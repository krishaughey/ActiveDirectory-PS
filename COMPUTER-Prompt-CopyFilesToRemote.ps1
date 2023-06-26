# Copy a file to mulitiple computers
## Copies a single file to multiple computers with the same path. Prompts for hostname search string, file path, and destination
##### author: Kristopher F. Haughey
Write-Host "Enter the hostname string (e.g. - USAVP-AESI*)" -ForegroundColor Green
$HostString =  Read-Host -Prompt "-->"
$ServerList = (Get-ADComputer -Filter {name -like "$HostString"}).Name
Write-Host "Enter the full path to the file to be copied (e.g. - C:\Temp\File.dll)" -ForegroundColor Green
$FilePath =  Read-Host -Prompt "-->"
Write-Host "Enter the destination path, without the hostname (e.g. - d$\Folder\bin)" -ForegroundColor Green
$Destination = Read-Host -Prompt "-->"


foreach ($Server in $ServerList) {
    Copy-Item $File -Destination "\\$Server\$Destination" -Verbose
} 
