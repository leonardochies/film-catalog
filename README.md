<div align="center">
  <h1>Catálogo de Filmes</h1>
  <p>
    <strong>Sistema completo de catálogo de filmes com CRUD completo de filmes e comentários, autenticação, e importação em massa via CSV<strong>
  </p>
  
  ![Ruby](https://img.shields.io/badge/Ruby-3.4.2-red?logo=ruby)
  ![Rails](https://img.shields.io/badge/Rails-8.0.3-red?logo=rubyonrails)
  ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue?logo=postgresql)
  ![Sidekiq](https://img.shields.io/badge/Sidekiq-Background_Jobs-red?logo=ruby)
</div>

  <h3>
    <a href="https://film-catalog-j1iz.onrender.com" target="_blank">🌐 Ver Demo Online</a>
  </h3>

---

## Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e Configuração](#instalaçãoconfiguração)
- [Como Rodar o Projeto](#como-rodar-o-projeto)
- [Importação em Massa (CSV)](#importação-em-massa-csv)
- [Executando os Testes](#testes)
- [Estrutura do Projeto](#-estrutura-do-projeto)

---

## Sobre o Projeto

Primeiramente, obrigado ao pessoal da Mainô pela oportunidade! O projeto foi desenvolvido como parte do processo seletivo e aprendi bastante com ele focando no Rails Way; boas práticas de desenvolvimento, a arquitetura MVC, testes automatizados e o processamento assíncrono com Sidekiq e Redis pro super diferencial.

Eu torço para que este projeto possa mostrar meu potencial e, pra isso, sintam-se a vontade para me contatar através do meu e-mail ou LinkedIn!

---

### Funcionalidades

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
  - Busca por título, diretor e ano
  - Busca combinando texto e ano (ex: 'Martin Scorsese 1976' -> Taxi Driver)
  - Implementado com a gem 'Ransack'

- ✅ **Paginação**
  - Lista de filmes paginada (usando a gem Kaminari)

### Funcionalidades Opcionais Implementadas

- ✅ **Importação em Massa via CSV**

- ✅ **Categorização de Filmes**

- ✅ **Interface Responsiva**

- ✅ **Internacionalização (i18n)**

- ✅ **Testes Automatizados**

---

## Pré-requisitos

Antes de começar, por favor verifiquem se estão instalados em sua máquina:

- **Ruby** 3.4.2 ou superior
- **Rails** 8.0.3 ou superior
- **PostgreSQL** 14 ou superior
- **Redis** 6 ou superior (pro Sidekiq)
- **Node.js** 18 ou superior (pros assets)

---

## Instalação/Configuração

### 1. Clone o repositório

```bash
git clone https://github.com/leonardochies/film-catalog.git
cd film-catalog
```

### 2. Instale as dependências Ruby

```bash
bundle install
```

### 3. Instale o Redis (Para rodar os jobs do Sidekiq em background)

**Linux (Ubuntu/Debian/WSL):**
```bash
sudo apt-get update
sudo apt-get install redis-server
```

**macOS:**
```bash
brew install redis
```

Verifique se o Redis foi instalado corretamente:
```bash
redis-cli ping
# Deve retornar 'PONG'
```

Se não estiver rodando, execute o Redis:
```bash
redis-server
```
### 4. Configure o banco de dados

O PostgreSQL deve estar rodando:

```bash
sudo service postgresql start  # para Linux/WSL
# ou
brew services start postgresql  # para macOS
```

Crie e configure o banco de dados:

```bash
rails db:create
rails db:migrate
rails db:seed  # Gera as categorias através das seeds
```

### 5. Configure o Active Storage

O Active Storage é necessário pro uso dos cartazes de filmes e para a importação CSV:

```bash
rails active_storage:install
rails db:migrate
```

---

## Como Rodar o Projeto

**🔗 Acesse o app em prod no Render:** [https://film-catalog-j1iz.onrender.com](https://film-catalog-j1iz.onrender.com)

Incluí `Procfile.dev` que inicia todos os serviços necessários:

```bash
bin/dev
```

Isso iniciará o Rails Server na porta 3000, o Sidekiq e o Dartsass pra buildar o CSS.


### Opção 2: Rodar os serviços separadamente

**Terminal 1 - Rails Server:**
```bash
bin/dev
```

**Terminal 2 - Sidekiq:**
```bash
bundle exec sidekiq
```

**Terminal 3 - Redis: (só é necessário se ele não estiver executando automaticamente)**
```bash
redis-server
```

### Acessando o app

Abra seu navegador e acesse:
```
http://localhost:3000
```

Ao rodar localmente optei por desabilitar o envio de emails por conta de estar usando uma conta free do Sidegrid, mas podem verificar os emails mesmo assim através do LetterOpener (em Prod/Deploy a funcionalidade de emails funciona normalmente):
```
http://localhost:3000/letter_opener
```

---

## Importação em Massa (CSV)

1. Faça login
2. Na página de filmes, clique no botão **"Importar CSV"**
3. Faça upload do arquivo CSV
4. O processamento será feito em background via Sidekiq
5. Você receberá um email quando a importação for concluída (ou se houver erro)

### Formato esperado do CSV

A funcionalidade implementada do CSV só aceita uma categoria por filme atualmente e também recomendo envolver textos entre aspas para evitar que vírgulas quebrem o formato do CSV, que é assim:

```csv
category,title,synopsis,release_year,duration,director
fantasy,"O Senhor dos Anéis: A Sociedade do Anel","Em uma terra fantástica e única, um hobbit recebe de presente de seu tio um anel mágico e maligno que precisa ser destruído antes que caia nas mãos do mal",2002,178,Peter Jackson
```

### Acompanhando a importação

- É possível acompanhar a importação pelo própria página de importações após inserir um arquivo e iniciar a importação, mas também pelo dashboard do Sidekiq:
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
