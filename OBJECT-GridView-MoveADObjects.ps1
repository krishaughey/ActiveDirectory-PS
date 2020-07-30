# Move ADObjects by OU
##### author: Kristopher F. Haughey
Import-Module ActiveDirectory

$MoveList = Get-ADOrganizationalUnit -Filter * | Where-Object {!$_.PSIsContainer} | Out-GridView -PassThru | Out-GridView -PassThru | Select Name,DistinguishedName

# Specify target OU.This is where users will be moved.
$TargetOU = "OU=OuName,OU=OuName,DC=Domain,DC=RootDomain"
# Import the data from CSV file and assign it to variable
$Imported_csv = Import-Csv -Path "C:\Scripts\MoveList.csv"

$Imported_csv | foreach-Object { # Retrieve DN of User. $UserDN = (Get-ADUser -Identity $_.Name).distinguishedName Write-Host " Moving Accounts ..... " # Move user to target OU. Move-ADObject -Identity $UserDN -TargetPath $TargetOU }
Write-Host " Completed move "
$total = ($MoveList).count
Write-Host " $total accounts have been moved successfully..."


` THIS IS JUNK SO YOU NEED TO FIX IT, BRO `
