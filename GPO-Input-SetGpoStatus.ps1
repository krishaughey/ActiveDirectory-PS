## Set GPO status
##### Set status of a single GPO (AllSettingsEnabled, UserSettingsDisabled, ComputerSettingsDisabled)
##### author: Kristopher F. Haughey

# $timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Write-Host "Enter the name of the GPO" -ForegroundColor Green
$GpoName = Read-Host -Prompt "-->"

$GpoObject = Get-Gpo -Name "$GpoName"
$GpoStatus = $GpoObject.GpoStatus

@'Write-Host "Chose the resulting status option. 1=AllSettingsEnabled, 2=UserSettingsDisabled, 3=ComputerSettingsDisabled" -ForegroundColor Green
$StatusOption = Read-Host -Prompt "Enter 1, 2, or 3"
If ($StatusOption = 1)
{
  $GpoStatus="AllSettingsEnabled"
}

$2 = $GpoStatus="UserSettingsDisabled"
$3 = $GpoStatus="ComputerSettingsDisabled"
'@
