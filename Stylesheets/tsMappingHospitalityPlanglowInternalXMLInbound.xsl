<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name				| Date				| Change
**********************************************************************
R Cambridge		| 08/12/2008		| 2601 Created module
**********************************************************************
           		|            		|                                 
**********************************************************************

*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
		
			<Batch>
				<BatchDocuments>
					<BatchDocument>
					
						<xsl:attribute name="DocumentTypeNo">
							<xsl:choose>
								<xsl:when test="/PurchaseOrder">2</xsl:when>
								<xsl:when test="/PurchaseOrderAcknowledgement">84</xsl:when>
								<xsl:when test="/PurchaseOrderConfirmation">3</xsl:when>
								<xsl:when test="/CreditNote">87</xsl:when>
								<xsl:when test="/CreditRequest"></xsl:when>
								<xsl:when test="/DeliveryNote">7</xsl:when>
								<xsl:when test="/Invoice">86</xsl:when>
							</xsl:choose>
						</xsl:attribute>
		
						<xsl:apply-templates/>
						
					</BatchDocument>
				</BatchDocuments>
			</Batch>
						
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
	
	<!-- Change TradeSimpleHeaderSent to TradeSimpleHeader -->
	<xsl:template match="TradeSimpleHeaderSent">
		<xsl:element name="TradeSimpleHeader">
			<xsl:apply-templates select="./*"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="SendersCodeForRecipient">
		<SendersCodeForRecipient>
			<xsl:value-of select="."/>
		</SendersCodeForRecipient>	
		<SendersBranchReference>
			<xsl:value-of select="../../*[contains(name(),'Header')]/Buyer/BuyersLocationID/SuppliersCode"/>
		</SendersBranchReference>
	</xsl:template>

	<xsl:template match="SendersBranchReference"/>

</xsl:stylesheet>
