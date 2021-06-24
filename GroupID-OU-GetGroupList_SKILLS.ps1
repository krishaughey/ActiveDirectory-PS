# Get GroupID Groups for SKILLS Team Export
## uses attribute 'name' for Center by removing the title via REGEX (line9)
##### author: Kristopher F. Haughey
Import-Module ActiveDirectory
$GroupIDList = Get-ADGroup -Filter " name -ne 'GroupID' -or name -notlike '*test*' " -SearchBase "OU=GroupID,OU=Offices,DC=CARD,DC=COM" -properties Name,Mail | Sort-Object Name | Select-Object Name,Mail

$Array = @()
foreach ($Group in $GroupIDList){
	$Center = $GroupIDList.Name -replace "(-\w.+)",""
    $Array += New-Object PsObject -Property ( [ordered]@{
    'Center' = ($Center)
    'Name' = $Group.Name
    'Email' = $Group.Mail} )
}
$Array | Export-Csv C:\Temp\GroupIDExport.csv -NoTypeInformation
#D:\SFTP\GroupIDExport.csv
