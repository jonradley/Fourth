<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Invoice into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 04/03/2004 | A Sheppard | Created module.
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="html"/>
	<xsl:template match="/">
		<table class="DocumentSurround">	
			<!--Header-->
			<tr>
				<td align="center" colspan="2">
					<table width="100%">
						<tr>
							<th align="center">Invoice (<xsl:value-of select="/Invoice/InvoiceHeader/DocumentStatus"/>)</th>
						</tr>
					</table>
				</td>
			</tr>
			<!--Addresses-->
			<tr>
				<td valign="top" width="50%">
					<!--Buyer-->
					<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
						<tr>
							<th colspan="2">Buyer</th>
						</tr>
						<tr>
							<th width="50%">GLN</th>
							<td><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/GLN"/></td>
						</tr>
						<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode">
							<tr>
								<th width="50%">Buyers Code For Location</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode">
							<tr>
								<th width="50%">Suppliers Code For Location</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersName">
							<tr>
								<th width="50%">Name</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersName"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress">
							<tr>
								<th width="50%" valign="top">Address</th>
								<td>
									<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/>
									<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2">
										<br/><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/>
									</xsl:if>
									<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3">
										<br/><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/>
									</xsl:if>
									<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine4">
										<br/><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/>
									</xsl:if>
									<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress/PostCode">
										<br/><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/PostCode"/>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
					</table>
				</td>
				<td valign="top" width="50%">
					<!--Supplier-->
					<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
						<tr>
							<th colspan="2">Supplier</th>
						</tr>
						<tr>
							<th width="50%">GLN</th>
							<td><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/GLN"/></td>
						</tr>
						<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode">
							<tr>
								<th width="50%">Buyers Code For Location</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode">
							<tr>
								<th width="50%">Suppliers Code For Location</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersName">
							<tr>
								<th width="50%">Name</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersName"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress">
							<tr>
								<th width="50%" valign="top">Address</th>
								<td>
									<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/>
									<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2">
										<br/><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/>
									</xsl:if>
									<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3">
										<br/><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/>
									</xsl:if>
									<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine4">
										<br/><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine4"/>
									</xsl:if>
									<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/PostCode">
										<br/><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/PostCode"/>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2"><br/></td>
			</tr>
			<tr>
				<td valign="top" width="50%">
					<!--ShipTo-->
					<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
						<tr>
							<th colspan="2">ShipTo</th>
						</tr>
						<tr>
							<th width="50%">GLN</th>
							<td><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/GLN"/></td>
						</tr>
						<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode">
							<tr>
								<th width="50%">Buyers Code For Location</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode">
							<tr>
								<th width="50%">Suppliers Code For Location</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToName">
							<tr>
								<th width="50%">Name</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToName"/></td>
							</tr>
						</xsl:if>
						<tr>
							<th width="50%" valign="top">Address</th>
							<td>
								<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/>
								<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine2">
									<br/><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/>
								</xsl:if>
								<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine3">
									<br/><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/>
								</xsl:if>
								<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine4">
									<br/><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/>
								</xsl:if>
								<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/PostCode">
									<br/><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/PostCode"/>
								</xsl:if>
							</td>
						</tr>
					</table>
				</td>
				<td valign="top" width="50%">
					<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
						<tr>
							<th colspan="2">References</th>
						</tr>
						<tr>
							<th width="50%">Invoice Reference</th>
							<td><xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/></td>
						</tr>
						<tr>
							<th width="50%">Invoice Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate)"/></td>
						</tr>
						<tr>
							<th width="50%">Delivery Note Reference</th>
							<td><xsl:value-of select="/Invoice/InvoiceHeader/DeliveryNoteReferences/DeliveryNoteReference"/></td>
						</tr>
						<tr>
							<th width="50%">Delivery Note Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/Invoice/InvoiceHeader/DeliveryNoteReferences/DeliveryNoteDate)"/></td>
						</tr>
						<tr>
							<th width="50%">Purchase Order Confirmation Reference</th>
							<td><xsl:value-of select="/Invoice/InvoiceHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/></td>
						</tr>
						<tr>
							<th width="50%">Purchase Order Confirmation Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/Invoice/InvoiceHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate)"/></td>
						</tr>
						<tr>
							<th width="50%">Purchase Order Reference</th>
							<td><xsl:value-of select="/Invoice/InvoiceHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
						</tr>
						<tr>
							<th width="50%">Purchase Order Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/Invoice/InvoiceHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
						</tr>
						<xsl:if test="/Invoice/InvoiceHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
							<tr>
								<th width="50%">Customers Purchase Order Reference</th>
								<td><xsl:value-of select="/Invoice/InvoiceHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/></td>
							</tr>
						</xsl:if>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2"><br/></td>
			</tr>
			<tr>
				<td valign="top" width="50%">
					<!--Other Invoice Info-->
					<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
						<tr>
							<th colspan="2">Other Details</th>
						</tr>
						<tr>
							<th width="50%">Tax Point Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate)"/></td>
						</tr>
						<tr>
							<th width="50%">VAT Reg No</th>
							<td><xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/VATRegNo"/></td>
						</tr>
					</table>
				</td>
				<td valign="top" width="50%">
					<!--TradeAgreement-->
					<xsl:choose>
						<xsl:when test="/Invoice/InvoiceHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
							<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
								<tr>
									<th colspan="2">Trade Agreement</th>
								</tr>
								<tr>
									<th width="50%">Contract Reference</th>
									<td><xsl:value-of select="/Invoice/InvoiceHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/></td>
								</tr>
								<xsl:if test="/Invoice/InvoiceHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
									<tr>
										<th width="50%">Contract Date</th>
										<td><xsl:value-of select="user:gsFormatDate(/Invoice/InvoiceHeader/PurchaseOrderReferences/TradeAgreement/ContractDate)"/></td>
									</tr>
								</xsl:if>
							</table>
						</xsl:when>
						<xsl:otherwise>&#xa0;</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td colspan="2"><br/></td>
			</tr>
			<tr>
				<td colspan="2">
					<!--Invoice Lines-->
					<table class="DocumentLines" cellpadding="1" cellspacing="1">
						<tr>
							<th>Line Number</th>
							<th>GTIN</th>
							<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/ProductID/SuppliersProductCode">
								<th>Suppliers Product Code</th>
							</xsl:if>
							<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/ProductID/BuyersProductCode">
								<th>Buyers Product Code</th>
							</xsl:if>
							<th>Product Description</th>
							<th>Confirmed Qty</th>
							<th>UOM</th>
							<th>Invoiced Qty</th>
							<th>UOM</th>
							<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/PackSize">
								<th>Pack Size</th>
							</xsl:if>
							<th>Unit Value Excl VAT</th>
							<th>Line Value Excl VAT</th>
							<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/LineDiscountRate">
								<th>Line Discount Rate</th>
							</xsl:if>
							<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/LineDiscountValue">
								<th>Line Discount Value</th>
							</xsl:if>
							<th>VAT Code</th>
							<th>VAT Rate</th>
						</tr>
						<xsl:for-each select="/Invoice/InvoiceDetail/InvoiceLine">
							<tr>
								<xsl:attribute name="class">
									<xsl:value-of select="user:gsGetRowClass()"/>
								</xsl:attribute>
								<td><xsl:value-of select="LineNumber"/></td>
								<td><xsl:value-of select="ProductID/GTIN"/></td>
								<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/ProductID/SuppliersProductCode">
									<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
								</xsl:if>
								<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/ProductID/BuyersProductCode">
									<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
								</xsl:if>
								<td><xsl:value-of select="ProductDescription"/></td>
								<td align="right"><xsl:value-of select="ConfirmedQuantity"/></td>
								<td><xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/></td>
								<td align="right"><xsl:value-of select="InvoicedQuantity"/></td>
								<td><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></td>
								<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/PackSize">
									<td><xsl:value-of select="PackSize"/>&#xa0;</td>
								</xsl:if>
								<td align="right"><xsl:value-of select="UnitValueExclVAT"/></td>
								<td align="right"><xsl:value-of select="LineValueExclVAT"/></td>
								<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/LineDiscountRate">
									<td align="right"><xsl:value-of select="LineDiscountRate"/></td>
								</xsl:if>
								<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/LineDiscountValue">
									<td align="right"><xsl:value-of select="LineDiscountValue"/></td>
								</xsl:if>
								<td><xsl:value-of select="VATCode"/></td>
								<td align="right"><xsl:value-of select="VATRate"/></td>
							</tr>
						</xsl:for-each>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<!--VAT subtotals-->
					<table class="DocumentLines" cellpadding="1" cellspacing="1" style="width:100%">
						<tr>
							<th colspan="8">VAT SubTotals</th>
						</tr>
						<tr>
							<th>VAT Code</th>
							<th>VAT Rate</th>
							<th>Number Of Lines</th>
							<th>Discounted Lines Total</th>
							<th>Document Discount</th>
							<th>Settlement Discount</th>
							<th>Taxable Total</th>
							<th>VAT Amount</th>
						</tr>
						<xsl:for-each select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal">
							<tr>
								<xsl:attribute name="class">
									<xsl:value-of select="user:gsGetRowClass()"/>
								</xsl:attribute>
								<td><xsl:value-of select="@VATCode"/></td>
								<td align="right"><xsl:value-of select="@VATRate"/></td>
								<td align="right"><xsl:value-of select="NumberOfLinesAtRate"/></td>
								<td align="right"><xsl:value-of select="DiscountedTotalExclVATAtRate"/></td>
								<td align="right"><xsl:value-of select="DocumentDiscountAtRate"/></td>
								<td align="right"><xsl:value-of select="SettlementDiscountAtRate"/></td>
								<td align="right"><xsl:value-of select="TaxableTotalExclVATAtRate"/></td>
								<td align="right"><xsl:value-of select="VATAmountAtRate"/></td>
							</tr>
						</xsl:for-each>
					</table>
				</td>
			</tr>
			<tr>
				<td><br/></td>
				<td>
					<!--Totals-->
					<table class="DocumentInner" cellpadding="1" cellspacing="1">
						<tr>
							<th colspan="2">Totals</th>
						</tr>
						<tr>
							<th width="50%">Number Of Lines</th>
							<td align="right"><xsl:value-of select="/Invoice/InvoiceTrailer/NumberOfLines"/></td>
						</tr>
						<xsl:if test="/Invoice/InvoiceTrailer/DocumentDiscountRate">
							<tr>
								<th width="50%">Document Discount Rate</th>
								<td align="right"><xsl:value-of select="/Invoice/InvoiceTrailer/DocumentDiscountRate"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceTrailer/SettlementDiscountRate">
							<tr>
								<th width="50%">Settlement Discount Rate</th>
								<td align="right"><xsl:value-of select="/Invoice/InvoiceTrailer/SettlementDiscountRate"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/Invoice/InvoiceTrailer/SettlementDiscountRate/@SettlementDiscountDays">
							<tr>
								<th width="50%">Settlement Discount Days</th>
								<td align="right"><xsl:value-of select="/Invoice/InvoiceTrailer/SettlementDiscountRate/@SettlementDiscountDays"/></td>
							</tr>
						</xsl:if>
						<tr>
							<th width="50%">Settlement Total Excl VAT</th>
							<td align="right"><xsl:value-of select="/Invoice/InvoiceTrailer/SettlementTotalExclVAT"/></td>
						</tr>
						<tr>
							<th width="50%">Document Total Excl VAT</th>
							<td align="right"><xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalExclVAT"/></td>
						</tr>
						<tr>
							<th width="50%">VAT Amount</th>
							<td align="right"><xsl:value-of select="/Invoice/InvoiceTrailer/VATAmount"/></td>
						</tr>
						<tr>
							<th width="50%">Settlement Total Incl VAT</th>
							<td align="right"><xsl:value-of select="/Invoice/InvoiceTrailer/SettlementTotalInclVAT"/></td>
						</tr>
						<tr>
							<th width="50%">Document Total Incl VAT</th>
							<td align="right"><xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalInclVAT"/></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>	
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : gsFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in mm/dd/yyyy format
		' Author       		 : A Sheppard, 09/06/2003
		' Alterations   	 : 
		'========================================================================================*/
		function gsFormatDate(vsDate)
		{
		
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(0,4);
			}
			else
			{
				return '';
			}
				
		}
		
		/*=========================================================================================
		' Routine       	 : gsGetRowClass
		' Description 	 : Gets listrow 0,1,0 etc.
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : A Sheppard, 23/02/2004.
		' Alterations   	 : 
		'========================================================================================*/
		var msPreviousRowClass = 'listrow0';
		function gsGetRowClass()
		{
			if(msPreviousRowClass == 'listrow1')
			{
				msPreviousRowClass = 'listrow0';
			}
			else
			{
				msPreviousRowClass = 'listrow1';
			}
			return msPreviousRowClass;
		}
	]]></msxsl:script>
</xsl:stylesheet>