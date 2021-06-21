# WORKING

# remove the old version of the CSV
Remove-Item -Path "c:\Temp\GroupIDExport.csv"#"D:\SFTP\GroupID.csv"
# create the CSV
$SourceFile = "c:\Temp\GroupIDExport.csv"#"D:\SFTP\GroupID.csv"
Add-Content -Path $SourceFile -Value "Center,Name,Email"
# get all of the GroupID Groups
$GroupIDGroupsList = Get-ADGroup -Filter * -SearchBase "OU=GroupID,OU=Offices,DC=CARD,DC=COM" | Select-Object Name

$Array = @()
foreach ($GroupObject in $GroupIDGroupsList){
    # Get the required attributes
    $GroupAttributes = Get-ADGroup $GroupObject -properties MemberOf,Name,Mail | Select-Object MemberOf,Name,Mail
    # Convert the parent DN to a simple Name
    $ParentGroup = Get-ADGroup $($GroupAttributes.MemberOf) -properties Name | Select-Object Name
    # Put the results in the Array
        foreach ($DL in $GroupAttributes){
            $Array += New-Object PsObject -Property ( [ordered]@{
            'Center' = $ParentGroup.Name
            'Name' = $GroupAttributes.Name
            'Email' = $GroupAttributes.Mail } )
        }
}
# Export the Data to the CSV
$Array | Export-Csv c:\Temp\GroupIDExport.csv -NoTypeInformation #D:\SFTP\GroupIDExport.csv -NoTypeInformation
