#Get TargetPath of All DFS Namespaces
##### author: Kristopher F. Haughey

$GetRoots = Get-DfsnRoot | Select-Object path
$Array = @()
$Roots = $GetRoots.path | foreach-object {$_ -replace ".com",""}
$DfsnFolders = Foreach($Root in $Roots){
    #$Array += New-Object PsObject -Property @{'DFSNRoot' = $Root}
    Get-DfsnFolder -path $Root\* | Select-Object path
}
$TargetPaths = Foreach($DfsnFolder in $DfsnFolders){
    #$Array += New-Object PsObject -Property @{'Folder' = $Folder}
    $TargetPath = Get-DfsnFolderTarget -path $DfsnFolder.path | Select-Object TargetPath
    #$Array += New-Object PsObject -Property @{'TargetPath' = $TargetPath}
}
$Array | Export-csv c:\Temp\DFSN_TargetPaths.csv -NoTypeInformation


### The "Array" setup is broke AF.
where {([datetime]::FromFileTime($_.lastwritetime -le (Get-Date).adddays(-30)))}
