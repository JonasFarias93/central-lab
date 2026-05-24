#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../.env"


# Importa módulos
source "$SCRIPT_DIR/../modules/system.sh"
source "$SCRIPT_DIR/../modules/network.sh"
source "$SCRIPT_DIR/../modules/services.sh"
source "$SCRIPT_DIR/../modules/backup.sh"
source "$SCRIPT_DIR/../modules/update.sh"
source "$SCRIPT_DIR/../modules/projects.sh"


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