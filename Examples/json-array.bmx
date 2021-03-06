SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

Import bmx.json

'Import bmx.lexer
'Import bmx.parser
'Import brl.objectlist

'Include "../json.mod/src/JSON.bmx"
'Include "../json.mod/src/TJSONLexer.bmx"
'Include "../json.mod/src/TJSONParser.bmx"

' Create JSON from string
Local JText:String = "{'test':true,'example':['one','two','three'],'items':[{'section':'test'},{'section':'bls'},{'section':'lsp'},{'section':'blitzmax'}]}"
JText = JText.Replace( "'", Chr(34) )
Local J:JSON = JSON.Parse( JText )

Local response:JSON = New JSON()
response.set( "jsonrpc", "2.0")
response.set( "params", J )

'response.set( "example", [] )

Print "~nLOOP THROUGH ARRAY ITEMS:"
'DebugStop

Local items:JSON = response.find( "params|items" )
Print "  CLASS: "+items.getClassName()
Print "  SIZE:  "+items.size()

For Local a:Int = 0 Until items.size()
	Local JA:JSON = items[a]
	Print "  items["+a+"] == "+JA.stringify()
Next

Print "~nLOOP THROUGH ARRAY WITH FOREACH"

'DebugStop
Local itemarray:JSON[] = items.toArray()
Print "  ARRAY SIZE:  "+itemarray.length

For Local item:JSON = EachIn itemarray
	Print item.stringify()
Next


Print "~nADD ARRAY ITEMS:"

'DebugStop
Local array:JSON = J.find( "test" )

Print "  BEFORE INSERT:"
Print "    CLASS: "+array.getClassName
Print "    VALUE: "+array.stringify()

'DebugStop
array.addLast( New JSON( JSON_BOOLEAN, False ) )
array.addFirst( New JSON( JSON_STRING, "XYZ" ) )

Print "  AFTER INSERT:"
Print "    CLASS: "+array.getClassName
Print "    SIZE:  "+array.size()

For Local a:Int = 0 Until array.size()
	Local JA:JSON = array[a]
	Print "    items["+a+"] == "+JA.stringify()
Next

array.removeFirst()

Print "~nPRETTY:"

Print response.prettify()

