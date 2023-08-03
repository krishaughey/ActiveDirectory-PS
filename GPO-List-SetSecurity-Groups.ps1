#Set GPO Security for Targeted GPO from a List of Groups
Import-Module GroupPolicy

Write-Host "Enter the name of the GPO" -ForegroundColor Green
$GpoName = Read-Host -Prompt "-->"
Write-Host "Enter the full path to the list of Groups that will be added to the GPO (no quotes)" -ForegroundColor Green
$groupListPath = Read-Host -Prompt "-->"
$groupList = Get-Content $groupListPath
foreach ($groupName in $groupList) {
	Set-GPPermission -Name $GpoName -TargetName $groupName -TargetType Group -PermissionLevel GpoApply
}
