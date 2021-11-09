# Module bmx.json

BlitzMax JSON by Scaremonger.

**VERSION:** 2.1

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

# CHANGE LOG

VERSION | DATE | DETAIL
------- | ---- | ------
V1.0 | 20 JUL 21 | Basic JSON Parser 
V1.1 | 20 JUL 21 | Added Transpose into TypeStr using reflection, added find() and set()
V1.2 | 20 JUL 21 | Moved parser into JSON_Parser. Merged JSON and JNode
V1.3 | 20 JUL 21 | dded error()
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

# HOW TO USE

Internally all JSON variables are stored as JSON types that represent the following types to store Blitzmax variables:

JSON | BLITZMAX | NOTES
---- | -------- | -----
array | TObjectList |
number | String |
object | TMap |
string | String |
keyword | String | "false", "true", "null" 

This makes it quite flexible and allows it to be constructed into one BlitzMax type instead of half a dozen.

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
# JSON Specification:
https://www.json.org/json-en.html

