#Get All Scope Exclusions by Server
$DHCPServers = Get-DhcpServerInDC
foreach ($computername in $DHCPServers)
{
##Export List of DHCP Servers
#$computername | Export-Csv C:\temp\DHCPServer.csv -Append -NoTypeInformation
$scopes = Get-DHCPServerv4Scope -ComputerName $computername.DnsName |
Select-Object "Name","SubnetMask","StartRange","EndRange","ScopeID","State"


$serveroptions = Get-DHCPServerv4OptionValue -ComputerName $computername.DnsName |
Select-Object OptionID,Name,Value,VendorClass,UserClass,PolicyName

ForEach ($scope in $scopes) {
$DHCPServer = $computername.DnsName

##Export List of scopes on each server
#$scope | Export-Csv "C:\temp\$DHCPServer-Scopes.csv" -Append -NoTypeInformation

    ForEach ($option in $serveroptions) {
    $lines = @()
    $Serverproperties = @{
    Name = $scope.Name
    SubnetMask = $scope.SubnetMask
    StartRange = $scope.StartRange
    EndRange = $scope.EndRange
    ScopeId = $scope.ScopeId
    OptionID = $option.OptionID
    OptionName = $option.name
    OptionValue =$option.Value
    OptionVendorClass = $option.VendorClass
    OptionUserClass = $option.UserClass
}

$lines += New-Object psobject -Property $Serverproperties
$lines | select * #| Export-Csv C:\temp\$dhcpserver-ServerOption.csv -Append -NoTypeInformation
    }



    $exclusions = Get-DhcpServerv4Scope -ComputerName $computername.DnsName | Get-DhcpServerv4ExclusionRange -ComputerName $computername.DnsName |
    Select-Object "ScopeId","StartRange","EndRange"

    ForEach ($exclusion in $exclusions) {
   $lines2 = @()
   $exclusionAttributes = @{
    StartRange = $exclusion.StartRange
    EndRange = $exclusion.EndRange
    ScopeId = $exclusion.ScopeId

}

$lines2 += New-Object psobject -Property $exclusionAttributes
$lines2 | select ScopeId,StartRange,EndRange | Export-Csv C:\temp\$dhcpserver-exclusions.csv -Append -NoTypeInformation
  }
}
}
