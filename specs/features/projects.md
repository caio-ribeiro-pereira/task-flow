# Spec: CRUD de projetos de um Usuário

Este documento especifica as regras de negócio, fluxos de API, critérios de aceitação e contratos técnicos para a funcionalidade de gerenciamento e modelagem da tabela de projetos de um usuário.

---

## 1. Requisitos Funcionais: CRUD de Projetos & Critérios de Aceitação

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

### Cenário 3: Falha no cadastro por status inválido
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

### Cenário 4: Buscando projeto por ID de projeto do usuário
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

### Cenário 5: Busca vazia ao informar ID inválido
* **Dado que** o usuário está autenticado no sistema, possui um token válido.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos/{id}` contendo um `id` inválido (ex.: `/api/projetos/invalid_id`) e o token do usuário via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar um json vazio, o status da resposta HTTP deve ser `200 OK`.

### Cenário 5: Busca vazia ao informar ID de projeto de outro usuário
* **Dado que** o usuário está autenticado no sistema, possui um token válido.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos/{id}` contendo um `id` de projeto de outro usuário e o token do usuário via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar um json vazio, o status da resposta HTTP deve ser `200 OK`.

## 2. Requisitos Não Funcionais: Regras de arquitetura, segurança e infraestrutura

### Modelagem

* **Primary Key:** Todos os models devem usar primary key no formato **UUID V7** através da gem `SQLiteCrypto` na construção das migrations através do atributo `id: :uuid`.
* **Camada de Persistência:** A migração do banco de dados para tabela `projects` deve conter as seguintes regras:
  * Incluir todos os campos documentados no `docs/openai.json` no Schema `Projeto`.
  * Respeitar o relacionamento da modelagem: `Users 1 - N Projects`.
  * Coluna `user_id` deve ser `null: false`.
  * Coluna `user_id` deve ser chave estrangeira da tabela `users`.

### Guarda de Rotas Protegidas (Filtro Global de Autenticação)
* Todos os endpoints de `projects_controller` devem ser protegidos por autenticação utilizando `before_action :authenticate_request!`

## 3. Diretrizes de QA e Cobertura de Testes para o Agente
* **Testes unitários:** O agente deve criar e rodar testes unitários para os models usando o Minitest nativo do Rails.
* Criar `test/factories/project.rb` com os dados necessário para modelagem de `Project`.
* Criar `test/models/project_test.rb` cobrindo o fluxo de testar validação de sucesso e falha de cada campo do model `Project`, utilize a factory `Project` para instanciar, salvar, alterar ou excluir um model `Project`.
* **Testes de Integração:** O agente deve gerar e rodar testes de integração usando o Minitest nativo do Rails.
* Criar `test/integration/api/projects_test.rb` cobrindo o fluxo de CRUD de projetos conforme é citado nos cenários de requisitos funcionais.
* **Validação de Contrato:** Se o arquivo `docs/openapi.json` contiver os esquemas para estes endpoints, adicione a asserção `assert_schema_conform` da gem `Committee` ao final de cada teste de integração para garantir conformidade total de contrato.
