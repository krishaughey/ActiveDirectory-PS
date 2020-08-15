# Create New Contacts from CSV
#### Creates Contacts from a CSV list, places all of the attributes from the CSV in to an array, and creates new Contact objects in a selected OU
##### author: Kristopher F. Haughey

$CSV = Import-CSV "c:\Temp\ContactImport.csv" | Where-Object { ![string]::IsNullOrWhiteSpace($_.PSObject.Properties.Value) }
$OU = "OU=Client Contacts,OU=Contacts,DC=card,DC=com"

  foreach ($Contact in $CSV) {
      $Attributes = @{}
      foreach ($Property in $Contact.PSObject.Properties) {
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
      $Contact.cn
      $Attributes
      '-' * 40

      New-ADObject -Type Contact -Name $Contact.Name -OtherAttributes $Attributes -Path $OU -Verbose
      $counter++
  }
