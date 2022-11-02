# Trigger and GPUpdate against a WSUS Computer Group
### REQUIRES PoshWSUS module https://www.powershellgallery.com/packages/PoshWSUS/2.3.1.6
##### author: Kristopher F. Haughey

Import-Module GroupPolicy
Import-Module PoshWSUS
Connect-PSWSUSServer -WsusServer wsus1.<DOMAIN>.com -port 8530
Write-Host "--------------------"
Write-Host "WSUS Computer Groups" -ForegroundColor Cyan
Write-Host "--------------------"
$Groups = Get-PSWSUSGroup
$Groups.Name | Format-List
Write-Host "--------------------"
Write-Host "enter the group name:" -ForegroundColor Yellow
$GroupName = Read-Host 

$GroupMembers = Get-PSWSUSClientsInGroup -Name $GroupName
foreach ($Computer in $GroupMembers) {
        Invoke-Gpupdate -Computer $Computer.FullDomainName -Force
}
Write-Host "Successfully triggered 'gpudpate /force' on the following machines:" -ForegroundColor Green
$GroupMembers.FullDomainName | Format-List
