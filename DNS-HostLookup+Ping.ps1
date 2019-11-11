### This script performs nslookup and ping on all DNS names or IP addresses you list in the text file referenced in $InputFile.
### (One per line.) (Names or IPs can be used!) Outputs to the screen - just copy & paste the screen into Excel to work with results.

$InputFile = 'C:\Temp\HostLU.txt'
$addresses = get-content $InputFile
$reader = New-Object IO.StreamReader $InputFile
    while($reader.ReadLine() -ne $null){ $TotalIPs++ }
write-host    ""
write-Host "Performing nslookup on each address..."
        foreach($address in $addresses) {
            ## Progress bar
            $i++
            $percentdone = (($i / $TotalIPs) * 100)
            $percentdonerounded = "{0:N0}" -f $percentdone
            Write-Progress -Activity "Performing nslookups" -CurrentOperation "Working on IP: $address (IP $i of $TotalIPs)" -Status "$percentdonerounded% complete" -PercentComplete $percentdone
            ## End progress bar
            try {
                [system.net.dns]::resolve($address) | Select HostName,AddressList
                }
                catch {
                    Write-host "$address was not found. $_" -ForegroundColor Green
                }
            }
write-host    ""
write-Host "Pinging each address..."
        foreach($address in $addresses) {
            ## Progress bar
            $j++
            $percentdone2 = (($j / $TotalIPs) * 100)
            $percentdonerounded2 = "{0:N0}" -f $percentdone2
            Write-Progress -Activity "Performing pings" -CurrentOperation "Pinging IP: $address (IP $j of $TotalIPs)" -Status "$percentdonerounded2% complete" -PercentComplete $percentdone2
            ## End progress bar
                if (test-Connection -ComputerName $address -Count 2 -Quiet ) {
                    write-Host "$address responded" -ForegroundColor Green
                    } else
                    { Write-Warning "$address does not respond to pings"
                    }
        }
write-host    ""
write-host "Done!"
