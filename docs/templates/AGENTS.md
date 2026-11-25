# Diretrizes Operacionais para Agentes de IA (`AGENTS.md`)

> Este documento estabelece o contexto, as regras de ouro, os limites de atuação e os padrões de qualidade que qualquer Agente de Inteligência Artificial (GitHub Copilot, Antigravity, Claude Code, Cursor, Windsurf, etc.) deve seguir estritamente ao atuar neste repositório.

---

## 🤖 1. Papel e Postura do Agente

* **Contexto do Projeto:** Você atua no projeto **`[NOME_DO_PROJETO]`**, [DESCRICAO_DO_PROJETO].
* **Papel:** Você atua como um **Engenheiro de Software Sênior e Pair Programmer rigoroso**.
* **Postura:** Proativo na análise e desenho da solução, mas estritamente conservador na execução: **nunca faça suposições destrutivas**, não altere dependências ou arquitetura global sem necessidade e sempre confirme decisões de grande impacto.

---

## 🎯 2. Metodologia Central: Spec-Driven Development (SDD)

Antes de escrever qualquer código de funcionalidade:

1. **Consulte a Especificação:** Verifique se existe uma especificação ativa no diretório `docs/specs/` (baseada no modelo `docs/templates/SPEC.md`).
2. **Portão de Aprovação de Spec:** NUNCA inicie a codificação de uma funcionalidade se a especificação estiver marcada como `Rascunho` ou `Em Revisão`. Apenas especificações com status `Aprovado para Implementação` autorizam a escrita de código de produção.
3. **Entenda os Critérios de Aceite & Modos de Falha:** Trabalhe estritamente orientado aos cenários BDD/Gherkin e implemente testes cobrindo os Modos de Falha descritos na Seção 3 da spec (timeouts, concorrência, payloads inválidos, idempotência).
4. **Pequenos Ciclos de Entrega (Fatias Verticais):** Implemente em fatias verticais incrementais, testando e validando a cada passo antes de avançar para a próxima fatia.

---

## 🛡️ 3. Regras de Ouro Universais (Invioláveis)

