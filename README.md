# AI-Assisted Project Starter Kit & Standards

> **Base padronizada para criação acelerada de novos projetos de software, com suporte nativo a Desenvolvimento Assistido por IA, Spec-Driven Development (SDD) e Governança Docs-as-Code.**

---

## 🎯 Por que este Starter Kit?

Iniciar um novo projeto de software hoje não significa apenas configurar linters e editores: significa **alinhar a colaboração entre desenvolvedores humanos e agentes de IA**.

Este repositório fornece a base operacional completa para garantir que:
1. **Agentes de IA** (Copilot, Antigravity, Claude, etc.) sigam padrões estritos de arquitetura, testes e commits antes de sugerir código.
2. O time adote **Spec-Driven Development (SDD)**, validando requisitos antes da codificação.
3. Decisões arquiteturais sejam documentadas formalmente via **ADRs (Architecture Decision Records)**.
4. O ambiente no **Visual Studio Code** e no **Git/GitHub** inicie padronizado desde o primeiro commit.

---

## 📂 O que está incluído?

### 🤖 1. Camada de Inteligência Artificial & Engenharia
* **[`AGENTS.md`](./AGENTS.md):** Diretrizes de ouro operacionais para agentes de IA (regras de contexto, proibição de alucinação de dependências, requisitos de testes e padrão Conventional Commits).
* **[`.github/copilot-instructions.md`](./.github/copilot-instructions.md):** Instruções nativas lidas automaticamente pelo GitHub Copilot no VS Code.

### 📑 2. Modelos e Templates (`/docs/templates/`)
* **[`SPEC.md`](./docs/templates/SPEC.md):** Modelo completo para especificação guiada por requisitos (SDD) com critérios de aceite em formato Gherkin e plano de execução em fases.
* **[`ADR.md`](./docs/templates/ADR.md):** Modelo para registro de decisões arquiteturais (Contexto, Forças, Decisão, Consequências e Alternativas).
* **[`README-PROJECT.md`](./docs/templates/README-PROJECT.md):** Template moderno e profissional para o README do seu novo projeto.

### 🛠️ 3. Configurações de Ambiente (`/.vscode`)
* **`settings.json`:** Formatação automática ao salvar, regras de quebra de linha e linter.
* **`extensions.json`:** Recomendações de extensões essenciais para produtividade.
* **`launch.json` & `tasks.json`:** Perfis de execução e compilação para depuração rápida.

### 🐙 4. Governança e Colaboração no GitHub (`/.github`)
* **`ISSUE_TEMPLATE/`:** Modelos estruturados para bug reports, feature requests e tarefas técnicas.
* **`PULL_REQUEST_TEMPLATE.md`:** Checklist de qualidade para abertura e revisão de PRs.
* **`CONTRIBUTING.md` & `CODE_OF_CONDUCT.md`:** Guias de contribuição e conduta comunitária.
* **`.editorconfig`:** Padronização de indentação e espaçamento entre diferentes IDEs e sistemas operacionais.

---

## 🚀 Como Usar este Starter Kit

### Opção A: Como Template Repository no GitHub (Recomendado)
1. No topo deste repositório no GitHub, clique no botão verde **"Use this template"** > **"Create a new repository"**.
2. Dê um nome ao seu novo projeto e clone-o na sua máquina.
3. Preencha a seção de comandos no `AGENTS.md` e adapte o `README.md` usando o modelo [`README-PROJECT.md`](./docs/templates/README-PROJECT.md).

### Opção B: Cópia Manual para Projeto Existente
1. Copie os arquivos de governança para o seu projeto:
   * `AGENTS.md` para a raiz.
   * Pastas `.vscode/` e `.github/` para a raiz.
   * Pasta `docs/templates/` para dentro do seu diretório `docs/`.
2. Adapte os arquivos à stack específica do seu projeto.

---

## 📄 Licença

Distribuído sob a licença [MIT](LICENSE).
