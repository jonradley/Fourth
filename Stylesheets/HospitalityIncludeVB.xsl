<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 This XSL file Provides standard script functionality for the xsl files which create document builder screens

 ©  Fourth Hospitality Ltd., 2009.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 
******************************************************************************************
' 23/09/2009     | S Hewitt   | FB3136. Internationalisation bug fixes for numbers etc
******************************************************************************************

******************************************************************************************
-->

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

	<msxsl:script xmlns:msxsl="urn:schemas-microsoft-com:xslt" language="VBScript" implements-prefix="user">
  <![CDATA[  
		'=========================================================================================
		' Routine       	 : gsFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date node in yyyy-mm-dd format
		'				   LocaleIID
		' Outputs       	 : None
		' Returns       	 : Date in correct format
		' Author       		 : A Sheppard, 09/06/2003
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript and globalised
		'==========================================================================================
		Function gsFormatDate(vobjDateNode, vsLocaleID)
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
			 
			 gsFormatDate = sReturn
				
		End Function
		
		'=========================================================================================
		' Routine       	 : gsFormatTime
		' Description 	 : Formats an xsd:time field
		' Inputs          	 : Time node in hh:nn:ss format
		'				   LocaleIID
		' Outputs       	 : None
		' Returns       	 : Date in correct format
		' Author       		 : Lee Boyton, 22/11/2004
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript and globalised
		'==========================================================================================
		Function gsFormatTime(vobjTimeNode, vsLocaleID)
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
			 
			 gsFormatTime = Left(sReturn, 5)
				
		End Function
		
		'=========================================================================================
		' Routine       	 : gsFormatCurrency
		' Description 	 : Formats the number into a 2dp number in the correct format
		' Inputs          	 : Number node in ####.## format
		'				   Number of decimal places
		'				   Locale ID
		' Outputs       	 : None
		' Returns       	 : Number in #,###.00 format
		' Author       		 : A Sheppard, 09/06/2003
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript and globalised
		'=========================================================================================
		Function gsFormatCurrency(vobjNumberNode, vlDPs, vsLocaleID)
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
		
		 	gsFormatCurrency = sReturn
		
		End Function

		'=========================================================================================
		' Routine         : gsFormatNumber
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
		Function gsFormatNumber(vobjNumberNode, vlMaxDPs, vsLocaleID, vbkeepTrailingZeros)
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
		
		 	gsFormatNumber = sReturn
		
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
		' Routine       	 : gsGetTodaysDate
		' Description 	 : Gets todays date, correctly formatted
		' Inputs          	 : Locale ID
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : A Sheppard, 27/02/2004.
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript and globalised
		'=========================================================================================
		Function gsGetTodaysDate(vsLocaleID)
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
				
				gsGetTodaysDate = sReturn
				
		End Function
		
		'=========================================================================================
		' Routine       	 : gsGetCurrencySymbol
		' Description 	 : Gets the relevant currency symbol given a 3 digit code.
		' Inputs          	 : Node containing 3 digit code representing the currency in the form of an xml node
		' Outputs       	 : None
		' Returns       	 : The currency symbol
		' Author       		 : A Sheppard, 08/05/2002
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript
		'=========================================================================================
		Function gsGetCurrencySymbol(vobjCurrencyCodeNode)
		Dim sCurrencyCode
		Dim sCurrencySymbol
		
			If vobjCurrencyCodeNode.length > 0 Then
				sCurrencyCode = vobjCurrencyCodeNode.item(0).nodeTypedValue
			Else
				sCurrencyCode = ""
			End If
			
			Select Case sCurrencyCode
				Case "GBP"
					sCurrencySymbol = "£"
				Case "EUR"
					sCurrencySymbol = "€"
				Case Else
					sCurrencySymbol = "£"
			End Select
	
			
			gsGetCurrencySymbol = sCurrencySymbol
				
		End Function
		
		'=========================================================================================
		' Routine       	 : gsGetRowClass
		' Description 	 : Gets listrow 0,1,0 etc.
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : A Sheppard, 23/02/2004.
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript
		'=========================================================================================
		Private msPreviousRowClass
		
		Function gsGetRowClass()
		
			Select Case msPreviousRowClass
				Case "listrow0"
					msPreviousRowClass = "listrow1"
				Case "listrow1"
					msPreviousRowClass = "listrow0"
				Case Else
					msPreviousRowClass = "listrow1"
			End Select

			gsGetRowClass= msPreviousRowClass
		End Function
		
		'=========================================================================================
		' Routine       	 : glGetRowNumber
		' Description 	 : Gets next row number.
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Row number
		' Author       		 : A Sheppard, 23/02/2004.
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript
		'=========================================================================================
		Private mlPreviousRowNo
		mlPreviousRowNo = 0
		
		Function glGetRowNumber()
		
			mlPreviousRowNo = mlPreviousRowNo + 1
			glGetRowNumber = mlPreviousRowNo
			
		End Function
		
		'=========================================================================================
		' Routine       	 : gbIsNewRef
		' Description 	 : Returns true if this a new ref - false otherwise
		' Inputs          	 : Reference node being checked
		'				   LocaleID (for blank references)
		' Outputs       	 : None
		' Returns       	 : True/False
		' Author       		 : A Sheppard, 10/05/2004.
		' Alterations   	 : A Sheppard, 05/04/2005. Converted to vbscript
		'=========================================================================================
		Private msPreviousRef
		msPreviousRef = ""
		
		Function gbIsNewRef(vobjRefNode, vsDefault)
		Dim sCurrentRef
			
			If IsObject(vobjRefNode) Then
				If vobjRefNode.length > 0 Then
					If Len(Trim(vobjRefNode.item(0).nodeTypedValue)) > 0 Then
						sCurrentRef = vobjRefNode.item(0).nodeTypedValue
					Else
						sCurrentRef = vsDefault
					End If
				Else
					sCurrentRef = vsDefault
				End If
			Else
				sCurrentRef = vsDefault
			End If
				
			If sCurrentRef = msPreviousRef Then
				gbIsNewRef = false
			Else
				msPreviousRef = sCurrentRef
				gbIsNewRef = true
			End If

		End Function

		'=========================================================================================
		' Routine       	 : gbIsNewRefPair
		' Description 	 : Returns true if this a new ref pair - false otherwise
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : True/False
		' Author       		 : A Sheppard, 22/09/2004.
		' Alterations   	 : 
		'========================================================================================
		Private msPreviousRef1 
		Private msPreviousRef2 
		msPreviousRef1 = ""
		msPreviousRef2 = ""

		Function gbIsNewRefPair(vsRef1, vsRef2)
		
			Dim sCurrentRef1
			Dim sCurrentRef2
			
			If IsObject(vsRef1) Then
				If vsRef1.length > 0 Then
					sCurrentRef1 = vsRef1(0).nodeTypedValue
				Else
					sCurrentRef1 = "UNKNOWN"
				End If
			Else
				sCurrentRef1 = "UNKNOWN"			
			End If
			
			If IsObject(vsRef2) Then
				If vsRef2.length > 0 Then
					sCurrentRef2 = vsRef2(0).nodeTypedValue
				Else
					sCurrentRef2 = "UNKNOWN"
				End If
			Else
				sCurrentRef2 = "UNKNOWN"
			End If
			
			If (sCurrentRef1 = msPreviousRef1 And sCurrentRef2 = msPreviousRef2) Then
				gbIsNewRefPair = false
			Else
				msPreviousRef1 = sCurrentRef1
				msPreviousRef2 = sCurrentRef2
				gbIsNewRefPair = true
			End If
			
		End Function
		
		'=========================================================================================
		' Routine       	 : gsStoreTotal and gdGetTotal
		' Description 	 : Adds up the totals (only use if sum(LineValueExclVAT) or the like is insufficient)
		' Inputs          	 : Line Value
		' Outputs       	 : None
		' Returns       	 : Total
		' Author       		 : A Sheppard, 01/06/2005.
		' Alterations   	 : 
		'========================================================================================*/
		Private mdTotal
		mdTotal = 0
		
		Function gsStoreTotal(vdTotal)
			mdTotal = mdTotal + CDbl(vdTotal)
			gsStoreTotal = ""
		End Function
		
		Function gsGetTotal()
			gsGetTotal = mdTotal
		End Function

	'=========================================================================================
	' Routine		: gUOMDropdown
	' Description	: Filter Available UOMs.
	' Inputs			: sAcceptedUOM, sAvailableUOMs
	' Outputs		: None
	' Returns		: List of Available UOMs.
	' Author		: Rave Tech, 02/12/2008.
	' Alterations	: 
	'========================================================================================*/
	Function gUOMDropdown(sAcceptedUOM,sAvailableUOMs)
		Dim msUOMDropdown
		Dim aUOM
		Dim iCnt
		
		iCnt = 0
		msUOMDropdown = ""
		aUOM = Split(sAvailableUOMs,",")
		
		For iCnt = 0 to UBound(aUOM)
			If  aUOM(iCnt) = sAcceptedUOM Then
				msUOMDropdown = msUOMDropdown + "<option value=" + aUOM(iCnt) + " selected>" + aUOM(iCnt) + "</option>"
			Else
				msUOMDropdown = msUOMDropdown + "<option value=" + aUOM(iCnt) + ">" + aUOM(iCnt) + "</option>"
			End if
		Next
		
		gUOMDropdown = msUOMDropdown

	End Function
	]]></msxsl:script>
</xsl:stylesheet>
