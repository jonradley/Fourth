<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2009-08-11		| 2991 Created Module
**********************************************************************
R Cambridge	| 2011-10-05		| 4992 Only identify buyer and site with buyer's codes (suppliers codes now have baVel ID prefixed to them)
**********************************************************************
				|						|
**********************************************************************
				|						|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="ISO-8859-1"/>
	
	<xsl:variable name="SITE_CODE_SEPARATOR" select="' '"/>
	
	<xsl:template match="/Invoice | /DebitNote">
		<xsl:call-template name="writeRecord">
			<xsl:with-param name="xmlData">
				<GeneralData>
					<Record>DatosGenerales</Record>
					<Ref>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference | DebitNoteHeader/InvoiceReferences/InvoiceReference"/>
					</Ref>
					<Type>
						<xsl:choose>
							<xsl:when test="InvoiceHeader">FacturaComercial</xsl:when>
							<xsl:when test="DebitNoteHeader">AutofacturaComercial</xsl:when>
						</xsl:choose>
					
					</Type>
					<Date>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate | DebitNoteHeader/InvoiceReferences/InvoiceDate"/>
					</Date>
					<Currency>
						<xsl:choose>
							<xsl:when test="InvoiceHeader/Currency | DebitNoteHeader/Currency">
								<xsl:value-of select="InvoiceHeader/Currency | DebitNoteHeader/Currency"/>
							</xsl:when>
							<xsl:otherwise>EUR</xsl:otherwise>
						</xsl:choose>
					</Currency>					
				</GeneralData>
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="writeRecord">
			<xsl:with-param name="xmlData">
				<Supplier>
					<Record>Proveedor</Record>
					<CustomerSupplierID>
						<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode | DebitNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</CustomerSupplierID>
					<CIF>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo | DebitNoteHeader/InvoiceReferences/VATRegNo"/>
					</CIF>
					<Company>
						<xsl:value-of select="InvoiceHeader/Supplier/SuppliersName | DebitNoteHeader/Supplier/SuppliersName"/>
					</Company>
					<Address>
						<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine1 | DebitNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
					</Address>
					<City>
						<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine2 | DebitNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
					</City>
					<PC>
						<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/PostCode | DebitNoteHeader/Supplier/SuppliersAddress/PostCode"/>
					</PC>
					<Province>
						<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine3 | DebitNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
					</Province>
					<Country>ESP</Country>
				</Supplier>
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="writeRecord">
			<xsl:with-param name="xmlData">
				<Client>
					<Record>Cliente</Record>
															
					<IDCliente>
						<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/BuyersCode | DebitNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
					</IDCliente>
					<!-- 4992 R Cambridge use buyer's code for supplier -->
					<IDCliProv>
						<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode | DebitNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</IDCliProv>
					<IDCentroCli/>
					<CIF>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/BuyersVATRegNo | DebitNoteHeader/InvoiceReferences/BuyersVATRegNo"/>
					</CIF>					
					<Company>
						<xsl:value-of select="InvoiceHeader/Buyer/BuyersName | DebitNoteHeader/Buyer/BuyersName"/>
					</Company>
					<Address>
						<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine1 | DebitNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
					</Address>
					<City>
						<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine2 | DebitNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
					</City>
					<PC>
						<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/PostCode | DebitNoteHeader/Buyer/BuyersAddress/PostCode"/>
					</PC>
					<Province>
						<xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine3 | DebitNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
					</Province>
					<Country>ESP</Country>
				</Client>
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="writeRecord">
			<xsl:with-param name="xmlData">
				<Customer>
					<Record>Establecimientos</Record>
					<SupplierClientID>
						<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
					</SupplierClientID>
					<Something/>
					<SupplierCustomerID>
						<!-- 4992 R Cambridge use buyer's code for ship to -->
						<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
					</SupplierCustomerID>
					<IDCentroCli/>
					<Customer>
						<xsl:value-of select="InvoiceHeader/ShipTo/ShipToName | DebitNoteHeader/ShipTo/ShipToName"/>
					</Customer>
					<Address>
						<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine1 | DebitNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
					</Address>
					<City>
						<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine2 | DebitNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
					</City>
					<PC>
						<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/PostCode | DebitNoteHeader/ShipTo/ShipToAddress/PostCode"/>
					</PC>
					<Province>
						<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine3 | DebitNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
					</Province>
					<Country>ESP</Country>
				</Customer>
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="writeRecord">
			<xsl:with-param name="xmlData">
				<References>
					<Record>Referencias</Record>
					<DNRef>
						<xsl:value-of select="(InvoiceHeader/DeliveryNoteReferences | InvoiceDetail/InvoiceLine/DeliveryNoteReferences | DebitNoteHeader/DeliveryNoteReferences | DebitNoteDetail/DebitNoteLine/DeliveryNoteReferences)/DeliveryNoteReference"/>
					</DNRef>
					<PORef>
						<xsl:value-of select="(InvoiceHeader/PurchaseOrderReferences | InvoiceDetail/InvoiceLine/PurchaseOrderReferences | DebitNoteHeader/PurchaseOrderReferences | DebitNoteDetail/DebitNoteLine/PurchaseOrderReferences)/PurchaseOrderReference"/>
					</PORef>
					<InvoiceRef>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference | DebitNoteHeader/InvoiceReferences/InvoiceReference"/>
					</InvoiceRef>
					<!--DNRefDate>
						<xsl:value-of select="(InvoiceHeader/DeliveryNoteReferences | InvoiceDetail/InvoiceLine/DeliveryNoteReferences | DebitNoteHeader/DeliveryNoteReferences | DebitNoteDetail/DebitNoteLine/DeliveryNoteReferences)/DeliveryNoteDate"/>
					</DNRefDate>
					<PORefDate>
						<xsl:value-of select="(InvoiceHeader/PurchaseOrderReferences | InvoiceDetail/InvoiceLine/PurchaseOrderReferences | DebitNoteHeader/PurchaseOrderReferences | DebitNoteDetail/DebitNoteLine/PurchaseOrderReferences)/PurchaseOrderDate"/>
					</PORefDate>
					<InvoiceRefDate>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate | DebitNoteHeader/InvoiceReferences/InvoiceDate"/>
					</InvoiceRefDate-->
				</References>
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:for-each select="InvoiceDetail/InvoiceLine | DebitNoteDetail/DebitNoteLine">
		
			<xsl:call-template name="writeRecord">
				<xsl:with-param name="xmlData">
					<Product>
						<Record>Detalle</Record>
						<SupplierSKU>
							<xsl:value-of select="ProductID/SuppliersProductCode"/>
						</SupplierSKU>
						<CustomerSKU>
							<xsl:value-of select="ProductID/SuppliersProductCode"/>
						</CustomerSKU>
						<Item>
							<xsl:value-of select="ProductDescription"/>
						</Item>
						<Qty>
							<xsl:value-of select="(InvoicedQuantity | DebitNotedQuantity)[last()]"/>
						</Qty>
						<MU>
							<xsl:call-template name="transUoM">
								<xsl:with-param name="tsUoM" select="(InvoicedQuantity/@UnitOfMeasure | DebitNotedQuantity/@UnitOfMeasure)[last()]"/>
							</xsl:call-template>
						</MU>
						<!--UE/>
						<UC/>
						<Peso/-->						
						<UP>
							<xsl:value-of select="UnitValueExclVAT"/>
						</UP>
						<Total>
							<xsl:value-of select="LineValueExclVAT"/>
						</Total>
						<!--Discount>
							<xsl:value-of select="LineDiscountValue"/>
						</Discount-->
					</Product>
				</xsl:with-param>
			</xsl:call-template>
			
			<xsl:call-template name="writeRecord">
				<xsl:with-param name="xmlData">
					<Discounts>
						<Record>DescuentosLinea</Record>
						<Calificador>Descuento</Calificador>
						<Tipo>Otros</Tipo>
						<Tasa/>
						<Importe>
							<xsl:value-of select="LineDiscountValue"/>
						</Importe>
					</Discounts>
				</xsl:with-param>
			</xsl:call-template>
			
			
			<xsl:call-template name="writeRecord">
				<xsl:with-param name="xmlData">
					<Tax>
						<Record>ImpuestosLinea</Record>
						<Tipo>
							<xsl:value-of select="VATCode"/>
						</Tipo>
						<Tasa>
							<xsl:value-of select="VATRate"/>
						</Tasa>
						<Importe>
							<xsl:value-of select="format-number(VATRate * (InvoicedQuantity | DebitedQuantity)[last()],'0.00')"/>
						</Importe>
					</Tax>
				</xsl:with-param>
			</xsl:call-template>
			
			<!--xsl:call-template name="writeRecord">
				<xsl:with-param name="xmlData">
					<References>
						<Record>Referencias</Record>
						<DNRef>
							<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
						</DNRef>
						<PORef>
							<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
						</PORef>
						<InvoiceRef>
							<xsl:value-of select="/DebitNote/DebitNoteHeader/InvoiceReferences/InvoiceReference"/>
						</InvoiceRef>
						<DNRefDate>
							<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
						</DNRefDate>
						<PORefDate>
							<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
						</PORefDate>
						<InvoiceRefDate>
							<xsl:value-of select="/DebitNote/DebitNoteHeader/InvoiceReferences/InvoiceDate"/>
						</InvoiceRefDate>
					</References>
				</xsl:with-param>
			</xsl:call-template-->
			
		</xsl:for-each>
		
		<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal | DebitNoteTrailer/VATSubTotals/VATSubTotal">
		
			<xsl:call-template name="writeRecord">
				<xsl:with-param name="xmlData">
					<tax>
						<Record>ResumenImpuestos</Record>
						<Tipo>
							<xsl:value-of select="@VATCode"/>
						</Tipo>
						<Tasa>
							<xsl:value-of select="@VATRate"/>
						</Tasa>
						<base>
							<xsl:value-of select="SettlementTotalExclVATAtRate"/>
						</base>
						<Importe>
							<xsl:value-of select="VATAmountAtRate"/>						
						</Importe>
					</tax>
				</xsl:with-param>
			</xsl:call-template>
			
		</xsl:for-each>
		
		<!--xsl:call-template name="writeRecord">
			<xsl:with-param name="xmlData">
				<payment>
					<Record>Vencimientos</Record>
				</payment>
			</xsl:with-param>
		</xsl:call-template-->
		
		<xsl:call-template name="writeRecord">
			<xsl:with-param name="xmlData">
			
				<xsl:for-each select="InvoiceTrailer | DebitNoteTrailer">
					<totals>
						<Record>ResumenTotales</Record>										
						<Bruto>
							<xsl:value-of select="format-number(sum(../InvoiceDetail/InvoiceLine/LineValueExclVAT | ../DebitNoteDetail/DebitNoteLine/LineValueExclVAT), '0.00')"/>
						</Bruto>
						<Neto>
							<xsl:value-of select="DiscountedLinesTotalExclVAT"/>
						</Neto>
						<Descuentos>
							<xsl:value-of select="format-number(DiscountedLinesTotalExclVAT - SettlementTotalExclVAT, '0.00')"/>
						</Descuentos>
						<Base>
							<xsl:value-of select="SettlementTotalExclVAT"/>
						</Base>
						<Impuestos>
							<xsl:value-of select="VATAmount"/>
						</Impuestos>
						<Total>
							<xsl:value-of select="DocumentTotalInclVAT"/>
						</Total>					
					</totals>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="transUoM">
		<xsl:param name="tsUoM"/>
		<xsl:choose>
			<xsl:when test="$tsUoM = 'EA'">Unidades</xsl:when>
			<xsl:when test="$tsUoM = 'CS'">Cajas</xsl:when>
			<xsl:when test="$tsUoM = 'KGM'">Kgs</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="writeRecord">
		<xsl:param name="xmlData"/>
		
		<xsl:for-each select="msxsl:node-set($xmlData)/*/*">
		
			<xsl:value-of select="."/>
			
			<xsl:if test="position() != last()">
				<xsl:text>;</xsl:text>
			</xsl:if>
		
		</xsl:for-each>
	
		<xsl:text>&#13;&#10;</xsl:text>
	
	</xsl:template>
	
</xsl:stylesheet>
