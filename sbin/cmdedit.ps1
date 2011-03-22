param (
	[string[]]$commands
)

foreach($cmd in $commands) {
	$local:found = $false
	$dcmd = ""
	try {
		$dcmd = Get-Command -TotalCount 1 $cmd
	}
	catch {
		try {
			$dcmd = Get-Command -TotalCount 1 "$cmd.ps1"
		}
		catch {
			try {
				$dcmd = Get-Command -TotalCount 1 "$cmd.bat"
			}
			catch {
			}
		}
	}
	if($dcmd) {
		$dcmd
		$dcmd.Definition
		MyPlace-Edit $dcmd.Definition
		$local:found=$true
	}
	<#
	foreach($dir in ($Env:MyPlace_System_CMD, $Env:MyPlace_CORE_CMD, $Env:MyPlace_CORE_SBIN)) {
		if($dir -and "Test-Path($dir)") {
			foreach($filename in ($cmd,"$cmd.ps1","$cmd.bat")) {
				$filename = "$dir\$filename"		
				if(Test-Path("$filename")) {
					Write-Output "Editing $filename ...";
					$local:found = $true
					MyPlace-Edit "$filename"
					break
				}
				else {
					$local:found = $false
				}
			}
			if($local:found) {
				break;
			}
		}
	}
	#>
	if(-not $local:found) {
		Write-Output "Command not found: $cmd" 
	}
}
