#Get User Account Attributes from a List    
## using a list of samAcccountNames/usernames, get user attributes specificed and export to CSV
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

$DomainController = Get-ADDomainController| Select-Object Name
$UserList = Get-Content c:\Temp\UserList.txt

$Array = @()
foreach($UserObject in $UserList){
$colItems = Get-ADuser $UserObject -Server $DomainController.Name -Properties samAccountName,givenName,surname,mail,title | Select-Object samAccountName,givenName,surname,mail,title 

    foreach ($User in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'AccountName' = $User.samAccountName
            'FirstName' = $User.givenName
            'LastName' = $User.surname
            'Email' = $User.mail
            'Title' = $User.title})
      }
    }
$Array | export-csv C:\Temp\UserAttributes_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\Temp\UserAttributes_$timestamp.csv" -ForegroundColor Cyan
