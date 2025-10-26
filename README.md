<div align="center">
  <h1>Film Catalog</h1>
  <p>
    <strong>Sistema completo de catálogo de filmes com CRUD completo de filmes e comentários, autenticação, e importação em massa via CSV<strong>
  </p>
  
  ![Ruby](https://img.shields.io/badge/Ruby-3.4.2-red?logo=ruby)
  ![Rails](https://img.shields.io/badge/Rails-8.0.3-red?logo=rubyonrails)
  ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue?logo=postgresql)
  ![Sidekiq](https://img.shields.io/badge/Sidekiq-Background_Jobs-red?logo=ruby)
</div>

---

## Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Funcionalidades](#-funcionalidades)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação e Configuração](#-instalação-e-configuração)
- [Como Rodar o Projeto](#-como-rodar-o-projeto)
- [Importação em Massa (CSV)](#-importação-em-massa-csv)
- [Executando os Testes](#-executando-os-testes)
- [Estrutura do Projeto](#-estrutura-do-projeto)

---

## Sobre o Projeto

Primeiramente, obrigado ao pessoal da Mainô pela oportunidade! O projeto foi desenvolvido como parte do processo seletivo e aprendi bastante com ele, tentei demostrar o meu potencial ao máximo com o 'Rails Way', boas práticas de desenvolvimento, a arquitetura MVC, testes automatizados e o processamento assíncrono com Sidekiq e Redis pro super diferencial.

Torço para que este projeto possa mostrar meu potencial e, para isso, sintam-se a vontade para me contatar através do meu e-mail ou LinkedIn!

---

## Funcionalidades

### Funcionalidades Principais

- ✅ **Autenticação de Usuários** (usando a gem do Devise)
  - Registro e login
  - Recuperação de senha
  - Proteção de rotas
  
- ✅ **CRUD Completo de Filmes**
  - Criar, visualizar, editar e deletar filmes
  - Upload de poster do filme (Active Storage)
  - Validações de formulário
  - Associação de múltiplas categorias

- ✅ **Sistema de Comentários**
  - Comentários aninhados em filmes
  - Apenas usuários autenticados podem comentar

- ✅ **Busca e Filtros**
  - Busca por título e diretor
  - Busca combinando texto e ano (ex: 'Martin Scorsese 1976' -> Taxi Driver)
  - Implementado com Ransack

- ✅ **Paginação**
  - Lista de filmes paginada (usando a gem Kaminari)
  - Interface limpa e responsiva

### Funcionalidades Opcionais Implementadas

- ✅ **Importação em Massa via CSV**
  - Upload de arquivo CSV
  - Processamento assíncrono com Sidekiq
  - Notificação por email ao concluir

- ✅ **Categorização de Filmes**
  - Múltiplas categorias por filme

- ✅ **Interface Responsiva**
  - Bootstrap 5
  - Compatível e responsivo com mobile

- ✅ **Internacionalização (i18n)**
  - Suporte a Português (pt-BR, padrão) e Inglês (en)

- ✅ **Testes Automatizados**
  - RSpec
  - Factory Bot
  - Testes de models, controllers e requests

---

## Tecnologias Utilizadas

### Backend
- **Ruby** 3.4.2
- **Rails** 8.0.3
- **PostgreSQL** - Banco de dados relacional
- **Sidekiq** - Processamento assíncrono de jobs
- **Redis** - Backend para Sidekiq

### Frontend
- **Bootstrap** 5.3.3 - Framework CSS
- **Hotwire** (Turbo + Stimulus) - SPA-like experience
- **Sass** - Pré-processador CSS

### Gems Principais
- **Devise** - Autenticação
- **Ransack** - Busca e filtros
- **Kaminari** - Paginação
- **Active Storage** - Upload de arquivos
- **RSpec** - Testes
- **Factory Bot** - Fixtures para testes

---

## Pré-requisitos

Antes de começar, por favor verifiquem se estão instalados em sua máquina:

- **Ruby** 3.4.2 ou superior
- **Rails** 8.0.3 ou superior
- **PostgreSQL** 14 ou superior
- **Redis** 6 ou superior (pro Sidekiq)
- **Node.js** 18 ou superior (pros assets)

---

## ⚙️ Instalação e Configuração

### 1. Clone o repositório

```bash
git clone https://github.com/leonardochies/film-catalog.git
cd film-catalog
```

### 2. Instale as dependências Ruby

```bash
bundle install
```

### 3. Configure o banco de dados

O PostgreSQL deve estar rodando:

```bash
sudo service postgresql start  # Linux
# ou
brew services start postgresql  # macOS
```

Crie e configure o banco de dados:

```bash
rails db:create
rails db:migrate
rails db:seed  # Gera as categorias das seeds
```

### 4. Configure o Active Storage

O Active Storage é necessário pro uso dos cartazes de filmes e para a importação CSV:

```bash
rails active_storage:install
rails db:migrate
```

---

## Como Rodar o Projeto

### Opção 1: Rodar todos os serviços de uma vez (Recomendado)

O projeto inclui um `Procfile.dev` que inicia todos os serviços necessários:

```bash
bin/dev
```

Isso iniciará:
- **Rails server** (porta 3000)
- **Sidekiq** (processamento de jobs)
- **CSS build** (Sass watch mode)

### Opção 2: Rodar os serviços separadamente

**Terminal 1 - Rails Server:**
```bash
bin/dev
```

**Terminal 2 - Sidekiq:**
```bash
bundle exec sidekiq
```

### Acessando a aplicação

Abra seu navegador e acesse:
```
http://localhost:3000
```

---

## Para a Importação em Massa (CSV)

1. Faça login
2. Na página de filmes, clique no botão **"Importar CSV"**
3. Faça upload do arquivo CSV
4. O processamento será feito em background via Sidekiq
5. Você receberá um email quando a importação for concluída (ou se houver erro)

### Formato esperado do CSV

O arquivo CSV deve seguir este formato:

```csv
title,synopsis,release_year,duration,director,categories
"The Matrix","A hacker discovers the truth about his reality and his role in the war against its controllers.",1999,136,"Wachowski Brothers","Action, Sci-Fi"
"The Godfather","The aging patriarch of an organized crime dynasty transfers control to his reluctant son.",1972,175,"Francis Ford Coppola","Crime, Drama"
"Inception","A thief who steals corporate secrets through dream-sharing technology.",2010,148,"Christopher Nolan","Action, Sci-Fi, Thriller"
```
### Exemplo de arquivo CSV completo

Baixe um arquivo de exemplo aqui: [movies_example.csv](spec/fixtures/files/movies.csv)

### Acompanhando a importação

**Via Interface:**
- Acompanhe o status na página de importações

**Via Sidekiq Dashboard:**
```
http://localhost:3000/sidekiq
```
---

## Testes

### Rodar todos os testes (cobrem Models, Controllers e Requests)

```bash
bundle exec rspec
```

---

## 📁 Estrutura do Projeto

```
film_catalog/
├── app/
│   ├── controllers/      # Controladores (Movies, Comments, ImportJobs)
│   ├── models/           # Models (Movie, User, Category, Comment, ImportJob)
│   ├── views/            # Views (ERB templates)
│   ├── workers/          # Sidekiq workers (ImportCsvWorker)
│   ├── mailers/          # Mailers (ImportMailer)
│   ├── helpers/          # Helpers
│   └── assets/           # CSS, JS, imagens
├── config/               # Configurações Rails
│   ├── routes.rb         # Rotas da aplicação
│   ├── database.yml      # Configuração do banco
│   └── locales/          # Traduções (i18n)
├── db/
│   ├── migrate/          # Migrations
│   └── seeds.rb          # Dados iniciais
├── spec/                 # Testes RSpec
│   ├── models/
│   ├── requests/
│   ├── factories/        # Factory Bot
│   └── fixtures/
└── README.md
```
