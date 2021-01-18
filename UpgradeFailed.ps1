$tsEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$targetWindowsBuild = $tsEnv.Value("SMSTSTargetOSBuild")
$smstsLogPath = $tsEnv.Value("_SMSTSLogPath")
$companyName = $tsEnv.Value("SMSTSCompanyName")
$currentActionName = $tsEnv.Value("_SMSTSCurrentActionName")
$waasVersion = $targetWindowsBuild
$logsPath = "$env:ProgramData\$companyName\WaaS\$waasVersion\Logs"
$currentActionPath = "$env:ProgramData\$companyName\WaaS\$waasVersion\Logs\$currentActionName"
if (-NOT(Test-Path -Path $currentActionPath)) { New-Item -Path $logsPath -Name $currentActionName -ItemType Directory }
Copy-Item -Path "$smstsLogPath\*" -Destination $currentActionPath -Recurse
Copy-Item -Path 'C:\$WINDOWS.~BT\Sources\Panther\CompatData*.xml' -Destination $currentActionPath -Recurse
Copy-Item -Path 'C:\$WINDOWS.~BT\Sources\Panther\*.log' -Destination $currentActionPath -Recurse
Copy-Item -Path 'C:\Windows\logs\SetupDiag\setupdiagresults.xml' -Destination $currentActionPath -Recurse
