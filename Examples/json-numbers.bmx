SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

Import bmx.json

Function Validate:JSON( text:String )
	Print text
	Local j:JSON = JSON.Parse( text )
	If j.isInvalid()
		Print "FAILURE: "
		Print "  ERROR: "+ j.errtext + " {"+ j.errline+","+j.errpos+"}"
	Else
		Print "SUCCESS"
	End If
	Return J
End Function

'	TEST

'DebugStop
Local J:JSON
J = Validate( "{ ~qname~q:~qAlice~q,~qAge~q:-37000 }" )
Print J.stringify()
J = Validate( "{ ~qname~q:~qAlice~q,~qAge~q:6.25 }" )
Print J.stringify()


