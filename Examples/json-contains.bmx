SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, August 2021

' This example parses a JSON string and tests the "contains" method

Import bmx.json

'DebugStop
Local JText:String = "{~qnumbers~q:[1,2,3,4],~qstrings~q:[~qOne~q,~qTwo~q,~qThree~q]}"

'DebugStop
Local J:JSON = JSON.Parse( JText )

Print J.Stringify()
If J.contains( "numbers" ) Print "CONTAINS NUMBERS"
If J.contains( "name" ) Print "CONTAINS NAME"

Local x:JSON = J.find( "numbers" )
Print x.Stringify()
