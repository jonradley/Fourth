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
R Cambridge	| 2010-01-04		| 3310 handle MITIE PL accounts in //sh:Receiver/sh:Identifier
**********************************************************************
R Cambridge	| 2010-02-01		| 3310 set sh:Sender and sh:Receiver according to GLN of the relevant party
**********************************************************************
H Robson		| 2012-03-02		| 5295 New template to return BuyersCode from a fixed list of codes that Brakes have agreed to receive
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
						
						<!-- 3310 moved senderID logic into template -->
						<xsl:call-template name="determineSenderID">
							<xsl:with-param name="senderGLN" select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
						</xsl:call-template>					
						
					</sh:Identifier>
				</sh:Sender>
				<!--Target Vendor  - Description-->
				<sh:Receiver>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
												
						<!-- 3310 moved vendorID logic into template -->
						<xsl:call-template name="determineVendorID">
							<xsl:with-param name="vendorGLN" select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>						
						</xsl:call-template>							
						
					</sh:Identifier>
				</sh:Receiver>
				<sh:DocumentIdentification>
					<sh:Standard>"http://www.w3.org/2001/XMLSchema-instance"</sh:Standard>
					<!--GS1 - Purchase Order version reference - Fixed value-->
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
													<!-- 2012-03-02 HR 5295 Call a new template to return a code from a fixed list of codes that Brakes have agreed to receive -->
													<xsl:call-template name="determineBuyersCode">
														<xsl:with-param name="vendorGLN" select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
														<xsl:with-param name="senderGLN" select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
														<xsl:with-param name="buyersCode" select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
													</xsl:call-template>
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
												<xsl:choose>
													<!--MacDonald Hotels-->
													<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN = 5060166760021">
														<xsl:text>EA</xsl:text>
													</xsl:when>
													<!--Mercure-->
													<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN = 5027615900020">
														<xsl:text>EA</xsl:text>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
													</xsl:otherwise>
												</xsl:choose>
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
	
	
	
	
<!--=======================================================================================
  Routine        : determineSenderID
  Description    : Uses customer GLN to determine SenderID needed by Kewill (Brakes' system provider)
  							
  							Customer set up before 2010-02-01 used //PurchaseOrderHeader/Buyer/BuyersName
  							 (but any changes to BP_Directory..Member.Name will cause issues at Kewill)
  							
  							Customers set up after 2010-02-01 should use the GLN
  
  Inputs         : Node containing a GLN
  Returns        : A string with a GLN or code/name
  Author         : Robert Cambridge	2010-01-05
  Alterations    : 
 =======================================================================================-->
	<xsl:template name="determineSenderID">
		<xsl:param name="senderGLN"/>

		<xsl:choose>
		
			<!-- Customers set up before 2010-02-01 :-
					Use value of BP_Directory..Member.Name as of 2010-02-01			
			 -->
		
			<xsl:when test="$senderGLN = '5013546120137'">Woodward Foodservice Limited</xsl:when>
			<xsl:when test="$senderGLN = '5027615900013'">Aramark</xsl:when>
			<xsl:when test="$senderGLN = '5027615900020'">Mercure</xsl:when>
			<xsl:when test="$senderGLN = '5060166760014'">Orchid Pubs</xsl:when>
			<xsl:when test="$senderGLN = '5060166760021'">Macdonald Hotels</xsl:when>
			
			<xsl:when test="$senderGLN = '5060166760045'">Bay Restaurant Group</xsl:when>
			<!-- Preceding entry is probably never used as InvoiceToAddress flag is set in extrainfo of  
			     2 Bay child members, corresponding to the next two entries... -->			
			<xsl:when test="$senderGLN = '5060166760243'">Town and City</xsl:when>			
			<xsl:when test="$senderGLN = '5060166760250'">Bay Restaurants</xsl:when> 		
			
			<xsl:when test="$senderGLN = '5060166760083'">Fullers Inns</xsl:when>
			<xsl:when test="$senderGLN = '5060166760106'">Tattershall Castle Group</xsl:when>
			<xsl:when test="$senderGLN = '5060166760113'">The Restaurant Group</xsl:when>
			<xsl:when test="$senderGLN = '5060166760120'">Massarella</xsl:when>
			<xsl:when test="$senderGLN = '5060166760236'">Crerar Hotels</xsl:when>	
			<xsl:when test="$senderGLN = '5060166760274'">J.W. Lees</xsl:when>		
			<xsl:when test="$senderGLN = '5060166760311'">MITIE Catering Services Ltd</xsl:when>
			
			
			<!-- Customers set up after 2010-02-01 :-
					Use GLN			
			 -->			
			 
			<xsl:otherwise>
				<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
			</xsl:otherwise>
			
		</xsl:choose>	
		
	</xsl:template>
	



<!--=======================================================================================
  Routine        : determineVendorID
  Description    : Uses supplier's GLN to determine VendorID needed by Kewill (Brakes' system provider)
  
  							Previously this used //PurchaseOrderHeader/Supplier/SuppliersName but any changes 
  							to BP_Directory..Member.Name will caused issues at Kewill. 
  							Also, PL account orders had the wrong name in this field
  							
  							For PL account customers, provided the PL account GLN is set correctly, the correct name/code will be returned  
  
  Inputs         : Node containing a GLN
  Returns        : A string with a code/name
  Author         : Robert Cambridge	2010-01-05
  Alterations    : 
 =======================================================================================-->	
	<xsl:template name="determineVendorID">
		<xsl:param name="vendorGLN"/>

		<xsl:choose>
			<xsl:when test="$vendorGLN = '5013546026886'">MJ Seafoods Wholesale Ltd</xsl:when><!-- 'M&J Seafood Ltd' on live -->
			<xsl:when test="$vendorGLN = '5013546062482'">Brakes Grocery</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009'">Brakes Frozen</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000030'">Brakes Logistics</xsl:when>
			<xsl:when test="$vendorGLN = '5013546120137'">Woodward Foodservice Limited</xsl:when>
			<xsl:otherwise>
				<xsl:text>??? no code found for </xsl:text>
				<xsl:value-of select="$vendorGLN"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"/>
				<xsl:text>)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>	
		
	</xsl:template>
	
