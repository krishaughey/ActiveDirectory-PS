function fnCheckAndInstall-WindowsFeature ($featureName) {
    $installedState = (Get-WindowsFeature -Name $featureName).InstallState
    if ($installedState -ne 'Installed') {
        Add-WindowsFeature $featureName
    }
    else {
        Write-Host $featureName already installed.
    }
}

fnCheckAndInstall-WindowsFeature -featureName SNMP-Service
fnCheckAndInstall-WindowsFeature -featureName RSAT-SNMP

Start-Service SNMP
