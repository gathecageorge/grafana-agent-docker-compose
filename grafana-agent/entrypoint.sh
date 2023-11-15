#!/bin/bash

WORK_DIR=$(dirname "$(readlink -f "${BASH_SOURCE}")")

# -----------------------------------------------------------------------------------------------------
# Start fresh every time
cp "$WORK_DIR/global.yml" "$WORK_DIR/agent.yml"

# -----------------------------------------------------------------------------------------------------
# Set metrics section
echo >> "$WORK_DIR/agent.yml" && cat "$WORK_DIR/prometheus.yml" >> "$WORK_DIR/agent.yml"
if [ -s "$WORK_DIR/prometheus-custom.yml" ]; then
  echo "$WORK_DIR/prometheus-custom.yml" | xargs sed 's/^/  /' >> "$WORK_DIR/agent.yml"
fi

# -----------------------------------------------------------------------------------------------------
# Set logs section
echo >> "$WORK_DIR/agent.yml" && cat "$WORK_DIR/promtail.yml" >> "$WORK_DIR/agent.yml"
if [ -s "$WORK_DIR/promtail-lokiurl.yml" ]; then
  echo >> "$WORK_DIR/agent.yml" && echo "$WORK_DIR/promtail-lokiurl.yml" | xargs sed 's/^/    /' >> "$WORK_DIR/agent.yml"
else
cat >> "$WORK_DIR/agent.yml" << EOF

    clients:
      - url: http://loki:3100/loki/api/v1/push
EOF
fi

# -----------------------------------------------------------------------------------------------------
# Set traces section
echo >> "$WORK_DIR/agent.yml" && cat "$WORK_DIR/traces.yml" >> "$WORK_DIR/agent.yml"

# -----------------------------------------------------------------------------------------------------
# Set intergrations section
echo >> "$WORK_DIR/agent.yml" && cat "$WORK_DIR/intergrations.yml" >> "$WORK_DIR/agent.yml"

# -----------------------------------------------------------------------------------------------------
sed -i "s/SERVER_LABEL_HOSTNAME/$SERVER_LABEL_HOSTNAME/" "$WORK_DIR/agent.yml"
exec "$@" --config.file=$WORK_DIR/agent.yml --metrics.wal-directory=/etc/agent/data