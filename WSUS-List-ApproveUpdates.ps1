$UpdateList = get-content c:\Temp\UpdateList.txt
$groups = Get-PSWSUSGroup -Name "WSUS-ServerOS_group02"
foreach ($update in $UpdateList) {
Get-PSWSUSUpdate -Update $update | Approve-PSWSUSUpdate -Group $groups -Action Install
}
