param (
	[string]$filepath
)
function Cmd-New([string]$filepath) {
	if(-not $filepath) {
		Write-Error "Useage: Cmd-new <command name>"
		return $false
	}
	if(-not ($filepath -match '\.[^\.]+$')) {
		$filepath = $filepath + ".ps1"
	}
	if(-not (Test-Path($filepath))) {
		$filepath = $MyPlace['Env']['Core_CMD'] + '\' + $filepath
	}
	if(Test-Path($filepath)) {
		MyPlace-Edit $filepath 
	}
	else {
		MyPlace-Edit $filepath 
	}
}

if($filepath) {
	Cmd-New $filepath 
}