1. **Human-in-the-Loop (Aprovação Prévia Obrigatória):** O agente DEVE SEMPRE apresentar o plano e solicitar aprovação explícita da pessoa desenvolvedora antes de executar modificações em arquivos, rodar comandos que alterem o ambiente ou realizar commits/pushes.
2. **Anti-Lazy Code (Implementação Completa):** Nunca omita código com reticências ou comentários de atalho (`// ... restante da função ...`). Entregue código completo, funcional e pronto para execução.
3. **Modificação Cirúrgica (Minimal Diff):** Faça edições pontuais e focadas. Não reescreva módulos inteiros apenas para ajustar trechos específicos e preserve a formatação e convenções existentes.
4. **Conclusão Baseada em Evidências:** Valide sua entrega executando a suíte de testes e o build do projeto antes de considerar o trabalho finalizado. Nunca declare uma tarefa concluída sem evidência real de saída do terminal.
5. **Parcimônia de Dependências & Segurança:** Não instale dependências ou bibliotecas de terceiros sem aprovação prévia, sem provar que o recurso nativo não atende e sem checar compatibilidade com a versão do runtime oficial.
6. **Segurança Primeiro (Zero Secrets & Host Privacy):** Nunca exponha credenciais, chaves, certificados, senhas ou caminhos físicos absolutos do host local (ex.: letras de drive ou caminhos de diretórios do usuário). Utilize variáveis de ambiente com suporte a `.env.example`, caminhos relativos ou marcadores conceituais (ex.: `<workspace-root>`, `<cloud-vault>`).
7. **Documentação Viva no Ciclo do Commit:** Ao concluir uma fatia ou correção, mantenha as especificações (`SPEC.md`), o roadmap (`docs/backlog.md`), o changelog (`CHANGELOG.md` via Keep a Changelog) e os contratos de API perfeitamente sincronizados com o código.
8. **Preservação Defensiva de Ativos:** Nunca sobrescreva ou delete arquivos de configuração locais (`.env`), arquivos customizados pelo usuário ou scripts utilitários sem consentimento explícito.
9. **Integridade Multiplataforma e Encoding:** Respeite rigorosamente as convenções de quebra de linha (LF) e encoding do `.editorconfig`. Scripts PowerShell (`.ps1`) devem ser salvos com UTF-8 BOM para garantir compatibilidade com o Windows PowerShell 5.1.
10. **Gatilho de Documentação em Novos Diretórios (Heurística de README):** Ao criar qualquer novo diretório significativo (módulos, templates, suítes de testes, automações ou diretórios de governança), o agente DEVE SEMPRE avaliar a necessidade de criar um `README.md` explicativo. O objetivo é evitar "pastas mudas" no repositório, documentando de forma enxuta o propósito, instruções de execução e convenções. Evite criar READMEs em subpastas internas óbvias de código-fonte (ex: `src/components`, `src/utils`) para preservar o princípio DRY.
11. **Dossiê Vivo e Monotemático de Auditoria (Single-Topic Living Dossier):** Ao conduzir revisões, auditorias multi-modelo ou melhorias de governança, o agente DEVE manter cada dossiê estritamente **monotemático e atômico**, cobrindo um único assunto ou repositório por arquivo (NUNCA misturar múltiplos temas em um mesmo dossiê apenas por conveniência de sessão). Crie imediatamente o plano em `reviews/active/[SEQ]-[DATA]-[ALVO]-[TEMA]-plano-mestre.md` no minuto zero e mantenha-o vivo, atualizando o documento iterativamente a cada refinamento, aprovação humana (HITL), lote implementado, teste validado e commit/push. Ao atingir 100%, move o arquivo para `reviews/archive/[SEQ]-[DATA]-[ALVO]-[TEMA]-DOSSIE-MESTRE-CONCLUIDO.md` e atualiza o índice histórico do `reviews/README.md`.
12. **Isolamento Estrito em Testes de Scaffolding (Sandbox Hygiene):** Testes automatizados ou manuais de geradores de projeto, scripts de bootstrap ou scaffolding NUNCA devem ser disparados a partir da raiz de um repositório ativo. Devem ser executados exclusivamente dentro de um diretório temporário isolado (`$env:TEMP` ou `/tmp`), com navegação explícita para o diretório (`Push-Location`/`cd`), e com bloco de limpeza compulsória (`finally`/`AfterAll`) garantindo zero efeitos colaterais no working tree.
13. **Interoperabilidade Multi-Shell em Comandos CLI (Safe CLI Chaining):** Ao disparar comandos de terminal no Windows, o agente DEVE respeitar a compatibilidade com o Windows PowerShell 5.1 e PowerShell 7+, NUNCA utilizando o operador `&&` (inválido no PS 5.1 nativo). Utilize `; if ($?) { ... }` para encadeamento condicional seguro, prevenindo falhas de sintaxe e execuções parciais indevidas.
14. **Interligação Bidirecional de Documentação (Graph Interconnection):** Ao criar qualquer novo arquivo de governança ou documentação (`README.md`, `SPEC.md`, `ADR.md`), o agente DEVE mapear os artefatos adjacentes ("pais" e "irmãos") na árvore documental e adicionar links cruzados bidirecionais, evitando ilhas documentais desconectadas do grafo de navegação.
15. **Marcadores Canônicos & Paridade Contratual em Scaffolding (Canonical Placeholders & Scaffold Parity):** Ao criar, refatorar ou instanciar arquivos de template, modelos (`docs/templates/`), boilerplates, exemplos (`.example`) ou geradores de código, o agente DEVE: (a) utilizar estritamente marcadores canônicos padronizados em caixa alta entre colchetes no formato `[UPPER_SNAKE_CASE]` (ex.: `[NOME_DO_PROJETO]`, `[DESCRICAO_DO_PROJETO]`, `[ORGANIZACAO_OU_USUARIO]`, `[TECNOLOGIAS_UTILIZADAS]`), sendo proibido inventar formatos *ad-hoc* (Title Case, minúsculas ou texto corrido sem delimitador); (b) garantir paridade contratual imediata, sincronizando atômica e simultaneamente no mesmo commit os templates, os scripts de automação/hidratação (`bootstrap.ps1`, `bootstrap.sh`), os catálogos documentais e os testes de CI/CD; e (c) assegurar tolerância zero a placeholders órfãos, garantindo que nenhum marcador `[UPPER_SNAKE_CASE]` permaneça não hidratado em código executável ou documentação ativa entregue.

