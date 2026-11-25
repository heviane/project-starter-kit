<#
.SYNOPSIS
    Script de inicialização (Bootstrapping) para novos projetos baseados no project-starter-kit.
.DESCRIPTION
    Coleta metadados essenciais, hidrata os arquivos README.md, AGENTS.md, docs/backlog.md,
    .github/CONTRIBUTING.md, CHANGELOG.md e .gitleaks.toml com os parâmetros do seu novo projeto
    e realiza a autolimpeza dos arquivos transitórios do template.
#>

[CmdletBinding()]
param(
    [switch]$NonInteractive,
    [switch]$Force,
    [string]$ProjectName,
    [string]$ProjectDesc,
    [string]$GithubOwner,
    [string]$ContactEmail,
    [string]$StackOption,
    [string]$LinkProject,
    [switch]$NoCleanup
)

$ErrorActionPreference = "Stop"

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "🚀 AI-Assisted Project Starter Kit — Inicialização de Novo Projeto" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Coleta de Metadados
$defaultProjectName = (Get-Item .).Name
$defaultOwner = git config user.name 2>$null
if ([string]::IsNullOrWhiteSpace($defaultOwner)) { $defaultOwner = "my-org" }
$defaultEmail = git config user.email 2>$null
if ([string]::IsNullOrWhiteSpace($defaultEmail)) { $defaultEmail = "contato@exemplo.com" }

if ($NonInteractive) {
    if ([string]::IsNullOrWhiteSpace($ProjectName)) { $projectName = $defaultProjectName } else { $projectName = $ProjectName }
    if ([string]::IsNullOrWhiteSpace($ProjectDesc)) { $projectDesc = "Sistema de alta qualidade desenvolvido com assistência de IA." } else { $projectDesc = $ProjectDesc }
    if ([string]::IsNullOrWhiteSpace($GithubOwner)) { $githubOwner = $defaultOwner } else { $githubOwner = $GithubOwner }
    if ([string]::IsNullOrWhiteSpace($ContactEmail)) { $contactEmail = $defaultEmail } else { $contactEmail = $ContactEmail }
    if ([string]::IsNullOrWhiteSpace($StackOption)) { $stackOption = "1" } else { $stackOption = $StackOption }

    if ($githubOwner -match '^[Hh]eviane') {
        $defaultProjectLink = "https://github.com/users/heviane/projects/14"
    } else {
        $defaultProjectLink = "https://github.com/$githubOwner/$projectName/projects"
    }
    if ([string]::IsNullOrWhiteSpace($LinkProject)) { $linkProject = $defaultProjectLink } else { $linkProject = $LinkProject }
} else {
    $projectName = Read-Host "Nome do novo projeto [$defaultProjectName]"
    if ([string]::IsNullOrWhiteSpace($projectName)) { $projectName = $defaultProjectName }

    $projectDesc = Read-Host "Breve descrição do valor do software"
    if ([string]::IsNullOrWhiteSpace($projectDesc)) { $projectDesc = "Sistema de alta qualidade desenvolvido com assistência de IA." }

    $githubOwner = Read-Host "Usuário ou Organização do GitHub [$defaultOwner]"
    if ([string]::IsNullOrWhiteSpace($githubOwner)) { $githubOwner = $defaultOwner }

    $contactEmail = Read-Host "E-mail de contato para Código de Conduta [$defaultEmail]"
    if ([string]::IsNullOrWhiteSpace($contactEmail)) { $contactEmail = $defaultEmail }

    if ($githubOwner -match '^[Hh]eviane') {
        $defaultProjectLink = "https://github.com/users/heviane/projects/14"
    } else {
        $defaultProjectLink = "https://github.com/$githubOwner/$projectName/projects"
    }

    $linkProject = Read-Host "URL do GitHub Project ou Kanban [$defaultProjectLink]"
    if ([string]::IsNullOrWhiteSpace($linkProject)) { $linkProject = $defaultProjectLink }

    Write-Host "`nSelecione a Stack Tecnológica Principal:" -ForegroundColor Yellow
    Write-Host "  1) Java 17+ / Spring Boot 3 / Maven"
    Write-Host "  2) Node.js 20+ / TypeScript / Vitest"
    Write-Host "  3) Python 3.12+ / FastAPI / Pytest"
    Write-Host "  4) .NET 9 / C# / xUnit"
    Write-Host "  5) Personalizada / Agnóstica"
    $stackOption = Read-Host "Opção [1-5, padrão: 1]"
    if ([string]::IsNullOrWhiteSpace($stackOption)) { $stackOption = "1" }
}

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
        $cmdCompile = "poetry run python -m compileall src -q"
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
    Default {
        $stackName = "Stack Customizada"
        $cmdCompile = "[COMANDO_COMPILAR]"
        $cmdRun = "[COMANDO_RODAR_LOCAL]"
        $cmdTest = "[COMANDO_TESTAR]"
        $cmdTestSingle = "[COMANDO_TESTE_UNICO]"
        $cmdBuild = "[COMANDO_BUILD]"
    }
}

