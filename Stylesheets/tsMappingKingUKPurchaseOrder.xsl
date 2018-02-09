<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order mapper
'  Hospitality iXML to King platform (BASDA 2.4) format.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 03/03/2005  | Lee Boyton   | Created        
'******************************************************************************************
' 13/07/2005  | Lee Boyton   | H465. King core upgrade - new internal format.
'******************************************************************************************
' 16/06/2005  | Lee Boyton   | H577. Remove the delivery cut of date and time.
'******************************************************************************************
'             |              | 
'******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="ISO-8859-1"/>

	<xsl:template match="/">
		<xsl:apply-templates select="@*|node()" />
	</xsl:template>

	<!-- override the routing information so we only get a sender's code for recipient and test flag;
	     and all other information is removed. this will be filled in as appropriate by the receiving platform -->
	<xsl:template match="TradeSimpleHeader">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:value-of select="SendersCodeForRecipient"/>
			</SendersCodeForRecipient>
			<TestFlag>
				<xsl:value-of select="TestFlag"/>
			</TestFlag>
		</TradeSimpleHeader>
	</xsl:template>
	
	<!-- Ensure that the Recipient's Branch reference is put in the Supplier's code for Supplier
	     so that it is available when the associated confirmation comes back -->
	<xsl:template match="SuppliersLocationID[not(SuppliersCode)]">
		<SuppliersLocationID>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:if test="//TradeSimpleHeader/RecipientsBranchReference">
				<SuppliersCode>
					<xsl:value-of select="//TradeSimpleHeader/RecipientsBranchReference"/>
				</SuppliersCode>
			</xsl:if>
		</SuppliersLocationID>
	</xsl:template>
	
	<!-- this second template will cater for the other case of SuppliersLocationID elements that do have a child SuppliersCode-->
	<xsl:template match="SuppliersLocationID/SuppliersCode">
		<xsl:if test="//TradeSimpleHeader/RecipientsBranchReference">
			<SuppliersCode>
				<xsl:value-of select="//TradeSimpleHeader/RecipientsBranchReference"/>
			</SuppliersCode>
		</xsl:if>		
	</xsl:template>
	
	<!--remove any elements from the document that are either not supported or should not be populated on the King platform -->
	<xsl:template match="OrderID|HeaderExtraData|LineExtraData|TrailerExtraData|DeliveryCutOffDate|DeliveryCutOffTime">
	</xsl:template>
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
		
</xsl:stylesheet>
