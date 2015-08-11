<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

 Outbound invoices from Adaco.Net (basically internal format)
 
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


	<xsl:template match="Invoice">
	
		<Invoice>
		
			<TradeSimpleHeader>
				<xsl:copy-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				<xsl:copy-of select="TradeSimpleHeader/SendersBranchReference"/>
				<xsl:copy-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				<RecipientsBranchReference>
					<xsl:value-of select="substring-before(concat(TradeSimpleHeader/RecipientsBranchReference, $HOTEL_SUBDIVISION_SEPERATOR), $HOTEL_SUBDIVISION_SEPERATOR)"/>
				</RecipientsBranchReference>
			</TradeSimpleHeader>
			
			<InvoiceHeader>
				<xsl:copy-of select="InvoiceHeader/BatchInformation"/>
				<xsl:copy-of select="InvoiceHeader/Buyer"/>
				<xsl:copy-of select="InvoiceHeader/Supplier"/>
				
				<ShipTo>
					<ShipToLocationID>
						<xsl:copy-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
						<SuppliersCode>
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</SuppliersCode>
					</ShipToLocationID>
					<xsl:copy-of select="InvoiceHeader/ShipTo/ShipToName"/>
					<xsl:copy-of select="InvoiceHeader/ShipTo/ShipToAddress"/>
				</ShipTo>
				
				<InvoiceReferences>
					<InvoiceReference>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
					</InvoiceReference>
					<InvoiceDate>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
					</InvoiceDate>
					<TaxPointDate>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
					</TaxPointDate>
					<VATRegNo>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/>
					</VATRegNo>
				</InvoiceReferences>
				<xsl:copy-of select="InvoiceHeader/Currency"/>
			</InvoiceHeader>
			
			<InvoiceDetail>
			
				<xsl:for-each select="InvoiceDetail/InvoiceLine">
					<InvoiceLine>
						<xsl:copy-of select="LineNumber"/>
						<xsl:copy-of select="PurchaseOrderReferences"/>
						<xsl:copy-of select="DeliveryNoteReferences"/>
						<ProductID>
							<xsl:copy-of select="ProductID/GTIN"/>
							<xsl:copy-of select="ProductID/SuppliersProductCode"/>
							<BuyersProductCode>
								<xsl:value-of select="InvoiceDetail/InvoiceLine/ProductID/BuyersProductCode"/>
							</BuyersProductCode>
						</ProductID>
						<xsl:copy-of select="ProductDescription"/>
						<InvoicedQuantity>
							<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:attribute>
							<xsl:value-of select="InvoicedQuantity"/>
						</InvoicedQuantity>
						<xsl:copy-of select="PackSize"/>
						<xsl:copy-of select="UnitValueExclVAT"/>
						<xsl:copy-of select="LineValueExclVAT"/>
						<xsl:copy-of select="VATCode"/>
						<xsl:copy-of select="VATRate"/>
					</InvoiceLine>
				</xsl:for-each>
				
			</InvoiceDetail>
			
			<InvoiceTrailer>
				<xsl:copy-of select="InvoiceTrailer/NumberOfLines"/>
				<xsl:copy-of select="InvoiceTrailer/NumberOfItems"/>
				<xsl:copy-of select="InvoiceTrailer/NumberOfDeliveries"/>
				<xsl:copy-of select="InvoiceTrailer/DocumentDiscountRate"/>
				<xsl:copy-of select="InvoiceTrailer/SettlementDiscountRate"/>
				<VATSubTotals>
					<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
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
				<xsl:copy-of select="InvoiceTrailer/DiscountedLinesTotalExclVAT"/>
				<xsl:copy-of select="InvoiceTrailer/DocumentDiscount"/>
				<xsl:copy-of select="InvoiceTrailer/DocumentTotalExclVAT"/>
				<xsl:copy-of select="InvoiceTrailer/SettlementDiscount"/>
				<xsl:copy-of select="InvoiceTrailer/SettlementTotalExclVAT"/>
				<xsl:copy-of select="InvoiceTrailer/VATAmount"/>
				<xsl:copy-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
				<xsl:copy-of select="InvoiceTrailer/SettlementTotalInclVAT"/>
			</InvoiceTrailer>
		</Invoice>
	</xsl:template>


</xsl:stylesheet>
