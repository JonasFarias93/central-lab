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
source "$SCRIPT_DIR/../modules/status-web.sh"


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
    project-add)
        project_add "$2" "$3" "$4"
        ;;
    project-remove)
        project_remove "$2" "$3"
        ;;
    project-link)
        project_link "$2" "$3"
    ;;
    service)
        case "$2" in
            start)   service_start "$3" "$4" ;;
            stop)    service_stop "$3" "$4" ;;
            restart) service_restart "$3" "$4" ;;
            connect) service_connect "$3" ;;

            *)
                echo "Uso: $0 service {start|stop|restart|connect} <ambiente> <nome>"
                exit 1
                ;;
        esac
        ;;
    status-web)
        gerar_json
    ;;
    *)
    
        echo "Uso: $0 {status|update|update-server|update-containers|project-add|project-link|project-remove [ambiente] [nome]}"
        exit 1
        ;;
esac