
'	JSON MODULE FOR BLITZMAX
'	(c) Copyright Si Dunford, July 2021, All Rights Reserved
'	V1.8

Const JSON_INVALID:Int 	= 0
Const JSON_ARRAY:Int 	= 1
Const JSON_BOOLEAN:Int 	= 2
Const JSON_KEYWORD:Int 	= 3
Const JSON_NUMBER:Int 	= 4
Const JSON_NULL:Int 	= 5
Const JSON_OBJECT:Int 	= 6
Const JSON_STRING:Int 	= 7

Type JSON
	Private

    Field class:String
	Field value:Object

	Public
	
    ' Error Text, Line and Character
    Field errLine:Int = 0
    Field errPos:Int = 0
	Field errNum:Int = 0
    Field errText:String = ""

    Method New()
		Self.class = "object"
		Self.value = New TMap()
	End Method
		
    Method New( jtype:Int, value:String="" )
		Select jtype			
		Case JSON_ARRAY
			Self.class = "array"
			Self.value = New TObjectList()
			' Value Argument Ignored
		Case JSON_BOOLEAN
			Self.class = "keyword"
			value = Lower(value)
			Select value
			Case "true", "false"	; Self.value = value
			Case "1"				; Self.value = "true"
			Default					; Self.value = "false"
			End Select
		Case JSON_INVALID
			Self.class = "invalid"
			Self.value = ""
		Case JSON_KEYWORD
			Self.class = "keyword"
			Self.value = value
		Case JSON_NUMBER
			Self.class = "number"
			Self.value = String(Int(value))
		Case JSON_NULL
			Self.class = "keyword"
			Self.value = "null"
		Case JSON_STRING
			Self.class = "string"
			Self.value = value
		Default
			Self.class = "object"
			Self.value = New TMap()
			' Value Argument Ignored
		End Select
    End Method

    Method New( class:String, value:Object )
        Self.class = class
        Self.value = value
    End Method

	Method error:String()
		Return errtext+" ["+errnum+"] at "+errline+":"+errpos
	End Method
	
	' Get integer representation of the class
	' NOTE: Internally these are strings, but that may change at some point
	Method getClassId:Int()
		Select class
		Case "array"	;	Return JSON_ARRAY
		Case "keyword"
			Select String(value)
			Case "true", "false"	;	Return JSON_BOOLEAN
			Case "null"				;	Return JSON_NULL
			End Select
			Return JSON_KEYWORD
		Case "number"	;	Return JSON_NUMBER
		Case "string"	;	Return JSON_STRING
		Case "object"	;	Return JSON_OBJECT
		End Select
		Return JSON_INVALID
	End Method

	' Get a string representation of the class
	' NOTE: Internally these are strings, but that may change at some point
	Method getClassName:String()
		Return class
	End Method
	
    Method toString:String()
		Return String(value)
	End Method

    Method toInt:Int()
		Select class
		Case "number","string"	;	Return Int(String(value))
		Case "keyword"
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method

    Method toArray:JSON[]()
		If class<>"array" Return [New JSON( "invalid", "Node is not an array" )]
		Return JSON[](TObjectList(value).toArray())
	End Method
	
    Method isValid:Int()
		Return ( class <> "invalid" )
	End Method

    Method isInvalid:Int()
		Return ( class = "invalid" )
	End Method

	Method isTrue:Int()
		Return (class = "keyword" And String(value) = "true")
	End Method

	Method isFalse:Int()
		Return (class = "keyword" And String(value) = "false")
	End Method

	Method isNull:Int()
		Return (class = "keyword" And String(value) = "null")
	End Method

	Method is:Int( criteria:String )
		Return ( class = Lower(criteria) )
	End Method	

	' Get value of a JSON object's child using string index
	Method operator []:String( key:String )
        If class = "object"
			Local map:TMap = TMap( value )
			If map
				'DebugStop
				'key = unescape(key)
				Local J:JSON = JSON( map.valueforkey(key) )
				If J Return String( J.value )
			End If
		End If
		Return ""
	End Method

	' Get value in a JSON array using integer index
	Method operator []:JSON( key:Int )
		If class <> "array" Return Null
		Local items:TObjectList = TObjectList( value )
		If key>items.count Or key<0 Return Null
		Return JSON( items.valueatIndex(key) )
		'If items
		'	Local J:JSON = items[key]
		'	If J Return J
		'End If
		Return Null
	End Method
	
	' Set value in a JSON array using integer index
