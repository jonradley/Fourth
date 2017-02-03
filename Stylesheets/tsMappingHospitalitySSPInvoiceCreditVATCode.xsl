<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
	SSP specifc version of ts internal XML (!)
==========================================================================================
 Module History
==========================================================================================
 Version	|						|
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
11/12//2008	| Rave Tech				| 2640. Changes VAT Code as 'T' when VAT Rate is 15%.
==========================================================================================
           		|                 				|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8"/>


	<!-- identity transformation -->
	<xsl:template match="/ | @* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	
	<xsl:template match="//VATCode">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="../VATCode='S' and (number(../VATRate)=20)">U</xsl:when>
				<xsl:when test="../VATCode='S' and (number(../VATRate)=15)">T</xsl:when>
			<xsl:otherwise><xsl:value-of select="../VATCode"></xsl:value-of></xsl:otherwise> 
			</xsl:choose>
		</xsl:copy> 
	</xsl:template>
	
	<xsl:template match="//@VATCode">
		<xsl:attribute name="VATCode">		
			<xsl:choose>
				<xsl:when test="../@VATCode='S' and (number(../@VATRate)=20)">U</xsl:when>
				<xsl:when test="../@VATCode='S' and (number(../@VATRate)=15)">T</xsl:when>
			<xsl:otherwise><xsl:value-of select="../@VATCode"></xsl:value-of></xsl:otherwise> 
			</xsl:choose>
		</xsl:attribute> 
	</xsl:template>


	<xsl:template match="//CreditNoteLine[not(DeliveryNoteReferences/DeliveryNoteReference)]">
		<CreditNoteLine>
			<xsl:copy-of select="LineNumber"/>
			<xsl:copy-of select="CreditRequestReferences"/>
			<xsl:copy-of select="PurchaseOrderReferences"/>
			<xsl:copy-of select="PurchaseOrderConfirmationReferences"/>
			<!-- Build a delivery note references element using credit note ref where there isn't one in the internal doc -->
			<DeliveryNoteReferences>
				<DeliveryNoteReference>
					<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				</DeliveryNoteReference>
				<DeliveryNoteDate>
					<xsl:choose>
						<xsl:when test="DeliveryNoteReferences/DeliveryNoteDate != ''">
							<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
						</xsl:otherwise>
					</xsl:choose>
				</DeliveryNoteDate>
				<DespatchDate>
					<xsl:choose>
						<xsl:when test="DeliveryNoteReferences/DespatchDate != ''">
							<xsl:value-of select="DeliveryNoteReferences/DespatchDate"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
						</xsl:otherwise>
					</xsl:choose>
				</DespatchDate>
			</DeliveryNoteReferences>
			<xsl:copy-of select="GoodsReceivedNoteReferences"/>
			<xsl:copy-of select="ProductID"/>
			<xsl:copy-of select="ProductDescription"/>
			<xsl:copy-of select="OrderedQuantity"/>
			<xsl:copy-of select="ConfirmedQuantity"/>
			<xsl:copy-of select="DeliveredQuantity"/>
			<xsl:copy-of select="InvoicedQuantity"/>
			<xsl:copy-of select="CreditedQuantity"/>
			<xsl:copy-of select="PackSize"/>
			<xsl:copy-of select="UnitValueExclVAT"/>
			<xsl:copy-of select="LineValueExclVAT"/>
			<xsl:copy-of select="LineDiscountRate"/>
			<xsl:copy-of select="LineDiscountValue"/>
			<xsl:apply-templates select="VATCode"/>
			<!--xsl:copy-of select="VATCode"/-->
			<xsl:copy-of select="VATRate"/>
			<xsl:copy-of select="Narrative"/>
			<xsl:copy-of select="NetPriceFlag"/>
			<xsl:copy-of select="Measure"/>
			<xsl:copy-of select="LineExtraData"/>
		</CreditNoteLine>
	</xsl:template>
	
</xsl:stylesheet>