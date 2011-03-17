
Param (
    [alias("r","root")][parameter(Position=1)][String][AllowEmptyString()]$MYPLACE_ROOT,
    [alias("w","working-dir")][parameter(Position=2)][String]$OPT_WDIR,
    [alias("h","help")][parameter(Position=3)][switch]$OPT_HELP,
    [alias("n","no-cmds")][parameter(Position=4)][switch]$OPT_NO_CMDS,
    [alias("c","commands")][parameter(Position=0)][String[]]$CMDS
)

$MyPlace = @{
	'AppName' = 'Shell';
	'AppVersion' = '1.0';
	'AppPath' = Get-Item($MyInvocation.MyCommand.Path);
	'AutoInitDir' = 'auto.d';
	'AutoInitFilename' = "init.ps1"
	'Env' = @{}
}

@'

         ============================================================
         =                                                          =
         =                  MyPlace PowerShell V1.0                 =
         =                                                          =
         =                                               xiaoranzzz =
         =                                                3/17/2011 =
         ============================================================
		 
'@



function message([string]$title,[string[]]$text) {
    #$title = $args[0]
    #$text = $args[1]
    for($i = 2;$i -lt $args.Count;$i++) {
        #$text += " " + $args[$i]
    }
   Write-Output ("[" + $title + "] " + $text)
}


function MYPLACE_setenv([string]$name,[string]$value) {
	#$env_name = "env:MYPLACE_" + $name
	#Set-Item -Path $env_name -Value $value
	$MyPlace['Env'][$name] = $value
	#message $Myplace["AppName"] ("Set MYPLACE_" + $name + " [ " + (Get-Item -Path $env_name).Value + " ]")
}
function MYPLACE_getenv([string]$name) {
	return $MyPlace['Env'][$name]
	#$env_name = "env:MYPLACE_" + $name
	#return (Get-Item -Path $env_name).Value
}

function init_auto([String] $path) {
	if(Test-Path ($path + "\" + $Myplace["AutoInitFilename"])) {
		message $Myplace["AppName"] ("Processing " + $path + "\" + $Myplace["AutoInitFilename"])
		. ($path + "\" + $Myplace["AutoInitFilename"])
	}
	if(Test-Path ($path + "\" + $Myplace["AutoInitDir"])) {
		Get-ChildItem -Path ($path + "\" + $Myplace["AutoInitDir"]) -Filter '*.ps1' | Sort-Object | ForEach-Object {
			message $Myplace["AppName"] ("Processing " + $_.Fullname + " ...")
			. ($_.Fullname)
		}
	}
}

function init_exec([String] $name, [String] $path) {
	foreach($en in $EXEC_NAMES) {
		$ep = $path + "\" + $en
		$en = $en.ToUpper()
		if(Test-Path $ep) {
			$ep = Get-Item($ep)
			MYPLACE_setenv ($name + "_" + $en) $ep.Fullname
			$MyPlace['Env']['New_Path'] = $ep.Fullname + ";" + $MyPlace['Env']['New_Path']
			$Env:PATH = $MyPlace['Env']['New_Path'] + $MyPlace['Env']['Old_Path']
			init_auto $ep.Fullname
		}
	}
}
function init_component([String] $name, [String] $path) {
	init_exec $name.ToUpper() $path
	init_auto $path
	foreach($sc in $SUB_COMPS) {
		$sn = $sc.ToUpper()
		$sc = $path + "\" + $sc
		if(Test-Path $sc) {
			$sc = Get-Item($sc)
			MYPLACE_setenv ($name + "_" + $sn) $sc.Fullname
			init_exec ($name + "_" + $sn) $sc.Fullname
			init_auto $sc.Fullname
		}
	}
}





function Init-Myplace() {

	$CWD = Get-Location
	$CORE_NAME = '\core'
	$COMPONENTS = "core","system","local","workspace","temp",'appdata'
	$EXEC_NAMES = "bin","cmd","sbin"
	$SUB_COMPS = "app","data"
	$MYPLACE_NEW_PATH = ""
	
	<#
	设定 MYPLACE_ROOT, 1.参数指定 2.脚本父目录上溯至 $CORE_NAME 3.脚本父目录的父目录
	#>
	if(!$MYPLACE_ROOT) {
	    $MYPLACE_ROOT = $Myplace["AppPath"].Directory.Fullname
	    $i = $MYPLACE_ROOT.lastIndexOf($CORE_NAME)
	    if($i) {
	        $MYPLACE_ROOT = $MYPLACE_ROOT.Remove($i);
	    }
	    else {
	        $MYPLACE_ROOT = $Myplace["AppPath"].Directory.Parent.Fullname
	    }
	}
	message $Myplace["AppName"] "ROOT in",$MYPLACE_ROOT
	MYPLACE_setenv "ROOT" $MYPLACE_ROOT

	foreach ($c in $COMPONENTS) {
	    $MYPLACE_comp = $MYPLACE_ROOT + "\" + $c
		$c = $c.ToUpper()
	    if(Test-Path $MYPLACE_comp) {
			message $Myplace["AppName"] "Initializing $c ..."
			$MYPLACE_comp = Get-Item($MYPLACE_comp)
			MYPLACE_setenv $c $MYPLACE_comp.Fullname
	    }
	    init_component $c $MYPLACE_comp.Fullname
	}
	[Array]::Reverse([Array] $COMPONENTS)
	foreach ($c in $COMPONENTS) {
		$c = $c.ToUpper()
		foreach($e in ($EXEC_NAMES + $SUB_COMPS)) {
			$e = $e.ToUpper()
			if(-not $MyPlace['Env'][$e]) {
				if($MyPlace['Env'][($c + '_' + $e)]) {
					$MyPlace['Env'][$e] = $MyPlace['Env'][($c + '_' + $e)]
				}
			}
		}
	}
}

#foreach ($arg in $psboundparameters.keys) {
#    $arg + " = " + $psboundparameters[$arg]
#}
if(Test-path 'Env:MyPlace_Old_Path') {
	$Env:Path = $Env:MyPlace_Old_Path
}
Remove-Item -Path 'Env:MYPLACE_*'
$MyPlace['Env'] = @{}
$MyPlace['Env']['Old_Path'] = $Env:Path
Init-Myplace
$MyPlace
$MyPlace['Env'].keys | ForEach-Object {
	Set-Item -Path ('Env:MyPlace_' + $_) -Value $MyPlace['Env'][$_]
}
Get-Item -path 'Env:MyPlace_*'
$Env:Path
<#
:usage
echo Shell v1.0
echo        - xiaoranzzz@gmail.com
echo Usage:
echo    Shell [-r ROOT_DIR] [cmds...]
echo Option:
echo    -h      	Display this texts
echo    -r      	Set shell MYPLACE_ROOT directory
echo    -d      	Set shell working directory
echo	-i		Inherit parent MYPLACE_ROOT PATH...
echo	-s,--NO_CMDS	Set no cmd mode
pause
goto END


#>
