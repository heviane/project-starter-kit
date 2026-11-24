# 🛡️ Guia de Segurança & Guardrails para Agentes de IA

> **Padrões Corporativos de Defesa em Profundidade, Sandboxing e Mitigação de Riscos no Desenvolvimento Assistido por IA**  
> **Repositório Base:** [`heviane/project-starter-kit`](https://github.com/heviane/project-starter-kit) &bull; **Framework:** AI-SEP / SDD  
> **Conformidade:** Alinhado às diretrizes do **OWASP Top 10 for LLMs / AI Agents** e **NIST AI Risk Management Framework**.

---

## 📑 Sumário

- [1. 🎯 Visão Geral & Modelo de Defesa em Profundidade](#1--visão-geral--modelo-de-defesa-em-profundidade)
- [2. 🔐 Camada 1: Blindagem de Segredos & Prevenção de Vazamento (Zero Secrets)](#2--camada-1-blindagem-de-segredos--prevenção-de-vazamento-zero-secrets)
- [3. 🛡️ Camada 2: Proteção de Infraestrutura de Código (Branch Protection)](#3-️-camada-2-proteção-de-infraestrutura-de-código-branch-protection)
- [4. ⚡ Camada 3: Matriz de Permissões de Comandos (Allowlist vs. HITL)](#4--camada-3-matriz-de-permissões-de-comandos-allowlist-vs-hitl)
- [5. 📦 Camada 4: Segregação Física de Contexto & Sandboxing (Containers)](#5--camada-4-segregação-física-de-contexto--sandboxing-containers)
- [6. 📋 Checklist de Prontidão de Segurança em 5 Minutos](#6--checklist-de-prontidão-de-segurança-em-5-minutos)
- [7. 🔄 Evolução Futura & Próximos Tópicos](#7--evolução-futura--próximos-tópicos)
- [8. 🔗 Conexões & Governança](#8--conexões--governança)

---

## 1. 🎯 Visão Geral & Modelo de Defesa em Profundidade

O desenvolvimento de software assistido por agentes autônomos de inteligência artificial (Google Antigravity, Claude Code, GitHub Copilot, Cursor, Aider) oferece ganhos substanciais de produtividade. No entanto, conceder capacidade de execução de comandos de terminal, manipulação de arquivos e chamadas de rede a modelos probabilísticos exige uma abordagem técnica estruturada de **Defesa em Profundidade (_Defense in Depth_)**.

```text
┌────────────────────────────────────────────────────────────────────────┐
│                      DEFESA EM PROFUNDIDADE (AI AGENTS)                │
├────────────────────────────────────────────────────────────────────────┤
│  [CAMADA 4] Segregação Física & Sandboxing (Dev Containers / Docker)    │
│    └─► [CAMADA 3] Matriz de Permissões & Allowlist (Comandos Seguros)  │
│          └─► [CAMADA 2] Branch Protection no Git (Bloqueio da Main)    │
│                └─► [CAMADA 1] Blindagem de Segredos (Zero Secrets)     │
│                      └─► [NÚCLEO] Agente de IA em Operação             │
└────────────────────────────────────────────────────────────────────────┘
```

O objetivo central desta arquitetura é assegurar o princípio do **_Blast Radius Zero_ (Raio de Destruição Zero)**: mesmo que o modelo de IA sofra uma alucinação severa, interprete incorretamente um comando ou execute código defeituoso, as salvaguardas concêntricas impedem que o dano atinja a máquina pessoal da pessoa desenvolvedora, os repositórios remotos de produção ou credenciais confidenciais.

---

## 2. 🔐 Camada 1: Blindagem de Segredos & Prevenção de Vazamento (Zero Secrets)

> **Risco OWASP Mitigado:** _LLM06: Sensitive Information Disclosure_ (Exposição Indevida de Informações Sensíveis).

Os agentes de IA operam lendo o contexto de arquivos locais, histórico de conversas e variáveis de ambiente para planejar soluções. Se dados sensíveis estiverem desprotegidos, eles podem ser acidentalmente indexados no contexto e transmitidos aos servidores de inferência.

### Diretrizes Mandatórias de Proteção de Segredos:

1. **Proibição Absoluta de Credenciais em Código:**  
   Chaves de API, senhas de banco de dados, tokens pessoais (PATs) e certificados digitais **nunca** devem ser comitados ou mantidos em arquivos acessíveis sem `.gitignore`.
2. **Padrão Obrigatório `.env.example`:**  
   Todos os repositórios devem conter um arquivo `.env.example` documentando os nomes das variáveis necessárias, utilizando exclusivamente marcadores canônicos padronizados:

   ```bash
   DATABASE_URL=postgresql://user:password@localhost:5432/app_db
   API_KEY=[CHAVE_DE_API_MOCK]
   JWT_SECRET=[SEGREDO_JWT_TEMPORARIO]
   ```

3. **Varredura Preventiva Contínua com Gitleaks:**  
   Manter a ferramenta Gitleaks configurada na raiz (`.gitleaks.toml`) e executada automaticamente no pipeline de CI em todo Pull Request:

   ```yaml
   - name: Run Gitleaks
     uses: gitleaks/gitleaks-action@v2
     env:
       GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
   ```

4. **Higiene de Terminal e Histórico:**  
   Evitar passar senhas ou tokens como argumentos de linha de comando (ex.: `--password meu_token`), pois agentes podem inspecionar o histórico do shell ou saídas de log.

---

## 3. 🛡️ Camada 2: Proteção de Infraestrutura de Código (Branch Protection)

> **Risco Mitigado:** Destruição acidental de código em produção, histórico Git corrompido ou force-pushes indevidos.

A proteção da branch principal (`main` ou `master`) é imposta pelo servidor Git remoto (GitHub/GitLab) e atua como uma barreira física inviolável que não pode ser contornada por comandos do agente local.

### Configuração Recomendada de Ruleset no GitHub (Settings $\rightarrow$ Rules $\rightarrow$ Rulesets):

- **Alvo de Proteção:** Branch padrão (`main`).
- **Require a Pull Request before merging:** Obrigatório. Todo código deve ser entregue via PR para revisão e auditoria humana.
- **Require status checks to pass:** Obrigatório. O merge só é autorizado se todos os quality gates automatizados estiverem verdes:
  - Varredura de segredos (Gitleaks).
  - Suíte de testes unitários e de integração.
  - Análise estática e validação de linting (`markdownlint`, `eslint`, etc.).
- **Block Force Pushes:** Ativado compulsoriamente. Impede `git push --force`.
- **Restrict Deletions:** Ativado compulsoriamente. Impede exclusão acidental da branch principal.

### Workflow Operacional do Agente:

O agente **nunca** deve comitar ou fazer push direto na branch `main`. Toda tarefa significativa deve seguir o fluxo de ramificação:
$$\text{main} \longrightarrow \text{feat/nome-da-tarefa} \longrightarrow \text{Pull Request} \longrightarrow \text{Revisão Humana} \longrightarrow \text{Merge}$$

---

## 4. ⚡ Camada 3: Matriz de Permissões de Comandos (Allowlist vs. HITL)

> **Risco OWASP Mitigado:** _LLM08: Excessive Agency_ (Autonomia Excessiva de Execução).

Para eliminar a necessidade de confirmações manuais repetitivas a cada segundo sem abrir mão da segurança, adota-se o **Princípio do Menor Privilégio (_Least Privilege_)** através de uma matriz clara de comandos.

### Matriz de Categorização de Comandos:

| Categoria | Nível de Autonomia | Exemplos de Comandos | Comportamento do Agente |
| :--- | :---: | :--- | :--- |
| **Leitura & Inspeção** | `🟢 Total (Auto-Approve)` | `git status`, `git diff`, `git log`, `Get-ChildItem`, `ls`, `cat`, `Test-Path` | Execução autônoma sem pausas ou confirmação. |
| **Qualidade & Testes** | `🟢 Total (Auto-Approve)` | `npx markdownlint-cli2`, `npm test`, `pytest`, `mvn test`, `dotnet test`, `bats` | Execução autônoma para ciclos rápidos de TDD. |
| **Mutação Segura** | `🟡 Supervisionado` | `git add`, `git commit`, `git checkout -b`, `npm install` (pacotes declarados) | Plano apresentado e aprovado no início do ciclo. |
| **Ações Críticas / Destrutivas** | `🔴 Confirmação Obrigatória (HITL)` | `rm -rf`, `git push --force`, `DROP TABLE`, `TRUNCATE`, exclusão de branches remotas | **Bloqueio mandatório:** Exige consentimento humano explícito antes de rodar. |

### Prática de Execução com Simulação (_Dry-Run_):

Scripts de automação corporativos devem implementar suporte nativo a flags de simulação prévia:

- **PowerShell:** Parâmetro nativo `-WhatIf`.
- **Bash / Shell:** Parâmetro `--dry-run`.

O agente deve prioritariamente rodar o comando no modo de simulação para auditoria visual antes de executar a mutação concreta no ambiente.

---

## 5. 📦 Camada 4: Segregação Física de Contexto & Sandboxing (Containers)

> **Risco Mitigado:** Acesso indevido ao sistema de arquivos do computador host, vazamento de documentos pessoais ou quebra de dependências locais.

A camada mais externa e resiliente de isolamento consiste em confinar a execução do agente de IA dentro de um ambiente descartável.

### A. Segregação de Diretórios Locais ([ADR-002](https://github.com/heviane/heviane/blob/main/meta-hub/adrs/002-segregacao-dados-sensiveis-multi-root-workspaces.md))

Em conformidade com a arquitetura estabelecida na ADR-002, o ecossistema adota separação estrita de armazenamentos:

- **Metadiretório de Código (`E:\Projects\GitHub`):** Contém exclusivamente projetos rastreados em Git e públicos/abertos.
- **Cofre em Nuvem (`H:\My Drive\Workspace Root Local`):** Contém anotações pessoais, pesquisas de mercado, estratégias de carreira e dados privados que **nunca** devem ser acessados por agentes atuando em código público.

### B. Sandboxing com VS Code Dev Containers (Padrão-Ouro de Isolamento)

A utilização da extensão oficial **VS Code Dev Containers** (`ms-vscode-remote.remote-containers`) permite instanciar contêineres Docker dedicados para cada repositório:

1. **Isolamento de Host:** O agente e o runtime da aplicação (Java, .NET, Node, Python) executam exclusivamente dentro do contêiner Linux. O agente **não tem acesso** aos discos físicos do Windows (`C:\`, `D:\`), arquivos pessoais ou unidades em nuvem.
2. **Ambiente Efêmero e Descartável:** Em caso de corrupção de ambiente ou instalação indevida de pacotes pelo modelo, o contêiner pode ser destruído e reconstruído em poucos segundos a partir da definição declarativa (`.devcontainer/devcontainer.json`).
3. **Autonomia com Segurança Máxima:** Dentro de um Dev Container devidamente isolado, é seguro conceder ao agente o modo de execução totalmente autônomo, pois o ambiente é uma "caixa de areia" estéril.

---

## 6. 📋 Checklist de Prontidão de Segurança em 5 Minutos

Antes de iniciar qualquer ciclo de desenvolvimento com agentes autônomos em um repositório, execute esta checagem rápida:

| Item | Ponto de Controle | Ação de Validação | Status |
| :---: | :--- | :--- | :---: |
| **1** | **Presença de `.gitignore`** | Verificar se `.env`, certificados (`.pem`, `.pfx`), `node_modules` e binários estão ignorados. | [ ] |
| **2** | **Sanitização de `.env.example`** | Confirmar que todas as variáveis requeridas possuem valores fictícios ou placeholders. | [ ] |
| **3** | **Branch de Trabalho Ativa** | Certificar-se de que o trabalho será conduzido em uma branch de feature (`feat/...`), nunca na `main`. | [ ] |
| **4** | **Ruleset Remoto Ativo** | Confirmar no GitHub se a branch `main` possui bloqueio de force-push e exigência de PR. | [ ] |
| **5** | **Gitleaks Ativo em CI** | Garantir que o workflow `.github/workflows/ci.yml` contém a etapa de detecção de segredos. | [ ] |

---

## 7. 🔄 Evolução Futura & Próximos Tópicos

Este guia é um documento vivo que será expandido nas próximas iterações do starter kit com:

- **Mitigação de Alucinação de Pacotes (_Package Hallucination_):** Diretrizes para verificação de dependências em registros oficiais (npm, Maven Central, NuGet, PyPI) antes de autorizar instalações sugeridas por IA.
- **Modelos Canônicos de `.devcontainer/` por Stack:** Templates prontos para inicialização instantânea de Dev Containers para Java, .NET, Node e Python.
- **Políticas de Governança de Tokens e Custos:** Diretrizes de rate-limiting e observabilidade de consumo de APIs de IA.

---

## 8. 🔗 Conexões & Governança

- 📘 **Playbook de Engenharia com IA:** [`docs/playbook-engenharia-ia.md`](./playbook-engenharia-ia.md)
- 🤖 **Contrato de IA do Repositório:** [`AGENTS.md`](../AGENTS.md)
- 📚 **Glossário de Engenharia:** [`docs/glossario-engenharia.md`](./glossario-engenharia.md)
- 🏛️ **Central de Governança Meta-Hub:** [`heviane/heviane/meta-hub/`](https://github.com/heviane/heviane/tree/main/meta-hub)
