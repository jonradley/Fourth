<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Report into an HTML page

 © Fourth Hospitality., 2012.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 21/03/2012 | Graham Neicho | Created module, copied from tsMappingReportCSV.xsl. Only difference is the include file.
******************************************************************************************
 19/12/2012 | Graham Neicho | FB5900. Added Reports 121 and 132
******************************************************************************************
 10/07/2015 | Jose Miguel | FB10304 - HOTUSA - add translations for reports
******************************************************************************************
 14/12/2015 | Graham Neicho | FB10676 - Adding further translations for Report 161
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:script="http://mycompany.com/mynamespace"
           xmlns:msxsl="urn:schemas-microsoft-com:xslt"
          exclude-result-prefixes="#default xsl msxsl script">
  <xsl:output method="text"/>
  <xsl:include href="InternationalisationDOTNET.xsl"/>

  <xsl:param name="RootFolderPath" select="'./Translations'"/>
  <xsl:param name="LocaleID"><xsl:value-of select = "/Report/@LocaleID"></xsl:value-of></xsl:param>
  <xsl:variable name="TranslationFile">Report<xsl:value-of select = "/Report/@ReportID"></xsl:value-of>.xml</xsl:variable>
  <xsl:variable name="ReportID"><xsl:value-of select = "/Report/@ReportID"></xsl:value-of></xsl:variable>
  <xsl:variable name="CommaCharacter"><xsl:if test="$LocaleID=1034">;</xsl:if><xsl:if test="$LocaleID=2057">,</xsl:if></xsl:variable >

  <xsl:template match="/">
    <xsl:choose>
        <xsl:when test="$LocaleID>0 and ($ReportID=64 or $ReportID=65 or $ReportID=66 or $ReportID=71 or $ReportID=90 or $ReportID=92 or $ReportID=93 or $ReportID=97 or $ReportID=98 or $ReportID=99 or $ReportID=112 or $ReportID=113 or $ReportID=118 or $ReportID = 121 or $ReportID=129 or $ReportID=132 or $ReportID=136 or $ReportID=161)">
        <xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(/Report/ReportName)"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:text> - </xsl:text><xsl:value-of select="script:gsFormatDateByLocale(/Report/ReportDate,number($LocaleID))"/>
        <xsl:text>&#xD;</xsl:text>
        <xsl:text>&#xD;</xsl:text>
        <!--Header Details-->
        <xsl:if test="/Report/HeaderDetails">
          <xsl:for-each select="/Report/HeaderDetails/HeaderDetail">
            <xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="Description"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of><xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="Value"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:text>&#xD;</xsl:text>				
          </xsl:for-each>
        </xsl:if>
        <!--Line Details-->
        <xsl:if test="/Report/LineDetails/LineDetail">
          <xsl:for-each select="/Report/LineDetails/LineDetail">
            <xsl:if test="script:mbNeedHeader(Columns/Column[@GroupBy = '1' or @GroupBy = 'true'])">
              <xsl:text>&#xD;</xsl:text>
              <xsl:for-each select="Columns/Column[@GroupBy = '1' or @GroupBy = 'true']">
                <xsl:variable name="ColumnID"><xsl:value-of select="@ID"/></xsl:variable>
                <xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = $ColumnID])"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of><xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(.)"/></xsl:call-template><xsl:text>&#xD;</xsl:text>
              </xsl:for-each>
              <xsl:for-each select="/Report/LineDetails/Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
                <xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(.)"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of>
              </xsl:for-each>
            </xsl:if>
            <xsl:text>&#xD;</xsl:text>
            <xsl:for-each select="Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
              <xsl:choose>
                <xsl:when test="(@DataType = 6 or @DataType=14 or @DataType=5 or @DataType=131) and . != ''">
                  <xsl:value-of select="script:gsFormatNumberByLocale(.,2,number($LocaleID),0)"/><xsl:value-of select="$CommaCharacter"></xsl:value-of>
                </xsl:when>								
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$ReportID = 118 and position() = 13">
                      <xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(.)"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of>
                    </xsl:when>
                    <xsl:when test="$ReportID = 129 and position() = 9">
                      <xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(.)"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of>
                    </xsl:when>
                    <xsl:when test="$ReportID = 161 and position() = 12">
                      <xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(.)"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="script:msFormatForCSV(.)"></xsl:value-of><xsl:value-of select="$CommaCharacter"></xsl:value-of>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>							
            </xsl:for-each>
          </xsl:for-each>
        </xsl:if>
        <xsl:text>&#xD;</xsl:text>
        <xsl:text>&#xD;</xsl:text>
        <!--Trailer Details-->
        <xsl:if test="/Report/TrailerDetails">
          <xsl:for-each select="/Report/TrailerDetails/TrailerDetail">
            <xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(Description)"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of><xsl:if test="Value != ''"><xsl:value-of select="script:gsFormatNumberByLocale(Value,2,number($LocaleID),0)"/></xsl:if><xsl:text>&#xD;</xsl:text>
          </xsl:for-each>
        </xsl:if>
      
      </xsl:when>
      <xsl:otherwise>
      
        <xsl:value-of select="script:msFormatForCSV(/Report/ReportName)"/><xsl:text> - </xsl:text><xsl:value-of select="script:gsFormatDateByLocale(/Report/ReportDate,2057)"/>
        <xsl:text>&#xD;</xsl:text>
        <xsl:text>&#xD;</xsl:text>
        <!--Header Details-->
        <xsl:if test="/Report/HeaderDetails">
          <xsl:for-each select="/Report/HeaderDetails/HeaderDetail">
            <xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(Value)"/><xsl:text>&#xD;</xsl:text>
          </xsl:for-each>
        </xsl:if>
        <!--Line Details-->
        <xsl:if test="/Report/LineDetails/LineDetail">
          <xsl:for-each select="/Report/LineDetails/LineDetail">
            <xsl:if test="script:mbNeedHeader(Columns/Column[@GroupBy = '1' or @GroupBy = 'true'])">
              <xsl:text>&#xD;</xsl:text>
              <xsl:for-each select="Columns/Column[@GroupBy = '1' or @GroupBy = 'true']">
                <xsl:variable name="ColumnID"><xsl:value-of select="@ID"/></xsl:variable>
                <xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = $ColumnID])"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(.)"/><xsl:text>&#xD;</xsl:text>
              </xsl:for-each>
              <xsl:for-each select="/Report/LineDetails/Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
                <xsl:value-of select="script:msFormatForCSV(.)"/><xsl:text>,</xsl:text>
              </xsl:for-each>
            </xsl:if>
            <xsl:text>&#xD;</xsl:text>
            <xsl:for-each select="Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
              <xsl:value-of select="script:msFormatForCSV(.)"/><xsl:text>,</xsl:text>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:if>
        <xsl:text>&#xD;</xsl:text>
        <xsl:text>&#xD;</xsl:text>
        <!--Trailer Details-->
        <xsl:if test="/Report/TrailerDetails">
          <xsl:for-each select="/Report/TrailerDetails/TrailerDetail">
            <xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(Value)"/><xsl:text>&#xD;</xsl:text>
          </xsl:for-each>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>			
  </xsl:template>
  <xsl:template name="SelectString">
    <xsl:param name="InputString"/>
    <xsl:param name="ReportID"/>
    <xsl:choose>
       <xsl:when test="$ReportID=64">
        <xsl:choose>
		  <xsl:when test="$InputString='Start Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='End Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Total Outlets'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Value Ordered'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Number of Orders'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Average Order Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Value Confirmed'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Number Of Confirmations'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Average Confirmation Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Outlets'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
       </xsl:when>
       <xsl:when test="$ReportID=65">
        <xsl:choose>
		  <xsl:when test="$InputString='Start Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='End Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Total Outlets'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Outlet'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Value Ordered'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Number of Orders'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Average Order Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Value Confirmed'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Number Of Confirmations'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Average Confirmation Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
       </xsl:when>
       <xsl:when test="$ReportID=66">
        <xsl:choose>
		  <xsl:when test="$InputString='Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Hotel'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Operator'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Order Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Start Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='End Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='PO Ref'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Buyer Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Order Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
       </xsl:when>
       <xsl:when test="$ReportID=71">
        <xsl:choose>
		  <xsl:when test="$InputString='Order Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Start Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='End Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='PL Account Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Unit Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Unit Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Purchase Order Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Order Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Date / Time'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Acknowledgement Message Created Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Confirmation Message Created Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Delivery Note Message Created Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Goods Received Note Message Created Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Invoice Message Created Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
       </xsl:when>
      <xsl:when test="$ReportID=90">
        <xsl:choose>
          <xsl:when test="$InputString='Substitution Report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Date From'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Date To'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Note Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Order Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Branch Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Branch Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Product Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Product Description'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Pack Size'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Order Quantity'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Order UOM'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Quantity'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice UOM'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Note'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="20"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Number of rows'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="21"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Not Provided'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="22"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="23"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=92">
        <xsl:choose>
          <xsl:when test="$InputString='Aramark Goods Received but not Invoiced Detail Report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Accrual Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Note Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GL Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total excl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Not Provided'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=93">
        <xsl:choose>
          <xsl:when test="$InputString='Aramark Goods Invoiced but not Receipted Detail Report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Accrual Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Default GL Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total excl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total incl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Not Provided'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=97">
        <xsl:choose>
          <xsl:when test="$InputString='Aramark Debit Note Report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Created Date Start'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Created Date End'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Created Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Debit Note Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Debit Note Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total excl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total incl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Not Provided'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=98">
        <xsl:choose>
          <xsl:when test="$InputString='Aramark All Goods Received Detail Report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Start Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='End Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Sender Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Recipient Parent Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Component Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Component Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Account Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Sender Parent Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Sender Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Stock/Non Stock'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='G/L Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='GRN Reference'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GRN Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Note Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Purchase order Reference'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Product Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="20"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Product Description'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="21"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='VAT Rate'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="22"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GRN Quantity'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="23"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GRN Price'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="24"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GRN Amount'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="25"/></xsl:call-template></xsl:when>																					
          <xsl:when test="$InputString='Total GRN Amount'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="26"/></xsl:call-template></xsl:when>																					
          <xsl:when test="$InputString='Not Provided'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="27"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=99">
        <xsl:choose>
          <xsl:when test="$InputString='Aramark All Goods Received Summary Report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Start Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='End Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Sender Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Recipient Parent Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Not Specified'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GL Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GRN Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total GRN Amount'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>																					
          <xsl:when test="$InputString='Not Provided'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=112">
        <xsl:choose>
          <xsl:when test="$InputString='Aramark Goods Receipted and Invoiced (By GL Code) report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Accrual Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Note Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Delivery Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GL Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Total excl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total incl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Threaded'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Accepted'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Exported'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Not Provided'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="20"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="21"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=113">
        <xsl:choose>
          <xsl:when test="$InputString='A0301: Exported Invoices - By Document (H/O Only)'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Accrual Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Note Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Delivery Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total excl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total incl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Threaded'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Accepted'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Exported'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Not Provided'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="20"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=118">
        <xsl:choose>
          <xsl:when test="$InputString='A0502: GRNIs - Detail (All) V3'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Accrual Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Purchase Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Note Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GL Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total excl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Status'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Emergency Goods Received Note'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Active Invoice Discrepancy'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Not Authorised'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Authorised but not Exported'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=129">
        <xsl:choose>
          <xsl:when test="$InputString='Aramark All Goods Received Supplier Report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Date From'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Date To'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Buyers Code for Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Received Delivery Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Purchase Order Reference'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GRN Reference'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GL Category Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='GRN Line Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoiced Yes/No'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Reference'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Invoice Total Ex VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Debit Note Reference'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Debit Total Ex VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Accepted GRN Total Value'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="20"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Yes'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="21"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='No'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="22"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=132">
        <xsl:choose>
          <xsl:when test="$InputString='Purchase Order Detail Report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Start Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='End Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Units'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Address'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Delivery PostCode'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Order Reference'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivery Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Line Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Product Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>									
          <xsl:when test="$InputString='Product Description'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Category'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Sub-category'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='UOM'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="20"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Pack Size'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="21"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Ordered Quantity'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="22"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Confirmed Quantity'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="23"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Price'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="24"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=136">
        <xsl:choose>
		  <xsl:when test="$InputString='To Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Selected PL Accounts'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Selected Components'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Parent Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Price Band – PL Account Description'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Component Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Component'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Delivery Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Order Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Order Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='GRN Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='GRN Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Supplier Product Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Product Description'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Pack Size'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Unit Price'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Extended Cost Price'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>
		  <xsl:when test="$InputString='Delivered Qty'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ReportID=161">
        <xsl:choose>
          <xsl:when test="$InputString='A0002: Debit Notes - (All) v2'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Created Date Start'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Created Date End'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Created Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Unit Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Debit Note Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Debit Note Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total excl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Total incl VAT'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Reason'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Not Provided'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Delivered item missing from invoice'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice price less than entered price at delivery'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice quantity less than accepted quantity at delivery'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="20"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice quantity more than accepted quantity at delivery'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="21"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Rejected on delivery or not receipted'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="22"/></xsl:call-template></xsl:when>
          <xsl:when test="$InputString='Invoice price more than catalogue price at delivery'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="23"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>