#!/usr/bin/env bash
# módulo: backup.sh

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