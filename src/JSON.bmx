
'	JSON MODULE FOR BLITZMAX
'	(c) Copyright Si Dunford, July 2021, All Rights Reserved
'	V3.0

' Version 3.0 constants
Const JINVALID:Int 	= 0
Const JARRAY:Int 	= 1
Const JBOOLEAN:Int 	= 2
Const JKEYWORD:Int 	= 3
Const JNUMBER:Int 	= 4
Const JNULL:Int 	= 5
Const JOBJECT:Int 	= 6
Const JSTRING:Int 	= 7

' Version 2.5 constants - Depreciated
'Const JSON_INVALID:Int 	= 0
'Const JSON_ARRAY:Int 	= 1
'Const JSON_BOOLEAN:Int 	= 2
'Const JSON_KEYWORD:Int 	= 3
'Const JSON_NUMBER:Int 	= 4
'Const JSON_NULL:Int 	= 5
'Const JSON_OBJECT:Int 	= 6
'Const JSON_STRING:Int 	= 7

Type JSON
	Private

    Field class:Int
	Field value:Object

	Public
	
    ' Error Text, Line and Character
    Field errLine:Int = 0
    Field errPos:Int = 0
	Field errNum:Int = 0
    Field errText:String = ""

    Method New()
		Self.class = JOBJECT
		Self.value = New TMap()
	End Method
		
    Method New( jtype:Int, value:String="" )
		Select jtype			
		Case JARRAY
			Self.class = JARRAY
			Self.value = New TObjectList()
			' Value Argument Ignored
		Case JBOOLEAN
			Self.class = JKEYWORD
			value = Lower(value)
			Select value
			Case "true", "false"	; Self.value = value
			Case "1"				; Self.value = "true"
			Default					; Self.value = "false"
			End Select
		Case JINVALID
			Self.class = JINVALID
			Self.value = ""
		Case JKEYWORD
			Self.class = JKEYWORD
			Self.value = value
		Case JNUMBER
			Self.class = JNUMBER
			Self.value = value	'String(Int(value))
		Case JNULL
			Self.class = JNULL
			Self.value = "null"
		Case JSTRING
			Self.class = JSTRING
			Self.value = value
		Default
			Self.class = JOBJECT
			Self.value = New TMap()
			' Value Argument Ignored
		End Select
    End Method

    Method New( jtype:Int, value:Object )
		Self.class = jtype
		Select jtype
		Case JARRAY
			Self.value = TObjectList(value)
			If Self.value; Return
		Case JOBJECT
			Self.value = TMap(value)
			If Self.value; Return
		End Select
		' Invalid...
		Self.class = JINVALID
		Self.value = ""
	End Method

	' Create a JARRAY from a string array
    Method New( value:String[] )
		For Local str:String = EachIn String[](value)
			addlast( New JSON( JSTRING, str ) )
		Next
    End Method

	' Request location of last error
	Method error:String()
		Return errtext+" ["+errnum+"] at "+errline+":"+errpos
	End Method
	
	Public
	
	' Get integer representation of the class
	' NOTE: Internally these are strings, but that may change at some point
	Method getClassId:Int()
		Select class
		Case JARRAY, JNUMBER, JSTRING, JOBJECT
			Return class
		Case JKEYWORD
			Select String(value)
			Case "true", "false"	;	Return JBOOLEAN
			Case "null"				;	Return JNULL
			End Select
			Return JKEYWORD
		End Select
		Return JINVALID
	End Method

	' Get a string representation of the class
	Method getClassName:String()
		Select class
		Case JARRAY		;	Return "array"
		Case JNUMBER	;	Return "number"
		Case JSTRING	;	Return "string"
		Case JOBJECT	;	Return "object"
		Case JKEYWORD
			Select String(value)
			Case "true", "false"	;	Return "boolean"
			Case "null"				;	Return "null"
			End Select
			Return JKEYWORD
		End Select
		Return JINVALID
	End Method
	
	' Copy / Duplicate a JSON type
	Method copy:JSON()
		'DebugStop
		Select class
		Case JARRAY
			Local J:JSON = New JSON()
			J.class = class
			J.value = New TObjectList()
			For Local item:JSON = EachIn TObjectList( value )
                'addlast( J.value, item.copy() )
				J.addlast( item.copy() )
			Next
			Return J
		Case JKEYWORD	;	Return New JSON( JKEYWORD, String( value ) )
		Case JNUMBER	;	Return New JSON( JNUMBER, String( value ) )
		Case JSTRING	;	Return New JSON( JSTRING, String( value ) )
		Case JOBJECT
			Local J:JSON = New JSON()
			J.class = class
			'J.value = New TMap()
			Local map:TMap = TMap( value )
			For Local key:String = EachIn map.keys()
				J.set( key, JSON(map[key]).copy() )
			Next
			Return J
		End Select
		Return New JSON( JINVALID )
	End Method

    Method toArray:JSON[]()
		If class<>JARRAY Return [New JSON( JINVALID, "Node is not an array" )]
		Return JSON[](TObjectList(value).toArray())
	End Method
	
	Method toByte:Byte()
		Select class
		Case JNUMBER,JSTRING	;	Return Long(String(value))
		Case JKEYWORD
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method
	
	Method toDouble:Double()
		Select class
		Case JNUMBER,JSTRING	;	Return Double(String(value))
		Case JKEYWORD
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method
	
	Method toFloat:Float()
		Select class
		Case JNUMBER,JSTRING	;	Return Float(String(value))
		Case JKEYWORD
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method

    Method toInt:Int()
		Select class
		Case JNUMBER,JSTRING	;	Return Int(String(value))
		Case JKEYWORD
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method
	
    Method toLong:Long()
		Select class
		Case JNUMBER,JSTRING	;	Return Long(String(value))
		Case JKEYWORD
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method
	
	Method toShort:Short()
		Select class
		Case JNUMBER,JSTRING	;	Return Short(String(value))
		Case JKEYWORD
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method
	
	Method toSizeT:Size_T()
		Return toSize_T()
	End Method

	Method toSize_T:Size_T()
		Select class
		Case JNUMBER,JSTRING	;	Return Size_T(String(value))
		Case JKEYWORD
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method
		
    Method toString:String()
		Return String(value)
	End Method

	Method toUInt:UInt()
		Select class
		Case JNUMBER,JSTRING	;	Return UInt(String(value))
		Case JKEYWORD
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method
	
	Method toULong:ULong()
		Select class
		Case JNUMBER,JSTRING	;	Return ULong(String(value))
		Case JKEYWORD
			Select String(value)
			Case "true"			;	Return True
			Case "false","null"	;	Return False
			End Select
		End Select
		Return 0
	End Method
	
    Method isValid:Int()
		Return ( class <> JINVALID )
	End Method

    Method isInvalid:Int()
		Return ( class = JINVALID )
	End Method

	Method isTrue:Int()
		Return (class = JKEYWORD And String(value) = "true")
	End Method

	Method isFalse:Int()
		Return (class = JKEYWORD And String(value) = "false")
	End Method

	Method isNull:Int()
		Return (class = JKEYWORD And String(value) = "null")
	End Method

	Method is:Int( criteria:Int )
		Return ( class = criteria )
	End Method	

	' Get value of a JSON object's child using string index
	Method operator []:String( key:String )
        If class = JOBJECT
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
		If class <> JARRAY Return Null
		Local items:TObjectList = TObjectList( value )
		If key>items.count Or key<0 Return Null
		Return JSON( items.valueatIndex(key) )
		'If items
		'	Local J:JSON = items[key]
		'	If J Return J
		'End If
		'Return Null
	End Method
	
	' Set Values
	Method operator []=( route:String, value:String )
		set( route, value )
	End Method
	Method operator []=( route:String, value:Int )
		set( route, value )
	End Method
	Method operator []=( route:String, value:Float )
		set( route, value )
	End Method
	Method operator []=( route:String, value:JSON )
		set( route, value )
	End Method
	' 14/12/22, Operator overload doesn;t seem to allow "Object" types as params
	'Method operator []=( route:String, value:Object )
	'	Local J:JSON = JSON.serialise( value )
	'	set( route, J )
	'End Method
	
	' Produce a stFring representation of a JSON datatype
    Method Stringify:String()
		Local txt:String
		'DebugStop
		'If Not j Return "~q~q"
		Select class    ' JSON NODE TYPES
		Case JOBJECT
			Local map:TMap = TMap( value )
			txt :+ "{"
			If map
				For Local key:String = EachIn map.keys()
                    Local j:JSON = JSON( map[key] )
					'Local K:String = key
					txt :+ "~q"+key+"~q:"+j.stringify()+","
				Next
				' Strip trailing comma
				If txt.endswith(",") txt = txt[..(Len(txt)-1)]

			End If
			txt :+ "}"
        Case JARRAY
			txt :+ "["
            'For Local J:JSON = EachIn JSON[](value)
            '    txt :+ J.stringify()+","
            'Next
            For Local J:JSON = EachIn TObjectList(value)
                txt :+ J.stringify()+","
			Next
			' Strip trailing comma
			If txt.endswith(",") txt = txt[..(Len(txt)-1)]
			txt :+ "]"
		Case JNUMBER
			txt :+ String(value)
		Case JSTRING
			txt :+ "~q"+escape(String(value))+"~q"
		Case JKEYWORD
			txt :+ escape(String(value))
		Case JINVALID
			txt :+ "#ERR#"
		Default
			fail( "INVALID SYMBOL: '"+class+"', ''" )
		End Select
		Return txt
	End Method

	Method Prettify:String( tabs:Int )
		Return Prettify( " "[..tabs] )
	End Method

	Method Prettify:String( tab:String="  " )
		Local txt:String = Stringify()
		Try
			For Local set:String[] = EachIn [["{","{~n"],["[","[~n"],["}","~n}"],["]","~n]"],["~q:","~q: "],[",",",~n"]]
				txt = txt.Replace( set[0], set[1] )		
			Next		
			Local tokens:String[] = txt.split( "~n" )
			Local indent:String
			For Local i:Int = 0 Until tokens.length
				Local token:String = tokens[i]
				If token.startswith("}") Or token.startswith("]") ; indent = indent[..(Len(indent)-Len(tab))]
				tokens[i] = indent+token
				If token.endswith("{") Or token.endswith("[") ; indent :+ tab
			Next
			txt = "~n".join( tokens )
		Catch e:TRegExException
			DebugLog "Error : " + e.toString()
		End Try
		Return txt
	End Method

	' Serialise a Blitzmax object into JSON
	Function serialise:JSON( obj:Object )	' British English
		Return _Object2JSON( obj )
	End Function
	Function serialize:JSON( obj:Object )	' American English
		Return _Object2JSON( obj )
	End Function
		
	Private

	Function _Array2JSON:JSON( array:Object, fieldtype:TTypeId )
		Local J:JSON = New JSON( JARRAY )
		Local length:Int, dimensions:Int
		Try
			length = fieldtype.arrayLength( array )
		Catch e:String
			length = 0
		End Try
		Try
			dimensions = fieldtype.arrayDimensions( array )
		Catch e:String
			dimensions = 0
		End Try
		If length = 0 Or dimensions = 0; Return J
		
		Local elementTypeid:TTypeId = fieldtype.ElementType()
		'DebugStop
		For Local e:Int = 0 Until length
			'Local element:JSON
			Local fieldname:String = elementTypeID.Name()
			'DebugStop
			Select ElementTypeId
			Case ByteTypeId;	J.addlast( New JSON( JNUMBER, fieldtype.GetByteArrayElement( array,e ) ))
			Case DoubleTypeId;	J.addlast( New JSON( JNUMBER, fieldtype.GetDoubleArrayElement( array,e ) ))
			Case FloatTypeId;	J.addlast( New JSON( JNUMBER, fieldtype.GetFloatArrayElement( array,e ) ))
			Case IntTypeId;		J.addlast( New JSON( JNUMBER, fieldtype.GetIntArrayElement( array,e ) ))
			Case LongTypeId;	J.addlast( New JSON( JNUMBER, fieldtype.GetLongArrayElement( array,e ) ))
			Case ShortTypeId;	J.addlast( New JSON( JNUMBER, fieldtype.GetShortArrayElement( array,e ) ))
			Case SizeTTypeId;	J.addlast( New JSON( JNUMBER, fieldtype.GetSizeTArrayElement( array,e ) ))
			Case StringTypeId
				Local str:String = fieldtype.GetStringArrayElement( array,e )
				If str; 		J.addlast( New JSON( JSTRING, str ) )
			Case UIntTypeId;	J.addlast( New JSON( JSTRING, fieldtype.GetUIntArrayElement( array,e ) ))
			Case ULongTypeId;	J.addlast( New JSON( JSTRING, fieldtype.GetULongArrayElement( array,e ) ))
			Default
				'DebugStop
				Select True
				Case elementTypeID.extendsType( ArrayTypeID )
					Local a:Object = elementTypeID.GetArrayElement( array,e )
					J.AddLast( _Array2JSON( a, elementTypeID ) )
				Case elementTypeID.extendsType( ObjectTypeId )
					Local o:Object = fieldtype.GetArrayElement( array,e )
					'Local o:Object = fld.get( obj )
					If o
						Local objectTypeId:TTypeId = TTypeId.ForObject(o)
						J.AddLast( _Object2JSON( o ) )
					End If
				Default
					DebugLog( "Unable to serialize "+fieldName+":"+fieldType.name() )
				End Select
			End Select
		Next
		Return J
	End Function

	Function _Object2JSON:JSON( obj:Object )
		Local typeid:TTypeId = TTypeId.ForObject( obj )
		Local J:JSON = New JSON()
		For Local fld:TField = EachIn typeid.EnumFields()
			
			'DebugStop
			If fld.metadata("noserialize") Or fld.metadata("noserialise"); Continue
			
			Local fieldType:TTypeId = fld.TypeID()
			Local fieldName:String = fld.name()			
			If fld.metadata("serializedname"); fieldname = fld.metadata("serializedname")
			If fld.metadata("serialisedname"); fieldname = fld.metadata("serialisedname")

