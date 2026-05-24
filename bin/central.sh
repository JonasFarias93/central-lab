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

        # Conecta via SSH, roda o comando 'docker ps', mostra os containers ativos
        CONTAINERS=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "docker ps --format 'table {{.Names}}\t{{.Status}}'")

        echo "💾 Armazenamento (Root): $DISCO"
        echo "🧠 Memória RAM: $RAM"
        echo "⚙️ CPU em Uso: $CPU%"
        echo "🛜 Conexões Ativas: $CONEXAO"
        echo "🐳 Containers Ativos:"
        echo "$CONTAINERS" | tail -n +2 | sed 's/^/   /'

    else
        echo "🔴 Servidor: OFFLINE ou inacessível na porta $PORTA_MEGA!"
    fi
    echo "=========================================="
}


atualizar_servidor() {
    echo "=========================================="
    echo " [Central] Atualização do Servidor: mega "
    echo "=========================================="
    echo "⏳ Atualizando..."


    UPDATE_SERVER=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "DEBIAN_FRONTEND=noninteractive sudo apt update -qq 2>/dev/null && DEBIAN_FRONTEND=noninteractive sudo apt upgrade -qq -y 2>/dev/null")

    echo "✅ Servidor Atualizado"
    echo "=========================================="

}

atualizar_containers() {
    echo "=========================================="
    echo " [Central] Atualização dos Containers: mega "
    echo "=========================================="
    echo "⏳ Atualizando..."

    UPDATE_CONTAINERS=$(ssh -q -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "docker images --format '{{.Repository}}:{{.Tag}}' | xargs -I {} docker pull {}")

    echo "✅ Containers Atualizado"
    echo "=========================================="
}

atualizar_tudo() {
    atualizar_servidor
    atualizar_containers
}

fazer_backup(){
    echo "=========================================="
    echo " [Central] De Backup: mega "
    echo "=========================================="
    echo "⏳ Fazendo backup..."
    mkdir -p ~/projects/central-lab/backups
    ssh -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "sudo tar -czf - /etc/ssh /etc/netplan /etc/ufw" > ~/projects/central-lab/backups/$(date +%F).tar.gz
    ls -t ~/projects/central-lab/backups/*.tar.gz | tail -n +6 | xargs rm -f
    echo "✅ Backup concluído"
    echo "=========================================="
}

case "$1" in
    status)
        verificar_status
        ;;
    update)
        atualizar_tudo
        ;;
    update-server)
        atualizar_servidor
        ;;
    update-containers)
        atualizar_containers
        ;;
    backup)
        fazer_backup
        ;;
    *)
    

        echo "Uso: $0 {status|update|update-server|update-containers}"
        exit 1
        ;;
esac