<?xml version="1.0" encoding="UTF-8"?>
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
	
	<!-- Bug fix where they incorrectly send multiple invoice structures within each BatchDocument -->
	<xsl:template match="BatchDocument">
		<!-- Now run the following for every invoice found within this BatchDocument element, even if there is only one -->
		<xsl:for-each select="CreditNote">
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

	<!-- Handle the MIL14T and FMC01T Account -->
	<xsl:template match="TradeSimpleHeader">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:choose>
					<xsl:when test="SendersBranchReference = 'MIL14T'">MIL14T</xsl:when>
					<xsl:when test="SendersBranchReference = 'FMC01T'">FMC01T</xsl:when>
					<xsl:when test="SendersBranchReference = 'TES01T'">TES01T</xsl:when>					
					<xsl:when test="SendersBranchReference = 'TES08T'">TES08T</xsl:when>					
					<xsl:when test="SendersBranchReference = 'TES12T'">TES12T</xsl:when>					
					<xsl:when test="SendersBranchReference = 'TES15T'">TES15T</xsl:when>					
					<xsl:when test="SendersBranchReference = 'TES25T'">TES25T</xsl:when>
					<xsl:when test="SendersBranchReference = 'NOB06T'">ORI05T</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="SendersCodeForRecipient"/>
					</xsl:otherwise>
				</xsl:choose>
			</SendersCodeForRecipient>
			
			<!--xsl:if test="SendersBranchReference = 'MIL14T' or SendersBranchReference = 'FMC01T' or SendersBranchReference = 'TES01T'"-->
			<xsl:if test="contains('MIL14T~FMC01T~TES01T~TES08T~TES12T~TES15T~TES25T',SendersBranchReference)">
				<SendersBranchReference>
					<xsl:value-of select="SendersBranchReference"/>
				</SendersBranchReference>
			</xsl:if>
		</TradeSimpleHeader>
	</xsl:template>
	
	<xsl:template match="ShipToLocationID">
		<ShipToLocationID>
			<SuppliersCode>
				<xsl:value-of select="SuppliersCode"/>
			</SuppliersCode>
			<xsl:if test="//TradeSimpleHeader/SendersBranchReference = 'MIL14T' or //TradeSimpleHeader/SendersBranchReference = 'FMC01T'">
				<BuyersCode>
					<xsl:value-of select="SuppliersCode"/>
				</BuyersCode>
			</xsl:if>
		</ShipToLocationID>
	</xsl:template>
	
	<xsl:template match="CreditNoteHeader/Supplier">
		<Supplier>
			<xsl:if test="//TradeSimpleHeader/SendersBranchReference = 'MIL14T' or //TradeSimpleHeader/SendersBranchReference = 'FMC01T'">
					<SuppliersLocationID>
					<SuppliersCode>Bibendum</SuppliersCode>
				</SuppliersLocationID>
			</xsl:if>
			<xsl:copy-of select="SuppliersName"/>
			<xsl:copy-of select="SuppliersAddress"/>
		</Supplier>
	</xsl:template>

	<xsl:template match="CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate">
		<xsl:if test=". != ''">
			<xsl:element name="InvoiceDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate">
		<xsl:if test=". != ''">
			<xsl:element name="CreditNoteDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate">
		<xsl:if test=". != ''">
			<xsl:element name="TaxPointDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderDate">
		<xsl:if test=". != ''">
			<xsl:element name="PurchaseOrderDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate">
		<xsl:if test=". != ''">
			<xsl:element name="DeliveryNoteDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	
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


	<!-- Decode Bibendum's PackSizes -->
	<xsl:template match="CreditedQuantity">
		<xsl:element name="CreditedQuantity">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:variable name="UoM">
					<xsl:call-template name="decodePacks">
						<xsl:with-param name="sBibPack" select="following-sibling::Measure/UnitsInPack"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$UoM = 1">EA</xsl:when>
					<xsl:otherwise>CS</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="format-number(.,'0')"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="InvoicedQuantity">
		<xsl:element name="InvoicedQuantity">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:variable name="UoM">
					<xsl:call-template name="decodePacks">
						<xsl:with-param name="sBibPack" select="following-sibling::Measure/TotalMeasure"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$UoM = 1">EA</xsl:when>
					<xsl:otherwise>CS</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="format-number(.,'0')"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="Measure">
		<xsl:element name="Measure">
			<xsl:element name="UnitsInPack">
				<xsl:call-template name="decodePacks">
					<xsl:with-param name="sBibPack" select="UnitsInPack"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="TotalMeasure"></xsl:template>



	<!--  Format a YYMMDD as YYYY-MM-DD -->
	<xsl:template name="fixDate">
		<xsl:param name="sDate"/>
		<xsl:value-of select="concat(substring($sDate,1,4),'-',substring($sDate,5,2),'-',substring($sDate,7,2))"/>
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
	
	<xsl:template name="decodePacks">
		<xsl:param name="sBibPack"/>
		<xsl:choose>
			<xsl:when test="normalize-space($sBibPack) = 'EACH' or normalize-space($sBibPack) = 'BOTTLE'">1</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(normalize-space($sBibPack),5)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
