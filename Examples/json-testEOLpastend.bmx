SuperStrict

'	JSON TEST
'	(c) Copyright Si Dunford, June 2021

'	FOR SANDBOX TESTING / CONTENT WILL CHANGE AS REQUIRED

' This tests a "pretty" JSON file with trailing EOL after "}"

Import bmx.json

Local J:JSON
Local Text:String
Text = "{~n~r~qlogfile~q:~q/home/scaremonger/dev/logfilelog~q,~n~qloglevel~q:~q7~q,~n~qthreadpool~q:4~n}~n"

Print "IN:~n  " + Text
'DebugStop
J = JSON.Parse( Text )
Print "OUT:~n  " + J.Stringify()

If j.isInvalid()
	Print "- FAILURE: "
	Print "  ERROR: "+ j.errtext + " {"+ j.errline+","+j.errpos+"}"
Else
	Print "- SUCCESS"
End If



