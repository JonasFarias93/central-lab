# 🧠 central-lab

Laboratório pessoal de infraestrutura, automação e segurança operacional baseado em Linux, WSL2 e Docker.

---

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
central status                # saúde geral do servidor
central update                # atualiza servidor + containers
central update-server         # atualiza apenas o Ubuntu
central update-containers     # atualiza apenas imagens Docker
central backup                # backup das configs críticas
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

## 📁 Estrutura do Projeto

```
central-lab/
├── bin/
│   └── central.sh          # entry point
├── modules/
│   ├── system.sh            # CPU, RAM, disco
│   ├── network.sh           # conexões de rede
│   ├── services.sh          # containers Docker
│   ├── backup.sh            # rotinas de backup
│   ├── update.sh            # rotinas de atualização
│   └── projects.sh          # gerenciamento de projetos
├── containers/
│   └── study/
│       └── python/
│           └── docker-compose.yml
├── backups/                 # arquivos .tar.gz (ignorado pelo git)
├── .env                     # variáveis locais (ignorado pelo git)
├── .env.example             # template de configuração
└── README.md
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

---

## 🐳 Containers

### study-python

Ambiente isolado para estudo de Python.

```bash
cd containers/study/python
docker compose up -d
```

---

## ⏳ Roadmap

| Milestone | Descrição | Status |
|-----------|-----------|--------|
| M3 | Setup do ambiente de desenvolvimento | ✅ |
| M4 | Comando `central status` completo | ✅ |
| M5 | Automação de rotinas (update/backup) | ✅ |
| M6 | Docker instalado e containers base | ✅ |
| M7 | Cloudflare Tunnel | 🔒 aguarda domínio |
| M8 | Gerenciamento de projetos via central | ⏳ |
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