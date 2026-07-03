# Spec: Cadastro e Autenticação de Usuários via API (JWT)

Este documento especifica as regras de negócio, fluxos de API, critérios de aceitação e contratos técnicos para a funcionalidade de gerenciamento de identidade e autenticação usando JSON Web Tokens (JWT) no Rails 8.

---

## 1. Requisitos Funcionais: Histórias de Cadastro de Usuário & Critérios de Aceitação

### Cenário 1: Cadastro de novo usuário com sucesso
* **Dado que** o email `"user@user.com"` ainda não está cadastrado no sistema.
* **Quando** uma requisição HTTP POST for enviada para `/api/cadastrar` contendo o seguinte payload:
```json
{
  "user": {
    "email": "user@user.com",
    "password": "SenhaSegura123"
  }
}
```
* **Então** o sistema deve criar um novo registro na tabela users com o password criptografado com hash seguro, o status da resposta HTTP deve ser `201 Created` e o corpo da resposta deve retornar vazio.

### Cenário 2: Falha no cadastro por e-mail duplicado
* **Dado que** o email `"user@user.com"` já existe na tabela users.
* **Quando** uma requisição HTTP POST for enviada para `/api/cadastrar` com os mesmos dados.
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Email has already been taken"]
}
```

### Cenário 3: Falha no cadastro por enviar email em branco
* **Quando** uma requisição HTTP POST for enviada para `/api/cadastrar` contendo no campo `"email"` uma string vazia, por exemplo:
```json
{
  "user": {
    "email": "",
    "password": "SenhaSegura123"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Email can't be blank"]
}
```

### Cenário 4: Falha no cadastro por enviar email inválido
* **Quando** uma requisição HTTP POST for enviada para `/api/cadastrar` contendo no campo `"email"` uma string que não está no formato válido de email, por exemplo:
```json
{
  "user": {
    "email": "invalido_email",
    "password": "SenhaSegura123"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Email is invalid"]
}
```

### Cenário 5: Falha no cadastro por enviar password em branco
* **Quando** uma requisição HTTP POST for enviada para `/api/cadastrar` contendo no campo `"password"` uma string vazia, por exemplo:
```json
{
  "user": {
    "email": "user@email.valido.com",
    "password": ""
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Password can't be blank"]
}
```

### Cenário 6: Falha no cadastro por enviar password inválido
* **Quando** uma requisição HTTP POST for enviada para `/api/cadastrar` contendo no campo `"password"` uma string de tamanho menor que 8 chars, por exemplo:
```json
{
  "user": {
    "email": "user@email.valido.com",
    "password": "123"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Password is too short (minimum is 8 characters)"]
}
```

## 2. Requisitos Funcionais: Histórias de Autenticação de Usuário & Critérios de Aceitação

### Cenário 1: Autenticando usuário com sucesso
* **Dado que** o usuário `"user@cadastrado.com"` está devidamente cadastrado com a senha `"SenhaCadastrada321`.
* **Quando** uma requisição HTTP POST for enviada para `/api/login` contendo o seguinte payload:
```json
{
  "email": "user@cadastrado.com",
  "password": "SenhaCadastrada321"
}
```
* **Então** o sistema deve autenticar com sucesso as credenciais fornecidas, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar o token de acesso gerado e suas informações de expiração:
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3ODMzMDcyMTl9...",
  "exp": "2026-07-03T11:28:18-03:00",
  "email": "user@cadastrado.com"
}
```

### Cenário 2: Falha na autenticação por credenciais incorretas

* **Quando** uma requisição HTTP POST for enviada para `/api/login` com uma senha maior que 8 chars incorreta ou um email em formato válido, porém não cadastrado.
* **Então** o sistema deve recusar a autenticação imediatamente, o status da resposta HTTP deve ser `401 Unauthorized` e o corpo da resposta deve retornar vazio.

### Cenário 3: Falha na autenticação por credenciais em formato inválido

* **Quando** uma requisição HTTP POST for enviada para `/api/login` com uma senha menor que 8 chars ou uma string de email inválido.
* **Então** o sistema deve recusar a autenticação imediatamente, o status da resposta HTTP deve ser `401 Unauthorized` e o corpo da resposta deve retornar vazio.

### Cenário 4: Carregar dados do usuário autenticado
* **Dado que** o usuário `"user@cadastrado.com"` está devidamente autenticado com sucesso e possui seu token válido de autenticação.
* **Quando** uma requisição HTTP GET for enviada para `/api/usuario`, utilizando o header `Authorization: Bearer <TOKEN_AUTENTICACAO>`:
* **Então** o sistema deve retornar com sucesso os dados de usuário, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar o payload:
```json
{
  "id": "019f28f6-bfef-7454-9b2a-d38c8ac91773",
  "email": "user@cadastrado.com"
}
```

### Cenário 5: Falha ao carregar dados do usuário por token inválido

* **Quando** uma requisição HTTP GET for enviada para `/api/usuario` com token inválido.
* **Então** o sistema deve recusar a autenticação imediatamente, o status da resposta HTTP deve ser `401 Unauthorized` e o corpo da resposta deve retornar vazio.

### Cenário 6: Falha ao carregar dados do usuário por token expirado

* **Quando** uma requisição HTTP GET for enviada para `/api/usuario` com token expirado.
* **Então** o sistema deve recusar a autenticação imediatamente, o status da resposta HTTP deve ser `401 Unauthorized` e o corpo da resposta deve retornar vazio.

## 3. Requisitos Não Funcionais: Regras de arquitetura, segurança e infraestrutura

### Segurança e criptografia

* **Primary Key:** Todos os models devem usar primary key no formato **UUID V7** através da gem `SQLiteCrypto` na construção das migrations através do atributo `id: :uuid`.
* **Criptografia de senha:** O model `User` deve usar obrigatoriamente o mecanismo nativo `has_secure_password` do Rails.
* **Camada de Persistência:** A migração do banco de dados para tabela `users` deve impor as seguintes restrições:
  * Coluna `email` deve ser `null: false`.
  * Deve existir indíce único (`unique: true`) na coluna `email`.

### Mecanismo de JSON Web Token (JWT)
* **Componente Utilitário:** O agente deve criar um módulo encapsulado `lib/json_web_token.rb` utilizando a gem `jwt` para lidar com a lógica de encode e decode.
* **Payload do Token:** O payload interno do JWT deve armazenar apenas o `user_id` e o timestamp de expiração do token (exp).
* **Tempo de Expiração:** O tempo de vida padrão de cada token gerado deve ser estritamente de 48 horas.
* **Chave de Assinatura:** O token deve ser assinado e validado utilizando a chave secreta nativa da aplicação: `Rails.application.credentials.secret_key_base`.

### Guarda de Rotas Protegidas (Filtro Global de Autenticação)
* O agente deve implementar um método de filtro (ex: authenticate_request) no `ApplicationController` para ser herdado por controllers que exijam autenticação no futuro.
* O filtro deve interceptar o cabeçalho HTTP Authorization: `Bearer <TOKEN>`, decodificar o payload e injetar o usuário correspondente do banco de dados em uma variável de instância acessível `@current_user`.
* Caso o token esteja ausente, corrompido, adulterado ou com o tempo de expiração vencido, a requisição deve ser abortada imediatamente retornando status `HTTP 401 Unauthorized` e corpo vazio.

## 4. Diretrizes de QA e Cobertura de Testes para o Agente
* **Testes unitários:** O agente deve criar e rodar testes unitários para os models usando o Minitest nativo do Rails.
* Criar `test/factories/user.rb` com o mínimo necessário de preencher com dados de teste todos os campos existentes no model `User`.
* Criar `test/models/user_test.rb` cobrindo o fluxo de testar validação de sucesso e falha de cada campo do model `User`, utilize a factory `User` para instanciar, salvar, alterar ou excluir um model `User`.
* Criar `test/lib/json_web_token.rb` cobrindo o fluxo de testar os métodos encode e decode.
* **Testes de Integração:** O agente deve gerar e rodar testes de integração usando o Minitest nativo do Rails.
* Criar `test/integration/api/users_test.rb` cobrindo o fluxo de criação de contas, carregamento do usuário logado e suas validações.
* Criar `test/integration/api/sessions_test.rb` validando os fluxos de login com sucesso e de bloqueio por falha de credenciais.
* **Validação de Contrato:** Se o arquivo `docs/openapi.json` contiver os esquemas para estes endpoints, adicione a asserção `assert_schema_conform` da gem `Committee` ao final de cada teste de integração para garantir conformidade total de contrato.
