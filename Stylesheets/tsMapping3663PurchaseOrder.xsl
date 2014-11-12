<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order mapper
'  Hospitality iXML to 3663/MyMarket (OFSCI) format.
'
' © ABS Ltd., 2005.
'******************************************************************************************'******************************************************************************************
' Module History
'******************************************************************************************'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************'******************************************************************************************
' 08/02/2005  | Lee Boyton   | Created        
'******************************************************************************************'******************************************************************************************
' 27/04/2005  | Lee Boyton   | H412. Swap various seller codes to support Burger King requirement.
'******************************************************************************************'******************************************************************************************
' 10/06/2005 | Steve Hewitt | H438, COM020. Change to BuyerGLN logic so one SSP unit can hold a 3663 and Burger King account
'******************************************************************************************'******************************************************************************************
' 02/08/2006  | Lee Boyton   | H610. Add support for wholesale orders (based on certain GLNs.)
'******************************************************************************************'******************************************************************************************
' 03/09/2008  | R Cambridge  | FB case 2459 Amphire require ship to GLN to be default
'******************************************************************************************'******************************************************************************************
' 28/09/2013  | A Barber		|  6118 Introduced logic around handling of split product code for Tragus.
'******************************************************************************************'******************************************************************************************
' 12/11/2014  | M Dimant      | 10081 Added logic not to remove 'S' to split lines for Strada.
'******************************************************************************************'******************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	
	<!-- use a constant for the BK seller GLN -->
	<xsl:variable name="supplierGLN_BK" select="5027615000886"/>
	<xsl:variable name="buyerGLN_SSPBK" select="50600790600029 "/> 

	<!-- wholesale GLNs -->
	<xsl:variable name="supplierGLN_WSFrozen" select="5027615000824"/>
	<xsl:variable name="supplierGLN_WSMultiTemp" select="5027615000831"/>
		
	<xsl:template match="/PurchaseOrder">

		<!-- determine whether we are dealing with a wholesale order as this 
		     changes the format of the order output. -->
		<xsl:variable name="isWholesale">
			<xsl:choose>
				<xsl:when test="substring(PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN,1,13) = $supplierGLN_WSFrozen">
					<xsl:value-of select="1"/>
				</xsl:when>		
				<xsl:when test="substring(PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN,1,13) = $supplierGLN_WSMultiTemp">
					<xsl:value-of select="1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="0"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<Order xmlns="http://www.eanucc.org/2002/Order/FoodService/FoodService/UK/EanUcc/Order" xmlns:cc="http://www.ean-ucc.org/2002/gsmp/schemas/CoreComponents">
			<!-- header information -->
			<OrderDocumentDetails>
			
				<!-- PurchaseOrderDate (and time if not a wholesale order) -->
				<xsl:choose>
					<xsl:when test="$isWholesale = 1">
						<PurchaseOrderDate format="YYYY-MM-DD">
							<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
						</PurchaseOrderDate>
					</xsl:when>
					<xsl:otherwise>
						<PurchaseOrderDate format="YYYY-MM-DDThh:mm:ss:TZD">
							<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
							<xsl:if test="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime">
								<xsl:text>T</xsl:text>
								<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime"/>					
							</xsl:if>
						</PurchaseOrderDate>
					</xsl:otherwise>
				</xsl:choose>
				
				<!-- PurchaseOrderNumber -->
				<PurchaseOrderNumber scheme="OTHER">
					<xsl:value-of select="substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,1,23)"/>					
				</PurchaseOrderNumber>
				<!-- CustomerReference is optional -->
				<xsl:if test="PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
					<CustomerReference scheme="OTHER">
						<xsl:value-of select="substring(PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference,1,23)"/>
					</CustomerReference>
				</xsl:if>
				<!-- DocumentStatus (Always 9 Original) -->
				<DocumentStatus codeList="EANCOM">
					<xsl:text>9</xsl:text>
				</DocumentStatus>
			</OrderDocumentDetails>
			
			<!-- MovementDateTime (time is not included in wholesale orders) -->
			<xsl:choose>
				<xsl:when test="$isWholesale = 1">
					<MovementDateTime format="YYYY-MM-DD">
						<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
					</MovementDateTime>				
				</xsl:when>
				<xsl:otherwise>
					<MovementDateTime format="YYYY-MM-DDThh:mm:ss:TZD">
						<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						<xsl:text>T</xsl:text>
						<xsl:choose>
							<xsl:when test="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart">
								<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>00:00:00</xsl:text>				
							</xsl:otherwise>
						</xsl:choose>
					</MovementDateTime>				
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- Optional Delivery Slot Start and End times (mandatory elements for wholesale orders even though they use lead times) -->
			<xsl:choose>
				<xsl:when test="$isWholesale = 1">
					<SlotTime>
						<SlotStartTime format="YYYY-MM-DD">
							<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						</SlotStartTime>
						<SlotEndTime format="YYYY-MM-DD">
							<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						</SlotEndTime>
					</SlotTime>				
				</xsl:when>
				<xsl:otherwise>
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
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- MovementType (Always X14 Delivery) -->
			<MovementType codeList="EANCOM">
				<xsl:text>X14</xsl:text>
			</MovementType>
			<!--
				Party codes are read in the following order of precedence:
				1. if GLN value is not equal to 5555555555555 then it is used
				2. if GLN value equals 5555555555555 then it is ignored
				3. if SellerAssigned exists then it is used, otherwise
				4. BuyerAssigned is used.
				NB: Cater for the internal document using 0000000000000 for 5555555555555
			-->
			<Buyer>
				<BuyerGLN scheme="GLN">
					<!-- with the Buyer GLN we have to check whether we have the SSP BK account and, if so, we must hard code 
					      the SSP BK value -->
					<xsl:choose>
						<xsl:when test="substring(PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN,1,13) = $supplierGLN_BK">
							<xsl:value-of select="$buyerGLN_SSPBK"/>
						</xsl:when>
						<xsl:when test="TradeSimpleHeader/RecipientsName = '3663 WS esporta'">
							<xsl:text>5060166760335</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN = '0000000000000'">
									<xsl:text>5555555555555</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring(PurchaseOrderHeader/Buyer/BuyersLocationID/GLN,1,13)"/>
								</xsl:otherwise>
							</xsl:choose>					
						</xsl:otherwise>
					</xsl:choose>
				</BuyerGLN>
				<xsl:if test="PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="substring(PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode,1,13)"/>
					</BuyerAssigned>			
				</xsl:if>
				<!-- 3663 specific requirement to use the seller's code for Ship-To in the seller' code for buyer value -->
				<SellerAssigned scheme="OTHER">
					<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,13)"/>
				</SellerAssigned>
			</Buyer>
			<Seller>
				<SellerGLN scheme="GLN">
					<xsl:choose>
						<xsl:when test="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN = '0000000000000'">
							<xsl:text>5555555555555</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN,1,13)"/>
						</xsl:otherwise>
					</xsl:choose>										
				</SellerGLN>				
				<xsl:if test="PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="substring(PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode,1,13)"/>
					</SellerAssigned>
				</xsl:if>
				<BuyerAssigned scheme="OTHER">
					<xsl:value-of select="substring(TradeSimpleHeader/SendersCodeForRecipient,1,13)"/>
				</BuyerAssigned>
			</Seller>
			<ShipTo>
				<!-- 2459 Always use default GLN-->
				<ShipToGLN scheme="GLN">5555555555555</ShipToGLN>
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="substring(PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode,1,13)"/>
					</BuyerAssigned>
				</xsl:if>
				<SellerAssigned scheme="OTHER">
					<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,13)"/>
				</SellerAssigned>
			</ShipTo>
			<!-- optional TradeAgreementReference, ContractReferenceDate and ContractReferenceNumber -->
			<xsl:if test="PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference or PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
				<TradeAgreementReference>
					<xsl:if test="PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
						<ContractReferenceDate format="YYYY-MM-DDThh:mm:ss:TZD">
							<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate"/>						
						</ContractReferenceDate>
					</xsl:if>
					<xsl:if test="PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
						<ContractReferenceNumber scheme="OTHER">
							<xsl:value-of select="substring(PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference,1,23)"/>
						</ContractReferenceNumber>
					</xsl:if>
				</TradeAgreementReference>
			</xsl:if>
			<!-- order line details -->
			<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
				<xsl:sort select="LineNumber" data-type="number"/>
				<OrderDetails>
					<!--
					   3663 specific split pack handling:
					   If the final character of the product code is a capital S then the UoM is set to 'EA' and the S is removed,
					   else the UoM is set to 'CS' and the product code remains unchanged
					-->
					<xsl:variable name="IsSplitLine" select="substring(ProductID/SuppliersProductCode,string-length(ProductID/SuppliersProductCode),1) = 'S'"/>
					<!-- RequestedQuantity -->
					<RequestedQuantity>
						<xsl:attribute name="unitCode">
							<xsl:choose>
								<xsl:when test="$IsSplitLine">
									<xsl:text>EA</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>CS</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<!-- 3663 can only handle integer quantities -->
						<xsl:choose>
							<xsl:when test="OrderedQuantity &lt; 1">
								<xsl:text>1.000</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number(floor(OrderedQuantity),'0.000')"/>
							</xsl:otherwise>
						</xsl:choose>
					</RequestedQuantity>
					<!-- Line Number -->
					<LineItemNumber scheme="OTHER">
						<xsl:value-of select="LineNumber"/>
					</LineItemNumber>
					<!--
						Item codes are read in the following order of precedence by 3663:
						1. if GTIN value is not equal to 5555555555555 (13 5's) then it is used
						2. if GTIN value is equal to 5555555555555 (13 5's) then it is ignored and AlternateCode value is used
						NB: Cater for the internal document using 00000000000000 (14 0's) or 55555555555555 (14 5's)
					-->
					<ItemIdentification>
						<GTIN scheme="GTIN">
							<xsl:choose>
								<xsl:when test="ProductID/GTIN = '00000000000000'">
									<xsl:text>5555555555555</xsl:text>
								</xsl:when>
								<xsl:when test="ProductID/GTIN = '55555555555555'">
									<xsl:text>5555555555555</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="ProductID/GTIN"/>
								</xsl:otherwise>
							</xsl:choose>
						</GTIN>
						<xsl:if test="ProductID/SuppliersProductCode">
							<AlternateCode scheme="OTHER">
								<!-- Bidvest specific split pack handling: Keep the 'S' at the end of product codes from Tragus and Strada, otherwise remove it as usual (for 3663 orders). -->
								<xsl:choose>									
									<xsl:when test="$IsSplitLine and not(../../PurchaseOrderHeader/Buyer/BuyersLocationID/GLN = '5060166761189' or '5060166761301')">
										<xsl:value-of select="substring(substring(ProductID/SuppliersProductCode,1,string-length(ProductID/SuppliersProductCode)-1),1,18)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring(ProductID/SuppliersProductCode,1,18)"/>
									</xsl:otherwise>
								</xsl:choose>								
							</AlternateCode>
						</xsl:if>
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
