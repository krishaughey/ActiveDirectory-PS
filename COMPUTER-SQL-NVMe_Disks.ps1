#Get all SQL Machines with Amazon EC2 NVMe Disks
##### author: Kristopher F. Haughey
Import-Module ActiveDirectory
$ADDomain = Read-Host "Enter AD Domain name (e.g.- domain.local)"
Set-ADDomain $ADDomain
$DomainController = Get-ADDomainController -Discover -Domain $ADDomain | Select-Object Name
$SearchBase = Read-Host "Enter searchbase (e.g.- OU=Servers,DC=Domain,DC=local)"
$ServerList = Get-ADComputer -Filter {name -like "*sql*"} -Searchbase $SearchBase -Server $DomainController.Name | Select-Object Name

$Array = @()
foreach ($ServerObject in $ServerList){
$colItems = Invoke-Command -ComputerName $ServerObject.Name -ScriptBlock {Get-PhysicalDisk -FriendlyName "NVMe Amazon EC2 NVMe" | Select-Object DeviceID,FriendlyName,AdapterSerialNumber,MediaType,OperationalStatus,Size}
foreach ($Disks in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
        'Server' = $ServerObject.Name
        'DiskNumber' = $Disks.DeviceID
        'FriendlyName' = $Disks.FriendlyName
        'SerialNumber' = $Disks.AdapterSerialNumber
        'Mediatype' = $Disks.Mediatype
        'OperationalStatus' = $Disks.OperationalStatus
        'Size' = $Disks.Size})
    }
}
$Array | Export-Csv c:\Temp\AmazonEC2NVMe_$Searchbase.csv -NoTypeInformation
Write-Host "export = c:\Temp\AmazonEC2NVMe_$Searchbase.csv" -ForegroundColor Cyan
