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
				|						|
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
						<xsl:choose>
							<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN = '5060166760274'">
								<xsl:text>J.W. Lees</xsl:text>
							</xsl:when>
							<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN = '5027615900013'">
								<xsl:text>Aramark</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/>
							</xsl:otherwise>
						</xsl:choose>
					</sh:Identifier>
				</sh:Sender>
				<!--Target Vendor  - Description-->
				<sh:Receiver>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
						
						<xsl:choose>
							
							<!-- Frozen for Aramark -->
							<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN[.='5036036000009'] and PurchaseOrderHeader/Buyer/BuyersLocationID/GLN[.='5027615900013']">
								<xsl:text>Brakes Frozen</xsl:text>
							</xsl:when>
							
							<!-- Grocery for Aramark -->
							<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN[.='5013546062482'] and PurchaseOrderHeader/Buyer/BuyersLocationID/GLN[.='5027615900013']">
								<xsl:text>Brakes Grocery</xsl:text>
							</xsl:when>
							
							<!-- All other suppliers/customers -->
							<xsl:otherwise>
								<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersName"/>
							</xsl:otherwise>
							
						</xsl:choose>				
						
						
					</sh:Identifier>
				</sh:Receiver>
				<sh:DocumentIdentification>
					<sh:Standard>"http://www.w3.org/2001/XMLSchema-instance"</sh:Standard>
					<!--GS1 - Purchase Order vaersion reference - Fixed value-->
					<sh:TypeVersion>2.1</sh:TypeVersion>
					<!--Message Instance identifier set by Vendor-->
					<sh:InstanceIdentifier>1111</sh:InstanceIdentifier>
					<!--Fixed value-->
					<sh:Type>"Purchase Order"</sh:Type>
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
						<additionalPartyIdentification>
							<!-- Text Description for DG Trading Eproc-->
							<additionalPartyIdentificationValue>
								<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/>
							</additionalPartyIdentificationValue>
							<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
						</additionalPartyIdentification>
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
							<xsl:attribute name="creationDateTime">						
								<xsl:value-of select="concat(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'T',PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime)"/>
							</xsl:attribute>
							<xsl:attribute name="documentStatus">ORIGINAL</xsl:attribute>
						
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
									<additionalPartyIdentification>
										<additionalPartyIdentificationValue>
											<xsl:choose>
												<xsl:when test="TradeSimpleHeader/RecipientsBranchReference">
													<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
												</xsl:otherwise>
											</xsl:choose>	
											
										</additionalPartyIdentificationValue>
										<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
									</additionalPartyIdentification>
								</seller>
								
								<buyer>
									<gln>
										<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
									</gln>
									<!--Brakes Outlet code -->
									<additionalPartyIdentification>
										<additionalPartyIdentificationValue>
											<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
										</additionalPartyIdentificationValue>
										<additionalPartyIdentificationType>SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
									</additionalPartyIdentification>
								</buyer>
							</orderPartyInformation>
							
							<orderLogisticalInformation>
								<shipToLogistics>
									<shipTo>
										<gln>
											
											<!-- specific default GLN requirement for Logistics (5036036000030) -->
											<xsl:choose>
												<xsl:when test="PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN='5555555555555' and PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN='5036036000030'">
													<xsl:text>0000000000000</xsl:text>
												</xsl:when>												
												<xsl:otherwise>
													<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
												</xsl:otherwise>												
											</xsl:choose>			
																			
										</gln>
										<!--DG Trading Outlet code -->
										<additionalPartyIdentification>
											<additionalPartyIdentificationValue>
												<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
											</additionalPartyIdentificationValue>
											<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
										</additionalPartyIdentification>
									</shipTo>
								</shipToLogistics>
								<orderLogisticalDateGroup>
									<requestedDeliveryDate>
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
									</requestedDeliveryDate>
								</orderLogisticalDateGroup>
							</orderLogisticalInformation>
							
							<tradeAgreement>
								<!-- DG Trading Price Level -->
								<tradeAgreementReferenceNumber>
									<xsl:choose>
										<xsl:when test="PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
											<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</tradeAgreementReferenceNumber>
							</tradeAgreement>
							
							<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">								
								
								<orderLineItem>
								
									<xsl:attribute name="number">
										<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
									</xsl:attribute>
								
									<requestedQuantity>
									
										<value>
											<xsl:choose>
												<xsl:when test=".='KG'">
													<xsl:value-of select="format-number(OrderedQuantity,'0.000')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="format-number(OrderedQuantity,'#0')"/>
												</xsl:otherwise>
											</xsl:choose>											
										</value>
										
										<unitOfMeasure>
											<measurementUnitCodeValue>
												<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
											</measurementUnitCodeValue>
										</unitOfMeasure>
										
									</requestedQuantity>
									
									<tradeItemIdentification>
									
										<gtin>
											<xsl:value-of select="ProductID/GTIN"/>
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
												<xsl:value-of select="substring(ProductDescription,1,35)"/>
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
