# Get Windows Roles and Features
## Report Windows Role and Feature Installations - prompted for OU
##### author: Kristopher F. Haughey
Import-Module ActiveDirectory
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
$ServerList = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,dnshostname

Write-Host "Gathering info. Depending on your searbase, this might take some time... Grab a coffee?" -ForegroundColor Green
$Array = @()
foreach ($Server in $ServerList){
$colItems = Get-WindowsFeature | Select-Object displayName,installed,installState,postConfigurationNeeded | Where-Object {$_.PostConfigurationNeeded -eq $True}
  foreach ($Feature in $colItems){
    $Array += New-Object PsObject -Property ( [ordered]@{
    'serverName' = $Server.name
    'FeatureName' = $Feature.displayName
    'installed' = $Feature.installed
    'installState' = $Feature.installState
    'pendingRestart' = $Feature.PostConfigurationNeeded } )
    }
}
$Array | export-csv c:\Temp\PendingFeatures_$timestamp.csv -NoTypeInformation
Write-Host "export = c:\Temp\PendingFeatures_$timestamp.csv" -ForegroundColor Cyan
