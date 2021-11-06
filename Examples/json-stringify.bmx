SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

' This example parses a JSON string, appends to it and then turns it back into a string.

Import bmx.json

'DebugStop
Local JText:String = "{~qNumbers~q:[1,2,3,4],~qStrings~q:[~qOne~q,~qTwo~q,~qThree~q]}"

'DebugStop
Local J:JSON = JSON.Parse( JText )

J.set( "id", 77 )
'DebugStop
J.set( "jsonrpc", "2.0" )
J.set( "result", "null" )

'DebugStop
Print J.Stringify()

