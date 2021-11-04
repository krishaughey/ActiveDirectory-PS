## Find Accounts by OU (gridview selection) that have not logged in (x) days or more. Log, report, and REMOVE
## (remove "#" before "-Whatif" at Ln 55, Col 55 to report with no action taken)
## Export path = Ln 31
## author: Kristopher F. Haughey

#Create the log
Function LogWrite
{
Param ([string]$logstring)

Add-content $Logfile -value $logstring
}

Write-Host "You are running PS Script user-prompt-REMOVEadusers.ps1" -ForegroundColor Yellow
#User input for Credentials
Write-Host "Enter your username and password" -ForegroundColor Yellow
$Global:Credential = Get-Credential

#User input for number of days
write-host "enter the number of days since last logon and press enter" -ForegroundColor Yellow

$input = Read-Host -Prompt "-->"
$DaysLastLogon = $input

#Griview for OU(s) to select
Write-Host "Select OU(s) to target" -ForegroundColor Yellow
$OU = Get-ADOrganizationalUnit -Filter * -Credential $Credential | Out-GridView -PassThru | Out-GridView -PassThru | Select Name,DistinguishedName

#Set variables for format and filenames
$TimeStamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$CsvExportPath = "C:\Temp\"
$FileName = "RemoveAdUsers-$TimeStamp"
$Logfile = "$CsvExportPath$Filename.log"

#Write all of the gathered data in to the log
LogWrite "StartTime= $TimeStamp"
LogWrite "Days= $DaysLastLogon"
LogWrite "OU= $OU"
LogWrite "ReportFile= $FileName"

Write-Host "Days= $DaysLastLogon" -ForegroundColor Yellow
Write-Host "OU= $OU" -ForegroundColor Yellow
Write-Host "StartTime= $TimeStamp" -ForegroundColor Cyan

#Search the selected OU for disabled more that (x) days - input from line 18
$UserList = Get-ADUser -Filter * -Credential $Credential -SearchBase $OU.DistinguishedName -Properties Name,Enabled,LastlogonTimeStamp,PasswordNeverExpires | Where-Object {([datetime]::FromFileTime($_.lastlogonTimeStamp) -le (Get-Date).adddays(-$DaysLastLogon)) -and ($_.passwordNeverExpires -ne "true") }

#Count the objects returned for log and display
$measure = $UserList | Measure-Object
$lines = $measure.Count
LogWrite "Users= ${lines}"
Write-Host "Users= ${lines}" -ForegroundColor Yellow

#Select the user objects from the search, REMOVE then report
$UserList | Remove-ADUser -Credential $Credential #-Whatif
$UserList | Select displayname,userPrincipalName,Enabled,AccountExpirationDate,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}},WhenChanged | Export-csv "$CsvExportPath$FileName.csv"

LogWrite "List of Accounts= $CsvExportPath$Filename.csv"

Write-Host "${lines} user accounts processed" -ForegroundColor White
Write-Host "Report= $CsvExportPath$Filename.csv" -ForegroundColor Cyan
Write-Host "Log= $LogFile" -ForegroundColor Cyan
Write-Host "Process complete" -ForegroundColor Yellow

#Press any key to end (this will error if ran from ISE)
Write-Host -NoNewLine 'Press any key to close...' -ForegroundColor Green;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

LogWrite "Process complete"
LogWrite "End Time= $TimeStamp"
##THE END##
