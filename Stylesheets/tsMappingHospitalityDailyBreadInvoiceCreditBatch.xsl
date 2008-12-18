<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R cambridge	| 11/06/2007		| Created module
**********************************************************************
           	|           		|
**********************************************************************
           	|           		|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
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
	
	
	<xsl:template match="InvoiceHeader">
		
		<InvoiceHeader>
	
			<DocumentStatus><xsl:value-of select="DocumentStatus"/></DocumentStatus>
				
			<ShipTo>
				<ShipToLocationID>
					<SuppliersCode><xsl:value-of select="../TradeSimpleHeader/SendersCodeForRecipient"/></SuppliersCode>
				</ShipToLocationID>
			</ShipTo>
			
			<InvoiceReferences>
				<xsl:apply-templates select="InvoiceReferences/*"/>
			</InvoiceReferences>
	
		</InvoiceHeader>
	
	</xsl:template>

	
	<xsl:template match="VATCode">	
		<xsl:copy>
			<xsl:choose>
				<xsl:when test=".='1'">Z</xsl:when>
				<xsl:otherwise>S</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>	
	</xsl:template>
	
	<xsl:template match="@VATCode">
		<xsl:attribute name="VATCode">
			<xsl:choose>
				<xsl:when test=".='1'">Z</xsl:when>
				<xsl:otherwise>S</xsl:otherwise>
			</xsl:choose>	
		</xsl:attribute>
	</xsl:template>
	

	<xsl:template match="//PurchaseOrderReferences">
	
		<xsl:choose>
		
			<xsl:when test="PurchaseOrderReference != '' and PurchaseOrderDate != ''">
			
				<PurchaseOrderReferences>
					<PurchaseOrderReference><xsl:value-of select="PurchaseOrderReference"/></PurchaseOrderReference>
					<PurchaseOrderDate><xsl:value-of select="PurchaseOrderDate"/></PurchaseOrderDate>
					<xsl:if test="CustomerPurchaseOrderReference != ''">
						<CustomerPurchaseOrderReference><xsl:value-of select="CustomerPurchaseOrderReference"/></CustomerPurchaseOrderReference>
					</xsl:if>
				</PurchaseOrderReferences>
				
			</xsl:when>
			
			<xsl:otherwise/>
			
		</xsl:choose>
	
	</xsl:template>
	
</xsl:stylesheet>