$currentDate = (Get-Date).ToString("yyyy-MM-dd")

Write-Host "`n📝 Hidratando arquivos do projeto..." -ForegroundColor Green

# 1. Garantir diretórios de governança
if (-not (Test-Path "docs/specs")) { New-Item -ItemType Directory -Path "docs/specs" -Force | Out-Null }
if (-not (Test-Path "docs/adrs")) { New-Item -ItemType Directory -Path "docs/adrs" -Force | Out-Null }

# 2. Hidratação do README.md
$readmeTemplatePath = "docs/templates/README-PROJECT.md"
$shouldGenerateReadme = $true
if ((Test-Path "README.md") -and -not (Select-String -Path "README.md" -Pattern "AI-Assisted Project Starter Kit" -Quiet)) {
    if ($Force) {
        $shouldGenerateReadme = $true
    } elseif (-not $NonInteractive) {
        $overwriteReadme = Read-Host "Arquivo README.md já existe e parece personalizado. Deseja sobrescrever? (s/N)"
        if ($overwriteReadme -ne "s" -and $overwriteReadme -ne "S") {
            $shouldGenerateReadme = $false
            Write-Host "  ! README.md existente mantido sem alterações." -ForegroundColor Yellow
        }
    } else {
        $shouldGenerateReadme = $false
    }
}

if ($shouldGenerateReadme -and (Test-Path $readmeTemplatePath)) {
    $readmeContent = Get-Content $readmeTemplatePath -Raw -Encoding UTF8
    $readmeContent = $readmeContent.Replace('[NOME_DO_PROJETO]', $projectName)
    $readmeContent = $readmeContent.Replace('[DESCRICAO_DO_PROJETO]', $projectDesc)
    $readmeContent = $readmeContent.Replace('[ORGANIZACAO_OU_USUARIO]', $githubOwner)
    $readmeContent = $readmeContent.Replace('[TECNOLOGIAS_UTILIZADAS]', $stackName)
    Set-Content -Path "README.md" -Value $readmeContent -Encoding UTF8
    Write-Host "  ✓ README.md gerado com sucesso." -ForegroundColor Cyan
}

# 3. Hidratação do AGENTS.md
$agentsTemplatePath = "docs/templates/AGENTS.md"
if (Test-Path $agentsTemplatePath) {
    $agentsContent = Get-Content $agentsTemplatePath -Raw -Encoding UTF8
    $agentsContent = $agentsContent.Replace('[NOME_DO_PROJETO]', $projectName)
    $agentsContent = $agentsContent.Replace('[DESCRICAO_DO_PROJETO]', "$projectDesc ($stackName)")
    $agentsContent = $agentsContent.Replace('[TECNOLOGIAS_UTILIZADAS]', $stackName)
    $agentsContent = $agentsContent.Replace('[COMANDO_COMPILAR]', $cmdCompile)
    $agentsContent = $agentsContent.Replace('[COMANDO_RODAR_LOCAL]', $cmdRun)
    $agentsContent = $agentsContent.Replace('[COMANDO_TESTAR]', $cmdTest)
    $agentsContent = $agentsContent.Replace('[COMANDO_TESTE_UNICO]', $cmdTestSingle)
    $agentsContent = $agentsContent.Replace('[COMANDO_BUILD]', $cmdBuild)
    Set-Content -Path "AGENTS.md" -Value $agentsContent -Encoding UTF8
    Write-Host "  ✓ AGENTS.md configurado com as diretrizes da stack." -ForegroundColor Cyan
}

