Set-Location -Path "e:\my-pro\spair-parts-pro\spairparts-UI-01\spairparts"
& mvn clean compile
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
