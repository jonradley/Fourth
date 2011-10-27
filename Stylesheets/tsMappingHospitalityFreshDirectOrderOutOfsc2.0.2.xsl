<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2007-07-26		| 1332 Created Modele
**********************************************************************
Lee Boyton	| 19/07/2007     | 1332 Changes following acceptance testing.
**********************************************************************
R Cambridge	| 2009-07-06	  	| 2980 Send SBR / PL account code as buyer's code for seller
											    Add some sorry logic to populate //sh:Receiver/sh:Identifier
**********************************************************************
A Barber		| 2009-11-17		| Fixed UOM to "EA" if order from MacDonald Hotels or Mercure GLN.
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:order="urn:ean.ucc:order:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
	<xsl:output method="xml" encoding="UTF-8"/>
	
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/PurchaseOrder">

		<sh:StandardBusinessDocument>
			<sh:StandardBusinessDocumentHeader>
				<!--Fixed value version of Standard Business Header - depends on final format agreed-->
				<sh:HeaderVersion>2.2</sh:HeaderVersion>
				<!--Sender Will be a fixed value probable 'DG Trading'-->
				<sh:Sender>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
							<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
					</sh:Identifier>
					<sh:ContactInformation>
						<sh:Contact>
							<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/>
						</sh:Contact>
					</sh:ContactInformation>
				</sh:Sender>
				<!--Target Vendor  - Description-->
				
				<sh:Receiver>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
							<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
						<sh:ContactInformation>
							<sh:Contact>
								<xsl:text>Tradeteam</xsl:text>
							</sh:Contact>
							<sh:ContactTypeIdentifier>
								<xsl:text>Seller</xsl:text>
							</sh:ContactTypeIdentifier>
						</sh:ContactInformation>
					</sh:Identifier>
				</sh:Receiver>
				
				<sh:DocumentIdentification>
					<sh:Standard>"http://www.w3.org/2001/XMLSchema-instance"</sh:Standard>
					<!--GS1 - Purchase Order vaersion reference - Fixed value-->
					<sh:TypeVersion>2.0.2</sh:TypeVersion>
					<!--Message Instance identifier set by Vendor-->
					<sh:InstanceIdentifier>26107001187</sh:InstanceIdentifier>
					<!--Fixed value-->
					<sh:Type>Order</sh:Type>
					<sh:MultipleType>False</sh:MultipleType>
					<!--date and time Format  YYYY-mm-ddTHH:MM:SS-timezone offset -->
					<sh:CreationDateAndTime>
						<xsl:value-of select="concat(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'T',PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime)"/>
					</sh:CreationDateAndTime>
				</sh:DocumentIdentification>
			</sh:StandardBusinessDocumentHeader>
			
			<eanucc:message>
			
				<entityIdentification>
					<!--Unique ID for this message - since one message = one Order could be Order number-->
					<uniqueCreatorIdentification>
						<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
					</uniqueCreatorIdentification>
					<contentOwner>
						<!--GLN for DG Trading -->
						<gln>
							<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
						</gln>
					</contentOwner>
				</entityIdentification>
				
				<!--Start of the Document-->
				<eanucc:documentCommand>
					<!--Type hardcoded to ADD-->
					<documentCommandHeader>
						<xsl:attribute name="type">ADD</xsl:attribute>
						<entityIdentification>
							<!--Unique identifier for Order -->
							<uniqueCreatorIdentification>
								<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
							</uniqueCreatorIdentification>
							<!--DG Trading GLN-->
							<contentOwner>
								<gln>
									<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
								</gln>
							</contentOwner>
						</entityIdentification>
					</documentCommandHeader>
					<documentCommandOperand>
						<!--Start of Order details - Order Creation date and time. Document Status hardcoded 'ORIGINAL'-->
						<!--Format  YYYY-mm-ddTHH:MM:SS-timezone offset -->
						<order:order>
							<contentVersion>
								<versionIdentification>2.0.2</versionIdentification>
							</contentVersion>
							<documentStructureVersion>
								<versionIdentification>2.0.2</versionIdentification>
							</documentStructureVersion>
						
							<!--Order details - Unique Purchase Order number-->
							<orderIdentification>
								<uniqueCreatorIdentification>
									<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
								</uniqueCreatorIdentification>
								<contentOwner>
									<gln>
										<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
									</gln>
								</contentOwner>
							</orderIdentification>
							
							<orderPartyInformation>
								<seller>
									<!--DG Tradings Identification of the Seller -  -->
									<gln>										
										<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
									</gln>
									<!--additionalPartyIdentification>
										<additionalPartyIdentificationValue>
											<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>						
										</additionalPartyIdentificationValue>
										<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
									</additionalPartyIdentification-->
								</seller>
								
								<buyer>
									<gln>
										<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
									</gln>
									<!--Brakes Outlet code -->
									<!--additionalPartyIdentification>
										<additionalPartyIdentificationValue>
											<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
										</additionalPartyIdentificationValue>
										<additionalPartyIdentificationType>SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
									</additionalPartyIdentification-->
								</buyer>
							</orderPartyInformation>
							
							<orderLogisticalInformation>
								<shipToLogistics>
									<shipTo>
										<gln>
											<xsl:choose>
												<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN = '5555555555555'">
													<xsl:text>0000000000000</xsl:text>
												</xsl:when>												
												<xsl:otherwise>
													<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
												</xsl:otherwise>												
											</xsl:choose>											
										</gln>
										<additionalPartyIdentification>
											<additionalPartyIdentificationValue>
												<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
											</additionalPartyIdentificationValue>
											<additionalPartyIdentificationType>SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
										</additionalPartyIdentification>
										<additionalPartyIdentification>
											<additionalPartyIdentificationValue>
												<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
											</additionalPartyIdentificationValue>
											<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
										</additionalPartyIdentification>
									</shipTo>
								</shipToLogistics>
								<orderLogisticalDateGroup>
									<requestedDeliveryDateAtUltimateConsignee>
										<date>
											<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
										</date>
										<time>
											<xsl:choose>
												<xsl:when test="string(PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart) != ''">
													<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
												</xsl:when>
												<xsl:otherwise>00:00:00</xsl:otherwise>
											</xsl:choose>										
										</time>
									</requestedDeliveryDateAtUltimateConsignee>
								</orderLogisticalDateGroup>
							</orderLogisticalInformation>
							
							<!--tradeAgreement>
								<tradeAgreementReferenceNumber>
									<xsl:choose>
										<xsl:when test="PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
											<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</tradeAgreementReferenceNumber>
							</tradeAgreement-->
							
							<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">								
								
								<orderLineItem>
								
									<xsl:attribute name="number">
										<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
									</xsl:attribute>
								
									<requestedQuantity>
											<xsl:choose>
												<xsl:when test=".='KG'">
													<xsl:value-of select="format-number(OrderedQuantity,'0.000')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="format-number(OrderedQuantity,'#0')"/>
												</xsl:otherwise>
											</xsl:choose>
									</requestedQuantity>							
										
										<!--unitOfMeasure>
											<measurementUnitCodeValue>
												<xsl:choose>
													<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN = 5060166760021">
														<xsl:text>EA</xsl:text>
													</xsl:when>
													<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN = 5027615900020">
														<xsl:text>EA</xsl:text>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
													</xsl:otherwise>
												</xsl:choose>
											</measurementUnitCodeValue>
										</unitOfMeasure-->
										
									
									<tradeItemIdentification>
										<gtin>
											<xsl:choose>
												<xsl:when test="ProductID/GTIN = '55555555555555'">
													<xsl:text>0000000000000</xsl:text>
												</xsl:when>
											</xsl:choose>
										</gtin>
										
										<additionalTradeItemIdentification>
											<!-- Suppliers material code -->
											<additionalTradeItemIdentificationValue>
												<xsl:value-of select="ProductID/SuppliersProductCode"/>
											</additionalTradeItemIdentificationValue>
											<additionalTradeItemIdentificationType>SUPPLIER_ASSIGNED</additionalTradeItemIdentificationType>
										</additionalTradeItemIdentification>
										
										<additionalTradeItemIdentification>
											<!-- Text Description of Material -->
											<additionalTradeItemIdentificationValue>
												<xsl:value-of select="ProductID/SuppliersProductCode"/>
											</additionalTradeItemIdentificationValue>
											<additionalTradeItemIdentificationType>BUYER_ASSIGNED</additionalTradeItemIdentificationType>
										</additionalTradeItemIdentification>
										
									</tradeItemIdentification>
									
								</orderLineItem>
								
							</xsl:for-each>
								
						</order:order>
						
					</documentCommandOperand>
					
				</eanucc:documentCommand>
				
			</eanucc:message>
			
		</sh:StandardBusinessDocument>

	</xsl:template>
	
</xsl:stylesheet>