'If fieldname.startswith("initialization"); DebugStop

			Select fieldType
			Case ByteTypeId;	J.set( fieldName, fld.GetByte(obj) )
			Case DoubleTypeId;	J.set( fieldName, fld.GetDouble(obj) )
			Case FloatTypeId;	J.set( fieldName, fld.GetFloat(obj) )
			Case IntTypeId;		J.set( fieldName, fld.GetInt(obj) )
			Case LongTypeId;	J.set( fieldName, fld.GetLong(obj) )
			Case ShortTypeId;	J.set( fieldName, fld.GetShort(obj) )
			Case SizeTTypeId;	J.set( fieldName, fld.GetSizeT(obj) )
			Case StringTypeId
				Local str:String = fld.GetString(obj)
				If str; 		J.set( fieldName, str )
			Case UIntTypeId;	J.set( fieldName, fld.GetUInt(obj) )
			Case ULongTypeId;	J.set( fieldName, fld.GetULong(obj) )
			Default
				'DebugStop
				Select True
				Case Lower(fieldtype.name())="json"
					'Local f:JSON = JSON( fld.get( obj ) )
					Local o:Object = fld.get( obj )
					If o; J.set( fieldname, JSON( o ).copy() )
				Case fieldtype.extendsType( ArrayTypeID )
					Local array:Object = fld.get( obj )
					J.set( fieldname, _Array2JSON( array, fieldtype ) )
				Case fieldtype.extendsType( ObjectTypeId )
					Local o:Object = fld.get( obj )
					If o
						Local objectTypeId:TTypeId = TTypeId.ForObject(o)
						J.set( fieldname, _Object2JSON( o ) )
					End If
				Default
					DebugLog( "Unable to serialize "+fieldName+":"+fieldType.name() )
				End Select
			End Select
			
			'DebugLog( fieldName )
			'fields.insert( fld.name(), fld.typeid.name() )
		Next
		Return J
	End Function
		
	Public
	
    ' Transpose a JSON object into a Blitzmax Object using Reflection 
    Method transpose:Object( typestr:String )
        'fail( "Transpose('"+typestr+"')" )
		If class=JOBJECT; Return _JSON2Object( typestr )
		Return fail( "Unable to transpose "+class )
	End Method

	Private

	Method _JSON2Array:Object( typestr:String )
		Local typeid:TTypeId = TTypeId.ForName( typestr )        
        If Not typeid; Return fail( "- '"+typestr+"' is not a Blitzmax Type" )

		' Get the list
		Local list:TObjectList = TObjectList(value)
		'DebugLog( list.count() + " elements" )
		'DebugStop
		
		' Create an object of this type
        Local array:Object = typeid.NewArray( list.count() )
        If Not array Return fail( "Unable to create array of type "+typestr )

		' Loop through array elements
		For Local index:Int = 0 Until list.count()
			Local J:JSON = JSON( list.valueAtIndex( index ) )

			typeid.setArrayElement( array, index, J._JSON2Object( typestr[..(Len(typestr)-2)] ) )
		Next	
		
		Return array
	End Method
	
	Method _JSON2Object:Object( typestr:String )
	
		' Get the typeid associated with the type string
		Local typeid:TTypeId = TTypeId.ForName( typestr )        
        If Not typeid; Return fail( "- '"+typestr+"' is not a Blitzmax Type" )

		' Create an object of this type
        Local obj:Object = typeid.newObject()
        If Not obj Return fail( "Unable to create object of type "+typestr )
   
		' Get object map
		Local map:TMap = TMap( value )
		'DebugStop
		
		' Debug the field list
		'For Local key:String = EachIn map.keys()
		'	Print( ": "+ key )
		'Next
		
		' Loop through object fields
        For Local fld:TField = EachIn typeid.EnumFields()
			' Check if field is marked for non-transpose
			If fld.metadata("notranspose"); Continue

			' Get field name using serialisedname if provided
			Local fieldName:String = Lower( fld.name() )
			If fld.metadata("serializedname"); fieldname = Lower( fld.metadata("serializedname") )
			If fld.metadata("serialisedname"); fieldname = Lower( fld.metadata("serialisedname") )
			
			'DebugLog( "->"+fieldname )
			
            'fields.insert( fld.name(), fld.typeid.name() )
			' Check if field exists in JSON
			Local J:JSON = JSON( map.valueforkey( fieldname ) )
			If Not J; Continue
			
