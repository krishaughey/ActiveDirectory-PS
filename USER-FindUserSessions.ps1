#############################################

# FIND COMPUTERS BY USERNAME
# ********************************************************************************
#
# Script Name: QueryUsersForLastLogon.ps1
# Version: 1.0
# Author: CRA
# Date: 13.01.15
# Location:
# Applies to: Computers
#
# Description: This script searches for a specific, logged on user on all or
# specific Computers by checking the process "explorer.exe" and its owner.
#
# ********************************************************************************

#Set variables
$progress = 0

#Get Admin Credentials
function Get-Login {
Clear-Host
Write-Host "Please provide admin credentials (for example DOMAIN\admin.user and your password)"
$Global:Credential = Get-Credential
}
Get-Login

#Get Username to search for
function Get-Username {
	Clear-Host
	$Global:Username = Read-Host "Enter username you want to search for"
	if ($Username -eq $null){
		Write-Host "Username cannot be blank, please re-enter username!"
		Get-Username
	}
	$UserCheck = Get-ADUser $Username
	if ($UserCheck -eq $null){
		Write-Host "Invalid username, please verify this is the logon id for the account!"
		Get-Username
	}
}
Get-Username





##Get Computername Prefix for large environments
function Get-Prefix {
	Clear-Host
	$Global:Prefix = Read-Host "Enter a prefix of Computernames to search on (CXX*) use * as a wildcard or enter * to search on all computers"
	Clear-Host
}
Get-Prefix

#Start search
$computers = Get-ADComputer -filter {Enabled -eq 'true' -and SamAccountName -like $Prefix}
$CompCount = $Computers.Count
Write-Host "Searching for $Username on $Prefix on $CompCount Computers`n"

#Start main foreach loop, search processes on all computers
foreach ($comp in $computers){
	$Computer = $comp.Name
	$Reply = $null
  	$Reply = test-connection $Computer -count 1 -quiet
  	if($Reply -eq 'True'){
		if($Computer -eq $env:COMPUTERNAME){
			#Get explorer.exe processes without credentials parameter if the query is executed on the localhost
			$proc = gwmi win32_process -ErrorAction SilentlyContinue -computer $Computer -filter "Name = 'explorer.exe'"
		}
		else{
			#Get explorer.exe processes with credentials for remote hosts
			$proc = gwmi win32_process -ErrorAction SilentlyContinue -Credential $Credential -computer $Computer -filter "Name = 'explorer.exe'"
		}
			#If $proc is empty return msg else search collection of processes for username
		if([string]::IsNullOrEmpty($proc)){
			write-host "Failed to check $Computer!"
		}
		else{
			$progress++
			foreach ($p in $proc) {
				$temp = ($p.GetOwner()).User
				Write-Progress -activity "Working..." -status "Status: $progress of $CompCount Computers checked" -PercentComplete (($progress/$Computers.Count)*100)
				if ($temp -eq $Username){
				write-host "$Username is logged on $Computer"
				}
			}
		}
	}
}
write-host "Search done!"

##################################
