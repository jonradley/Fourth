<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' Overview 
'  XSL Credit Note mapper
'  Hospitality iXML to King platform format.
'
' © ABS Ltd., 2007.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date            | Name             | Description of modification
'******************************************************************************************
' 13/11/2007  | Steve Hewitt | Created for FB 1595 
'******************************************************************************************
'
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
	
	<!-- Ensure that the Recipient's Branch reference is put in the Supplier's code for Supplier -->
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

	<!-- PO ref and date are mandatory in King but optional in Hosp so use the Credit Note ref and date if missing -->
	<!-- This one looks for lines which have no Credit Request ref (the node before purchaseorderref) or Purchase Order ref -->
	<xsl:template match="LineNumber[name(following-sibling::*[1]) != 'CreditRequestReferences' and name(following-sibling::*[1]) != 'PurchaseOrderReferences']">
		<LineNumber>
			<xsl:apply-templates select="@*|node()" />
		</LineNumber>		
		<PurchaseOrderReferences>
			<PurchaseOrderReference>
				<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			</PurchaseOrderReference>
			<PurchaseOrderDate>
				<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</PurchaseOrderDate>
		</PurchaseOrderReferences>
	</xsl:template>

	<!-- This one looks for lines which have a Credit Request ref but no Purchase Order ref -->
	<xsl:template match="CreditRequestReferences[name(following-sibling::*[1]) != 'PurchaseOrderReferences']">
		<CreditRequestReferences>
			<xsl:apply-templates select="@*|node()" />
		</CreditRequestReferences>	
		<PurchaseOrderReferences>
			<PurchaseOrderReference>
				<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			</PurchaseOrderReference>
			<PurchaseOrderDate>
				<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</PurchaseOrderDate>
		</PurchaseOrderReferences>
	</xsl:template>	
	
	<!--remove any elements from the document that are either not supported or should not be populated on the King platform -->
	<xsl:template match="MHDSegment|SuppliersName|CreditRequestStatus|JobNumber|DistributionsHeader|DistributionsDetail|DistributionsTrailer">
	</xsl:template>
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
		
</xsl:stylesheet>
