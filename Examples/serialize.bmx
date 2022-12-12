SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, Dec 2022

Import bmx.json

Type TPerson
    Field name: String
    Field age: Int 

    Method New( name:String, age:Int )
        Self.name = name
        Self.age = age
    End Method

End Type

Local person:TPerson = New TPerson( "Scaremonger", 99 )
Local J:JSON = JSON.serialize( person )
Print( J.Prettify() )