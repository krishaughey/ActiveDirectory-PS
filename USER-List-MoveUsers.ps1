# Import AD Module
import-module ActiveDirectory

# Import CSV
$MoveList = Import-Csv -Path "C:\Scripts\MoveList.csv"
# Specify target OU.This is where users will be moved.
$TargetOU = "OU=OuName,OU=OuName,DC=Domain,DC=RootDomain"
# Import the data from CSV file and assign it to variable
$Imported_csv = Import-Csv -Path "C:\Scripts\MoveList.csv"

$Imported_csv | foreach-Object { # Retrieve DN of User. $UserDN = (Get-ADUser -Identity $_.Name).distinguishedName Write-Host " Moving Accounts ..... " # Move user to target OU. Move-ADObject -Identity $UserDN -TargetPath $TargetOU }
Write-Host " Completed move "
$total = ($MoveList).count
Write-Host " $total accounts have been moved successfully..."
