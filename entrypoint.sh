#!/bin/bash

# -----------------------------------------------------------------------------------------------------
# Start fresh every time
cp "/agent-global-config.yml" "/agent.yml"

# -----------------------------------------------------------------------------------------------------
# Set metrics section
echo >> "/agent.yml" && cat "/agent-prometheus-config.yml" >> "/agent.yml"
if [ -s "/custom-prom.yml" ]; then
  echo "/custom-prom.yml" | xargs sed 's/^/  /' >> "/agent.yml"
fi

# -----------------------------------------------------------------------------------------------------
# Set logs section
echo >> "/agent.yml" && cat "/agent-promtail-config.yml" >> "/agent.yml"
if [ -s "/custom-lokiurl.yml" ]; then
  echo "/custom-lokiurl.yml" | xargs sed 's/^/      /' >> "/agent.yml"
else
cat >> "/agent.yml" << EOF
      - url: http://loki:3100/loki/api/v1/push
EOF
fi

# -----------------------------------------------------------------------------------------------------
# Set traces section
echo >> "/agent.yml" && cat "/agent-traces-config.yml" >> "/agent.yml"

# -----------------------------------------------------------------------------------------------------
# Set intergrations section
echo >> "/agent.yml" && cat "/agent-intergrations-config.yml" >> "/agent.yml"

# -----------------------------------------------------------------------------------------------------
sed -i "s/SERVER_LABEL_HOSTNAME/$SERVER_LABEL_HOSTNAME/" "/agent.yml"
exec "$@" --config.file=/agent.yml --metrics.wal-directory=/etc/agent/data