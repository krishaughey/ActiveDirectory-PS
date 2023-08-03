#Set GPO Security for WORKVIVO Homepage GPO
Import-Module GroupPolicy

$GpoName = "Arbonne Workvivo Home Page"

Set-GPPermission -Name $GpoName -TargetName "Authenticated Users" -TargetType Group -PermissionLevel GpoApply
Set-GPPermission -Name $GpoName -TargetName "DLS-Intranet Home GPO" -TargetType Group -PermissionLevel None
