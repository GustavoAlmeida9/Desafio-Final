# CRUD App - Sistema de Gerenciamento de Clientes e Produtos

Sistema completo de CRUD (Create, Read, Update, Delete) desenvolvido com Flutter para o frontend e Node.js/Express para o backend, utilizando MySQL como banco de dados.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Pré-requisitos](#pré-requisitos)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Instalação e Configuração](#instalação-e-configuração)
- [Executando o Projeto](#executando-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Estrutura de Dados](#estrutura-de-dados)
- [Troubleshooting](#troubleshooting)

## 🎯 Sobre o Projeto

Este projeto é um sistema de gerenciamento completo que permite realizar operações CRUD em duas entidades principais:

- **Clientes**: Gerenciamento completo de cadastros de clientes
- **Produtos**: Gerenciamento de catálogo de produtos

O sistema possui uma interface moderna e intuitiva, com navegação lateral, validações de formulário e feedback visual para todas as operações.

## 🛠 Tecnologias Utilizadas

### Frontend
- **Flutter** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **Material Design 3** - Design system
- **HTTP** - Comunicação com API
- **Image Picker** - Seleção de imagens

### Backend
- **Node.js** - Runtime JavaScript
- **Express** - Framework web
- **MySQL2** - Driver MySQL
- **CORS** - Controle de acesso
- **dotenv** - Gerenciamento de variáveis de ambiente

### Banco de Dados
- **MySQL** - Banco de dados relacional

## 📦 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

1. **Flutter SDK** (versão 3.1.0 ou superior)
   - [Guia de instalação do Flutter](https://docs.flutter.dev/get-started/install)

2. **Node.js** (versão 14 ou superior)
   - [Download Node.js](https://nodejs.org/)

3. **MySQL** (versão 5.7 ou superior)
   - [Download MySQL](https://dev.mysql.com/downloads/mysql/)

4. **Git** (opcional, para clonar o repositório)
   - [Download Git](https://git-scm.com/)

5. **Editor de código** (recomendado: VS Code ou Android Studio)

## 📁 Estrutura do Projeto

```
Trabalho final dev mobile 2/
│
├── flutter_crud_app/          # Aplicação Flutter (Frontend)
│   ├── lib/
│   │   ├── main.dart          # Ponto de entrada
│   │   ├── models/            # Modelos de dados
│   │   │   ├── cliente.dart
│   │   │   └── produto.dart
│   │   ├── screens/           # Telas da aplicação
│   │   │   ├── home_screen.dart
│   │   │   ├── clientes_screen.dart
│   │   │   ├── cliente_form_screen.dart
│   │   │   ├── produtos_screen.dart
│   │   │   └── produto_form_screen.dart
│   │   ├── services/          # Serviços de API
│   │   │   └── api_service.dart
│   │   └── widgets/           # Componentes reutilizáveis
│   │       ├── custom_appbar.dart
│   │       ├── custom_button.dart
│   │       ├── custom_card.dart
│   │       ├── cliente_card.dart
│   │       └── navigation_drawer.dart
│   ├── assets/                # Recursos (imagens, fontes)
│   └── pubspec.yaml           # Dependências Flutter
│
└── flutter_crud_backend/      # API Node.js (Backend)
    ├── index.js               # Servidor Express
    ├── database.sql           # Script de criação do banco
    ├── package.json           # Dependências Node.js
    └── .env                   # Variáveis de ambiente (criar)
```

## ⚙️ Instalação e Configuração

### 1. Configuração do Banco de Dados

1. **Crie o banco de dados MySQL:**
   ```sql
   CREATE DATABASE crud_app;
   ```

2. **Execute o script SQL:**
   - Abra o MySQL Workbench ou cliente MySQL
   - Execute o arquivo `flutter_crud_backend/database.sql`
   - Ou copie e cole o conteúdo do arquivo no seu cliente MySQL

### 2. Configuração do Backend

1. **Navegue até a pasta do backend:**
   ```bash
   cd flutter_crud_backend
   ```

2. **Instale as dependências:**
   ```bash
   npm install
   ```

3. **Crie o arquivo `.env` na pasta `flutter_crud_backend`:**
   ```env
   DB_HOST=localhost
   DB_USER=root
   DB_PASS=sua_senha_mysql
   DB_NAME=crud_app
   PORT=3000
   ```
   
   ⚠️ **Importante:** Substitua `sua_senha_mysql` pela sua senha do MySQL.

### 3. Configuração do Frontend

1. **Navegue até a pasta do app Flutter:**
   ```bash
   cd flutter_crud_app
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Verifique se o Flutter está configurado corretamente:**
   ```bash
   flutter doctor
   ```

## 🚀 Executando o Projeto

### Passo 1: Iniciar o Backend

1. **Abra um terminal na pasta `flutter_crud_backend`:**
   ```bash
   cd flutter_crud_backend
   ```

2. **Inicie o servidor:**
   ```bash
   npm start
   ```

3. **Você deve ver a mensagem:**
   ```
   Banco de dados conectado!
   Servidor rodando na porta 3000
   ```

   ✅ Se aparecer essa mensagem, o backend está funcionando!

### Passo 2: Iniciar o Frontend

1. **Abra um novo terminal na pasta `flutter_crud_app`:**

2. **Verifique os dispositivos disponíveis:**
   ```bash
   flutter devices
   ```

3. **Execute o app:**
   
   **Para Android Emulator:**
   ```bash
   flutter run
   ```
   
   **Para iOS Simulator (apenas macOS):**
   ```bash
   flutter run
   ```
   
   **Para dispositivo físico:**
   - Conecte seu dispositivo via USB
   - Ative o modo desenvolvedor e depuração USB
   - Execute: `flutter run`

### Passo 3: Configuração de URL da API

O app está configurado para usar automaticamente:
- **Android Emulator:** `http://10.0.2.2:3000`
- **iOS Simulator:** `http://localhost:3000`
- **Dispositivo físico:** Você precisará alterar para o IP da sua máquina

**Para usar em dispositivo físico:**

1. Descubra o IP da sua máquina:
   - **Windows:** `ipconfig` (procure por IPv4)
   - **macOS/Linux:** `ifconfig` ou `ip addr`

2. Edite o arquivo `lib/services/api_service.dart`:
   ```dart
   static String get baseUrl {
     if (Platform.isAndroid) {
       return 'http://SEU_IP_AQUI:3000';  // Ex: http://192.168.1.100:3000
     }
     // ...
   }
   ```

## ✨ Funcionalidades

### Clientes
- ✅ **Listar** todos os clientes cadastrados
- ✅ **Criar** novo cliente com foto, nome, sobrenome, email e idade
- ✅ **Editar** informações de clientes existentes
- ✅ **Excluir** clientes com confirmação
- ✅ **Selecionar foto** da galeria
- ✅ **Validação** de email e campos obrigatórios

### Produtos
- ✅ **Listar** todos os produtos cadastrados
- ✅ **Criar** novo produto com nome, descrição e preço
- ✅ **Editar** produtos existentes
- ✅ **Excluir** produtos com confirmação
- ✅ **Data de atualização** automática
- ✅ **Validação** de preço e campos obrigatórios

### Interface
- ✅ **Menu lateral** para navegação rápida
- ✅ **Design moderno** com gradientes e cores vibrantes
- ✅ **Pull-to-refresh** nas listagens
- ✅ **Feedback visual** para todas as operações
- ✅ **Tratamento de erros** com mensagens amigáveis
- ✅ **Estados vazios** informativos

## 📊 Estrutura de Dados

### Tabela: clientes
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | INT | Chave primária (auto-incremento) |
| nome | VARCHAR(100) | Nome do cliente |
| sobrenome | VARCHAR(100) | Sobrenome do cliente |
| email | VARCHAR(100) | Email do cliente |
| idade | INT | Idade do cliente |
| foto | VARCHAR(255) | URL ou caminho da foto (opcional) |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Data de atualização |

### Tabela: produtos
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | INT | Chave primária (auto-incremento) |
| nome | VARCHAR(100) | Nome do produto |
| descricao | TEXT | Descrição do produto |
| preco | DECIMAL(10,2) | Preço do produto |
| data_atualizado | DATETIME | Data da última atualização |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Data de atualização |

## 🔧 Troubleshooting

### Problema: Backend não conecta ao banco de dados

**Solução:**
1. Verifique se o MySQL está rodando
2. Confirme as credenciais no arquivo `.env`
3. Verifique se o banco de dados `crud_app` foi criado
4. Teste a conexão manualmente no MySQL Workbench

### Problema: App não consegue conectar ao backend

**Solução:**
1. Verifique se o backend está rodando na porta 3000
2. Para Android Emulator, use `http://10.0.2.2:3000`
3. Para dispositivo físico, use o IP da sua máquina
4. Verifique se o firewall não está bloqueando a porta 3000

### Problema: Erro ao cadastrar produto

**Solução:**
- O problema foi corrigido na versão atual
- Certifique-se de usar a versão mais recente do código
- O preço agora aceita tanto números quanto strings

### Problema: Overflow no menu lateral

**Solução:**
- O problema foi corrigido na versão atual
- O drawer foi ajustado para evitar overflow

### Problema: Flutter não encontra dispositivos

**Solução:**
1. Execute `flutter doctor` para verificar problemas
2. Para Android: Abra o Android Studio e crie um AVD
3. Para iOS: Certifique-se de ter o Xcode instalado (apenas macOS)
4. Para dispositivo físico: Ative o modo desenvolvedor

### Problema: Dependências não instalam

**Solução:**
1. Backend: Delete `node_modules` e `package-lock.json`, depois `npm install`
2. Frontend: Execute `flutter clean` e depois `flutter pub get`

## 📱 Telas do Sistema

### Tela Inicial (Home)
- Menu de navegação com opções para Clientes e Produtos
- Design moderno com cards interativos

### Tela de Clientes
- Lista de todos os clientes cadastrados
- Botão flutuante para adicionar novo cliente
- Cards com foto, nome completo, email e idade
- Toque no card para editar
- Botão de exclusão em cada card

### Tela de Produtos
- Lista de todos os produtos cadastrados
- Botão flutuante para adicionar novo produto
- Cards com nome, descrição, preço e data de atualização
- Toque no card para editar
- Botão de exclusão em cada card

### Formulários
- Validação em tempo real
- Campos obrigatórios marcados
- Feedback visual de sucesso/erro
- Botão de voltar funcional

## 📝 Notas Importantes

- ⚠️ O backend deve estar rodando antes de iniciar o app Flutter
- ⚠️ Certifique-se de que o banco de dados está criado e as tabelas foram executadas
- ⚠️ Para produção, configure variáveis de ambiente adequadas
- ⚠️ O upload de fotos atualmente salva apenas a URL - para produção, implemente upload de arquivos

## 👨‍💻 Desenvolvido por

Sistema desenvolvido como trabalho final de Desenvolvimento Mobile 2.

## 📄 Licença

Este projeto é de uso educacional.

---

**Dúvidas ou problemas?** Verifique a seção [Troubleshooting](#troubleshooting) ou consulte a documentação oficial do Flutter e Node.js.

