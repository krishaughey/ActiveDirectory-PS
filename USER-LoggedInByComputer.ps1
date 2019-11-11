## Logged in User on Computer
function Get-LoggedOnUser {
#Requires -Version 2.0
[CmdletBinding()]
 param
   (
    [Parameter(Mandatory=$TRUE,
               Position=0,
               ValueFromPipeline=$TRUE,
               ValueFromPipelineByPropertyName=$TRUE)]
    [String[]]$ComputerName
   )#End Param

begin
{
 Write-Host "`n Checking Users . . . "
 $i = 0
}#Begin
process
{
    $ComputerName | foreach-object {
    $Computer = $_
    try
        {
            $processinfo = @(Get-WmiObject -class win32_process -ComputerName $Computer -EA "Stop")
                if ($processinfo)
                {
                    $processinfo | foreach-Object {$_.GetOwner().User} |
                    Where-Object {$_ -ne "NETWORK SERVICE" -and $_ -ne "LOCAL SERVICE" -and $_ -ne "SYSTEM"} |
                    Sort-Object -Unique |
                    foreach-Object { New-Object psobject -Property @{Computer=$Computer;LoggedOn=$_} } |
                    Select-Object Computer,LoggedOn
                }#If
        }
    catch
        {
            "Cannot find any processes running on $computer" | Out-Host
        }
     }#Forech-object(Comptuters)

}#Process
end
{

}#End

}#Get-LoggedOnUser


# THEN
# > Get-LoggedOnUser -ComputerName <COMPUTERNAME1,COMPUTERNAME2,COMPUTERNAME3>

# EXAMPLE
# > Get-LoggedOnUser -ComputerName WH-LAP-RL3216US,WH-VM-030,WH-LAP-RL1457US,WH-VM-FIN-001

############################################
