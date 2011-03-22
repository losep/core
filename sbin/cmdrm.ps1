param (
	[string[]]$commands
)

function Cmd-Remove([string]$cmd) {
	$local:found = $false
	$dcmd = Get-Command -TotalCount 1 $cmd
	if($dcmd) {
		Remove-Item -Confirm -Path $dcmd.Definition
		$local:found=$true
	}
	if(-not $local:found) {
		Write-Output "Command not found: $cmd" 
	}
}

foreach($cmd in $commands) {
	Cmd-Remove $cmd 
}


