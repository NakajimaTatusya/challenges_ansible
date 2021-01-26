@(echo '> NUL
echo off)
NET SESSION > NUL 2>&1
IF %ERRORLEVEL% neq 0 goto RESTART
setlocal enableextensions
set "THIS_PATH=%~f0"
set "PARAM_1=%~1"
PowerShell.exe -Command "iex -Command ((gc \"%THIS_PATH:`=``%\") -join \"`n\")"
exit /b %errorlevel%
:RESTART
powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process %~f0 -Verb runas"
exit
') | sv -Name TempVar
# !!!!! Windows Server 2016 以降に適用すること !!!!!
# ここから下は PowerShellスクリプト
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
$result = Get-NetFirewallRule -Name WINRM-HTTP-In-TCP | Select-Object -ExpandProperty "Enabled"
if ($result -eq "False") {
    Get-NetFirewallRule -Name WINRM-HTTP-In-TCP | Set-NetFirwallRule -Profile Any -PassThru
    Write-Host "Allow WINRM-HTTP-In-TCP firewall rules."
}
else {
	Write-Host "WinRM OK!"
}
pause
exit
