<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	<xsl:template match="/">
	<GoodsReceivedNote>
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient"/>
			</SendersCodeForRecipient>
			<SendersName>
				<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/SendersName"/>
			</SendersName>
			<SendersAddress>
				<AddressLine1>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/SendersAddress/AddressLine1"/>
				</AddressLine1>
				<AddressLine2>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/SendersAddress/AddressLine2"/>
				</AddressLine2>
				<AddressLine3>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/SendersAddress/AddressLine3"/>
				</AddressLine3>
				<AddressLine4>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/SendersAddress/AddressLine4"/>
				</AddressLine4>
				<PostCode>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/SendersAddress/PostCode"/>
				</PostCode>
			</SendersAddress>
			<RecipientsCodeForSender>
				<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/RecipientsCodeForSender"/>		
			</RecipientsCodeForSender>
			<RecipientsBranchReference>
				<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/RecipientsBranchReference"/>
			</RecipientsBranchReference>
			<RecipientsName>
				<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/RecipientsName"/>		
			</RecipientsName>
			<RecipientsAddress>
				<AddressLine1>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/RecipientsAddress/AddressLine1"/>	
				</AddressLine1>
				<AddressLine2>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/RecipientsAddress/AddressLine2"/>
				</AddressLine2>
				<AddressLine3>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/RecipientsAddress/AddressLine3"/>
				</AddressLine3>
				<AddressLine4>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/RecipientsAddress/AddressLine4"/>
				</AddressLine4>
				<PostCode>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/RecipientsAddress/PostCode"/>
				</PostCode>
			</RecipientsAddress>
			<TestFlag>
					<xsl:value-of select="GoodsReceivedNote/TradeSimpleHeader/TestFlag"/>
			</TestFlag>
		</TradeSimpleHeader>
		<GoodsReceivedNoteHeader>
			<DocumentStatus>
				<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/DocumentStatus"/>
			</DocumentStatus>
			<Buyer>
				<BuyersLocationID>
					<GLN>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/GLN"/>
					</GLN>
					<BuyersCode>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
					</BuyersCode>
					<SuppliersCode>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</SuppliersCode>
				</BuyersLocationID>
				<BuyersName>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersName"/>
				</BuyersName>
				<BuyersAddress>
					<AddressLine1>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
					</AddressLine1>
					<PostCode>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/PostCode"/>
					</PostCode>
				</BuyersAddress>
			</Buyer>
			<Supplier>
				<SuppliersLocationID>
					<GLN>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/GLN"/>
					</GLN>
					<BuyersCode>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</BuyersCode>
					<SuppliersCode>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
					</SuppliersCode>
				</SuppliersLocationID>
				<SuppliersName>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersName"/>
				</SuppliersName>
				<SuppliersAddress>
					<AddressLine1>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
					</AddressLine2>
					<AddressLine3>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
					</AddressLine3>
					<PostCode>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/PostCode"/>
					</PostCode>
				</SuppliersAddress>
			</Supplier>
			<ShipTo>
				<ShipToLocationID>
					<GLN>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/GLN"/>
					</GLN>
					<SuppliersCode>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</SuppliersCode>
				</ShipToLocationID>
				<ShipToName>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToName"/>
				</ShipToName>
				<ShipToAddress>
					<AddressLine1>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
					</AddressLine2>
					<AddressLine3>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
					</AddressLine3>
					<AddressLine4>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine4"/>
					</AddressLine4>
					<PostCode>
						<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/PostCode"/>
					</PostCode>
				</ShipToAddress>
			</ShipTo>
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
				</PurchaseOrderReference>
				<PurchaseOrderDate>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
			<PurchaseOrderConfirmationReferences>
				<PurchaseOrderConfirmationReference>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
				</PurchaseOrderConfirmationReference>
				<PurchaseOrderConfirmationDate>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
				</PurchaseOrderConfirmationDate>
			</PurchaseOrderConfirmationReferences>
			<DeliveryNoteReferences>
				<DeliveryNoteReference>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
				</DeliveryNoteReference>
				<DeliveryNoteDate>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
				</DeliveryNoteDate>
				<DespatchDate>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DespatchDate"/>
				</DespatchDate>
			</DeliveryNoteReferences>
			<GoodsReceivedNoteReferences>
				<GoodsReceivedNoteReference>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
				</GoodsReceivedNoteReference>
				<GoodsReceivedNoteDate>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
				</GoodsReceivedNoteDate>
			</GoodsReceivedNoteReferences>
			<DeliveredDeliveryDetails>
				<DeliveryType>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliveryType"/>
				</DeliveryType>
				<DeliveryDate>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
				</DeliveryDate>
			</DeliveredDeliveryDetails>
			<ReceivedDeliveryDetails>
				<DeliveryType>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryType"/>
				</DeliveryType>
				<DeliveryDate>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryDate"/>
				</DeliveryDate>
			</ReceivedDeliveryDetails>
			<HeaderExtraData>
				<UpdateZonalStock>
					<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteHeader/HeaderExtraData/UpdateZonalStock"/>
				</UpdateZonalStock>
			</HeaderExtraData>
		</GoodsReceivedNoteHeader>
		<GoodsReceivedNoteDetail>
			<xsl:for-each select="GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
				<GoodsReceivedNoteLine LineStatus="">
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
					</ProductID>
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
					<DeliveredQuantity>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/>
						</xsl:attribute>
						<xsl:value-of select="DeliveredQuantity"/>
					</DeliveredQuantity>
					<AcceptedQuantity>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="AcceptedQuantity/@UnitOfMeasure"/>
						</xsl:attribute>
						<xsl:value-of select="AcceptedQuantity"/>
					</AcceptedQuantity>
					<UnitValueExclVAT>
						<xsl:value-of select="/UnitValueExclVAT"/>
					</UnitValueExclVAT>
					<LineValueExclVAT>
						<xsl:value-of select="LineValueExclVAT"/>
					</LineValueExclVAT>
					<LineDiscountRate>
						<xsl:value-of select="LineDiscountRate"/>
					</LineDiscountRate>
					<LineDiscountValue>
						<xsl:value-of select="LineDiscountValue"/>
					</LineDiscountValue>
					<LineExtraData/>
				</GoodsReceivedNoteLine>
			</xsl:for-each>
		</GoodsReceivedNoteDetail>
		<GoodsReceivedNoteTrailer>
			<NumberOfLines>
				<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteTrailer/NumberOfLines"/>
			</NumberOfLines>
			<DocumentDiscountRate>
				<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate"/>
			</DocumentDiscountRate>
			<DiscountedLinesTotalExclVAT>
				<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteTrailer/DiscountedLinesTotalExclVAT"/>
			</DiscountedLinesTotalExclVAT>
			<DocumentDiscount>
				<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscount"/>
			</DocumentDiscount>
			<TotalExclVAT>
				<xsl:value-of select="GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT"/>
			</TotalExclVAT>
		</GoodsReceivedNoteTrailer>
	</GoodsReceivedNote>	
	</xsl:template>
</xsl:stylesheet>