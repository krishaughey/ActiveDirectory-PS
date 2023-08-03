#Set GPO Security for Targeted GPO from a List
Import-Module GroupPolicy

Write-Host "Enter the name of the GPO" -ForegroundColor Green
$GpoName = Read-Host -Prompt "-->"
Write-Host "Enter the full path to the list of hosts that will be added to the GPO (no quotes)" -ForegroundColor Green
$hostListPath = Read-Host -Prompt "-->"
$hostList = Get-Content $hostListPath
foreach ($hostName in $hostList) {
	Set-GPPermission -Name $GpoName -TargetName $hostName -TargetType Computer -PermissionLevel GpoApply
}
