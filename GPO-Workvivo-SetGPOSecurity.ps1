#Set GPO Security for One or More GPO Objects
Import-Module GroupPolicy

$GpoName = "<NAME>"

Set-GPPermission -Name $GpoName -TargetName "Authenticated Users" -TargetType Group -PermissionLevel GpoApply
Set-GPPermission -Name $GpoName -TargetName "<AD OBJECT>" -TargetType Group -PermissionLevel None
