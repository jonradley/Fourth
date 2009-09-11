<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Takes the internal version of a Invoice and map it directly into the same format.
 
 © Alternative Business Solutions Ltd., 2000.
******************************************************************************************
 Module History
******************************************************************************************
 Version     | 
******************************************************************************************
 Date            | Name                       | Description of modification
******************************************************************************************
07/07/2009  | Rave Tech			| FB2989 Created stylesheet
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
28/07/2009  | Steve Hewitt		| FB2989 LineExtraData was missing AccountCode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
30/07/2009  | Rave Tech			| FB2989 IsStockProduct,CataloguePrice,CataloguePackSize nodes should always be added.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
13/08/2009  | Steve Hewitt		| FB2989 Always add all nodes, even if empty
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    |                   |                                                                               
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="Invoice">
		<xsl:element name="Invoice">
			<xsl:element name="TradeSimpleHeader">	
			
				<!-- Sender Details -->			
				<xsl:element name="SendersCodeForRecipient">
					<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				</xsl:element>				
				<xsl:element name="SendersBranchReference">
					<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
				</xsl:element>	
				<xsl:element name="SendersName">
					<xsl:value-of select="TradeSimpleHeader/SendersName"/>
				</xsl:element>
				<xsl:element name="SendersAddress">						
					<xsl:element name="AddressLine1">
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine1"/>
					</xsl:element>							
					<xsl:element name="AddressLine2">
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine2"/>
					</xsl:element>
					<xsl:element name="AddressLine3">
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine3"/>
					</xsl:element>
					<xsl:element name="AddressLine4">
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine4"/>
					</xsl:element>
					<xsl:element name="PostCode">
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/PostCode"/>
					</xsl:element>
				</xsl:element>
				
				<!-- Recipient Details -->
				<xsl:element name="RecipientsCodeForSender">
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</xsl:element>
				<xsl:element name="RecipientsBranchReference">
					<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
				</xsl:element>
				<xsl:element name="RecipientsName">
					<xsl:value-of select="TradeSimpleHeader/RecipientsName"/>
				</xsl:element>
				<xsl:element name="RecipientsAddress">						
					<xsl:element name="AddressLine1">
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine1"/>
					</xsl:element>							
					<xsl:element name="AddressLine2">
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine2"/>
					</xsl:element>
					<xsl:element name="AddressLine3">
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine3"/>
					</xsl:element>
					<xsl:element name="AddressLine4">
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine4"/>
					</xsl:element>
					<xsl:element name="PostCode">
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/PostCode"/>
					</xsl:element>
				</xsl:element>
				
				<!-- TestFlag -->				
				<xsl:element name="TestFlag">
					<xsl:value-of select="TradeSimpleHeader/TestFlag"/>
				</xsl:element>								
			</xsl:element>
			
			<!-- InvoiceHeader -->
			<xsl:element name="InvoiceHeader">
				<xsl:element name="MHDSegment">						
					<xsl:element name="MHDHeader">
						<xsl:value-of select="InvoiceHeader/MHDSegment/MHDHeader"/>
					</xsl:element>						
					<xsl:element name="MHDVersion">
						<xsl:value-of select="InvoiceHeader/MHDSegment/MHDVersion"/>
					</xsl:element>											
				</xsl:element>
				
				<!-- 	Document Status -->		
				<xsl:element name="DocumentStatus">
					<xsl:value-of select="InvoiceHeader/DocumentStatus"/>
				</xsl:element>
				
				<!-- BatchInformation -->				
				<xsl:element name="BatchInformation">
					<xsl:element name="FileGenerationNo">
						<xsl:value-of select="InvoiceHeader/BatchInformation/FileGenerationNo"/>
					</xsl:element>
					<xsl:element name="FileVersionNo">
						<xsl:value-of select="InvoiceHeader/BatchInformation/FileVersionNo"/>
					</xsl:element>
					<xsl:element name="FileCreationDate">
						<xsl:value-of select="InvoiceHeader/BatchInformation/FileCreationDate"/>
					</xsl:element>
					<xsl:element name="SendersTransmissionReference">
						<xsl:value-of select="InvoiceHeader/BatchInformation/SendersTransmissionReference"/>
					</xsl:element>
					<xsl:element name="SendersTransmissionDate">
						<xsl:value-of select="InvoiceHeader/BatchInformation/SendersTransmissionDate"/>
					</xsl:element>
				</xsl:element>
				
				<!-- Buyer -->				
				<xsl:element name="Buyer">					
					<xsl:element name="BuyersLocationID">						
						<xsl:element name="GLN">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
						</xsl:element>						
						<xsl:element name="BuyersCode">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/>
						</xsl:element>
						<xsl:element name="SuppliersCode">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/>
						</xsl:element>
					</xsl:element>
												
					<!-- BuyersName -->
					<xsl:element name="BuyersName">
						<xsl:value-of select="InvoiceHeader/Buyer/BuyersName"/>
					</xsl:element>
					
					<!-- BuyersAddress-->
					<xsl:element name="BuyersAddress">							
						<xsl:element name="AddressLine1">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/>
						</xsl:element>							
						<xsl:element name="AddressLine2">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/>
						</xsl:element>
						<xsl:element name="AddressLine3">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/>
						</xsl:element>
						<xsl:element name="AddressLine4">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/>
						</xsl:element>
						<xsl:element name="PostCode">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/PostCode"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				
				<!-- Supplier -->				
				<xsl:element name="Supplier">					
					<xsl:element name="SuppliersLocationID">						
						<xsl:element name="GLN">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/GLN"/>
						</xsl:element>						
						<xsl:element name="BuyersCode">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
						</xsl:element>
						<xsl:element name="SuppliersCode">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
						</xsl:element>
					</xsl:element>						
					<!-- SuppliersName -->
					<xsl:element name="SuppliersName">
						<xsl:value-of select="InvoiceHeader/Supplier/SuppliersName"/>
					</xsl:element>
					<!-- SuppliersAddress -->
					<xsl:element name="SuppliersAddress">							
						<xsl:element name="AddressLine1">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/>
						</xsl:element>								
						<xsl:element name="AddressLine2">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/>
						</xsl:element>
						<xsl:element name="AddressLine3">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/>
						</xsl:element>
						<xsl:element name="AddressLine4">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine4"/>
						</xsl:element>
						<xsl:element name="PostCode">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/PostCode"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				
				<!-- ShipTo -->				
				<xsl:element name="ShipTo">					
					<xsl:element name="ShipToLocationID">						
						<xsl:element name="GLN">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
						</xsl:element>						
						<xsl:element name="BuyersCode">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
						</xsl:element>
						<xsl:element name="SuppliersCode">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</xsl:element>
					</xsl:element>							
						
					<xsl:element name="ShipToName">
						<xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/>
					</xsl:element>
					
					<xsl:element name="ShipToAddress">						
						<xsl:element name="AddressLine1">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/>
						</xsl:element>						
						<xsl:element name="AddressLine2">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/>
						</xsl:element>
						<xsl:element name="AddressLine3">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/>
						</xsl:element>
						<xsl:element name="AddressLine4">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/>
						</xsl:element>
						<xsl:element name="PostCode">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/PostCode"/>
						</xsl:element>
					</xsl:element>

					<xsl:element name="ContactName">
						<xsl:value-of select="InvoiceHeader/ShipTo/ContactName"/>
					</xsl:element>													
				</xsl:element>
							
				<!-- Invoice References-->				
				<xsl:element name="InvoiceReferences">					
					<xsl:element name="InvoiceReference">
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
					</xsl:element>		
					<xsl:element name="InvoiceDate">
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
					</xsl:element>
					<xsl:element name="TaxPointDate">
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
					</xsl:element>
					<xsl:element name="VATRegNo">
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/>
					</xsl:element>
					<xsl:element name="BuyersVATRegNo">
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/BuyersVATRegNo"/>
					</xsl:element>
				</xsl:element>
				
				<!-- Currency -->
				<xsl:element name="Currency">
					<xsl:value-of select="InvoiceHeader/Currency"/>
				</xsl:element>
				
				<!-- SequenceNumber-->
				<xsl:element name="SequenceNumber">
					<xsl:value-of select="InvoiceHeader/SequenceNumber"/>
				</xsl:element>
				
				<!-- Header ExtraData-->
				<xsl:element name="HeaderExtraData">
					<xsl:element name="IgnoreInvalidLineValues">
						<xsl:value-of select="InvoiceHeader/HeaderExtraData/IgnoreInvalidLineValues"/>
					</xsl:element>
					<xsl:element name="CostCentreCode">
						<xsl:value-of select="InvoiceHeader/HeaderExtraData/CostCentreCode"/>
					</xsl:element>
					<xsl:element name="STXSupplierCode">
						<xsl:value-of select="InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
			<!-- Invoice  Details-->
			<xsl:element name="InvoiceDetail">
				<xsl:for-each select="InvoiceDetail/InvoiceLine">
					<xsl:element name="InvoiceLine">
					
						<!-- LineNumber -->						
						<xsl:element name="LineNumber">
							<xsl:value-of select="LineNumber"/>
						</xsl:element>
							
						<!-- PurchaseOrderReferences-->
						<xsl:element name="PurchaseOrderReferences">								
							<xsl:element name="PurchaseOrderReference">
								<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
							</xsl:element>								
							<xsl:element name="PurchaseOrderDate">
								<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
							</xsl:element>																										
							<xsl:element name="PurchaseOrderTime">
								<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderTime"/>
							</xsl:element>	
							<xsl:element name="TradeAgreement">
								<xsl:element name="ContractReference">
									<xsl:value-of select="PurchaseOrderReferences/TradeAgreement/ContractReference"/>
								</xsl:element>
								<xsl:element name="ContractDate">
									<xsl:value-of select="PurchaseOrderReferences/TradeAgreement/ContractDate"/>
								</xsl:element>							
							</xsl:element>	
							<xsl:element name="CustomerPurchaseOrderReference">
								<xsl:value-of select="PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
							</xsl:element>	
							<xsl:element name="JobNumber">
								<xsl:value-of select="PurchaseOrderReferences/JobNumber"/>
							</xsl:element>	
						</xsl:element>
						
						<!-- PurchaseOrderConfirmationReferences -->
						<xsl:element name="PurchaseOrderConfirmationReferences">
							<xsl:element name="PurchaseOrderConfirmationReference">
								<xsl:value-of select="PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
							</xsl:element>																										
							<xsl:element name="PurchaseOrderConfirmationDate">
								<xsl:value-of select="PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
							</xsl:element>							
						</xsl:element>
						
						<!-- DeliveryNoteReferences-->
						<xsl:element name="DeliveryNoteReferences">								
							<xsl:element name="DeliveryNoteReference">
								<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
							</xsl:element>								
							<xsl:element name="DeliveryNoteDate">
								<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
							</xsl:element>								
							<xsl:element name="DespatchDate">
								<xsl:value-of select="DeliveryNoteReferences/DespatchDate"/>
							</xsl:element>																										
						</xsl:element>

						<!-- GoodsReceivedNoteReferences-->
						<xsl:element name="GoodsReceivedNoteReferences">								
							<xsl:element name="GoodsReceivedNoteReference">
								<xsl:value-of select="GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
							</xsl:element>								
							<xsl:element name="GoodsReceivedNoteDate">
								<xsl:value-of select="GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
							</xsl:element>																																
						</xsl:element>
												
						<!-- ProductID-->						
						<xsl:element name="ProductID">							
							<xsl:element name="GTIN">
								<xsl:value-of select="ProductID/GTIN"/>
							</xsl:element>							
							<xsl:element name="SuppliersProductCode">
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</xsl:element>
							<xsl:element name="BuyersProductCode">
								<xsl:value-of select="ProductID/BuyersProductCode"/>
							</xsl:element>
						</xsl:element>							
						
						<!-- ProductDescription -->						
						<xsl:element name="ProductDescription">
							<xsl:value-of select="ProductDescription"/>
						</xsl:element>							
						
						<!-- Quantities-->	
						<xsl:element name="OrderedQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="OrderedQuantity"/>																			
						</xsl:element>
						<xsl:element name="ConfirmedQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="ConfirmedQuantity"/>																			
						</xsl:element>	
						<xsl:element name="DeliveredQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="DeliveredQuantity"/>																			
						</xsl:element>																									
						<xsl:element name="InvoicedQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="InvoicedQuantity"/>																			
						</xsl:element>						

						<!-- PackSize -->
						<xsl:element name="PackSize">
							<xsl:value-of select="PackSize"/>
						</xsl:element>	
						
						<!-- UnitValueExclVAT-->						
						<xsl:element name="UnitValueExclVAT">
							<xsl:value-of select="UnitValueExclVAT"/>
						</xsl:element>						
						
						<!-- LineValueExclVAT-->						
						<xsl:element name="LineValueExclVAT">
							<xsl:value-of select="LineValueExclVAT"/>
						</xsl:element>						
						
						<!-- LineDiscountRate-->
						<xsl:element name="LineDiscountRate">
							<xsl:value-of select="LineDiscountRate"/>
						</xsl:element>
						
						<!-- LineDiscountValue-->
						<xsl:element name="LineDiscountValue">
							<xsl:value-of select="LineDiscountValue"/>
						</xsl:element>
						
						<!-- VATCode-->						
						<xsl:element name="VATCode">
							<xsl:value-of select="VATCode"/>
						</xsl:element>						
						
						<!-- VATRate-->						
						<xsl:element name="VATRate">
							<xsl:value-of select="VATRate"/>
						</xsl:element>						
							
						<!-- Measure-->
						<xsl:element name="Measure">
							<xsl:element name="UnitsInPack">
								<xsl:value-of select="Measure/UnitsInPack"/>
							</xsl:element>
							<xsl:element name="OrderingMeasure">
								<xsl:value-of select="Measure/OrderingMeasure"/>
							</xsl:element>
							<xsl:element name="MeasureIndicator">
								<xsl:value-of select="Measure/MeasureIndicator"/>
							</xsl:element>
							<xsl:element name="TotalMeasure">
								<xsl:value-of select="Measure/TotalMeasure"/>
							</xsl:element>
							<xsl:element name="TotalMeasureIndicator">
								<xsl:value-of select="Measure/TotalMeasureIndicator"/>
							</xsl:element>
						</xsl:element>
						
						<!-- LineExtraData-->
						<xsl:element name="LineExtraData">
							<xsl:element name="SuppliersOriginalVATCode">
								<xsl:value-of select="LineExtraData/SuppliersOriginalVATCode"/>
							</xsl:element>
							
							<xsl:element name="AccountCode">
								<xsl:value-of select="LineExtraData/AccountCode"/>
							</xsl:element>
							
							<xsl:element name="IsStockProduct">
								<xsl:value-of select="LineExtraData/IsStockProduct"/>
							</xsl:element>								
							
							<xsl:element name="CataloguePrice">
								<xsl:value-of select="LineExtraData/CataloguePrice"/>
							</xsl:element>								
														
							<xsl:element name="CataloguePackSize">
								<xsl:value-of select="LineExtraData/CataloguePackSize"/>
							</xsl:element>																								
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
			
			<!-- InvoiceTrailer -->
			<xsl:element name="InvoiceTrailer">
				<xsl:element name="NumberOfLines">
					<xsl:value-of select="InvoiceTrailer/NumberOfLines"/>
				</xsl:element>
				<xsl:element name="NumberOfItems">
					<xsl:value-of select="InvoiceTrailer/NumberOfItems"/>
				</xsl:element>
				<xsl:element name="NumberOfDeliveries">
					<xsl:value-of select="InvoiceTrailer/NumberOfDeliveries"/>
				</xsl:element>
				<xsl:element name="DocumentDiscountRate">
					<xsl:value-of select="InvoiceTrailer/DocumentDiscountRate"/>
				</xsl:element>
				<xsl:element name="SettlementDiscountRate">
					<xsl:attribute name="SettlementDiscountDays">
						<xsl:value-of select="InvoiceTrailer/SettlementDiscountRate/@SettlementDiscountDays"/>
					</xsl:attribute>
					<xsl:value-of select="InvoiceTrailer/SettlementDiscountRate"/>
				</xsl:element>	
				<!-- VATSubTotals -->
				<xsl:element name="VATSubTotals">
					<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
						<xsl:element name="VATSubTotal">
							<xsl:attribute name="VATCode">
								<xsl:value-of select="@VATCode"/>
							</xsl:attribute>
							<xsl:attribute name="VATRate">
								<xsl:value-of select="@VATRate"/>
							</xsl:attribute>
							<xsl:element name="NumberOfLinesAtRate">
								<xsl:value-of select="NumberOfLinesAtRate"/>
							</xsl:element>
							<xsl:element name="NumberOfItemsAtRate">
								<xsl:value-of select="NumberOfItemsAtRate"/>
							</xsl:element>
							<xsl:element name="DiscountedLinesTotalExclVATAtRate">
								<xsl:value-of select="DiscountedLinesTotalExclVATAtRate"/>
							</xsl:element>
							<xsl:element name="DocumentDiscountAtRate">
								<xsl:value-of select="DocumentDiscountAtRate"/>
							</xsl:element>
							<xsl:element name="DocumentTotalExclVATAtRate">
								<xsl:value-of select="DocumentTotalExclVATAtRate"/>
							</xsl:element>
							<xsl:element name="SettlementDiscountAtRate">
								<xsl:value-of select="SettlementDiscountAtRate"/>
							</xsl:element>
							<xsl:element name="SettlementTotalExclVATAtRate">
								<xsl:value-of select="SettlementTotalExclVATAtRate"/>
							</xsl:element>
							<xsl:element name="VATAmountAtRate">
								<xsl:value-of select="VATAmountAtRate"/>
							</xsl:element>
							<xsl:element name="DocumentTotalInclVATAtRate">
								<xsl:value-of select="DocumentTotalInclVATAtRate"/>
							</xsl:element>
							<xsl:element name="SettlementTotalInclVATAtRate">
								<xsl:value-of select="SettlementTotalInclVATAtRate"/>
							</xsl:element>
							<xsl:element name="VATTrailerExtraData">
								<xsl:element name="SuppliersOriginalVATCode">
									<xsl:value-of select="VATTrailerExtraData/SuppliersOriginalVATCode"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
				<xsl:element name="DiscountedLinesTotalExclVAT">
					<xsl:value-of select="InvoiceTrailer/DiscountedLinesTotalExclVAT"/>
				</xsl:element>
				<xsl:element name="DocumentDiscount">
					<xsl:value-of select="InvoiceTrailer/DocumentDiscount"/>
				</xsl:element>
				<xsl:element name="DocumentTotalExclVAT">
					<xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/>
				</xsl:element>
				<xsl:element name="SettlementDiscount">
					<xsl:value-of select="InvoiceTrailer/SettlementDiscount"/>
				</xsl:element>
				<xsl:element name="SettlementTotalExclVAT">
					<xsl:value-of select="InvoiceTrailer/SettlementTotalExclVAT"/>
				</xsl:element>
				<xsl:element name="VATAmount">
					<xsl:value-of select="InvoiceTrailer/VATAmount"/>
				</xsl:element>
				<xsl:element name="DocumentTotalInclVAT">
					<xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
				</xsl:element>
				<xsl:element name="SettlementTotalInclVAT">
					<xsl:value-of select="InvoiceTrailer/SettlementTotalInclVAT"/>
				</xsl:element>
								
			</xsl:element>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>
