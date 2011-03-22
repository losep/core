<#

 .SYNOPSIS
  	Cygwin launcher
	
 .DESCRIPTION
 	A simple launcher for cygwin
	
 .Example
 	cygwin.ps1 
 .Example
 	cygwin.ps1 -user user -home /temp
#>

Param (
	[Alias('u','user')] [Parameter(Position=1)] [String] 
		$username = "xiaoranzzz",
	[Alias('s','sh')] [Parameter(Position=2)] [String] 
		$shell = ($Env:MyPlace_System + "\Cygwin\Bin\SH.EXE"),
	[Alias('h','home')] [Parameter(Position=3)] [String] 
		$userhome = ($Env:MyPlace_Core_Data + "\Linux\$username"),
	[Alias('a','args')] [Parameter(Position=0)] [String[]] 
		$arguments = ("--login","-i")
)


<#
foreach ($arg in ($psboundparameters).keys) {
    	Write-Output ($arg + " = " + ($psboundparameters)[$arg])
}
"Username `t= $username"
"Home `t`t= $userhome"
"Shell `t`t= $shell"
"Arguments `t= $arguments"
#>


$Env:USERNAME = $username
$Env:USER = $Env:USERNAME
$Env:HOME = $userhome

"$shell $arguments"
Start-Process -FilePath $shell -ArgumentList $arguments

<#
#foreach ($arg in $psboundparameters.keys) {
#    $arg + " = " + $psboundparameters[$arg]
#}
@echo off
title Cygwin Shell 
SET USERNAME=xiaoranzzz
SET USER=xiaoranzzz
SET HOME=%FS_CORE_DATA%\linux\xiaoranzzz
SET CHERE_INVOKING=1
%FS_SYSTEM%\CYGWIN\BIN\SH.EXE --login -i
#>