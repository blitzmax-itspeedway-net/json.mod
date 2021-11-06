
'	JSON Parser
'	(c) Copyright Si Dunford, July 2021, All Rights Reserved

'	CHANGE LOG
'	V1.4	07 AUG 21	Initial version
'	V1.1	16 AUG 21	Fixed issue that made all defined tokens TK_Identifiers!
'	V1.2	18 AUG 21	Added support for REM..(ENDREM|END REM)
'	V1.3	20 AUG 21	Fixed bug where remarks can contain "end rem"!
'	V1.4	26 AUG 21	Removed debugging info
'			03 SEP 21	Array chnaged from JSON[] to TObjectList

Type TJSONParser Extends TParser

    Field linenum:Int = 1
    Field linepos:Int = 1

	Method New( lexer:TLexer )
		Super.New(lexer )
	End Method

	' Over-ride the default parser because we don't need an AST
	Method parse_json:JSON()

		'	RUN THE LEXER
		'Print "~nSTARTING LEXER:"
		'Local start:Int, finish:Int
		'start = MilliSecs()
'DebugStop
		lexer.run()
		'finish = MilliSecs()
		'Print( "LEXER.TIME: "+(finish-start)+"ms" )
	
		'Print( "STARTING LEXER DEBUG:")
		Print( lexer.reveal() )
'DebugStop
		'	RUN THE PARSER
		
		'Print "~nSTARTING PARSER:"
		'Publish( "PARSE-START", Null )		
		token = lexer.reset()
		'Local program:TASTNode = parse_program()
		
