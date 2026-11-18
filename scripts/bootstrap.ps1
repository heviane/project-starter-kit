<#
.SYNOPSIS
    Script interativo de inicialização (Bootstrapping) para novos projetos baseados no project-starter-kit.
.DESCRIPTION
    Coleta metadados essenciais, hidrata os arquivos README.md, AGENTS.md e docs/backlog.md com os parâmetros
    do seu novo projeto e realiza a autolimpeza dos arquivos transitórios do template.
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "🚀 AI-Assisted Project Starter Kit — Inicialização de Novo Projeto" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Coleta de Metadados
$defaultProjectName = (Get-Item .).Name
$projectName = Read-Host "Nome do novo projeto [$defaultProjectName]"
if ([string]::IsNullOrWhiteSpace($projectName)) { $projectName = $defaultProjectName }

$projectDesc = Read-Host "Breve descrição do valor do software"
if ([string]::IsNullOrWhiteSpace($projectDesc)) { $projectDesc = "Sistema de alta qualidade desenvolvido com assistência de IA." }

$githubOwner = Read-Host "Usuário ou Organização do GitHub [heviane]"
if ([string]::IsNullOrWhiteSpace($githubOwner)) { $githubOwner = "heviane" }

Write-Host "`nSelecione a Stack Tecnológica Principal:" -ForegroundColor Yellow
Write-Host "  1) Java 17+ / Spring Boot 3 / Maven"
Write-Host "  2) Node.js 20+ / TypeScript / Vitest"
Write-Host "  3) Python 3.12+ / FastAPI / Pytest"
Write-Host "  4) .NET 9 / C# / xUnit"
Write-Host "  5) Personalizada / Agnóstica"
$stackOption = Read-Host "Opção [1-5, padrão: 1]"
if ([string]::IsNullOrWhiteSpace($stackOption)) { $stackOption = "1" }

switch ($stackOption) {
    "1" {
        $stackName = "Java 17+, Spring Boot 3, Maven"
        $cmdCompile = "./mvnw clean compile"
        $cmdRun = "./mvnw spring-boot:run"
        $cmdTest = "./mvnw clean test"
        $cmdTestSingle = "./mvnw test -Dtest=NomeDoTeste"
        $cmdBuild = "./mvnw clean package"
    }
    "2" {
        $stackName = "Node.js 20+, TypeScript, Vitest"
        $cmdCompile = "npm run build"
        $cmdRun = "npm run dev"
        $cmdTest = "npm test"
        $cmdTestSingle = "npx vitest run caminho/do/teste.test.ts"
        $cmdBuild = "npm run build"
    }
    "3" {
        $stackName = "Python 3.12+, FastAPI, Pytest"
        $cmdCompile = "poetry check"
        $cmdRun = "poetry run uvicorn main:app --reload"
        $cmdTest = "poetry run pytest"
        $cmdTestSingle = "poetry run pytest tests/test_especifico.py"
        $cmdBuild = "poetry build"
    }
    "4" {
        $stackName = ".NET 9, C#, xUnit"
        $cmdCompile = "dotnet build"
        $cmdRun = "dotnet run"
        $cmdTest = "dotnet test"
        $cmdTestSingle = "dotnet test --filter FullyQualifiedName~NomeDoTeste"
        $cmdBuild = "dotnet publish -c Release"
    }
    default {
        $stackName = "Stack Customizada"
        $cmdCompile = "[comando de compilação]"
        $cmdRun = "[comando para rodar localmente]"
        $cmdTest = "[comando de testes]"
        $cmdTestSingle = "[comando de teste específico]"
        $cmdBuild = "[comando de build de produção]"
    }
}

$currentDate = (Get-Date).ToString("yyyy-MM-dd")

Write-Host "`n📝 Hidratando arquivos do projeto..." -ForegroundColor Green

