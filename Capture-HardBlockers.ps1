$tsEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$targetWindowsBuild = $tsEnv.Value("SMSTSTargetOSBuild")
$companyName = $tsEnv.Value("SMSTSCompanyName")
$registryPath = "HKLM:\SOFTWARE\$companyName\WaaS\$targetWindowsBuild"
$searchLocation = 'C:\$WINDOWS.~BT\Sources\Panther'
$compatibilityXMLs = Get-childitem "$SearchLocation\compat*.xml" | Sort LastWriteTime –Descending
$blockers = @()
foreach ($item in $compatibilityXMLs) {
    $xml = [xml]::new()
    $xml.Load($item)
    $hardBlocks = $xml.CompatReport.Hardware.HardwareItem | Where {$_.InnerXml -match 'BlockingType="Hard"'}
    if ($hardBlocks) {
        foreach ($hardBlock in $hardBlocks) {
            $blockers += [pscustomobject]@{
                FileName = $item.Name
                BlockingType = $hardBlock.CompatibilityInfo.BlockingType
                Title = $hardBlock.CompatibilityInfo.Title
                Message = $hardBlock.CompatibilityInfo.Message
                Link = $hardBlock.Link.Target
            }
        }
    }
}
if ($blockers) {
    if ($blockers.BlockingType) {
        New-ItemProperty -Path $registryPath -Name "HardBlockType" -Value $blockers.BlockingType -Force
    }
    if ($blockers.Title) {
        New-ItemProperty -Path $registryPath -Name "HardBlockTitle" -Value $blockers.Title -Force
    }
    if ($blockers.Message) {
        New-ItemProperty -Path $registryPath -Name "HardBlockMessage" -Value $blockers.Message -Force
    }
    if ($blockers.Link) {
        New-ItemProperty -Path $registryPath -Name "HardBlockLink" -Value $blockers.Link -Force
    }
}
