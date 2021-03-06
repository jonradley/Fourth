<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
CSV Purchase Order mapper

**********************************************************************
Name         | Date       | Change
*********************************************************************
M Dimant  | 15/10/2010 | Created.
**********************************************************************
             |            |                                    
**********************************************************************
             |            |
*******************************************************************-->
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:vbscript="http://abs-Ltd.com">

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
	
	

	<xsl:template match="TradeSimpleHeader">	
		<TradeSimpleHeader>
			<SendersCodeForRecipient><xsl:value-of select="SendersCodeForRecipient"/></SendersCodeForRecipient>
			<xsl:choose>
				<xsl:when test="TestFlag = 'Y'">
					<TestFlag >true</TestFlag > 
				</xsl:when>
				<xsl:when test="TestFlag = 'N'">
					<TestFlag >false</TestFlag > 
				</xsl:when>
			</xsl:choose>	
		</TradeSimpleHeader>	
	</xsl:template>
	
	<xsl:template match="ShipTo">
		<ShipTo>
			<ShipToLocationID>
				<SuppliersCode><xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/SendersBranchReference"/></SuppliersCode>
			</ShipToLocationID>
			<xsl:copy-of select="ShipToName"/>
			<xsl:copy-of select="ShipToAddress"/>	
			<xsl:copy-of select="ContactName"/>	
		</ShipTo>	
	</xsl:template>

	<xsl:template match="PurchaseOrderDate | DeliveryDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
		</xsl:element>
	</xsl:template>
			
</xsl:stylesheet>