$tsEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$targetWindowsBuild = $tsEnv.Value("SMSTSTargetOSBuild")
$companyName = $tsEnv.Value("SMSTSCompanyName")
$registryPath = "HKLM:\SOFTWARE\$companyName\WaaS\$targetWindowsBuild"
if (-NOT(Test-Path $registryPath)) { New-Item -ItemType Directory -Path $registryPath -Force -ErrorAction SilentlyContinue | Out-Null }
if ($tsEnv.Value("_SMSTSOSUpgradeActionReturnCode") -ne $null -OR $tsEnv.Value("_SMSTSOSUpgradeActionReturnCode") -ne "") {
    [int64]$decimalReturnCode = $tsEnv.Value("_SMSTSOSUpgradeActionReturnCode")
    $hexReturnCode = "{0:X0}" -f [int64]$decimalReturnCode
    switch ($hexReturnCode) {
        C1900210 { $returnMessage = 'No compatibility issues' }
        C1900208 { $returnMessage = 'Incompatible apps or drivers' }
        C1900204 { $returnMessage = 'Selected migration choice is not available' }
        C1900200 { $returnMessage = 'Not eligible for Windows 10' }
        C190020E { $returnMessage = 'Not enough free disk space' }
        C1900107 { $returnMessage = 'Unsupported Operating System' }
        8024200D { $returnMessage = 'Update Needs to be Downloaded Again' }
        0 { $returnMessage = 'Windows Setup completed successfully' }
    }
    New-ItemProperty -Path $registryPath -Name "UpgradeReturnCode" -PropertyType String -Value $hexReturnCode -Force
    New-ItemProperty -Path $registryPath -Name "UpgradeReturnMessage" -PropertyType String -Value $returnMessage -Force
}
if ($tsEnv.Value("SMSTSStartUpgradeTime") -ne $null -and $tsEnv.Value("SMSTSEndUpgradeTime") -ne "") {
    $ipuStartTime = $tsEnv.Value("SMSTSStartUpgradeTime")
    $ipuEndTime = $tsEnv.Value("SMSTSEndUpgradeTime")
    $Difference = ([datetime]$TSEnv.Value("SMSTSEndUpgradeTime")) - ([datetime]$tsEnv.Value("SMSTSStartUpgradeTime")) 
    $Difference = [math]::Round($Difference.TotalMinutes)
    New-ItemProperty -Path $registryPath -Name "UpgradeTSRunTime" -Value $Difference -Force
    New-ItemProperty -Path $registryPath -Name "UpgradeTSEndTime" -Value $ipuEndTime -Force
    New-ItemProperty -Path $registryPath -Name "UpgradeTSStartTime" -Value $ipuStartTime -Force
}
