## Join Computer to Active Directory
$Credential = (Get-Credential)
Add-Computer –Domainname <DOMAIN>.com -Credential $Credential -OUPath "OU=Workstations,OU=Objects-Computers,DC=<DOMAIN>,DC=com" -Restart –Force 