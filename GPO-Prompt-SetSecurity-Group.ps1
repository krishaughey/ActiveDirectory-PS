#Set GPO Security for Targeted GPO - Add Group
Import-Module GroupPolicy

Write-Host "Enter the name of the GPO" -ForegroundColor Green
$GpoName = Read-Host -Prompt "-->"
Write-Host "Enter the name of the group that will be added to the GPO (no quotes)" -ForegroundColor Green
$name = Read-Host -Prompt "-->"
Set-GPPermission -Name $GpoName -TargetName $name -TargetType Group -PermissionLevel GpoApply
