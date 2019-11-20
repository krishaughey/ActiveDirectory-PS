Get-Content c:\Scripts\NA.txt | Get-ADuser -properties * | select displayname, office, DistinguishedName | Export-csv c:\Temp\NA.csv
