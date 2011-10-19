<!--**************************************************************************************
 Overview

 Maps EAN UCC format (OFSCI) Purchase Order Acknowledgements into the King internal format
 The following details must be populated by subsequent processors:
 	TradeSimpleHeader : 
						Senders Name, Address1-4 and PostCode
						RecipientsCodeForSender, RecipientsBranchReference, RecipientsName, Address1-4
						TestFlag
	PurchaseOrderAcknowledgementHeader :
						Buyer/BuyersName, Address1-4 and PostCode
						Seller/SellersName, Address1-4 and PostCode
						ShipTo/ShipToName, Address1-4 and PostCode CANNOT be filled in anywhere as they will not be a ts member


 © Alternative Business Solutions Ltd., 2005.
******************************************************************************************
 Module History
******************************************************************************************
 Date        	| Name				| Description of modification
******************************************************************************************
K Oshaughnessy|           		| 3450
******************************************************************************************
R Cambridge		| 2011-07-26		| 4632 Added supplier's code for buyer (to allow tsProcessorHosptransSBR to remove SBR when required)
******************************************************************************************
					|						|				
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	xmlns:order="urn:ean.ucc:order:2" 
	xmlns:eanucc="urn:ean.ucc:2" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	
	exclude-result-prefixes="sh order eanucc">
	<xsl:output method="xml" encoding="UTF-8" />
	
	<xsl:template match="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader"/>
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message">
	
		<BatchRoot>
					<PurchaseOrderAcknowledgement>
					
						<!-- ~~~~~~~~~~~~~~~~~~~~~~~
						      TRADESIMPLE HEADER
						      ~~~~~~~~~~~~~~~~~~~~~~~ -->
						<TradeSimpleHeader>
						
							<!-- SCR comes from Sellers code for Buyer if there, else it comes from Buyer GLN -->
							<SendersCodeForRecipient>
								<xsl:choose>
									<xsl:when test="substring-before(order:orderResponse/buyer/additionalPartyIdentification/additionalPartyIdentificationValue,'|')">
										<xsl:value-of select="substring-before(order:orderResponse/buyer/additionalPartyIdentification/additionalPartyIdentificationValue,'|')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="order:orderResponse/seller/gln"/>
									</xsl:otherwise>
								</xsl:choose>
							</SendersCodeForRecipient>
							
							<SendersBranchReference>
								<xsl:value-of select="substring-after(order:orderResponse/seller/additionalPartyIdentification/additionalPartyIdentificationValue,'|')"/>
							</SendersBranchReference>
							
							<!-- SendersName, Address1 - 4 and PostCode will be populated by subsequent processors -->
				
							<!-- Recipients Code for Sender, Recipients Branch Reference, Name, Address1 - 4, PostCode and testflag are populated by 	subsequent processors -->
							
							<!-- TestFlag is populated by subsequent processors -->
											
						</TradeSimpleHeader>
							
							
						<!-- ~~~~~~~~~~~~~~~~~~~~~~~
						      PURCHASE ORDER ACKNOWLEDGEMENT HEADER
						      ~~~~~~~~~~~~~~~~~~~~~~~ -->
						<PurchaseOrderAcknowledgementHeader>
			
							<!-- DocumentStatus is always Original as copies are invalid-->
							<DocumentStatus>
								<xsl:text>Original</xsl:text>
							</DocumentStatus>
							
							<Buyer>
							
								<BuyersLocationID>
									<GLN>
										<xsl:value-of select="order:orderResponse/buyer/gln"/>
									</GLN>							
									<SuppliersCode>
										<xsl:value-of select="substring-after(order:orderResponse/seller/additionalPartyIdentification/additionalPartyIdentificationValue,'|')"/>
									</SuppliersCode>
								</BuyersLocationID>
								
							</Buyer>
							
							<Supplier>
							
								<SuppliersLocationID>
									<GLN>
										<xsl:value-of select="order:orderResponse/seller/gln"/>
									</GLN>
								</SuppliersLocationID>
							
							</Supplier>
							
							<ShipTo>
								<ShipToLocationID>

									<xsl:if test="order:orderResponse/seller/additionalPartyIdentification/additionalPartyIdentificationValue">
										<SuppliersCode>
											<xsl:value-of select="order:orderResponse/seller/additionalPartyIdentification/additionalPartyIdentificationValue"/>
										</SuppliersCode>
									</xsl:if>
								</ShipToLocationID>		
							</ShipTo>
											
							<PurchaseOrderReferences>
			
								<PurchaseOrderReference>
									<xsl:value-of select="order:orderResponse/responseToOriginalDocument/@referenceIdentification"/>
								</PurchaseOrderReference>
								
								<xsl:if test="substring-before(order:orderResponse/responseToOriginalDocument/@referenceDateTime,'T') != ''">								
									<PurchaseOrderDate>
										<xsl:value-of select="substring-before(order:orderResponse/responseToOriginalDocument/@referenceDateTime,'T')"/>
									</PurchaseOrderDate>
								</xsl:if>
								
								<xsl:if test="substring-after(order:orderResponse/responseToOriginalDocument/@referenceDateTime,'T') != ''">
									<PurchaseOrderTime>
										<xsl:value-of select="substring-after(order:orderResponse/responseToOriginalDocument/@referenceDateTime,'T')"/>
									</PurchaseOrderTime>	
								</xsl:if>			
								
							</PurchaseOrderReferences>
							
							<PurchaseOrderAcknowledgementReferences>
							
								<xsl:if test="string(order:orderResponse/responseIdentification/uniqueCreatorIdentification) != ''">
									<PurchaseOrderAcknowledgementReference>
										<xsl:value-of 	select="order:orderResponse/responseIdentification/uniqueCreatorIdentification"/>
									</PurchaseOrderAcknowledgementReference>
								</xsl:if>
							
								<xsl:if test="substring-before(order:orderResponse/@creationDateTime, 'T') != ''">
									<PurchaseOrderAcknowledgementDate>
										<xsl:value-of select="substring-before(order:orderResponse/@creationDateTime, 'T')"/>				
									</PurchaseOrderAcknowledgementDate>
								</xsl:if>
								
							</PurchaseOrderAcknowledgementReferences>		
							
							<OrderedDeliveryDetails>
			
								<!-- we try to get the movement type. We default to Delivery if we do not find it or it is not the only other valid value of 200, 	'Collect' -->
								<DeliveryType>
									<xsl:choose>
										<xsl:when test="/OrderAcknowledgement/MovementType = '200'">
											<xsl:text>Collect</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Delivery</xsl:text>							
										</xsl:otherwise>
									</xsl:choose>
								</DeliveryType>	
													
							</OrderedDeliveryDetails>
							
						</PurchaseOrderAcknowledgementHeader>				
					</PurchaseOrderAcknowledgement>
				</BatchRoot> 	
		</xsl:template>
</xsl:stylesheet>