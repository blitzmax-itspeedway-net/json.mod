SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

Import bmx.json

Global TRUEFALSE:String[] = ["FALSE","TRUE"]
Global YESNO:String[] = ["NO","YES"]

' Create JSON from string
Local JText:String = """
	["test1","test2","test3",{"Another":"time"},"test4"]
"""
Local J:JSON = JSON.Parse( JText )
Print J.Prettify()


Print "OK"