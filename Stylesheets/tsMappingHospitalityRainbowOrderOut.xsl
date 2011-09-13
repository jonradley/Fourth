<?xml version="1.0" encoding="UTF-8"?>
<!-- **************************************************************************************
 Overview
		
 Outbound order mapper producing format used by Rainbow's Order Capture component in JBA
 

******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name            | Description of modification
******************************************************************************************
 17/03/2008 | R Cambridge     | FB2077 Created module
******************************************************************************************
            |                 |                
******************************************************************************************
            |                 |                
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output encoding="utf-8" method="text"/>

	<xsl:variable name="PartyCodeSeperator" select="'_'"/>

	<xsl:template match="/PurchaseOrder">
	
		<xsl:variable name="customerCode">
			<xsl:choose>
				<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender, $PartyCodeSeperator)">
					<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender, $PartyCodeSeperator)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:variable>
			
		<xsl:variable name="unitCode">
			<xsl:choose>
				<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender, $PartyCodeSeperator)">
					<xsl:value-of select="substring-after(TradeSimpleHeader/RecipientsCodeForSender, $PartyCodeSeperator)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:variable>
	
		<xsl:text>[CUST]=</xsl:text>
		<xsl:value-of select="$customerCode"/>
		<xsl:text>&#13;&#10;</xsl:text>	
		
		<xsl:text>[BRANCH]=</xsl:text>
		<xsl:value-of select="$unitCode"/>
		<xsl:text>&#13;&#10;</xsl:text>	
		
		<xsl:text>[ORDERDATE]=</xsl:text>
		<xsl:call-template name="formateDate_DD_MM_YYYY">
			<xsl:with-param name="utcDate" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>			
		</xsl:call-template>		
		<xsl:text>&#13;&#10;</xsl:text>	
		
		<!--
		<xsl:text>[FIRSTNAME]=tbc</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>	
		<xsl:text>[LASTNAME]=tbc</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>	
		
		<xsl:text>[EMAIL ADDRESS]=tbc</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>	
		<xsl:text>[PHONENO]=</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>	
		
		<xsl:text>[MANAGERSNAME]=</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>			
		
		<xsl:text>[ADDROVR]=0</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>	
		<xsl:text>[ADDRLINE1]=</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>	
		<xsl:text>[ADDRLINE2]=</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>	
		<xsl:text>[ADDRLINE3]=</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>	
		<xsl:text>[ADDRLINE4]=</xsl:text>	
		<xsl:text>&#13;&#10;</xsl:text>		
		
		<xsl:text>[POSTCODE]=</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>			
		-->
		
		<xsl:text>[CUSTREF]=</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>&#13;&#10;</xsl:text>			
		
		<!--
		<xsl:text>[CARDNO]=</xsl:text>		
		<xsl:text>&#13;&#10;</xsl:text>	
		<xsl:text>[EXPIRY]=</xsl:text>		
		<xsl:text>&#13;&#10;</xsl:text>	
		<xsl:text>[PROJECT]=</xsl:text>		
		<xsl:text>&#13;&#10;</xsl:text>	
		-->
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<xsl:text>[PRODUCT]=</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>&#13;&#10;</xsl:text>	
			
			<xsl:text>[QTY]=</xsl:text>
			<xsl:value-of select="format-number(OrderedQuantity,'#')"/>
			<xsl:text>&#13;&#10;</xsl:text>	
			
		</xsl:for-each>
	
	</xsl:template>
	
	<xsl:template name="formateDate_DD_MM_YYYY">
		<xsl:param name="utcDate"/>
		
		<!-- UTC to DD/MM/YYY -->
		<xsl:value-of select="concat(substring($utcDate,9,2),'/',substring($utcDate,6,2),'/',substring($utcDate,1,4))"/>	
	
	</xsl:template>


</xsl:stylesheet>
