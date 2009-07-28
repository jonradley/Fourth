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
                    |                   |                                                                               
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="Invoice">
		<xsl:element name="Invoice">
			<xsl:element name="TradeSimpleHeader">				
				<xsl:element name="SendersCodeForRecipient">
					<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				</xsl:element>				
				<xsl:if test="TradeSimpleHeader/SendersName">
					<xsl:element name="SendersName">
						<xsl:value-of select="TradeSimpleHeader/SendersName"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="TradeSimpleHeader/SendersAddress">
					<xsl:element name="SendersAddress">						
						<xsl:element name="AddressLine1">
							<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine1"/>
						</xsl:element>							
						<xsl:if test="TradeSimpleHeader/SendersAddress/AddressLine2">
							<xsl:element name="AddressLine2">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine2"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/SendersAddress/AddressLine3">
							<xsl:element name="AddressLine3">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine3"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/SendersAddress/AddressLine4">
							<xsl:element name="AddressLine4">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine4"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/SendersAddress/PostCode">
							<xsl:element name="PostCode">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/PostCode"/>
							</xsl:element>
						</xsl:if>						
					</xsl:element>
				</xsl:if>	
				<xsl:if test="TradeSimpleHeader/RecipientsCodeForSender">
					<xsl:element name="RecipientsCodeForSender">
						<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
					</xsl:element>
				</xsl:if>
				
				<!-- RecipientsBranchReference -->
				<xsl:if test="TradeSimpleHeader/RecipientsBranchReference">
					<xsl:element name="RecipientsBranchReference">
						<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
					</xsl:element>
				</xsl:if>
				
				<!-- RecipientsName -->
				<xsl:if test="TradeSimpleHeader/RecipientsName">
					<xsl:element name="RecipientsName">
						<xsl:value-of select="TradeSimpleHeader/RecipientsName"/>
					</xsl:element>
				</xsl:if>
				
				<!-- RecipientsAddress -->	
				<xsl:if test="TradeSimpleHeader/RecipientsAddress">
					<xsl:element name="RecipientsAddress">						
						<xsl:element name="AddressLine1">
							<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine1"/>
						</xsl:element>							
						<xsl:if test="TradeSimpleHeader/RecipientsAddress/AddressLine2">
							<xsl:element name="AddressLine2">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine2"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/RecipientsAddress/AddressLine3">
							<xsl:element name="AddressLine3">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine3"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/RecipientsAddress/AddressLine4">
							<xsl:element name="AddressLine4">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine4"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/RecipientsAddress/PostCode">
							<xsl:element name="PostCode">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/PostCode"/>
							</xsl:element>
						</xsl:if>						
					</xsl:element>
				</xsl:if>	
				
				<!-- TestFlag -->				
				<xsl:element name="TestFlag">
					<xsl:value-of select="TradeSimpleHeader/TestFlag"/>
				</xsl:element>								
			</xsl:element>
			
			<!-- InvoiceHeader -->
			<xsl:element name="InvoiceHeader">
				<xsl:if test="InvoiceHeader/MHDSegment">
					<xsl:element name="MHDSegment">						
						<xsl:element name="MHDHeader">
							<xsl:value-of select="InvoiceHeader/MHDSegment/MHDHeader"/>
						</xsl:element>						
						<xsl:element name="MHDVersion">
							<xsl:value-of select="InvoiceHeader/MHDSegment/MHDVersion"/>
						</xsl:element>											
					</xsl:element>
				</xsl:if>	
				
				<!-- 	Document Status -->		
				<xsl:element name="DocumentStatus">
					<xsl:value-of select="InvoiceHeader/DocumentStatus"/>
				</xsl:element>
				
				<!-- BatchInformation -->				
				<xsl:if test="InvoiceHeader/BatchInformation">
					<xsl:element name="BatchInformation">
						<xsl:if test="InvoiceHeader/BatchInformation/FileGenerationNo">
							<xsl:element name="FileGenerationNo">
								<xsl:value-of select="InvoiceHeader/BatchInformation/FileGenerationNo"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="InvoiceHeader/BatchInformation/FileVersionNo">
							<xsl:element name="FileVersionNo">
								<xsl:value-of select="InvoiceHeader/BatchInformation/FileVersionNo"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="InvoiceHeader/BatchInformation/FileCreationDate">
							<xsl:element name="FileCreationDate">
								<xsl:value-of select="InvoiceHeader/BatchInformation/FileCreationDate"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="InvoiceHeader/BatchInformation/SendersTransmissionReference">
							<xsl:element name="SendersTransmissionReference">
								<xsl:value-of select="InvoiceHeader/BatchInformation/SendersTransmissionReference"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="InvoiceHeader/BatchInformation/SendersTransmissionDate">
							<xsl:element name="SendersTransmissionDate">
								<xsl:value-of select="InvoiceHeader/BatchInformation/SendersTransmissionDate"/>
							</xsl:element>
						</xsl:if>					
					</xsl:element>
				</xsl:if>	
				
				<!-- Buyer -->				
				<xsl:element name="Buyer">					
					<xsl:element name="BuyersLocationID">						
						<xsl:element name="GLN">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
						</xsl:element>						
						<xsl:if test="InvoiceHeader/Buyer/BuyersLocationID/BuyersCode">
							<xsl:element name="BuyersCode">
								<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode">
							<xsl:element name="SuppliersCode">
								<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
												
					<!-- BuyersName -->
					<xsl:if test="InvoiceHeader/Buyer/BuyersName">
						<xsl:element name="BuyersName">
							<xsl:value-of select="InvoiceHeader/Buyer/BuyersName"/>
						</xsl:element>
					</xsl:if>	
					
					<!-- BuyersAddress-->
					<xsl:if test="InvoiceHeader/Buyer/BuyersAddress">
						<xsl:element name="BuyersAddress">							
							<xsl:element name="AddressLine1">
								<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/>
							</xsl:element>							
							<xsl:if test="InvoiceHeader/Buyer/BuyersAddress/AddressLine2">
								<xsl:element name="AddressLine2">
									<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="InvoiceHeader/Buyer/BuyersAddress/AddressLine3">
								<xsl:element name="AddressLine3">
									<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="InvoiceHeader/Buyer/BuyersAddress/AddressLine4">
								<xsl:element name="AddressLine4">
									<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="InvoiceHeader/Buyer/BuyersAddress/PostCode">
								<xsl:element name="PostCode">
									<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/PostCode"/>
								</xsl:element>
							</xsl:if>						
						</xsl:element>
					</xsl:if>									
				</xsl:element>
				
				<!-- Supplier -->				
				<xsl:element name="Supplier">					
					<xsl:element name="SuppliersLocationID">						
						<xsl:element name="GLN">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/GLN"/>
						</xsl:element>						
						<xsl:if test="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode">
							<xsl:element name="BuyersCode">
								<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode">
							<xsl:element name="SuppliersCode">
								<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>						
					<!-- SuppliersName -->
					<xsl:if test="InvoiceHeader/Supplier/SuppliersName">
						<xsl:element name="SuppliersName">
							<xsl:value-of select="InvoiceHeader/Supplier/SuppliersName"/>
						</xsl:element>
					</xsl:if>	
					<!-- SuppliersAddress -->
					<xsl:if test="InvoiceHeader/Supplier/SuppliersAddress">
						<xsl:element name="SuppliersAddress">							
							<xsl:element name="AddressLine1">
								<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/>
							</xsl:element>								
							<xsl:if test="InvoiceHeader/Supplier/SuppliersAddress/AddressLine2">
								<xsl:element name="AddressLine2">
									<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="InvoiceHeader/Supplier/SuppliersAddress/AddressLine3">
								<xsl:element name="AddressLine3">
									<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="InvoiceHeader/Supplier/SuppliersAddress/AddressLine4">
								<xsl:element name="AddressLine4">
									<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine4"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="InvoiceHeader/Supplier/SuppliersAddress/PostCode">
								<xsl:element name="PostCode">
									<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/PostCode"/>
								</xsl:element>
							</xsl:if>						
						</xsl:element>
					</xsl:if>									
				</xsl:element>
				
				<!-- ShipTo -->				
				<xsl:element name="ShipTo">					
					<xsl:element name="ShipToLocationID">						
						<xsl:element name="GLN">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
						</xsl:element>						
						<xsl:if test="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode">
							<xsl:element name="BuyersCode">
								<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode">
							<xsl:element name="SuppliersCode">
								<xsl:attribute name="ValidationResult">
								    <xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode/@ValidationResult"/>
								</xsl:attribute>
								<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>							
						
					<xsl:if test="InvoiceHeader/ShipTo/ShipToName">
						<xsl:element name="ShipToName">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/>
						</xsl:element>
					</xsl:if>						
					
					<xsl:element name="ShipToAddress">						
						<xsl:element name="AddressLine1">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/>
						</xsl:element>						
						<xsl:if test="InvoiceHeader/ShipTo/ShipToAddress/AddressLine2">
							<xsl:element name="AddressLine2">
								<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="InvoiceHeader/ShipTo/ShipToAddress/AddressLine3">
							<xsl:element name="AddressLine3">
								<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="InvoiceHeader/ShipTo/ShipToAddress/AddressLine4">
							<xsl:element name="AddressLine4">
								<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="InvoiceHeader/ShipTo/ShipToAddress/PostCode">
							<xsl:element name="PostCode">
								<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/PostCode"/>
							</xsl:element>
						</xsl:if>						
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
					
					<xsl:if test="InvoiceHeader/InvoiceReferences/TaxPointDate">
						<xsl:element name="TaxPointDate">
							<xsl:value-of select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
						</xsl:element>
					</xsl:if>	
					<xsl:if test="InvoiceHeader/InvoiceReferences/VATRegNo">
						<xsl:element name="VATRegNo">
							<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/>
						</xsl:element>
					</xsl:if>											
				</xsl:element>
				
				<!-- Currency -->
				<xsl:if test="InvoiceHeader/Currency">
					<xsl:element name="Currency">
						<xsl:value-of select="InvoiceHeader/Currency"/>
					</xsl:element>
				</xsl:if>	
				
				<!-- SequenceNumber-->
				<xsl:if test="InvoiceHeader/SequenceNumber">
					<xsl:element name="SequenceNumber">
						<xsl:value-of select="InvoiceHeader/SequenceNumber"/>
					</xsl:element>
				</xsl:if>
				
				<!-- Header ExtraData-->
				<xsl:if test="InvoiceHeader/HeaderExtraData">
					<xsl:element name="HeaderExtraData">
						<xsl:if test="InvoiceHeader/HeaderExtraData/IgnoreInvalidLineValues">
							<xsl:element name="IgnoreInvalidLineValues">
								<xsl:value-of select="InvoiceHeader/HeaderExtraData/IgnoreInvalidLineValues"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="InvoiceHeader/HeaderExtraData/CostCentreCode">
							<xsl:element name="CostCentreCode">
								<xsl:value-of select="InvoiceHeader/HeaderExtraData/CostCentreCode"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="InvoiceHeader/HeaderExtraData/STXSupplierCode">
							<xsl:element name="STXSupplierCode">
								<xsl:value-of select="InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
							</xsl:element>
						</xsl:if>																	
					</xsl:element>
				</xsl:if>				
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
						<xsl:if test="PurchaseOrderReferences">
							<xsl:element name="PurchaseOrderReferences">								
								<xsl:element name="PurchaseOrderReference">
									<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
								</xsl:element>								
								<xsl:element name="PurchaseOrderDate">
									<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
								</xsl:element>																										
							</xsl:element>
						</xsl:if>	
						
						<!-- DeliveryNoteReferences-->
						<xsl:if test="DeliveryNoteReferences">
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
						</xsl:if>	
						
						<!-- ProductID-->						
						<xsl:element name="ProductID">							
							<xsl:element name="GTIN">
								<xsl:value-of select="ProductID/GTIN"/>
							</xsl:element>							
							<xsl:if test="ProductID/SuppliersProductCode">
								<xsl:element name="SuppliersProductCode">
									<xsl:attribute name="ValidationResult">
										<xsl:value-of select="ProductID/SuppliersProductCode/@ValidationResult"/>
									</xsl:attribute>
									<xsl:value-of select="ProductID/SuppliersProductCode"/>
								</xsl:element>
							</xsl:if>																												
						</xsl:element>							
						
						<!-- ProductDescription -->						
						<xsl:element name="ProductDescription">
							<xsl:value-of select="ProductDescription"/>
						</xsl:element>							
						
						<!-- InvoicedQuantity-->						
						<xsl:element name="InvoicedQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="InvoicedQuantity"/>																			
						</xsl:element>						

						<!-- PackSize -->
						<xsl:if test="PackSize != ''">						
							<xsl:element name="PackSize">
								<xsl:value-of select="PackSize"/>
							</xsl:element>	
						</xsl:if>
						
						<!-- UnitValueExclVAT-->						
						<xsl:element name="UnitValueExclVAT">
							<xsl:value-of select="UnitValueExclVAT"/>
						</xsl:element>						
						
						<!-- LineValueExclVAT-->						
						<xsl:element name="LineValueExclVAT">
							<xsl:value-of select="LineValueExclVAT"/>
						</xsl:element>						
						
						<!-- LineDiscountRate-->
						<xsl:if test="LineDiscountRate">
							<xsl:element name="LineDiscountRate">
								<xsl:value-of select="LineDiscountRate"/>
							</xsl:element>
						</xsl:if>
						
						<!-- LineDiscountValue-->
						<xsl:if test="LineDiscountValue">
							<xsl:element name="LineDiscountValue">
								<xsl:value-of select="LineDiscountValue"/>
							</xsl:element>
						</xsl:if>
						
						<!-- VATCode-->						
						<xsl:element name="VATCode">
							<xsl:value-of select="VATCode"/>
						</xsl:element>						
						
						<!-- VATRate-->						
						<xsl:element name="VATRate">
							<xsl:value-of select="VATRate"/>
						</xsl:element>						
						
						<!-- Measure-->
						<xsl:if test="Measure">
							<xsl:element name="Measure">
								<xsl:if test="Measure/UnitsInPack">
									<xsl:element name="UnitsInPack">
										<xsl:value-of select="Measure/UnitsInPack"/>
									</xsl:element>
								</xsl:if>	
								<xsl:if test="Measure/TotalMeasure">
									<xsl:element name="TotalMeasure">
										<xsl:value-of select="Measure/TotalMeasure"/>
									</xsl:element>
								</xsl:if>	
								<xsl:if test="Measure/TotalMeasureIndicator">
									<xsl:element name="TotalMeasureIndicator">
										<xsl:value-of select="Measure/TotalMeasureIndicator"/>
									</xsl:element>
								</xsl:if>																								
							</xsl:element>
						</xsl:if>
						
						<!-- LineExtraData-->
						<xsl:if test="LineExtraData">
							<xsl:element name="LineExtraData">
								<xsl:if test="LineExtraData/SuppliersOriginalVATCode">
									<xsl:element name="SuppliersOriginalVATCode">
										<xsl:value-of select="LineExtraData/SuppliersOriginalVATCode"/>
									</xsl:element>
								</xsl:if>	

								<xsl:if test="LineExtraData/AccountCode">
									<xsl:element name="AccountCode">
										<xsl:value-of select="LineExtraData/AccountCode"/>
									</xsl:element>
								</xsl:if>
																
								<xsl:if test="LineExtraData/IsStockProduct">
									<xsl:element name="IsStockProduct">
										<xsl:value-of select="LineExtraData/IsStockProduct"/>
									</xsl:element>
								</xsl:if>	
								
								<xsl:if test="LineExtraData/CataloguePrice">
									<xsl:element name="CataloguePrice">
										<xsl:value-of select="LineExtraData/CataloguePrice"/>
									</xsl:element>
								</xsl:if>	
								
								<xsl:if test="LineExtraData/CataloguePackSize">
									<xsl:element name="CataloguePackSize">
										<xsl:value-of select="LineExtraData/CataloguePackSize"/>
									</xsl:element>
								</xsl:if>	
																																
							</xsl:element>
						</xsl:if>	

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
							<xsl:if test="VATTrailerExtraData">
								<xsl:element name="VATTrailerExtraData">
									<xsl:if test="VATTrailerExtraData/SuppliersOriginalVATCode">
										<xsl:element name="SuppliersOriginalVATCode">
											<xsl:value-of select="VATTrailerExtraData/SuppliersOriginalVATCode"/>
										</xsl:element>
									</xsl:if>	
								</xsl:element>
							</xsl:if>					
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
