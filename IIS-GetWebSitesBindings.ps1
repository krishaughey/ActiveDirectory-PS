get-website | select name,id,state,physicalpath,
@{n="Bindings"; e= { ($_.bindings | select -expa collection) -join ';' }} ,
@{n="LogFile";e={ $_.logfile | select -expa directory}},
@{n="attributes"; e={($_.attributes | % { $_.name + "=" + $_.value }) -join ';' }} |
Export-Csv -NoTypeInformation -Path C:\Temp\WebsiteExport.csv
