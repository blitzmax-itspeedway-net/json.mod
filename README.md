# Module bmx.json

BlitzMax JSON by Scaremonger.

**VERSION:** 3.0

# DEPENDENCIES
* [BlitzMax-NG](https://blitzmax.org/downloads/)
* [bmx.lexer](https://github.com/blitzmax-itspeedway-net/lexer.mod)
* [bmx.parser](https://github.com/blitzmax-itspeedway-net/parser.mod)

# MANUAL INSTALL USING GIT
**LINUX:**
```
    # mkdir -p ~/BlitzMax/mod/bmx.mod
    # cd ~/BlitzMax/mod/bmx.mod
    # git clone https://github.com/blitzmax-itspeedway-net/json.mod.git
    # cd json.mod
    # chmod +x compile.sh
    # ./compile.sh
```
**WINDOWS:**
```
    C:\> mkdir C:\BlitzMax\mod\bmx.mod
    C:\> cd /d C:\BlitzMax\mod\bmx.mod
    C:\> git clone https://github.com/blitzmax-itspeedway-net/json.mod.git
    C:\> cd json.mod
    C:\> compile.bat
```

# MANUAL INSTALL USING ZIP
* Create a folder in your BlitzMax/mod folder called "bmx.mod"
* Download ZIP file from GitHub and unzip it: You will have a folder called json.mod.
* Copy folder json.mod-main/json.mod to BlitzMax/mod/bmx.mod/
* Run the compile.sh or compile.bat file located in the json.mod folder to compile

# UPDATE USING GIT
**LINUX:**
```
    # cd ~/BlitzMax/mod/bmx.mod/json.mod
    # git pull
    # chmod +x compile.sh
    # ./compile.sh
```
**WINDOWS:**
```
    C:\> cd /d C:\BlitzMax\mod\bmx.mod\json.mod
    C:\> git pull
    C:\> compile.bat
```

# HOW TO USE IT

Internally all JSON variables are stored as JSON types that represent the following types to store Blitzmax variables:

JSON      | INTERNAL    | VALUES | NOTES
--------- | ----------- | ------ | ------
JINVALID  | TString     ||
JARRAY    | TObjectList ||
JNUMBER   | String      ||
JOBJECT   | TMap        ||
JSTRING   | String      ||
JKEYWORD  | String      | "false", "true", "null" |
JBOOLEAN  | String      | "false", "true          | Stored as JKEYWORD
JNULL     | String      | "null"                  | Stored as JKEYWORD

**String to JSON - JSON to String**
```
Import bmx.json
Local JText:String = "{ ~qpeople~q:[~qjack~q,~qjill~q]}"
Local J:JSON = JSON.Parse( JText )
Local Text:string = J.Stringify()
Print( Text )
```
**JSON to String - JSON to Pretty String**
```
Import bmx.json
Local JText:String = "{ ~qpeople~q:[~qjack~q,~qjill~q]}"
Local J:JSON = JSON.Parse( JText )
Local Text:String = J.Prettify()
Print( Text )
```
**JSON Resource Paths**
```
Import bmx.json

Local JText:String = "{~qstory~q:{~qJack and Jill~q:{~qcharacters~q:[~qjack~q,~qjill~q]}}}"
Local J:JSON = JSON.Parse( JText )

Local characters:JSON = J.find("story|Jack and Jill|characters")
Print( characters.Prettify() )
```
**Manual JSON Creation**
```
Import bmx.json

Local J:JSON = New JSON()
J["id"] = "31"
J["name"] = "Scaremonger"
J["age"] = 99
J["addresses|home"] = "si@example.com"
J["addresses|work"] = "scaremonger@example.com"

Print( J.prettify() )
```

**BMX Type Serialisation**
```
Import bmx.json

Type TPerson
    Field name: String
    Field age: Int 

    Method New( name:string, age:int )
        self.name = name
        self.age = age
    End Method

End Type

Local person:TPerson = new TPerson( "Scaremonger", 99 )
Local J:JSON = JSON.serialize( person )
Print( J.Prettify() )
```

Type fields can have the following metadata attached to direct the serialisation process:
    {serializedname="NAME"}
    Uses the given NAME field instead of the actula filed. This is useful if your JSON data contains keywords like "field" or "method".

    {noserialize}
    This prevents the fields from being serialised, effectivly ignoring it.


**BMX Type De-Serialisation**
```
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
```

# JSON Specification:
https://www.json.org/json-en.html

# Function index:

FUNCTION  | DESCRIPTION 
------- | ---------
.parse:JSON( JText:string ) | Converts JSON Text string into JSON Object
.serialise:JSON( obj:Obj )  | Convert Blitzmax Object to JSON
.transpose:Object( typestr:string ) | Convert JSON into given BlitzMax object. 
.version:string()           | Get the current version
.versioncheck:int( minver:float, minbuild:int ) | Check for JSON library minimum version 

# Method index:

METHOD  | DESCRIPTION 
------- | ---------
.error() | Returns formatted error message
.getlasterror()		| Returns the last error message
.getClassID:Int()      | Returns class identifier as an integer 
.getClassName:String() | Returns class identifier as a string
.copy:JSON()           | Returns a copy of the object
.toArray:JSON[]()      | Returns an array of JSON objects
.toByte:Byte()         | Return JSON value as a Byte
.toDouble:Double()     | Return JSON value as a Double
.toFloat:Float()       | Return JSON value as a Float
.toInt:int()           | Return JSON value as a Int
.toLong:Long()         | Return JSON value as a Long
.toShort:Short()       | Return JSON value as a Short
.toSize_T:Size_T()     | Return JSON value as a Size_T
.toString:string()     | Return JSON value as a String
.toUInt:Uint()         | Return JSON value as a UInt
.toULong:ULong()       | Return JSON value as a ULong
.isValid:int()         | Checks if the object class is NOT JINVALID
.isInvalid:Int()       | Checks if the object class is JINVALID
.isTrue:int()          | Checks if the object class is JKEYWORD and the value is "true"
.isFalse:int()         | Checks if the object class is JKEYWORD and the value is "false"
.isNull:int()          | Checks if the object class is JKEYWORD and the value is "null"
.is:int( criteria:int ) | Checks the object class matches criteria (See class identifiers)
.stringify:string()                | Converts JSON object into string representation
.prettifyify:string()              | Converts JSON object into pretty string using 2 spaces
.prettifyify:string( tabsize:int ) | Converts JSON object into pretty string using given number of spaces
.prettifyify:string( tab:String )  | Converts JSON object into pretty string using given string
.find:JSON()           |
.set()                 |
.exists:Int()          | Returns True if the JOBJECT contains the given path
.contains:Int( key:string ) | Returns True if the JOBJECT contains the given key
.search:JSON()         |
.size:int()            | Size of a JARRAY or number of keys in a JOBJECT 
.addFirst( data:JSON ) | Adds a JSON element to top of a JARRAY
.addLast( data:JSON )  | Adds a JSON element to end of a JARRAY
.removeFirst:JSON()    | Removes a JSON element from top of a JARRAY
.removeLast:JSON()     | Removes a JSON element from end of a JARRAY

# Operator Overloads
OVERLOAD  | DESCRIPTION 
------- | ---------
[]:String( key:string )           | Equivalent of .find:String( key:String )
[]:JSON( key:int )                | Equivalent of .find:JSON( key:int )
[]=( route:String, value:String ) | Equivalent of .set( route:string, value:string )
[]=( route:String, value:Int )    | Equivalent of .set( route:string, value:Int )
[]=( route:String, value:Float )  | Equivalent of .set( route:string, value:Float )
[]=( route:String, value:JSON )   | Equivalent of .set( route:string, value:JSON )

# Class 

# CHANGE LOG

VERSION | DATE | DETAIL
------- | ---- | ------
V1.0 | 20 JUL 21 | Basic JSON Parser 
V1.1 | 20 JUL 21 | Added Transpose into TypeStr using reflection, added find() and set()
V1.2 | 20 JUL 21 | Moved parser into JSON_Parser. Merged JSON and JNode
V1.3 | 20 JUL 21 | Added error()
V1.4 | 24 AUG 21 | Re-Written to use bmx.lexer and converted to a Module
V1.5 | 26 AUG 21 | Fixed issue with escaped characters including Hexcodes.
V1.6 | 31 AUG 21 | Added contains() method plus example
V1.7 | 01 SEP 21 | Added PrettyPrint() plus example
V1.8 | 03 SEP 21 | Changed Array datatype from JSON[] to TObjectList<br>toInt() now processes "true","false" and "null", properly<br>class and value are now private<br>Added constants for the class identifiers<br>Added getClassID() and getClassName() instead of using class directly<br>PrettyPrint() renamed to Prettify()<br>Added isTrue(), isFalse(), isNull() for dealing with boolean/null<br>Added size(), addFirst(), addLast(), RemoveFirst(), RemoveLast() for dealing with Arrays<br>Added examples json-boolean.bmx and json-array.bmx
V1.8.1 | 04 SEP 21 | Fixed bug in JSON_ constants
V1.9 | 06 SEP 21 | Fixed bug when parsing multiline (Pretty) JSON
V1.10 | 22 OCT 21 | Find returns empty JSON instead of NULL when not found.
V1.11 | 24 OCT 21 | Fixed bug in .toArray()
V2.0 | 29 OCT 21 | Major refactoring to support TLexer V2.0<br>Fixed issue parsing whitespace strings<br>Fixed line numbers in errors<br>Fixed bug where EOL was reported as unexpected before a comma
V2.1 | 09 NOV 21 | Fixed Escaping issue with strings containing quotes
V2.2 | 06 DEC 21 | Updated size() to support objects<br> Added search() and is()
V2.3 | 12 DEC 22 | Added Function serialize()<br>Fixed 'Floating point number as string' issue
V2.4 | 13 DEC 22 | Added toByte(), toDouble(), toFloat(), toLong(), toShort(), toSize_T(), toUInt() and toULong()<br>Added copy()<br>Updated Transpose()<br>Fixed serialise bug when serialising Type JSON.
V2.5 | 14 DEC 22 | Added Operator overloading to allow easy creation of JSON
V3.0 | 02 FEB 23 | Internal classes are now INT instead of STRING
||Fixed toUInt(), toULong(), .count(). Added getLastError()
V3.1 | 11 FEB 23 | Fixed issue when parse string is a JSON array

