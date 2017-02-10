<?xml version="1.0" encoding="UTF-8"?>
<!--*****************************************************************************************************************************
Date 			|	Name				|	Description
********************************************************************************************************************************
04/12/2015	| M Dimant		| FB 10645: Created Module
********************************************************************************************************************************-->				
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
	
	<!-- To Manipulate unit of measure string to our standard-->
	<xsl:template match="@UnitOfMeasure">
		<xsl:call-template name="UOM">
			<xsl:with-param name="UOMdecode" select="."/>
		</xsl:call-template>
	</xsl:template>	
	
	<xsl:template name="UOM">
		<xsl:param name="UOMdecode"/>
			<xsl:attribute name="UnitOfMeasure">
				<xsl:choose>
					<!-- If value is '1' insert EA as the UOM -->
					<xsl:when test="$UOMdecode = '1' ">
						<xsl:text>EA</xsl:text>
					</xsl:when>
					<!-- If value is 'Case' insert CS as the UOM -->
					<xsl:when test="$UOMdecode = 'Case' ">
						<xsl:text>CS</xsl:text>
					</xsl:when>
					<!-- If value is 'EACH' insert EA as the UOM -->
					<xsl:when test="$UOMdecode = 'EACH' ">
						<xsl:text>EA</xsl:text>
					</xsl:when>
					<!-- If value is 'Each' insert EA as the UOM -->
					<xsl:when test="$UOMdecode = 'Each' ">
						<xsl:text>EA</xsl:text>
					</xsl:when>					
					<!-- If value is numerical insert CS as the UOM -->
					<xsl:when test="number($UOMdecode) = $UOMdecode">
							<xsl:text>CS</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
	</xsl:template>
		
	<!--To Manipulate the date string into trade|simple format-->
	<xsl:template match="InvoiceDate | PurchaseOrderDate | DeliveryNoteDate | TaxPointDate">
		<xsl:call-template name="DateHandler">
			<xsl:with-param name="FormatDate" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="DateHandler">
	<xsl:param name="FormatDate"/>
		<xsl:copy>
			<xsl:value-of select="concat('20',substring($FormatDate,5,2),'-',substring($FormatDate,3,2),'-',substring($FormatDate,1,2))"/>
		</xsl:copy>
	</xsl:template>
	
	<!--To Decode the VAT codes into the trade|simple standards-->
	<xsl:template match="VATCode">
		<xsl:element name="VATCode">
			<xsl:call-template name="VAT">
				<xsl:with-param name="VATDecode" select="."/>
			</xsl:call-template>
		</xsl:element>	
	</xsl:template>
	<xsl:template match="@VATCode">
		<xsl:attribute name="VATCode">
			<xsl:call-template name="VAT">
				<xsl:with-param name="VATDecode" select="."/>
			</xsl:call-template>
		</xsl:attribute>	
	</xsl:template>
	
	<xsl:template name="VAT">
	<xsl:param name="VATDecode"/>
		<xsl:choose>
			<xsl:when test="$VATDecode = 1 ">
				<xsl:text>S</xsl:text>
			</xsl:when>
			<xsl:otherwise>Z</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
