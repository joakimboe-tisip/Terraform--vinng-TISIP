
# Kjører kontrollene på nettverksmodulen

Set-Location -Path $PSScriptRoot -ErrorAction Stop

terraform fmt -check -recursive
if ($LASTEXITCODE -ne 0) { exit 1 }

terraform init -backend=false
if ($LASTEXITCODE -ne 0) { exit 1 }

terraform validate
if ($LASTEXITCODE -ne 0) { exit 1 }

tflint --init
if ($LASTEXITCODE -ne 0) { exit 1 }

tflint
if ($LASTEXITCODE -ne 0) { exit 1 }

checkov --config-file .checkov.yaml
if ($LASTEXITCODE -ne 0) { exit 1 }

terraform test
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "Alle kontrollene er bestatt"
