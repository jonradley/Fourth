<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
'
' Maps King internal Delivery Notes into the EAN UCC format (OFSCI)
' 
' © Alternative Business Solutions Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name              | Description of modification
'******************************************************************************************
' 05/04/2011  | M Dimant 		 | Created. Based on King outbound EANUCC mapper
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'			  |                         |
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	
	<xsl:template match="/">
		<DespatchAdvice>
		
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			      ACTUAL SHIP DATE
			      ~~~~~~~~~~~~~~~~~~~~~~~ -->
			<ActualShipDate format="YYYY-MM-DDThh:mm:ss:TZD">
				<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DespatchDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</ActualShipDate>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			      ESTIMATED DELIVERY DATE
			      ~~~~~~~~~~~~~~~~~~~~~~~ -->			
			<EstimatedDeliveryDate format="YYYY-MM-DDThh:mm:ss:TZD">
				<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</EstimatedDeliveryDate>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			      DESPATCH ADVICE DOCUMENT DETAILS
			      ~~~~~~~~~~~~~~~~~~~~~~~ -->			
			<DespatchAdviceDocumentDetails>
				<DespatchDocumentDate format="YYYY-MM-DDThh:mm:ss:TZD">
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
					<xsl:text>T00:00:00</xsl:text>
				</DespatchDocumentDate>
			
				<DespatchDocumentNumber scheme="OTHER">
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
				</DespatchDocumentNumber>
			</DespatchAdviceDocumentDetails>			  
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    DESPATCH ITEM
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			      
			<!-- The draft EAN.UCC spec does not allow for repeating DespatchItem nodes but we are assuming this will be corrected for the release version -->
			<xsl:for-each select="/DeliveryNote/DeliveryNoteDetail/DeliveryNoteLine">
				<xsl:sort select="LineNumber"/>
				
				<DespatchItem>
				
					<DespatchedQuantity>
						<xsl:attribute name="unitCode">
							<xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/>
						</xsl:attribute>
						
						<xsl:value-of select="format-number(DespatchedQuantity, '0.000')"/>
					</DespatchedQuantity>

					<RequestedQuantity>
						<xsl:attribute name="unitCode">
							<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
						</xsl:attribute>
						
						<xsl:value-of select="format-number(OrderedQuantity, '0.000')"/>
					</RequestedQuantity>
	
					<xsl:if test="ExpiryDate">
						<ExpiryDate format="YYYY-MM-DDThh:mm:ss:TZD">		
							<xsl:value-of select="ExpiryDate"/>
							<xsl:text>T00:00:00</xsl:text>			
						</ExpiryDate>
					</xsl:if>
					
					<xsl:if test="SellByDate">				
						<SellByDate format="YYYY-MM-DDThh:mm:ss:TZD">
							<xsl:value-of select="SellByDate"/>
							<xsl:text>T00:00:00</xsl:text>		
						</SellByDate>
					</xsl:if>
					
					<LineItemNumber scheme="OTHER">
						<xsl:value-of select="LineNumber"/>
					</LineItemNumber>
					
					<LineItemCount scheme="OTHER">						
						<xsl:value-of select="format-number(DespatchedQuantity, '0.000')"/>
					</LineItemCount>
				
					<xsl:if test="SSCC">
						<SSCC scheme="OTHER">
							<xsl:value-of select="SSCC"/>					
						</SSCC>
					</xsl:if>
					
					<ItemIdentification>
						<GTIN scheme="GTIN">
							<xsl:value-of select="ProductID/SuppliersProductCode"/>
						</GTIN>
						
					</ItemIdentification>
				</DespatchItem>
			</xsl:for-each>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    ORDER REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->		
			<OrderReference>
				<PurchaseOrderDate format="YYYY-MM-DDThh:mm:ss:TZD">
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
					
					<xsl:choose>
						<xsl:when test="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderTime">
							<xsl:text>T</xsl:text>
							<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderTime"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>T00:00:00</xsl:text>					
						</xsl:otherwise>
					</xsl:choose>
				</PurchaseOrderDate >

				<PurchaseOrderNumber scheme="OTHER">
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
				</PurchaseOrderNumber>
			</OrderReference>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    ORDER CONFIRMATION REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->		
			<OrderConfirmationReference>
				<CreationDate format="YYYY-MM-DDThh:mm:ss:TZD">
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
					<xsl:text>T00:00:00</xsl:text>					
				</CreationDate>

				<UniqueCreatorIdentification scheme="OTHER">
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
				</UniqueCreatorIdentification>
			</OrderConfirmationReference>
				
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    TRADE AGREEMENT 
			      ~~~~~~~~~~~~~~~~~~~~~~~-->	
			<!-- if we have a TradeAgreement node then a TradeAgreement/ContractReference node must also exist -->
			<xsl:if test="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/TradeAgreement">	
				<TradeAgreement>
					
					<xsl:if test="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
						<ContractReferenceDate format="YYYY-MM-DDThh:mm:ss:TZD">
							<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate"/>
							<xsl:text>T00:00:00</xsl:text>
						</ContractReferenceDate>
					</xsl:if>
						
					<ContractReferenceNumber scheme="OTHER">
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
					</ContractReferenceNumber>
				</TradeAgreement>
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    BUYER
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<Buyer>
				<BuyerGLN scheme="GLN">
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>
				</BuyerGLN>
			
				<xsl:if test="/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>
				
				<xsl:if test="/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</SellerAssigned>
				</xsl:if>
			</Buyer>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SELLER
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<Seller>
				<SellerGLN scheme="GLN">
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
				</SellerGLN>
			
				<xsl:if test="/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
					</SellerAssigned>
				</xsl:if>
				
				<xsl:if test="/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>
			</Seller>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SHIP TO
			      ~~~~~~~~~~~~~~~~~~~~~~~-->			
			<ShipTo>
				<ShipToGLN scheme="GLN">
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToLocationID/GLN"/>
				</ShipToGLN>
			
				<xsl:if test="/DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>
	
				<xsl:if test="/DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToLocationID/SellersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToLocationID/SellersCode"/>
					</SellerAssigned>			
				</xsl:if>
			</ShipTo>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SLOT TIME
			      ~~~~~~~~~~~~~~~~~~~~~~~-->		
			<xsl:if test="/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliverySlot">	
				<SlotTime>
					<SlotStartTime format="YYYY-MM-DDThh:mm:ss:TZD">
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>		
						<xsl:text>T</xsl:text>
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliverySlot/SlotStart"/>
					</SlotStartTime>
					
					<SlotEndTime format="YYYY-MM-DDThh:mm:ss:TZD">
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>		
						<xsl:text>T</xsl:text>
						<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliverySlot/SlotEnd"/>	
					</SlotEndTime>
				</SlotTime>
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SPECIAL DELIVERY REQUIREMENTS
			      ~~~~~~~~~~~~~~~~~~~~~~~-->	
			      
			<!-- Number of boxes being shipped. Provided in Fairfax delivery notes-->	
			<xsl:if test="/DeliveryNote/DeliveryNoteHeader/HeaderExtraData/NumberOfBoxes">	
				<SpecialDeliveryRequirements>
					<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/HeaderExtraData/NumberOfBoxes"/>
				</SpecialDeliveryRequirements>
			</xsl:if>
		</DespatchAdvice>
	</xsl:template>
</xsl:stylesheet>