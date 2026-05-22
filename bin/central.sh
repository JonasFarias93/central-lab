#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../.env"

verificar_status() {
    echo "=========================================="
    echo " [Central] Status do Servidor: mega "
    echo "=========================================="

    # Validação rápida de porta usando Netcat
    if nc -z -w 2 "$IP_MEGA" "$PORTA_MEGA" > /dev/null 2>&1; then
        echo "🟢 Servidor: ONLINE (Tempo de Resposta Rápido)"
        echo "------------------------------------------"

        # Conecta via SSH, roda o comando 'df -h', filtra a linha da raiz '/' e exibe
        # O parâmetro '-q' silencia o banner do SSH
        DISCO=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "df -h / | awk 'NR==2 {print \$4 \" livres de \" \$2}'")

        # Conecta via SSH, roda o comando 'free -h', filtra a linha de Memória e exibe
        RAM=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "free -h | awk 'NR==2 {print \$3 \" usados de \" \$2}'")

        # Conecta via SSH, roda o comando 'idle', mostra CPU em uso
        CPU=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "idle=\$(vmstat 1 1 | tail -1 | awk '{print \$15}'); echo \$((100 - idle))")

        # Conecta via SSH, roda o comando 'ss', mostra quantidade de Conexoes Ativas
        CONEXAO=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "total=\$(ss -tn state established | wc -l); echo \$((total - 1))")

        echo "💾 Armazenamento (Root): $DISCO"
        echo "🧠 Memória RAM: $RAM"
        echo "⚙️ CPU em Uso: $CPU%"
        echo "🛜 Conexões Ativas: $CONEXAO"

    else
        echo "🔴 Servidor: OFFLINE ou inacessível na porta $PORTA_MEGA!"
    fi
    echo "=========================================="
}

case "$1" in
    status)
        verificar_status
        ;;
    *)
        echo "Uso: $0 {status}"
        exit 1
        ;;
esac
