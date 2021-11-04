Get-Content c:\Temp\import.txt | Foreach-Object {get-aduser -filter "displayName -like '$($_)'" | Select-Object SamAccountName}
