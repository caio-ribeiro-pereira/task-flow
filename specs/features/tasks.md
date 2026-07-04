# Spec: CRUD de tarefas de um projeto

Este documento especifica as regras de negócio, fluxos de API, critérios de aceitação e contratos técnicos para a funcionalidade de gerenciamento e modelagem da tabela de tarefas de um projeto.

---

## 1. Requisitos Funcionais: Cadastro de Tarefas do Projeto de um Usuário & Critérios de Aceitação

### Cenário 1: Cadastro de tarefa do projeto de um usuário
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "priority": "low"
  }
}
```
* **Então** o sistema deve criar um novo registro na tabela tasks com status default `"pending"`, project_id com valor do `params[:project_id]` e user_id com valor de `@current_user.id`, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
{
  "id": "019f28f6-bfef-7454-9b2a-d38c8ac91790",
  "title": "Tarefa X",
  "description": "Descrição da tarefa X",
  "status": "pending",
  "priority": "low",
  "created_at": "2026-07-03T11:28:18-03:00",
  "completed_at": null,
  "project_id": "019f28f6-bfef-7454-9b2a-d38c8ac91800",
  "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
}
```

### Cenário 2: Cadastro de tarefa com status done do projeto de um usuário
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "status": "done",
    "priority": "low"
  }
}
```
* **Então** o sistema deve criar um novo registro na tabela tasks com completed_at com valor de timestamp do momento do cadastro, project_id com valor do `params[:project_id]` e user_id com valor de `@current_user.id`, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
{
  "id": "019f28f6-bfef-7454-9b2a-d38c8ac91790",
  "title": "Tarefa X",
  "description": "Descrição da tarefa X",
  "status": "done",
  "priority": "low",
  "created_at": "2026-07-03T11:28:18-03:00",
  "completed_at": "2026-07-03T11:28:18-03:00",
  "project_id": "019f28f6-bfef-7454-9b2a-d38c8ac91800",
  "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
}
```

### Cenário 3: Falha no cadastro por titulo em branco
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "",
    "description": "Descrição da tarefa X",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Title can't be blank"]
}
```

### Cenário 4: Falha no cadastro por titulo muito longo
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "TITULO MUITO LONGO QUE SUPERA LIMITE DE 200 CARACTERES TITULO MUITO LONGO QUE SUPERA LIMITE DE 200 CARACTERES TITULO MUITO LONGO QUE SUPERA LIMITE DE 200 CARACTERES TITULO MUITO LONGO QUE SUPERA LIMITE DE 200 CARACTERES",
    "description": "Descrição da tarefa X",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Title is too long (maximum is 200 characters)"]
}
```

### Cenário 5: Falha no cadastro por prioridade em branco
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "priority": ""
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Priority can't be blank"]
}
```

### Cenário 6: Falha no cadastro por prioridade inválida
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "priority": "invalid"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Priority is not included in the list"]
}
```

### Cenário 7: Falha no cadastro por status inválido
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "status": "invalid",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status is not included in the list"]
}
```

### Cenário 8: Falha no cadastro por usar project_id de outro usuário
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto de outro usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "status": "pending",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Project does not belong to user"]
}
```

