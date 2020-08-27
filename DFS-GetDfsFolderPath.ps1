
$Roots = Get-DfsnRoot | Select-Object path
$RootPaths = @()

Foreach ($Root in $Roots){
  $Folder = Get-DfsnFolder -path $Root\* | select path
}

"Foreach"
Get-DfsnFolderTarget -path \\CARD\Websites\Media\SDVideos | select TargetPath
