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

dim UserArgs
UserArgs = InputBox(_ 
    "About to run :" & vbcrlf & prog & vbcrlf & _
    "Give it some arguments?" & vbcrlf,"LoadProg" _
    )

if UserArgs <> "" then
    progargs = UserArgs
end if

Dim wsh
Set wsh = WScript.CreateObject("WScript.Shell")
wsh.run(prog & progargs)

