# ActiveDirectory-PS

![PowerShell](https://repository-images.githubusercontent.com/221074232/158c2480-5262-11ea-8af0-452a86d9e56d)

##### Log & Timestamp Wrapper Batch
    @echo OFF - Wrapper to Log Script
    echo [%date% - %time%] Log start >> C:\Temp\WSUS\wsusSelfUpdateManaged-Log.txt
    powershell "\\<ServerName>\<PATH>.ps1" >> C:\Temp\WSUS\wsusSelfUpdateManaged-Log.txt 2>&1

##### Reset AD Computer Object Password
Reset-ComputerMachinePassword -Server "<SERVER>"
