# Get Group Membership of AD User by First and Last Name Search
### searches givenName and surName by partial or full string
##### author: Kristopher F. Haughey
##### 20260409

$timeStamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

#Prompt for FirstName
$givenName ='*' + $(Read-Host -Prompt "Enter the first (given) name of the User you'd like to query -->") + '*'

#Prompt for LastName
$surName = '*' + $(Read-Host -Prompt "Enter the last (sur) name of the User you'd like to query -->") + '*'

#Query by the user's first (givenname) and last (surname) with wildcards
$userList = Get-ADUser -Filter 'givenName -like $givenName -and surName -like $surName'

#String for File Name Uniquness, removing the wildcards and seperating by "_"
$appendFileName = @($givenName.Replace("*",""),$surName.Replace("*",""),$timeStamp) | Join-String -Separator '_'

#Create an empty array, enumerate each user object found, get Group membership of each user object, then populate the ordered array with custom headers
$Array = @()
foreach($userObject in $userList){
$groupQuery = Get-ADPrincipalGroupMembership $userObject | Select-Object samAccountName,groupCategory,groupScope,distinguishedName
    foreach ($groupObject in $groupQuery){
        $Array += New-Object PsObject -Property ([ordered]@{
        'UserSAM' = $userObject.samAccountName
        'UserDN' = $userObject.DistinguishedName
        'GroupSAM' = $groupObject.samAccountName
        'GroupCategory' = $groupObject.GroupCategory
        'GroupScope' = $groupObject.GroupScope
        'GroupDN' = $groupObject.distinguishedName})
    }
  }

#Send the populated array out Host and to CSV (C:\Temp)
$Array | Write-Output | ft
$Array | export-csv "C:\Temp\Group_Membership_Report_$appendFileName.csv" -NoTypeInformation
Write-Host "Export available at C:\Temp\Group_Membership_Report_$appendFileName.csv" -ForegroundColor Cyan
