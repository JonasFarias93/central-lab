# 🧠 central-lab

Laboratório pessoal de infraestrutura, automação e segurança operacional baseado em Linux, WSL2 e Docker.

---
![Logo do meu Projeto](/assets/img/central-lab.png)

## 🛡️ Infraestrutura Base (Concluído)

O servidor principal (`mega`) foi configurado com políticas de segurança inspiradas em ambientes corporativos.

### 🌐 Rede

- IP estático via Netplan (`/etc/netplan/`)
- Máscara `/24` para estabilidade e previsibilidade

### 🔐 SSH

- Autenticação exclusiva por chave pública/privada
- Senha desabilitada (`PasswordAuthentication no`)
- Porta customizada `2222` via systemd socket override

### 🔥 Firewall (UFW)

- Política padrão: `deny incoming / allow outgoing`
- Liberação explícita apenas da porta `2222/tcp`

### 🚫 Fail2ban

- Proteção contra brute force
- Monitoramento da porta SSH customizada
- Banimento automático de IPs suspeitos

---

## 🎛️ Controlador Central (`central.sh`)

Script principal de monitoramento e automação do laboratório, executado via WSL2.

### Comandos disponíveis

```bash
# Monitoramento
central status                                   # saúde geral do servidor

# Atualizações
central update                                   # atualiza servidor + containers
central update-server                            # atualiza apenas o Ubuntu
central update-containers                        # atualiza apenas imagens Docker

# Backup
central backup                                   # backup das configs críticas

# Gerenciamento de Projetos
central project-add <ambiente> <nome> <imagem>   # cria novo projeto/container
central project-remove <ambiente> <nome>         # remove projeto e container
central project-link <url> <ambiente>            # clona repo Git existente

# Gerenciamento de Serviços
central service start <ambiente> <nome>          # inicia container
central service stop <ambiente> <nome>           # para container
central service restart <ambiente> <nome>        # reinicia container
central service connect <container>              # acessa container interativamente
```

---

## 📊 `central status`

Exibe em tempo real via SSH:

- 🟢/🔴 Status de conectividade
- 💾 Espaço livre em disco
- 🧠 Memória RAM usada/total
- ⚙️ CPU em uso (%)
- 🛜 Conexões TCP ativas
- 🐳 Containers Docker ativos

---

## 🔄 `central update`

Executa em sequência:

1. `apt update && apt upgrade` no servidor
2. `docker pull` em todas as imagens existentes

Variantes:

```bash
central update-server       # só apt
central update-containers   # só docker
```

---

## 💾 `central backup`

Compacta configs críticas do servidor e salva localmente no WSL.

**Diretórios protegidos:**

```
/etc/ssh
/etc/netplan
/etc/ufw
```

**Formato:** `backups/YYYY-MM-DD.tar.gz`

**Rotação automática:** mantém os 5 backups mais recentes.

---

## 🐳 Gerenciamento de Projetos

### Criar novo projeto

```bash
central project-add study python python:3.12
central project-add dev api node:20
```

Cria a estrutura no servidor:

```
~/containers/<ambiente>/<nome>/
└── docker-compose.yml
```

### Vincular projeto existente (Git)

```bash
central project-link https://github.com/user/repo.git dev
```

Clona o repo em `~/projects/<nome>/` e registra o ambiente em `~/containers/<ambiente>/<nome>/`.

> ⚠️ O repositório deve conter um `docker-compose.yml` na raiz.

### Remover projeto

```bash
central project-remove study python
```

> ⚠️ Operações no ambiente `prod` exigem confirmação digitando `CONFIRMAR`.

### Acessar container

```bash
central service connect python-python-1
```

---

## 📁 Estrutura do Projeto

```
central-lab/
├── bin/
│   └── central.sh          # entry point e roteamento
├── modules/
│   ├── system.sh            # CPU, RAM, disco
│   ├── network.sh           # conexões de rede
│   ├── services.sh          # containers Docker
│   ├── backup.sh            # rotinas de backup
│   ├── update.sh            # rotinas de atualização
│   └── projects.sh          # gerenciamento de projetos
├── backups/                 # arquivos .tar.gz (ignorado pelo git)
├── .env                     # variáveis locais (ignorado pelo git)
├── .env.example             # template de configuração
└── README.md
```

### Estrutura no Servidor

```
~/projects/                  # repositórios Git
│   ├── central-lab/
│   └── <seus-projetos>/
│
~/containers/                # ambientes Docker
    ├── study/               # ambientes de estudo
    ├── dev/                 # projetos em desenvolvimento
    └── prod/                # serviços em produção (protegidos)
```

---

## ⚙️ Configuração

### Pré-requisitos

- WSL2 com Ubuntu
- Servidor Linux configurado com SSH
- Chaves SSH mapeadas em `~/.ssh/config`

### Setup

```bash
git clone https://github.com/JonasFarias93/central-lab.git
cd central-lab
cp .env.example .env
# editar .env com IP, porta e usuário do servidor
```

### Exemplo de `.env`

```bash
IP_MEGA="IP_DO_SERVIDOR"
PORTA_MEGA="PORTA_SSH"
USER_MEGA="USUARIO"
```

### Exemplo de `~/.ssh/config`

```
Host mega
    HostName IP_DO_SERVIDOR
    User USUARIO
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
```

---

## ⏳ Roadmap

| Milestone | Descrição | Status |
|-----------|-----------|--------|
| M3 | Setup do ambiente de desenvolvimento | ✅ |
| M4 | Comando `central status` completo | ✅ |
| M5 | Automação de rotinas (update/backup) | ✅ |
| M6 | Docker instalado e containers base | ✅ |
| M8 | Gerenciamento de projetos via central | ✅ |
| M7 | Cloudflare Tunnel | 🔒 aguarda domínio |
| M9 | Gerenciamento de energia dos containers | ⏳ |

---

## 📚 Tecnologias

- **SO:** Ubuntu Server + WSL2
- **Segurança:** UFW, Fail2ban, OpenSSH
- **Containers:** Docker, Docker Compose
- **Automação:** Bash, SSH
- **Versionamento:** Git, GitHub

---

## 🎯 Objetivos

- Consolidar laboratório pessoal de infraestrutura Linux
- Preparação para certificação LPI 101/102
- Praticar automação operacional e boas práticas DevOps
- Criar base para estudos de segurança ofensiva e defensiva