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
08/10/2009  | Steve Hewitt		| FB3169 Format numbers and the test flag consistently
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
05/04/2012  | Sandeep Sehgal	| FB5348 Translate accented characters 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
10/03/2017  | Warith Nassor	| FB11638 Adding AWRS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    |                   |                                                                               
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="xml" encoding="UTF-8"/>
<xsl:include href="HospitalityInclude.xsl"/>
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
					<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/SendersName"/></xsl:call-template>
				</xsl:element>
				<xsl:element name="SendersAddress">						
					<xsl:element name="AddressLine1">
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/SendersAddress/AddressLine1"/></xsl:call-template>
					</xsl:element>							
					<xsl:element name="AddressLine2">
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/SendersAddress/AddressLine2"/></xsl:call-template>
					</xsl:element>
					<xsl:element name="AddressLine3">
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/SendersAddress/AddressLine3"/></xsl:call-template>
					</xsl:element>
					<xsl:element name="AddressLine4">
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/SendersAddress/AddressLine4"/></xsl:call-template>
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
					<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/RecipientsName"/></xsl:call-template>
				</xsl:element>
				<xsl:element name="RecipientsAddress">						
					<xsl:element name="AddressLine1">
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/RecipientsAddress/AddressLine1"/></xsl:call-template>
					</xsl:element>							
					<xsl:element name="AddressLine2">
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/RecipientsAddress/AddressLine2"/></xsl:call-template>
					</xsl:element>
					<xsl:element name="AddressLine3">
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/RecipientsAddress/AddressLine3"/></xsl:call-template>
					</xsl:element>
					<xsl:element name="AddressLine4">
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="TradeSimpleHeader/RecipientsAddress/AddressLine4"/></xsl:call-template>
					</xsl:element>
					<xsl:element name="PostCode">
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/PostCode"/>
					</xsl:element>
				</xsl:element>
				
				<!-- TestFlag must always be true or false. Make sure we convert 1 and 0 -->				
				<xsl:element name="TestFlag">
					<xsl:choose>
						<xsl:when test="TradeSimpleHeader/TestFlag = '1'">
							<xsl:text>true</xsl:text>
						</xsl:when>
						<xsl:when test="TradeSimpleHeader/TestFlag = '0'">
							<xsl:text>false</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="TradeSimpleHeader/TestFlag"/>
						</xsl:otherwise>
					</xsl:choose>
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
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Buyer/BuyersName"/></xsl:call-template>
					</xsl:element>
					
					<!-- BuyersAddress-->
					<xsl:element name="BuyersAddress">							
						<xsl:element name="AddressLine1">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/></xsl:call-template>
						</xsl:element>							
						<xsl:element name="AddressLine2">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/></xsl:call-template>
						</xsl:element>
						<xsl:element name="AddressLine3">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/></xsl:call-template>
						</xsl:element>
						<xsl:element name="AddressLine4">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/></xsl:call-template>
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
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Supplier/SuppliersName"/></xsl:call-template>
					</xsl:element>
					<!-- SuppliersAddress -->
					<xsl:element name="SuppliersAddress">							
						<xsl:element name="AddressLine1">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/></xsl:call-template>
						</xsl:element>								
						<xsl:element name="AddressLine2">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/></xsl:call-template>
						</xsl:element>
						<xsl:element name="AddressLine3">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/></xsl:call-template>
						</xsl:element>
						<xsl:element name="AddressLine4">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine4"/></xsl:call-template>
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
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/ShipTo/ShipToName"/></xsl:call-template>
					</xsl:element>
					
					<xsl:element name="ShipToAddress">						
						<xsl:element name="AddressLine1">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/></xsl:call-template>
						</xsl:element>						
						<xsl:element name="AddressLine2">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/></xsl:call-template>
						</xsl:element>
						<xsl:element name="AddressLine3">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/></xsl:call-template>
						</xsl:element>
						<xsl:element name="AddressLine4">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/></xsl:call-template>
						</xsl:element>
						<xsl:element name="PostCode">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/PostCode"/>
						</xsl:element>
					</xsl:element>

					<xsl:element name="ContactName">
						<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="InvoiceHeader/ShipTo/ContactName"/></xsl:call-template>
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
					<xsl:element name="AlcoholWholesalerRegistrationNumber">
						<xsl:value-of select="InvoiceHeader/HeaderExtraData/AlcoholWholesalerRegistrationNumber"/>
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
								<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="ProductID/SuppliersProductCode"/></xsl:call-template>
							</xsl:element>
							<xsl:element name="BuyersProductCode">
								<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="ProductID/BuyersProductCode"/></xsl:call-template>
							</xsl:element>
						</xsl:element>							
						
						<!-- ProductDescription -->						
						<xsl:element name="ProductDescription">
							<xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="ProductDescription"/></xsl:call-template>
						</xsl:element>							
						
						<!-- Quantities-->	
						<xsl:element name="OrderedQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:if test="OrderedQuantity">
								<xsl:value-of select="format-number(OrderedQuantity,'0.0000')"/>																			
							</xsl:if>
						</xsl:element>
						<xsl:element name="ConfirmedQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:if test="ConfirmedQuantity">
								<xsl:value-of select="format-number(ConfirmedQuantity,'0.0000')"/>
							</xsl:if>
						</xsl:element>	
						<xsl:element name="DeliveredQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:if test="DeliveredQuantity">
								<xsl:value-of select="format-number(DeliveredQuantity,'0.0000')"/>
							</xsl:if>
						</xsl:element>																									
						<xsl:element name="InvoicedQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:if test="InvoicedQuantity">
								<xsl:value-of select="format-number(InvoicedQuantity,'0.0000')"/>
							</xsl:if>
						</xsl:element>						

						<!-- PackSize -->
						<xsl:element name="PackSize">
							<xsl:value-of select="PackSize"/>
						</xsl:element>	
						
						<!-- UnitValueExclVAT-->						
						<xsl:element name="UnitValueExclVAT">			
							<xsl:if test="UnitValueExclVAT">
								<xsl:value-of select="format-number(UnitValueExclVAT, '0.00')"/>
							</xsl:if>				
						</xsl:element>						
						
						<!-- LineValueExclVAT-->						
						<xsl:element name="LineValueExclVAT">
							<xsl:if test="LineValueExclVAT">
								<xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/>
							</xsl:if>				
						</xsl:element>						
						
						<!-- LineDiscountRate-->
						<xsl:element name="LineDiscountRate">
							<xsl:if test="LineDiscountRate">
								<xsl:value-of select="format-number(LineDiscountRate, '0.00')"/>
							</xsl:if>				
						</xsl:element>
						
						<!-- LineDiscountValue-->
						<xsl:element name="LineDiscountValue">
							<xsl:if test="LineDiscountValue">
								<xsl:value-of select="format-number(LineDiscountValue, '0.00')"/>
							</xsl:if>				
						</xsl:element>
						
						<!-- VATCode-->						
						<xsl:element name="VATCode">
							<xsl:value-of select="VATCode"/>
						</xsl:element>						
						
						<!-- VATRate-->						
						<xsl:element name="VATRate">
							<xsl:if test="VATRate">
								<xsl:value-of select="format-number(VATRate, '0.00')"/>
							</xsl:if>		
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
					<xsl:if test="InvoiceTrailer/DocumentDiscountRate">
						<xsl:value-of select="format-number(InvoiceTrailer/DocumentDiscountRate, '0.00')"/>
					</xsl:if>
				</xsl:element>
				<xsl:element name="SettlementDiscountRate">
					<xsl:attribute name="SettlementDiscountDays">
						<xsl:value-of select="InvoiceTrailer/SettlementDiscountRate/@SettlementDiscountDays"/>
					</xsl:attribute>
					<xsl:if test="InvoiceTrailer/SettlementDiscountRate">
						<xsl:value-of select="format-number(InvoiceTrailer/SettlementDiscountRate, '0.00')"/>
					</xsl:if>
				</xsl:element>	
				<!-- VATSubTotals -->
				<xsl:element name="VATSubTotals">
					<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
						<xsl:element name="VATSubTotal">
							<xsl:attribute name="VATCode">
								<xsl:value-of select="@VATCode"/>
							</xsl:attribute>
							<xsl:attribute name="VATRate">
								<xsl:if test="@VATRate">
									<xsl:value-of select="@VATRate"/>
								</xsl:if>
							</xsl:attribute>
							<xsl:element name="NumberOfLinesAtRate">
								<xsl:value-of select="NumberOfLinesAtRate"/>
							</xsl:element>
							<xsl:element name="NumberOfItemsAtRate">
								<xsl:value-of select="NumberOfItemsAtRate"/>
							</xsl:element>
							<xsl:element name="DiscountedLinesTotalExclVATAtRate">
								<xsl:if test="DiscountedLinesTotalExclVATAtRate">
									<xsl:value-of select="format-number(DiscountedLinesTotalExclVATAtRate, '0.00')"/>
								</xsl:if>
							</xsl:element>
							<xsl:element name="DocumentDiscountAtRate">
								<xsl:if test="DocumentDiscountAtRate">
									<xsl:value-of select="format-number(DocumentDiscountAtRate, '0.00')"/>
								</xsl:if>							
							</xsl:element>
							<xsl:element name="DocumentTotalExclVATAtRate">
								<xsl:if test="DocumentTotalExclVATAtRate">
									<xsl:value-of select="format-number(DocumentTotalExclVATAtRate, '0.00')"/>
								</xsl:if>									
							</xsl:element>
							<xsl:element name="SettlementDiscountAtRate">
								<xsl:if test="SettlementDiscountAtRate">
									<xsl:value-of select="format-number(SettlementDiscountAtRate, '0.00')"/>
								</xsl:if>			
							</xsl:element>
							<xsl:element name="SettlementTotalExclVATAtRate">
								<xsl:if test="SettlementTotalExclVATAtRate">
									<xsl:value-of select="format-number(SettlementTotalExclVATAtRate, '0.00')"/>
								</xsl:if>		
							</xsl:element>
							<xsl:element name="VATAmountAtRate">
								<xsl:if test="VATAmountAtRate">
									<xsl:value-of select="format-number(VATAmountAtRate, '0.00')"/>
								</xsl:if>		
							</xsl:element>
							<xsl:element name="DocumentTotalInclVATAtRate">
								<xsl:if test="DocumentTotalInclVATAtRate">
									<xsl:value-of select="format-number(DocumentTotalInclVATAtRate, '0.00')"/>
								</xsl:if>		
							</xsl:element>
							<xsl:element name="SettlementTotalInclVATAtRate">
								<xsl:if test="SettlementTotalInclVATAtRate">
									<xsl:value-of select="format-number(SettlementTotalInclVATAtRate, '0.00')"/>
								</xsl:if>		
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
					<xsl:if test="InvoiceTrailer/DiscountedLinesTotalExclVAT">
						<xsl:value-of select="format-number(InvoiceTrailer/DiscountedLinesTotalExclVAT, '0.00')"/>
					</xsl:if>		
				</xsl:element>
				<xsl:element name="DocumentDiscount">
					<xsl:if test="InvoiceTrailer/DocumentDiscount">
						<xsl:value-of select="format-number(InvoiceTrailer/DocumentDiscount, '0.00')"/>
					</xsl:if>							
				</xsl:element>
				<xsl:element name="DocumentTotalExclVAT">
					<xsl:if test="InvoiceTrailer/DocumentTotalExclVAT">
						<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalExclVAT, '0.00')"/>
					</xsl:if>		
				</xsl:element>
				<xsl:element name="SettlementDiscount">
					<xsl:if test="InvoiceTrailer/SettlementDiscount">
						<xsl:value-of select="format-number(InvoiceTrailer/SettlementDiscount, '0.00')"/>
					</xsl:if>		
				</xsl:element>
				<xsl:element name="SettlementTotalExclVAT">
					<xsl:if test="InvoiceTrailer/SettlementTotalExclVAT">
						<xsl:value-of select="format-number(InvoiceTrailer/SettlementTotalExclVAT, '0.00')"/>
					</xsl:if>		
				</xsl:element>
				<xsl:element name="VATAmount">
					<xsl:if test="InvoiceTrailer/VATAmount">
						<xsl:value-of select="format-number(InvoiceTrailer/VATAmount, '0.00')"/>
					</xsl:if>		
				</xsl:element>
				<xsl:element name="DocumentTotalInclVAT">
					<xsl:if test="InvoiceTrailer/DocumentTotalInclVAT">
						<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalInclVAT, '0.00')"/>
					</xsl:if>		
				</xsl:element>
				<xsl:element name="SettlementTotalInclVAT">
					<xsl:if test="InvoiceTrailer/SettlementTotalInclVAT">
						<xsl:value-of select="format-number(InvoiceTrailer/SettlementTotalInclVAT, '0.00')"/>
					</xsl:if>		
				</xsl:element>	
			</xsl:element>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>
