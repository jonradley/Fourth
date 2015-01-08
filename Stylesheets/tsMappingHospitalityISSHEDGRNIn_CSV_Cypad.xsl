<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
ISS Facility Services HED Cypad CSV GRN mapper
**********************************************************************
Name				| Date			| Change
*********************************************************************
Andrew Barber	| 21/04/2013	| 6259: Created.
*********************************************************************
Andrew Barber	| 04/07/2013	| 6737: Updated senders code for recipient map logic.
*******************************************************************-->
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:vbscript="http://tradesimple.net">

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
			<SendersCodeForRecipient>
				<xsl:value-of select="SendersCodeForRecipient"/>
				<xsl:if test="SendersCodeForRecipient = '7190'">
					<xsl:text>/PE</xsl:text>
				</xsl:if>		
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
	
	<xsl:template match="@LineStatus">
		<xsl:attribute name="LineStatus">
			<xsl:choose>
				<xsl:when test=". = 'A'">
					<xsl:text>Accepted</xsl:text>
				</xsl:when>
				<xsl:when test=". = 'C'">
					<xsl:text>Changed</xsl:text>
				</xsl:when>
				<xsl:when test=". = 'R'">
					<xsl:text>Rejected</xsl:text>
				</xsl:when>
				<xsl:when test=". = 'S'">
					<xsl:text>Added</xsl:text>
				</xsl:when>
				<!-- if the line status is not recognised then pass through the inbound value
					 so the document fails at the xsd validation stage -->
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
			
</xsl:stylesheet>