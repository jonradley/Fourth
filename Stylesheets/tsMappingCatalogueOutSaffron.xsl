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

******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>

  <!--=======================================================================================
  Routine        : msCSV()
  Description    : Puts " around a string if it contains a comma and replaces " with ""
  Inputs         : A string
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
  <xsl:template name="msCSV">
    <xsl:param name="vs"/>
    <xsl:if test="contains($vs,',') or contains($vs,'&quot;')">
      <xsl:text>"</xsl:text>
    </xsl:if>
    <xsl:call-template name="msQuotes">
      <xsl:with-param name="vs" select="$vs"/>
    </xsl:call-template>
    <xsl:if test="contains($vs,',') or contains($vs,'&quot;')">
      <xsl:text>"</xsl:text>
    </xsl:if>
  </xsl:template>
  
    <!--=======================================================================================
  Routine        : msQuotes
  Description    : Recursively searches for " and replaces it with ""
  Inputs         : A string
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
  <xsl:template name="msQuotes">
    <xsl:param name="vs"/>

    <xsl:choose>

      <xsl:when test="$vs=''"/>
      <!-- base case-->

      <xsl:when test="substring($vs,1,1)='&quot;'">
        <!-- " found -->
        <!--xsl:value-of select="substring($vs,1,1)"/-->
        <!--xsl:value-of select="'&quot;'"/-->
        <xsl:text>'</xsl:text>
        <xsl:call-template name="msQuotes">
          <xsl:with-param name="vs" select="substring($vs,2)"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <!-- other character -->
        <xsl:value-of select="substring($vs,1,1)"/>
        <xsl:call-template name="msQuotes">
          <xsl:with-param name="vs" select="substring($vs,2)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

	
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

		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,10)"/>
		<xsl:text>,T</xsl:text>

		<!--### ITEM LINES ###-->
		<xsl:for-each select="(ListOfPriceCatAction/PriceCatAction)">

			<xsl:value-of select="$NewLine"/>
			<xsl:text>CATITEM,</xsl:text>

			<xsl:value-of select="substring(//PriceCatHeader/CatHdrRef/PriceCat/RefNum,1,10)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(PriceCatDetail/PartNum/PartID,1,20)"/>
			<xsl:text>,</xsl:text>

      <xsl:call-template name="msCSV">
        <xsl:with-param name="vs" select="substring(PriceCatDetail/ListOfDescription/Description,1,50)"/>
      </xsl:call-template>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='PackSize'],1,20)"/>
		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>
