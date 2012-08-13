<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">

<xsl:variable name="TranslationsXML" select="document(concat($RootFolderPath,'/',$LocaleID,'/',$TranslationFile))/listoftext"/>

<xsl:template name="TranslateString">
		<xsl:param name="ID"/>
		<xsl:variable name="InternalID"><xsl:value-of select="concat('msg',format-number($ID,'0000'))"/></xsl:variable>
		<xsl:variable name="TranslatedString"><xsl:value-of select="$TranslationsXML/text[@id = $InternalID]/translation"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="$TranslatedString"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$InternalID"/><xsl:text> is missing</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="TranslateStringWith1Parameter">
		<xsl:param name="ID"/>
		<xsl:param name="Parameter"/>
		<xsl:variable name="InternalID"><xsl:value-of select="concat('msg',format-number($ID,'0000'))"/></xsl:variable>
		<xsl:variable name="TranslatedString"><xsl:value-of select="$TranslationsXML/text[@id = $InternalID]/translation"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{0}')"/><xsl:value-of select="$Parameter"/><xsl:value-of select="substring-after($TranslatedString, '{0}')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$InternalID"/><xsl:text> is missing</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="TranslateStringWith2Parameters">
		<xsl:param name="ID"/>
		<xsl:param name="Parameter0"/>
		<xsl:param name="Parameter1"/>
		<xsl:variable name="InternalID"><xsl:value-of select="concat('msg',format-number($ID,'0000'))"/></xsl:variable>
		<xsl:variable name="TranslatedString"><xsl:value-of select="$TranslationsXML/text[@id = $InternalID]/translation"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{1}')"/><xsl:value-of select="$Parameter1"/><xsl:value-of select="substring-after($TranslatedString, '{1}')"/></xsl:when>
			<xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{0}')"/><xsl:value-of select="$Parameter0"/><xsl:value-of select="substring-after($TranslatedString, '{0}')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$InternalID"/><xsl:text> is missing</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="TranslateStringWith3Parameters">
		<xsl:param name="ID"/>
		<xsl:param name="Parameter0"/>
		<xsl:param name="Parameter1"/>
		<xsl:param name="Parameter2"/>		
		<xsl:variable name="InternalID"><xsl:value-of select="concat('msg',format-number($ID,'0000'))"/></xsl:variable>
		<xsl:variable name="TranslatedString"><xsl:value-of select="$TranslationsXML/text[@id = $InternalID]/translation"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{2}')"/><xsl:value-of select="$Parameter2"/><xsl:value-of select="substring-after($TranslatedString, '{2}')"/></xsl:when>
			<xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{1}')"/><xsl:value-of select="$Parameter1"/><xsl:value-of select="substring-after($TranslatedString, '{1}')"/></xsl:when>			
			<xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{0}')"/><xsl:value-of select="$Parameter0"/><xsl:value-of select="substring-after($TranslatedString, '{0}')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$InternalID"/><xsl:text> is missing</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
