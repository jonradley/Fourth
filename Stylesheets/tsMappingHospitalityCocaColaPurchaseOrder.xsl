<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
Overview

 Coca Cola specific outbound order mapping.
 Maps Hospitality internal Purchase Orders into the EAN UCC format (OFSCI)
 
 © Alternative Business Solutions Ltd., 2007.
******************************************************************************************
 Module History
******************************************************************************************
 Date 			| Name           | Description of modification
******************************************************************************************
 01/06/2007		| R Cambridge    | 1160 copy of tsMapping_Outbound_EANUCC_PurchaseOrder.xsl 
 													 to force encoding to ASCII (even UTF-8 wouldn't do)
******************************************************************************************
 22/10/2007		| Lee Boyton		| 1160 Non-OFSCI compliant change to add the Product Description.
******************************************************************************************
 30/10/2007 	| Lee Boyton     | 1160 Copy SellerAssigned for ShipTo to the BuyerAssigned for ShipTo
******************************************************************************************
			  		|                |
***************************************************************************************-->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:script="http://mycompany.com/mynamespace" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	exclude-result-prefixes="xsl fo script msxsl">
	<xsl:output method="xml" encoding="utf-8"/>
	
	<xsl:template match="/">
		<Order>
		
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			      ORDER DOCUMENT DETAILS 
			      ~~~~~~~~~~~~~~~~~~~~~~~ -->
			<OrderDocumentDetails>
				<PurchaseOrderDate format="YYYY-MM-DDThh:mm:ss:TZD">
					<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
					<xsl:text>T00:00:00</xsl:text>
				</PurchaseOrderDate>
				
				<PurchaseOrderNumber scheme="OTHER">
					<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
				</PurchaseOrderNumber>
				
				<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
					<CustomerReference scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
					</CustomerReference>
				</xsl:if>
				
				<!-- Document Status is always going to be 7 - original -->
				<DocumentStatus codeList="EANCOM">
					<xsl:text>7</xsl:text>
				</DocumentStatus>
			</OrderDocumentDetails>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    MOVEMENT DATE TIME
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<MovementDateTime format="YYYY-MM-DDThh:mm:ss:TZD">
				<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</MovementDateTime>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SLOT TIME
			      ~~~~~~~~~~~~~~~~~~~~~~~-->			
			<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot">
				<SlotTime>
					<SlotStartTime format="YYYY-MM-DDThh:mm:ss:TZD">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						<xsl:text>T</xsl:text>
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
					</SlotStartTime>
					
					<SlotEndTime format="YYYY-MM-DDThh:mm:ss:TZD">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						<xsl:text>T</xsl:text>
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/>
					</SlotEndTime>
				</SlotTime>
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    MOVEMENT TYPE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<MovementType codeList="EANCOM">
				<xsl:choose>
					<!-- 'Collect' maps to '200' and the only other option is 'Delivery' which maps to 'X14' -->
					<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryType = 'Collect'">
						<xsl:text>200</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>X14</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</MovementType>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    BUYER
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<Buyer>
				<BuyerGLN scheme="GLN">
					<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
				</BuyerGLN>
			
				<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>
	
				<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</SellerAssigned>
				</xsl:if>
			</Buyer>
		
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SELLER
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<Seller>
				<SellerGLN scheme="GLN">
					<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
				</SellerGLN>
			
				<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
					</SellerAssigned>
				</xsl:if>
	
				<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>
			</Seller>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SHIP TO
			      ~~~~~~~~~~~~~~~~~~~~~~~-->			
			<ShipTo>
				<ShipToGLN scheme="GLN">
					<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
				</ShipToGLN>
			
				<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</BuyerAssigned>
				</xsl:if>	

				<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</SellerAssigned>			
				</xsl:if>
			</ShipTo>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    TRADE AGREEMENT REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->					
			<!-- if RBR or TradeAgreement exists then TradeAgreement/ContractReference must also exist -->
			<xsl:for-each select="(/PurchaseOrder/TradeSimpleHeader/RecipientsBranchReference | /PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement)[1]">	
				<TradeAgreementReference>
				
					<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">	
						<ContractReferenceDate format="YYYY-MM-DDThh:mm:ss:TZD">
							<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate"/>
							<xsl:text>T00:00:00</xsl:text>
						</ContractReferenceDate>
					</xsl:if>
					
					<ContractReferenceNumber scheme="OTHER">
						<xsl:value-of select="."/>
					</ContractReferenceNumber>
										
				</TradeAgreementReference>
			</xsl:for-each>
			
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    ORDER DETAILS
			      ~~~~~~~~~~~~~~~~~~~~~~~-->					
			<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
				<xsl:sort data-type="number" select="LineNumber"/>
				
				<OrderDetails>
				
					<RequestedQuantity>
						<xsl:attribute name="unitCode">
							<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
						</xsl:attribute>
						
						<xsl:value-of select="format-number(OrderedQuantity,'0.000')"></xsl:value-of>
					</RequestedQuantity>
				
					<LineItemNumber scheme="OTHER">
						<xsl:value-of select="LineNumber"/>
					</LineItemNumber>
				
					<!-- Coca Cola specific change.
					     The supplier product code in our database is probably the GTIN and so should be 
					     put in the GTIN rather than the AlternateCode field -->
					<ItemIdentification>
						<GTIN scheme="GTIN">
							<xsl:choose>
								<xsl:when test="ProductID/GTIN != '55555555555555' and ProductID/GTIN != '5555555555555'">
									<xsl:value-of select="ProductID/GTIN"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="ProductID/SuppliersProductCode"/>					
								</xsl:otherwise>
							</xsl:choose>
						</GTIN>
					</ItemIdentification>
					
					<!-- Coca Cola specific change to add the product description (this is not a valid element in the OFSCI schema.) -->
					<ProductDescription>
						<xsl:value-of select="ProductDescription"/>
					</ProductDescription>
					
				</OrderDetails>
			</xsl:for-each>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    DOCUMENT LINE ITEM COUNT
			      ~~~~~~~~~~~~~~~~~~~~~~~-->					
			<DocumentLineItemCount scheme="OTHER">
				<xsl:value-of select="count(//PurchaseOrderLine)"/>
			</DocumentLineItemCount>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SPECIAL DELIVERY REQUIREMENTS
			      ~~~~~~~~~~~~~~~~~~~~~~~-->			
			<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">		
				<SpecialDeliveryRequirements>
					<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
				</SpecialDeliveryRequirements>
			</xsl:if>
		</Order>
	</xsl:template>
</xsl:stylesheet>