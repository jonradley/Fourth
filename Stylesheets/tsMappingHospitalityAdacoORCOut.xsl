<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

 Outbound confirmations to Adaco.Net (basically internal format)
 
******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         	| Description of modification
******************************************************************************************
 2013-03-04  | R Cambridge 	| FB6038 Created Module 
******************************************************************************************
             |            	| 
******************************************************************************************
             |            	| 
******************************************************************************************
             |             	|           
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:include href="./tsMappingHospitalityAdacoCommon.xsl"/>
	
	<xsl:template match="PurchaseOrderConfirmation">
	
		<PurchaseOrderConfirmation>
			<TradeSimpleHeader>
				
				<SendersCodeForRecipient>
					<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				</SendersCodeForRecipient>
				<SendersName>
					<xsl:value-of select="TradeSimpleHeader/SendersName"/>
				</SendersName>
				
				<SendersAddress>
					<AddressLine1>
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine2"/>
					</AddressLine2>
					<AddressLine3>
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine3"/>
					</AddressLine3>
					<AddressLine4>
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine4"/>
					</AddressLine4>
					<PostCode>
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/PostCode"/>
					</PostCode>
				</SendersAddress>
				
				<RecipientsCodeForSender>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</RecipientsCodeForSender>
				<RecipientsBranchReference>
					<xsl:value-of select="substring-before(concat(TradeSimpleHeader/RecipientsBranchReference, $HOTEL_SUBDIVISION_SEPERATOR), $HOTEL_SUBDIVISION_SEPERATOR)"/>
				</RecipientsBranchReference>
				<RecipientsName>
					<xsl:value-of select="TradeSimpleHeader/RecipientsName"/>
				</RecipientsName>
				
				<RecipientsAddress>
					<AddressLine1>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine2"/>
					</AddressLine2>
					<AddressLine3>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine3"/>
					</AddressLine3>
					<AddressLine4>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine4"/>
					</AddressLine4>
					<PostCode>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/PostCode"/>
					</PostCode>
					
				</RecipientsAddress>
				<TestFlag>
					<xsl:value-of select="TradeSimpleHeader/TestFlag"/>
				</TestFlag>
				
			</TradeSimpleHeader>
			
			<PurchaseOrderConfirmationHeader>
			
				<DocumentStatus>
					<xsl:value-of select="PurchaseOrderConfirmationHeader/DocumentStatus"/>
				</DocumentStatus>
				
				<Buyer>
					<BuyersLocationID>
						<GLN>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/GLN"/>
						</GLN>
						<BuyersCode>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/BuyersCode"/>
						</BuyersCode>
						<SuppliersCode>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/SuppliersCode"/>
						</SuppliersCode>
					</BuyersLocationID>
					<BuyersName>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersName"/>
					</BuyersName>
					<BuyersAddress>
						<AddressLine1>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine1"/>
						</AddressLine1>
						<AddressLine2>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine2"/>
						</AddressLine2>
						<AddressLine3>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine3"/>
						</AddressLine3>
						<PostCode>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/PostCode"/>
						</PostCode>
					</BuyersAddress>
				</Buyer>
				
				<Supplier>
					<SuppliersLocationID>
						<GLN>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
						</GLN>
						<BuyersCode>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/BuyersCode"/>
						</BuyersCode>
					</SuppliersLocationID>
					<SuppliersName>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersName"/>
					</SuppliersName>
					<SuppliersAddress>
						<AddressLine1>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine1"/>
						</AddressLine1>
						<AddressLine2>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine2"/>
						</AddressLine2>
						<AddressLine3>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine3"/>
						</AddressLine3>
						<PostCode>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/PostCode"/>
						</PostCode>
					</SuppliersAddress>
				</Supplier>
				
				<ShipTo>
					<ShipToLocationID>
						<GLN>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/GLN"/>
						</GLN>
						<BuyersCode>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode"/>
						</BuyersCode>
						<SuppliersCode>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</SuppliersCode>
					</ShipToLocationID>
					<ShipToName>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToName"/>
					</ShipToName>
					<ShipToAddress>
						<AddressLine1>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1"/>
						</AddressLine1>
						<AddressLine2>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2"/>
						</AddressLine2>
						<AddressLine3>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3"/>
						</AddressLine3>
						<AddressLine4>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4"/>
						</AddressLine4>
						<PostCode>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode"/>
						</PostCode>
					</ShipToAddress>
					<ContactName>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ContactName"/>
					</ContactName>
				</ShipTo>
				
				<PurchaseOrderReferences>
					<PurchaseOrderReference>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
					</PurchaseOrderReference>
					<PurchaseOrderDate>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
					</PurchaseOrderDate>
				</PurchaseOrderReferences>
				
				<PurchaseOrderConfirmationReferences>
					<PurchaseOrderConfirmationReference>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
					</PurchaseOrderConfirmationReference>
					<PurchaseOrderConfirmationDate>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
					</PurchaseOrderConfirmationDate>
				</PurchaseOrderConfirmationReferences>
				
				<OrderedDeliveryDetails>
					<DeliveryType>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryType"/>
					</DeliveryType>
					<DeliveryDate>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate"/>
					</DeliveryDate>
				</OrderedDeliveryDetails>
				
				<ConfirmedDeliveryDetails>
					<DeliveryType>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryType"/>
					</DeliveryType>
					<DeliveryDate>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
					</DeliveryDate>
				</ConfirmedDeliveryDetails>
				
			</PurchaseOrderConfirmationHeader>
			
			<PurchaseOrderConfirmationDetail>
				
				<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
			
					<PurchaseOrderConfirmationLine>
					
						<xsl:attribute name="LineStatus">
							<xsl:value-of select="@LineStatus"/>
						</xsl:attribute>
					
						<LineNumber>
							<xsl:value-of select="LineNumber"/>
						</LineNumber>
						<ProductID>
							<GTIN>
								<xsl:value-of select="ProductID/GTIN"/>
							</GTIN>
							<SuppliersProductCode>
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</SuppliersProductCode>
							<BuyersProductCode>
								<xsl:value-of select="ProductID/BuyersProductCode"/>
							</BuyersProductCode>
						</ProductID>
						
						<xsl:for-each select="SubstitutedProductID">
						
							<SubstitutedProductID>
								<GTIN>
									<xsl:value-of select="GTIN"/>
								</GTIN>
								<SuppliersProductCode>
									<xsl:value-of select="SuppliersProductCode"/>
								</SuppliersProductCode>
							</SubstitutedProductID>
						
						</xsl:for-each>
						
						
						<ProductDescription>
							<xsl:value-of select="ProductDescription"/>
						</ProductDescription>
						
						<OrderedQuantity>
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="OrderedQuantity"/>
						</OrderedQuantity>
						
						<ConfirmedQuantity>
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="ConfirmedQuantity"/>
						</ConfirmedQuantity>
						
						<PackSize>
							<xsl:value-of select="PackSize"/>
						</PackSize>
						
						<UnitValueExclVAT>
							<xsl:value-of select="UnitValueExclVAT"/>
						</UnitValueExclVAT>
						
						<LineValueExclVAT>
							<xsl:value-of select="LineValueExclVAT"/>
						</LineValueExclVAT>
					</PurchaseOrderConfirmationLine>
					
				</xsl:for-each>
					
			</PurchaseOrderConfirmationDetail>
			
			<PurchaseOrderConfirmationTrailer>
			
				<NumberOfLines>
					<xsl:value-of select="PurchaseOrderConfirmationTrailer/NumberOfLines"/>
				</NumberOfLines>
				
				<TotalExclVAT>
					<xsl:value-of select="PurchaseOrderConfirmationTrailer/TotalExclVAT"/>
				</TotalExclVAT>
				
			</PurchaseOrderConfirmationTrailer>
			
		</PurchaseOrderConfirmation>
		
	</xsl:template>
	
</xsl:stylesheet>
