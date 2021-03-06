param (
	[alias('a')][parameter(position=0)][String[]]$arguments,
	[alias('p')][parameter(position=1)][string]$profile = "xiaoranzzz"
)

$firefox_bin = $MyPlace['Env']['System_App'] + '\internet\firefox\firefox.exe'
$firefox_reg = 'HKLM:\software\mozilla\mozilla firefox'
if(TEST-PATH $firefox_reg) {
	$firefox_ver = (Get-Item $firefox_reg).GetValue('CurrentVersion')
	$firefox_reg = $firefox_reg + '\' + $firefox_ver + '\Main'
	if(Test-Path $firefox_reg) {
		$firefox_bin = (Get-Item $firefox_reg).GetValue('PathToExe')
	}
}
$PROFILE = $MyPlace['Env']['AppData'] + "\firefox\profiles\$profile"
"$firefox_bin -profile $profile $arguments"
if($arguments) {
	MyPlace-Start -FilePath  $firefox_bin -ArgumentList (("-profile",$PROFILE,"-arguments") + $arguments)
}
else {
	MyPlace-Start -FilePath  $firefox_bin -ArgumentList "-profile",$PROFILE
}
