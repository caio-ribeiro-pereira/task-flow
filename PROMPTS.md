-- IMPLEMENTAÇÃO DE FEATURE USER
Faça leitura de `AGENTS.md`, `DEVELOPMENT.md`, `specs/features/user.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `1. Requisitos Funcionais: Histórias de Cadastro de Usuário & Critérios de Aceitação`. Inclua testes unitários de validação de model e testes de integração dos endpoints, por fim execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Faça leitura de `AGENTS.md`, `DEVELOPMENT.md`, `specs/features/user.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `2. Requisitos Funcionais: Histórias de Autenticação de Usuário & Critérios de Aceitação`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes de QA e Cobertura de testes, por fim execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Faça leitura de `AGENTS.md`, `DEVELOPMENT.md`, `specs/features/user.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `3. Requisitos Não Funcionais: Regras de arquitetura, segurança e infraestrutura`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes de QA e Cobertura de testes, por fim execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Modifique a migration da tabela users para que a primary key seja em formato `uuid` e configure a gem `SQLiteCrypto` para suportar `uuid v7`. Crie também um teste unitário para `lib/json_web_token.rb`.


-- IMPLEMENTAÇÃO DE FEATURE PROJECTS

Faça leitura de `AGENTS.md`, `DEVELOPMENT.md`, `specs/features/projects.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `1. Requisitos Funcionais: Cadastro de Projetos do Usuário & Critérios de Aceitação`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes da seção: `6. Diretrizes de QA e Cobertura de Testes para o Agente`, por último execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Faltou incluir o guarda de rotas protegidas em `app/api/projects_controller.rb`, nesse controller todas as rotas precisam passar pelo hook: `before_action :authenticate_request!`.

Faça leitura de `AGENTS.md`, `DEVELOPMENT.md`, `specs/features/projects.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `2. Requisitos Funcionais: Edição de Projetos do Usuário & Critérios de Aceitação`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes da seção: `6. Diretrizes de QA e Cobertura de Testes para o Agente`, por último execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Faltou implementar validação e testes dos cenários 4, 5 e 6.

Faça leitura de `specs/features/projects.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `3. Requisitos Funcionais: Busca de Projeto do Usuário por ProjectID & Critérios de Aceitação`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes da seção: `6. Diretrizes de QA e Cobertura de Testes para o Agente`, por último execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Faça leitura de `specs/features/projects.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `4. Requisitos Funcionais: Listagem de Projetos do Usuário (com filtro por status) & Critérios de Aceitação`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes da seção: `6. Diretrizes de QA e Cobertura de Testes para o Agente`, por último execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Faltou criar testes para o cenário: `Cenário 3: Listagem vazia de projetos do usuário por filtro de status inválido`.


-- IMPLEMENTAÇÃO DE FEATURE TASKS

Faça leitura de `specs/features/tasks.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `1. Requisitos Funcionais: Cadastro de Tarefas do Projeto de um Usuário & Critérios de Aceitação`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes de QA e Cobertura de testes, por fim execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Faltou implementar o fluxo do cenário: `Cenário 2: Cadastro de tarefa com status done do projeto de um usuário` e seus respectivos testes.

Faça leitura de `specs/features/tasks.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `2. Requisitos Funcionais: Listagem de Tarefas do Projeto de um Usuário (com filtro por status e prioridade)`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes de QA e Cobertura de testes, por fim execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Inclua também um teste de integração que faça uso dos dois filtros ao mesmo tempo, fazendo concatenação dos filtros de status e prioridade, seguindo por exemplo o padrão dessa querystring `?status=pending&priority=low`.

Faça leitura de `specs/features/tasks.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `3. Requisitos Funcionais: Exclusão de Tarefas do Projeto de um Usuário`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes de QA e Cobertura de testes, por fim execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Os testes dos cenários 2 e 3, estão incorretos. Refaça os testes seguindo corretamente as descrições das seções: `Cenário 2: Falha ao excluir uma tarefa em andamento` e `Cenário 3: Falha ao excluir uma tarefa em finalizada`.

Faça leitura de `specs/features/tasks.md` e `docs/openapi.json`. Implemente todos os cenários do requisíto: `4. Requisitos Funcionais: Edição de Tarefas do Projeto de um Usuário & Critérios de Aceitação`. Inclua testes unitários de validação de model e testes de integração dos endpoints seguindo as diretrizes de QA e Cobertura de testes, por fim execute o `bundle rubocop -A` para corrigir e padronizar todo código.

Inclua também um teste de integração que atualize o status da tarefa com sucesso, deve testar o fluxo de sucesso da edição do status `pending` para `in_progress` e também deve testar o fluxo de sucesso da edição do status `in_progress` para `done`.

