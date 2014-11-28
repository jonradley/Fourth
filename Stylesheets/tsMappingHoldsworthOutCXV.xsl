<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
'
' Maps iXML validation errors into Holdsworh format.
' 
' © Alternative Business Solutions Ltd.,2004
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name            | Description of modification
'******************************************************************************************
'  15/07/2004 | A Sheppard   | Created 
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'			 |                        |
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>
	<xsl:template match="/">Validation Error

A message that your company has sent to the tradesimple exchange has failed validation. This message will not be processed by the exchange or forwarded to its intended recipient. We advise you to determine the cause of the error, to correct it and then to re-send the message.<br/>We have provided some details of the message that failed validation. If you cannot determine the reason for the error from these details, then please call our support staff on the number opposite.

Phone: 01993 899294
Fax: 01993 775081
Email: helpdesk@abs-ltd.com

Document and Sender Details:<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersName">
Sender's Name: 				<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersName"/>
</xsl:if>
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress">
Sender's Address: 			<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress/AddressLine1"/>
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress/AddressLine2">.
						<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress/AddressLine2"/>
</xsl:if>	
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress/AddressLine3">.				
						<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress/AddressLine3"/>
</xsl:if>	
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress/AddressLine4">.								
						<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress/AddressLine4"/>
</xsl:if>	
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress/PostCode">.								
						<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersAddress/PostCode"/>
</xsl:if>
</xsl:if>
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersBranchReference">
Sender's Branch Reference:		<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersBranchReference"/>
</xsl:if>
<xsl:if test="/XSDValidationError/DocumentInformation/SendersDocumentReference">
Sender's Doc Ref:			<xsl:value-of select="/XSDValidationError/DocumentInformation/SendersDocumentReference"/>
</xsl:if>
<xsl:if test="/XSDValidationError/DocumentInformation/DocumentTypeName">
Type of Document Sent:			<xsl:value-of select="/XSDValidationError/DocumentInformation/DocumentTypeName"/>
</xsl:if>
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsName">
Recipient's Name:				<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsName"/>
</xsl:if>
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress">
Recipient's Address:			<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress/AddressLine1"/>
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress/AddressLine2">.
						<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress/AddressLine2"/>
</xsl:if>		
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress/AddressLine3">.						
						<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress/AddressLine3"/>
</xsl:if>		
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress/AddressLine4">.								
						<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress/AddressLine4"/>
</xsl:if>		
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress/PostCode">.							
						<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsAddress/PostCode"/>
</xsl:if>			
</xsl:if>						
<xsl:if test="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsBranchReference">
Recipient's Branch Reference:		<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/RecipientsBranchReference"/>
</xsl:if>
Sender's Code for Recipient:		<xsl:value-of select="/XSDValidationError/DocumentInformation/TradeSimpleHeader/SendersCodeForRecipient"/>

Error Details:		
<xsl:for-each select="/XSDValidationError/Errors/Error">											
	<xsl:choose>
		<xsl:when test="Label = 'Error- validation error' ">
			<xsl:choose>
				<xsl:when test="starts-with(Description,'Element content')">
					<xsl:call-template name="TranslateStructuralErrors">																				
						<xsl:with-param name="vsErrorText" select="substring-after(Description, 'Expecting: ')"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="TranslateDataTypeErrors">																				
						<xsl:with-param name="vsErrorText" select="Description"/>																				
						<xsl:with-param name="vsInvalidValue" select="Value"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="Description"/>																		
		</xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
							