'If fieldname = "workspacefolders"; DebugStop
			
			'DebugStop
			Select fld.TypeID()			
			Case ByteTypeId;	fld.setByte( obj, J.toByte() )
			Case DoubleTypeId;	fld.setDouble( obj, J.toDouble() )
			Case FloatTypeId;	fld.SetFloat( obj, J.toFloat() )
			Case IntTypeId;		fld.setInt( obj, J.toInt() )
			Case LongTypeId;	fld.setLong( obj, J.toLong() )
			Case ShortTypeId;	fld.setShort( obj, J.toShort() )
			Case SizeTTypeId;	fld.setSizeT( obj, J.toSize_T() )
			Case StringTypeId;	fld.SetString( obj, J.tostring() )
			Case UIntTypeId;	fld.setUInt( obj, J.toUInt() )
			Case ULongTypeId;	fld.setULong( obj, J.toULong() )
			Default
				Select True
				Case Lower( fld.typeid.name() ) = "json"
					fld.set( obj, J )
				Case fld.typeid.extendsType( ObjectTypeId )
					'DebugStop
					If fld.typeid.extendsType( ArrayTypeID )
						' Type[]
						'DebugLog( "Custom type arrays are not supported" )
						'DebugStop
						fld.set( obj, J._JSON2Array( fld.typeid.name() ) )
					Else
						' Type
						fld.set( obj, J._JSON2Object( fld.typeid.name() ) )
					End If
				Default
					'DebugStop
					fail( "Blitzmax Type '"+fld.typeid.name()+"' cannot be transposed()" )
				End Select
			End Select
        Next

