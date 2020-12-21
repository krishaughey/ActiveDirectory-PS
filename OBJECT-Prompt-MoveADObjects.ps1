# Move ADObjects
#### Prompts for origin and target OU, then moves all of the objects in the origin OU to the target OU
##### author: Kristopher F. Haughey

$OriginOU = Read-Host -Prompt "Enter the DistinguishedName of the Origin OU"
$TargetOU = Read-Host -Prompt "Enter the DistinguishedName of the Target OU"

foreach($Name in $OriginOU){
  # Retrieve DN
    $ObjectDN = (Get-ADObject -Identity $_.Name).distinguishedName
    # Move objects
    Move-ADObject -Identity $ObjectDN -TargetPath $TargetOU
  }
