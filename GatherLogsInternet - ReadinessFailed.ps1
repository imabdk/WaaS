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
