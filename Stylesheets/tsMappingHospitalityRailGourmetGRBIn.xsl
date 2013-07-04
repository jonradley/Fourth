<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Rail Gourmet GRN Map
**********************************************************************
Name				| Date			| Change
*********************************************************************
Andrew Barber	| 21/04/2013	| 6374 Created.
*******************************************************************-->
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:vbscript="http://abs-Ltd.com">

	<xsl:template match="/">
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<xsl:apply-templates select="@*|node()"/>
		</BatchRoot>
	</xsl:template>
	
	<xsl:template match="BatchDocument">
		<BatchDocument DocumentTypeNo="85">
			<xsl:apply-templates select="@*|node()"/>
		</BatchDocument>
	</xsl:template>
		
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
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
			<SendersCodeForRecipient>
				<xsl:value-of select="format-number(SendersCodeForRecipient,'00000000')"/>
			</SendersCodeForRecipient>
			<SendersBranchReference>
				<xsl:value-of select="SendersBranchReference"/>
			</SendersBranchReference>
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
				<BuyersCode>
					<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/SendersBranchReference"/>
				</BuyersCode>
			</ShipToLocationID>
			<xsl:copy-of select="ShipToName"/>
			<xsl:copy-of select="ShipToAddress"/>	
			<xsl:copy-of select="ContactName"/>	
		</ShipTo>	
	</xsl:template>

	<xsl:template match="PurchaseOrderDate | DeliveryNoteDate | GoodsReceivedNoteDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="GoodsReceivedNoteLine">
		<GoodsReceivedNoteLine>
			<xsl:copy-of select="ProductID"/>
			<AcceptedQuantity>
				<xsl:value-of select="format-number(AcceptedQuantity,0)"/>
			</AcceptedQuantity>
			<UnitValueExclVAT>
					<xsl:value-of select="format-number(UnitValueExclVAT div 10000,'0.0000')"/>
			</UnitValueExclVAT>
		</GoodsReceivedNoteLine>
	</xsl:template>
			
</xsl:stylesheet>