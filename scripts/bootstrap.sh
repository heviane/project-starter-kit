#!/usr/bin/env bash
# ==============================================================================
# AI-Assisted Project Starter Kit — Script de Bootstrapping (Linux/macOS)
# ==============================================================================
set -euo pipefail

echo -e "\033[36m=====================================================================\033[0m"
echo -e "\033[36m🚀 AI-Assisted Project Starter Kit — Inicialização de Novo Projeto\033[0m"
echo -e "\033[36m=====================================================================\033[0m"
echo ""

NON_INTERACTIVE=${NON_INTERACTIVE:-false}
for arg in "$@"; do
  case $arg in
    --non-interactive|-y)
      NON_INTERACTIVE=true
      shift
      ;;
  esac
done

DEFAULT_NAME=$(basename "$PWD")
DEFAULT_OWNER=$(git config user.name 2>/dev/null || echo "")
[ -z "$DEFAULT_OWNER" ] && DEFAULT_OWNER="my-org"

if [ "$NON_INTERACTIVE" = true ]; then
  PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_NAME}
  PROJECT_DESC=${PROJECT_DESC:-"Sistema de alta qualidade desenvolvido com assistência de IA."}
  GITHUB_OWNER=${GITHUB_OWNER:-$DEFAULT_OWNER}
  STACK_OPTION=${STACK_OPTION:-"1"}

  if [[ "$GITHUB_OWNER" =~ ^[Hh]eviane ]]; then
    DEFAULT_PROJECT_LINK="https://github.com/users/heviane/projects/14"
  else
    DEFAULT_PROJECT_LINK="https://github.com/$GITHUB_OWNER/$PROJECT_NAME/projects"
  fi
  LINK_PROJECT=${LINK_PROJECT:-$DEFAULT_PROJECT_LINK}
else
  read -rp "Nome do novo projeto [$DEFAULT_NAME]: " PROJECT_NAME
  PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_NAME}

  read -rp "Breve descrição do valor do software: " PROJECT_DESC
  PROJECT_DESC=${PROJECT_DESC:-"Sistema de alta qualidade desenvolvido com assistência de IA."}

  read -rp "Usuário ou Organização do GitHub [$DEFAULT_OWNER]: " GITHUB_OWNER
  GITHUB_OWNER=${GITHUB_OWNER:-$DEFAULT_OWNER}

  if [[ "$GITHUB_OWNER" =~ ^[Hh]eviane ]]; then
    DEFAULT_PROJECT_LINK="https://github.com/users/heviane/projects/14"
  else
    DEFAULT_PROJECT_LINK="https://github.com/$GITHUB_OWNER/$PROJECT_NAME/projects"
  fi

  read -rp "URL do GitHub Project ou Kanban [$DEFAULT_PROJECT_LINK]: " LINK_PROJECT
  LINK_PROJECT=${LINK_PROJECT:-$DEFAULT_PROJECT_LINK}

  echo -e "\n\033[33mSelecione a Stack Tecnológica Principal:\033[0m"
  echo "  1) Java 17+ / Spring Boot 3 / Maven"
  echo "  2) Node.js 20+ / TypeScript / Vitest"
  echo "  3) Python 3.12+ / FastAPI / Pytest"
  echo "  4) .NET 9 / C# / xUnit"
  echo "  5) Personalizada / Agnóstica"
  read -rp "Opção [1-5, padrão: 1]: " STACK_OPTION
  STACK_OPTION=${STACK_OPTION:-"1"}
fi

case "$STACK_OPTION" in
  1)
    STACK_NAME="Java 17+, Spring Boot 3, Maven"
    CMD_COMPILE="./mvnw clean compile"
    CMD_RUN="./mvnw spring-boot:run"
    CMD_TEST="./mvnw clean test"
    CMD_TEST_SINGLE="./mvnw test -Dtest=NomeDoTeste"
    CMD_BUILD="./mvnw clean package"
    ;;
  2)
    STACK_NAME="Node.js 20+, TypeScript, Vitest"
    CMD_COMPILE="npm run build"
    CMD_RUN="npm run dev"
    CMD_TEST="npm test"
    CMD_TEST_SINGLE="npx vitest run caminho/do/teste.test.ts"
    CMD_BUILD="npm run build"
    ;;
  3)
    STACK_NAME="Python 3.12+, FastAPI, Pytest"
    CMD_COMPILE="poetry check"
    CMD_RUN="poetry run uvicorn main:app --reload"
    CMD_TEST="poetry run pytest"
    CMD_TEST_SINGLE="poetry run pytest tests/test_especifico.py"
    CMD_BUILD="poetry build"
    ;;
  4)
    STACK_NAME=".NET 9, C#, xUnit"
    CMD_COMPILE="dotnet build"
    CMD_RUN="dotnet run"
    CMD_TEST="dotnet test"
    CMD_TEST_SINGLE="dotnet test --filter FullyQualifiedName~NomeDoTeste"
    CMD_BUILD="dotnet publish -c Release"
    ;;
  *)
    STACK_NAME="Stack Customizada"
    CMD_COMPILE="[COMANDO_COMPILAR]"
    CMD_RUN="[COMANDO_RODAR_LOCAL]"
    CMD_TEST="[COMANDO_TESTAR]"
    CMD_TEST_SINGLE="[COMANDO_TESTE_UNICO]"
    CMD_BUILD="[COMANDO_BUILD]"
    ;;
