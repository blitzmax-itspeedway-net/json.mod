SuperStrict

'	JSON EXAMPLES
'	(c) Copyright Si Dunford, June 2021

Import bmx.json

Local JText:String = "{~qstory~q:{~qJack and Jill~q:{~qcharacters~q:[~qjack~q,~qjill~q]}}}"
Local J:JSON = JSON.Parse( JText )

Local characters:JSON = J.find("story|Jack and Jill|characters")
Print( characters.Prettify() )

