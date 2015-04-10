<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date			| Change
**********************************************************************
R cambridge	| 11/06/2007		| Created module
'*********************************************************************
Rave Tech  		| 26/11/2008		| 2592 - Handled VAT rate change from 17.5% to 15%.
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
	
	
	<!--xsl:template match="BatchDocuments">
		<xsl:copy>
			<xsl:for-each select="BatchDocument[position()!=1]">
				<xsl:copy>
					<xsl:attribute name="DocumentTypeNo">86</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:copy>			
			</xsl:for-each>
		</xsl:copy>
	</xsl:template-->
	
	<xsl:template match="InvoiceDetail/InvoiceLine">
	
		<InvoiceLine>
		
			<xsl:apply-templates select="ProductID"/>
			<xsl:apply-templates select="ProductDescription"/>
			<xsl:apply-templates select="InvoicedQuantity"/>
			
			<UnitValueExclVAT><xsl:value-of select="format-number(LineValueExclVAT div InvoicedQuantity,'0.00')"/></UnitValueExclVAT>
			
			<xsl:apply-templates select="LineValueExclVAT"/>
			<xsl:apply-templates select="VATCode"/>
			<xsl:apply-templates select="VATRate"/>		

		</InvoiceLine>
		
	</xsl:template>
	

	<xsl:template match="InvoiceDate | TaxPointDate | CreditNoteDate | PurchaseOrderDate | DeliveryNoteDate"> 
		<xsl:copy>
			<xsl:call-template name="formatDate">
				<xsl:with-param name="dateAndTime" select="."/>
			</xsl:call-template >
		</xsl:copy>	
	</xsl:template>
	
	
	<xsl:template match="InvoiceLine/DeliveryNoteReferences">
		<xsl:copy>
			<xsl:apply-templates/>
			<xsl:call-template name="formatDate">
				<xsl:with-param name="dateAndTime" select="./DeliveryNoteDate"/>
			</xsl:call-template >
		</xsl:copy>
	</xsl:template>

	
	
	<xsl:template match="VATCode">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="number(.) = 0">Z</xsl:when>
				<xsl:when test="number(.) = 17.5">S</xsl:when>
				<xsl:when test="number(.) = 15">S</xsl:when>
				<xsl:when test="number(.) = 20.0">S</xsl:when>
				<xsl:otherwise>L</xsl:otherwise>
			</xsl:choose>		
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template name="formatDate">
		<xsl:param name="dateAndTime"/>
		<xsl:value-of select="concat(substring($dateAndTime, 7, 4), '-', substring($dateAndTime, 4, 2), '-', substring($dateAndTime, 1, 2))"/>
	</xsl:template>

</xsl:stylesheet>