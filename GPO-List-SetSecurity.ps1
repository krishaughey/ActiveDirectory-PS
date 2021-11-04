#Set GPO Security for Targeted GPO from a List
Import-Module GroupPolicy

Write-Host "Enter the name of the GPO" -ForegroundColor Green
$GpoName = Read-Host -Prompt "-->"
$serverList = get-content c:\Temp\ServerList.txt
foreach ($Server in $serverList) {
	Set-GPPermission -Name $GpoName -TargetName $Server -TargetType Computer -PermissionLevel GpoApply
}