### Cenário 9: Falha no cadastro por usar project_id de projeto arquivado
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP POST for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto arquivado (`status: "archived"`) do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "status": "pending",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve criar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Project is archived"]
}
```

## 2. Requisitos Funcionais: Listagem de Tarefas do Projeto de um Usuário (com filtro por status e prioridade)

### Cenário 1: Listando tarefas do projeto de um usuário
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui registros de projetos associado ao seu user_id.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos/{project_id}/tarefas`, em que `project_id` é um id de projeto do usuário e o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar todos os registros de tarefas referente ao projeto do usuário, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
[
  {
    "id": "019f28f6-bfef-7454-9b2a-d38c8ac91773",
    "title": "Tarefa X",
    "description": "Descrição da Tarefa X",
    "status": "pending",
    "priority": "low",
    "created_at": "2026-07-03T11:28:18-03:00",
    "completed_at": null,
    "project_id": "019f28f6-bfef-7454-9b2a-d38c8ac91900",
    "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
  },
  {
    "id": "019f28f6-bfef-7454-9b2a-d38c8ac91772",
    "title": "Tarefa Y",
    "description": "Descrição da Tarefa Y",
    "status": "in_progress",
    "priority": "medium",
    "created_at": "2026-07-03T11:28:19-03:00",
    "completed_at": null,
    "project_id": "019f28f6-bfef-7454-9b2a-d38c8ac91900",
    "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
  }
]
```
### Cenário 2: Listando tarefas do projeto de um usuário com filtro por status
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui registros de projetos associado ao seu user_id.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos/{project_id}/tarefas?status=pending`, em que `project_id` é um id de projeto do usuário e o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar todos os registros de tarefas referente ao projeto do usuário de status igual ao valor de status enviado por querystring `status=pending`, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
[
  {
    "id": "019f28f6-bfef-7454-9b2a-d38c8ac91773",
    "title": "Tarefa X",
    "description": "Descrição da Tarefa X",
    "status": "pending",
    "priority": "low",
    "created_at": "2026-07-03T11:28:18-03:00",
    "completed_at": null,
    "project_id": "019f28f6-bfef-7454-9b2a-d38c8ac91900",
    "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
  }
]
```

### Cenário 3: Listando tarefas do projeto de um usuário com filtro por prioridade
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui registros de projetos associado ao seu user_id.
* **Quando** uma requisição HTTP GET for enviada para `/api/projetos/{project_id}/tarefas?priority=medium`, em que `project_id` é um id de projeto do usuário e o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve retornar todos os registros de tarefas referente ao projeto do usuário de prioridade igual ao valor de status enviado por querystring `priority=medium`, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
[
  {
    "id": "019f28f6-bfef-7454-9b2a-d38c8ac91772",
    "title": "Tarefa Y",
    "description": "Descrição da Tarefa Y",
    "status": "in_progress",
    "priority": "medium",
    "created_at": "2026-07-03T11:28:19-03:00",
    "completed_at": null,
    "project_id": "019f28f6-bfef-7454-9b2a-d38c8ac91900",
    "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
  }
]
```

## 3. Requisitos Funcionais: Exclusão de Tarefas do Projeto de um Usuário

### Cenário 1: Excluindo uma tarefa pendente
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui registros de projetos associado ao seu user_id.
* **Quando** uma requisição HTTP DELETE for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de uma tarefa do usuário de status `pending` e o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema deve excluir registro de tarefa do usuário e o status da resposta HTTP deve ser `204 No Content`.

### Cenário 2: Falha ao excluir uma tarefa em andamento
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui registros de projetos associado ao seu user_id.
* **Quando** uma requisição HTTP DELETE for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de uma tarefa do usuário de status `in_progress` e o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema não deve excluir registro de tarefa, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status in progress cannot delete this task"]
}
```

### Cenário 3: Falha ao excluir uma tarefa em finalizada
* **Dado que** o usuário está autenticado no sistema, possui um token válido e possui registros de projetos associado ao seu user_id.
* **Quando** uma requisição HTTP DELETE for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de uma tarefa do usuário de status `done` e o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>`.
* **Então** o sistema não deve excluir registro de tarefa, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status done cannot delete this task"]
}
```

## 4. Requisitos Funcionais: Edição de Tarefas do Projeto de um Usuário & Critérios de Aceitação

### Cenário 1: Editar tarefa do projeto de um usuário
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "priority": "low"
  }
}
```
* **Então** o sistema deve editar o registro na tabela tasks, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
{
  "id": "019f28f6-bfef-7454-9b2a-d38c8ac91790",
  "title": "Tarefa X",
  "description": "Descrição da tarefa X",
  "status": "pending",
  "priority": "low",
  "created_at": "2026-07-03T11:28:18-03:00",
  "completed_at": null,
  "project_id": "019f28f6-bfef-7454-9b2a-d38c8ac91800",
  "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
}
```

### Cenário 2: Editar tarefa com status done
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "priority": "low",
    "status": "done"
  }
}
```
* **Então** o sistema deve editar o registro na tabela tasks com completed_at com valor de timestamp do momento da edição, o status da resposta HTTP deve ser `200 OK` e o corpo da resposta deve retornar:
```json
{
  "id": "019f28f6-bfef-7454-9b2a-d38c8ac91790",
  "title": "Tarefa X",
  "description": "Descrição da tarefa X",
  "status": "done",
  "priority": "low",
  "created_at": "2026-07-03T11:28:18-03:00",
  "completed_at": "2026-07-03T11:28:18-05:00",
  "project_id": "019f28f6-bfef-7454-9b2a-d38c8ac91800",
  "user_id": "019f28f6-bfef-7454-9b2a-d38c8ac91779"
}
```

