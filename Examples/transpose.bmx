SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, Dec 2022

Import bmx.json

Type TPerson
    Field name: String
    Field age: Int 
	Field occupation: String {serializedname="job"}
End Type

Local JText:String = """
	{
	"name":"Scaremonger",
	"age":99,
	"job":"Engineer"
	}
"""
Local J:JSON = JSON.Parse( JText )

Local person:TPerson = TPerson( J.Transpose( "TPerson" ) )
If Person
    Print( "NAME: "+Person.name )
    Print( "AGE:  "+Person.age )
	Print( "JOB:  "+Person.occupation )
End If