# 4. Hidratação do docs/backlog.md
$backlogTemplatePath = "docs/templates/BACKLOG.md"
if (Test-Path $backlogTemplatePath) {
    $backlogContent = Get-Content $backlogTemplatePath -Raw -Encoding UTF8
    $backlogContent = $backlogContent.Replace('[NOME_DO_PROJETO]', $projectName)
    $backlogContent = $backlogContent.Replace('[ORGANIZACAO_OU_USUARIO]', $githubOwner)
    $backlogContent = $backlogContent.Replace('[DATA_ATUALIZACAO]', $currentDate)
    $backlogContent = $backlogContent.Replace('[LINK_DO_PROJECT_OU_KANBAN]', $linkProject)
    Set-Content -Path "docs/backlog.md" -Value $backlogContent -Encoding UTF8
    Write-Host "  ✓ docs/backlog.md inicializado." -ForegroundColor Cyan
}

# 5. Hidratação de .github/CONTRIBUTING.md
$contributingPath = ".github/CONTRIBUTING.md"
if (Test-Path $contributingPath) {
    $contributingContent = Get-Content $contributingPath -Raw -Encoding UTF8
    $contributingContent = $contributingContent.Replace('[NOME_DO_PROJETO]', $projectName)
    Set-Content -Path $contributingPath -Value $contributingContent -Encoding UTF8
    Write-Host "  ✓ .github/CONTRIBUTING.md configurado com o nome do projeto." -ForegroundColor Cyan
}

# 5b. Hidratação de .github/CODE_OF_CONDUCT.md
$cocPath = ".github/CODE_OF_CONDUCT.md"
if (Test-Path $cocPath) {
    $cocContent = Get-Content $cocPath -Raw -Encoding UTF8
    $cocContent = $cocContent.Replace('[EMAIL_DE_CONTATO]', $contactEmail)
    Set-Content -Path $cocPath -Value $cocContent -Encoding UTF8
    Write-Host "  ✓ .github/CODE_OF_CONDUCT.md configurado com o e-mail de contato." -ForegroundColor Cyan
}

# 6. Inicialização do CHANGELOG.md
$changelogTemplatePath = "docs/templates/CHANGELOG.md"
if (Test-Path $changelogTemplatePath) {
    Copy-Item $changelogTemplatePath -Destination "CHANGELOG.md" -Force
    Write-Host "  ✓ CHANGELOG.md inicializado para o novo projeto." -ForegroundColor Cyan
}

# 7. Configuração limpa do .gitleaks.toml e .gitleaksignore
if (Test-Path ".gitleaks.toml") {
    $gitleaksContent = @"
title = "$projectName gitleaks config"

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
"@
    Set-Content -Path ".gitleaks.toml" -Value $gitleaksContent -Encoding UTF8
    Write-Host "  ✓ .gitleaks.toml configurado para o novo projeto." -ForegroundColor Cyan
}

if (Test-Path ".gitleaksignore") {
    $gitleaksIgnoreContent = @"
# ==============================================================================
# GITLEAKS IGNORE FILE (.gitleaksignore) — $projectName
# ==============================================================================
# Utilize este arquivo para registrar falsos positivos ou excecoes pontuais
# de commits historicos detectados pelo scanner de segredos Gitleaks.
#
# Formato:
# commit-sha:file-path:rule-id:line-number
# ==============================================================================
"@
    Set-Content -Path ".gitleaksignore" -Value $gitleaksIgnoreContent -Encoding UTF8
    Write-Host "  ✓ .gitleaksignore configurado para o novo projeto." -ForegroundColor Cyan
}

# 8. Garantir e Hidratar .env.example
$envPath = ".env.example"
if (-not (Test-Path $envPath)) {
    $envContent = @"
# ==============================================================================
# VARIÁVEIS DE AMBIENTE — $projectName
# Copie para .env e preencha conforme o ambiente local. Nunca comite o .env!
# ==============================================================================
APP_PORT=8080
APP_ENV=local
"@
    Set-Content -Path $envPath -Value $envContent -Encoding UTF8
    Write-Host "  ✓ .env.example criado." -ForegroundColor Cyan
} else {
    $envContent = Get-Content $envPath -Raw -Encoding UTF8
    $envContent = $envContent -replace '\[NOME_DO_PROJETO\]', $projectName
    Set-Content -Path $envPath -Value $envContent -Encoding UTF8
    Write-Host "  ✓ .env.example configurado para o novo projeto." -ForegroundColor Cyan
}

