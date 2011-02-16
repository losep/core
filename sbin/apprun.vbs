dim Args,prog,progargs
set Args = WScript.Arguments

if(Args.count>0) then
    prog = Args.item(0)
    dim q
    q = chr(34)
    prog = q & prog & q
    dim i
    for i = 1 to Args.count -1
        progargs = progargs & " " & q & Args.item(i) & q
    next
end if

if prog = "" then
	WScript.Echo "Usage:Apprun [command]"
else
	Dim wsh
	Set wsh = WScript.CreateObject("WScript.Shell")
	WScript.Echo "Running " & prog & progargs & " ..."
	wsh.run prog & progargs,1,false
end if

