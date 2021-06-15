#Set GPO Security for Targeting a Specific WSUS Computer Group (WSUS-ServerOS_group03)
## REQUIRES PoshWSUS Module
### GPO = "WSUS-ServerOS-ScheduleInstall (TARGETED)"
#### author: Kristopher F. Haughey

Import-Module GroupPolicy
Import-Module PoshWSUS
Connect-PSWSUSServer -WsusServer wsus1.card.com -port 8530
$GpoName = "WSUS-ServerOS-ScheduleInstall (TARGETED)"
$GroupName = "WSUS-ServerOS_group03"
$GroupMembers = Get-PSWSUSClientsInGroup -Name $GroupName

foreach ($Computer in $GroupMembers) {
    $ComputerName = Get-ADComputer -Filter {DNSHostName -eq $Computer.FullDomainName } -SearchBase "DC=Card,DC=com"
    Set-GPPermission -Name $GpoName -TargetName $Computername.name -TargetType Computer -PermissionLevel GpoApply
}
