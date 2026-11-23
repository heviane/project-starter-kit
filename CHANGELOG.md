# Changelog

Todas as alterações notáveis no `project-starter-kit` serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added

- Arquivo base `.env.example` na raiz do starter kit com suporte a cópia manual e hidratação dinâmica no bootstrap.
- Diretrizes operacionais avançadas em `docs/templates/AGENTS.md` e `AGENTS.md` (portão de aprovação de spec, cobertura de modos de falha, preservação defensiva de ativos e integridade multiplataforma/encoding).
- Arquivo base `.gitleaksignore` na raiz e suporte à inicialização limpa no bootstrap para gestão de falsos positivos históricos.
- Scripts utilitários de execução local segura (`scripts/run-local.ps1.example` e `run-local.sh.example`) com carregamento de ambiente `.env`, blindagem preventiva no `.gitignore` e hidratação no bootstrap.
- Arquivo `.gitattributes` para normalização canônica de quebras de linha (LF universal e CRLF para scripts Windows).
- Adaptadores multi-agente enxutos (`CLAUDE.md` e `.cursor/rules/sdd.mdc`) com apontamento centralizado para `@AGENTS.md` (compatibilidade nativa com Claude Code e Cursor AI).

### Changed

- Padronização canônica de todos os marcadores e placeholders em `[UPPER_SNAKE_CASE]` (ex.: `[NOME_DO_PROJETO]`, `[DESCRICAO_DO_PROJETO]`, `[ORGANIZACAO_OU_USUARIO]`, `[TECNOLOGIAS_UTILIZADAS]`) em todos os templates (`docs/templates/` e `docs/reviews/templates/`), configurações de editor (`.vscode/tasks.json`), scripts de bootstrap (`scripts/bootstrap.ps1` e `scripts/bootstrap.sh`) e workflow de CI (`.github/workflows/ci.yml`).
- Limpeza e calibração estrita do `.gitleaks.toml` (remoção de caminhos órfãos e hash de commit alheio) com paridade nos scripts de bootstrap.

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
