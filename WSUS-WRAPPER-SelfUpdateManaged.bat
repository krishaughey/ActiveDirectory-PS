@echo OFF - Wrapper to Log Script
echo [%date% - %time%] Log start >> C:\Temp\WSUS\wsusSelfUpdateManaged-Log.txt
powershell "C:\Temp\WSUS\wsusSelfUpdateManaged.ps1" >> C:\Temp\WSUS\wsusSelfUpdateManaged-Log.txt 2>&1
