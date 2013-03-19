<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

 Outbound credits to Adaco.Net (basically internal format)
 
******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         	| Description of modification
******************************************************************************************
 2013-02-21  | R Cambridge 	| FB6038 Created Module (based on FnB outbound mapper) 
******************************************************************************************
             |            	| 
******************************************************************************************
             |            	| 
******************************************************************************************
             |             	|           
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:include href="./tsMappingHospitalityAdacoCommon.xsl"/>


	<xsl:template match="CreditNote">
		<CreditNote>
			<TradeSimpleHeader>
				<xsl:copy-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				<xsl:copy-of select="TradeSimpleHeader/SendersBranchReference"/>
				<xsl:copy-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				<RecipientsBranchReference>
					<xsl:value-of select="substring-before(concat(TradeSimpleHeader/RecipientsBranchReference, $HOTEL_SUBDIVISION_SEPERATOR), $HOTEL_SUBDIVISION_SEPERATOR)"/>
				</RecipientsBranchReference>
			</TradeSimpleHeader>
			<CreditNoteHeader>
				<xsl:copy-of select="CreditNoteHeader/BatchInformation"/>
				<xsl:copy-of select="CreditNoteHeader/Buyer"/>
				<xsl:copy-of select="CreditNoteHeader/Supplier"/>
				<ShipTo>
					<ShipToLocationID>
						<xsl:copy-of select="CreditNoteHeader/ShipTo/ShipToLocationID/GLN"/>
						<SuppliersCode>
							<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</SuppliersCode>
					</ShipToLocationID>
					<xsl:copy-of select="CreditNoteHeader/ShipTo/ShipToName"/>
					<xsl:copy-of select="CreditNoteHeader/ShipTo/ShipToAddress"/>
				</ShipTo>
				
				<InvoiceReferences>
					<InvoiceReference>
						<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
					</InvoiceReference>
					<InvoiceDate>
						<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
					</InvoiceDate>
				</InvoiceReferences>
				
				<CreditNoteReferences>
					<CreditNoteReference>
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
					</CreditNoteReference>
					<CreditNoteDate>
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
					</CreditNoteDate>
					<TaxPointDate>					
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/TaxPointDate"/>
					</TaxPointDate>
					<VATRegNo>					
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/VATRegNo"/>
					</VATRegNo>
				</CreditNoteReferences>				
				
				<xsl:copy-of select="CreditNoteHeader/Currency"/>
			</CreditNoteHeader>
			<CreditNoteDetail>
				<xsl:for-each select="CreditNoteDetail/CreditNoteLine">
					<CreditNoteLine>
						<xsl:copy-of select="LineNumber"/>
						<xsl:copy-of select="CreditRequestReferences"/>
						<xsl:copy-of select="PurchaseOrderReferences"/>
						<xsl:copy-of select="DeliveryNoteReferences"/>
						<ProductID>
							<xsl:copy-of select="ProductID/GTIN"/>
							<xsl:copy-of select="ProductID/SuppliersProductCode"/>
							<BuyersProductCode>
								<xsl:value-of select="CreditNoteDetail/CreditNoteLine/ProductID/BuyersProductCode"/>
							</BuyersProductCode>
						</ProductID>
						<xsl:copy-of select="ProductDescription"/>
						<CreditedQuantity>
							<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="PackSize"/></xsl:attribute>
							<xsl:value-of select="CreditedQuantity"/>
						</CreditedQuantity>
						<xsl:copy-of select="PackSize"/>
						<xsl:copy-of select="UnitValueExclVAT"/>
						<xsl:copy-of select="LineValueExclVAT"/>
						<xsl:copy-of select="VATCode"/>
						<xsl:copy-of select="VATRate"/>
					</CreditNoteLine>
				</xsl:for-each>
			</CreditNoteDetail>
			<CreditNoteTrailer>
				<xsl:copy-of select="CreditNoteTrailer/NumberOfLines"/>
				<xsl:copy-of select="CreditNoteTrailer/NumberOfItems"/>
				<xsl:copy-of select="CreditNoteTrailer/NumberOfDeliveries"/>
				<xsl:copy-of select="CreditNoteTrailer/DocumentDiscountRate"/>
				<xsl:copy-of select="CreditNoteTrailer/SettlementDiscountRate"/>
				<VATSubTotals>
					<xsl:for-each select="CreditNoteTrailer/VATSubTotals/VATSubTotal">
						<VATSubTotal>
							<xsl:attribute name="VATCode">
								<xsl:value-of select="@VATCode"/>
							</xsl:attribute>
							<xsl:attribute name="VATRate">
								<xsl:value-of select="@VATRate"/>
							</xsl:attribute>
							<xsl:copy-of select="NumberOfLinesAtRate"/>
							<xsl:copy-of select="NumberOfItemsAtRate"/>
							<xsl:copy-of select="DiscountedLinesTotalExclVATAtRate"/>
							<xsl:copy-of select="DocumentDiscountAtRate"/>
							<xsl:copy-of select="DocumentTotalExclVATAtRate"/>
							<xsl:copy-of select="SettlementDiscountAtRate"/>
							<xsl:copy-of select="SettlementTotalExclVATAtRate"/>
							<xsl:copy-of select="VATAmountAtRate"/>
							<xsl:copy-of select="DocumentTotalInclVATAtRate"/>
							<xsl:copy-of select="SettlementTotalInclVATAtRate"/>
						</VATSubTotal>
					</xsl:for-each>
				</VATSubTotals>
				<xsl:copy-of select="CreditNoteTrailer/DiscountedLinesTotalExclVAT"/>
				<xsl:copy-of select="CreditNoteTrailer/DocumentDiscount"/>
				<xsl:copy-of select="CreditNoteTrailer/DocumentTotalExclVAT"/>
				<xsl:copy-of select="CreditNoteTrailer/SettlementDiscount"/>
				<xsl:copy-of select="CreditNoteTrailer/SettlementTotalExclVAT"/>
				<xsl:copy-of select="CreditNoteTrailer/VATAmount"/>
				<xsl:copy-of select="CreditNoteTrailer/DocumentTotalInclVAT"/>
				<xsl:copy-of select="CreditNoteTrailer/SettlementTotalInclVAT"/>
			</CreditNoteTrailer>
		</CreditNote>
	</xsl:template>


</xsl:stylesheet>