'        ' Add Field names and types to map
'        Local fields:TMap = New TMap()
'        For Local fld:TField = EachIn typeid.EnumFields()
'            fields.insert( fld.name(), fld.typeid.name() )
'        Next
    
'        ' Extract MAP (of JSONs) from value
'        Local map:TMap = TMap( value )
'        If Not map Return Null
'        'logfile.write( "Map extracted from value successfully" )
'        'for local key:string = eachin map.keys()
'        '    logfile.write "  "+key+" = "+ JSON(map[key]).toString()
'        'next

Rem		

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
                        SendUpdate( "log", "ERRR", "Blitzmax type '"+fldtype+"' cannot be transposed()" )
                    End Select
                Catch Exception:String
                    SendUpdate( "log", "CRIT", "Transpose exception" )
                    SendUpdate( "log", "CRIT", Exception )
                End Try
            'else
                'logfile.write "-- Is null"
            End If
        Next
        Return invoke
End Rem
		Return obj
   	End Method
	
'		##### JSON HELPER

	Public

    ' Set the value of a JSON
    Method set( value:String )
		If value.startswith("~q") And value.endswith("~q")
			' STRING
			Self.class = JSTRING
			Self.value = dequote(value)
		Else
			If Lower(value) = "true" Or Lower(value) = "false" Or Lower(value) = "null"
				' KEYWORD (true/false/null)
				Self.class = JKEYWORD
				Self.value = Lower(value)
			Else
				' Treat it as a string
				Self.class = JSTRING
				Self.value = value
			End If
		End If
    End Method

    Method set( value:Int )
        ' If existing value is NOT a number, overwrite it
		Self.class = JNUMBER
		Self.value = String(value)
    End Method

    Method set( value:Float )
        ' If existing value is NOT a number, overwrite it
		Self.class = JNUMBER
		Self.value = String(value)
    End Method

    Method Set( route:String, value:String )
		'_set( route, value, "string" )
		Local J:JSON = find( route, True )	' Find route and create if missing
		If J ; J.set( value )
    End Method

    Method Set( route:String, value:Float )
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
			If class=JOBJECT ' Yay, I am an object.
				If value=Null
					value = New TMap()
				End If
				map = TMap( value )
			Else 
				If Not createme Return New JSON() ' Not found
				' I must now evolve into an object, destroying my previous identity!
				map = New TMap()
				class = JOBJECT
				value = map
			End If
			' Does child exist?
			child = JSON( map.valueforkey( path[0] ) )

