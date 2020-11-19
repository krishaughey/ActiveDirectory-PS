$ImportObject = Import-Csv "C:\Temp\GroupID_DL_SMTP-20201117.csv"
Foreach ($Object in $ImportObject){
   $u = Get-ADGroup $Object."name" -properties name,mail,mailNickName
   $u | Set-ADGroup -Replace @{mail = "$($Object."mail")"}
}
Get-ADGroup -filter * -SearchBase "OU=GroupID,OU=Offices,DC=Card,DC=Com" -properties name,mail,mailNickName | Select-Object name,mail,mailNickName | Export-Csv "c:\Temp\GroupID_SMTP_results.csv"
