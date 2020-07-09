# Add Account to share ACL and enable inheritence on child items
## REQUIRES PSGallery Module "NTFSSecurity"
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
# Create Log
Function LogWrite
{
Param ([string]$logstring)
Add-content $Logfile -value $logstring
}

$LogPath = "c:\Temp\"
$LogFile = "$LogPath\NTFSAccess_$timestamp.log"
LogWrite "START SCRIPT = $TimeStamp"

$Account = "CARD All Regional Vice Presidents"
LogWrite "Account: $Account"
$AccessRights = "Modify, Synchronize"
LogWrite "AccessRights: $AccessRights"
$RootPath = "\\card.com\Offices\"
LogWrite "RootPath: $RootPath"
$ChildPaths = Get-ChildItem -Path $RootPath -Directory -Name -Exclude 'Corporate','Woodland Hills'

foreach ($FolderName in $ChildPaths){
  # Concatenate RootPath and FolderName
  $FolderPath = join-path -path $RootPath -childpath $FolderName

  # Get the sub folders of all the $FolderNames under $RootPath
  Get-ChildItem -Path $FolderPath | Where-Object {$_.Name -notlike "user*folder*"} | Enable-NTFSAccessInheritance
  Get-ChildItem -Path $FolderPath | Where-Object {$_.Name -like "user*folder*"} | Disable-NTFSAccessInheritance
  # Add access permissions for $Account with ACL $AccessRights to $Paths
  Add-NTFSAccess -Path $FolderPath -Account $Account -AccessRights Modify,Synchronize -AccessType Allow
  LogWrite "$FolderName -- Processed"
}
LogWrite "END SCRIPT = $TimeStamp"