# 2. Hidratação do README.md
$readmeTemplatePath = "docs/templates/README-PROJECT.md"
if (Test-Path $readmeTemplatePath) {
    $readmeContent = Get-Content $readmeTemplatePath -Raw -Encoding UTF8
    $readmeContent = $readmeContent -replace '\[Nome do Projeto\]', $projectName
    $readmeContent = $readmeContent -replace '\[Breve descrição em uma ou duas frases sobre o objetivo e o valor do projeto\]\.', $projectDesc
    $readmeContent = $readmeContent -replace '\[usuario\]', $githubOwner
    $readmeContent = $readmeContent -replace '\[nome-repositorio\]', $projectName
    $readmeContent = $readmeContent -replace '\[ex: Java 17/21, Node.js 22, \.NET 9, Python 3\.12\]', $stackName
    Set-Content -Path "README.md" -Value $readmeContent -Encoding UTF8
    Write-Host "  ✓ README.md gerado com sucesso." -ForegroundColor Cyan
}

# 3. Hidratação do AGENTS.md
$agentsTemplatePath = "docs/templates/AGENTS.md"
if (Test-Path $agentsTemplatePath) {
    $agentsContent = Get-Content $agentsTemplatePath -Raw -Encoding UTF8
    $agentsContent = $agentsContent -replace '\[Nome do Projeto\]', $projectName
    $agentsContent = $agentsContent -replace '\[breve descrição do propósito do software e tecnologia principal\]', "$projectDesc ($stackName)"
    $agentsContent = $agentsContent -replace '\[Linguagem X, Framework Y, Gerenciador de Build Z\]', $stackName
    $agentsContent = $agentsContent -replace '\[comando de compilação, ex: \./mvnw clean compile \| npm install \| dotnet build\]', $cmdCompile
    $agentsContent = $agentsContent -replace '\[comando para rodar localmente, ex: \./mvnw spring-boot:run \| npm run dev\]', $cmdRun
    $agentsContent = $agentsContent -replace '\[comando de testes, ex: \./mvnw clean test \| npm test \| pytest\]', $cmdTest
    $agentsContent = $agentsContent -replace '\[comando para teste unitário único\]', $cmdTestSingle
    $agentsContent = $agentsContent -replace '\[comando de empacotamento, ex: \./mvnw clean package \| npm run build\]', $cmdBuild
    Set-Content -Path "AGENTS.md" -Value $agentsContent -Encoding UTF8
    Write-Host "  ✓ AGENTS.md configurado com as diretrizes da stack." -ForegroundColor Cyan
}

# 4. Hidratação do docs/backlog.md
$backlogTemplatePath = "docs/templates/BACKLOG.md"
if (Test-Path $backlogTemplatePath) {
    $backlogContent = Get-Content $backlogTemplatePath -Raw -Encoding UTF8
    $backlogContent = $backlogContent -replace '\[Nome do Projeto\]', $projectName
    $backlogContent = $backlogContent -replace '\[usuario\]', $githubOwner
    $backlogContent = $backlogContent -replace '\[nome-repositorio\]', $projectName
    $backlogContent = $backlogContent -replace 'AAAA-MM-DD', $currentDate
    Set-Content -Path "docs/backlog.md" -Value $backlogContent -Encoding UTF8
    Write-Host "  ✓ docs/backlog.md inicializado." -ForegroundColor Cyan
}

# 5. Garantir .env.example
if (-not (Test-Path ".env.example")) {
    $envContent = @"
# ==============================================================================
# VARIÁVEIS DE AMBIENTE — $projectName
# Copie para .env e preencha conforme o ambiente local. Nunca comite o .env!
# ==============================================================================
APP_PORT=8080
APP_ENV=local
"@
    Set-Content -Path ".env.example" -Value $envContent -Encoding UTF8
    Write-Host "  ✓ .env.example criado." -ForegroundColor Cyan
}

# 6. Autolimpeza (Self-Cleanup)
Write-Host ""
$cleanup = Read-Host "Deseja remover os scripts de bootstrap agora para finalizar o setup? (S/n)"
if ($cleanup -ne "n" -and $cleanup -ne "N") {
    Remove-Item -Path "scripts" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  ✓ Pasta scripts/ de bootstrap removida (repositório limpo)." -ForegroundColor Yellow
}

Write-Host "`n🎉 Projeto '$projectName' inicializado com sucesso!" -ForegroundColor Green
Write-Host "Próximos passos recomendados:" -ForegroundColor White
Write-Host "  1. Revise o README.md e o AGENTS.md."
Write-Host "  2. Adicione sua primeira especificação em docs/specs/ a partir de docs/templates/SPEC.md."
Write-Host "  3. Execute 'git add .' e faça seu primeiro commit: 'chore: inicializar projeto via starter-kit'."
