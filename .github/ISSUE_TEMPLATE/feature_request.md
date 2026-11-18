---
name: ✨ Nova Funcionalidade (SPEC / SDD)
about: Proponha uma nova funcionalidade ou caso de uso orientado a especificação.
title: "[FEAT]: "
labels: [enhancement, sdd]
assignees: ''
---

### 🎯 Contexto e Valor de Negócio
Qual é a dor ou necessidade do usuário/cliente que esta funcionalidade resolve?

### 📋 Requisitos & Critérios de Aceite (BDD)
- [ ] **Dado** [contexto inicial], **Quando** [ação executada], **Então** [resultado esperado].
- [ ] **Dado** [cenário de borda/erro], **Quando** [ação inválida], **Então** [código/mensagem de erro].

### 📑 Especificação Técnica (SDD)
* **Spec Vinculada:** `docs/specs/SPEC-XXXX-[nome].md` *(se já criada ou a criar)*
* **Item do Backlog:** `[ex: CORE-01, API-02]`

### 🍰 Fatias Verticais de Implementação
- [ ] Fatia 1: Modelos de domínio e validações unitárias.
- [ ] Fatia 2: Caso de uso central (Core Business Logic).
- [ ] Fatia 3: Adaptadores de entrada/saída (Controller, persistência).
- [ ] Fatia 4: Teste integrado e documentação de contrato.
