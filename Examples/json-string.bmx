SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

'	This example tests different types of string parsing

Import bmx.json

Function Validate:JSON( text:String )
	Print "----------------------------------------"
	Print "IN:  " + text
	Local j:JSON = JSON.Parse( text )
	Local jtext:String = J.Stringify()
	Print "OUT: " + jtext
	If j.isInvalid()
		Print "- FAILURE: "
		Print "  ERROR: "+ j.errtext + " {"+ j.errline+","+j.errpos+"}"
	Else
		Print "- SUCCESS"
	End If
	Return J
End Function

' 7 Bit Ascii
Local str:String
For Local n:Int = 32 To 126
	str:+Chr(n)
Next
Print str

Print ""

'DebugStop
Local J:JSON

' Empty string
Validate( "{~qname~q:~q~q}" )

' "NORMAL" characters in it
Validate( "{~qname~q:~qAlice~q}" )

' "Any codepoint except " or \ or control characters"
Validate( "{~qname~q:~q!#$%&'()*+,-./:;<=>?@[]^_`{|}~q}" )

' Escape characters:
Validate( "{~qname~q:~q#\n\r\~q#~q}" )

Validate( "{~qname~q:~q~~37~q}" )

' Universal HEX Digits (Uses a hash symbol, # == asc(35) : 35 == 0x23
Validate( "{~qname~q:~q\u0023~q}" )

' Embedded Text Document:
Local document:String = "\n'   INCLUDE APPLICATION COMPONENTS\r\n\r\n'DebugStop\r\n\r\nInclude \~qbin/TObserver.bmx\~q\r\n"
Validate( "{~qname~q:~q"+document+"~q}" )


document = "{~n-r~qlogfile~q:~q/home/scaremonger/dev/logfilelog~q,~n~qloglevel~q:~q7~q,~n~qthreadpool~q:4~n}~n"
Validate( document )