esac

CURRENT_DATE=$(date +%Y-%m-%d)

# Função para escapar caracteres especiais no sed (delimitador /)
escape_sed() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

PROJECT_NAME_ESC=$(escape_sed "$PROJECT_NAME")
PROJECT_DESC_ESC=$(escape_sed "$PROJECT_DESC")
GITHUB_OWNER_ESC=$(escape_sed "$GITHUB_OWNER")
LINK_PROJECT_ESC=$(escape_sed "$LINK_PROJECT")
STACK_NAME_ESC=$(escape_sed "$STACK_NAME")
CMD_COMPILE_ESC=$(escape_sed "$CMD_COMPILE")
CMD_RUN_ESC=$(escape_sed "$CMD_RUN")
CMD_TEST_ESC=$(escape_sed "$CMD_TEST")
CMD_TEST_SINGLE_ESC=$(escape_sed "$CMD_TEST_SINGLE")
CMD_BUILD_ESC=$(escape_sed "$CMD_BUILD")

echo -e "\n\033[32m📝 Hidratando arquivos do projeto...\033[0m"

# 1. Garantir diretórios de governança
mkdir -p docs/specs docs/adrs
touch docs/specs/.gitkeep docs/adrs/.gitkeep

# 2. README.md
SHOULD_GENERATE_README=true
if [ -f "README.md" ] && ! grep -q "AI-Assisted Project Starter Kit" README.md; then
  if [ "$NON_INTERACTIVE" = false ]; then
    read -rp "Arquivo README.md já existe e parece personalizado. Deseja sobrescrever? (s/N): " OVERWRITE_README
    OVERWRITE_README=${OVERWRITE_README:-"n"}
    if [[ ! "$OVERWRITE_README" =~ ^[sSyY]$ ]]; then
      SHOULD_GENERATE_README=false
      echo -e "  \033[33m! README.md existente mantido sem alterações.\033[0m"
    fi
  fi
fi

if [ "$SHOULD_GENERATE_README" = true ] && [ -f "docs/templates/README-PROJECT.md" ]; then
  sed -e "s/\[NOME_DO_PROJETO\]/$PROJECT_NAME_ESC/g" \
      -e "s/\[DESCRICAO_DO_PROJETO\]/$PROJECT_DESC_ESC/g" \
      -e "s/\[ORGANIZACAO_OU_USUARIO\]/$GITHUB_OWNER_ESC/g" \
      -e "s/\[TECNOLOGIAS_UTILIZADAS\]/$STACK_NAME_ESC/g" \
      docs/templates/README-PROJECT.md > README.md
  echo -e "  \033[36m✓ README.md gerado com sucesso.\033[0m"
fi

# 3. AGENTS.md
if [ -f "docs/templates/AGENTS.md" ]; then
  sed -e "s/\[NOME_DO_PROJETO\]/$PROJECT_NAME_ESC/g" \
      -e "s/\[DESCRICAO_DO_PROJETO\]/$PROJECT_DESC_ESC ($STACK_NAME_ESC)/g" \
      -e "s/\[TECNOLOGIAS_UTILIZADAS\]/$STACK_NAME_ESC/g" \
      -e "s/\[COMANDO_COMPILAR\]/$CMD_COMPILE_ESC/g" \
      -e "s/\[COMANDO_RODAR_LOCAL\]/$CMD_RUN_ESC/g" \
      -e "s/\[COMANDO_TESTAR\]/$CMD_TEST_ESC/g" \
      -e "s/\[COMANDO_TESTE_UNICO\]/$CMD_TEST_SINGLE_ESC/g" \
      -e "s/\[COMANDO_BUILD\]/$CMD_BUILD_ESC/g" \
      docs/templates/AGENTS.md > AGENTS.md
  echo -e "  \033[36m✓ AGENTS.md configurado com as diretrizes da stack.\033[0m"
fi

# 4. docs/backlog.md
if [ -f "docs/templates/BACKLOG.md" ]; then
  sed -e "s/\[NOME_DO_PROJETO\]/$PROJECT_NAME_ESC/g" \
      -e "s/\[ORGANIZACAO_OU_USUARIO\]/$GITHUB_OWNER_ESC/g" \
      -e "s/\[DATA_ATUALIZACAO\]/$CURRENT_DATE/g" \
      -e "s/\[LINK_DO_PROJECT_OU_KANBAN\]/$LINK_PROJECT_ESC/g" \
      docs/templates/BACKLOG.md > docs/backlog.md
  echo -e "  \033[36m✓ docs/backlog.md inicializado.\033[0m"
fi

# 5. .github/CONTRIBUTING.md
if [ -f ".github/CONTRIBUTING.md" ]; then
  sed -e "s/\[NOME_DO_PROJETO\]/$PROJECT_NAME_ESC/g" .github/CONTRIBUTING.md > .github/CONTRIBUTING.md.tmp && mv .github/CONTRIBUTING.md.tmp .github/CONTRIBUTING.md
  echo -e "  \033[36m✓ .github/CONTRIBUTING.md configurado com o nome do projeto.\033[0m"