<!--=======================================================================================
  Routine        : determineBuyersCode
  Description    : Uses supplier's GLN & the buyers GLN to determine the buyer's code for supplier. See FB case 5295 
  
  Inputs         : Nodes containing GLNs
  Returns        : A string with a code/name
  Author         : H Robson 	2012-03-02
  Alterations    : 
 =======================================================================================-->	
	<xsl:template name="determineBuyersCode">
		<xsl:param name="vendorGLN"/>
		<xsl:param name="senderGLN"/>
		<xsl:param name="buyersCode"/>
		
		<xsl:choose>
			<!-- special cases -->
			<!-- unfortunately the 3 subdivisions of Brakes; Grocery, Non-Food, and Bar, have all been set up with the same GLN -->
			<!-- TCG and Stonegate both trade with more than one of these subdivisions, so we can not provide protection against these customers changing their codes -->
			<!-- the best we can do is to detect the presence of the codes as they are now (March 2012) and pass them straight through -->
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760106' and $buyersCode = 'BRA008'">BRA008</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760106' and $buyersCode = 'BRA015'">BRA015</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760106' and $buyersCode = 'BRA020'">BRA020</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760007' and $buyersCode = 'S20293538800/N'">S20293538800/N</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760007' and $buyersCode = 'S20293538800/G'">S20293538800/G</xsl:when>

			<!-- !!! NEW MAPPINGS FOR BRAKES NON-FOOD OR BRAKES BAR SHOULD BE ADDED HERE !! -->
			<!-- for any other subdivision (e.g. MJ Seafood, Brakes Grocery) the mapping is handled further down in this template and nothing should be added -->
			<!-- <xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = 'xxxxxxxxxxxxx' and $buyersCode = 'xxxxxx'">BRAKESNONFOOD</xsl:when> -->
			<!-- <xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = 'xxxxxxxxxxxxx' and $buyersCode = 'xxxxxx'">BRAKESBAR</xsl:when>-->
			<!-- if the vendorGLN is 5013546062482 and you do not add a mapping then the code 'BRAKESGROCERY' will be sent by default -->
			<!-- once again the code to use for a Non-Food integration is 'BRAKESNONFOOD' and for a Bar integration its 'BRAKESBAR' - this has been agreed with Brakes as of March 2012 -->
				
			<!-- standard cases -->
			<!-- where the combination of vendor GLN and sender GLN is enough to correctly determine the right buyersCode -->
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166760045'">S34824145700</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166760069'">CMJS01</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166760014'">M&amp;JSEAFOOD</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5027615900012'">MandJ</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166760106'">MJS001</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166760090'">MJS001</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166760083'">MJSEAFOOD</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166760274'">m&amp;jSEAFOOD</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166761004'">MJSE01</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166761028'">803/1</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166761066'">752907</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5055188800008'">mjseafood</xsl:when>
			<xsl:when test="$vendorGLN = '5013546026886' and $senderGLN = '5060166760038'">mjseafoods</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760045'">S20293538800FROZEN</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760069'">CBRA01</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760014'">BRAKESFROZEN</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760106'">BRA010</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5027615900020'">BRAKESFROZEN</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760083'">BrakesFrozen</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760236'">BRAK01</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760281'">PL106</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166761028'">FROZEN#805/2</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760007'">S20293538800/F</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760021'">213948</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5055188800008'">brakesfrozen</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760038'">brakesfrozen</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760144'">BF</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009' and $senderGLN = '5060166760076'">13285</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760045'">S20293538800GROCERY</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760069'">CWAT01</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760014'">BRAKESGROCERY</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5027615900020'">BRAKESGROCERY</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760083'">BrakesGrocery</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760236'">WATS02</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760281'">PL744</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166761028'">GROCERY#805/2</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760021'">201027</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5055188800008'">brakesgrocery</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760038'">brakesgrocery</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760144'">BRAKES</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5060166760076'">GOSH45</xsl:when>
			<xsl:when test="$vendorGLN = '5013546062482' and $senderGLN = '5024875116663'">BRAKES</xsl:when>
			<xsl:when test="$vendorGLN = '5013546120137' and $senderGLN = '5060166760045'">Woodwards</xsl:when>
			<xsl:when test="$vendorGLN = '5013546120137' and $senderGLN = '5060166760014'">WOODWARD</xsl:when>
			<xsl:when test="$vendorGLN = '5013546120137' and $senderGLN = '5060166760274'">LW0163</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000030' and $senderGLN = '5060166760045'">S20293538800</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000030' and $senderGLN = '5060166760113'">V010352</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000030' and $senderGLN = '5060166760120'">BRA01</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000030' and $senderGLN = '5060166760007'">S20293538800</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000030' and $senderGLN = '5060166761042'">CBRA02</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000030' and $senderGLN = '5024875116663'">BRAKES</xsl:when>
			
			<!-- codes to be sent for future customers we integrate -->
			<xsl:when test="$vendorGLN = '5013546026886'">MJSEAFOOD</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000009'">BRAKESFROZEN</xsl:when>
			<!-- Unfortunately Brakes Grocery, Non-Food, and Bar, all share a GLN so the best we can do is assume the Grocery code by default -->
			<xsl:when test="$vendorGLN = '5013546062482'">BRAKESGROCERY</xsl:when>
			<!--<xsl:when test="$vendorGLN = '5013546062482'">BRAKESNONFOOD</xsl:when>-->
			<!--<xsl:when test="$vendorGLN = '5013546062482'">BRAKESBAR</xsl:when>-->
			<xsl:when test="$vendorGLN = '5013546120137'">WOODWARD</xsl:when>
			<xsl:when test="$vendorGLN = '5036036000030'">BRAKESLOGISTICS</xsl:when>

		</xsl:choose>	
		
	</xsl:template>
	
	
</xsl:stylesheet>
