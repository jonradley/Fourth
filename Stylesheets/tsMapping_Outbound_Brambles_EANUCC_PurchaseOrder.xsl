<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

 Maps Hospitality internal Purchase Orders into the EAN UCC format (OFSCI)
  

******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name              | Description of modification
******************************************************************************************
 14/01/2009  |	 R Cambridge   | 2669 branched from tsMapping_Outbound_FoodPartners_EANUCC_PurchaseOrder.xsl
******************************************************************************************
 04/03/2009  | R Cambridge   | 2787 Only try to prepend Recipient's branch ref to buyer's unit code if it exists
******************************************************************************************
  10/04/2012 |K Oshaughnessy  | Small temporary hack to allow order though a child Food partners member for Caffe Nero  
***************************************************************************************-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
				xmlns="http://www.eanucc.org/2002/Order/FoodService/FoodService/UK/EanUcc/Order"
				exclude-result-prefixes="fo script msxsl">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	
	<xsl:template match="/">
		<Order>
		
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			      ORDER DOCUMENT DETAILS 
			      ~~~~~~~~~~~~~~~~~~~~~~~ -->
			<OrderDocumentDetails>
				<PurchaseOrderDate format="YYYY-MM-DDThh:mm:ss:TZD">
					<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
					<xsl:text>T</xsl:text>
					<xsl:choose>
						<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime">
							<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>00:00:00</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
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
	
				<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
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
	
				<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
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
			
			<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode != ''">
				<xsl:choose>
					<xsl:when test="/PurchaseOrder/TradeSimpleHeader/RecipientsBranchReference = 'Food' ">
						<BuyerAssigned scheme="OTHER">
							<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender"/>
						</BuyerAssigned>
					</xsl:when>
					<xsl:when test="string(/PurchaseOrder/TradeSimpleHeader/RecipientsBranchReference) != ''">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/RecipientsBranchReference"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender"/>
					</BuyerAssigned>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender"/>
					</xsl:otherwise>
				</xsl:choose>
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
			<!-- if TradeAgreement exists then TradeAgreement/ContractReference must also exist -->
			<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement">	
				<TradeAgreementReference>
				
					<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">	
						<ContractReferenceDate format="YYYY-MM-DDThh:mm:ss:TZD">
							<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate"/>
							<xsl:text>T00:00:00</xsl:text>
						</ContractReferenceDate>
					</xsl:if>
					
					<ContractReferenceNumber scheme="OTHER">
						<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
					</ContractReferenceNumber>
				</TradeAgreementReference>
			</xsl:if>
			
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

							<!--xsl:choose>
								<xsl:when test="translate(PackSize,'EACH','each') = 'each'">EA</xsl:when>
								<xsl:otherwise>CS</xsl:otherwise>
							</xsl:choose-->
						
						<xsl:value-of select="format-number(OrderedQuantity,'0.000')"></xsl:value-of>
					</RequestedQuantity>
				
					<LineItemNumber scheme="OTHER">
						<xsl:value-of select="LineNumber"/>
					</LineItemNumber>
				
					<ItemIdentification>
						<GTIN scheme="GTIN">
							<xsl:value-of select="ProductID/GTIN"/>
						</GTIN>
						
						<!-- alternate code is sourced from the Suppliers code -->
						<xsl:if test="ProductID/SuppliersProductCode"> 
							<AlternateCode scheme="OTHER">
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</AlternateCode>
						</xsl:if>
					</ItemIdentification>
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