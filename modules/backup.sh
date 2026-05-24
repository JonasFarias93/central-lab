#!/usr/bin/env bash
# módulo: backup.sh

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