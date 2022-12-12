SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, Dec 2022

Import bmx.json

Type TPerson
    Field name: String
    Field age: Int 
End Type

Local JText:String = "{~qname~q:~qScaremonger~q,~qage~q:99}"
Local J:JSON = JSON.Parse( JText )

Local person:TPerson = TPerson( J.Transpose( "TPerson" ) )
If Person
    Print( "NAME: "+Person.name )
    Print( "AGE:  "+Person.age )
End If