'DebugStop
		'Local n:TToken = lexer.getnext()
		'If lexer.getnext().id <> TK_lbrace Return InvalidNode( "Expected '{'" )
		'If token.id <> TK_lbrace Return InvalidNode( "Expected '{'" )
		Local J:JSON = ReadObject()
		If J.isInvalid() Return J 
		advance()
		If token.id <> TK_EOF ; Return InvalidNode( "'"+token.value+"' was unexpected" )
		'If lexer.getnext().id <> TK_rbrace Return InvalidNode( "Expected '}'" )
		'Publish( "PARSE-FINISH", Null )
		
		' Check that file parsing has completed successfully
		'Local after:TToken = lexer.peek()
		'If after.id <> TK_EOF ; ThrowParseError( "'"+after.value+"' unexpected past End", after.line, after.pos )
		
		' Print state and return value
'DebugStop
		'If J
		'	Print "PARSING SUCCESS"
		'Else
		'	Print "PARSING FAILURE"
		'End If
		Return J
	End Method
	

	' Every story starts, as they say, with a beginning...
Rem	Method parse_program:TASTNode()
		
		' Scan the tokens, creating children
		lexer.reset()	' Starting position
		Local token:TToken = lexer.getnext()
		
		' FIRST WE DEAL WITH THE PROGRAM HEADER
		Local ast:TASTCompound = New TASTCompound( "PROGRAM" )
		ast = parseHeader( ast, token )
		
		' NEXT WE DEAL WITH PROGRAM BODY
		Local allow:Int[] = SYM_PROGRAMBODY
		ast = parseBlock( 0, ast, token, allow, error_to_eol )
		
		' INSERT BODY INTO PROGRAM
		'For Local child:TASTNode = EachIn body.children
		'	ast.add( child )
		'Next
	
		If token.id <> TK_EOF
			ThrowParseError( "Unexpected characters past end of program", token.line, token.pos )
		End If
		
		Return ast
	End Method

End Rem

   ' Reads an Object creating a TMAP
Rem
    Method ReadObject:JSON()
        Local node:TMap = New TMap()
        'Local token:TToken

		'DebugStop
		
        If lexer.peek().id = TK_rbrace Return New JSON( "object", node )
        Repeat
            ' Only valid option is a string (KEY)
            token = lexer.getNext()
            If token.id <> TK_QSTRING Return InvalidNode( "Expected quoted String" )

			'DebugStop
			'WE ARE LOOKING HERE To CHECK THAT JSON IS DEQUOTED

            Local name:String = Dequote( token.value )
'If name="text" ; DebugStop
'DebugStop
            ' Only valid option is a colon
			If lexer.getnext().id <> TK_Colon Return InvalidNode( "Expected ':'" )

            ' Get the value for this KEY
            token = lexer.getNext()
            Select token.id	' TOKENS
            Case TK_lbrace   ' "{" = OBJECT
                'PopToken()  ' Throw away the "{"
                Local value:JSON = ReadObject()
				If value.isInvalid() Return value
                If lexer.getnext().id <> TK_rbrace Return InvalidNode( "Expected '}'")
                node.insert( name, value )
				'node.insert( name, New JSON( "object", value ) )
            Case TK_lcrotchet    ' "[" = ARRAY
                'PopToken()  ' Throw away the "{"
                Local value:JSON = ReadArray()
                If lexer.getNext().id <> TK_rcrotchet Return InvalidNode( "Expected ']'" )
                node.insert( name, value ) 
                'node.insert( name, New JSON( "array", value ) )
            Case TK_QSTRING
                'token = PopToken()
				node.insert( name, New JSON( "string", dequote(token.value) ) )
            Case TK_NUMBER
                'token = PopToken()
                node.insert( name, New JSON( "number", token.value ) )
            Case TK_ALPHA
                'token = PopToken()
                Local value:String = token.value
                If value="true" Or value="false" Or value="null"
                    node.insert( name, New JSON( "keyword", token.value ) )
                Else
                    Return InvalidNode( "Unknown identifier" )
                End If
            Default
                Return InvalidNode( "invalid symbol "+token.class+"/"+token.value)
            End Select

            ' Valid options now are "}" or ","
DebugStop
            token = lexer.Peek()
            If token.id = TK_rbrace
                Return New JSON( "object", node )
            ElseIf token.id = TK_Comma
                lexer.getNext()  ' Remove "," from token list
            Else
                lexer.getNext()  ' Remove Token
                Return InvalidNode( "Unexpected symbol '"+token.value+"'" )
            End If
        Forever
    End Method

    ' Reads an Array creating a TList
    Method ReadArray:JSON()
        Local node:TObjectList = New TObjectList()
        Local token:TToken

		'DebugStop
		
        If Lexer.Peek().id = TK_rcrotchet Return New JSON( "array", node )
        Repeat
            ' Get the value for this array element
            token = lexer.getnext()
            Select token.id
            Case TK_lbrace	' "{" = OBJECT
                Local value:JSON = ReadObject()
				If value.isInvalid() Return value
                If lexer.getnext().id <> TK_rbrace Return InvalidNode( "Expected '}'")
                'node :+ [ value ]
				node.addlast( value )
            Case TK_lcrotchet ' "[" = ARRAY
                Local value:JSON = ReadArray()
                If lexer.getnext().id <> TK_rcrotchet Return InvalidNode( "Expected ']'" )
                'node :+ [ value ]	'New JSON( "array", value ) ]
				node.addlast( value )
            Case TK_QSTRING
                'token = PopToken()
                'node :+ [ New JSON( "string", Dequote(token.value) ) ]
				node.addlast( New JSON( "string", Dequote(token.value) ) )
            Case TK_NUMBER
                'token = PopToken()
                'node :+ [ New JSON( "number", token.value ) ]
                node.addlast( New JSON( "number", token.value ) )
            Case TK_ALPHA
                'token = PopToken()
                Local value:String = token.value
                If value="true" Or value="false" Or value="null"
                    'node :+ [ New JSON( value, value ) ]
                    node.addlast( New JSON( value, value ) )
                Else
                    Return InvalidNode( "Unknown identifier '"+token.value+"'" )
                End If
            Default
                Return InvalidNode( "Unknown identifier" )
            End Select

            ' Valid options now are "]" or ","
            token = lexer.Peek()
            If token.id = TK_rcrotchet
                Return New JSON( "array", node )
            ElseIf token.id = TK_Comma
                lexer.getnext()  ' Remove "," from token list
            Else
                Return InvalidNode( "Unexpected symbol '"+token.value+"'" )
            End If
        Forever
    End Method
End Rem

	Method ReadObject:JSON()
		Local node:TMap = New TMap()
		Local ALLOWED:Int[] = [ TK_lbrace,TK_lcrotchet,TK_QSTRING,TK_NUMBER,TK_ALPHA ]
