SuperStrict

'	JSON MODULE FOR BLITZMAX
'	(c) Copyright Si Dunford, July 2021, All Rights Reserved
'	V2.0

Rem
bbdoc: bmx.json
about: 
End Rem
Module bmx.json

ModuleInfo "Copyright: Si Dunford, July 2021, All Rights Reserved"
ModuleInfo "Author:    Si Dunford"
ModuleInfo "Version:   2.0"
ModuleInfo "License:   MIT"

ModuleInfo "History: V1.0, 20 JUL 21"
ModuleInfo "History: Basic JSON Parser"
ModuleInfo "History: V1.1, 20 JUL 21"
ModuleInfo "History: Added Transpose into TypeStr using reflection"
ModuleInfo "History: Added find() and set()"
ModuleInfo "History: V1.2, 20 JUL 21"
ModuleInfo "History: TMoved parser into JSON_Parser"
ModuleInfo "History: Merged JSON and JNode"
ModuleInfo "History: JNode is now depreciated, but not yet removed"
ModuleInfo "History: V1.3, 20 JUL 21"
ModuleInfo "History: Added error()"
ModuleInfo "History: V1.4, 24 AUG 21"
ModuleInfo "History: Re-Written to use bmx.lexer"
ModuleInfo "History: Converted into module bmx.json"
ModuleInfo "History: V1.5, 26 AUG 21"
ModuleInfo "History: Fixed issue with escaped characters including Hexcodes."
ModuleInfo "History: V1.6, 31 AUG 21"
ModuleInfo "History: Added contains() method plus example"
ModuleInfo "History: V1.7, 01 SEP 21"
ModuleInfo "History: Added PrettyPrint() plus example"

ModuleInfo "History: V1.8, 03 SEP 21"
ModuleInfo "History: Changed Array datatype from JSON[] To TObjectList"
ModuleInfo "History: toInt() now processes 'True','False' And 'Null' properly"
ModuleInfo "History: class And value are now Private"
ModuleInfo "History: Added constants For the class identifiers"
ModuleInfo "History: Added getClassID() And getClassName() instead of using class directly"
ModuleInfo "History: PrettyPrint() renamed To Prettify()"
ModuleInfo "History: Added isTrue(), isFalse(), isNull() For dealing with boolean/Null"
ModuleInfo "History: Added size(), addFirst(), addLast(), RemoveFirst(), RemoveLast() For dealing with Arrays"
ModuleInfo "History: Added examples 'json-boolean.bmx' And 'json-array.bmx'"
ModuleInfo "History: V1.8.1, 04 SEP 21"
ModuleInfo "History: Fixed bug in JSON_ constants"
ModuleInfo "History: V1.9, 06 SEP 21"
ModuleInfo "History: Fixed bug when parsing multiline (Pretty) JSON"
ModuleInfo "History: V1.10, 22 OCT 21"
ModuleInfo "History: Added support to find() to optionally return Null (default) or Empty JSON."
ModuleInfo "History: V1.11, 24 OCT 21"
ModuleInfo "History: Fixed bug in .toArray()"

ModuleInfo "History: V2.0, 29 OCT 21"
ModuleInfo "History: Major refactoring to support TLexer V2.0"
ModuleInfo "History: Fixed issue parsing whitespace strings"
ModuleInfo "History: Fixed line numbers in errors"
ModuleInfo "History: Fixed bug where EOL was reported as unexpected before a comma"

Import brl.objectlist

Import bmx.lexer
Import bmx.parser

Include "src/JSON.bmx"
Include "src/TJSONLexer.bmx"
Include "src/TJSONParser.bmx"


