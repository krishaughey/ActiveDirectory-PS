#Step through all your DCs and remove secondary zones for:
 #gci
 #dns.gci
 #ad.gannett.com
 #(it should throw an error and move on if the zone isn’t there)

#Then it makes conditional forwarders for
#gci
#dns.gci

ad.gannett.comget-adcomputer -ldapfilter "(userAccountControl=532480)" | foreach {
  Remove-DNSServerZone -name ad.gannett.com -computerName $_.dnshostname -force:$true;
  add-DNSServerConditionalForwarderZone -name ad.gannett.com -computerName $_.dnshostname -MasterServers '172.30.0.40','172.20.0.40','172.20.0.153','172.20.0.183';
  Remove-DNSServerZone -name gci -computerName $_.dnshostname -force:$true;
  add-DNSServerConditionalForwarderZone -name gci -computerName $_.dnshostname -MasterServers '172.23.1.44','172.24.1.44','172.24.129.44';
  Remove-DNSServerZone -name dns.gci -computerName $_.dnshostname -force:$true;
  add-DNSServerConditionalForwarderZone -name dns.gci -computerName $_.dnshostname -MasterServers '172.23.1.44','172.24.1.44','172.24.129.44';
  add-DNSServerConditionalForwarderZone -name dmz.gannett.com -computerName $_.dnshostname -MasterServers '172.23.1.44','172.24.1.44','172.24.129.44';
}
