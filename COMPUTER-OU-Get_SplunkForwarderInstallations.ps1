 #Discover Splunk Universal Forwarder Installations
## Search and report on servers within an AD OU for the SplunkForwarder application
#### https://github.com/krishaughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

### Get a list of active servers from an OU
$SearchBase = "OU=<OU>,DC=<DOMAIN>,DC=<DOMAIN>"
$ServerList = Get-Adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase

### Check for and Report on Splunk Installations to CSV
$Array = @()
foreach($ServerObject in $Serverlist){
    $colItems = Invoke-Command -ComputerName $ServerObject.Name -ScriptBlock {Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "UniversalForwarder"}}
    
        foreach ($Server in $colItems){
            $Array += New-Object PsObject -Property ([ordered]@{
                'Server' = $ServerObject.Name
                'Software' = $colItems.Name
                'Version' = $colItems.Version})
          }
        }

$Array | Export-Csv -Path C:\Temp\SoftwareReport_$timestamp.csv -NoTypeInformation 
Write-Output "Export available at -- C:\Temp\SoftwareReport_$timestamp.csv --" -ForegroundColor Cyan