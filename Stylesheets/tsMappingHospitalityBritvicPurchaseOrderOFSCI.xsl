<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order mapper
'  Hospitality iXML to Britvic (OFSCI) format.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 13/09/2005  | Calum Scott  | Created based on tsMapping3663PurchaseOrder.xsl
'******************************************************************************************
'             |              | 
'******************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	
	<xsl:template match="/PurchaseOrder">
		<Order xmlns="http://www.eanucc.org/2002/Order/FoodService/FoodService/UK/EanUcc/Order" xmlns:cc="http://www.ean-ucc.org/2002/gsmp/schemas/CoreComponents">
			<!-- header information -->
			<OrderDocumentDetails>
				<!-- PurchaseOrderDate (and time) -->
				<PurchaseOrderDate format="YYYY-MM-DDThh:mm:ss:TZD">
					<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
					<xsl:text>T00:00:00</xsl:text>
				</PurchaseOrderDate>
				<!-- PurchaseOrderNumber -->
				<PurchaseOrderNumber scheme="OTHER">
					<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>					
				</PurchaseOrderNumber>
				<!-- DocumentStatus (Always 9 Original) -->
				<DocumentStatus codeList="EANCOM">
					<xsl:text>9</xsl:text>
				</DocumentStatus>
			</OrderDocumentDetails>
			<!-- MovementDateTime -->
			<MovementDateTime format="YYYY-MM-DDThh:mm:ss:TZD">
				<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
				<xsl:text>T00:00:00</xsl:text>				
			</MovementDateTime>
			<!-- Optional Delivery Slot Start and End times -->
			<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart or PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd">
				<SlotTime>
					<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart">
						<SlotStartTime format="YYYY-MM-DDThh:mm:ss:TZD">
							<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>				
							<xsl:text>T</xsl:text>
							<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
						</SlotStartTime>
					</xsl:if>
					<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd">
						<SlotEndTime format="YYYY-MM-DDThh:mm:ss:TZD">
							<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>				
							<xsl:text>T</xsl:text>
							<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/>
						</SlotEndTime>
					</xsl:if>
				</SlotTime>
			</xsl:if>
			<Buyer>
				<BuyerGLN scheme="GLN">
					<xsl:text>5555555555555</xsl:text>
				</BuyerGLN>
				<SellerAssigned scheme="OTHER">
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</SellerAssigned>
			</Buyer>
			<Seller>
				<SellerGLN scheme="GLN">
					<xsl:text>5555555555555</xsl:text>
				</SellerGLN>				
			</Seller>
			<ShipTo>
				<ShipToGLN scheme="GLN">
					<xsl:text>5555555555555</xsl:text>
				</ShipToGLN>
				<SellerAssigned scheme="OTHER">
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</SellerAssigned>
			</ShipTo>
			<!-- order line details -->
			<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
				<xsl:sort select="LineNumber" data-type="number"/>
				<OrderDetails>
					<RequestedQuantity>
						<xsl:attribute name="unitCode">
							<xsl:text>EA</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="format-number(OrderedQuantity,'0.000')"/>
					</RequestedQuantity>
					<!-- Line Number -->
					<LineItemNumber scheme="OTHER">
						<xsl:value-of select="LineNumber"/>
					</LineItemNumber>
					<ItemIdentification>
						<GTIN scheme="GTIN">
							<xsl:choose>
								<xsl:when test="string-length(ProductID/GTIN) = 14">
									<xsl:choose>
										<xsl:when test="number(ProductID/GTIN)">
											<xsl:value-of select="ProductID/GTIN"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>5555555555555</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>5555555555555</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</GTIN>
						<AlternateCode scheme="OTHER">
							<xsl:value-of select="ProductID/SuppliersProductCode"/>
						</AlternateCode>
					</ItemIdentification>
				</OrderDetails>
			</xsl:for-each>
			<!-- DocumentLineItemCount -->
			<DocumentLineItemCount scheme="OTHER">
				<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>				
			</DocumentLineItemCount>
		</Order>
	</xsl:template>
</xsl:stylesheet>
