# Spec: CRUD de projetos de um Usuário

Este documento especifica as regras de negócio, fluxos de API, critérios de aceitação e contratos técnicos para a funcionalidade de gerenciamento e modelagem da tabela de projetos de um usuário.

---

## 1. Requisitos Funcionais: Cadastro de Projetos do Usuário & Critérios de Aceitação

### Cenário 1: Cadastro de projeto do usuário
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos` contendo o token do usuário via header `Authorization: Bearer <TOKEN>` e o seguinte payload:
```json
{
  "project": {
    "name": "Projeto X",
    "description": "Descrição do projeto X",
    "status": "active"
  }
}
```
* **Então** o sistema deve criar um novo registro na tabela projects com status `"active"` e user_id com valor de `@current_user.id`, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
{
  "id": "019f28f6-bfef-7454-9b2a-d38c8ac91773",
  "name": "Projeto X",
  "description": "Descrição do projeto X",
  "status": "active",
  "created_at": "2026-07-03T11:28:18-03:00",
  "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
}
```

### Cenário 2: Falha no cadastro por nome muito longo
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos` contendo o token do usuário via header `Authorization: Bearer <TOKEN>` e o seguinte payload:
```json
{
  "project": {
    "name": "NOME MUITO LONGO QUE SUPERAR 100 CARACTERES NOME MUITO LONGO QUE SUPERAR 100 CARACTERES NOME MUITO LONGO QUE SUPERAR 100 CARACTERES",
    "description": "Descrição do projeto X",
    "status": "active"
  }
}
```

* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Name is too long (maximum is 100 characters)"]
}
```

### Cenário 3: Falha no cadastro por descrição muito longa
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos` contendo o token do usuário via header `Authorization: Bearer <TOKEN>` e o seguinte payload:
```json
{
  "project": {
    "name": "Nome do Projeto",
    "description": "A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS",
    "status": "active"
  }
}
```

* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Description is too long (maximum is 2000 characters)"]
}
```

