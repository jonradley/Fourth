<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************
Date		|	Name				|	Comment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
08/11/2011	|	KOshaughnessy	| Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
05/10/2012 |	A Barber			| Added code to map in invoice reference and date as the delivery note reference and date FB CaseNo:5759
***************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
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
	<!--Reformating Date to Trade|Simple format-->
	<xsl:template match="InvoiceHeader/InvoiceReferences/TaxPointDate |
							   InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate |
							   InvoiceHeader/InvoiceReferences/InvoiceDate |
							   InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate |
							   InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DespatchDate">
		<xsl:call-template name="DateFormat"/>
	</xsl:template>
	<xsl:template name="DateFormat">
		<xsl:param name="sDateFormat" select="."/>
		<xsl:copy>
			<xsl:value-of select="concat(substring($sDateFormat,1,4),'-',substring($sDateFormat,5,2),'-',substring($sDateFormat,7,2))"/>
		</xsl:copy>
	</xsl:template>
	<!--Sorting out the VAT codes-->
	<xsl:template match="VATCode">
		<xsl:element name="VATCode">
			<xsl:call-template name="VATDecode">
				<xsl:with-param name="Translate" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATCode">
		<xsl:attribute name="VATCode"><xsl:call-template name="VATDecode"><xsl:with-param name="Translate" select="."/></xsl:call-template></xsl:attribute>
	</xsl:template>
	<xsl:template name="VATDecode">
		<xsl:param name="Translate"/>
		<xsl:choose>
			<xsl:when test="$Translate = 'ZERO' ">
				<xsl:text>Z</xsl:text>
			</xsl:when>
			<xsl:otherwise>S</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="UOMDECODE">
		<xsl:param name="TranslateUOM"/>
		<xsl:choose>
			<xsl:when test="$TranslateUOM = 'CA' ">
				<xsl:text>CS</xsl:text>
			</xsl:when>
			<xsl:when test="$TranslateUOM = 'CASE' ">
				<xsl:text>CS</xsl:text>
			</xsl:when>
			<xsl:when test="$TranslateUOM = 'CL' ">
				<xsl:text>CS</xsl:text>
			</xsl:when>
			<xsl:when test="$TranslateUOM = 'KG' ">
				<xsl:text>KGM</xsl:text>
			</xsl:when>
			<xsl:when test="$TranslateUOM = 'LITRES' ">
				<xsl:text>LTR</xsl:text>
			</xsl:when>
			<xsl:otherwise>EA</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@UnitOfMeasure">
		<xsl:attribute name="UnitOfMeasure"><xsl:call-template name="UOMDECODE"><xsl:with-param name="TranslateUOM" select="."/></xsl:call-template></xsl:attribute>
	</xsl:template>
	<xsl:template match="InvoiceLine">
		<xsl:element name="InvoiceLine">
			<xsl:apply-templates select="LineNumber"/>
			<xsl:apply-templates select="PurchaseOrderReferences"/>
			<xsl:apply-templates select="PurchaseOrderConfirmationReferences"/>
			<xsl:choose>
				<xsl:when test="../*[1]/DeliveryNoteReferences">
					<xsl:element name="DeliveryNoteReferences">
						<xsl:apply-templates select="../*[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
						<xsl:apply-templates select="../*[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
						<xsl:apply-templates select="../*[1]/DeliveryNoteReferences/DespatchDate"/>
					</xsl:element>				
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="GoodsReceivedNoteReferences"/>
			<xsl:apply-templates select="ProductID"/>
			<xsl:apply-templates select="ProductDescriptions"/>
			<xsl:apply-templates select="OrderedQuantity"/>
			<xsl:apply-templates select="ConfirmedQuantity"/>
			<xsl:apply-templates select="DeliveredQuantity"/>
			<xsl:apply-templates select="InvoicedQuantity"/>
			<xsl:apply-templates select="PackSize"/>
			<xsl:apply-templates select="UnitValueExclVAT"/>
			<xsl:apply-templates select="LineValueExclVAT"/>
			<xsl:apply-templates select="LineDiscountRate"/>
			<xsl:apply-templates select="LineDiscountValue"/>
			<xsl:apply-templates select="VATCode"/>
			<xsl:apply-templates select="VATRate"/>
			<xsl:apply-templates select="NetPriceFlag"/>
			<xsl:apply-templates select="Measure"/>
			<xsl:apply-templates select="LineExtraData"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
