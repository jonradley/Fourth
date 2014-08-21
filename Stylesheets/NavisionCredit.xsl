<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Credit Note into an HTML page

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
							<th align="center">Credit Note (<xsl:value-of select="/CreditNote/CreditNoteHeader/DocumentStatus"/>)</th>
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
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/GLN"/></td>
						</tr>
						<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode">
							<tr>
								<th width="50%">Buyers Code For Location</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode">
							<tr>
								<th width="50%">Suppliers Code For Location</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersName">
							<tr>
								<th width="50%">Name</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersName"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress">
							<tr>
								<th width="50%" valign="top">Address</th>
								<td>
									<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
									<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2">
										<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
									</xsl:if>
									<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3">
										<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
									</xsl:if>
									<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine4">
										<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine4"/>
									</xsl:if>
									<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/PostCode">
										<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/PostCode"/>
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
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/></td>
						</tr>
						<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode">
							<tr>
								<th width="50%">Buyers Code For Location</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
							<tr>
								<th width="50%">Suppliers Code For Location</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersName">
							<tr>
								<th width="50%">Name</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersName"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress">
							<tr>
								<th width="50%" valign="top">Address</th>
								<td>
									<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
									<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2">
										<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
									</xsl:if>
									<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3">
										<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
									</xsl:if>
									<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4">
										<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4"/>
									</xsl:if>
									<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/PostCode">
										<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/PostCode"/>
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
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/GLN"/></td>
						</tr>
						<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
							<tr>
								<th width="50%">Buyers Code For Location</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
							<tr>
								<th width="50%">Suppliers Code For Location</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToName">
							<tr>
								<th width="50%">Name</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToName"/></td>
							</tr>
						</xsl:if>
						<tr>
							<th width="50%" valign="top">Address</th>
							<td>
								<xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
								<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2">
									<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
								</xsl:if>
								<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3">
									<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
								</xsl:if>
								<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4">
									<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4"/>
								</xsl:if>
								<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/PostCode">
									<br/><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/PostCode"/>
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
							<th width="50%">Credit Note Reference</th>
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/></td>
						</tr>
						<tr>
							<th width="50%">Credit Note Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate)"/></td>
						</tr>
						<tr>
							<th width="50%">Invoice Reference</th>
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference"/></td>
						</tr>
						<tr>
							<th width="50%">Invoice Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate)"/></td>
						</tr>
						<tr>
							<th width="50%">Delivery Note Reference</th>
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/></td>
						</tr>
						<tr>
							<th width="50%">Delivery Note Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/CreditNote/CreditNoteHeader/DeliveryNoteReferences/DeliveryNoteDate)"/></td>
						</tr>
						<tr>
							<th width="50%">Purchase Order Confirmation Reference</th>
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/></td>
						</tr>
						<tr>
							<th width="50%">Purchase Order Confirmation Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/CreditNote/CreditNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate)"/></td>
						</tr>
						<tr>
							<th width="50%">Purchase Order Reference</th>
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
						</tr>
						<tr>
							<th width="50%">Purchase Order Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/CreditNote/CreditNoteHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
						</tr>
						<xsl:if test="/CreditNote/CreditNoteHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
							<tr>
								<th width="50%">Customers Purchase Order Reference</th>
								<td><xsl:value-of select="/CreditNote/CreditNoteHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/></td>
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
					<!--Other CreditNote Info-->
					<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
						<tr>
							<th colspan="2">Other Details</th>
						</tr>
						<tr>
							<th width="50%">Invoice Tax Point Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/CreditNote/CreditNoteHeader/InvoiceReferences/TaxPointDate)"/></td>
						</tr>
						<tr>
							<th width="50%">Invoice VAT Reg No</th>
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/VATRegNo"/></td>
						</tr>
						<tr>
							<th width="50%">Credit Note Tax Point Date</th>
							<td><xsl:value-of select="user:gsFormatDate(/CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate)"/></td>
						</tr>
						<tr>
							<th width="50%">Credit Note VAT Reg No</th>
							<td><xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/VATRegNo"/></td>
						</tr>
					</table>
				</td>
				<td valign="top" width="50%">
					<!--TradeAgreement-->
					<xsl:choose>
						<xsl:when test="/CreditNote/CreditNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
							<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
								<tr>
									<th colspan="2">Trade Agreement</th>
								</tr>
								<tr>
									<th width="50%">Contract Reference</th>
									<td><xsl:value-of select="/CreditNote/CreditNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/></td>
								</tr>
								<xsl:if test="/CreditNote/CreditNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
									<tr>
										<th width="50%">Contract Date</th>
										<td><xsl:value-of select="user:gsFormatDate(/CreditNote/CreditNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate)"/></td>
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
					<!--CreditNote Lines-->
					<table class="DocumentLines" cellpadding="1" cellspacing="1">
						<tr>
							<th>Line Number</th>
							<th>GTIN</th>
							<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/ProductID/SuppliersProductCode">
								<th>Suppliers Product Code</th>
							</xsl:if>
							<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/ProductID/BuyersProductCode">
								<th>Buyers Product Code</th>
							</xsl:if>
							<th>Product Description</th>
							<th>Invoiced Qty</th>
							<th>UOM</th>
							<th>Credited Qty</th>
							<th>UOM</th>
							<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/PackSize">
								<th>Pack Size</th>
							</xsl:if>
							<th>Unit Value Excl VAT</th>
							<th>Line Value Excl VAT</th>
							<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/LineDiscountRate">
								<th>Line Discount Rate</th>
							</xsl:if>
							<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/LineDiscountValue">
								<th>Line Discount Value</th>
							</xsl:if>
							<th>VAT Code</th>
							<th>VAT Rate</th>
						</tr>
						<xsl:for-each select="/CreditNote/CreditNoteDetail/CreditNoteLine">
							<xsl:variable name="RowClass">
								<xsl:value-of select="user:gsGetRowClass()"/>
							</xsl:variable>
							<tr>
								<xsl:attribute name="class">
									<xsl:value-of select="$RowClass"/>
								</xsl:attribute>
								<td><xsl:value-of select="LineNumber"/></td>
								<td><xsl:value-of select="ProductID/GTIN"/></td>
								<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/ProductID/SuppliersProductCode">
									<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
								</xsl:if>
								<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/ProductID/BuyersProductCode">
									<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
								</xsl:if>
								<td><xsl:value-of select="ProductDescription"/></td>
								<td align="right"><xsl:value-of select="InvoicedQuantity"/></td>
								<td><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></td>
								<td align="right"><xsl:value-of select="CreditedQuantity"/></td>
								<td><xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/></td>
								<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/PackSize">
									<td><xsl:value-of select="PackSize"/>&#xa0;</td>
								</xsl:if>
								<td align="right"><xsl:value-of select="UnitValueExclVAT"/></td>
								<td align="right"><xsl:value-of select="LineValueExclVAT"/></td>
								<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/LineDiscountRate">
									<td align="right"><xsl:value-of select="LineDiscountRate"/></td>
								</xsl:if>
								<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/LineDiscountValue">
									<td align="right"><xsl:value-of select="LineDiscountValue"/></td>
								</xsl:if>
								<td><xsl:value-of select="VATCode"/></td>
								<td align="right"><xsl:value-of select="VATRate"/></td>
							</tr>
							<xsl:if test="Narrative">
								<tr>
									<xsl:attribute name="class">
										<xsl:value-of select="$RowClass"/>
									</xsl:attribute>
									<td colspan="15">
										<xsl:if test="Narrative/@Code"><xsl:value-of select="Narrative/@Code"/>: </xsl:if><xsl:value-of select="Narrative"/>
									</td>
								</tr>
							</xsl:if>
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
						<xsl:for-each select="/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal">
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
							<td align="right"><xsl:value-of select="/CreditNote/CreditNoteTrailer/NumberOfLines"/></td>
						</tr>
						<xsl:if test="/CreditNote/CreditNoteTrailer/DocumentDiscountRate">
							<tr>
								<th width="50%">Document Discount Rate</th>
								<td align="right"><xsl:value-of select="/CreditNote/CreditNoteTrailer/DocumentDiscountRate"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteTrailer/SettlementDiscountRate">
							<tr>
								<th width="50%">Settlement Discount Rate</th>
								<td align="right"><xsl:value-of select="/CreditNote/CreditNoteTrailer/SettlementDiscountRate"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="/CreditNote/CreditNoteTrailer/SettlementDiscountRate/@SettlementDiscountDays">
							<tr>
								<th width="50%">Settlement Discount Days</th>
								<td align="right"><xsl:value-of select="/CreditNote/CreditNoteTrailer/SettlementDiscountRate/@SettlementDiscountDays"/></td>
							</tr>
						</xsl:if>
						<tr>
							<th width="50%">Settlement Total Excl VAT</th>
							<td align="right"><xsl:value-of select="/CreditNote/CreditNoteTrailer/SettlementTotalExclVAT"/></td>
						</tr>
						<tr>
							<th width="50%">Document Total Excl VAT</th>
							<td align="right"><xsl:value-of select="/CreditNote/CreditNoteTrailer/DocumentTotalExclVAT"/></td>
						</tr>
						<tr>
							<th width="50%">VAT Amount</th>
							<td align="right"><xsl:value-of select="/CreditNote/CreditNoteTrailer/VATAmount"/></td>
						</tr>
						<tr>
							<th width="50%">Settlement Total Incl VAT</th>
							<td align="right"><xsl:value-of select="/CreditNote/CreditNoteTrailer/SettlementTotalInclVAT"/></td>
						</tr>
						<tr>
							<th width="50%">Document Total Incl VAT</th>
							<td align="right"><xsl:value-of select="/CreditNote/CreditNoteTrailer/DocumentTotalInclVAT"/></td>
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