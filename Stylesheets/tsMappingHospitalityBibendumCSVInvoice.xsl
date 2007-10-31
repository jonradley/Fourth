<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
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
	
	<!-- Bug fix where they incorrectly send multiple invoice structures within each BatchDocument -->
	<xsl:template match="BatchDocument">
		<!-- Now run the following for every invoice found within this BatchDocument element, even if there is only one -->
		<xsl:for-each select="Invoice">
			<!-- Each time we find an invoice element, first (repeat) copy the BatchDocument element -->
			<xsl:element name="BatchDocument">
				<!-- Now process the invoice -->
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			<!-- And before looking for another invoice, (repeat) close the BatchDocument element -->
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<!-- sort all the dates in the file -->
	<xsl:template match="InvoiceHeader/BatchInformation/FileCreationDate">
		<xsl:if test=". != ''">
			<xsl:element name="FileCreationDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="InvoiceHeader/InvoiceReferences/InvoiceDate">
		<xsl:if test=". != ''">
			<xsl:element name="InvoiceDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="InvoiceHeader/InvoiceReferences/TaxPointDate">
		<xsl:if test=". != ''">
			<xsl:element name="TaxPointDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- Currently not provided -->
	<!--xsl:template match="InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate">
		<xsl:if test=". != ''">
			<xsl:element name="PurchaseOrderDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template-->
	<xsl:template match="InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate">
		<xsl:if test=". != ''">
			<xsl:element name="DeliveryNoteDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- Currently not provided -->
	<!--xsl:template match="InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate">
		<xsl:if test=". != ''">
			<xsl:element name="DeliveryNoteDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template-->
	
	<!-- Sort out some Addresses -->
	<xsl:template match="BuyersAddress">
		<xsl:element name="BuyersAddress">
			<xsl:element name="AddressLine1">
				<xsl:value-of select="child::*[1]"/>
			</xsl:element>
			<xsl:element name="AddressLine2">
				<xsl:value-of select="child::*[2]"/>
			</xsl:element>
			<xsl:if test="child::*[3] != ''">
				<xsl:element name="AddressLine3">
					<xsl:value-of select="child::*[3]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[4] != ''">
				<xsl:element name="AddressLine4">
					<xsl:value-of select="child::*[4]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[5] != ''">
				<xsl:element name="PostCode">
					<xsl:value-of select="child::*[5]"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>


	<xsl:template match="SuppliersAddress">
		<xsl:element name="SuppliersAddress">
			<xsl:element name="AddressLine1">
				<xsl:value-of select="child::*[1]"/>
			</xsl:element>
			<xsl:element name="AddressLine2">
				<xsl:value-of select="child::*[2]"/>
			</xsl:element>
			<xsl:if test="child::*[3] != ''">
				<xsl:element name="AddressLine3">
					<xsl:value-of select="child::*[3]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[4] != ''">
				<xsl:element name="AddressLine4">
					<xsl:value-of select="child::*[4]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[5] != ''">
				<xsl:element name="PostCode">
					<xsl:value-of select="child::*[5]"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="ShipToAddress">
		<xsl:element name="ShipToAddress">
			<xsl:element name="AddressLine1">
				<xsl:value-of select="child::*[1]"/>
			</xsl:element>
			<xsl:element name="AddressLine2">
				<xsl:value-of select="child::*[2]"/>
			</xsl:element>
			<xsl:if test="child::*[3] != ''">
				<xsl:element name="AddressLine3">
					<xsl:value-of select="child::*[3]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[4] != ''">
				<xsl:element name="AddressLine4">
					<xsl:value-of select="child::*[4]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[5] != ''">
				<xsl:element name="PostCode">
					<xsl:value-of select="child::*[5]"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	
	<!-- Sort out some numbers -->
	<xsl:template match="VATRate">
		<xsl:element name="VATRate">
			<xsl:value-of select="format-number((. div 1000),'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATRate">
		<xsl:attribute name="VATRate">
			<xsl:value-of select="format-number((. div 1000),'0.00')"/>
		</xsl:attribute>
	</xsl:template>	
	<xsl:template match="DocumentTotalExclVATAtRate">
		<xsl:element name="DocumentTotalExclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalExclVATAtRate">
		<xsl:element name="SettlementTotalExclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="VATAmountAtRate">
		<xsl:element name="VATAmountAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="DocumentTotalInclVATAtRate">
		<xsl:element name="DocumentTotalInclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalInclVATAtRate">
		<xsl:element name="SettlementTotalInclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="DocumentTotalExclVAT">
		<xsl:element name="DocumentTotalExclVAT">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalExclVAT">
		<xsl:element name="SettlementTotalExclVAT">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="VATAmount">
		<xsl:element name="VATAmount">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalInclVAT">
		<xsl:element name="SettlementTotalInclVAT">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="UnitValueExclVAT">
		<xsl:element name="UnitValueExclVAT">
			<xsl:value-of select="format-number(. div 10000,'0.0000')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="LineValueExclVAT">
		<xsl:element name="LineValueExclVAT">
			<xsl:value-of select="format-number(. div 10000,'0.0000')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="NumberOfLinesAtRate">
		<xsl:element name="NumberOfLinesAtRate">
			<xsl:value-of select="format-number(.,'0')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="DocumentTotalExclVATAtRate">
		<xsl:element name="DocumentTotalExclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementDiscountAtRate">
		<xsl:element name="SettlementDiscountAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalExclVATAtRate">
		<xsl:element name="SettlementTotalExclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementDiscount">
		<xsl:element name="SettlementDiscount">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="DocumentTotalInclVAT">
		<xsl:element name="DocumentTotalInclVAT">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>


	<!-- Decode Bibendum's PackSizes -->
	<xsl:template match="InvoicedQuantity">
		<xsl:element name="InvoicedQuantity">
			<xsl:choose>
				<xsl:when test="contains(following-sibling::PackSize,'CASE')">
					<xsl:attribute name="UnitOfMeasure">CS</xsl:attribute>
				</xsl:when>
				<xsl:when test="following-sibling::PackSize = 'BOTTLE'">
					<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="format-number(.,'0')"/>
		</xsl:element>
	</xsl:template>



	<!-- Sort VATCodes -->
	<xsl:template match="VATCode">
		<xsl:element name="VATCode">
			<xsl:call-template name="decodeVATCodes">
				<xsl:with-param name="sVATCode" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATCode">
		<xsl:attribute name="VATCode">
			<xsl:call-template name="decodeVATCodes">
				<xsl:with-param name="sVATCode" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	
	<!--  Format a YYMMDD as YYYY-MM-DD -->
	<xsl:template name="fixDate">
		<xsl:param name="sDate"/>
		<xsl:value-of select="concat('20',substring($sDate,1,2),'-',substring($sDate,3,2),'-',substring($sDate,5,2))"/>
	</xsl:template>
	
	<!-- Decode the VATCodes -->
	<xsl:template name="decodeVATCodes">
		<xsl:param name="sVATCode"/>
		<xsl:choose>
			<xsl:when test="$sVATCode = 'STD'">S</xsl:when>
			<xsl:when test="$sVATCode = 'EXEMPT'">E</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
