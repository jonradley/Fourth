<!--
'******************************************************************************************
' BRANCHES LOCATED IN: SSP, SSP Equipment Ordering
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Invoice into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 04/03/2004 | A Sheppard | Created module.
 ******************************************************************************************
 22/09/2004 | A Sheppard | Updated to cope with new schemas
 ******************************************************************************************
 04/11/2004 | L Boyton   | H190. Added Coda Company Code.
******************************************************************************************
 07/04/2005 | A Sheppard | Added print button
******************************************************************************************
 20/04/2005 | A Sheppard | Added contact name
******************************************************************************************
 23/08/2005 | S Jefford  | H491. Added Stock System Identifier.
******************************************************************************************
 25/08/2005 | A Sheppard | H488. Cater for the presence of batch structure
****************************************************************************************** 
 18/01/2006 | A Sheppard | H548. Change Buyer to Buyer/Invoice To
****************************************************************************************** 
 19/12/2006 | A Sheppard | 630. Made into outbound email mapping version
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="html"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	<xsl:template match="/">
		<html>
			<style>
				BODY
				{
				    FONT-SIZE: 8pt;
				    COLOR: #0d0d67;
				    FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;
				    BACKGROUND-COLOR: #ffffff;
				    style: "text-decoration: none"
				}
				TR.listrow0
				{
				    BACKGROUND-COLOR: #dde6e4
				}
				TR.listrow1
				{
				    BACKGROUND-COLOR: #ffffff
				}
				TH
				{
				    FONT-WEIGHT: bold;
				    FONT-SIZE: 10pt;
				    COLOR: #ffffff;
				    FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;
				    BACKGROUND-COLOR: #024a37
				}
				TD
				{
				    FONT-SIZE: 8pt
				}
				TABLE.Test
				{
				    BACKGROUND-COLOR: #ff0000;
				}				
				TABLE.DocumentSurround
				{
				    BACKGROUND-COLOR: #dde6e4;
				    WIDTH: 100%;
				}
				TABLE.DocumentSurround TH
				{
				    FONT-SIZE: larger
				}
				TABLE.DocumentInner
				{
				    WIDTH: 100%;
				    BACKGROUND-COLOR: white;
				}
				TABLE.DocumentInner TH
				{
				    FONT-SIZE: smaller
				}
				TABLE.DocumentLines
				{
				    WIDTH: 100%;
				    BACKGROUND-COLOR: white;
				}
				TABLE.DocumentLines TH
				{
				    FONT-SIZE: smaller
				}
				TR.Rejected
				{
				    BACKGROUND-COLOR: salmon
				}
				TR.Changed
				{
				    BACKGROUND-COLOR: #ffcc00
				}
				TR.Accepted
				{
				    BACKGROUND-COLOR: palegreen
				}
				TR.Added
				{
				    BACKGROUND-COLOR: palegreen
				}
				TR.Breakage
				{
				    BACKGROUND-COLOR: #ffcc00
				}
			</style>
			<body>
				<table class="DocumentSurround">	
					<!--Header-->
					<tr>
						<td align="center" colspan="2">
							<table width="100%">
								<tr>
									<th align="center">Invoice (<xsl:value-of select="//Invoice//InvoiceHeader/DocumentStatus"/>)</th>
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
									<th colspan="2">Buyer/Invoice To</th>
								</tr>
								<xsl:if test="//Invoice//InvoiceHeader/Buyer/BuyersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/Buyer/BuyersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/Buyer/BuyersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/Buyer/BuyersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="//Invoice//InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/>
											<xsl:if test="//Invoice//InvoiceHeader/Buyer/BuyersAddress/AddressLine2">
												<br/><xsl:value-of select="//Invoice//InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="//Invoice//InvoiceHeader/Buyer/BuyersAddress/AddressLine3">
												<br/><xsl:value-of select="//Invoice//InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="//Invoice//InvoiceHeader/Buyer/BuyersAddress/AddressLine4">
												<br/><xsl:value-of select="//Invoice//InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="//Invoice//InvoiceHeader/Buyer/BuyersAddress/PostCode">
												<br/><xsl:value-of select="//Invoice//InvoiceHeader/Buyer/BuyersAddress/PostCode"/>
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
								<xsl:if test="//Invoice//InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/Supplier/SuppliersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/Supplier/SuppliersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/Supplier/SuppliersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="//Invoice//InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/>
											<xsl:if test="//Invoice//InvoiceHeader/Supplier/SuppliersAddress/AddressLine2">
												<br/><xsl:value-of select="//Invoice//InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="//Invoice//InvoiceHeader/Supplier/SuppliersAddress/AddressLine3">
												<br/><xsl:value-of select="//Invoice//InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="//Invoice//InvoiceHeader/Supplier/SuppliersAddress/AddressLine4">
												<br/><xsl:value-of select="//Invoice//InvoiceHeader/Supplier/SuppliersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="//Invoice//InvoiceHeader/Supplier/SuppliersAddress/PostCode">
												<br/><xsl:value-of select="//Invoice//InvoiceHeader/Supplier/SuppliersAddress/PostCode"/>
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
								<xsl:if test="//Invoice//InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/ShipTo/ContactName">
									<tr>
										<th width="50%">Contact Name</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/ShipTo/ContactName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/ShipTo/ShipToName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/ShipTo/ShipToName"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%" valign="top">Address</th>
									<td>
										<xsl:value-of select="//Invoice//InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/>
										<xsl:if test="//Invoice//InvoiceHeader/ShipTo/ShipToAddress/AddressLine2">
											<br/><xsl:value-of select="//Invoice//InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/>
										</xsl:if>
										<xsl:if test="//Invoice//InvoiceHeader/ShipTo/ShipToAddress/AddressLine3">
											<br/><xsl:value-of select="//Invoice//InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/>
										</xsl:if>
										<xsl:if test="//Invoice//InvoiceHeader/ShipTo/ShipToAddress/AddressLine4">
											<br/><xsl:value-of select="//Invoice//InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/>
										</xsl:if>
										<xsl:if test="//Invoice//InvoiceHeader/ShipTo/ShipToAddress/PostCode">
											<br/><xsl:value-of select="//Invoice//InvoiceHeader/ShipTo/ShipToAddress/PostCode"/>
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
									<th width="50%">INV Ref</th>
									<td><xsl:value-of select="//Invoice//InvoiceHeader//InvoiceReferences//InvoiceReference"/></td>
								</tr>
								<tr>
									<th width="50%">INV Date</th>
									<td><xsl:value-of select="user:gsFormatDate(//Invoice//InvoiceHeader//InvoiceReferences//InvoiceDate)"/></td>
								</tr>
								<xsl:if test="//Invoice//InvoiceHeader/DeliveryNoteReferences">
									<tr>
										<th width="50%">DN Ref</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/DeliveryNoteReferences/DeliveryNoteReference"/></td>
									</tr>
									<tr>
										<th width="50%">DN Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//Invoice//InvoiceHeader/DeliveryNoteReferences/DeliveryNoteDate)"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/PurchaseOrderReferences">
									<tr>
										<th width="50%">PO Ref</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
									</tr>
									<tr>
										<th width="50%">PO Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//Invoice//InvoiceHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
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
								<xsl:if test="//Invoice//InvoiceHeader/BatchInformation/FileGenerationNo">
									<tr>
										<th width="50%">File Generation No</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/BatchInformation/FileGenerationNo"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/BatchInformation/FileVersionNo">
									<tr>
										<th width="50%">File Version No</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/BatchInformation/FileVersionNo"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/BatchInformation/FileCreationDate">
									<tr>
										<th width="50%">File Creation Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//Invoice//InvoiceHeader/BatchInformation/FileCreationDate)"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/BatchInformation/SendersTransmissionReference">
									<tr>
										<th width="50%">Senders Trans Ref</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/BatchInformation/SendersTransmissionReference"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/BatchInformation/SendersTransmissionDate">
									<tr>
										<th width="50%">Senders Trans Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//Invoice//InvoiceHeader/BatchInformation/SendersTransmissionDate)"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/HeaderExtraData/FinancialPeriod">
									<tr>
										<th width="50%">Financial Period</th>
										<td><xsl:value-of select="substring(//Invoice//InvoiceHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>/<xsl:value-of select="substring(//Invoice//InvoiceHeader/HeaderExtraData/FinancialPeriod, 5)"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceHeader/HeaderExtraData/CodaCompanyCode">
									<tr>
										<th width="50%">Coda Company Code</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/HeaderExtraData/CodaCompanyCode"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%">Tax Point Date</th>
									<td><xsl:value-of select="user:gsFormatDate(//Invoice//InvoiceHeader//InvoiceReferences/TaxPointDate)"/></td>
								</tr>
								<tr>
									<th width="50%">VAT Reg No</th>
									<td><xsl:value-of select="//Invoice//InvoiceHeader//InvoiceReferences/VATRegNo"/></td>
								</tr>
								<xsl:if test="//Invoice//InvoiceHeader/Currency">
									<tr>
										<th width="50%">Currency</th>
										<td><xsl:value-of select="//Invoice//InvoiceHeader/Currency"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/Invoice/InvoiceHeader/HeaderExtraData/StockSystemIdentifier">
									<tr>
										<th width="50%">Stock System Identifier</th>
										<td><xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/StockSystemIdentifier"/></td>
									</tr>
								</xsl:if>
							</table>
						</td>
						<td valign="top" width="50%">
							<!--TradeAgreement-->
							<xsl:choose>
								<xsl:when test="//Invoice//InvoiceDetail//InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement/ContractReference">
									<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
										<tr>
											<th colspan="2">Trade Agreement</th>
										</tr>
										<tr>
											<th width="50%">Contract Reference</th>
											<td><xsl:value-of select="//Invoice//InvoiceDetail//InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement/ContractReference"/></td>
										</tr>
										<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement/ContractDate">
											<tr>
												<th width="50%">Contract Date</th>
												<td><xsl:value-of select="user:gsFormatDate(//Invoice//InvoiceDetail//InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement/ContractDate)"/></td>
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
									<th colspan="18">Invoice Lines</th>
								</tr>
								<xsl:for-each select="//Invoice//InvoiceDetail//InvoiceLine">
									<xsl:sort select="DeliveryNoteReferences/DeliveryNoteReference"/>
									<xsl:sort select="PurchaseOrderReferences/PurchaseOrderReference"/>
									<xsl:if test="user:gbIsNewRefPair(DeliveryNoteReferences/DeliveryNoteReference, PurchaseOrderReferences/PurchaseOrderReference)">
										<xsl:if test="not(//Invoice//InvoiceHeader/DeliveryNoteReferences)">
											<tr>
												<th colspan="3" align="left">DN Ref</th>
												<td colspan="15">
													<xsl:choose>
														<xsl:when test="DeliveryNoteReferences/DeliveryNoteReference"><xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/></xsl:when>
														<xsl:otherwise>{Not Supplied}</xsl:otherwise>
													</xsl:choose>
												</td>
											</tr>
											<xsl:if test="DeliveryNoteReferences/DeliveryNoteDate">
												<tr>
													<th colspan="3" align="left">DN Date</th>
													<td colspan="15">
														<xsl:value-of select="user:gsFormatDate(DeliveryNoteReferences/DeliveryNoteDate)"/>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="DeliveryDate">
												<tr>
													<th colspan="3" align="left">Despatch/Delivery Date</th>
													<td colspan="15">
														<xsl:value-of select="user:gsFormatDate(DeliveryNoteReferences/DespatchDate)"/>
													</td>
												</tr>
											</xsl:if>
										</xsl:if>
										<xsl:if test="not(//Invoice//InvoiceHeader/PurchaseOrderReferences)">
											<tr>
												<th colspan="3" align="left">PO Ref</th>
												<td colspan="15">
													<xsl:choose>
														<xsl:when test="PurchaseOrderReferences/PurchaseOrderReference"><xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/></xsl:when>
														<xsl:otherwise>{Not Supplied}</xsl:otherwise>
													</xsl:choose>
												</td>
											</tr>
											<xsl:if test="PurchaseOrderReferences/PurchaseOrderDate">
												<tr>
													<th colspan="3" align="left">PO Date</th>
													<td colspan="15">
														<xsl:value-of select="user:gsFormatDate(PurchaseOrderReferences/PurchaseOrderDate)"/>
													</td>
												</tr>
											</xsl:if>
										</xsl:if>
										<tr>	
											<xsl:if test="not(//Invoice//InvoiceHeader/DeliveryNoteReferences) and not(//Invoice//InvoiceHeader/PurchaseOrderReferences)">
												<td width="20" rowspan="2">&#xa0;</td>
											</xsl:if>
											<th rowspan="2"/>
											<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/LineExtraData/ProductGroup">
												<th rowspan="2">Product Group</th>
											</xsl:if>
											<th rowspan="2">Suppliers Code</th>
											<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/ProductID/BuyersProductCode">
												<th rowspan="2">Buyers Code</th>
											</xsl:if>
											<th rowspan="2">Description</th>
											<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/ConfirmedQuantity">
												<th colspan="2">Confirmed</th>
											</xsl:if>
											<th colspan="2">Invoiced</th>
											<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/PackSize">
												<th rowspan="2">Pack</th>
											</xsl:if>
											<th rowspan="2">Price</th>
											<th rowspan="2">Line Value</th>
											<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/LineDiscountRate">
												<th rowspan="2">Disc %</th>
											</xsl:if>
											<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/LineDiscountValue">
												<th rowspan="2">Disc</th>
											</xsl:if>
											<th rowspan="2">VAT Code</th>
											<th rowspan="2">VAT %</th>
										</tr>
										<tr>
											<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/ConfirmedQuantity">
												<th>Qty</th>
												<th>UOM</th>
											</xsl:if>
											<th>Qty</th>
											<th>UOM</th>
										</tr>
									</xsl:if>
									<tr>
										<xsl:attribute name="class">
											<xsl:value-of select="user:gsGetRowClass()"/>
										</xsl:attribute>
										<xsl:if test="not(//Invoice//InvoiceHeader/DeliveryNoteReferences) and not(//Invoice//InvoiceHeader/PurchaseOrderReferences)">
											<td width="20">&#xa0;</td>
										</xsl:if>
										<td align="center"><xsl:value-of select="LineNumber"/></td>
										<xsl:if test="LineExtraData/ProductGroup">
											<td><xsl:value-of select="LineExtraData/ProductGroup"/>&#xa0;</td>
										</xsl:if>
										<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
										<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/ProductID/BuyersProductCode">
											<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
										</xsl:if>
										<td><xsl:value-of select="ProductDescription"/></td>
										<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/ConfirmedQuantity">
											<td align="right"><xsl:value-of select="format-number(ConfirmedQuantity,'0.0000')"/></td>
											<td align="right"><xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/></td>
										</xsl:if>
										<td align="right"><xsl:value-of select="format-number(InvoicedQuantity,'0.0000')"/></td>
										<td align="right"><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></td>
										<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/PackSize">
											<td align="right"><xsl:value-of select="PackSize"/>&#xa0;</td>
										</xsl:if>
										<td align="right"><xsl:value-of select="format-number(UnitValueExclVAT, '0.00')"/></td>
										<td align="right"><xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/></td>
										<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/LineDiscountRate">
											<td align="right">
												<xsl:if test="LineDiscountRate">
													<xsl:value-of select="format-number(LineDiscountRate, '0.00')"/>
												</xsl:if>
												&#xa0;
											</td>
										</xsl:if>
										<xsl:if test="//Invoice//InvoiceDetail//InvoiceLine/LineDiscountValue">
											<td align="right">
												<xsl:if test="LineDiscountValue">
													<xsl:value-of select="format-number(LineDiscountValue, '0.00')"/>
												</xsl:if>
												&#xa0;
											</td>
										</xsl:if>
										<td align="right"><xsl:value-of select="VATCode"/></td>
										<td align="right"><xsl:value-of select="format-number(VATRate,'0.00')"/></td>
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
									<th colspan="9">VAT SubTotals</th>
								</tr>
								<tr>
									<th>VAT Code</th>
									<th>VAT %</th>
									<th>No. Lines</th>
									<xsl:if test="//Invoice//InvoiceTrailer/VATSubTotals/VATSubTotal/NumberOfItemsAtRate">
										<th>No. Items</th>
									</xsl:if>
									<th>Lines Total</th>
									<th>Disc</th>
									<th>Settlement Disc</th>
									<th>Taxable Total</th>
									<th>VAT</th>
								</tr>
								<xsl:for-each select="//Invoice//InvoiceTrailer/VATSubTotals/VATSubTotal">
									<tr>
										<xsl:attribute name="class">
											<xsl:value-of select="user:gsGetRowClass()"/>
										</xsl:attribute>
										<td><xsl:value-of select="@VATCode"/></td>
										<td align="right"><xsl:value-of select="format-number(@VATRate,'0.00')"/></td>
										<td align="right"><xsl:value-of select="NumberOfLinesAtRate"/></td>
										<xsl:if test="//Invoice//InvoiceTrailer/VATSubTotals/VATSubTotal/NumberOfItemsAtRate">
											<td align="right"><xsl:value-of select="NumberOfItemsAtRate"/></td>
										</xsl:if>
										<td align="right">
											<xsl:choose>
												<xsl:when test="DiscountedLinesTotalExclVATAtRate"><xsl:value-of select="format-number(DiscountedLinesTotalExclVATAtRate, '0.00')"/></xsl:when>
												<xsl:otherwise><xsl:value-of select="format-number(DiscountedTotalExclVATAtRate, '0.00')"/></xsl:otherwise>
											</xsl:choose>
										</td>
										<td align="right"><xsl:value-of select="format-number(DocumentDiscountAtRate, '0.00')"/></td>
										<td align="right"><xsl:value-of select="format-number(SettlementDiscountAtRate, '0.00')"/></td>
										<td align="right">
											<xsl:choose>
												<xsl:when test="SettlementTotalExclVATAtRate"><xsl:value-of select="format-number(SettlementTotalExclVATAtRate, '0.00')"/></xsl:when>
												<xsl:otherwise><xsl:value-of select="format-number(TaxableTotalExclVATAtRate, '0.00')"/></xsl:otherwise>
											</xsl:choose>
										</td>
										<td align="right"><xsl:value-of select="format-number(VATAmountAtRate, '0.00')"/></td>
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
									<td align="right"><xsl:value-of select="//Invoice//InvoiceTrailer/NumberOfLines"/></td>
								</tr>
								<xsl:if test="//Invoice//InvoiceTrailer/DocumentDiscountRate">
									<tr>
										<th width="50%">Document Disc %</th>
										<td align="right"><xsl:value-of select="format-number(//Invoice//InvoiceTrailer/DocumentDiscountRate, '0.00')"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceTrailer/SettlementDiscountRate">
									<tr>
										<th width="50%">Settlement Disc %</th>
										<td align="right"><xsl:value-of select="format-number(//Invoice//InvoiceTrailer/SettlementDiscountRate, '0.00')"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//Invoice//InvoiceTrailer/SettlementDiscountRate/@SettlementDiscountDays">
									<tr>
										<th width="50%">Settlement Discount Days</th>
										<td align="right"><xsl:value-of select="//Invoice//InvoiceTrailer/SettlementDiscountRate/@SettlementDiscountDays"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%">Document Total</th>
									<td align="right"><xsl:value-of select="format-number(//Invoice//InvoiceTrailer/DocumentTotalExclVAT, '0.00')"/></td>
								</tr>
								<tr>
									<th width="50%">Settlement Total</th>
									<td align="right"><xsl:value-of select="format-number(//Invoice//InvoiceTrailer/SettlementTotalExclVAT, '0.00')"/></td>
								</tr>
								<tr>
									<th width="50%">VAT Amount</th>
									<td align="right"><xsl:value-of select="format-number(//Invoice//InvoiceTrailer/VATAmount, '0.00')"/></td>
								</tr>
								<tr>
									<th width="50%">Document Total Incl VAT</th>
									<td align="right"><xsl:value-of select="format-number(//Invoice//InvoiceTrailer/DocumentTotalInclVAT, '0.00')"/></td>
								</tr>
								<tr>
									<th width="50%">Settlement Total Incl VAT</th>
									<td align="right"><xsl:value-of select="format-number(//Invoice//InvoiceTrailer/SettlementTotalInclVAT, '0.00')"/></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>	
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>