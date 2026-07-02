# DEVELOPMENT.md — Diretrizes de Desenvolvimento Local para IA

Este documento serve como a base de conhecimento operacional para o desenvolvimento do projeto. Sempre consulte este arquivo para entender as convenções de código, comandos locais e a estrutura de diretórios do Rails 8.

---

## 1. Comandos Operacionais (CLI)

Use estes comandos exatos sempre que precisar rodar a aplicação, executar testes ou fazer checagens estáticas. Nunca tente adivinhar comandos de infraestrutura.

*   **Executar Testes (Minitest):** `bin/rails test`
*   **Executar Teste de um Arquivo Específico:** `bin/rails test test/integration/meu_teste_test.rb`
*   **Girar Migrations Pendentes:** `bin/rails db:migrate`
*   **Resetar Banco de Dados de Teste:** `bin/rails db:test:prepare`
*   **Análise Estática de Estilo (RuboCop):** `bundle exec rubocop -A` (use `-A` para autocorreção segura)
*   **Análise de Segurança (Brakeman):** `bin/brakeman`

---

## 2. Estrutura e Convenções de Pastas (Rails 8)

Mantenha o padrão estrito do ecossistema Rails 8 API/MVC. Não invente novas estruturas de diretórios.

*   `app/models/` — Regras de negócio, escopos, associações com outros modelos e validações de dados.
*   `app/controllers/` — Processamento de requisições e Strong Parameters. Controllers de API devem herdar de `Api::BaseController` e responder em formato JSON.
*   `app/jobs/` — Background jobs assíncronos que rodam nativamente sob o `Solid Queue`.
*   `config/routes.rb` — Mapeamento estrito de rotas RESTful, deve usar convenções de resource do rails sempre que possível para mapear as rotas dos respectivos controllers.
*   `db/migrate/` — Arquivos de migração do banco de dados.
*   `docs/openapi.json` — Contrato e especificação da API (Fonte da verdade).
*   `specs/features/` — Histórias de usuário, critérios de aceitação e especificações funcionais em Markdown.
*   `test/` — Toda a suíte de testes (Minitest).

---

## 3. Diretrizes de Codificação e Estilo (Ruby on Rails)

*   **Padrão de Nomeação:** Classes e Models em `CamelCase`, arquivos, métodos, tabelas e colunas de banco em `snake_case`.
*   **Strong Parameters:** Em controllers, encapsule os parâmetros permitidos em métodos privados seguindo o padrão: `params.require(:modelo).permit(:campo1, :campo2)`.
*   **Validações de Model:** Garanta que todas as restrições do banco de dados (ex: `null: false`, `unique: true`) tenham suas validações correspondentes no Model Rails (ex: `validates :campo, presence: true`).
*   **Tratamento de Contrato (OpenAPI):** Ao criar ou alterar um endpoint, use a gem `Committee` integrada nos testes de integração para validar se o payload de resposta corresponde exatamente ao schema definido em `docs/openapi.json` usando `assert_schema_conform(status_code)`.

---

## 4. Fluxo de Correção de Erros (Self-Healing)

Se os testes (`bin/rails test`) falharem após uma alteração de código:
1. Analise o traceback do erro impresso no terminal.
2. Identifique se a falha é por erro de sintaxe, quebra de contrato com o OpenAPI, ou falha de lógica de negócio em relação à Spec.
3. Corrija o arquivo correspondente, limpe os arquivos temporários se necessário e rode a suíte de testes novamente.
4. Não solicite intervenção humana a menos que haja um conflito direto entre o arquivo de especificação (`specs/features/*`) e o contrato da API (`docs/openapi.json`).