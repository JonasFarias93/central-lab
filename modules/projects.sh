#!/usr/bin/env bash
# módulo: projects.sh

project_add() {
    local AMBIENTE="$1"
    local NOME="$2"
    local IMAGEM="$3"


    if [ -z "$AMBIENTE" ] || [ -z "$NOME" ] || [ -z "$IMAGEM" ]; then
        echo "❌ Erro: Informar [ambiente] , [nome] e [imagem]. Ex: $0 project-add study python"
        return 1
    fi

    echo "=========================================="
    echo " [Central] Abertura de Projetos: mega "
    echo "=========================================="
    echo "⏳ Criando pasta em: ~/containers/$AMBIENTE/$NOME..."

    ssh -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "mkdir -p ~/containers/$AMBIENTE/$NOME"

    # cria temp local
    cat > /tmp/docker-compose.yml <<-EOF
	services:
	  $NOME:
	    image: $IMAGEM
	    stdin_open: true
	    tty: true
	EOF
    cat /tmp/docker-compose.yml
    scp -P "$PORTA_MEGA" /tmp/docker-compose.yml "${USER_MEGA}@${IP_MEGA}":~/containers/$AMBIENTE/$NOME/docker-compose.yml

    rm /tmp/docker-compose.yml

}


project_remove() {
    local AMBIENTE="$1"
    local NOME="$2"

    if [ -z "$AMBIENTE" ] || [ -z "$NOME" ]; then
        echo "❌ Erro: Informar [ambiente] e [nome]. Ex: $0 project-remove study python"
        return 1
    fi

    echo "=========================================="
    echo " [Central] Remoção de Projetos: mega "
    echo "=========================================="
    echo "⏳ Desligando Containers em: ~/containers/$AMBIENTE/$NOME..."
    echo "⏳ Removendo Pastas em: ~/containers/$AMBIENTE/$NOME..."

    ssh -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "[ -d ~/containers/$AMBIENTE/$NOME ]" || {
    echo "❌ Projeto não encontrado: $AMBIENTE/$NOME"
    return 1
}
    ssh -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "cd ~/containers/$AMBIENTE/$NOME && docker compose down"
    ssh -p "$PORTA_MEGA" "${USER_MEGA}@${IP_MEGA}" "rm -r ~/containers/$AMBIENTE/$NOME"

    echo "✅ Projeto Removido com Sucesso!!"

}