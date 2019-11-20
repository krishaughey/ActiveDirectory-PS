# Add/Update attributes on list of user accounts
$UserListFile = "C:\Temp\UserListFile.txt"
$Users = Get-Content $UserListFile

foreach ($Account in $Users)
{
    # Update properties.
    $Account.description = "Analyst 1"
    # Update the user data in AD using the Instance parameter of Set-ADUser.
    Set-ADUser -Instance $Account
}
