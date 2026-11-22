# AI-Assisted Project Starter Kit & Standards

> **Base operacional padronizada para inicialização acelerada de novos projetos de software, com suporte nativo a Desenvolvimento Assistido por IA, Spec-Driven Development (SDD), Playbook Metodológico e Governança Docs-as-Code.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/heviane/project-starter-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/heviane/project-starter-kit/actions/workflows/ci.yml)
[![Version](https://img.shields.io/badge/version-v0.1.0--mvp-blue.svg)](CHANGELOG.md)
[![Security: Gitleaks](https://img.shields.io/badge/Security-Gitleaks-green.svg)](.gitleaks.toml)

---

## 🎯 Por que este Starter Kit?

Iniciar um novo projeto de software hoje não significa apenas configurar linters e editores: significa **alinhar a colaboração entre desenvolvedores humanos e agentes de IA com controle absoluto de qualidade**.

Este repositório fornece a base operacional completa para garantir que:
1. **Agentes de IA** (Antigravity, Copilot, Claude Code, Cursor, Windsurf) sigam padrões estritos de arquitetura, segurança, testes e commits antes de sugerir código.
2. O time adote **Spec-Driven Development (SDD)**, com fatias verticais e critérios BDD/Gherkin antes da codificação.
3. Decisões arquiteturais sejam formalizadas via **ADRs (Architecture Decision Records)** com gatilhos explícitos de reavaliação.
4. O arranque do projeto seja **zero atrito**, utilizando scripts de inicialização inteligente (*Bootstrapping*) que personalizam o repositório e removem arquivos temporários automaticamente.

---

## 📂 O que está incluído?

### 🤖 1. Camada de Inteligência Artificial & Governança
* **[`AGENTS.md`](./AGENTS.md):** Contrato operacional universal em duas camadas: Regras de Ouro Universais (*Human-in-the-Loop*, *Anti-Lazy Code*, *Minimal Diff*, *Conclusão por Evidências*) e seção plugável de regras de domínio.
* **[`.github/copilot-instructions.md`](./.github/copilot-instructions.md):** Integração nativa para GitHub Copilot referenciando o `AGENTS.md`.
* **[`docs/playbook-engenharia-ia.md`](./docs/playbook-engenharia-ia.md):** *The AI-Aided Software Engineering Playbook* — o guia em 5 fases para conduzir o agente do commit zero até a produção.
* **[`docs/glossario-engenharia.md`](./docs/glossario-engenharia.md):** Glossário técnico com alinhamento conceitual sobre SDLC, Engenharia de Software Assistida por IA e Padrões de Qualidade.

### 📑 2. Modelos e Templates Refinados (`/docs/templates/`)
* **[`SPEC.md`](./docs/templates/SPEC.md):** Modelo completo para especificação guiada por requisitos (SDD) com fatias verticais, modos de falha (*Failure Modes*) e Definition of Done (DoD).
* **[`ADR.md`](./docs/templates/ADR.md):** Registro de decisões arquiteturais com tabela de alternativas e gatilhos de reavaliação (*Review Triggers*).
* **[`BACKLOG.md`](./docs/templates/BACKLOG.md):** Roadmap vivo Docs-as-Code com taxonomia de IDs (`SET-`, `CORE-`, `API-`, `OPS-`).
* **[`docs/reviews/`](./docs/reviews/):** Módulo e guia operacional do **Multi-Agent Review Framework (MARF)** para auditorias cruzadas com múltiplos modelos de IA, contendo seus templates dedicados em [`docs/reviews/templates/`](./docs/reviews/templates/):
  * [`REVIEW_BRIEFING_TEMPLATE.md`](./docs/reviews/templates/REVIEW_BRIEFING_TEMPLATE.md) (briefing)
  * [`AI_REVIEW_TEMPLATE.md`](./docs/reviews/templates/AI_REVIEW_TEMPLATE.md) (parecer individual)
  * [`MASTER_ACTION_PLAN_TEMPLATE.md`](./docs/reviews/templates/MASTER_ACTION_PLAN_TEMPLATE.md) (dossiê mestre consolidador em lotes dinâmicos `1..N`)
* **[`AGENTS.md`](./docs/templates/AGENTS.md):** Template universal para instanciar diretrizes em novos projetos.
* **[`README-PROJECT.md`](./docs/templates/README-PROJECT.md):** Template moderno e profissional para o README do seu novo projeto.

### ⚡ 3. Scripts de Inicialização Inteligente (`/scripts`)
* **`scripts/bootstrap.ps1` (Windows / PowerShell):** Coleta interativa de metadados, hidratação automática de `README.md`, `AGENTS.md` e `docs/backlog.md`, com opção de autolimpeza dos scripts de bootstrap.
* **`scripts/bootstrap.sh` (Linux / macOS / Bash):** Script equivalente em Bash para inicialização automatizada em sistemas Unix.

### 🛠️ 4. Configurações de Ambiente (`/.vscode`)
* **`settings.json`:** Formatação automática ao salvar, quebra de linha LF, ruler e regras de encoding UTF-8.
* **`extensions.json`:** Recomendações de extensões essenciais para produtividade e qualidade.
* **`launch.json` & `tasks.json`:** Perfis de execução e compilação para depuração rápida.

### 🛡️ 5. Segurança, CI & Colaboração no GitHub
* **`.github/workflows/ci.yml`:** Pipeline de CI com detecção de segredos via Gitleaks.
* **`.editorconfig`:** Padronização multiplataforma de indentação e espaçamento.
* **`.gitignore` Defensivo:** Bloqueio preemptivo de certificados (`*.p12`, `*.key`), segredos (`.env*`) e artefatos de múltiplas linguagens (Java, Node, Python, .NET).
* **`ISSUE_TEMPLATE/` & `PULL_REQUEST_TEMPLATE.md`:** Modelos estruturados para issues e checklist rigoroso de revisão de PRs.

---

## 🚀 Como Usar este Starter Kit

### Opção A: Como Template Repository no GitHub (Recomendado)

1. No topo deste repositório no GitHub, clique no botão verde **"Use this template"** > **"Create a new repository"**.
2. Dê um nome ao seu novo projeto e clone-o na sua máquina.
3. Abra o terminal na raiz do novo projeto e execute o script de inicialização:
   * **No Windows (PowerShell):**
     ```powershell
     .\scripts\bootstrap.ps1
     ```
   * **No Linux/macOS (Bash):**
     ```bash
     chmod +x ./scripts/bootstrap.sh
     ./scripts/bootstrap.sh
     ```
4. O script solicitará o nome, descrição e stack tecnológica, gerando os arquivos customizados e removendo os scripts de bootstrap para deixar o repositório limpo.

### Opção B: Cópia Manual para Projeto Existente
1. Copie as pastas `.vscode/`, `.github/` e `docs/templates/` para a raiz do seu projeto.
2. Copie o `AGENTS.md` para a raiz e adapte as seções de stack e regras de domínio.

---

## 📄 Licença

Distribuído sob a licença [MIT](LICENSE).
