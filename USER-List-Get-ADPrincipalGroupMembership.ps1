# Get Group Membership of AD User from List of Names
##### author: Kristopher F. Haughey
##### 20260409

$timeStamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

#Get the list of users to query
$userList = Get-Content -Path "c:\temp\UserList.txt"

#Get the AD User Objects 
$userObjectList = foreach ($u in $userList) {
  Get-ADUser -filter 'Name -like $u'
}

#Create an empty array, enumerate each user object found, get Group membership of each user object, then populate the ordered array with custom headers
$Array = @()
foreach($userObject in $userObjectList){
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
$Array | export-csv "C:\Temp\Group_Membership_Report_$timeStamp.csv" -NoTypeInformation
Write-Host "Export available at C:\Temp\Group_Membership_Report_$timeStamp.csv" -ForegroundColor Cyan
