$ErrorActionPreference= 'silentlycontinue'
$list = (Get-Content "C:\Users\kh7487\OneDrive - Center for Autism and Related Disorders (CARD)\WORKING\PendingUpdate-Approved.txt")

$LogOutFile = Foreach ($server in $list){
  psexec \\$server wuauclt.exe \selfupdatemanaged
}
$LogOutFile | Out-File C:\Temp\wsusUpdateCheck.csv
