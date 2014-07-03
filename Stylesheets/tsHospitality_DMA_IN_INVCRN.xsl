<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Invoice mapper
'  Hospitality post flat file mapping to iXML format.
'
' © Fourth Ltd., 2013.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 06/11/2013  | Jose Miguel  | Created
'******************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="@*|text()|comment()|processing-instruction()">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates select="BatchDocument"/>
		</BatchRoot>
	</xsl:template>
	<!-- Process the invoices -->
	<xsl:template match="BatchDocument[@DocumentTypeNo='I']">
		<Document>
			<xsl:attribute name="TypePrefix"><xsl:text>INV</xsl:text></xsl:attribute>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<!-- Generate Invoices -->
						<xsl:apply-templates select="Invoice" mode="Invoice"/>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</Document>
	</xsl:template>
	<!-- Process the credit notes -->
	<xsl:template match="BatchDocument[@DocumentTypeNo='CR']">
		<Document>
			<xsl:attribute name="TypePrefix"><xsl:text>CRN</xsl:text></xsl:attribute>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<!-- Generate CREDITS -->
						<xsl:apply-templates select="Invoice" mode="CreditNote"/>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</Document>
	</xsl:template>
	<!-- The FFM created an invoice by default. So no need of a huge transformation -->
	<xsl:template match="Invoice" mode="Invoice">
		<!-- calculate the tax rate as (total+TAX)/total -->
		<xsl:variable name="rate" select="100 * round(10000 * (number(InvoiceTrailer/DocumentTotalInclVAT) div number(InvoiceTrailer/DocumentTotalExclVAT) - 1)) div 10000"/>
		<Invoice>
			<xsl:apply-templates select="TradeSimpleHeader"/>
			<xsl:apply-templates select="InvoiceHeader"/>
			<InvoiceDetail>
				<xsl:for-each select="InvoiceDetail/InvoiceLine">
					<InvoiceLine>
						<!-- Process the line number -->
						<xsl:apply-templates select="LineNumber"/>
						<!-- Translate the purchase order reference -->
						<xsl:call-template name="CreatePurchaseOrderReferences">
							<xsl:with-param name="reference" select="../../InvoiceHeader/BatchInformation/SendersTransmissionReference"/>
							<xsl:with-param name="date" select="../../InvoiceHeader/BatchInformation/SendersTransmissionDate"/>
						</xsl:call-template>
						<!-- Process all the tags until the VAT code to keep the order of the tags -->
						<xsl:apply-templates select="PurchaseOrderConfirmationReferences | DeliveryNoteReferences | GoodsReceivedNoteReferences | ProductID | ProductDescription | OrderedQuantity | ConfirmedQuantity | DeliveredQuantity | InvoicedQuantity | PackSize | UnitValueExclVAT | LineValueExclVAT | LineDiscountRate | LineDiscountValue"/>
						<!-- Calculate the VAT code and the rate -->
						<VATCode>S</VATCode>
						<VATRate>
							<xsl:value-of select="$rate"/>
						</VATRate>
						<!-- Process the rest of the tags -->
						<xsl:apply-templates select="NetPriceFlag | Measure | LineExtraData"/>
					</InvoiceLine>
				</xsl:for-each>
				<!-- Extra line for the Fees -->
				<xsl:if test="not(InvoiceTrailer/SettlementDiscount = 0)">
					<InvoiceLine>
						<xsl:call-template name="CreateFeeLine">
							<xsl:with-param name="amount">
								<xsl:value-of select="InvoiceTrailer/SettlementDiscount"/>
							</xsl:with-param>
						</xsl:call-template>
					</InvoiceLine>
				</xsl:if>
			</InvoiceDetail>
			<xsl:apply-templates select="InvoiceTrailer"/>
		</Invoice>
	</xsl:template>
	<!-- For Credits notes we need to flip the names of the tags -->
	<xsl:template match="Invoice" mode="CreditNote">
		<!-- calculate the tax rate as (total+TAX)/total -->
		<xsl:variable name="rate" select="100 * round(10000 * (number(InvoiceTrailer/DocumentTotalInclVAT) div number(InvoiceTrailer/DocumentTotalExclVAT) - 1)) div 10000"/>
		<!-- Rename the document type -->
		<CreditNote>
			<!-- Copy the header as is -->
			<xsl:apply-templates select="TradeSimpleHeader"/>
			<!-- Rename the invoice header -->
			<CreditNoteHeader>
				<!-- Copy the buyer the supplier and the ship to -->
				<xsl:apply-templates select="InvoiceHeader/Buyer | InvoiceHeader/Supplier | InvoiceHeader/ShipTo"/>
				<!-- Renaming the references -->
				<CreditNoteReferences>
					<CreditNoteReference>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
					</CreditNoteReference>
					<CreditNoteDate>
						<xsl:call-template name="FormatDate">
							<xsl:with-param name="date" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
						</xsl:call-template>
					</CreditNoteDate>
				</CreditNoteReferences>
			</CreditNoteHeader>
			<!-- Rebuild the credit lines based on the invoices lines -->
			<CreditNoteDetail>
				<xsl:for-each select="InvoiceDetail/InvoiceLine">
					<CreditNoteLine>
						<!-- Process the line number -->
						<xsl:apply-templates select="LineNumber"/>
						<!-- Translate the purchase order reference -->
						<!-- Translate the purchase order reference -->
						<xsl:call-template name="CreatePurchaseOrderReferences">
							<xsl:with-param name="reference" select="../../InvoiceHeader/BatchInformation/SendersTransmissionReference"/>
							<xsl:with-param name="date" select="../../InvoiceHeader/BatchInformation/SendersTransmissionDate"/>
						</xsl:call-template>
						<!-- Process all the tags until the credited quantity to keep the order of the tags -->
						<xsl:apply-templates select="PurchaseOrderConfirmationReferences | DeliveryNoteReferences | GoodsReceivedNoteReferences | ProductID | ProductDescription | OrderedQuantity | ConfirmedQuantity | DeliveredQuantity | InvoicedQuantity"/>
						<!-- Create the credited quantity as the invoice quantity, bearing in mind the catchweight logic -->
						<CreditedQuantity>
							<xsl:call-template name="AdjustQuantity">
								<xsl:with-param name="isCatchWeight" select="../Measure/MeasureIndicator"/>
								<xsl:with-param name="quantity" select="InvoicedQuantity"/>
								<xsl:with-param name="weight" select="../Measure/TotalMeasure"/>
							</xsl:call-template>
						</CreditedQuantity>
						<!-- Process all the tags after the credited quantity to keep the order of the tags -->
						<xsl:apply-templates select="PackSize | UnitValueExclVAT | LineValueExclVAT | LineDiscountRate | LineDiscountValue"/>
						<VATCode>S</VATCode>
						<VATRate>
							<xsl:value-of select="$rate"/>
						</VATRate>
						<!-- Process the rest of the tags -->
						<xsl:apply-templates select="NetPriceFlag | Measure | LineExtraData"/>
					</CreditNoteLine>
				</xsl:for-each>
				<xsl:if test="not(InvoiceTrailer/SettlementDiscount = 0)">
					<CreditNoteLine>
						<xsl:call-template name="CreateFeeLine">
							<xsl:with-param name="amount">
								<xsl:value-of select="InvoiceTrailer/SettlementDiscount"/>
							</xsl:with-param>
						</xsl:call-template>
					</CreditNoteLine>
				</xsl:if>
			</CreditNoteDetail>
			<!-- Rename the invoice trailer -->
			<CreditNoteTrailer>
				<xsl:apply-templates select="InvoiceTrailer/*"/>
			</CreditNoteTrailer>
		</CreditNote>
	</xsl:template>
	<!-- Create Purchase Order reference -->
	<xsl:template name="CreatePurchaseOrderReferences">
		<xsl:param name="reference"/>
		<xsl:param name="date"/>
		<PurchaseOrderReferences>
			<PurchaseOrderReference>
				<xsl:value-of select="$reference"/>
			</PurchaseOrderReference>
			<PurchaseOrderDate>
				<xsl:call-template name="FormatDate">
					<xsl:with-param name="date" select="$date"/>
				</xsl:call-template>
			</PurchaseOrderDate>
		</PurchaseOrderReferences>
	</xsl:template>
	<!-- Create the fee line -->
	<xsl:template name="CreateFeeLine">
		<xsl:param name="amount"/>
		<xsl:param name="type"/>
		<ProductID>
			<SuppliersProductCode>Fees</SuppliersProductCode>
		</ProductID>
		<ProductDescription>Total Fee Amount</ProductDescription>
		<OrderedQuantity>0</OrderedQuantity>
		<DeliveredQuantity>1</DeliveredQuantity>
		<InvoicedQuantity>1</InvoicedQuantity>
		<xsl:if test="$type='Credit'">
			<CreditedQuantity>1</CreditedQuantity>
		</xsl:if>
		<UnitValueExclVAT>
			<xsl:value-of select="$amount"/>
		</UnitValueExclVAT>
		<LineValueExclVAT>
			<xsl:value-of select="$amount"/>
		</LineValueExclVAT>
		<VATCode>E</VATCode>
		<VATRate>0</VATRate>
	</xsl:template>
	<!-- Create the tax information -->
	<xsl:template name="CreateVATInformation">
		<xsl:param name="rate"/>
		<VATCode>S</VATCode>
		<VATRate>
			<xsl:value-of select="$rate"/>
		</VATRate>
	</xsl:template>
	<!-- Adding the break level to the supliers product code -->
	<xsl:template match="SuppliersProductCode">
		<SuppliersProductCode>
			<xsl:value-of select="."/>
			<!-- if the BreakLevel indicator is present and non zero.-->
			<xsl:if test = "number(../../Measure/UnitsInPack)">
				<xsl:text>~</xsl:text><xsl:value-of select="../../Measure/UnitsInPack"/>
			</xsl:if>
		</SuppliersProductCode>
	</xsl:template>
	<!-- Formatting dates to TS format -->
	<xsl:template match="InvoiceDate | TaxPointDate">
		<xsl:element name="{name()}">
			<xsl:call-template name="FormatDate">
				<xsl:with-param name="date" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<!-- Getting the senders branch reference -->
	<xsl:template match="SendersBranchReference">
		<SendersBranchReference>
			<xsl:value-of select="substring(., 0, 3)"/>
		</SendersBranchReference>
	</xsl:template>
	<!-- Adding catchweight logic -->
	<xsl:template match="DeliveredQuantity | InvoicedQuantity">
		<xsl:element name="{name(.)}">
			<xsl:call-template name="AdjustQuantity">
				<xsl:with-param name="isCatchWeight" select="../Measure/MeasureIndicator"/>
				<xsl:with-param name="quantity" select="."/>
				<xsl:with-param name="weight" select="../Measure/TotalMeasure"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<!-- Removing extra tags that were for other purposes -->
	<xsl:template match="BatchInformation | SettlementDiscount | Measure | VATAmount"/>
	<!-- Adjust the quantity depending on the catchweight flag -->
	<xsl:template name="AdjustQuantity">
		<xsl:param name="isCatchWeight"/>
		<xsl:param name="quantity"/>
		<xsl:param name="weight"/>
		<xsl:choose>
			<xsl:when test="number($isCatchWeight) = 1">
				<xsl:value-of select="$weight"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$quantity"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Date Formatting -->
	<xsl:template name="FormatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat(substring($date, 1, 4),'-',substring($date, 5, 2),'-',substring($date, 7, 2))"/>
	</xsl:template>
</xsl:stylesheet>
