
Import-Module activedirectory
$PC=Get-ADcomputer -Filter * -Properties IPV4Address -SearchBase "OU=Computers,OU=CARD IT,DC=CARD,DC=com"
foreach ($Computer in $PC)
    {
        switch -wildcard ($Computer.IPV4Address)
            {
                "10.40.0.*" {Get-Adcomputer $Computer.Name | Move-ADObject -Targetpath "OU=IT,OU=Corporate,OU=Offices,DC=CARD,DC=com"}
               
            }
    }



Import-Module ActiveDirectory
$Computers = Import-CSV "C:\Temp\ComputerList.csv" | Where-Object { ![string]::IsNullOrWhiteSpace($_.PSObject.Properties.Value) }
$OU = "OU=Client Contacts,OU=Contacts,DC=card,DC=com"
foreach ($Computers in $CSV) {
    $Attributes = @{}
    foreach ($Property in $Computers.PSObject.Properties) {
        if ($Property.Name -eq 'cn') {
            continue
        }
        
        # if the property is a string, add it to hashtable if not null
        if ($Property.TypeNameOfValue -eq 'System.String') {
            if (-Not [string]::IsNullOrWhiteSpace($Property.Value)) {
                $Attributes.add($Property.Name,$Property.Value)
            }
            
            # if the property is not a string add it to hashtable if it's not null
        } else {
            if ($null -ne $Property.Value) {
                $Attributes.add($Property.Name,$Property.Value)
            }
        }
    }
    $Computers.cn
    $Attributes
    '-' * 40
    
    New-ADObject -Type Contact -Name $Computers.Name -OtherAttributes $Attributes -Path $OU -Verbose
    $counter++
}



Import-Module ActiveDirectory
$OriginOU = "OU=Computers,OU=CARD IT,DC=CARD,DC=com"
$TargetOU = "OU=IT,OU=Corporate,OU=Offices,DC=CARD,DC=com"
$ComputerList = Get-ADcomputer -Filter * -SearchBase $OriginOU | Select-Object distinguishedName
foreach ($Computer in $CompterList) {
    Move-ADObject -Identity $Computer.distinguishedName -Targetpath $TargetOU
}
