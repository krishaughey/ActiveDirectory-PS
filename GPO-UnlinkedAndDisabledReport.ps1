#========================================================================
# Created with: SAPIEN Technologies, Inc., PowerShell Studio 2012 v3.0.1
# Created on:   24.10.2012 11:22
# Created by:   Jonathan Borgeaud - LANexpert
# Organization: LANexpert
# Filename:     find_unlinked_gpo.ps1
#========================================================================

# Import the necessary modules
Import-Module activedirectory
import-module grouppolicy

#Get AD Domain
$DomainDNS = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
$ADInfo = Get-ADDomain
$ADDomainDistinguishedName = $ADInfo.DistinguishedName


Write-host "Reading GPO information from AD (CN=Policies,CN=System,$ADDomainDistinguishedName)..."
# create an array of all policies
[array]$GPOPolicies = Get-GPO -All

Write-host "Discovered" $GPOPolicies.Count "GPOs in Active Directory ($DomainDNS)"
Write-host " `r "

Write-host "Get a list of all OUs in the domain $DomainDNS"
# Get all OU's in the domain
$AllDomainOUs = Get-ADOrganizationalUnit -filter * -properties *

Write-host "Check each OU for linked GPOs"
Write-host "There is" $AllDomainOUs.Count" OUs in" $DomainDNS
Write-host " `r "
Write-host "Checking for unlinked, linked but disabled and empty GPO's"
Write-host " `r "

# check all GPO's
ForEach ($GPO in $GPOPolicies)
{ 	# create a XML report of each GPO's
	[xml]$GPOReport = (get-gporeport -name $GPO.Displayname -ReportType xml)
	if ($null -eq $GPOReport.gpo.LinksTo) # test if the GPO's is linked
		{
			[array] $UnLinkedGPOs += $GPO.displayname
		}
	else
		{	# test if the GPO's has no settings
			if (!$GPOReport.gpo.Computer.ExtensionData -and !$GPOReport.GPO.User.ExtensionData)
				{
					[array] $EmptyGPOs += $GPO.displayname
				}
			# test if the GPO's is linked but disabled
			if (-not (($GPOReport.GPO.LinksTo | Foreach {$_.Enabled}) -eq $true))
				{
					[array]  $LinkedDisabledGPOs += $GPO.displayname
				}
		}

}

Write-host "There are" $UnLinkedGPOs.Count "unlinked," $LinkedDisabledGPOs.Count "linked but disabled and" $EmptyGPOs.Count "empty GPOs in AD"
Write-host "Unlinked GPOs :"
$UnLinkedGPOs
Write-host " `r "
Write-host "Linked but disabled GPOs :"
$LinkedDisabledGPOs
Write-host " `r "
Write-host "Empty GPOs :"
$EmptyGPOs
