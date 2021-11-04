## Get Groups and their Membership by OU
#####
##### author: Kristopher F. Haughey
#$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

#$SearchBase = Read-Host -Prompt "Enter the DN for your search base-->"
#$Groups =
Get-ADGroup -Filter * -SearchBase "OU=Groups,OU=Alameda,OU=Offices,DC=CARD,DC=com" -properties members | select name, @{Name=‘Members’;Expression={$_.members -join “;”}} | export-csv c:\Temp\AlamedaGroups.csv -NoTypeInformation

#$Groups | export-csv c:\Temp\AlamedaGroups_$timestamp.csv -NoTypeInformation

###################### THIS IS JUNK RIGHT NOW ###############################
