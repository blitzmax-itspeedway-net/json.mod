SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, October 2021

Import bmx.json

Local content:String = "{~qjsonrpc~q:~q2.0~q,~qmethod~q:~qtextDocument/didChange~q,~qparams~q:{~qtextDocument~q:{~quri~q:~qfile:///home/si/dev/sandbox/loadfile/loadfile3.bmx~q,~qversion~q:2},~qcontentChanges~q:[{~qrange~q:{~qstart~q:{~qline~q:16,~qcharacter~q:0},~qend~q:{~qline~q:16,~qcharacter~q:0}},~qrangeLength~q:0,~qtext~q:~q ~q}]}}"

Local J:JSON = JSON.Parse( content )
'Publish( "debug", "Parse finished" )
' Report an error to the Client using stdOut
If Not J Or J.isInvalid()
	Local errtext:String
	If J.isInvalid()
		Print "ERROR("+J.errNum+") "+J.errText+" at {"+J.errLine+","+J.errpos+"}"
	Else
		Print "ERROR: Parse returned null"
	End If
Else
	Print "PARSE: OK"
	Print J.prettify()
End If


