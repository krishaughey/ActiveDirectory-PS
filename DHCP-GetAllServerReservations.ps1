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



    $reservations = Get-DhcpServerv4Scope -ComputerName $computername.DnsName | Get-DhcpServerv4Reservation -ComputerName $computername.DnsName |
    Select-Object *

    ForEach ($reservation in $reservations) {
   $lines2 = @()
   $ReservationAttributes = @{
   ScopeId = $reservation.ScopeId
   Name = $reservation.Name
   ClientId = $reservation.ClientId
   IPAddress = $reservation.IPAddress
   Type = $reservation.Type

}

$lines2 += New-Object psobject -Property $ReservationAttributes
$lines2 | select ScopeId,Name,ClientId,IPAddress,Type | Export-Csv C:\temp\$dhcpserver-Reservations.csv -Append -NoTypeInformation
  }
}
}
