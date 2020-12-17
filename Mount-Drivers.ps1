try {
    $tsEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment
    $targetWindowsBuild = $tsEnv.Value("SMSTSTargetOSBuild")
    $companyName = $tsEnv.Value("SMSTSCompanyName")
    $waasVersion = $targetWindowsBuild
    $ipuContentPath = "$env:ProgramData\$companyName\WaaS\$waasVersion"
    $driversContentPath = "$env:ProgramData\$companyName\WaaS\$waasVersion\Drivers"
    $computerModel = (Get-CimInstance Win32_ComputerSystemProduct).Version
    if (-NOT[string]::IsNullOrEmpty($computerModel)) {
        $compuderModel = (Get-WmiObject -Class Win32_ComputerSystem).Model  
    }
    $findDrivers = (Get-ChildItem -Path $driversContentPath -Recurse | Where-Object {$_.FullName -match $computerModel}).FullName
    if (-NOT[string]::IsNullOrEmpty($findDrivers)) {
        if (-NOT(Test-Path -Path $ipuContentPath\MountDrivers)) { New-Item -Path $ipuContentPath -Name MountDrivers -ItemType Directory }
        dism.exe /mount-wim /wimfile:$findDrivers /index:1 /mountdir:$ipuContentPath\MountDrivers
    }
}
catch {
    Write-Verbose -Verbose -Message "Failed to mount WIM containing drivers"
    exit 1
}
