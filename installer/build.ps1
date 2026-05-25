$ErrorActionPreference = "Stop"

$installerDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$issFile = Join-Path $installerDir "mCockpitExternalViewerBridge.iss"

$isccCommand = Get-Command "ISCC.exe" -ErrorAction SilentlyContinue
$isccPath = if ($isccCommand) { $isccCommand.Source } else { $null }

if (-not $isccPath) {
    $defaultPath = Join-Path ${env:ProgramFiles(x86)} "Inno Setup 6\ISCC.exe"
    if (Test-Path $defaultPath) {
        $isccPath = $defaultPath
    }
}

if (-not $isccPath) {
    throw "ISCC.exe nao encontrado. Instale o Inno Setup 6 ou adicione ISCC.exe ao PATH."
}

Push-Location $installerDir
try {
    & $isccPath $issFile
}
finally {
    Pop-Location
}
