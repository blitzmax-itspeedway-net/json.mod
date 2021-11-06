SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

Import bmx.json

Rem
Import bmx.lexer
Import bmx.parser

Include "../json.mod/src/JSON.bmx"
Include "../json.mod/src/TJSONLexer.bmx"
Include "../json.mod/src/TJSONParser.bmx"
End Rem

Global TRUEFALSE:String[] = ["FALSE","TRUE"]
Global YESNO:String[] = ["NO","YES"]

' Create JSON from string
Local JText:String = "{'workspace':{'test1':true,'test2':false,'test3':null},'Another':'time'}"
JText = JText.Replace( "'", Chr(34) )
Local J:JSON = JSON.Parse( JText )
Print J.Stringify()

'DebugStop

' Test the values
For Local x:Int = 1 To 3

	Local JBool:JSON = J.find( "workspace|test"+x )
	Print "~nTESTING - "+ JBool.Stringify()

	Local bool:Int = JBool.toint()
	Print "  BOOL is "+TRUEFALSE[bool]

	Print "  True:   "+YESNO[JBool.isTrue()]
	Print "  False:  "+YESNO[JBool.isFalse()]
	Print "  Null:   "+YESNO[JBool.isNull()]
Next

Print "OK"