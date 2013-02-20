<?xml version="1.0" encoding="UTF-8"?>
<!--
	===================================================================
	Hospitality Invoice Mapper for inbound OFSCI format.
	
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Date:			|	Name:				|	Changes:
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	04 Aug 2006	|	Nigel Emsen		|	Created from Hosp Invoice Schema
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	===================================================================

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="xml"/> 
	
	<!-- document level flag of type -->
	<xsl:variable name="msDocTypeFlag">
		<xsl:choose>
			<!-- its an invoice -->
			<xsl:when test="/Invoice">
				<xsl:text>INVOICE</xsl:text>
			</xsl:when>
			
			<!-- it must be a credit note -->
			<xsl:otherwise>
				<xsl:text>CREDIT_NOTE</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:variable>
	
	<!-- document level constant -->
	<xsl:variable name="INVOICE_FLAG">
		<xsl:text>INVOICE</xsl:text>
	</xsl:variable>
	
	<!-- document level constant -->
	<xsl:variable name="CREDIT_FLAG">
		<xsl:text>CREDIT_NOTE</xsl:text>
	</xsl:variable>
	
	<!--
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Extract and Build final output
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->		
	<xsl:template match="*">
	
		<Document>
		
			<xsl:choose>
			
				<!-- It is an Invoice -->
				<xsl:when test="$msDocTypeFlag = $INVOICE_FLAG">
				
					<Invoice>
			
						<!-- Add Tradesimple header -->
						<xsl:call-template name="BuildTradeSimpleHeader"/>

						<!-- Add invoice header -->
						<xsl:call-template name="BuildInvoiceHeader"/>
				
						<!-- Add invoice details -->
						<xsl:call-template name="BuildInvoiceDetail"/>
				
						<!-- Add Invoice document trailer -->
						<xsl:call-template name="BuildInvoiceTrailer"/>
				
					</Invoice>
								
				</xsl:when>
				
				<!-- It is a Credit Note -->
				<xsl:otherwise>
				
					<CreditNote>
				
						<!-- Add Tradesimple header -->
						<xsl:call-template name="BuildTradeSimpleHeader"/>				
					
					</CreditNote>		
				
				</xsl:otherwise>
			</xsl:choose>
	
		</Document>
	
	</xsl:template>
	
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Build TradeSimple Header
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->		
	<xsl:template name="BuildTradeSimpleHeader">
	
		<!-- TradeSimpleHeader -->
		<TradeSimpleHeader>

			<xsl:call-template name="BuildSendersDetails"/>	
					
			<xsl:call-template name="BuildRecipientsDetails"/>	

	</TradeSimpleHeader>
	
	</xsl:template>
	
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get Senders Details
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->	
	<xsl:template name="BuildSendersDetails">
	
			<!--SendersCodeForRecipient -->
			<SendersCodeForRecipient>
				<xsl:value-of select="//Seller/SellerGLN[@scheme='GLN']"/>
			</SendersCodeForRecipient>
			
			<!-- SendersBranchReference -->
			<xsl:if test="string(//ShipTo/ShipToGLN[@scheme='GLN']) != '' ">
				<SendersBranchReference>
					<xsl:value-of select="//ShipTo/ShipToGLN[@scheme='GLN']"/>
				</SendersBranchReference>
			</xsl:if>
		
			<!-- SendersName -->
			<xsl:if test="string(//Seller/SellerAssigned) != '' ">
				<SendersName>
					<xsl:value-of select="//Seller/SellerAssigned"/>
				</SendersName>
			</xsl:if>
		
			<!-- SendersAddress -->
			<xsl:if test="string(//Seller/Address/BuildingIdentifier) !='' ">
				<SendersAddress>
				
					<!-- get Sellers address block -->
					<xsl:call-template name="GetSellersAddressBlock"/>
								
				</SendersAddress>
			</xsl:if>	
	
	</xsl:template>
	
	
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get Recipients Details
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->	
	<xsl:template name="BuildRecipientsDetails">
	
			<!-- RecipientsName -->
			<xsl:if test="string(//Buyer/BuyerAssigned) != '' ">
				<RecipientsName>
					<xsl:value-of select="//Buyer/BuyerAssigned"/>
				</RecipientsName>
			</xsl:if>
		
			<!-- RecipientsAddress -->
			<xsl:if test="string(//Buyer/Address/BuildingIdentifier) !='' ">
				<RecipientsAddress>
				
					<!-- Get Buyers address block -->
					<xsl:call-template name="GetBuyersAddressBlock"/>

				</RecipientsAddress>
				
			</xsl:if>	
	
	</xsl:template>

	
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Build Invoice Header
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->		
	<xsl:template name="BuildInvoiceHeader">
	
		<InvoiceHeader>
		
			<!-- DocumentStatus -->
			<xsl:if test="string(//InvoiceDocumentDetails/DocumentStatus/@codeList)">
				<DocumentStatus>
					<xsl:value-of select="//InvoiceDocumentDetails/DocumentStatus/@codeList"/>
				</DocumentStatus>
			</xsl:if>
		
			<!-- Get BatchInformation -->
			<xsl:call-template name="GetBatchInformation"/>
			
			<!-- Get Buyer Details -->
			<xsl:call-template name="GetBuyerDetails"/>
		
			<!-- Get Seller Details -->
			<xsl:call-template name="GetSellerDetails"/>
			
			<!-- Get Supplier details -->
			<xsl:call-template name="GetSupplierDetails"/>
		
			<!-- Get Ship To details -->
			<xsl:call-template name="GetShipToDetails"/>
		
			<!-- Get invoice references -->
			<xsl:call-template name="GetInvoiceReferences"/>
		
		</InvoiceHeader>

	</xsl:template>
	
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Build Invoice Detail
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->		
	<xsl:template name="BuildInvoiceDetail">
	
		<!-- InvoiceDetail -->
		<InvoiceDetail>
		
			<xsl:for-each select="/Invoice/InvoiceItem">
			
				<InvoiceLine>
				
					<!-- LineNumber -->
					<LineNumber>
						<xsl:value-of select="LineItemNumber"/>
					</LineNumber>
					
					<!-- PurchaseOrderReferences -->
					<PurchaseOrderReferences>
					
						<!-- PurchaseOrderReference -->
						<PurchaseOrderReference>
							<xsl:value-of select="//OrderReference/PurchaseOrderNumber"/>
						</PurchaseOrderReference>
				
						<!-- currently not in the example document 
						<PurchaseOrderDate/> -->
				
					</PurchaseOrderReferences>
			
					<!-- ProductID -->
					<ProductID>
					
						<!-- GTIN -->
						<xsl:if test="string(ItemIdentifier/GTIN[@scheme='GTIN']) != '' ">
							<GTIN>
								<xsl:value-of select="ItemIdentifier/GTIN[@scheme='GTIN']"/>
							</GTIN>
						</xsl:if>
						
						<!-- SuppliersProductCode -->
						<xsl:if test="string(ItemIdentifier/AlternateCode[@scheme='OTHER']) !='' ">
							<SuppliersProductCode>
								<xsl:value-of select="ItemIdentifier/AlternateCode[@scheme='OTHER']"/>
							</SuppliersProductCode>
						</xsl:if>
				
					</ProductID>
			
					<!-- ProductDescription -->
					<ProductDescription>
						<xsl:text>{Not Provided}</xsl:text>
					</ProductDescription>
					
					<!-- InvoicedQuantity -->
					<InvoicedQuantity>
						<xsl:value-of select="format-number(InvoiceQuantity,'0')"/>
					</InvoicedQuantity>

					<!-- UnitValueExclVAT -->
					<UnitValueExclVAT>
						<xsl:value-of select="format-number(UnitPrice,'#0.0000')"/>
					</UnitValueExclVAT>
			
					<!-- LineValueExclVAT -->
					<LineValueExclVAT>
						<xsl:value-of select="format-number(LineItemPrice,'#0.00')"/>
					</LineValueExclVAT>
					
					<!-- LineDiscountRate -->
					<LineDiscountRate>
						<xsl:value-of select="format-number(LineItemDiscount/DiscountValue,'0.000')"/>
					</LineDiscountRate>
			
					<!-- VATRate -->
					<VATRate>
						<xsl:value-of select="format-number(VATDetails/TaxRate[@Format='PERCENT'],'#0.000')"/>
					</VATRate>
			
				</InvoiceLine>
		
			</xsl:for-each>
		
		</InvoiceDetail>	
	
	</xsl:template>

	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get the Batch Information
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->	
	<xsl:template name="GetBatchInformation">
	
		<!-- 
		<BatchInformation>
			<FileGenerationNo>xx</FileGenerationNo>
			<FileVersionNo>xx</FileVersionNo>
			<FileCreationDate>1967-08-13</FileCreationDate>
			<RecipientsTransmissionReference>xx</RecipientsTransmissionReference>
			<RecipientsTransmissionDate>2001-12-17T09:30:47-05:00</RecipientsTransmissionDate>
		</BatchInformation>
		-->
		
	</xsl:template>
	
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get the Buyers Information
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->		
	<xsl:template name="GetBuyerDetails">
	
		<!-- Buyer -->
		<Buyer>
		
			<!-- BuyersLocationID -->
			<BuyersLocationID>
			
				<!-- GLN -->
				<GLN>
					<xsl:value-of select="//Buyer/BuyerGLN[@scheme='GLN']"/>
				</GLN>
				
				<!-- BuyersCode -->
				<BuyersCode>
					<xsl:value-of select="//Buyer/BuyerAssigned"/>
				</BuyersCode>
				
				<!-- SuppliersCode -->
				<SuppliersCode>
					<xsl:value-of select="//Buyer/SellerAssigned"/>				
				</SuppliersCode>
				
			</BuyersLocationID>
			
			<!-- Buyers Name -->
			<BuyersName>
				<xsl:value-of select="//Buyer/BuyerAssigned"/>
			</BuyersName>
			
			<!-- Buyers Address -->
			<BuyersAddress>
				
				<!-- Get Buyers address block -->
				<xsl:call-template name="GetBuyersAddressBlock"/>
				
			</BuyersAddress>
			
		</Buyer>
	
	</xsl:template>
			
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get the Sellers Information
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->		
	<xsl:template name="GetSellerDetails">
	
		<!-- Seller -->
		<Seller>
		
			<!-- SellersLocationID -->
			<SellersLocationID>
			
				<!-- GLN -->
				<GLN>
					<xsl:value-of select="//Seller/SellerGLN[@scheme='GLN']"/>
				</GLN>
				
				<!-- SellersCode -->
				<BuyersCode>
					<xsl:value-of select="//Seller/BuyerAssigned"/>
				</BuyersCode>
				
				<!-- SellersCode -->
				<SellersCode>
					<xsl:value-of select="//Seller/SellerAssigned"/>				
				</SellersCode>
				
			</SellersLocationID>
			
			<!-- Sellers Name -->
			<SellersName>
				<xsl:value-of select="//Seller/SellerAssigned"/>
			</SellersName>
			
			<!-- Sellers Address -->
			<SellersAddress>
				
				<!-- get Sellers address block -->
				<xsl:call-template name="GetSellersAddressBlock"/>
								
			</SellersAddress>
			
		</Seller>
		
	</xsl:template>
	
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get the ship to details.
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->
	<xsl:template name="GetShipToDetails">
	
		<!-- ShipTo -->
		<ShipTo>
		
			<!-- Ship To Location ID -->
			<ShipToLocationID>
			
				<!-- GLN -->
				<xsl:if test="string(//ShipTo/ShipToGLN[@scheme='GLN']) != '' ">
					<GLN>
						<xsl:value-of select="//ShipTo/ShipToGLN[@scheme='GLN']"/>
					</GLN>
				</xsl:if>
				
				<!-- Buyers Code -->
				<xsl:if test="string(//ShipTo/BuyerAssigned) != '' ">
					<BuyersCode>
						<xsl:value-of select="//ShipTo/BuyerAssigned"/>
					</BuyersCode>
				</xsl:if>
				
				<!-- SuppliersCode -->
				<xsl:if test="string(//ShipTo/SellerAssigned) != '' ">
					<SuppliersCode>
						<xsl:value-of select="//ShipTo/SellerAssigned"/>
					</SuppliersCode>
				</xsl:if>
				
			</ShipToLocationID>
			
		</ShipTo>
	
	</xsl:template>
	
	<!--
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get the invoice reference
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->	
	<xsl:template name="GetInvoiceReferences">
	
		<!-- Invoice References -->
		<InvoiceReferences>
		
			<!-- Invoice Reference -->
			<xsl:if test="string(//InvoiceDocumentDetails/InvoiceDocumentNumber) != '' ">
				<InvoiceReference>
					<xsl:value-of select="//InvoiceDocumentDetails/InvoiceDocumentNumber"/>
				</InvoiceReference>
			</xsl:if>
			
			<!-- InvoiceDate -->
			<xsl:if test="string(//InvoiceDocumentDetails/InvoiceDocumentDate) != '' ">
				<InvoiceDate>		
					<xsl:call-template name="msFormatDate">				
						<xsl:with-param name="sDate" select="//InvoiceDocumentDetails/InvoiceDocumentDate"/>				
					</xsl:call-template>		
				</InvoiceDate>
			</xsl:if>
			
			<!-- TaxPointDate -->
			<xsl:if test="string(//TaxPointDateTime) != '' ">
				<TaxPointDate>
					<xsl:call-template name="msFormatDate">				
						<xsl:with-param name="sDate" select="//TaxPointDateTime"/>				
					</xsl:call-template>		
				</TaxPointDate>
			</xsl:if>
	
			<!-- VATRegNo -->	
			<xsl:if test="string(//Seller/VATRegisterationNumber) != '' ">
				<VATRegNo>
					<xsl:value-of select="translate(//Seller/VATRegisterationNumber,' ','')"/>
				</VATRegNo>
			</xsl:if>	
		
		</InvoiceReferences>
	
	</xsl:template>
	
	<!--
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get the invoice reference
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->	
	<xsl:template name="GetSupplierDetails">
	
		<!-- Supplier -->
		<Supplier>
		
			<!-- SuppliersLocationID -->
			<SuppliersLocationID>
			
				<!-- GLN -->
				<GLN>
					<xsl:value-of select="//Seller/SellerGLN[@scheme='GLN']"/>
				</GLN>
				
				<!-- SellersCode -->
				<BuyersCode>
					<xsl:value-of select="//Seller/BuyerAssigned"/>
				</BuyersCode>
				
				<!-- SellersCode -->
				<SuppliersCode>
					<xsl:value-of select="//Seller/SellerAssigned"/>				
				</SuppliersCode>

			</SuppliersLocationID>
			
			<!-- SuppliersName -->
			<SuppliersName>
				<xsl:value-of select="//Seller/SellerAssigned"/>
			</SuppliersName>
			
			<!-- SuppliersAddress -->
			<SuppliersAddress>
			
				<!-- get Sellers address block -->
				<xsl:call-template name="GetSellersAddressBlock"/>
				
			</SuppliersAddress>
			
		</Supplier>
	
	</xsl:template>
	
	
	<!--
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get the SELLERS address block
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->	
	<xsl:template name="GetSellersAddressBlock">
	
				<!-- Address Line 1 -->
				<AddressLine1>
					<xsl:value-of select="//Seller/Address/BuildingIdentifier"/>
				</AddressLine1>
				
				<!-- Address Line 2 -->
				<xsl:if test="string(//Seller/Address/StreetName) != '' ">
					<AddressLine2>
						<xsl:value-of select="//Seller/Address/StreetName"/>
					</AddressLine2>
				</xsl:if>
				
				<!-- Address Line 3 -->
				<xsl:if test="string(//Seller/Address/City) != '' ">
					<AddressLine3>
						<xsl:value-of select="//Seller/Address/City"/>
					</AddressLine3>
				</xsl:if>
				
				<!-- Address Line 4 -->
				<xsl:if test="string(//Seller/Address/Country) != '' ">
					<AddressLine4>
						<xsl:value-of select="//Seller/Address/Country"/>
					</AddressLine4>
				</xsl:if>
				
				<!-- Post Code -->
				<PostCode>
					<xsl:value-of select="//Seller/Address/PostCode"/>
				</PostCode>
	
	</xsl:template>
	
	<!--
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Get the Buyers Address Block
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->
	<xsl:template name="GetBuyersAddressBlock">
	
				<!-- Address Line 1 -->
				<AddressLine1>
					<xsl:value-of select="//Buyer/Address/BuildingIdentifier"/>
				</AddressLine1>
				
				<!-- Address Line 2 -->
				<xsl:if test="string(//Buyer/Address/StreetName) != '' ">
					<AddressLine2>
						<xsl:value-of select="//Buyer/Address/StreetName"/>
					</AddressLine2>
				</xsl:if>
				
				<!-- Address Line 3 -->
				<xsl:if test="string(//Buyer/Address/City) != '' ">
					<AddressLine3>
						<xsl:value-of select="//Buyer/Address/City"/>
					</AddressLine3>
				</xsl:if>
				
				<!-- Address Line 4 -->
				<xsl:if test="string(//Buyer/Address/Country) != '' ">
					<AddressLine4>
						<xsl:value-of select="//Buyer/Address/Country"/>
					</AddressLine4>
				</xsl:if>
				
				<!-- Post Code -->
				<PostCode>
					<xsl:value-of select="//Buyer/Address/PostCode"/>
				</PostCode>
	
	</xsl:template>
	
		
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Build Document Trailer
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->	
	<xsl:template name="BuildInvoiceTrailer">
	
		<!-- InvoiceTrailer -->
		<InvoiceTrailer>
		
			<!-- NumberOfLines -->
			<NumberOfLines>
				<xsl:value-of select="count(/Invoice/InvoiceItem)"/>
			</NumberOfLines>
			
			<!-- NumberOfItems -->
			<NumberOfItems>
				<xsl:value-of select="sum(/Invoice/InvoiceItem/InvoiceQuantity)"/>	
			</NumberOfItems>
		
			<!-- VATSubTotals -->
			<VATSubTotals>
		
				<xsl:for-each select="/Invoice/InvoiceTotals/VATRateTotals">
			
					<!-- VATSubTotal -->
					<VATSubTotal>
					
						<!-- DiscountedLinesTotalExclVATAtRate -->
						<DiscountedLinesTotalExclVATAtRate>
							<xsl:value-of select="DiscountedLineTotals"/>
						</DiscountedLinesTotalExclVATAtRate>
				
						<!-- DocumentDiscountAtRate -->
						<DocumentDiscountAtRate>
							<xsl:value-of select="DocumentDiscountValue"/>
						</DocumentDiscountAtRate>
				
						<!-- SettlementDiscountAtRate -->
						<SettlementDiscountAtRate>
							<xsl:value-of select="SettlementDiscountValue"/>
						</SettlementDiscountAtRate>
				
						<!--VATAmountAtRate -->
						<VATAmountAtRate>
							<xsl:value-of select="VATPayable"/>
						</VATAmountAtRate>
				
					</VATSubTotal>
			
				</xsl:for-each>
			
			</VATSubTotals>
		
			<!-- DocumentTotalExclVAT -->
			<DocumentTotalExclVAT>
				<xsl:value-of select="/Invoice/InvoiceTotals/InvoiceSubTotal"/>
			</DocumentTotalExclVAT>
		
			<!-- SettlementTotalExclVAT -->
			<SettlementTotalExclVAT>
				<xsl:value-of select="/Invoice/InvoiceTotals/SettlementSubTotal"/>
			</SettlementTotalExclVAT>
		
			<!-- VATAmount -->
			<VATAmount>
				<xsl:value-of select="/Invoice/InvoiceTotals/VATTotal"/>
			</VATAmount>
		
			<!-- DocumentTotalInclVAT -->
			<DocumentTotalInclVAT>
				<xsl:value-of select="/Invoice/InvoiceTotals/TotalPayable"/>
			</DocumentTotalInclVAT>
		
			<!-- SettlementTotalInclVAT -->
			<SettlementTotalInclVAT>
				<xsl:value-of select="/Invoice/InvoiceTotals/SettlementInvoiceTotal"/>
			</SettlementTotalInclVAT>
		
		</InvoiceTrailer>
	
	</xsl:template>
	
	
	<!-- 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			FUNCTION: Extract Date
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-->
	<xsl:template name="msFormatDate">
	
		<xsl:param name="sDate" select="sDate"/>
		
		<xsl:value-of select="substring($sDate,1,10)"/>

	</xsl:template>
	
	
	
</xsl:stylesheet>

	
	