### Cenário 3: Falha na edição por titulo em branco
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "",
    "description": "Descrição da tarefa X",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve editar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Title can't be blank"]
}
```

### Cenário 4: Falha na edição por titulo muito longo
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "TITULO MUITO LONGO QUE SUPERA LIMITE DE 200 CARACTERES TITULO MUITO LONGO QUE SUPERA LIMITE DE 200 CARACTERES TITULO MUITO LONGO QUE SUPERA LIMITE DE 200 CARACTERES TITULO MUITO LONGO QUE SUPERA LIMITE DE 200 CARACTERES",
    "description": "Descrição da tarefa X",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve editar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Title is too long (maximum is 200 characters)"]
}
```

### Cenário 5: Falha na edição por prioridade em branco
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "priority": ""
  }
}
```
* **Então** o sistema não deve editar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Priority can't be blank"]
}
```

### Cenário 6: Falha na edição por prioridade inválida
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "priority": "invalid"
  }
}
```
* **Então** o sistema não deve editar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Priority is not included in the list"]
}
```

### Cenário 7: Falha na edição por status inválido
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "status": "invalid",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve editar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status is not included in the list"]
}
```

### Cenário 8: Falha na edição na transição de status in_progress para pending
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa com status `in_progress` do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "status": "pending",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve editar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status cannot change from in progress to pending"]
}
```

### Cenário 9: Falha na edição na transição de status done para in_progress
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa com status `done` do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "status": "in_progress",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve editar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status cannot change from done to in progress"]
}
```

### Cenário 10: Falha na edição na transição de status done para pending
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa com status `done` do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "status": "pending",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve editar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status cannot change from done to pending"]
}
```

### Cenário 11: Falha na edição na transição de status pending para done
* **Dado que** o usuário está autenticado no sistema e possui um token válido.
* **Quando** uma requisição HTTP PATCH for enviada para `/api/tarefas/{task_id}`, em que `task_id` é um id de tarefa com status `pending` do usuário, o token do usuário autenticado é informado via header `Authorization: Bearer <TOKEN>` e é enviado o seguinte payload:
```json
{
  "task": {
    "title": "Tarefa X",
    "description": "Descrição da tarefa X",
    "status": "done",
    "priority": "low"
  }
}
```
* **Então** o sistema não deve editar registro, o status da resposta HTTP deve ser `422 Unprocessable Entity` e o corpo da resposta deve retornar o erro de validação contendo a seguinte resposta:
``` json
{
  "errors": ["Status cannot change from pending to done"]
}
```

## 5. Requisitos Não Funcionais: Regras de arquitetura, modelagem e segurança

### Modelagem

* **Primary Key:** Todos os models devem usar primary key no formato **UUID V7** através da gem `SQLiteCrypto` na construção das migrations através do atributo `id: :uuid`.
* **Camada de Persistência:** A migração do banco de dados para tabela `tasks` deve conter as seguintes regras:
  * Incluir todos os campos documentados no `docs/openai.json` no Schema `Tarefa`.
  * Respeitar o relacionamento da modelagem: `Projects 1 - N Tasks` e `Users 1 - N Tasks`.
  * Coluna `project_id` deve ser `null: false`.
  * Coluna `project_id` deve ser chave estrangeira da tabela `projects`.
  * Coluna `user_id` deve ser `null: false`.
  * Coluna `user_id` deve ser chave estrangeira da tabela `users`.

### Guarda de Rotas Protegidas (Filtro Global de Autenticação)
* Todos os endpoints de `tasks_controller` devem ser protegidos por autenticação utilizando `before_action :authenticate_request!` que é um método já existente, herdado do `ApplicationController`

## 6. Diretrizes de QA e Cobertura de Testes para o Agente
* **Testes unitários:** O agente deve criar e rodar testes unitários para os models usando o Minitest nativo do Rails.
* Criar `test/factories/task.rb` com os dados necessário para modelagem de `Task`.
* Criar `test/models/task_test.rb` cobrindo o fluxo de testar validação de sucesso e falha de cada campo do model `Task`, utilize a factory `Task` para instanciar, salvar, alterar ou excluir um model `Task`.
* **Testes de Integração:** O agente deve gerar e rodar testes de integração usando o Minitest nativo do Rails.
* Criar `test/integration/api/tasks_test.rb` cobrindo o fluxo de CRUD de projetos conforme é citado nos cenários de requisitos funcionais.
* **Validação de Contrato:** Se o arquivo `docs/openapi.json` contiver os esquemas para estes endpoints, adicione a asserção `assert_schema_conform` da gem `Committee` ao final de cada teste de integração para garantir conformidade total de contrato.
