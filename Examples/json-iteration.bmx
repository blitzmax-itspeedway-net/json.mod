SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

Import bmx.json

Local JText:String
Local J:JSON

' Create JSON Array
Print "~nARRAY:"
	JText = """
	[
	"test1","test2","test3",{"Another":"time"},"test4"
	]
	"""
J = JSON.Parse( JText )
Print J.Prettify()

Print "~nARRAY MEMBERS:"
For Local member:JSON = EachIn J
	Print member.stringify()
Next

' Create JSON Object
Print "~nOBJECT:"
JText = """
	{
	"test1":"A","test2":"B","test3":{"Another":"time"},"test4":"C"
	}
	"""
J = JSON.Parse( JText )
Print J.Prettify()

Print "~nOBJECT MEMBERS:"
For Local member:String = EachIn J.keys() 'map.keys()
	Print member+": "+J.find(member).stringify()
Next

Print "OK"