<msxsl:script xmlns:msxsl="urn:schemas-microsoft-com:xslt" language="VBScript"  implements-prefix="user">
  <![CDATA[  


		'=========================================================================================
		' Routine       	 : gsFormatDateByLocale
		' Description 	 : Formats the date
		' Inputs          	 : Date node in yyyy-mm-dd format
		'				   LocaleIID
		' Outputs       	 : None
		' Returns       	 : Date in correct format
		' Author       		 : A Sheppard, 09/06/2003
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript and globalised
		'==========================================================================================
		Function gsFormatDateByLocale(vobjDateNode, vsLocaleID)
		Dim sReturn
		Dim dtDate
		Dim lOriginalLocaleID
			
			If IsObject(vobjDateNode) Then
				If vobjDateNode.length > 0 Then
		
					dtDate = DateSerial(CLng(Left(vobjDateNode.item(0).nodeTypedValue, 4)), CLng(Mid(vobjDateNode.item(0).nodeTypedValue, 6, 2)), CLng(Mid(vobjDateNode.item(0).nodeTypedValue, 9, 2)))
					
					'Set script engine to locale specified
					lOriginalLocaleID = SetLocale(vsLocaleID) 
					'Format date using current locale (2 - vbShortDate)
					sReturn = FormatDateTime(dtDate, 2) 
					
					'Restore locale to previous setting
					SetLocale lOriginalLocaleID
					
					If Err.Number > 0 Then
						sReturn = "Invalid Date"
					End If
				Else
					sReturn = ""
				End If	
			Else
				sReturn = ""
			End If	
			 
			 gsFormatDateByLocale= sReturn
				
		End Function
		
		'=========================================================================================
		' Routine       	 : gsFormatTimeByLocale
		' Description 	 : Formats an xsd:time field
		' Inputs          	 : Time node in hh:nn:ss format
		'				   LocaleIID
		' Outputs       	 : None
		' Returns       	 : Date in correct format
		' Author       		 : Lee Boyton, 22/11/2004
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript and globalised
		'==========================================================================================
		Function gsFormatTimeByLocale(vobjTimeNode, vsLocaleID)
		Dim sReturn
		Dim dtTime
		Dim lOriginalLocaleID
		
			If IsObject(vobjTimeNode) Then
				If vobjTimeNode.length > 0 Then
		
					dtTime = CDate("01 Jan 2005 " + vobjTimeNode.item(0).nodeTypedValue)
					
					'Set script engine to locale specified
					lOriginalLocaleID = SetLocale(vsLocaleID) 
					
					'Format time using current locale (4 - vbShortTime)
					sReturn = FormatDateTime(dtTime, 4) 
					
					'Restore locale to previous setting
					SetLocale lOriginalLocaleID
					
					If Err.Number > 0 Then
						sReturn = "Invalid Time"
					End If
				Else
					sReturn = ""
				End If	
			Else
				sReturn = ""
			End If
			 
			 gsFormatTimeByLocale= Left(sReturn, 5)
				
		End Function
		
		'=========================================================================================
		' Routine       	 : gsFormatCurrencyByLocale
		' Description 	 : Formats the number into a 2dp number in the correct format
		' Inputs          	 : Number node in ####.## format
		'				   Number of decimal places
		'				   Locale ID
		' Outputs       	 : None
		' Returns       	 : Number in #,###.00 format
		' Author       		 : A Sheppard, 09/06/2003
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript and globalised
		'=========================================================================================
		Function gsFormatCurrencyByLocale(vobjNumberNode, vlDPs, vsLocaleID)
		Dim sReturn
		Dim dValue
		Dim lOriginalLocaleID
		
			If IsObject(vobjNumberNode) Then
				If vobjNumberNode.length > 0 Then
					dValue = CDbl(vobjNumberNode.item(0).nodeTypedValue)  
				Else
					dValue = 0
				End If
			Else
		      		dValue = CDbl(vobjNumberNode)
		  	End If	
		  	
		  	'Set script engine to locale specified
			lOriginalLocaleID = SetLocale(vsLocaleID)
			
			'Format time using current locale (4 - vbShortTime)
			sReturn = FormatNumber(dValue, vlDPs) 
			
			'Restore locale to previous setting
			SetLocale lOriginalLocaleID
	
			If Err.Number > 0 Then
				sReturn = "Invalid Number"
			End If		
		
		 	gsFormatCurrencyByLocale= sReturn
		
		End Function

		'=========================================================================================
		' Routine         : gsFormatNumberByLocale
		' Description     : Formats a number to a maximum number of decimal places, but does not
		'                   add additional zeros if not required.
		'                   E.g. 4.5 is left as 4.5 rather than 4.5000, but 4.56789 becomes 4.5679.
		' Inputs          : Number node
		'                   Maximum number of decimal places
		'                   Locale ID
		'			vbkeepTrailingZeros - do you want to keep trailing zeros (looks nicer on prices for example) but only keeps the max from vlMaxDPS
		' Outputs       	 : None
		' Returns       	 : Formatted Number
		' Author       	 : Lee Boyton, 29/09/2005. 2353.
		' Alterations   	 : 
		'=========================================================================================
		Function gsFormatNumberByLocale(vobjNumberNode, vlMaxDPs, vsLocaleID, vbkeepTrailingZeros)
		Dim sReturn
		Dim dValue
		Dim sDecimalSeparator

			'set the locale to english, that is the default for numbers which have not already been formatted
			SetLocale 2057
							
			If IsObject(vobjNumberNode) Then
				If vobjNumberNode.length > 0 Then
					dValue = CDbl(vobjNumberNode.item(0).nodeTypedValue)  
				Else
					dValue = CDbl(0)
				End If
			Else
		      		dValue = CDbl(vobjNumberNode)
		  	End If	
			 
		  	'Set script engine to locale specified if we haven't already
			SetLocale vsLocaleID	

			'Format value using the current locale to the indicated number of decimal places, making sure we do not display 1000 seperators
			sReturn = FormatNumber(dValue, vlMaxDPs,,,0) 
			
			'Format a known number so we can get the decimal separator
			sDecimalSeparator = gsLocaleSpecificDecimalCharacter(vsLocaleID)
			
			If Instr(sReturn,sDecimalSeparator) > 0 Then
			
				'Remove any additional zeros after the decimal separator (E.g. 4.5000 would become 4.5)
				If Not CBool(vbkeepTrailingZeros) Then
					Do While Right(sReturn,1) = "0"
						sReturn = Left(sReturn,Len(sReturn)-1)
					Loop
				End If
				
				'If the last character is the decimal separator then remove it.
				If Right(sReturn,1) = sDecimalSeparator Then
					sReturn = Left(sReturn,Len(sReturn)-1)				
				End If
				
			End If
						
			If Err.Number > 0 Then
				sReturn = "Invalid Number"
			End If		
		
		 	gsFormatNumberByLocale= sReturn
		
		End Function

		'=========================================================================================
		' Routine		: gsLocaleSpecificDecimalCharacter
		' Description	: Gets the decimal char in the specified locale
		' Inputs		: vsLocaleID - The locale we want the decimal character from
		' Outputs		: None
		' Returns		: The decimal character
		' Author		: Steve Hewitt, 20/09/2009
		' Alterations	: 
		'=========================================================================================
		Function gsLocaleSpecificDecimalCharacter(vsLocaleID)
			
			Dim lTestNumber
			
			'Format a known number so we can get the decimal separator
			SetLocale 2057 'set to english where we know we can use a decimal point
			lTestNumber = CDbl(1.1)
			SetLocale vsLocaleID
			gsLocaleSpecificDecimalCharacter = Mid(FormatNumber(lTestNumber, 1),2,1)					
							
		End Function
				
		'=========================================================================================
		' Routine       	 : gsGetTodaysDateByLocale
		' Description 	 : Gets todays date, correctly formatted
		' Inputs          	 : Locale ID
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : A Sheppard, 27/02/2004.
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript and globalised
		'=========================================================================================
		Function gsGetTodaysDateByLocale(vsLocaleID)
		Dim dtDate
		Dim lOriginalLocaleID
		Dim sReturn
		
				dtDate = Now
				
				'Set script engine to locale specified
				lOriginalLocaleID = SetLocale(vsLocaleID) 
				
				'Format date using current locale (2 - vbShortDate)
				sReturn = FormatDateTime(dtDate, 2) 
				
				'Restore locale to previous setting
				SetLocale lOriginalLocaleID
				
				gsGetTodaysDateByLocale= sReturn
				
		End Function
		
		'=========================================================================================
		' Routine       	 : msFormatForCSV
		' Description 	 : Formats the string for a csv file
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author             : A Sheppard, 23/08/2004.
		' Alterations   	 :  S Sehgal, 24/04/2010. FB 3536 Converted to VB script
		'========================================================================================
		Function msFormatForCSV(vsString)
		
		
		Dim sString
			If IsObject(vsString) Then
				If vsString.length > 0 Then
					sString= vsString.item(0).nodeTypedValue
				Else
					sString= ""
				End If
			Else
				sString= vsString
			End If	

						
			sString= replace(sString,"""","¬")
			
			sString= replace(sString,"¬","""")
			
			if InStr(sString,"""")> 0 or InStr(sString,",") Then
				sString= """" & sString& """"
			End if
			
			msFormatForCSV = sString
				
		End Function

		Dim msPreviousGroupingValues  
		msPreviousGroupingValues  = "-"
	
		'=========================================================================================
		' Routine       	 : mbNeedHeader
		' Description 	 : Determines whether a new header row is required
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : A Sheppard, 23/08/2004
		' Alterations   	 :  S Sehgal, 24/04/2010. FB 3536 Converted to VB script
		'========================================================================================
		Function mbNeedHeader(vcolGroupingValues)
		
		Dim sCurrentGroupingValues 
		sCurrentGroupingValues = ""
		
			If IsObject(vcolGroupingValues) Then
				for i=0 to vcolGroupingValues.length -1
					sCurrentGroupingValues  = sCurrentGroupingValues  & vcolGroupingValues.item(i).nodeTypedValue & "¬"
				next
			End If
			
			if 	sCurrentGroupingValues <> msPreviousGroupingValues Then
				msPreviousGroupingValues = sCurrentGroupingValues
				msPreviousRowClass = "listrow0"
				mbNeedHeader  = True
			Else
				mbNeedHeader = False
			End if
			
			
		End Function

]]></msxsl:script>

	

</xsl:stylesheet>