Technical Details:
Date and Time:				<xsl:value-of select="translate(/XSDValidationError/ABSInformation/DateTime,'T',' ')"/>
BatchGUID:					<xsl:value-of select="/XSDValidationError/ABSInformation/BatchGUID"/>
Document Number:				<xsl:value-of select="/XSDValidationError/ABSInformation/DocumentNumber"/>
SenderID:					<xsl:value-of select="/XSDValidationError/ABSInformation/SenderID"/>
RecipientID:				<xsl:value-of select="/XSDValidationError/ABSInformation/RecipientID"/>
Validation Schema:			<xsl:value-of select="/XSDValidationError/ABSInformation/ValidationSchema"/>
<xsl:if test="/XSDValidationError/ABSInformation/ValidationStylesheet">
Validation Stylesheet:		<xsl:value-of select="/XSDValidationError/ABSInformation/ValidationStylesheet"/>
</xsl:if>
	</xsl:template>
	
	<!--=======================================================================================
	' Routine        : TranslateStructuralErrors
	' Description    : Maps msxml XSD validation error messages about missing elements
	' Inputs         : The msxml error message and a list of missing elements
	' Returns        : A user friendly error message
	' Author         : Robert Cambridge
	' Alterations    : 
	'=======================================================================================-->
	<xsl:template name="TranslateStructuralErrors">
		<xsl:param name="vsErrorText"/>
		
		<xsl:choose>
		
			<xsl:when test="contains($vsErrorText,',')">
				<xsl:text>tradesimple has not processed this document because one or more of the following elements were expected but are missing:</xsl:text>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:text>tradesimple has not processed this document because the following element was expected but is missing:</xsl:text>
			</xsl:otherwise>
			
		</xsl:choose>
		
		<xsl:call-template name="SpaceElementName">
			<xsl:with-param name="vsName" select="$vsErrorText"/>
		</xsl:call-template>
		
	</xsl:template>
	
	<!--=======================================================================================
	' Routine        : TranslateDataTypeErrors
	' Description    : Maps msxml XSD validation error messages into something a little better
	' Inputs         : The msxml error message and the offending value
	' Returns        : A user friendly error message
	' Author         : Robert Cambridge
	' Alterations    : 
	'=======================================================================================-->
	<xsl:template name="TranslateDataTypeErrors">
		<xsl:param name="vsErrorText"/>
		<xsl:param name="vsInvalidValue"/>
		
		<!-- vsErrorText will have the form
		
				Error parsing '~#~ERROR VALUE~#~' as date datatype. The element: '~#~ERROR ELEMENT~#~'  has an invalid value according to its data type. 
		
				or
		
				Pattern constraint failed. The element: '~#~ERROR ELEMENT~#~'  has an invalid value according to its data type.		
		-->
		
		<xsl:variable name="sInvalidElement">
			<xsl:variable name="sTemp" select="substring-before(substring-after($vsErrorText ,'. The element: '), ' has an invalid value according to its data type.')"/>
			
			<xsl:call-template name="SpaceElementName">
				<xsl:with-param name="vsName" select="translate($sTemp,&quot;' &quot;,'')"/><!-- remove commas and spaces from temp -->
			</xsl:call-template>
			
		</xsl:variable>
		
		<xsl:variable name="sErrorType">		
			<xsl:variable name="sConstraint" select="substring-before($vsErrorText,' constraint failed. The element: ')"/>
			
			<xsl:choose>				
				<xsl:when test="$sConstraint = ''">
					<xsl:value-of select="substring-before(substring-after($vsErrorText, ' as '), ' datatype. The element: ')"/>
				</xsl:when>				
				<xsl:otherwise>
					<xsl:value-of select="$sConstraint"/>
				</xsl:otherwise>				
			</xsl:choose>
			
		</xsl:variable>
		
		<!-- This list relates a contraint type to a fragment of friendly message :)-->
		<xsl:variable name="xmlTranslationList">
			<Errors>
				<Error Lookup="fractiondigits">has too many decimal places</Error>
				<Error Lookup="enumeration">can’t be found in the set of allowed values</Error>
				<Error Lookup="length">has the wrong number of characters</Error>
				<Error Lookup="maxexclusive">is too large</Error>
				<Error Lookup="maxinclusive">is too large</Error>
				<Error Lookup="maxlength">has too many characters</Error>
				<Error Lookup="minexclusive">is too small</Error>
				<Error Lookup="mininclusive">is too small</Error>
				<Error Lookup="minlength">has too few characters</Error>
				<Error Lookup="pattern">doesn’t have an allowable structure</Error>
				<Error Lookup="totaldigits">has too many digits</Error>
				<Error Lookup="boolean">can’t be converted to a boolean</Error>
				<Error Lookup="date">can’t be converted to a date</Error>
				<Error Lookup="datetime">can’t be converted to a date and time</Error>
				<Error Lookup="float">can’t be converted to a floating point number</Error>
				<Error Lookup="int">can’t be converted to an integer</Error>
				<Error Lookup="integer">can’t be converted to an integer</Error>
				<Error Lookup="long">can’t be converted to an integer</Error>
				<Error Lookup="nonnegativeinteger">can’t be converted to a positive integer</Error>
				<Error Lookup="positiveinteger">can’t be converted to a positive integer</Error>
				<Error Lookup="string">can’t be converted to a string</Error>
				<Error Lookup="time">can’t be converted to a time</Error>
			</Errors>
		</xsl:variable>
		
		<!-- the return value.... -->
		<xsl:text>tradesimple has not processed this document because the </xsl:text>
		<xsl:value-of select="$sInvalidElement"/>
		<xsl:text> '</xsl:text>
		<xsl:value-of select="$vsInvalidValue"/>
		<xsl:text>' </xsl:text>
		<xsl:value-of select="msxsl:node-set($xmlTranslationList)/Errors/Error[@Lookup=translate($sErrorType,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')]"/>
		<xsl:text>.</xsl:text>
		
	</xsl:template>

	<!--=======================================================================================
	' Routine        : SpaceElementName
	' Description    : Puts spaces between the words that make up an XML elements name by 
	'							assuming each word begins with a capitial letter. 
							  Recursively calls itself	
	' Inputs         : The element name
	' Returns        : The element name, spaced out a bit
	' Author         : Robert Cambridge
	' Alterations    : 
	'=======================================================================================-->
	<xsl:template name="SpaceElementName">
		<xsl:param name="vsName"/>
		
		<xsl:choose>
		
			<!-- the base case -->
			<xsl:when test="$vsName = ''"/>
			
			<!-- case(s) to catch Acronyms -->
			<xsl:when test="starts-with($vsName, 'VAT')">
				<xsl:text> VAT</xsl:text>
				<xsl:call-template name="SpaceElementName">
					<xsl:with-param name="vsName" select="substring($vsName,4)"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- insert a space before any capitial letter in the output -->
			<xsl:when test="string-length(translate(substring($vsName ,1,1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', '')) = 0">
				<xsl:text> </xsl:text>
				<xsl:value-of select="substring($vsName ,1,1)"/>
				<xsl:call-template name="SpaceElementName">
					<xsl:with-param name="vsName" select="substring($vsName,2)"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- copy anything else straight to the output -->
			<xsl:otherwise>
				<xsl:value-of select="substring($vsName ,1,1)"/>
				<xsl:call-template name="SpaceElementName">
					<xsl:with-param name="vsName" select="substring($vsName,2)"/>
				</xsl:call-template>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>

</xsl:stylesheet>