'	Method operator []( key:Int, newvalue:JSON )
'		If class <> "array" Return
'		Local items:TObjectList = TObjectList( value )
'		If key>items.count Or key<0 Return
'		Local item:JSON = JSON( items.valueatIndex(key) )
'		item.set( newvalue )
'	End Method

	' Produce a string representation of a JSON datatype
    Method Stringify:String()
		Local Text:String
		'If Not j Return "~q~q"
		Select class    ' JSON NODE TYPES
		Case "object"
			Local map:TMap = TMap( value )
			Text :+ "{"
			If map
				For Local key:String = EachIn map.keys()
                    Local j:JSON = JSON( map[key] )
					'Local K:String = key
					Text :+ "~q"+key+"~q:"+j.stringify()+","
				Next
				' Strip trailing comma
				If Text.endswith(",") Text = Text[..(Len(Text)-1)]

			End If
			Text :+ "}"
        Case "array"
			Text :+ "["
            'For Local J:JSON = EachIn JSON[](value)
            '    text :+ J.stringify()+","
            'Next
            For Local J:JSON = EachIn TObjectList(value)
                Text :+ J.stringify()+","
			Next
			' Strip trailing comma
			If Text.endswith(",") Text = Text[..(Len(Text)-1)]
			Text :+ "]"
		Case "number"
			Text :+ String(value)
		Case "string"
			Text :+ "~q"+escape(String(value))+"~q"
		Case "keyword"
			Text :+ escape(String(value))
		Case "invalid"
			Text :+ "#ERR#"
		Default
			Publish( "log", "DEBG", "INVALID SYMBOL: '"+class+"', ''" )
		End Select
		Return Text
	End Method

	Method Prettify:String( tabs:Int )
		Return Prettify( " "[..tabs] )
	End Method

	Method Prettify:String( tab:String="  " )
		Local Text:String = Stringify()
		Try
			For Local set:String[] = EachIn [["{","{~n"],["[","[~n"],["}","~n}"],["]","~n]"],["~q:","~q: "],[",",",~n"]]
				Text = Text.Replace( set[0], set[1] )		
			Next		
			Local tokens:String[] = Text.split( "~n" )
			Local indent:String
			For Local i:Int = 0 Until tokens.length
				Local token:String = tokens[i]
				If token.startswith("}") Or token.startswith("]") ; indent = indent[..(Len(indent)-Len(tab))]
				tokens[i] = indent+token
				If token.endswith("{") Or token.endswith("[") ; indent :+ tab
			Next
			Text = "~n".join( tokens )
		Catch e:TRegExException
			DebugLog "Error : " + e.toString()
		End Try
		Return Text
	End Method

    ' Transpose a JSON object into a Blitzmax Object using Reflection 
    Method transpose:Object( typestr:String )
        Publish( "log", "DEBG", "Transpose('"+typestr+"')" )
        ' We can only transpose an object into a Type
        If class<>"object" Return Null
        Local typeid:TTypeId = TTypeId.ForName( typestr )
        If Not typeid
            Publish( "log", "DEBG", "- '"+typestr+"' is not a Blitzmax Type" )
            Return Null
        End If
        Local invoke:Object = typeid.newObject()
        If Not invoke Return Null
    
        ' Add Field names and types to map
        Local fields:TMap = New TMap()
        For Local fld:TField = EachIn typeid.EnumFields()
            fields.insert( fld.name(), fld.typeid.name() )
        Next
    
        ' Extract MAP (of JSONs) from value
        Local map:TMap = TMap( value )
        If Not map Return Null
        'logfile.write( "Map extracted from value successfully" )
        'for local key:string = eachin map.keys()
        '    logfile.write "  "+key+" = "+ JSON(map[key]).toString()
        'next

        ' Transpose fields into object
        For Local fldname:String = EachIn fields.keys()
            Local fldtype:String = String(fields[fldname]).tolower()
            'debuglog( "Field: "+fldname+":"+fldtype )
            'logfile.write "- Field: "+fldname+":"+fldtype
            Local fld:TField = typeid.findField( fldname )
            If fld
                'logfile.write "-- Is not null"
                Try
                    Select fldtype	' BLITZMAX TYPES
                    Case "string"
                        Local J:JSON = JSON(map[fldname])
                        If J fld.SetString( invoke, J.tostring() )
                    Case "int"
                        Local J:JSON = JSON(map[fldname])
                        If J fld.setInt( invoke, J.toInt() )
                        'if J 
                        '    local fldvalue:int = J.toInt()
                        '    logfile.write fldname+":"+fldtype+"=="+fldvalue
                        '    fld.setInt( invoke, fldvalue )
                        '    logfile.write "INT FIELD SET"
                        'end if
                    Case "json"
                        ' This is a direct copy of JSON
                        Local J:JSON = JSON(map[fldname])
                        fld.set( invoke, J )
                    Default
                        Publish( "log", "ERRR", "Blitzmax type '"+fldtype+"' cannot be transposed()" )
                    End Select
                Catch Exception:String
                    Publish( "log", "CRIT", "Transpose exception" )
                    Publish( "log", "CRIT", Exception )
                End Try
            'else
                'logfile.write "-- Is null"
            End If
        Next
        Return invoke
    End Method

