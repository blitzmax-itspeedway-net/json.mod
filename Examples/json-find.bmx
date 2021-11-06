SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

' Test the FIND() method

Import bmx.json

Local example:JSON = New JSON()
example.set( "id", 99 )
example.set( "test", "testing" )
example.set( "error|code", 42 )

Print example.prettify()

' Un-Safe Operation
Print "~n> Testing an unsafe operation"
Try
	Print "UNSAFE: "+example.find( "missing" ).tostring()
Catch exception:Object
	Print "## UNSAFE OPERATION CAUSED EXCEPTION"
	Print exception.tostring()
End Try

' Safe Operation
Print "~n> Testing a safe operation"
Print "MISSING: "+example.find( "missing", True ).tostring()
Print "## SAFE OPERATION WORKED OKAY"

Local test:JSON

' UNSAFE
Print "~n> Testing an unsafe assignment"
test = example.find( "missing" )
If test=Null 
	Print "UNSAFE - Test is NULL"
Else
	Print "UNSAFE - "+test.stringify()
End If

' SAFE
Print "~n> Testing a safe assignment"
test = example.find( "missing", True )
If test=Null 
	Print "SAFE - Test is NULL"
Else
	Print "SAFE - Test is empty JSON - "+test.stringify()
End If




