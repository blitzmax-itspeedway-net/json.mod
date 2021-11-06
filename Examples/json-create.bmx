SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

' EASY JSON CREATION

Import bmx.json

Local response:JSON = New JSON()
'DebugStop
response.set( "id", 99 )

response.set( "test", "testing" )
response.set( "error|code", 42 )


Local J:JSON 
J = response.find( "id" )
Print J.stringify()
J = response.find( "test" )
Print J.stringify()
J = response.find( "error" )
Print J.stringify()
J = response.find( "error|code" )
Print J.stringify()
J = response.find( "error|text",True )
Print J.stringify()

response.set( "error|text", "~qLife the universe and everything~q" )
Print response.stringify()


response.set( "result|capabilities", [["hoverProvider","true"]] )

response.set( "capabilities", [["hover","true"]] )


''result.set( "capabilities", [["hover","true"]] )
'result.set( "serverinfo|name", "~qBlitzmax Language Server~q" )

Print( "-------------_" )

Print response.stringify()

Print( "-------------_" )
'DebugStop
Local str:String = ""
str   = "{~qjsonrpc~q:~q2.0~q,~qid~q:0,~qmethod~q:~qinitialize~q,"
str  :+ "~qclientInfo~q:{~qname~q:~qVisual Studio~q,~qversion~q:~q123ABC~q},"
str  :+ "~qlocale~q:~qen-gb~q}"


Local JS:JSON = JSON.parse( str )
Print JS.stringify()

J = JS.find( "method" )

Print J.stringify()


Local clientinfo:JSON = JS.find( "clientInfo" )
If clientinfo
	Print( "CLIENT INFO EXISTS" )
	Local clientname:String = clientinfo["name"]
	Local clientver:String = clientinfo["version"]
	
	Print clientname
	Print clientver
Else
	Print( "NO CLIENT INFO EXISTS" )
End If




