# Get Update Status per Client -- REQUIRES PoshWSUS module https://www.powershellgallery.com/packages/PoshWSUS/2.3.1.6
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ApprovedStates = "LatestRevisionApproved","HasStaleUpdateApprovals"
$ExcludedInstallationStates = "Unknown","NotApplicable"
$IncludedInstallationStates = "Downloaded","InstalledPendingReboot","NotInstalled"
$UpdateApprovalAction = "Install"

Import-Module PoshWSUS
Connect-PSWSUSServer -WsusServer wsus1.card.com -port 8530
$GetUpdates = Get-PSWSUSUpdatePerClient -UpdateScope (New-PSWSUSUpdateScope -ApprovedStates $ApprovedStates -ExcludedInstallationStates $ExcludedInstallationStates -IncludedInstallationStates $IncludedInstallationStates -UpdateApprovalAction $UpdateApprovalAction) | Select-Object "UpdateTitle","UpdateKB","Computername","UpdateApprovalAction","UpdateInstallationState","UpdateApprovalTargetGroupId" #| Where-Object {$_.UpdateApprovalAction -eq "Install"} #the prior where-object will filter out updates that are applied, pending but are in "unapproved" state 
$GetUpdates | Export-CSV c:\Temp\UpdatesPerClient_$timestamp.csv -NoTypeInformation