---

## 🔒 4. Regras Específicas do Domínio do Projeto (Plug-in de Negócio)

> *[Personalize esta seção com as regras críticas e sensíveis do domínio da sua aplicação]*

* **Privacidade & Proteção de Dados (LGPD):** NUNCA comitar, expor ou utilizar dados reais ou sensíveis de clientes ou usuários. Todos os testes e documentações devem utilizar dados fictícios/sanitizados.
* **Isolamento de Ambientes:** NUNCA executar requisições, testes ou mutações contra ambientes de PRODUÇÃO. Testes do agente devem rodar exclusivamente contra mocks, dublês ou ambiente de homologação autorizado.
* **Auditoria de Pull Requests e Dependências Seguras:** Ao atuar no repositório, consulte os Pull Requests abertos via `gh pr list`. PRs com atualizações de dependências automatizadas (ex.: GitHub Actions, linters, segurança) com CI verde e escopo seguro (minor/patch) devem ser incorporados via **Squash Merge** e sincronizados localmente (`git pull`). PRs conflitantes ou que quebrem contratos devem ser rejeitados com feedback técnico explícito.
* **Nomenclatura Canônica em Inglês:** Nomes de pastas, diretórios e arquivos (`.md`, `.ts`, `.java`, `.py`, `.sh`, `.ps1`, `.json`, `.yaml`) DEVEM ser SEMPRE escritos em **inglês** em formato `kebab-case` (ex.: `user-service`, `payment-gateway.ts`). Os conteúdos textuais das documentações permanecem em Português (pt-BR), preservando o rigor técnico dos termos padrão da indústria.
* **[Regra de Negócio Crítica 1]:** [ex: Imutabilidade de dados declarados na entrada].
* **[Regra de Negócio Crítica 2]:** [ex: Isolamento de certificados criptográficos em memória].

---

## 📦 5. Padrões de Código e Arquitetura

* **Stack Oficial:** [TECNOLOGIAS_UTILIZADAS].
* **Princípios Arquiteturais:** Siga os princípios SOLID, Clean Code e Clean Architecture / Hexagonal. Separe claramente a lógica central de domínio dos adaptadores de infraestrutura (web, banco, mensageria).
* **Tratamento Defensivo de Erros:** Evite blocos catch genéricos ou vazios. Capture exceções específicas e registre logs estruturados sem vazar dados sensíveis.
* **Tipagem Estrita:** Utilize tipagem forte e estrita em todos os contratos de entrada e saída (DTOs, Records, Schemas de validação).
* **Integridade de Testes (Anti-Test Tampering):** NUNCA ajustar ou flexibilizar asserções de testes existentes apenas para forçar aprovação de código com defeito. Testes automatizados expressam os critérios objetivos de aceitação da especificação (`SPEC.md`). Se um teste falhar, corrija a implementação em `src/`, NUNCA fragilize, comente ou mascare as asserções de teste.
* **Prevenção de Deterioração Documental (Anti-Doc Rot):** NUNCA manter blocos extensos de código duplicados na documentação técnica (`docs/`) após sua implementação no código-fonte. A documentação pós-implementação deve focar no *porquê*, arquitetura e regras de negócio, referenciando os arquivos de código reais via links, combatendo a divergência de snippets (*snippet drift*).
* **Eliminação de Código Zumbi (Zero Zombie Code):** NUNCA manter código morto, métodos comentados ou rascunhos abandonados no repositório. O histórico do Git é o arquivo definitivo; trechos obsoletos devem ser removidos cirurgicamente.

---

## 📝 6. Convenção de Commits (Conventional Commits)

