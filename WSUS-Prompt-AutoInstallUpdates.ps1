## Auto Install WSUS Updates
#### Auto Install WSUS Updates from list (prompted)
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerListPath = Read-Host -Input "Enter the path to your server list (e.g - c:\Temp\)"
$ServerList = (Get-Content $ServerListPath)
$Array = foreach ($Server in $ServerList){
  Install-WindowsUpdate -ComputerName Billing -AcceptAll -Install -AutoReboot
}
$Array | Export-Csv $ServerListPath
## END ##
