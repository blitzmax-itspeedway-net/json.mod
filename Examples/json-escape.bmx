SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

'	Tests escaping of strings.

',"kind":0,"name":"SKIPPED 'Original message "' [4,21]","range":{"end":{"character":39,"line":3},"start":{"character":21,"line":3}},"selectionRange":{"end":{"character":39,"line":3},"start":{"character":21,"line":3}}},

Import bmx.json

Print "JSON VERSION: "+JSON.Version()

Local J:JSON, Result:JSON, Text:String

Local WhatFredSaid:String = "Fred said ~qHello~q."

'DebugStop
Print "~n--TEST1--------"
J = New JSON( JSTRING, WhatFredSaid )
Print "PRETTY: "+J.prettify()
Print "STRING: "+J.toString()

Print "~n--TEST2--------"
J = New JSON( JSTRING, WhatFredSaid )
Print "PRETTY: "+J.prettify()
Print "STRING: "+J.toString()

Print "~n--TEST3--------"
J = New JSON()
J.set( "conversation|fred", WhatFredSaid )
Print "PRETTY: "+J.prettify()
Result = J.find("conversation|fred")
Print "STRING: "+result.toString()
 
Print "~n--TEST4--------"
J = New JSON.parse( "{~qONE~q:1,~qTWO\~q~q:2,~qTHREE~q:3,~qFOUR~q:4}" )
Print "PARSED: "+J.prettify()
Print J.error()
Text = J["TWO\~q"]
Print "STRING: "+Text





