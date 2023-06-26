$ServerList = (Get-ADComputer -Filter "name -like '<HOSTNAME STRING>'").Name
$File = "<PATH TO FILE>"

foreach ($Server in $ServerList) {
    Copy-Item $File -Destination "\\$Server\d$\<PATH TO FOLDER>" -Verbose
} 
