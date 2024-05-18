SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

'	This example removes a route

'Import bmx.json
Import brl.objectlist

Import "../lexer/lexer.bmx"
Import "../parser/parser.bmx"

'   INCREMENT JSON_VERSION
?Debug
'IGNORE ' @bmk include src/version.bmk
'IGNORE ' @bmk incrementVersion src/version.bmx
?
Include "../src/version.bmx"

Include "../src/JSON.bmx"
Include "../src/TJSONLexer.bmx"
Include "../src/TJSONParser.bmx"



Local example:String = """
{
	"users": {
		"john":{  "office":"North", "job":"Analyst" },
		"james":{ "office":"South", "job":"Programmer" }
	},
	"offices": {
		"North":{ "location":"Scotland" },
		"South":{ "location":"England" },
		"West":{  "location":"Wales" }
	}
}
""" 

Local J:JSON = JSON.parse( example )
If Not J
	Print "JSON is null"
	End
End If
If J.isInvalid()
	Print "ERROR:"
	Print J.error()
	End
End If

Print "BEFORE:"
Print J.prettify()

Print "~nREMOVED USERS|JOHN:"
J.unset( "users|john" )
Print J.prettify()

Print "~nREMOVED OFFICES|WEST:"
J.unset( "offices|West" )
Print J.prettify()

Print "~nREMOVE FROM ROOT"
J.unset( "offices" )
Print J.prettify()


