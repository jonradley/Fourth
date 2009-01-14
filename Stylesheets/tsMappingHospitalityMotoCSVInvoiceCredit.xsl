<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations Moto inbound invoice/credit translator
**********************************************************************
Name			|  Date		  | Change
**********************************************************************
Rave Tech     	|  02/01/2009 | Created Module
**********************************************************************
				|			  |				
*********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:variable name="DefaultVATRate" select="'15'"/>
	<xsl:variable name="AccountCode">
		 <xsl:value-of select="string(//TradeSimpleHeader/SendersBranchReference)"/>
	</xsl:variable>
	
	<xsl:variable name="CustomerFlag">
		<xsl:choose>
			<xsl:when test="$AccountCode = '500806'">Ginsters</xsl:when>
			<xsl:when test="$AccountCode = '254692'">3663 CD</xsl:when>
			<xsl:when test="$AccountCode = '504356'">3663 CD</xsl:when>
			<xsl:when test="$AccountCode = '504374'">3663 CD</xsl:when>
			<xsl:when test="$AccountCode = '504375'">3663 CD</xsl:when>
			<xsl:when test="$AccountCode = '504351'">Palmer and Harvey</xsl:when>
			<xsl:when test="$AccountCode = '504352'">Palmer and Harvey</xsl:when>
			<xsl:when test="$AccountCode = '503353'">Palmer and Harvey/></xsl:when>
			<xsl:when test="$AccountCode = '304637'">Coca Cola</xsl:when>
			<xsl:when test="$AccountCode = '506114'">Caspa Marketing</xsl:when>
			<xsl:when test="$AccountCode = '506214'">3663 WS</xsl:when>
			<xsl:when test="$AccountCode = '050811'">3663 BK</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
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

	<!-- DATE CONVERSION dd/mm/yyyy to xsd:date -->
	<xsl:template match="BatchInformation/FileCreationDate |
						InvoiceReferences/InvoiceDate |
						InvoiceReferences/TaxPointDate |
						CreditNoteReferences/CreditNoteDate |
						CreditNoteReferences/TaxPointDate |						
						PurchaseOrderReferences/PurchaseOrderDate |
						DeliveryNoteReferences/DeliveryNoteDate |						
						DeliveryNoteReferences/DespatchDate">
		<xsl:copy>
			<xsl:value-of select="concat(substring(., 1, 2), '-', substring(., 4, 2), '-', substring(., 7, 4))"/>
		</xsl:copy>
	</xsl:template>

	<!--************** HEADERS ***********-->
	<!--***************************************-->

	<!--Set DocumentStatus as 'Original'-->
	<xsl:template match="//DocumentStatus">
		<xsl:element name="DocumentStatus"><xsl:text>Original</xsl:text></xsl:element>
	</xsl:template>

	<!--Set SuppliersName as 'Not Provided-->
	<xsl:template match="//SuppliersName">
		<xsl:element name="SuppliersName"><xsl:text>Not Provided</xsl:text> </xsl:element>
	</xsl:template>

	<!--Set Currency as 'GBP'-->
	<xsl:template match="//Currency">
		<xsl:element name="Currency"><xsl:text>GBP</xsl:text></xsl:element>
	</xsl:template>


	<!--*********** LINE DETAILS **********-->
	<!--***************************************-->

	<!--Add line number-->
	<xsl:template match="//LineNumber">
		<LineNumber><xsl:value-of select="vbscript:getLineNumber()"/></LineNumber>
	</xsl:template>
	
	<!--Append extra values to Product description field-->
	<xsl:template match="//ProductDescription">
		<xsl:copy>
			<xsl:value-of select="../ProductDescription"></xsl:value-of>
			<xsl:if test="..//LineExtraData/ProductDescription2 != ''">
				<xsl:text> </xsl:text> 
				<xsl:value-of select="..//LineExtraData/ProductDescription2"></xsl:value-of>
			</xsl:if> 
		</xsl:copy> 
	</xsl:template>

	<!--Append extra values to Pack size field-->
	<xsl:template match="//PackSize">
		<xsl:copy>
			<xsl:value-of select="../PackSize"></xsl:value-of>
			<xsl:if test="..//LineExtraData/ProductGroup != ''">
				<xsl:text> x </xsl:text>
				<xsl:value-of select="..//LineExtraData/ProductGroup"></xsl:value-of>
				<xsl:value-of select="..//LineExtraData/OriginalProductCode"></xsl:value-of>
			</xsl:if> 
		</xsl:copy> 
	</xsl:template>

	<!--Decode UOM of InvoicedQuantity-->
	<xsl:template match="//InvoicedQuantity">
		<xsl:element name="InvoicedQuantity">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:variable name="UoM">
					<xsl:call-template name="DecodePacks">
						<xsl:with-param name="sMotoPack" select="following-sibling::Measure/UnitsInPack"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$UoM = 1">EA</xsl:when>
					<xsl:otherwise>CS</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!--Append minus (-) sign when Credit Line indicator is 'Y'-->
			<xsl:if test="..//LineExtraData/CodaVATCode = 'Y'">
				<xsl:text>-</xsl:text>
			</xsl:if> 
			<xsl:value-of select="format-number(../InvoicedQuantity, '0.00')"></xsl:value-of>
		</xsl:element>
	</xsl:template>

	<!--Decode UOM of CreditedQuantity-->
	<xsl:template match="//CreditedQuantity">
		<xsl:element name="CreditedQuantity">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:variable name="UoM">
					<xsl:call-template name="DecodePacks">
						<xsl:with-param name="sMotoPack" select="following-sibling::Measure/UnitsInPack"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$UoM = 1">EA</xsl:when>
					<xsl:otherwise>CS</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="format-number(../CreditedQuantity, '0.00')"></xsl:value-of>
		</xsl:element>
	</xsl:template>

	<!--Calculate LineValueExclVAT-->
	<xsl:template match="//LineValueExclVAT">
		<xsl:element name="LineValueExclVAT">
			<!--Append minus (-) sign to when Credit Line indicator is 'Y'-->
			<xsl:if test="..//LineExtraData/CodaVATCode = 'Y'">
				<xsl:text>-</xsl:text>
			</xsl:if> 
			<xsl:choose>
				<xsl:when test="../CreditedQuantity != 0">
					<xsl:value-of select="format-number(../CreditedQuantity * ../UnitValueExclVAT, '0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(../InvoicedQuantity * ../UnitValueExclVAT, '0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<!--Remove LineExtraData element-->
	<xsl:template match="//LineExtraData">
	</xsl:template>

	<!--Derive VATRate-->
	<xsl:template match="//VATRate">
		<xsl:element name="VATRate">
			<xsl:choose>
				<xsl:when test="../VATCode='Z'">0</xsl:when>
				<xsl:otherwise><xsl:value-of select="format-number($DefaultVATRate, '0.00')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<!-- Decode UOM -->
	<xsl:template match="Measure">
		<xsl:element name="Measure">
			<xsl:element name="UnitsInPack">
				<xsl:call-template name="DecodePacks">
					<xsl:with-param name="sMotoPack" select="UnitsInPack"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="DecodePacks">
		<xsl:param name="sMotoPack"/>
		<xsl:choose>
			<xsl:when test="normalize-space($sMotoPack) = 'EACH' or normalize-space($sMotoPack) = 'BOTTLE'">1</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(normalize-space($sMotoPack),5)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!--************** TRAILERS ***********-->
	<!--***************************************-->
	<xsl:template match="NumberOfLines">
		<xsl:choose>
			<xsl:when test="../../CreditNoteDetail/CreditNoteLine/CreditedQuantity != 0">
				<NumberOfLines><xsl:value-of select="count(../../CreditNoteDetail/CreditNoteLine)"/></NumberOfLines>
			</xsl:when>
			<xsl:otherwise>
				<NumberOfLines><xsl:value-of select="count(../../InvoiceDetail/InvoiceLine)"/></NumberOfLines>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<xsl:template match="//NumberOfItems">
		<xsl:choose>
			<xsl:when test="../../CreditNoteDetail/CreditNoteLine/CreditedQuantity != 0">
				<NumberOfItems><xsl:value-of select="sum(../../CreditNoteDetail/CreditNoteLine/CreditedQuantity)"/></NumberOfItems>
			</xsl:when>
			<xsl:otherwise>
				<NumberOfItems><xsl:value-of select="sum(../../InvoiceDetail/InvoiceLine/InvoicedQuantity)"/></NumberOfItems>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="//NumberOfDeliveries">
		<NumberOfDeliveries>1</NumberOfDeliveries>
	</xsl:template>

	<!--Calculate @VATRate-->
	<xsl:template match="//VATSubTotal/@VATRate">
		<xsl:attribute name="{name()}">
			<xsl:choose>
				<xsl:when test="../@VATCode='Z'">0</xsl:when>
				<xsl:otherwise><xsl:value-of select="format-number($DefaultVATRate, '0.00')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 
	Dim lLineNumber
	
	lLineNumber = 1
	Function getLineNumber()
		getLineNumber = lLineNumber
		lLineNumber = lLineNumber + 1
	End Function
	]]></msxsl:script>
	
</xsl:stylesheet>
