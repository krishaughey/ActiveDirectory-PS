Get-Content c:\Temp\UserTelephoneSAM.txt | Get-ADuser -properties Name,Mail,TelephoneNumber | select Name,Mail,TelephoneNumber | Export-csv c:\Temp\TeleFullResults.csv