'DebugStop		
		' The leading "{" isn't needed
		If Not eat( TK_lbrace, Null ) Return InvalidNode( "Expected '{'" )
		Repeat	
			Try
				' Termination
				If Not token Or token.id = TK_EOF ; Return InvalidNode( "Unexpected end" )
				If token.id = TK_rbrace ; Return New JSON( "object", node )		
				
				' WE MUST ALWAYS EXPECT A QUOTED STRING FOLLOWED BY A COLON
				
				Local key:TToken = eat( TK_QString, Null )
				If Not key Return InvalidNode( "Expected quoted String" )
				If Not eat( TK_Colon, Null ) Return InvalidNode( "Expected ':'" )
				
				Local name:String = Dequote( key.value )
				
				' NEXT COMES THE CONTENT
				
				Select token.id			
				Case TK_lbrace   ' "{" = OBJECT
					Local value:JSON = ReadObject()
					If value.isInvalid() Return value
					node.insert( name, value )
					advance()
				Case TK_lcrotchet    ' "[" = ARRAY
					'PopToken()  ' Throw away the "{"
					Local value:JSON = ReadArray()
					'If lexer.getNext().id <> TK_rcrotchet Return InvalidNode( "Expected ']'" )
					node.insert( name, value ) 
					'node.insert( name, New JSON( "array", value ) )
					advance()
				Case TK_QSTRING
					node.insert( name, New JSON( "string", dequote(token.value) ) )
					advance()
				Case TK_NUMBER
					node.insert( name, New JSON( "number", token.value ) )
					advance()
				Case TK_ALPHA
					Local value:String = token.value
					If value="true" Or value="false" Or value="null"
						node.insert( name, New JSON( "keyword", token.value ) )
						advance()
					Else
						Return InvalidNode( "Unknown identifier" )
					End If

				Default
					' ALL OPTIONS SHOULD BE ACCOUNTED FOR IN SELECT CASE
					' IF WE GET HERE, WE HAVE A BUG
					Return InvalidNode( "Unexpected identifier" )
				End Select	
		
				' The next symbol can only be a closing symbol or a comma:
				
				Select token.id
				Case TK_COMMA
					eat( TK_Comma )	' Consume the comma and continue
				Case TK_rbrace
					Continue	' This will be caught at the start of the loop
				Default
					Return InvalidNode( "'"+token.value+"' was unexpected" )
				End Select
		
			Catch Exception:String
DebugStop
				Return InvalidNode( "EXCEPTION: "+Exception )
			EndTry
		Forever
	
	End Method
	
	Method ReadArray:JSON()
		Local node:TObjectList = New TObjectList()
		Local ALLOWED:Int[] = [ TK_lbrace,TK_lcrotchet,TK_QSTRING,TK_NUMBER,TK_ALPHA ]
'DebugStop		
		' The leading "{" isn't needed
		If Not eat( TK_lcrotchet, Null ) Return InvalidNode( "Expected '['" )
		Repeat	
			Try
				' Termination
				If Not token Or token.id = TK_EOF ; Return InvalidNode( "Unexpected end" )
				If token.id = TK_rcrotchet ; Return New JSON( "array", node )		

				' NEXT COMES THE CONTENT
				
				Select token.id			
				Case TK_lbrace	' "{" = OBJECT
					Local value:JSON = ReadObject()
					If value.isInvalid() Return value
					node.addlast( value )
					advance()
				Case TK_lcrotchet ' "[" = ARRAY
					Local value:JSON = ReadArray()
					If value.isInvalid() Return value
					node.addlast( value )
					advance()
				Case TK_QSTRING
					node.addlast( New JSON( "string", dequote(token.value) ) )
					advance()
				Case TK_NUMBER
					node.addlast( New JSON( "number", token.value ) )
					advance()
				Case TK_ALPHA
					Local value:String = token.value
					If value="true" Or value="false" Or value="null"
						node.addlast( New JSON( "keyword", token.value ) )
						advance()
					Else
						Return InvalidNode( "Unknown identifier" )
					End If

				Default
					' ALL OPTIONS SHOULD BE ACCOUNTED FOR IN SELECT CASE
					' IF WE GET HERE, WE HAVE A BUG
					Return InvalidNode( "Unexpected identifier" )
				End Select	

				' The next symbol can only be a closing symbol or a comma:
				
				Select token.id
				Case TK_COMMA
					eat( TK_Comma )	' Consume the comma and continue
				Case TK_rcrotchet
					Continue	' This will be caught at the start of the loop
				Default
					Return InvalidNode( "'"+token.value+"' was unexpected" )
				End Select
		
			Catch Exception:String
DebugStop
				Return InvalidNode( "EXCEPTION: "+Exception )
			EndTry
        Forever
	End Method
	
   ' Returns an invalid node object
    Method InvalidNode:JSON( message:String = "Invalid JSON", token:TToken=Null )
        'print( "Creating invalid node at "+linenum+","+linepos )
        'print( errtext )
		Local J:JSON = New JSON( "invalid", message )
		J.errNum  = 1
		J.errText = message
		If token
			J.errLine = token.line
			J.errPos  = token.pos
		Else
			J.errLine = Self.token.line
			J.errPos  = Self.token.pos
		End If
        Return J
    End Method
End Type
