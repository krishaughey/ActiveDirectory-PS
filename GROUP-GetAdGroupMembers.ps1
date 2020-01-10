##Get members of AD group and export to fomratted CSV
Get-ADGroupMember -identity "RLC-RevSysAdmins" | select name, SamAccountName | format-table -AutoSize | out-file c:\Temp\RevSysAdmins.txt
