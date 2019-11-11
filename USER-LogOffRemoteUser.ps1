cls
Write-Host '******************************'
Write-Host '* Log Off User Remotely *'
Write-Host '******************************'
Write-Host

$global:adminCreds = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "")
$global:ComputerName = Read-Host 'Computer Name?'
Function getSessions {
Write-host
Write-host "Getting user sessions..."
Write-Host
Write-Host '***************************************************************************'
Invoke-Command -ComputerName $global:ComputerName -scriptBlock {query session} -credential $global:adminCreds
}

Function logUserOff {
Write-Host
$SessionNum = Read-Host 'Session ID number to log off?'
$title = "Log Off"
$message = "Are you sure you want to log them off?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
"Logs selected user off."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
"Exits."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$result = $host.ui.PromptForChoice($title, $message, $options, 1)

switch ($result){
0 {
Write-Host
Write-Host 'OK. Logging them off...'
Invoke-Command -ComputerName $global:ComputerName -scriptBlock {logoff $args[0]} -ArgumentList $SessionNum -credential $global:adminCreds
Write-Host
Write-Host 'Success!' -ForegroundColor green
break
}
1 {break}
}
}

Do {
getSessions
logUserOff

Write-Host
#Write-Host "Press any key to continue ..."
# $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Configure yes choice
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Remove another profile."

#Configure no choice
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Quit profile removal"

#Determine Values for Choice
$choice = [System.Management.Automation.Host.ChoiceDescription[]] @($yes,$no)

#Determine Default Selection
[int]$default = 0

#Present choice option to user
$userchoice = $host.ui.PromptforChoice("","Logoff Another Profile?",$choice,$default)
}
#If user selects No, then quit the script
Until ($userchoice -eq 1)
