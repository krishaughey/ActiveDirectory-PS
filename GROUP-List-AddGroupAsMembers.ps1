$Members = Get-Content c:\Temp\GroupMembers.txt | Foreach-Object {get-AdGroup -filter "displayName -like '$($_)'" | Select-Object SamAccountName}

foreach($Member in $Members){
    Add-AdGroupMember "Central Regional Managers" $Member
}
