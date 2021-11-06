
'	JSON Lexer
'	(c) Copyright Si Dunford, July 2021, All Rights Reserved

'	CHANGE LOG
'	V1.4	07 AUG 21	Initial version
'	V1.1	16 AUG 21	Fixed issue that made all defined tokens TK_Identifiers!
'	V1.2	18 AUG 21	Added support for REM..(ENDREM|END REM)
'	V1.3	20 AUG 21	Fixed bug where remarks can contain "end rem"!
'	V1.4	24 AUG 21	Re-written to use bmx.lexer

Type TJSONLexer Extends TLexer

	Method New( Text:String )
		Super.New( Text )
		'Print "Starting JSON Lexer"
		
		RestoreData json_symbols
		readSymbols()
	End Method

	' Read symbols and add as tokens
	Method readSymbols()
		Local id:Int, value:String, class:String
		ReadData id, value, class
		Repeat
			lookup[Asc(value)]=class
			ReadData id, value, class
		Until id = 0
	End Method

Rem
	Method tokenise()
'DebugStop
		Local token:TToken	' = nextToken()
		'nextChar()			' Move to first character
		previous = New TToken( TK_Invalid, "", 0,0, "" ) ' Beginning of file (Stops NUL)
		Repeat
			token = nextToken()
If token.value="text" ; DebugStop
			' JSON does not need EOL
			If Not (token.id = TK_EOL)
				tokens.addlast( token )
			End If
			previous = token
		Until token.id = TK_EOF
		' Set the token cursor to the first element
		tokpos = tokens.firstLink()
	End Method
End Rem	

	Method nextToken:TToken()
		Repeat
			Local char:String = PeekChar()
			Select True
			Case char = ""						' End of file
				Return New TToken( TK_EOF, "EOF", linenum, linepos, "EOF" )
			Case char = "~n" Or char="~r"		' Ignore End of line
				popChar()
			Case char = " "	Or char = "~t"		' Ignore whitespace between tokens
				popChar()
			Case char < " "	Or char > "~~"		' Throw away control codes
				' Do nothing...
				popchar()
			Default
				Return getNextToken() ' char, linenum, linepos )
			End Select	
		Forever
	End Method
	
	' Language specific tokeniser
	Method GetNextToken:TToken()
		Local char:String = peekchar()
		Local line:Int = linenum
		Local pos:Int = linepos
		'
		Select True
		'Case char="~r"
		Case char = "~q"	' Quote indicates a string
'DebugStop
			Return New TToken( TK_QString, ExtractString(), line, pos, "QSTRING" )
		'Case char = "'"		' Line comment
		'	Return New TToken( TK_Comment, ExtractLineComment(), line, pos, "COMMENT" )
		Case Instr( SYM_NUMBER+"-", char ) > 0	' Number
			Return New TToken( TK_Number, ExtractNumber(), line, pos, "NUMBER" )
		Case Instr( SYM_ALPHA, char )>0       	' Alphanumeric Identifier
			Local Text:String = ExtractIdent( SYM_ALPHA+"_" )
			Return New TToken( TK_ALPHA, Text, line, pos, "ALPHA" )
		'Case Instr( valid_symbols, char, 1 )            ' Single character symbol
		Default								' A Symbol
			PopChar()   ' Move to next character
			Local ascii:Int = Asc(char)
			Local class:String = lookup[ascii]
			If class<>"" Return New TToken( ascii, char, line, pos, class ) 
			' Default to ASCII code
			Return New TToken( ascii, char, line, pos, "SYMBOL" )
		EndSelect
	End Method

End Type


' Single Symbols
' A single symbol uses it's ASCII code unles overwritten here
#json_symbols

'		ID				VALUE	CLASS
DefData TK_dquote,		"~q",	"dquote"
DefData TK_comma,		",",	"comma"
DefData TK_colon,		":",	"colon"		
DefData TK_lcrotchet,	"[",	"lcrotchet"
DefData TK_rcrotchet,	"]",	"rcrotchet"	
DefData TK_lbrace,		"{",	"lbrace"
DefData TK_rbrace,		"}",	"rbrace"	
DefData 0,"#","#"
