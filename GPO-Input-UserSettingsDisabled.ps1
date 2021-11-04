## Set GPO status
##### Set status of a single GPO (AllSettingsEnabled, UserSettingsDisabled, ComputerSettingsDisabled)
##### author: Kristopher F. Haughey

# $timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Write-Host "Enter the name of the GPO" -ForegroundColor Green
$GpoName = Read-Host -Prompt "-->"
#Write-Host "Enter the DC" -ForegroundColor Green
#$DC = Read-Host -Prompt "-->"
$GpoObject = Get-Gpo -Name "$GpoName" -Server DC2 #$DC
$GpoStatus = $GpoObject.GpoStatus

write-host $GpoObject.GpoStatus

$GpoStatus="UserSettingsDisabled"
write-host $GpoStatus
