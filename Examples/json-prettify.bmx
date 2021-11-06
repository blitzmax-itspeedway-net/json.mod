SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

' This example parses a JSON string, appends to it and then pretty prints it.

Import bmx.json

Local JText:String = "{~qNumbers~q:[1,2,3,4],~qStrings~q:[~qOne~q,~qTwo~q,~qThree~q]}"
Local J:JSON = JSON.Parse( JText )

J.set( "id", 77 )
'DebugStop
J.set( "jsonrpc", "2.0" )
J.set( "result", "null" )

J.set( "example|one", "1.1" )
J.set( "example|two", "2.2" )

Print "~nUNFORMATTED"
Print J.Stringify()

Print "~nFORMATTED WITH DEFAULT TWO SPACES:"
Print J.Prettify()

Print "~nFORMATTED WITH TAB:"
Print J.Prettify( "~t" )

Print "~nFORMATTED WITH ONE SPACE"
Print J.Prettify( " " )

Print "~nFORMATTED WITH THREE SPACES"
Print J.Prettify( 3 )
