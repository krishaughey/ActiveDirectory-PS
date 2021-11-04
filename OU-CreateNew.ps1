# Create New OU (with check for existing)
 $OUExist = [adsi]::Exists("LDAP://OU=TESTING,OU=Computers,OU=DomainName,dc=Domain,dc=RootDomain")
if ($OUExist)
{
    "It already exists"
} Else {
    "Creating the OU"
    New-ADOrganizationalUnit -Name 'TESTING' -Path "OU=Computers,OU=DomainName,dc=Domain,dc=RootDomain"
}

# Does an OU exist?
 $OUExist = [adsi]::Exists("LDAP://OU=TESTING,OU=Computers,OU=DomainName,dc=Domain,dc=RootDomain")
if ($OUExist)
{
    "OU already exists"
} Else {
    "OU does NOT exist"
}
