#Find Accounts by OU (gridview selection) that have not logged in (x) days or more. Log, report, and remove
## add "-Whatif" at Ln 36, Col 31 to report with no action taken
Function LogWrite
{
  Param ([string]$logstring)

  Add-content $Logfile -value $logstring
}

$DaysLastLogon = "90"
$OU = Get-ADOrganizationalUnit -Filter * -Server padm075.rlcorp.local | Out-GridView -PassThru | Out-GridView -PassThru | Select Name,DistinguishedName
$TimeStamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$CsvExportPath = "C:\Temp\RemoveAdUsers\"
$FileName = "RemoveAdUsers-$TimeStamp"
$Logfile = "$CsvExportPath$Filename.log"

LogWrite "StartTime= $TimeStamp"
LogWrite "Days= $DaysLastLogon"
LogWrite "OU= $OU"
LogWrite "ReportFile= $FileName"

Write-Host "Days= $DaysLastLogon" -ForegroundColor Yellow
Write-Host "OU= $OU" -ForegroundColor Yellow
Write-Host "StartTime= $TimeStamp" -ForegroundColor Green

$FindDisabled = Get-ADUser -Filter * -SearchBase $OU.DistinguishedName -Server padm075.rlcorp.local -Properties Name,Enabled,LastlogonTimeStamp,PasswordNeverExpires | Where-Object {([datetime]::FromFileTime($_.lastlogonTimeStamp) -le (Get-Date).adddays(-$DaysLastLogon)) -and ($_.passwordNeverExpires -ne "true") }

$measure = $FindDisabled | Measure-Object
$lines = $measure.Count

LogWrite "Users= ${lines}"

Write-Host "Users= ${lines}" -ForegroundColor Green

$FindDisabled | Select displayname,userPrincipalName,Enabled,AccountExpirationDate,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}},WhenChanged | Export-csv "$CsvExportPath$FileName.csv"
$FindDisabled | Remove-ADUser

LogWrite "List of Accounts= $CsvExportPath$Filename.csv"

Write-Host "${lines} user accounts processed" -ForegroundColor Yellow
Write-Host "Report= $CsvExportPath$Filename.csv" -ForegroundColor Cyan
Write-Host "Log= $LogFile" -ForegroundColor Yellow
Write-Host "Process complete" -ForegroundColor Green

LogWrite "Process complete"
LogWrite "End Time= $TimeStamp"
