##Get members of AD group and export to fomratted CSV
Get-ADGroupMember -identity "GroupName" | select name, SamAccountName | format-table -AutoSize | out-file c:\Temp\GroupName.txt