### Cenário 4: Falha no cadastro por status inválido
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos` contendo o token do usuário via header `Authorization: Bearer <TOKEN>` e o seguinte payload:
```json
{
  "project": {
    "name": "Projeto",
    "description": "Descrição do projeto X",
    "status": "INVALIDO_STATUS"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status is not included in the list"]
}
```

## 2. Requisitos Funcionais: Edição de Projetos do Usuário & Critérios de Aceitação

### Cenário 1: Edição de projeto do usuário
* **Dado que** o usuário está autenticado no sistema, possui um token válido e já possui um projeto cadastrado.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/projetos/{id}`, em que `id` é um ID de projeto cadastrado do usuário, é informado o token do usuário via header `Authorization: Bearer <TOKEN>` e informado o seguinte payload:
```json
{
  "project": {
    "name": "Projeto EDITADO",
    "description": "Descrição do projeto X",
    "status": "active"
  }
}
```
* **Então** o sistema deve editar o registro na tabela `projects`, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar os dados editados:
```json
{
  "id": "019f28f6-bfef-7454-9b2a-d38c8ac91773",
  "name": "Projeto EDITADO",
  "description": "Descrição do projeto X",
  "status": "active",
  "created_at": "2026-07-03T11:28:18-03:00",
  "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
}
```

### Cenário 2: Falha na edição por nome muito longo
* **Dado que** o usuário está autenticado no sistema, possui um token válido e já possui um projeto cadastrado.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/projetos/{id}`, em que `id` é um ID de projeto cadastrado do usuário, é informado o token do usuário via header `Authorization: Bearer <TOKEN>` e informado o seguinte payload:
```json
{
  "project": {
    "name": "NOME MUITO LONGO QUE SUPERAR 100 CARACTERES NOME MUITO LONGO QUE SUPERAR 100 CARACTERES NOME MUITO LONGO QUE SUPERAR 100 CARACTERES",
    "description": "Descrição do projeto X",
    "status": "active"
  }
}
```

* **Então** o sistema não deve editar o registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Name is too long (maximum is 100 characters)"]
}
```

### Cenário 3: Falha na edição por descrição muito longa
* **Dado que** o usuário está autenticado no sistema, possui um token válido e já possui um projeto cadastrado.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/projetos/{id}`, em que `id` é um ID de projeto cadastrado do usuário, é informado o token do usuário via header `Authorization: Bearer <TOKEN>` e informado o seguinte payload:
```json
{
  "project": {
    "name": "Nome do Projeto",
    "description": "A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS A DESCRIÇÃO DESSE PROJETO SUPEROU 2000 CHARS",
    "status": "active"
  }
}
```

* **Então** o sistema não deve editar o registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Description is too long (maximum is 2000 characters)"]
}
```

### Cenário 4: Falha na edição por status inválido
* **Dado que** o usuário está autenticado no sistema, possui um token válido e já possui um projeto cadastrado.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/projetos/{id}`, em que `id` é um ID de projeto cadastrado do usuário, é informado o token do usuário via header `Authorization: Bearer <TOKEN>` e informado o seguinte payload:
```json
{
  "project": {
    "name": "Projeto",
    "description": "Descrição do projeto X",
    "status": "INVALIDO_STATUS"
  }
}
```
* **Então** o sistema não deve editar o registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status is not included in the list"]
}
```

### Cenário 5: Falha na edição por id inválido
* **Dado que** o usuário está autenticado no sistema, possui um token válido e já possui um projeto cadastrado.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/projetos/{id}`, em que `id` é um ID inválido, é informado o token do usuário via header `Authorization: Bearer <TOKEN>` e informado o seguinte payload:
```json
{
  "project": {
    "name": "Projeto",
    "description": "Descrição do projeto X",
    "status": "active"
  }
}
```
* **Então** o sistema não deve editar o registro, o status da resposta HTTP deve ser `204 No Content` e o corpo da resposta deve retornar json vazio.

## 3. Requisitos Funcionais: Busca de Projeto do Usuário por ProjectID & Critérios de Aceitação

### Cenário 1: Buscando por ID de projeto do usuário
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui um registro de projeto associado ao seu user_id.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos/{id}` (ex.: `/api/projetos/019f28f6-bfef-7454-9b2a-d38c8ac91773`)contendo o token do usuário via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar um único registro de projeto referente ao `id` passado em parâmetro do endpoint, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
{
  "id": "019f28f6-bfef-7454-9b2a-d38c8ac91773",
  "name": "Projeto X",
  "description": "Descrição do projeto X",
  "status": "active",
  "created_at": "2026-07-03T11:28:18-03:00",
  "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
}
```

### Cenário 2: Busca vazia ao informar ID inválido
* **Dado que** o usuário está autenticado no sistema, possui um token válido.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos/{id}` contendo um `id` inválido (ex.: `/api/projetos/invalid_id`) e o token do usuário via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar um json vazio, o status da resposta HTTP deve ser `200 OK`.

### Cenário 3: Busca vazia ao informar ID de projeto de outro usuário
* **Dado que** o usuário está autenticado no sistema, possui um token válido.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos/{id}` contendo um `id` de projeto de outro usuário e o token do usuário via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar um json vazio, o status da resposta HTTP deve ser `200 OK`.

## 4. Requisitos Funcionais: Listagem de Projetos do Usuário (com filtro por status) & Critérios de Aceitação

### Cenário 1: Listando projetos do usuário
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui registros de projetos associado ao seu user_id.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos` contendo o token do usuário via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar todos os registros de projetos referente ao usuário, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
[
  {
    "id": "019f28f6-bfef-7454-9b2a-d38c8ac91773",
    "name": "Projeto X",
    "description": "Descrição do projeto X",
    "status": "active",
    "created_at": "2026-07-03T11:28:18-03:00",
    "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
  },
  {
    "id": "019f28f6-bfef-7454-9b2a-d38c8ac91779",
    "name": "Projeto Y",
    "description": "Descrição do projeto Y",
    "status": "archived",
    "created_at": "2026-07-03T11:28:18-10:00",
    "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
  }
]
```

### Cenário 2: Listando projetos do usuário com filtro por status
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui registros de projetos associado ao seu user_id.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos?status=active` contendo o token do usuário via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar todos os registros de projetos de status igual ao valor de status enviado por querystring `status=active` e referente ao usuário, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
[
  {
    "id": "019f28f6-bfef-7454-9b2a-d38c8ac91773",
    "name": "Projeto X",
    "description": "Descrição do projeto X",
    "status": "active",
    "created_at": "2026-07-03T11:28:18-03:00",
    "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
  }
]
```

### Cenário 3: Listagem vazia de projetos do usuário por filtro de status inválido
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui registros de projetos associado ao seu user_id.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos?status=invalid` contendo o token do usuário via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar um array vazio, o status da resposta HTTP deve ser `200 OK`.

## 5. Requisitos Não Funcionais: Regras de arquitetura, segurança e infraestrutura

### Modelagem

* **Primary Key:** Todos os models devem usar primary key no formato **UUID V7** através da gem `SQLiteCrypto` na construção das migrations através do atributo `id: :uuid`.
* **Camada de Persistência:** A migração do banco de dados para tabela `projects` deve conter as seguintes regras:
  * Incluir todos os campos documentados no `docs/openai.json` no Schema `Projeto`.
  * Respeitar o relacionamento da modelagem: `Users 1 - N Projects`.
  * Coluna `user_id` deve ser `null: false`.
  * Coluna `user_id` deve ser chave estrangeira da tabela `users`.

### Guarda de Rotas Protegidas (Filtro Global de Autenticação)
* Todos os endpoints de `projects_controller` devem ser protegidos por autenticação utilizando `before_action :authenticate_request!` que é um método já existente, herdado do `ApplicationController`

## 6. Diretrizes de QA e Cobertura de Testes para o Agente
* **Testes unitários:** O agente deve criar e rodar testes unitários para os models usando o Minitest nativo do Rails.
* Criar `test/factories/project.rb` com os dados necessário para modelagem de `Project`.
* Criar `test/models/project_test.rb` cobrindo o fluxo de testar validação de sucesso e falha de cada campo do model `Project`, utilize a factory `Project` para instanciar, salvar, alterar ou excluir um model `Project`.
* **Testes de Integração:** O agente deve gerar e rodar testes de integração usando o Minitest nativo do Rails.
* Criar `test/integration/api/projects_test.rb` cobrindo o fluxo de CRUD de projetos conforme é citado nos cenários de requisitos funcionais.
* **Validação de Contrato:** Se o arquivo `docs/openapi.json` contiver os esquemas para estes endpoints, adicione a asserção `assert_schema_conform` da gem `Committee` ao final de cada teste de integração para garantir conformidade total de contrato.