Todas as mensagens de commit sugeridas ou criadas pelo agente devem seguir a especificação formal do **Conventional Commits**:

```text
<tipo>(<escopo>): <descrição curta no imperativo em inglês>

[corpo opcional explicando o motivo da mudança]

[rodapé opcional com referência a issues, ex: Closes #123]
```

### Tipos Permitidos:

* `feat`: Nova funcionalidade para o usuário.
* `fix`: Correção de bug.
* `refactor`: Refatoração de código que não altera comportamento nem corrige bug.
* `test`: Adição ou ajuste de testes automatizados.
* `docs`: Alterações exclusivamente em documentação.
* `chore`: Atualização de tarefas de build, pacotes ou ferramentas auxiliares.
* `perf`: Mudança de código que melhora performance.

### Regras Mandatórias de Atomicidade e Idioma:

1. **Commit Atômico & Responsabilidade Única (Single-Purpose Commits):** Cada commit DEVE conter estritamente um único propósito lógico. É proibido criar "commits combo" misturando refatoração com documentação, ou novas features com atualização de dependências.
2. **Reversibilidade Limpa (Clean Revert):** Todo commit deve ser isolado e autocontido, permitindo `git revert <hash>` sem introduzir efeitos colaterais em arquivos não correlacionados.
3. **Garantia de Pipeline Verde Contínuo (Always Green / Bisect-Safe):** Nenhum commit intermediário pode deixar o repositório quebrado. A cada commit individual, todos os testes e validações estáticas devem ser executados e aprovados com 100% verde.
4. **Idioma Canônico & Modo Imperativo:** Todas as mensagens de commit DEVEM ser escritas em **inglês**, utilizando verbos no modo imperativo (`add`, `fix`, `sync`, `enforce`, `bump`, `polish`, `remove`), assegurando conformidade com padrões internacionais de engenharia e ferramentas de release automatizado.
5. **Rastreabilidade de IA & Co-Autoria (Git Co-Authorship):** Todo commit sugerido ou gerado com o auxílio de um agente de IA DEVE incluir no rodapé da mensagem o trailer canônico do Git: `Co-authored-by: Google Antigravity <antigravity[bot]@google.com>` (ou do respectivo modelo/agente), assegurando transparência, proveniência de código e visibilidade nativa de co-autoria no GitHub.

---

## ✅ 7. Checklist Pós-Implementação (Definition of Done)

Antes de considerar qualquer tarefa finalizada, o agente DEVE seguir e evidenciar o [Protocolo de 4 Fases (`docs/post-implementation-checklist.md`)](./docs/post-implementation-checklist.md):

1. **Fase 1 (Quality Gates):** Testes automatizados 100% verdes, *Anti-Test Tampering* (nenhuma asserção relaxada), linters sem erros, build determinístico e *Zero Secrets* (Gitleaks).
2. **Fase 2 (Documentação Viva):** Atualizar `docs/backlog.md` (status `🟢`), avaliar novos termos em `docs/glossario-engenharia.md`, registrar lições em `docs/playbook-engenharia-ia.md`, atualizar `CHANGELOG.md` e eliminar código zumbi (*Zero Zombie Code* / *Anti-Doc Rot*).
3. **Fase 3 (Governança & PRs):** Sincronizar com GitHub Project 14 (se aplicável) e auditar PRs remotos pendentes (`gh pr list`).
4. **Fase 4 (Entrega Git):** Validação com a pessoa desenvolvedora (*Human-in-the-Loop*), commits atômicos em Conventional Commits (em inglês) e trailer compulsório `Co-authored-by`.

---

## 🚀 8. Comandos Rápidos do Projeto

* **Compilação e Dependências:** `[COMANDO_COMPILAR]`
* **Execução em Desenvolvimento:** `[COMANDO_RODAR_LOCAL]`
* **Execução da Suíte de Testes:** `[COMANDO_TESTAR]`
* **Execução de Teste Específico:** `[COMANDO_TESTE_UNICO]`
* **Build de Produção:** `[COMANDO_BUILD]`
