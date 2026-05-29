gerar_json() {
    DISCO=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "df -h / | awk 'NR==2 {print \$4 \" livres de \" \$2}'")
    RAM=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "free -h | awk 'NR==2 {print \$3 \" usados de \" \$2}'")
    CPU=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "idle=\$(vmstat 1 1 | tail -1 | awk '{print \$15}'); echo \$((100 - idle))")
    CONEXAO=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "total=\$(ss -tn state established | wc -l); echo \$((total - 1))")
    CONTAINERS=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "docker ps --format '{{.Names}}|{{.Status}}'")
    CONTAINERS_JSON=$(echo "$CONTAINERS" | awk -F'|' '{if(NR>1) printf ","; printf "{\"nome\":\"%s\",\"status\":\"%s\"}", $1, $2}' | sed 's/^/[/;s/$/]/')

    cat > /tmp/status.json << EOF
{
  "servidor": "online",
  "disco": "$DISCO",
  "ram": "$RAM",
  "cpu": "${CPU}%",
  "conexoes": $CONEXAO,
  "containers": $CONTAINERS_JSON,
  "atualizado": "$(date '+%d/%m/%Y %H:%M:%S')"
}
EOF
}