# 9. Hidratação do .vscode/tasks.json
$vscodeTasksPath = ".vscode/tasks.json"
if (Test-Path $vscodeTasksPath) {
    $vscodeTasks = Get-Content $vscodeTasksPath -Raw -Encoding UTF8
    $vscodeTasks = $vscodeTasks -replace '\[COMANDO_BUILD\]', $cmdBuild
    $vscodeTasks = $vscodeTasks -replace '\[COMANDO_TESTAR\]', $cmdTest
    Set-Content -Path $vscodeTasksPath -Value $vscodeTasks -Encoding UTF8
    Write-Host "  ✓ .vscode/tasks.json configurado para a stack." -ForegroundColor Cyan
}

# 10. Hidratação de scripts/run-local.*.example
$runLocalPs1Path = "scripts/run-local.ps1.example"
if (Test-Path $runLocalPs1Path) {
    $runLocalPs1 = Get-Content $runLocalPs1Path -Raw -Encoding UTF8
    $runLocalPs1 = $runLocalPs1 -replace '\[COMANDO_RODAR_LOCAL\]', $cmdRun
    Set-Content -Path $runLocalPs1Path -Value $runLocalPs1 -Encoding UTF8
}
$runLocalShPath = "scripts/run-local.sh.example"
if (Test-Path $runLocalShPath) {
    $runLocalSh = Get-Content $runLocalShPath -Raw -Encoding UTF8
    $runLocalSh = $runLocalSh -replace '\[COMANDO_RODAR_LOCAL\]', $cmdRun
    Set-Content -Path $runLocalShPath -Value $runLocalSh -Encoding UTF8
}
if ((Test-Path $runLocalPs1Path) -or (Test-Path $runLocalShPath)) {
    Write-Host "  ✓ scripts/run-local.*.example configurados para a stack." -ForegroundColor Cyan
}

# 11. Autolimpeza (Self-Cleanup)
Write-Host ""
if ($NonInteractive) {
    if (-not $NoCleanup) {
        Remove-Item -Path "scripts/bootstrap.ps1", "scripts/bootstrap.sh" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "docs/templates/README-PROJECT.md" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "docs/templates/AGENTS.md" -Force -ErrorAction SilentlyContinue
        if ((Test-Path "scripts") -and ((Get-ChildItem -Path "scripts" -Force).Count -eq 0)) {
            Remove-Item -Path "scripts" -Force -ErrorAction SilentlyContinue
        }
        Write-Host "  ✓ Scripts de bootstrap e templates iniciais removidos (repositório limpo)." -ForegroundColor Yellow
    }
} else {
    $cleanup = Read-Host "Deseja remover os scripts de bootstrap e templates iniciais agora? (S/n)"
    if ($cleanup -ne "n" -and $cleanup -ne "N") {
        Remove-Item -Path "scripts/bootstrap.ps1", "scripts/bootstrap.sh" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "docs/templates/README-PROJECT.md" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "docs/templates/AGENTS.md" -Force -ErrorAction SilentlyContinue
        if ((Test-Path "scripts") -and ((Get-ChildItem -Path "scripts" -Force).Count -eq 0)) {
            Remove-Item -Path "scripts" -Force -ErrorAction SilentlyContinue
        }
        Write-Host "  ✓ Scripts de bootstrap e templates iniciais removidos (repositório limpo)." -ForegroundColor Yellow
    }
}

Write-Host "`n🎉 Projeto '$projectName' inicializado com sucesso!" -ForegroundColor Green
Write-Host "Próximos passos recomendados:" -ForegroundColor White
Write-Host "  1. Revise o README.md e o AGENTS.md."
Write-Host "  2. Adicione sua primeira especificação em docs/specs/ a partir de docs/templates/SPEC.md."
Write-Host "  3. Execute 'git add .' e faça seu primeiro commit: 'chore: inicializar projeto via starter-kit'."