'For Local k:String = EachIn map.keys()
'	Print k
'Next

			If Not child 
				If Not createme Return New JSON() ' Not found
				' Add a new child
				child = New JSON( JSTRING, "" )
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
			If class=JOBJECT ' Yay, I am an object.
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
		If class<>JOBJECT ; Return False
		
		' Check I am not empty!
		If Not value ; Return False

		' Check if I contain the given field
		Local map:TMap = TMap( value )
		Return map.contains(name)
    End Method

	' Get SIZE of an ARRAY
	Method size:Int()
		Select class
		Case JARRAY
			Return TObjectList(value).count()
		Case JOBJECT
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
		If class = JARRAY
			Local list:TObjectList = TObjectList(value)
			If list ; Return JSON(list.RemoveFirst())
		End If
		Return Null
	End Method

	' Remove the last record of an ARRAY
	Method RemoveLast:JSON()
		If class = JARRAY
			Local list:TObjectList = TObjectList(value)
			If list ; Return JSON(list.RemoveLast())
		End If
		Return Null
	End Method

	Method _UpgradeToArray:TObjectList()
		Select class
		Case JNUMBER, JSTRING, JKEYWORD, JOBJECT
			' Copy self into another node
			Local node:JSON = New JSON( class )
			node.value = value
			' Create an Array-backed list and insert copy
			Local list:TObjectList = New TObjectList()
			list.addlast( node )
			' Upgrade self to an array
			class = JARRAY
			value = list
			Return list
		Case JINVALID
			Local list:TObjectList = New TObjectList()
			class = JARRAY
			value = list
			Return list
		Case JARRAY
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
	'Method SendUpdate:Object( message:String, state:String, alt:String )
	'	DebugLog( message + ", " + state + ", "+ alt )
	'	Return Null
	'End Method
	
	Method fail:Object( message:String )
		errText = message
		Return Null
	End Method

	Method GetLastError:String()
		Return errText
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
