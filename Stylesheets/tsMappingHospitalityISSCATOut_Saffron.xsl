<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview
 Maps Catalogue into a Saffron csv format for Harrison Catering.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 02/02/2009	| Rave Tech		| Created Module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 09/09/2009 | Steve Hewitt    | FB3109 : Removed the group and sub-group, renamed as it is now used for Harrisons and Mitie
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 01/04/2011 | Andrew Barber | FB4365 : Copied default Saffron map and added drop '/n' component of supplier account code.
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script"
                xmlns:user="http://mycompany.com/mynamespace">
	<xsl:output method="text"/>
	
	<xsl:template match="/PriceCatalog">

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!--### HEADER LINE ###-->
		<xsl:text>CATHEAD,</xsl:text>
		
		<xsl:value-of select="substring(PriceCatHeader/CatHdrRef/PriceCat/RefNum,1,10)"/>
		<xsl:text>,</xsl:text>

		<xsl:value-of select="substring(PriceCatHeader/ListOfDescription/Description,1,50)"/>
		<xsl:text>,</xsl:text>

		<xsl:choose>
			<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'/')">
				<xsl:value-of select="substring(substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/'),1,10)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,10)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,T</xsl:text>

		<!--### ITEM LINES ###-->
		<xsl:for-each select="(ListOfPriceCatAction/PriceCatAction)">

			<xsl:value-of select="$NewLine"/>
			<xsl:text>CATITEM,</xsl:text>

			<xsl:value-of select="substring(//PriceCatHeader/CatHdrRef/PriceCat/RefNum,1,10)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(PriceCatDetail/PartNum/PartID,1,20)"/>
			<xsl:text>,</xsl:text>

			<!--xsl:value-of select="substring(PriceCatDetail/ListOfDescription/Description,1,50)"/>
			<xsl:text>,</xsl:text-->
			
			<xsl:if test="contains(user:msEscapeQuotes(substring(PriceCatDetail/ListOfDescription/Description,1,50)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(PriceCatDetail/ListOfDescription/Description,1,50))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(PriceCatDetail/ListOfDescription/Description,1,50)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='PackSize'],1,20)"/>
			
		</xsl:for-each>

	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="user"><![CDATA[ 
	
		Function msEscapeQuotes(inputValue)
			Dim sReturn
				       	
			'sReturn = inputValue.item(0).nodeTypedValue
			sReturn = inputValue
	      		msEscapeQuotes = Replace(sReturn,"""","""" & """")
			
			End Function 
	]]></msxsl:script>
	
</xsl:stylesheet>