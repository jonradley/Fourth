<?xml version="1.0" encoding="UTF-8"?>
<!--
Maps Greggs CSV invoices into internal XML Delivery Notes
**********************************************************************
13/11/2012 |	M Dimant	| 5845: Created. 
**********************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
<xsl:output encoding="utf-8"/>
	
	<xsl:template match="/">
		<BatchRoot>	
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
	
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!--Then let attributes be copied/not copied/modified by other more specific templates -->
			<xsl:apply-templates select="@*"/>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	
	<xsl:template match="BatchDocument">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!-- Fix what documenttype this is -->
			<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- CONVERT TestFlag from Y / N to 1 / 0 -->
	<xsl:template match="TradeSimpleHeader/TestFlag">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string(.) = 'N'">
					<!-- Is NOT TEST: found an N char, map to '0' -->
					<xsl:value-of select="'0'"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Is TEST: map anything else to '1' -->
					<xsl:value-of select="'1'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- Insert a time stamp at the end of the PO reference, making it unique -->
	<xsl:template match="PurchaseOrderReference">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(.,'_',jscript:jstime())"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDate | DeliveryNoteDate | DespatchDate | DeliveryDate | ExpiryDate | SellByDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
		</xsl:element>
	</xsl:template>
	
		<xsl:template match="SlotStart">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(., 1, 2), ':', substring(., 3, 2))"/>
		</xsl:element>
	</xsl:template>
	
		<xsl:template match="SlotEnd">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(., 1, 2), ':', substring(., 3, 2))"/>
		</xsl:element>
	</xsl:template>
	
	
	<msxsl:script language="JScript" implements-prefix="jscript">
       function jstime()
       {
      var time = new Date();
      var hours = time.getHours();
      var min = time.getMinutes();
      var sec = time.getSeconds();
      
      return hours + "" + min + "" + sec;  
       } 
   </msxsl:script> 
	
</xsl:stylesheet>
