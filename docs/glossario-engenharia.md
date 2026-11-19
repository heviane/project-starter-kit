# Glossário — Engenharia de Software & Práticas de IA

> **Documento Vivo de Aprendizado, Alinhamento Conceitual & Engenharia**  
> Repositório: [`heviane/project-starter-kit`](https://github.com/heviane/project-starter-kit)  
> _Este glossário reúne termos fundamentais de gestão ágil, engenharia de software assistida por inteligência artificial e padrões de arquitetura e qualidade de código adotados neste repositório._

---

## 📌 Índice Temático

1. [Gestão de Projetos & Ciclo de Vida (SDLC)](#1-gestão-de-projetos--ciclo-de-vida-sdlc)
2. [Engenharia de Software Assistida por IA](#2-engenharia-de-software-assistida-por-ia)
3. [Qualidade, Testes & Padrões de Código](#3-qualidade-testes--padrões-de-código)

---

## 1. Gestão de Projetos & Ciclo de Vida (SDLC)

### Milestone (Marco de Entrega)

Um **Milestone** é um ponto de referência estratégico que agrupa um conjunto de entregas em direção a uma versão ou objetivo maior (por exemplo: `v0.1.0 - Incepção & Fundação` ou `v1.0.0 - MVP`).

- **Função prática:** Diferente de uma tarefa isolada (*Issue*), o Milestone atua como uma meta com barra de progresso visual percentual. Conforme as issues e pull requests vinculados são concluídos, o progresso avança até atingir 100%.

### Épico (Epic)

Uma iniciativa ou grande bloco de trabalho que é amplo demais para ser implementado em uma única tarefa. No gerenciamento moderno, o épico é decomposto em histórias de usuário ou fatias verticais menores (ex.: *Épico 1: Arquitetura Técnica & Decisões Fundamentais*).

### Fatias Verticais (Vertical Slices)

Técnica de decomposição de funcionalidades em que cada incremento implementa uma fração estreita, mas completa, atravessando todas as camadas do sistema (Domínio -> Caso de Uso Core -> Adaptadores de Entrada/Saída -> Teste de Integração).

- **Benefício:** Ao contrário de entregas horizontais em camadas (ex.: criar todas as tabelas do banco primeiro para só depois fazer as rotas), a fatia vertical entrega valor funcional testável de ponta a ponta desde o primeiro incremento.

### Walking Skeleton (Esqueleto Funcional)

A menor implementação ponta a ponta (*end-to-end*) possível da arquitetura de um sistema, construída no início do projeto para interligar todas as camadas principais (banco, backend, rotas e pipeline de build). Não possui regras de negócio completas, mas prova que a infraestrutura, o deploy e a comunicação básica funcionam perfeitamente.

### Docs-as-Code (Documentação como Código)

A prática de gerenciar documentação técnica (backlog, arquitetura, manuais, especificações) utilizando as mesmas ferramentas e processos do código-fonte: arquivos em Markdown (`.md`), controle de versão com Git, revisões via Pull Request e publicação automatizada.

### WIP (Work in Progress)

A quantidade de tarefas que foram iniciadas, mas ainda não estão finalizadas. Um dos princípios centrais do Kanban é limitar o WIP para evitar gargalos, alternância excessiva de contexto (*context switching*) e entregas incompletas.

### Definition of Done (DoD - Critério de Conclusão)

Checklist acordado e mensurável que define quando uma tarefa ou especificação pode ser considerada oficialmente concluída. No ecossistema deste kit, inclui: suíte de testes automatizados verde, build limpo, ausência de segredos detectados por varredura de segurança, OpenAPI/README atualizados e status marcado no backlog.

### Definition of Ready (DoR - Critério de Prontidão)

Conjunto de condições mínimas que uma especificação ou tarefa deve atender antes de ser iniciada a implementação. Garante que os requisitos funcionais, critérios de aceite BDD e casos de borda estejam compreendidos e validados pela liderança técnica humana antes de qualquer linha de código ser escrita.

---

## 2. Engenharia de Software Assistida por IA

### SDD (Spec-Driven Development)

*Desenvolvimento Orientado a Especificações.* Abordagem metodológica em que nenhuma linha de funcionalidade é codificada antes de uma especificação clara ([`docs/templates/SPEC.md`](./templates/SPEC.md)) descrevendo os requisitos funcionais, critérios de aceite em linguagem ubíqua (BDD/Gherkin) e modos de falha. Isso impede que o modelo de IA tome premissas equivocadas ou invente regras de negócio.

### ADR (Architecture Decision Record)

*Registro de Decisão Arquitetural.* Documento curto e padronizado ([`docs/templates/ADR.md`](./templates/ADR.md)) que captura uma decisão técnica importante, o contexto e as forças que a motivaram, as alternativas avaliadas, os *trade-offs* (consequências positivas e negativas) aceitos pelo time e os gatilhos explícitos de reavaliação (*Review Triggers*).

### Human-in-the-Loop (HITL)

Princípio operacional e regra de ouro fundamental em que o agente de inteligência artificial atua sob tutela estrita: o modelo **sempre apresenta o plano técnico** e aguarda aprovação explícita do desenvolvedor humano antes de alterar arquivos em disco, executar mutações de ambiente ou realizar commits/pushes.

### Anti-Lazy Code (Implementação Completa)

Diretriz operacional que proíbe expressamente o modelo de IA de emitir código com reticências, comentários de atalho (`// ... restante da função ...`) ou implementações parciais. O agente deve entregar código cirúrgico, funcional e imediatamente compilável.

### Minimal Diff (Edição Cirúrgica)

Princípio de modificação pontual e estrita do código, limitando a edição às linhas estritamente necessárias para cumprir o critério de aceite. Preserva formatações preexistentes, convenções do repositório e comentários, sem reescrever arquivos inteiros desnecessariamente.

### Conclusão Baseada em Evidências (Evidence-Based Completion)

Postura técnica rigorosa em que o agente de IA nunca presume que uma tarefa está pronta pelo simples fato de ter editado o arquivo. A conclusão exige evidência empírica fornecida pela execução bem-sucedida da suíte de testes automatizados e do build do projeto via terminal.

### Multi-Model Review (Auditoria Cruzada Multi-IA)

Prática descrita na Fase 4 do [`docs/playbook-engenharia-ia.md`](./playbook-engenharia-ia.md) que consiste em submeter o código ou especificações a um segundo modelo de IA independente (ex.: Claude, GPT, DeepSeek, Gemini) utilizando o template [`docs/templates/ANALYSIS-AI.md`](./templates/ANALYSIS-AI.md). A auditoria cruzada elimina pontos cegos e viés cognitivo inerentes a um único modelo.

### Context Window (Janela de Contexto)

O limite máximo de dados (tokens de texto, código e instruções) que um modelo de linguagem (LLM) consegue processar simultaneamente em uma única interação. O uso de documentação em disco como memória externa ([`AGENTS.md`](../AGENTS.md), `SPEC.md`, `backlog.md`) evita o esquecimento de decisões arquiteturais por estouro ou degradação de contexto.

### Alucinação da IA (AI Hallucination) & Mitigação por Contexto

Fenômeno em que um modelo de IA gera informações factualmente incorretas, inventa parâmetros de APIs ou sugere bibliotecas inexistentes com alta confiança aparente. No desenvolvimento de software, a mitigação definitiva da alucinação é obtida através de restrições explícitas de contexto (SDD, contratos de interface e testes automatizados imediatos).

### Pair Programming com IA

Metodologia de trabalho colaborativo em que a pessoa desenvolvedora humana atua como condutora estratégica e revisora técnica (*Tech Lead / Navigator*), enquanto o agente de inteligência artificial opera como engenheiro de software sênior de suporte operacional (*Senior Pair / Driver*), acelerando implementações com alto rigor de qualidade.

---

## 3. Qualidade, Testes & Padrões de Código

### TDD (Test-Driven Development)

*Desenvolvimento Guiado por Testes.* Prática em que o desenvolvedor (ou agente) escreve primeiro o teste automatizado que falha (*Red*), implementa a quantidade mínima de código para fazê-lo passar (*Green*) e, por fim, refatora o design preservando o comportamento funcional (*Refactor*).

### Critérios de Aceite BDD (Given / When / Then)

Padrão estruturado de escrita em linguagem ubíqua:
* **Dado (*Given*):** O estado inicial ou pré-condição do sistema.
* **Quando (*When*):** A ação, requisição ou evento executado.
* **Então (*Then*):** O resultado esperado, código de retorno e efeitos observáveis.

### Modos de Falha (Failure Modes)

Seção obrigatória de robustez técnica em que se antecipa explicitamente o comportamento do sistema diante de adversidades: tratamento de indisponibilidade de serviços externos (timeouts, circuit breakers), payloads malformados, duplicidade de requisições e falhas de persistência.

### Idempotência

Propriedade técnica em que uma mesma requisição pode ser submetida repetidas vezes sem alterar o resultado além da primeira chamada e sem gerar efeitos colaterais duplicados (ex.: uso de chaves de idempotência em transações financeiras ou criação de pedidos).

### Conventional Commits

Convenção padronizada para mensagens de commit no Git que utiliza prefixos semânticos estruturados (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`, `perf:`), facilitando a geração automática de changelogs, rastreabilidade e versionamento semântico.

### Arquitetura Hexagonal (Ports & Adapters)

Padrão arquitetural que visa isolar a lógica de negócio central (Core de Domínio) de tecnologias externas (frameworks web, bancos de dados, mensageria). A comunicação entre o Core e o mundo exterior é intermediada por contratos abstratos (*Portas*) e implementações técnicas concretas (*Adaptadores*).

### ACL (Anti-Corruption Layer / Camada Anticorrupção)

Padrão de integração que atua como um tradutor intermediário entre dois sistemas ou subsistemas com modelos conceituais distintos. Converte contratos externos para o modelo do novo domínio (e vice-versa), garantindo que débitos técnicos ou formatos legados não poluam a pureza do Core da aplicação.
