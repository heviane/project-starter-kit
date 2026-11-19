## 🎯 1. Propósito da Alteração

<!-- Descreva de forma clara o que este Pull Request implementa, corrige ou refatora. -->

* **Issue Vinculada:** Closes #[NUM]
* **Especificação Técnica (SDD):** `docs/specs/SPEC-XXXX-[nome].md` *(se aplicável)*
* **ADR Vinculada:** `docs/adrs/ADR-XXXX-[nome].md` *(se aplicável)*

---

## 🧪 2. Evidências de Validação (Conclusão por Evidências)

<!-- Descreva como as alterações foram validadas e anexe o resumo do resultado. -->
- [ ] **Testes Automatizados:** Suíte de testes executada e 100% verde via terminal.
- [ ] **Build:** Compilação do projeto concluída com sucesso e sem advertências críticas.

```text
[Cole aqui o trecho do log com o resultado dos testes, ex: "Tests run: 12, Failures: 0" ou "PASS ..."]
```

---

## 🛡️ 3. Checklist de Governança & Qualidade

Antes de abrir o PR para revisão, confirme os seguintes critérios:

- [ ] **Conformidade de Estilo:** Segue a padronização do `.editorconfig` e convenções da stack.
- [ ] **Segurança (Zero Segredos):** Nenhuma chave de API, senha, token ou credencial foi exposta.
- [ ] **Modificação Cirúrgica (Minimal Diff):** As edições tocam apenas o necessário, sem código incompleto (*Anti-Lazy Code*).
- [ ] **Commits Semânticos:** As mensagens de commit seguem o padrão *Conventional Commits* estabelecido no `AGENTS.md`.
- [ ] **Documentação Sincronizada:** Documentação, specs, contratos de API e changelog atualizados conforme a alteração.
