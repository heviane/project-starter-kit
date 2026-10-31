# Instruções do GitHub Copilot

Este repositório segue os padrões modernos de **Engenharia de Software Assistida por IA** e **Spec-Driven Development (SDD)**.

## Diretrizes Gerais
1. **Regras de Ouro:** Antes de iniciar qualquer desenvolvimento ou refatoração, leia e obedeça ao arquivo [`AGENTS.md`](../AGENTS.md) na raiz do projeto.
2. **Especificações:** Para implementar novas funcionalidades, consulte a especificação correspondente em `docs/specs/`. Não adivinhe requisitos.
3. **Padrão de Código:**
   - Priorize legibilidade, tipagem estrita e arquitetura limpa.
   - Trate erros de forma explícita com logs informativos.
   - Siga a convenção de commits [Conventional Commits](https://www.conventionalcommits.org/).
4. **Segurança:** Nunca inclua credenciais em código aberto. Utilize variáveis de ambiente com suporte a `.env.example`.