fi

# 6. CHANGELOG.md
if [ -f "docs/templates/CHANGELOG.md" ]; then
  cp docs/templates/CHANGELOG.md CHANGELOG.md
  echo -e "  \033[36m✓ CHANGELOG.md inicializado para o novo projeto.\033[0m"
fi

# 7. .gitleaks.toml e .gitleaksignore
if [ -f ".gitleaks.toml" ]; then
  cat <<EOF > .gitleaks.toml
title = "$PROJECT_NAME gitleaks config"

[extend]
useDefault = true

[allowlist]
description = "Permitir apenas templates e arquivos de exemplo"
commits = []
paths = [
    '''(^|/)docs/templates/''',
    '''\.example$''',
    '''\.env\.example$'''
]
EOF
  echo -e "  \033[36m✓ .gitleaks.toml configurado para o novo projeto.\033[0m"
fi

if [ -f ".gitleaksignore" ]; then
  cat <<EOF > .gitleaksignore
# ==============================================================================
# GITLEAKS IGNORE FILE (.gitleaksignore) — $PROJECT_NAME
# ==============================================================================
# Utilize este arquivo para registrar falsos positivos ou excecoes pontuais
# de commits historicos detectados pelo scanner de segredos Gitleaks.
#
# Formato:
# commit-sha:file-path:rule-id:line-number
# ==============================================================================
EOF
  echo -e "  \033[36m✓ .gitleaksignore configurado para o novo projeto.\033[0m"
fi

# 8. .env.example
if [ ! -f ".env.example" ]; then
  cat <<EOF > .env.example
# ==============================================================================
# VARIÁVEIS DE AMBIENTE — $PROJECT_NAME
# Copie para .env e preencha conforme o ambiente local. Nunca comite o .env!
# ==============================================================================
APP_PORT=8080
APP_ENV=local
EOF
  echo -e "  \033[36m✓ .env.example criado.\033[0m"
else
  sed -e "s/\[NOME_DO_PROJETO\]/$PROJECT_NAME_ESC/g" .env.example > .env.example.tmp && mv .env.example.tmp .env.example
  echo -e "  \033[36m✓ .env.example configurado para o novo projeto.\033[0m"
fi

# 9. .vscode/tasks.json
if [ -f ".vscode/tasks.json" ]; then
  sed -e "s/\[COMANDO_BUILD\]/$CMD_BUILD_ESC/g" \
      -e "s/\[COMANDO_TESTAR\]/$CMD_TEST_ESC/g" \
      .vscode/tasks.json > .vscode/tasks.json.tmp && mv .vscode/tasks.json.tmp .vscode/tasks.json
  echo -e "  \033[36m✓ .vscode/tasks.json configurado para a stack.\033[0m"
fi

# 10. scripts/run-local.*.example
if [ -f "scripts/run-local.sh.example" ]; then
  sed -e "s/\[COMANDO_RODAR_LOCAL\]/$CMD_RUN_ESC/g" \
      scripts/run-local.sh.example > scripts/run-local.sh.example.tmp && mv scripts/run-local.sh.example.tmp scripts/run-local.sh.example
fi
if [ -f "scripts/run-local.ps1.example" ]; then
  sed -e "s/\[COMANDO_RODAR_LOCAL\]/$CMD_RUN_ESC/g" \
      scripts/run-local.ps1.example > scripts/run-local.ps1.example.tmp && mv scripts/run-local.ps1.example.tmp scripts/run-local.ps1.example
fi
if [ -f "scripts/run-local.sh.example" ] || [ -f "scripts/run-local.ps1.example" ]; then
  echo -e "  \033[36m✓ scripts/run-local.*.example configurados para a stack.\033[0m"
fi

# 11. Autolimpeza
echo ""
if [ "$NON_INTERACTIVE" = true ]; then
  CLEANUP="s"
else
  read -rp "Deseja remover os scripts de bootstrap e templates iniciais agora? (S/n): " CLEANUP
  CLEANUP=${CLEANUP:-"s"}
fi

if [[ "$CLEANUP" =~ ^[sSyY]$ ]]; then
  rm -f scripts/bootstrap.sh scripts/bootstrap.ps1
  rm -f docs/templates/README-PROJECT.md docs/templates/AGENTS.md
  rmdir scripts 2>/dev/null || true
  echo -e "  \033[33m✓ Scripts de bootstrap e templates iniciais removidos (repositório limpo).\033[0m"
fi

echo -e "\n\033[32m🎉 Projeto '$PROJECT_NAME' inicializado com sucesso!\033[0m"
echo "Próximos passos recomendados:"
echo "  1. Revise o README.md e o AGENTS.md."
echo "  2. Adicione sua primeira especificação em docs/specs/ a partir de docs/templates/SPEC.md."
echo "  3. Execute 'git add .' e faça seu primeiro commit: 'chore: inicializar projeto via starter-kit'."
