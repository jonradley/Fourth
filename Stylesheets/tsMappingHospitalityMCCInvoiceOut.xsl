<?xml version="1.0" encoding="UTF-8"?>

<!--
/******************************************************************************************
'  XSL Invoice mapper
'  Hospitality iXML to Urbium CSV Outbound format.
'
' © ABS Ltd., 2008.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 10/07/2008  | Andy Newton  | Created
'******************************************************************************************

'             |              | 
'******************************************************************************************
-->


<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>

<xsl:template match="/"> 

<!--These are 'fake' batch headers designed to replicate what MCC already receive.  In essence it will always be a batch of one-->
<Batch>
	<BatchHeader>	
		<VATSubTotals>
			<xsl:for-each select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal">	
				<VATSubTotal>
					<xsl:attribute name="VATCode">
						<xsl:value-of select = "@VATCode"/>
					</xsl:attribute>
					<xsl:attribute name="VATRate">
						<xsl:value-of select = "@VATRate"/>
					</xsl:attribute>					
					<NumberOfLinesAtRate>
						<xsl:value-of select="NumberOfLinesAtRate"/>
					</NumberOfLinesAtRate>
					<NumberOfItemsAtRate>
						<xsl:value-of select="NumberOfItemsAtRate"/>
					</NumberOfItemsAtRate>
					<DocumentTotalExclVATAtRate>
						<xsl:value-of select="DocumentTotalExclVATAtRate"/>
					</DocumentTotalExclVATAtRate>
					<SettlementDiscountAtRate>
						<xsl:value-of select="SettlementDiscountAtRate"/>
					</SettlementDiscountAtRate>
					<SettlementTotalExclVATAtRate>
						<xsl:value-of select="SettlementTotalExclVATAtRate"/>
					</SettlementTotalExclVATAtRate>
					<VATAmountAtRate>
						<xsl:value-of select="VATAmountAtRate"/>
					</VATAmountAtRate>
					<DocumentTotalInclVATAtRate>
						<xsl:value-of select="DocumentTotalInclVATAtRate"/>
					</DocumentTotalInclVATAtRate>
					<SettlementTotalInclVATAtRate>
						<xsl:value-of select="SettlementTotalInclVATAtRate"/>
					</SettlementTotalInclVATAtRate>
				</VATSubTotal>
			</xsl:for-each>		
		</VATSubTotals>
		<DocumentTotalExclVAT>
			<xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalExclVAT"/>
		</DocumentTotalExclVAT>
		<SettlementDiscount>
			<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementDiscount"/>
		</SettlementDiscount>
		<SettlementTotalExclVAT>
			<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementTotalExclVAT"/>
		</SettlementTotalExclVAT>
		<VATAmount>
			<xsl:value-of select="/Invoice/InvoiceTrailer/VATAmount"/>
		</VATAmount>
		<DocumentTotalInclVAT>
			<xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalInclVAT"/>
		</DocumentTotalInclVAT>
		<SettlementTotalInclVAT>
			<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementTotalInclVAT"/>
		</SettlementTotalInclVAT>	
	</BatchHeader>	
	<BatchDocuments>
		<BatchDocument>
			<Invoice>
				<TradeSimpleHeader>				
					<SendersCodeForRecipient>				
						<xsl:value-of select="/Invoice/TradeSimpleHeader/SendersCodeForRecipient"/>				
					</SendersCodeForRecipient>					
					<xsl:if test="/Invoice/TradeSimpleHeader/SendersBranchReference">
						<SendersBranchReference>	
							<xsl:value-of select="/Invoice/TradeSimpleHeader/SendersBranchReference"/>
						</SendersBranchReference>
					</xsl:if>
					<TestFlag>		
						<xsl:value-of select="/Invoice/TradeSimpleHeader/TestFlag"/>			
					</TestFlag>				
				</TradeSimpleHeader>		
				<InvoiceHeader>				
					<BatchInformation>
						<FileGenerationNo>					
							<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/FileGenerationNo"/>				
						</FileGenerationNo>
						<FileVersionNo>					
							<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/FileVersionNo"/>				
						</FileVersionNo>		
						<FileCreationDate>					
							<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/FileCreationDate"/>				
						</FileCreationDate>							
						<xsl:if test="/Invoice/InvoiceHeader/BatchInformation/SendersTransmissionReference">
							<SendersTransmissionReference>	
								<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/SendersTransmissionReference"/>
							</SendersTransmissionReference>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceHeader/BatchInformation/SendersTransmissionDate">
							<SendersTransmissionDate>	
								<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/SendersTransmissionDate"/>
							</SendersTransmissionDate>	
						</xsl:if>				
					</BatchInformation>				
					<Buyer>				
						<BuyersLocationID>				
							<SuppliersCode>
								<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/>				
							</SuppliersCode>			
						</BuyersLocationID>			
						<BuyersName>
							<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersName"/>
						</BuyersName>
						<BuyersAddress>
							<AddressLine1>
								<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/>
							</AddressLine1>
							<AddressLine2>
								<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/>
							</AddressLine2>
							<AddressLine3>
								<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/>
							</AddressLine3>
							<AddressLine4>
								<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/>
							</AddressLine4>
							<PostCode>
								<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/PostCode"/>
							</PostCode>
						</BuyersAddress>
					</Buyer>			
					<Supplier>
						<SuppliersLocationID>
							<SuppliersCode>
								<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
							</SuppliersCode>
						</SuppliersLocationID>
						<SuppliersName>
							<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersName"/>
						</SuppliersName>
						<SuppliersAddress>
							<AddressLine1>
								<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/>
							</AddressLine1>
							<AddressLine2>
								<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/>
							</AddressLine2>
							<AddressLine3>
								<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/>
							</AddressLine3>
							<AddressLine4>
								<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine4"/>
							</AddressLine4>
							<PostCode>
								<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/PostCode"/>
							</PostCode>
						</SuppliersAddress>
					</Supplier>		
					<ShipTo>
						<ShipToName>
							<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToName"/>
						</ShipToName>
						<ShipToAddress>
							<AddressLine1>
								<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/>
							</AddressLine1>
							<AddressLine2>
								<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/>
							</AddressLine2>
							<AddressLine3>
								<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/>
							</AddressLine3>
							<AddressLine4>
								<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/>
							</AddressLine4>
							<PostCode>
								<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/PostCode"/>
							</PostCode>
						</ShipToAddress>
					</ShipTo>
					<InvoiceReferences>
						<InvoiceReference>
							<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
						</InvoiceReference>
						<InvoiceDate>
							<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
						</InvoiceDate>
						<TaxPointDate>
							<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate"/>
						</TaxPointDate>
						<VATRegNo>
							<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/VATRegNo"/>
						</VATRegNo>
						<CustomerOrderReference>
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/>
						</CustomerOrderReference>
					</InvoiceReferences>
					<Currency>
						<xsl:value-of select="/Invoice/InvoiceHeader/Currency"/>
					</Currency>
				</InvoiceHeader>
				<InvoiceDetail>
					<xsl:for-each select="/Invoice/InvoiceDetail/InvoiceLine">	
					<InvoiceLine>
						<LineNumber>
							<xsl:value-of select="LineNumber"/>
						</LineNumber>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
							</PurchaseOrderDate>
						</PurchaseOrderReferences>
						<DeliveryNoteReferences>
							<DeliveryNoteReference>
								<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
							</DeliveryNoteReference>
							<DeliveryNoteDate>
								<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
							</DeliveryNoteDate>
							<DespatchDate>
								<xsl:value-of select="DeliveryNoteReferences/DespatchDate"/>
							</DespatchDate>
						</DeliveryNoteReferences>
						<ProductID>
							<SuppliersProductCode>
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</SuppliersProductCode>
						</ProductID>
						<ProductDescription>
							<xsl:value-of select="ProductDescription"/>
						</ProductDescription>
						<InvoicedQuantity>
							<xsl:value-of select="InvoicedQuantity"/>
						</InvoicedQuantity>
						<PackSize>
							<xsl:value-of select="PackSize"/>
						</PackSize>
						<UnitValueExclVAT>
							<xsl:value-of select="UnitValueExclVAT"/>
						</UnitValueExclVAT>
						<LineValueExclVAT>
							<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
						</LineValueExclVAT>
						<VATCode>
							<xsl:value-of select="VATCode"/>
						</VATCode>
						<VATRate>
							<xsl:value-of select="VATRate"/>
						</VATRate>
						<Measure>
							<UnitsInPack>
								<xsl:value-of select="Measure/UnitsInPack"/>
							</UnitsInPack>
						</Measure>
					</InvoiceLine>
					</xsl:for-each>						
				</InvoiceDetail>
				<InvoiceTrailer>
					<NumberOfLines>
						<xsl:value-of select="/Invoice/InvoiceTrailer/NumberOfLines"/>
					</NumberOfLines>
					<NumberOfItems>
						<xsl:value-of select="/Invoice/InvoiceTrailer/NumberOfItems"/>
					</NumberOfItems>
					<NumberOfDeliveries>
						<xsl:value-of select="/Invoice/InvoiceTrailer/NumberOfDeliveries"/>
					</NumberOfDeliveries>
					<VATSubTotals>
					<xsl:for-each select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal">	
						<VATSubTotal>
							<xsl:attribute name="VATCode">
								<xsl:value-of select = "@VATCode"/>
							</xsl:attribute>
							<xsl:attribute name="VATRate">
								<xsl:value-of select = "@VATRate"/>
							</xsl:attribute>					
							<NumberOfLinesAtRate>
								<xsl:value-of select="NumberOfLinesAtRate"/>
							</NumberOfLinesAtRate>
							<NumberOfItemsAtRate>
								<xsl:value-of select="NumberOfItemsAtRate"/>
							</NumberOfItemsAtRate>
							<DocumentTotalExclVATAtRate>
								<xsl:value-of select="DocumentTotalExclVATAtRate"/>
							</DocumentTotalExclVATAtRate>
							<SettlementDiscountAtRate>
								<xsl:value-of select="SettlementDiscountAtRate"/>
							</SettlementDiscountAtRate>
							<SettlementTotalExclVATAtRate>
								<xsl:value-of select="SettlementTotalExclVATAtRate"/>
							</SettlementTotalExclVATAtRate>
							<VATAmountAtRate>
								<xsl:value-of select="VATAmountAtRate"/>
							</VATAmountAtRate>
							<DocumentTotalInclVATAtRate>
								<xsl:value-of select="DocumentTotalInclVATAtRate"/>
							</DocumentTotalInclVATAtRate>
							<SettlementTotalInclVATAtRate>
								<xsl:value-of select="SettlementTotalInclVATAtRate"/>
							</SettlementTotalInclVATAtRate>
						</VATSubTotal>
					</xsl:for-each>		
					</VATSubTotals>
					<DocumentTotalExclVAT>
						<xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalExclVAT"/>
					</DocumentTotalExclVAT>
					<SettlementDiscount>
						<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementDiscount"/>
					</SettlementDiscount>
					<SettlementTotalExclVAT>
						<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementTotalExclVAT"/>
					</SettlementTotalExclVAT>
					<VATAmount>
						<xsl:value-of select="/Invoice/InvoiceTrailer/VATAmount"/>
					</VATAmount>
					<DocumentTotalInclVAT>
						<xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalInclVAT"/>
					</DocumentTotalInclVAT>
					<SettlementTotalInclVAT>
						<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementTotalInclVAT"/>
					</SettlementTotalInclVAT>
				</InvoiceTrailer>
			</Invoice>
		</BatchDocument>
	</BatchDocuments>
</Batch>

</xsl:template>

</xsl:stylesheet>
