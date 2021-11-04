$serverList = get-content c:\Temp\ServerList.txt
foreach ($Server in $serverList) {
	Invoke-Command -Computername $Server -ScriptBlock {wuauclt /reportnow /detectnow}
}