'		##### JSON HELPER

    ' Set the value of a JSON
    Method set( value:String )
		If value.startswith("~q") And value.endswith("~q")
			' STRING
			Self.class = "string"
			Self.value = dequote(value)
		Else
			If value = "true" Or value = "false" Or value = "null"
				' KEYWORD (true/false/null)
				Self.class = "keyword"
				Self.value = value
			Else
				' Treat it as a string
				Self.class = "string"
				Self.value = value
			End If
		End If
    End Method

    Method set( value:Int )
        ' If existing value is NOT a number, overwrite it
		Self.class="number"
		Self.value = String(value)
    End Method

    Method Set( route:String, value:String )
		'_set( route, value, "string" )
		Local J:JSON = find( route, True )	' Find route and create if missing
		If J ; J.set( value )
    End Method

    Method Set( route:String, value:Int )
		'_set( route, value, "number" )
		Local J:JSON = find( route, True )	' Find route and create if missing
		If J ; J.set( value )
    End Method

    Method Set( route:String, values:String[][] )
		Local J:JSON = find( route, True )	' Find route and create if missing
		For Local value:String[] = EachIn values
			'_set( route+"|"+value[0], value[1], "string" )
			If value.length=2
				Local node:JSON = J.find( value[0], True )
				node.set( value[1] )
			End If
		Next
    End Method

	' V0.2
	' Set a route to an existing JSON
    Method Set( route:String, node:JSON )
		Local J:JSON = find( route, True )	' Find route and create if missing
		J.class = node.class
		J.value = node.value
    End Method
	
	' V0.1
	Method find:JSON( route:String, createme:Int = False )
        ' Ignore empty route
        route = Trim(route)
        If route="" Return New JSON()
		' Split up the path
        Return find( route.split("|"), createme )
	End Method
	
	Method find:JSON( path:String[], createme:Int = False )
	'DebugStop
		If path.length=0		' Found!
			Return Self
		Else
			' If child is specified then I MUST be an object right?
			Local child:JSON, map:TMap
			If class="object" ' Yay, I am an object.
				If value=Null
					value = New TMap()
				End If
				map = TMap( value )
			Else 
				If Not createme Return New JSON() ' Not found
				' I must now evolve into an object, destroying my previous identity!
				map = New TMap()
				class = "object"
				value = map
			End If
			' Does child exist?
			child = JSON( map.valueforkey( path[0] ) )
			If Not child 
				If Not createme Return New JSON() ' Not found
				' Add a new child
				child = New JSON( "string", "" )
				map.insert( path[0], child )
			End If
			Return child.find( path[1..], createme )
		End If
	End Method

	' V0.2
	Method exists:Int( route:String )
        ' Ignore empty route
        route = Trim(route)
        If route="" Return False
		' Split up the path
        Return Not( search( route.split("|") ) = Null )
	End Method

	Method search:JSON( route:String )
        ' Ignore empty route
        route = Trim(route)
        If route="" Return Null
		' Split up the path
        Return search( route.split("|") )
	End Method
	
	' Search is like FIND but returns NUL if not found
	Method search:JSON( path:String[] )
	'DebugStop
		If path.length=0		' Found!
			Return Self
		Else
			' If child is specified then I MUST be an object right?
			Local child:JSON, map:TMap
			If class="object" ' Yay, I am an object.
				If value=Null
					value = New TMap()
				End If
				map = TMap( value )
			Else 
				Return Null ' Not found
			End If
			' Does child exist?
			child = JSON( map.valueforkey( path[0] ) )
			If Not child Return Null ' Not found
			Return child.find( path[1..] )
		End If
	End Method

    Method contains:Int( name:String )		
		' Only an Object contains named children
		If class<>"object" ; Return False
		
		' Check I am not empty!
		If Not value ; Return False

		' Check if I contain the given field
		Local map:TMap = TMap( value )
		Return map.contains(name)
    End Method

	' Get SIZE of an ARRAY
	Method size:Int()
		Select class
		Case "array"
			Return TObjectList(value).count()
		Case "class"
			Local map:TMap = TMap( value )
			If Not map Return 0
			Local count:Int = 0
			For Local key:String = EachIn map.keys()
				count :+1
			Next
			Return count
		End Select 
		Return 0
	End Method
	
	' Insert a record at the beginning of an array
	Method addFirst( data:JSON )
