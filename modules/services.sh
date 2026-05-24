#!/usr/bin/env bash
# módulo: services.sh


service_start(){
    local AMBIENTE="$1"
    local NOME="$2"

    if [ -z "$AMBIENTE" ] || [ -z "$NOME" ]; then
        echo "❌ Erro: Informar [ambiente] e [nome]. Ex: $0 service start study python"
        return 1
    fi
    
    echo "=========================================="
    echo " [Central] Gerenciamento de Serviços: mega "
    echo "=========================================="
    echo "⏳ Iniciando Container em: ~/containers/$AMBIENTE/$NOME..."

    ssh -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "cd ~/containers/$AMBIENTE/$NOME && docker compose up -d"
    echo "✅ Serviço Iniciado com Sucesso!!"

}

service_stop(){
    local AMBIENTE="$1"
    local NOME="$2"

    if [ -z "$AMBIENTE" ] || [ -z "$NOME" ]; then
        echo "❌ Erro: Informar [ambiente] e [nome]. Ex: $0 service stop study python"
        return 1
    fi

    echo "=========================================="
    echo " [Central] Gerenciamento de Serviços: mega "
    echo "=========================================="
    echo "⏳ Parando Container em: ~/containers/$AMBIENTE/$NOME..."

    ssh -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "cd ~/containers/$AMBIENTE/$NOME && docker compose stop"
    echo "✅ Serviço Parado com Sucesso!!"

}

service_restart(){
    local AMBIENTE="$1"
    local NOME="$2"

    if [ -z "$AMBIENTE" ] || [ -z "$NOME" ]; then
        echo "❌ Erro: Informar [ambiente] e [nome]. Ex: $0 service restart study python"
        return 1
    fi
    
    echo "=========================================="
    echo " [Central] Gerenciamento de Serviços: mega "
    echo "=========================================="
    echo "⏳ Reiniciando Container em: ~/containers/$AMBIENTE/$NOME..."

    ssh -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "cd ~/containers/$AMBIENTE/$NOME && docker compose restart"
    echo "✅ Serviço Reiniciado com Sucesso!!"

}