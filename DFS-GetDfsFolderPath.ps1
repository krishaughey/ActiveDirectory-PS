
$Roots = Get-DfsnRoot | Select-Object path
$Folders = Foreach($Root in $Roots){
    Get-DfsnFolder -path $Root.path\* | Select-Object path
}
$TargetPaths = Foreach($Folder in $Folders){
    Get-DfsnFolderTarget -path $Folder.path | Select-Object TargetPath
}
$TargetPaths | Export-csv c:\Temp\DFSN_TargetPaths.csv -NoTypeInformation

# "WORK IN PROGRESS"
