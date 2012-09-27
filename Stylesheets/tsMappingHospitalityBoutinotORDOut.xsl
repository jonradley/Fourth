<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************
Name			| Date				| Change
**********************************************************************
K Oshaughnessy| 24/09/2012	| Created FB5520
*********************************************************************
K Oshaughnessy| 26/009/2012| Bugfix to map suppliers code for unit FB5738
**********************************************************************.-->

<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:fo="http://www.w3.org/1999/XSL/Format" 
xmlns:script="http://mycompany.com/mynamespace" 
xmlns:msxsl="urn:schemas-microsoft-com:xslt">

<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:template match="/">
	
	<xsl:variable name="Guid">
		<xsl:value-of select="script:CreateGUID()"/>
	</xsl:variable>	
	
		<Envelope xmlns="http://schemas.microsoft.com/dynamics/2008/01/documents/Message">
		
			<Header>
				<!-- This needs to be a unqiue GUID for each message sent-->
				<MessageId>
				<xsl:value-of select="$Guid"/>
				</MessageId>
				
				<!-- This is the windows/AX user that the order will be created by -->
				<SourceEndpointUser>
					<xsl:text>Omnica\Gareth</xsl:text>
				</SourceEndpointUser>
				
				<!-- This will be a fixed value that we will need to configure and provide -->
				<SourceEndpoint>
					<xsl:text>SyncEngine</xsl:text>
				</SourceEndpoint>
				
				<!-- This will be a fixed value that we will need to configure and provide -->
				<DestinationEndpoint>
					<xsl:text>UK4</xsl:text>
				</DestinationEndpoint>
				
				<!-- do not change this line, it tells AX to create a sales order -->
				<Action>
					<xsl:text>http://schemas.microsoft.com/dynamics/2008/01/services/SalesOrderService/create</xsl:text>
				</Action>
				
				<!-- This can be the same value as the "MessageId" field above -->
				<RequestMessageId>
					<xsl:value-of select="$Guid"/>
				</RequestMessageId>
				
			</Header>
			
			<Body>
				<MessageParts>
				
					<SalesOrder xmlns="http://schemas.microsoft.com/dynamics/2008/01/documents/SalesOrder">
						<SalesTable class="entity">
						
							<!-- AX Currency code for the order -->
							<CurrencyCode>
								<xsl:text>GBP</xsl:text>
							</CurrencyCode>
							
							<!-- Customer account number -->
							<CustAccount>
								<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
							</CustAccount>
							
							<!-- Customer's reference number if they have one -->
							<CustomerRef>
								<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
							</CustomerRef>
							
							<xsl:if test="/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4 !=''">
								<DeliveryCity>
									<xsl:value-of select="/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
								</DeliveryCity>
							</xsl:if>
							
							<DeliveryCountryRegionId>
								<xsl:text>GB</xsl:text>
							</DeliveryCountryRegionId>
							
							<!-- Optional delivery date for the order -->
							<DeliveryDate>
								<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
							</DeliveryDate>
							
							<xsl:if test="PurchaseOrder/PurchaseOrderHeader/ShipTo/ContactName !='' ">
								<DeliveryName>
									<xsl:value-of select="/PurchaseOrderHeader/ShipTo/ContactName"/>
								</DeliveryName>
							</xsl:if>
							
							<xsl:if test="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4 !=''">
								<DeliveryState>
									<xsl:value-of select="/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
								</DeliveryState>
							</xsl:if>
							
							<xsl:if test="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 !='' ">
								<DeliveryStreet>
									<xsl:value-of select="/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
								</DeliveryStreet>
							</xsl:if>
							
							<xsl:if test="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode !=''">
								<DeliveryZipCode>
									<xsl:value-of select="/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
								</DeliveryZipCode>
							</xsl:if>
							
							<DlvMode>
								<xsl:text>STD</xsl:text>
							</DlvMode>
							
							<!-- AX mode of delivery for the order -->
							<Email/>
							
							<!-- Leave this field blank -->
							<OBSDutyCodeId/>
							
							<!-- Leave this field blank -->
							<OBSOrderTypeId/>
							
							<!-- Leave as "No" -->
							<OCCCashOrder>
								<xsl:text>No</xsl:text>
							</OCCCashOrder>
							
							<!-- Leave as "No" -->
							<OneTimeCustomer>
								<xsl:text>No</xsl:text>
							</OneTimeCustomer>
							
							<!-- Omnica Brand -->
							<OSSBrandId>Independ</OSSBrandId>

							<!-- Omnica Channel -->
							<OSSChannelId>
								<xsl:text>EDI</xsl:text>
							</OSSChannelId>
							
							<!-- Leave as "No" -->
							<OSSSingleDelivery>
								<xsl:text>No</xsl:text>
							</OSSSingleDelivery>
							
							<!-- This needs to be a unique order reference value, must be unqiue -->
							<PurchOrderFormNum>
								<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
							</PurchOrderFormNum>
							
							<!-- Order number - this is optional, but if they can provide an order number it will stop duplicates being loaded if some one accedentally sends an order file again -->
							<SalesId>
								<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
							</SalesId>
							
							<xsl:for-each select="PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
								<SalesLine class="entity">
								
									<!-- AX Item Id -->
									<ItemId>
										<xsl:value-of select="ProductID/SuppliersProductCode"/>
									</ItemId>
									
									<!-- Leave as "0" if sending next field -->
									<LinePercent>
										<xsl:text>0</xsl:text>
									</LinePercent>
									
									<!-- Item Price, this is optional, if not provided AX will re-price the order -->
									<SalesPrice>
										<xsl:value-of select="UnitValueExclVAT"/>
									</SalesPrice>
									
									<!-- Number of Units ordered -->
									<SalesQty>
										<xsl:value-of select="OrderedQuantity"/>
									</SalesQty>
									
									<!-- Unit of product ordered, e.g. Bottle/Case6/Case12-->
									<xsl:if test="OrderedQuantity/@UnitOfMeasure!= '' ">
										<SalesUnit>
											<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
										</SalesUnit>
									</xsl:if>
									
								</SalesLine>
							</xsl:for-each>
							
							<xsl:if test="/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions !='' ">
								<DocuRefHeader class="entity">
									<!-- Only need this block of XML if there are some delivery instructions -->
									<Notes>
										<xsl:text>Delivery Notes</xsl:text>
									</Notes>
									<!-- Delivery Instructions for the order - optional -->
									<Restriction>
										<xsl:value-of select="/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
									</Restriction>
								</DocuRefHeader>
							</xsl:if>
							
						</SalesTable>
					</SalesOrder>
					
				</MessageParts>
			</Body>
			
		</Envelope>
	
	</xsl:template>
	
<msxsl:script language="VBScript" implements-prefix="script"><![CDATA[
	Function CreateGUID
	  Dim TypeLib
	  Set TypeLib = CreateObject("Scriptlet.TypeLib")
	  CreateGUID = Mid(TypeLib.Guid, 2, 36)
	End Function
]]>		
</msxsl:script>			
	

</xsl:stylesheet>
