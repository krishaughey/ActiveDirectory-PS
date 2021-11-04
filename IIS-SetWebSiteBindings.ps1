
$CSV = import-csv C:\Temp\HostnameList.csv

foreach ($Site in $CSV) {
    $Attributes = @{}
    foreach ($Property in $Binding.PSObject.Properties) {
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
    $Binding.Name
    $Attributes
    '-' * 40

    New-webBinding -Name $Site.Website -IPAddress "*" -Port $Site.Port -HostHeader $Site.HostName
    $counter++
}
