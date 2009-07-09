<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Takes the internal version of a Credit Note and map it directly into the same format.
 
 © Alternative Business Solutions Ltd., 2000.
******************************************************************************************
 Module History
******************************************************************************************
 Version     | 
******************************************************************************************
 Date            | Name                       | Description of modification
******************************************************************************************
08/07/2009  | Rave Tech			| FB2989 Created stylesheet
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    |                   |                                                                               
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="CreditNote">
		<xsl:element name="CreditNote">
		<!-- TradeSimpleHeader -->
			<xsl:element name="TradeSimpleHeader">
			
				<!-- SendersCodeForRecipient -->				
				<xsl:element name="SendersCodeForRecipient">
					<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				</xsl:element>
				
				<!-- Senders Name -->				
				<xsl:if test="TradeSimpleHeader/SendersName">
					<xsl:element name="SendersName">
						<xsl:value-of select="TradeSimpleHeader/SendersName"/>
					</xsl:element>
				</xsl:if>
				
				<!-- Senders Address -->
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
				
				<!-- RecipientsCodeForSender -->
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
			
			<!-- CreditNoteHeader -->
			<xsl:element name="CreditNoteHeader">
				<xsl:if test="CreditNoteHeader/MHDSegment">
					<xsl:element name="MHDSegment">						
						<xsl:element name="MHDHeader">
							<xsl:value-of select="CreditNoteHeader/MHDSegment/MHDHeader"/>
						</xsl:element>						
						<xsl:element name="MHDVersion">
							<xsl:value-of select="CreditNoteHeader/MHDSegment/MHDVersion"/>
						</xsl:element>												
					</xsl:element>
				</xsl:if>
					
				<!-- 	Document Status -->		
				<xsl:element name="DocumentStatus">
					<xsl:value-of select="CreditNoteHeader/DocumentStatus"/>
				</xsl:element>
				
				<!-- BatchInformation -->				
				<xsl:if test="CreditNoteHeader/BatchInformation">
					<xsl:element name="BatchInformation">
						<xsl:if test="CreditNoteHeader/BatchInformation/FileGenerationNo">
							<xsl:element name="FileGenerationNo">
								<xsl:value-of select="CreditNoteHeader/BatchInformation/FileGenerationNo"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="CreditNoteHeader/BatchInformation/FileVersionNo">
							<xsl:element name="FileVersionNo">
								<xsl:value-of select="CreditNoteHeader/BatchInformation/FileVersionNo"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="CreditNoteHeader/BatchInformation/FileCreationDate">
							<xsl:element name="FileCreationDate">
								<xsl:value-of select="CreditNoteHeader/BatchInformation/FileCreationDate"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="CreditNoteHeader/BatchInformation/SendersTransmissionReference">
							<xsl:element name="SendersTransmissionReference">
								<xsl:value-of select="CreditNoteHeader/BatchInformation/SendersTransmissionReference"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="CreditNoteHeader/BatchInformation/SendersTransmissionDate">
							<xsl:element name="SendersTransmissionDate">
								<xsl:value-of select="CreditNoteHeader/BatchInformation/SendersTransmissionDate"/>
							</xsl:element>
						</xsl:if>					
					</xsl:element>
				</xsl:if>	
				
				<!-- Buyer -->				
				<xsl:element name="Buyer">					
					<xsl:element name="BuyersLocationID">						
						<xsl:element name="GLN">
							<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
						</xsl:element>						
						<xsl:if test="CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode">
							<xsl:element name="BuyersCode">
								<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode">
							<xsl:element name="SuppliersCode">
								<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>							
						
					<xsl:if test="CreditNoteHeader/Buyer/BuyersName">
						<xsl:element name="BuyersName">
							<xsl:value-of select="CreditNoteHeader/Buyer/BuyersName"/>
						</xsl:element>
					</xsl:if>	
					
					<xsl:if test="CreditNoteHeader/Buyer/BuyersAddress">
						<xsl:element name="BuyersAddress">							
							<xsl:element name="AddressLine1">
								<xsl:value-of select="CreditNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
							</xsl:element>							
							<xsl:if test="CreditNoteHeader/Buyer/BuyersAddress/AddressLine2">
								<xsl:element name="AddressLine2">
									<xsl:value-of select="CreditNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="CreditNoteHeader/Buyer/BuyersAddress/AddressLine3">
								<xsl:element name="AddressLine3">
									<xsl:value-of select="CreditNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="CreditNoteHeader/Buyer/BuyersAddress/AddressLine4">
								<xsl:element name="AddressLine4">
									<xsl:value-of select="CreditNoteHeader/Buyer/BuyersAddress/AddressLine4"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="CreditNoteHeader/Buyer/BuyersAddress/PostCode">
								<xsl:element name="PostCode">
									<xsl:value-of select="CreditNoteHeader/Buyer/BuyersAddress/PostCode"/>
								</xsl:element>
							</xsl:if>						
						</xsl:element>
					</xsl:if>									
				</xsl:element>
				
				<!-- Supplier -->				
				<xsl:element name="Supplier">					
					<xsl:element name="SuppliersLocationID">						
						<xsl:element name="GLN">
							<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
						</xsl:element>						
						<xsl:if test="CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode">
							<xsl:element name="BuyersCode">
								<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
							<xsl:element name="SuppliersCode">
								<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>							
						
					<xsl:if test="CreditNoteHeader/Supplier/SuppliersName">
						<xsl:element name="SuppliersName">
							<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersName"/>
						</xsl:element>
					</xsl:if>	
					<xsl:if test="CreditNoteHeader/Supplier/SuppliersAddress">
						<xsl:element name="SuppliersAddress">							
							<xsl:element name="AddressLine1">
								<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
							</xsl:element>								
							<xsl:if test="CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2">
								<xsl:element name="AddressLine2">
									<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3">
								<xsl:element name="AddressLine3">
									<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4">
								<xsl:element name="AddressLine4">
									<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="CreditNoteHeader/Supplier/SuppliersAddress/PostCode">
								<xsl:element name="PostCode">
									<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersAddress/PostCode"/>
								</xsl:element>
							</xsl:if>						
						</xsl:element>
					</xsl:if>									
				</xsl:element>
				
				<!-- ShipTo -->				
				<xsl:element name="ShipTo">					
					<xsl:element name="ShipToLocationID">
						<!-- GLN -->						
						<xsl:element name="GLN">
							<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/GLN"/>
						</xsl:element>
						
						<!-- BuyersCode -->					
						<xsl:if test="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
							<xsl:element name="BuyersCode">
								<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
							</xsl:element>
						</xsl:if>
						
						<!-- SuppliersCode -->
						<xsl:if test="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
							<xsl:element name="SuppliersCode">
								<xsl:attribute name="ValidationResult">
								    <xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode/@ValidationResult"/>
								</xsl:attribute>
								<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>	
											
					<!-- ShipToName -->
					<xsl:if test="CreditNoteHeader/ShipTo/ShipToName">
						<xsl:element name="ShipToName">
							<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToName"/>
						</xsl:element>
					</xsl:if>
											
					<!-- ShipToAddress-->
					<xsl:element name="ShipToAddress">						
						<xsl:element name="AddressLine1">
							<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
						</xsl:element>						
						<xsl:if test="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2">
							<xsl:element name="AddressLine2">
								<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3">
							<xsl:element name="AddressLine3">
								<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4">
							<xsl:element name="AddressLine4">
								<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="CreditNoteHeader/ShipTo/ShipToAddress/PostCode">
							<xsl:element name="PostCode">
								<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/PostCode"/>
							</xsl:element>
						</xsl:if>						
					</xsl:element>													
				</xsl:element>
				
				<!--InvoiceReferences-->
				<xsl:if test="CreditNoteHeader/InvoiceReferences">				
					<xsl:element name="InvoiceReferences">					
						<xsl:element name="InvoiceReference">
							<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
						</xsl:element>
						
						<!-- InvoiceDate-->										
						<xsl:element name="InvoiceDate">
							<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
						</xsl:element>
						
						<!-- TaxPointDate-->	
						<xsl:if test="CreditNoteHeader/InvoiceReferences/TaxPointDate">				
							<xsl:element name="TaxPointDate">
								<xsl:value-of select="CreditNoteHeader/InvoiceReferences/TaxPointDate"/>
							</xsl:element>
						</xsl:if>	
												
						<!-- VATRegNo-->
						<xsl:if test="CreditNoteHeader/InvoiceReferences/VATRegNo">					
							<xsl:element name="VATRegNo">
								<xsl:value-of select="CreditNoteHeader/InvoiceReferences/VATRegNo"/>
							</xsl:element>
						</xsl:if>																
					</xsl:element>
				</xsl:if>
							
				<!-- CreditNote References-->				
				<xsl:element name="CreditNoteReferences">					
					<xsl:element name="CreditNoteReference">
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
					</xsl:element>
					
					<!-- CreditNoteDate -->										
					<xsl:element name="CreditNoteDate">
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
					</xsl:element>
					
					<!-- TaxPointDate-->					
					<xsl:element name="TaxPointDate">
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/TaxPointDate"/>
					</xsl:element>					
					
					<!-- VATRegNo-->					
					<xsl:element name="VATRegNo">
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/VATRegNo"/>
					</xsl:element>																
				</xsl:element>
				
				<!-- Currency -->
				<xsl:if test="CreditNoteHeader/Currency">
					<xsl:element name="Currency">
						<xsl:value-of select="CreditNoteHeader/Currency"/>
					</xsl:element>
				</xsl:if>	
				
				<!-- SequenceNumber-->
				<xsl:if test="CreditNoteHeader/SequenceNumber">
					<xsl:element name="SequenceNumber">
						<xsl:value-of select="CreditNoteHeader/SequenceNumber"/>
					</xsl:element>
				</xsl:if>
				
				<!-- Header ExtraData-->
				<xsl:if test="CreditNoteHeader/HeaderExtraData">
					<xsl:element name="HeaderExtraData">
						<xsl:if test="CreditNoteHeader/HeaderExtraData/IgnoreInvalidLineValues">
							<xsl:element name="IgnoreInvalidLineValues">
								<xsl:value-of select="CreditNoteHeader/HeaderExtraData/IgnoreInvalidLineValues"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="CreditNoteHeader/HeaderExtraData/CostCentreCode">
							<xsl:element name="CostCentreCode">
								<xsl:value-of select="CreditNoteHeader/HeaderExtraData/CostCentreCode"/>
							</xsl:element>
						</xsl:if>	
						<xsl:if test="CreditNoteHeader/HeaderExtraData/STXSupplierCode">
							<xsl:element name="STXSupplierCode">
								<xsl:value-of select="CreditNoteHeader/HeaderExtraData/STXSupplierCode"/>
							</xsl:element>
						</xsl:if>																	
					</xsl:element>
				</xsl:if>				
			</xsl:element>
			
			<!-- CreditNote  Details-->
			<xsl:element name="CreditNoteDetail">
				<xsl:for-each select="CreditNoteDetail/CreditNoteLine">
					<xsl:element name="CreditNoteLine">
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
								<xsl:if test="PurchaseOrderReferences/PurchaseOrderTime">
									<xsl:element name="PurchaseOrderTime">
										<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderTime"/>
									</xsl:element>
								</xsl:if>																									
							</xsl:element>
						</xsl:if>	
						
						<!-- PurchaseOrderConfirmationReferences-->
						<xsl:if test="PurchaseOrderConfirmationReferences">
							<xsl:element name="PurchaseOrderConfirmationReferences">								
								<xsl:element name="PurchaseOrderConfirmationReference">
									<xsl:value-of select="PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
								</xsl:element>								
								<xsl:element name="PurchaseOrderConfirmationDate">
									<xsl:value-of select="PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
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
						
						<!-- OrderedQuantity-->
						<xsl:if test="OrderedQuantity">						
							<xsl:element name="OrderedQuantity">								
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
								</xsl:attribute>
								<xsl:value-of select="OrderedQuantity"/>																			
							</xsl:element>
						</xsl:if>						
						
						<!-- CreditNotedQuantity-->						
						<xsl:element name="CreditedQuantity">								
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="CreditedQuantity"/>																			
						</xsl:element>
						
						<!-- PackSize-->
						<xsl:if test="PackSize">
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
			
			<!-- CreditNoteTrailer -->
			<xsl:element name="CreditNoteTrailer">
				<xsl:element name="NumberOfLines">
					<xsl:value-of select="CreditNoteTrailer/NumberOfLines"/>
				</xsl:element>
				<xsl:element name="NumberOfItems">
					<xsl:value-of select="CreditNoteTrailer/NumberOfItems"/>
				</xsl:element>
				<xsl:element name="NumberOfDeliveries">
					<xsl:value-of select="CreditNoteTrailer/NumberOfDeliveries"/>
				</xsl:element>
				<xsl:element name="DocumentDiscountRate">
					<xsl:value-of select="CreditNoteTrailer/DocumentDiscountRate"/>
				</xsl:element>
				<xsl:element name="SettlementDiscountRate">
					<xsl:value-of select="CreditNoteTrailer/SettlementDiscountRate"/>
				</xsl:element>	
				<!-- VATSubTotals -->
				<xsl:element name="VATSubTotals">
					<xsl:for-each select="CreditNoteTrailer/VATSubTotals/VATSubTotal">
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
					<xsl:value-of select="CreditNoteTrailer/DiscountedLinesTotalExclVAT"/>
				</xsl:element>
				<xsl:element name="DocumentDiscount">
					<xsl:value-of select="CreditNoteTrailer/DocumentDiscount"/>
				</xsl:element>
				<xsl:element name="DocumentTotalExclVAT">
					<xsl:value-of select="CreditNoteTrailer/DocumentTotalExclVAT"/>
				</xsl:element>
				<xsl:element name="SettlementDiscount">
					<xsl:value-of select="CreditNoteTrailer/SettlementDiscount"/>
				</xsl:element>
				<xsl:element name="SettlementTotalExclVAT">
					<xsl:value-of select="CreditNoteTrailer/SettlementTotalExclVAT"/>
				</xsl:element>
				<xsl:element name="VATAmount">
					<xsl:value-of select="CreditNoteTrailer/VATAmount"/>
				</xsl:element>
				<xsl:element name="DocumentTotalInclVAT">
					<xsl:value-of select="CreditNoteTrailer/DocumentTotalInclVAT"/>
				</xsl:element>
				<xsl:element name="SettlementTotalInclVAT">
					<xsl:value-of select="CreditNoteTrailer/SettlementTotalInclVAT"/>
				</xsl:element>
								
			</xsl:element>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>
