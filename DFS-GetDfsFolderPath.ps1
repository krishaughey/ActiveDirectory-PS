#Get TargetPath of All DFS Namespaces
##### author: Kristopher F. Haughey

$GetRoots = Get-DfsnRoot | Select-Object path
$Roots = $GetRoots.path | foreach-object {$_ -replace ".com",""}
$Folders = Foreach($Root in $Roots){
    Get-DfsnFolder -path $Root\* | Select-Object path
}
$TargetPaths = Foreach($Folder in $Folders){
    Get-DfsnFolderTarget -path $Folder.path | Select-Object TargetPath
}
$TargetPaths | Export-csv c:\Temp\DFSN_TargetPaths.csv -NoTypeInformation

# "WORK IN PROGRESS"
