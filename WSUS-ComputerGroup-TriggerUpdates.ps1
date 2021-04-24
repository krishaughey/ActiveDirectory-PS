# Trigger and Update against a WSUS Computer Group
## REQUIRES PoshWSUS module https://www.powershellgallery.com/packages/PoshWSUS/2.3.1.6
##### author: Kristopher F. Haughey
#$timestamp = Get-Date -Format s #| ForEach-Object { $_ -replace ":", "." }
Write-Host "--------------------"
Write-Host "WSUS Computer Groups" -ForegroundColor Cyan
Write-Host "--------------------"
$Groups = Get-PSWSUSGroup
$Groups.Name | Format-List
Write-Host "--------------------"
Write-Host "enter the group name:" -ForegroundColor Yellow
$GroupName = Read-Host 
$Switches = "/reportnow /detectnow /updatenow"

Import-Module PoshWSUS
Connect-PSWSUSServer -WsusServer wsus1.card.com -port 8530

$GroupMembers = Get-PSWSUSClientsInGroup -Name $GroupName
foreach ($Computer in $GroupMembers) {
        Invoke-Command -Computername $Computer.FullDomainName -ScriptBlock {wuauclt.exe $Switches}
}
Write-Host "Successfully triggered $Switches on the following machines:" -ForegroundColor Green
$GroupMembers.FullDomainName | Format-List
