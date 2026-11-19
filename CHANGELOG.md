# Changelog

Todas as alterações notáveis no `project-starter-kit` serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added
- Arquivo base `.env.example` na raiz do starter kit com suporte a cópia manual e hidratação dinâmica no bootstrap.

## [0.1.0] - 2026-11-19

### Added
- Governança canônica de engenharia com templates estruturados (`SPEC.md`, `ADR.md`, `BACKLOG.md`, `ANALYSIS-AI.md`, `AGENTS.md`, `CHANGELOG.md`).
- Diretórios canônicos de governança `docs/specs/` e `docs/adrs/`.
- Automação de bootstrap multiplataforma (`bootstrap.sh` e `bootstrap.ps1`) com modo interativo e não-interativo (`--non-interactive` / `-NonInteractive`).
- Tratamento de caracteres especiais (`escape_sed`), paridade de comandos da stack na Seção 7 do `AGENTS.md` e autolimpeza cirúrgica preservando scripts do usuário.
- Unificação do arquivo de governança do agente (`AGENTS.md`), removendo o template pós-hidratação para garantir arquivo canônico único na raiz do projeto derivado.
- Proteção defensiva contra sobrescrita indevida de `README.md` customizado pré-existente.
- Playbook de Engenharia em 5 fases para pair programming rigoroso com agentes de IA (`docs/playbook-engenharia-ia.md`).
- Glossário Canônico de Engenharia e IA (`docs/glossario-engenharia.md`).
- Pipeline de CI preventivo no GitHub Actions com detecção de segredos via Gitleaks e teste automatizado de bootstrap (`.github/workflows/ci.yml`).
- Allowlist blindada e restritiva no `.gitleaks.toml`, inspecionando rigorosamente `docs/specs/` e `docs/adrs/`.
- Template de Pull Request modernizado com rastreabilidade SDD e checklist de regras de ouro (`.github/PULL_REQUEST_TEMPLATE.md`).
- Padronização de ambiente multilinguagem (`.editorconfig`, `.vscode/settings.json`, `.vscode/tasks.json` e `.gitignore`).
