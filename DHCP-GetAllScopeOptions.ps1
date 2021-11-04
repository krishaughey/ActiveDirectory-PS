#Get DHCP Servers and ScopeOptions
$DHCPServers = Get-DhcpServerInDC
foreach ($computername in $DHCPServers)
{
##Export List of DHCP Servers
$computername | Export-Csv C:\temp\DHCPServer.csv -Append -NoTypeInformation
$scopes = Get-DHCPServerv4Scope -ComputerName $computername.DnsName |
Select-Object "Name","SubnetMask","StartRange","EndRange","ScopeID","State"

$lines = @()

$serveroptions = Get-DHCPServerv4OptionValue -ComputerName $computername.DnsName -All |
Select-Object Name,Value,VendorClass,UserClass

ForEach ($scope in $scopes) {
$DHCPServer = $computername.DnsName

    ForEach ($option in $serveroptions) {

        $lines += $scope | Select-Object *,@{
            "Name"="OptionScope"
            "Expression"={ "Server" }},@{
            "Name"="OptionName"
            "Expression"={ $option.name }},@{
            "Name"="OptionValue"
            "Expression"={ $option.Value }},@{
            "Name"="OptionVendorClass"
            "Expression"={ $option.VendorClass }},@{
            "Name"="OptionUserClass"
            "Expression"={ $option.UserClass }}

    }

    $scopeoptions = Get-DhcpServerv4OptionValue -ComputerName $DHCPServer -ScopeId "$($scope.ScopeId)" -All |
    Select-Object Name,Value,VendorClass,UserClass

    ForEach ($option in $scopeoptions) {

        $lines += $scope | Select-Object *,@{
            "Name"="OptionScope"
            "Expression"={ "Scope" }},@{
            "Name"="OptionName"
            "Expression"={ $option.name }},@{
            "Name"="OptionValue"
            "Expression"={ $option.Value }},@{
            "Name"="OptionVendorClass"
            "Expression"={ $option.VendorClass }},@{
            "Name"="OptionUserClass"
            "Expression"={ $option.UserClass }}

    }
$lines | Export-Csv -Path C:\temp\$DHCPServer-ScopeOptions.csv -NoTypeInformation
 }
}
