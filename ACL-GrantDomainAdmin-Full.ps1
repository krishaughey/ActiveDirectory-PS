

<#
2020/08/16 07:20:08 ERROR 5 (0x00000005) Copying File E:\Offices\ALE\United Kingdom\Caroline De Fina Public\TESS\Admin\letter gemma.doc
#>
# $logContents = $null

$folderPath = "C:\ps\accessdenied_list"
$folderPath = "C:\ps\netappMigration\test"
$files = Get-ChildItem -Path "$folderPath"

foreach ($file in $files) {

    $filePath = $($file.FullName)

    #$filePath = "C:\ps\accessDenied_all.txt"
    $inputFolderName = Split-Path -path $filePath
    $inputFileName = Split-Path -path $filePath -leaf
    $outputFileName = $($file.BaseName) + "_Clean" + $($file.Extension)
    #$outputFileName = $inputFileName.Split(".")[0]+"_folders."+$inputFileName.Split(".")[1]
    $outputFileNameProcessed = $inputFolderName + "\" + $($file.BaseName) + "_Clean_Processed" + $($file.Extension)
    #$outputFileNameProcessed = $inputFileName.Split(".")[0]+"_folders_processed."+$inputFileName.Split(".")[1]
    write-host $outputFileName


    if ($null -eq $deniedList) {
        $deniedList = Get-Content $filePath
    }

    $regex = [regex]'([a-zA-Z]+:)'
    $regexFolder = [regex]'`\(?!.*`\)'
    $folderPath = $null
    $curFolderPath = $null
    $foldersList = @()
    foreach ($item in $deniedList) {
        $item -match $regex | out-null
        $fullPath = $item.Substring($item.IndexOf($matches[0]))
        $folderPath = Split-Path $fullPath
        if ($curFolderPath -ne $folderPath) {
            $curFolderPath = $folderPath
            $foldersList += $curFolderPath
        }
    }

    #$resultFile = $inputFolderName + "\" + $outputFileName
    $foldersList | out-file $resultFile

    Import-Module ActiveDirectory
    $groupName = "Domain Admins"
    $Permission = "FullControl"

    $i = 0

    foreach ($folder in $foldersList) {
        $i++
        Write-Host "Setting Permission for $folder"
        $acl = Get-Acl -Path "$folder"
        $acl.GetAccessRules()
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList @("$GroupName","$Permission","ObjectInherit, ContainerInherit","None","Allow")
        $acl.SetAccessRuleProtection($false, $false)
        $acl.SetAccessRule($rule)
        $acl |Set-Acl
        #$folder | out-file $outputFileNameProcessed -append

    }

}



<#

$logfilePath = "C:\ps\netappMigration\E_Drpartments.txt"
if ($null -eq $logContents) {
    $logContents = Get-Content "$logfilePath"
}


    $rexAccessDenied = [regex]'(0x00000005)\s*\S+\s*'


$logContents.Length

foreach ($line in $logContents) {
    if ($line -match '(0x00000005)') {
        $line | Out-File C:\ps\netappMigration\accessDenied_all.txt -append
    }
}



#>
