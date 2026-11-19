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

if [ "$NON_INTERACTIVE" = true ]; then
  PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_NAME}
  PROJECT_DESC=${PROJECT_DESC:-"Sistema de alta qualidade desenvolvido com assistência de IA."}
  GITHUB_OWNER=${GITHUB_OWNER:-"heviane"}
  STACK_OPTION=${STACK_OPTION:-"1"}
else
  read -rp "Nome do novo projeto [$DEFAULT_NAME]: " PROJECT_NAME
  PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_NAME}

  read -rp "Breve descrição do valor do software: " PROJECT_DESC
  PROJECT_DESC=${PROJECT_DESC:-"Sistema de alta qualidade desenvolvido com assistência de IA."}

  read -rp "Usuário ou Organização do GitHub [heviane]: " GITHUB_OWNER
  GITHUB_OWNER=${GITHUB_OWNER:-"heviane"}

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
    CMD_COMPILE="[comando de compilação]"
    CMD_RUN="[comando para rodar localmente]"
    CMD_TEST="[comando de testes]"
    CMD_TEST_SINGLE="[comando de teste específico]"
    CMD_BUILD="[comando de build de produção]"
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
if [ -f "docs/templates/README-PROJECT.md" ]; then
  sed -e "s/\[Nome do Projeto\]/$PROJECT_NAME_ESC/g" \
      -e "s/\[Breve descrição em uma ou duas frases sobre o objetivo e o valor do projeto\]\./$PROJECT_DESC_ESC/g" \
      -e "s/\[usuario\]/$GITHUB_OWNER_ESC/g" \
      -e "s/\[nome-repositorio\]/$PROJECT_NAME_ESC/g" \
      -e "s/\[ex: Java 17\/21, Node\.js 22, \.NET 9, Python 3\.12\]/$STACK_NAME_ESC/g" \
      docs/templates/README-PROJECT.md > README.md
  echo -e "  \033[36m✓ README.md gerado com sucesso.\033[0m"
fi

# 3. AGENTS.md
if [ -f "docs/templates/AGENTS.md" ]; then
  sed -e "s/\[Nome do Projeto\]/$PROJECT_NAME_ESC/g" \
      -e "s/\[breve descrição do propósito do software e tecnologia principal\]/$PROJECT_DESC_ESC ($STACK_NAME_ESC)/g" \
      -e "s/\[Linguagem X, Framework Y, Gerenciador de Build Z\]/$STACK_NAME_ESC/g" \
      -e "s/\[comando de compilação, ex: \.\/mvnw clean compile | npm install | dotnet build\]/$CMD_COMPILE_ESC/g" \
      -e "s/\[comando para rodar localmente, ex: \.\/mvnw spring-boot:run | npm run dev\]/$CMD_RUN_ESC/g" \
      -e "s/\[comando de testes, ex: \.\/mvnw clean test | npm test | pytest\]/$CMD_TEST_ESC/g" \
      -e "s/\[comando para teste unitário único\]/$CMD_TEST_SINGLE_ESC/g" \
      -e "s/\[comando de empacotamento, ex: \.\/mvnw clean package | npm run build\]/$CMD_BUILD_ESC/g" \
      docs/templates/AGENTS.md > AGENTS.md
  echo -e "  \033[36m✓ AGENTS.md configurado com as diretrizes da stack.\033[0m"
fi

# 4. docs/backlog.md
if [ -f "docs/templates/BACKLOG.md" ]; then
  sed -e "s/\[Nome do Projeto\]/$PROJECT_NAME_ESC/g" \
      -e "s/\[usuario\]/$GITHUB_OWNER_ESC/g" \
      -e "s/\[nome-repositorio\]/$PROJECT_NAME_ESC/g" \
      -e "s/AAAA-MM-DD/$CURRENT_DATE/g" \
      docs/templates/BACKLOG.md > docs/backlog.md
  echo -e "  \033[36m✓ docs/backlog.md inicializado.\033[0m"
fi

# 5. .github/CONTRIBUTING.md
if [ -f ".github/CONTRIBUTING.md" ]; then
  sed -e "s/\[Nome do Projeto\]/$PROJECT_NAME_ESC/g" .github/CONTRIBUTING.md > .github/CONTRIBUTING.md.tmp && mv .github/CONTRIBUTING.md.tmp .github/CONTRIBUTING.md
  echo -e "  \033[36m✓ .github/CONTRIBUTING.md configurado com o nome do projeto.\033[0m"
fi

# 6. CHANGELOG.md
if [ -f "docs/templates/CHANGELOG.md" ]; then
  cp docs/templates/CHANGELOG.md CHANGELOG.md
  echo -e "  \033[36m✓ CHANGELOG.md inicializado para o novo projeto.\033[0m"
fi

# 7. .gitleaks.toml
if [ -f ".gitleaks.toml" ]; then
  cat <<EOF > .gitleaks.toml
title = "$PROJECT_NAME gitleaks config"

[extend]
useDefault = true

[allowlist]
description = "Permitir exemplos em documentacao e arquivos de exemplo"
commits = []
paths = [
    '''(^|/)docs/''',
    '''\.example$''',
    '''(^|/)scripts/samples/''',
    '''\.env\.example$'''
]
EOF
  echo -e "  \033[36m✓ .gitleaks.toml configurado para o novo projeto.\033[0m"
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
fi

# 9. .vscode/tasks.json
if [ -f ".vscode/tasks.json" ]; then
  sed -e "s/\[comando-build\]/$CMD_BUILD_ESC/g" \
      -e "s/\[comando-testes\]/$CMD_TEST_ESC/g" \
      .vscode/tasks.json > .vscode/tasks.json.tmp && mv .vscode/tasks.json.tmp .vscode/tasks.json
  echo -e "  \033[36m✓ .vscode/tasks.json configurado para a stack.\033[0m"
fi

# 10. Autolimpeza
echo ""
if [ "$NON_INTERACTIVE" = true ]; then
  CLEANUP="s"
else
  read -rp "Deseja remover os scripts de bootstrap e templates iniciais agora? (S/n): " CLEANUP
  CLEANUP=${CLEANUP:-"s"}
fi

if [[ "$CLEANUP" =~ ^[sSyY]$ ]]; then
  rm -rf scripts
  rm -f docs/templates/README-PROJECT.md docs/templates/AGENTS.md
  echo -e "  \033[33m✓ Scripts de bootstrap e templates iniciais removidos (repositório limpo).\033[0m"
fi

echo -e "\n\033[32m🎉 Projeto '$PROJECT_NAME' inicializado com sucesso!\033[0m"
echo "Próximos passos recomendados:"
echo "  1. Revise o README.md e o AGENTS.md."
echo "  2. Adicione sua primeira especificação em docs/specs/ a partir de docs/templates/SPEC.md."
echo "  3. Execute 'git add .' e faça seu primeiro commit: 'chore: inicializar projeto via starter-kit'."