'DebugStop
		' If class is not an array, upgrade it using existing element as first
		Local list:TObjectList = _UpgradeToArray()
		' Add value
		If list ; list.addFirst( data )			
	End Method

	' Append a record to an ARRAY
	Method addLast( data:JSON )
		' If class is not an array, upgrade it using existing element as first
		Local list:TObjectList = _UpgradeToArray()
		' Add value
		If list ; list.addlast( data )		
	End Method
	
	' Removes a record from the beginning of an array
	Method RemoveFirst:JSON()
		If class = "array"
			Local list:TObjectList = TObjectList(value)
			If list ; Return JSON(list.RemoveFirst())
		End If
		Return Null
	End Method

	' Remove the last record of an ARRAY
	Method RemoveLast:JSON()
		If class = "array"
			Local list:TObjectList = TObjectList(value)
			If list ; Return JSON(list.RemoveLast())
		End If
		Return Null
	End Method

	Method _UpgradeToArray:TObjectList()
		Select class
		Case "number", "string", "keyword", "object"
			' Copy self into another node
			Local node:JSON = New JSON( class, value )
			' Create an Array-backed list and insert copy
			Local list:TObjectList = New TObjectList()
			list.addlast( node )
			' Upgrade self to an array
			class = "array"
			value = list
			Return list
		Case "array"
			' Do nothing
			Return TObjectList(value)
		End Select
		' We dont support other types
		Return Null		
	End Method

'	Method Copy:JSON()
'	End Method
	
'	Method merge:JSON( with:JSON )
'	End Method

	' Event handler
	Method publish( message:String, state:String, alt:String )
		DebugLog( message + ", " + state + ", "+ alt )
	End Method

	' Escape a string
	Method escape:String( Text:String )
		Local escaped:String = Text
		escaped = escaped.Replace( "\", "\\" )			' Reverse Solidus
		escaped = escaped.Replace( "~q", "\~q" )		' Quotation mark
		'escaped = escaped.Replace( "/", "\/" )			' Solidus
		escaped = escaped.Replace( Chr(8), "\b" )		' Backspace			ASC(08)
		escaped = escaped.Replace( Chr(12), "\f" )		' Form Feed			ASC(12)
		escaped = escaped.Replace( "~n", "\n" )			' Line Feed			ASC(10)
		escaped = escaped.Replace( "~r", "\r" )			' Carriage Return	ASC(13)
		escaped = escaped.Replace( "~t", "\t" )			' Horizontal Tab	ASC(09)
		Return escaped
	End Method
	
	' De-Escape a string
	Method unescape:String( escaped:String )
		Local Text:String = escaped
		'Text = Text.Replace( "\/", "/" )			' Solidus
		Text = Text.Replace( "\\", "\" )			' Reverse Solidus
		Text = Text.Replace( "\~q", "~q" )			' Quotation mark
		Text = Text.Replace( "\b", Chr(8) )			' Backspace			ASC(08)
		Text = Text.Replace( "\f", Chr(12) )		' Form Feed			ASC(12)
		Text = Text.Replace( "\n", "~n" )			' Line Feed			ASC(10)
		Text = Text.Replace( "\r", "~r" )			' Carriage Return	ASC(13)
		Text = Text.Replace( "\t", "~t" )			' Horizontal Tab	ASC(09)
		Return Text
	End Method

    ' Convert text into a JSON object
    Function Parse:JSON( Text:String )
        ' For convenience, and empty string is the same as {}
		If Text.Trim()="" Text = "{}"
		'
'DebugStop
		Local lexer:TLexer       = New TJSONLexer( Text )
		' A Bit of debugging
		'lexer.run()
		'Print lexer.reveal()
'DebugStop
		Local parser:TJSONParser = New TJSONParser( lexer )
        Return parser.parse_json()
    End Function

	Function version:String()
		Return JSON_VERSION+"."+JSON_BUILD
	End Function
	
	Function versioncheck:Int( minver:Float, minbuild:Int )
		If Float( JSON_VERSION ) < minver Return False
		If Float( JSON_VERSION ) > minver Return True
		If Int( JSON_BUILD ) >= minbuild Return True
		Return False
	End Function
	
End Type

' De-Quote a string
Function dequote:String( Text:String )
	If Text.startswith( "~q" ) Text = Text[1..]
	If Text.endswith( "~q" ) Text = Text[..(Len(Text)-1)]
	Return Text
End Function
