<?xml version="1.0" encoding="UTF-8"?>
<!--
'*************************************************************************************
Maps iXML credit notes into OFSCI format for iTN (Compass).
**************************************************************************************
Name			| Date 				|	Description
**************************************************************************************
J Miguel		| 19/05/2016	| FB11000 - Fixes
**************************************************************************************
J Miguel		| 25/05/2016	| FB11028 - Adding support for more units of measure
**************************************************************************************
J Miguel		| 25/05/2016	| FB11037  - Fix the name of the template
**************************************************************************************-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
				xmlns="http://www.eanucc.org/2002/Pay/FoodService/FoodService/UK/EanUcc/Pay"
				xmlns:cc="http://www.ean-ucc.org/2002/gsmp/schemas/CoreComponents" 
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				exclude-result-prefixes="fo script msxsl">
	<xsl:output method="xml" encoding="utf-8"/>
	<xsl:template match="/">

		<!--FB 6617 Generic Variables-->
		<xsl:variable name="CPM" select="'CPM'"/>
		<xsl:variable name="NF" select="'NF'"/>
		<xsl:variable name="accountCode" select="string(/CreditNote/TradeSimpleHeader/RecipientsCodeForSender)"/>		
		<xsl:variable name="Supplier">
			<xsl:choose>
				<xsl:when test="$accountCode = 'CAMPBELLS'">
					<xsl:value-of select="$CPM"/>
				</xsl:when>
				<xsl:when test="$accountCode = '5060166761097'">
					<xsl:value-of select="$NF"/>
				</xsl:when>
				
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<!-- FB 6617 end ****************************** -->	
	
		<CreditNote>
			<xsl:attribute name="xsi:schemaLocation">
				<xsl:text>http://www.eanucc.org/2002/Pay/FoodService/FoodService/UK/EanUcc/Pay X:\HOME\COMMON\projects\TSFOOD~1\ebXML\Invoice\0.9\CreditNote0.9.xsd</xsl:text>
			</xsl:attribute>
			<CreditNoteDocumentDetails>
				<CreditNoteDocumentDate format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>T00:00:00</CreditNoteDocumentDate>
				<CreditNoteDocumentNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/></CreditNoteDocumentNumber>
				<DocumentStatus codeList="EANCOM">
					<xsl:choose>
						<xsl:when test="/CreditNote/CreditNoteHeader/DocumentStatus = 'Original'">9</xsl:when>
						<xsl:otherwise>7</xsl:otherwise>
					</xsl:choose>
				</DocumentStatus>
			</CreditNoteDocumentDetails>
			<xsl:if test="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference and /CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate">
				<InvoiceReference>
					<InvoiceDocumentDate format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate"/>T00:00:00</InvoiceDocumentDate>
					<InvoiceDocumentNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference"/></InvoiceDocumentNumber>
				</InvoiceReference>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Supplier = $CPM">
					<TradeAgreementReference>
						<ContractReferenceNumber scheme="GTIN">NET</ContractReferenceNumber>
					</TradeAgreementReference>
				</xsl:when>
				<xsl:when test="$Supplier = $NF">
					<TradeAgreementReference>
						<ContractReferenceDate format="YYYY-MM-DDThh:mm:ss:TZD">2001-12-17T09:30:47</ContractReferenceDate>
						<ContractReferenceNumber scheme="OTHER">CG34</ContractReferenceNumber>
					</TradeAgreementReference>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement/ContractReference">
						<TradeAgreementReference>
							<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement/ContractDate">
								<ContractReferenceDate format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement/ContractDate"/>T00:00:00</ContractReferenceDate>
							</xsl:if>
							<ContractReferenceNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement/ContractReference"/></ContractReferenceNumber>
						</TradeAgreementReference>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderReference">
				<OrderReference>
					<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderDate">
						<PurchaseOrderDate format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>T00:00:00</PurchaseOrderDate>
					</xsl:if>
					<PurchaseOrderNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/></PurchaseOrderNumber>
				</OrderReference>
			</xsl:if>
			<OrderConfirmationReference>
				<xsl:choose>
					<xsl:when test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference">
						<PurchaseOrderConfirmationDate format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>T00:00:00</PurchaseOrderConfirmationDate>
						<PurchaseOrderConfirmationNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/></PurchaseOrderConfirmationNumber>				
					</xsl:when>
					<xsl:otherwise>
						<PurchaseOrderConfirmationDate format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>T00:00:00</PurchaseOrderConfirmationDate>
						<PurchaseOrderConfirmationNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/></PurchaseOrderConfirmationNumber>				
					</xsl:otherwise>
				</xsl:choose>
			</OrderConfirmationReference>				
			<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteReference">
				<DespatchReference>
					<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate">
						<DespatchDocumentDate format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>T00:00:00</DespatchDocumentDate>
					</xsl:if>
					<DespatchDocumentNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/></DespatchDocumentNumber>
				</DespatchReference>
			</xsl:if>
			
			<ReceiptAdviceReference>
				<xsl:choose>
					<xsl:when test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteReference">
						<ReceiptAdviceDocumentDate format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>T00:00:00</ReceiptAdviceDocumentDate>
						<ReceiptAdviceDocumentNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/></ReceiptAdviceDocumentNumber>
					</xsl:when>
					<xsl:otherwise>
						<ReceiptAdviceDocumentDate format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>T00:00:00</ReceiptAdviceDocumentDate>
						<ReceiptAdviceDocumentNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/></ReceiptAdviceDocumentNumber>
					</xsl:otherwise>
				</xsl:choose>
			</ReceiptAdviceReference>
			
			<Buyer>
				<BuyerGLN scheme="GLN"><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/GLN"/></BuyerGLN>
				<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/></BuyerAssigned>
				</xsl:if>
				<Address>
					<BuildingIdentifier scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine1"/></BuildingIdentifier>
					<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2">
						<StreetName scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2"/></StreetName>
					</xsl:if>
					<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3">
						<City scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3"/></City>
					</xsl:if>
					<PostCode scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/PostCode"/></PostCode>
					<Country codeList="ISO">GB</Country>
				</Address>
			</Buyer>
			<Seller>
				<SellerGLN scheme="GLN"><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/></SellerGLN>
				<!-- FB 6617 Sellers code for seller originates from a different field in Campbells invoices -->
				<xsl:choose>
					<xsl:when test="$Supplier = $CPM">
						<SellerAssigned scheme="OTHER"><xsl:value-of select="/CreditNote/TradeSimpleHeader/RecipientsCodeForSender"/></SellerAssigned>
						<BuyerAssigned scheme="OTHER"><xsl:text>52565</xsl:text></BuyerAssigned>
					</xsl:when>
					<xsl:when test="$Supplier = $NF">
						<SellerAssigned scheme="OTHER">
							<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersName"/>
						</SellerAssigned>
						<BuyerAssigned scheme="OTHER">
							<xsl:text>55099</xsl:text>
						</BuyerAssigned>
					</xsl:when>					
					<xsl:otherwise>
						<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
							<SellerAssigned scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/></SellerAssigned>
						</xsl:if>
						<xsl:if test="/CreditNote/TradeSimpleHeader/RecipientsCodeForSender">
							<BuyerAssigned scheme="OTHER"><xsl:value-of select="/CreditNote/TradeSimpleHeader/RecipientsCodeForSender"/></BuyerAssigned>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>

				<Address>
					<BuildingIdentifier scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1"/></BuildingIdentifier>
					<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2">
						<StreetName scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2"/></StreetName>
					</xsl:if>
					<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3">
						<City scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3"/></City>
					</xsl:if>
					<PostCode scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/PostCode"/></PostCode>
					<Country codeList="ISO">GB</Country>
				</Address>
				<VATRegisterationNumber scheme="OTHER"><xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/VATRegNo"/></VATRegisterationNumber>
			</Seller>
			<ShipTo>
				<ShipToGLN scheme="GLN"><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/GLN"/></ShipToGLN>
				<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:choose>
							<xsl:when test="substring-after(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode, '|')">
								<xsl:value-of select="substring-after(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode, '|')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
							</xsl:otherwise>
						</xsl:choose>
					</BuyerAssigned>
				</xsl:if>
				<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:choose>
							<xsl:when test="substring-before(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode, '|')">
								<xsl:value-of select="substring-before(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode, '|')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
							</xsl:otherwise>
						</xsl:choose>
					</SellerAssigned>
				</xsl:if>
			</ShipTo>
			<TaxPointDateTime format="YYYY-MM-DDThh:mm:ss:TZD"><xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate"/>T00:00:00</TaxPointDateTime>
			<xsl:for-each select="/CreditNote/CreditNoteDetail/CreditNoteLine">
				<xsl:sort select="LineNumber"/>
				<CreditItem>
					<xsl:if test="Narrative/@Code">
						<xsl:attribute name="ChangeReasonCoded"><xsl:value-of select="Narrative/@Code"/></xsl:attribute>
					</xsl:if>
					<LineItemNumber scheme="OTHER"><xsl:value-of select="LineNumber"/></LineItemNumber>
					<ItemIdentifier>
						<GTIN scheme="GTIN"><xsl:value-of select="ProductID/GTIN"/></GTIN>
						<xsl:if test="ProductID/SuppliersProductCode">
							<AlternateCode scheme="OTHER"><xsl:value-of select="ProductID/SuppliersProductCode"/></AlternateCode>
						</xsl:if>
					</ItemIdentifier>
					<InvoiceQuantity>
						<xsl:choose>
							<xsl:when test="InvoicedQuantity">
								<xsl:attribute name="unitCode">
									<xsl:call-template name="translateUoM">
										<xsl:with-param name="UOM" select="InvoicedQuantity/@UnitOfMeasure"/>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:value-of select="format-number(InvoicedQuantity, '0.000')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="unitCode">EA</xsl:attribute>
								<xsl:text>0.000</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</InvoiceQuantity>
					<xsl:if test="CreditedQuantity">
						<CreditQuantity>
							<xsl:attribute name="unitCode">
								<xsl:call-template name="translateUoM">
									<xsl:with-param name="UOM" select="CreditedQuantity/@UnitOfMeasure"/>
								</xsl:call-template>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="number(LineValueExclVAT) >= 0"><xsl:value-of select="format-number(CreditedQuantity, '0.000')"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="format-number(CreditedQuantity * -1, '0.000')"/></xsl:otherwise>
							</xsl:choose>
						</CreditQuantity>
					</xsl:if>
					<UnitPrice Amount="GBP"><xsl:value-of select="format-number(UnitValueExclVAT, '0.00')"/></UnitPrice>
					<LineItemPrice Amount="GBP">
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) >= 0"><xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="format-number(LineValueExclVAT * -1, '0.00')"/></xsl:otherwise>
						</xsl:choose>
					</LineItemPrice>
					<LineItemDiscount>
						<DiscountValue Amount="GBP">
							<xsl:choose>
								<xsl:when test="LineDiscountValue != ''">
									<xsl:value-of select="format-number(LineDiscountValue, '0.00')"/>
								</xsl:when>
								<xsl:otherwise>0.00</xsl:otherwise>
							</xsl:choose>
						</DiscountValue>
						<DiscountRate>
							<xsl:attribute name="Format">PERCENT</xsl:attribute>
							<xsl:choose>
								<xsl:when test="LineDiscountRate != ''">
									<xsl:value-of select="format-number(LineDiscountRate, '0.00')"/>
								</xsl:when>
								<xsl:otherwise>0.00</xsl:otherwise>
							</xsl:choose>
						</DiscountRate>
					</LineItemDiscount>
					<xsl:if test="VATRate">
						<VATDetails>
							<xsl:if test="VATCode">
								<TaxCategory codeList="EANCOM"><xsl:value-of select="VATCode"/></TaxCategory>
							</xsl:if>
							<TaxRate Format="PERCENT"><xsl:value-of select="format-number(VATRate, '0.00')"/></TaxRate>
						</VATDetails>
					</xsl:if>
					<CreditLineIndicator codeList="OFSCI">
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) &lt; 0">1</xsl:when>
							<xsl:otherwise>2</xsl:otherwise>
						</xsl:choose>
					</CreditLineIndicator>
				</CreditItem>
			</xsl:for-each>
			<CreditTotals>
				<DocumentDiscountRate Format="PERCENT"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentDiscountRate, '0.00')"/></DocumentDiscountRate>
				<SettlementDiscountRate Format="PERCENT"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementDiscountRate, '0.00')"/></SettlementDiscountRate>
				<xsl:for-each select="/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal">
					<VATRateTotals>
						<VATDetails>
							<TaxCategory codeList="EANCOM"><xsl:value-of select="@VATCode"/></TaxCategory>
							<TaxRate Format="PERCENT"><xsl:value-of select="format-number(@VATRate, '0.00')"/></TaxRate>
						</VATDetails>
						<DiscountedLineTotals Amount="GBP"><xsl:value-of select="format-number(DiscountedLinesTotalExclVATAtRate, '0.00')"/></DiscountedLineTotals>
						<DocumentDiscountValue Amount="GBP"><xsl:value-of select="format-number(DocumentDiscountAtRate, '0.00')"/></DocumentDiscountValue>
						<SettlementDiscountValue Amount="GBP"><xsl:value-of select="format-number(SettlementDiscountAtRate, '0.00')"/></SettlementDiscountValue>
						<TaxableAmount Amount="GBP"><xsl:value-of select="format-number(SettlementTotalExclVATAtRate, '0.00')"/></TaxableAmount>
						<VATPayable Amount="GBP"><xsl:value-of select="format-number(VATAmountAtRate, '0.00')"/></VATPayable>
					</VATRateTotals>
				</xsl:for-each>
				<SettlementSubTotal Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementTotalExclVAT, '0.00')"/></SettlementSubTotal>
				<CreditNoteSubTotal Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentTotalExclVAT, '0.00')"/></CreditNoteSubTotal>
				<VATTotal Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/VATAmount, '0.00')"/></VATTotal>
				<SettlementCreditTotal Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementTotalInclVAT, '0.00')"/></SettlementCreditTotal>
				<TotalPayable Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentTotalInclVAT, '0.00')"/></TotalPayable>
			</CreditTotals>
		</CreditNote>
	</xsl:template>
	<xsl:template name="translateUoM">
		<xsl:param name="UOM"/>
			<xsl:choose>
				<xsl:when test="$UOM='CS'"><xsl:text>BOX</xsl:text></xsl:when>
				<xsl:when test="$UOM='PF'"><xsl:text>PK</xsl:text></xsl:when>
				<xsl:when test="$UOM='HUR'"><xsl:text>HR</xsl:text></xsl:when>
				<xsl:when test="$UOM='KGM'"><xsl:text>KG</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>EA</xsl:text></xsl:otherwise>
			</xsl:choose>
	</xsl:template>	
</xsl:stylesheet>
