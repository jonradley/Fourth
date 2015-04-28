<!--
'******************************************************************************************
' BRANCHES LOCATED IN: SSP, SSP Equipment Ordering
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Credit Note into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 04/03/2004 | A Sheppard | Created module.
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
									<th align="center">Credit Note (<xsl:value-of select="//CreditNote//CreditNoteHeader/DocumentStatus"/>)</th>
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
								<xsl:if test="//CreditNote//CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/Buyer/BuyersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/Buyer/BuyersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
											<xsl:if test="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress/AddressLine2">
												<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress/AddressLine3">
												<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress/AddressLine4">
												<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress/PostCode">
												<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/Buyer/BuyersAddress/PostCode"/>
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
								<xsl:if test="//CreditNote//CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/Supplier/SuppliersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/Supplier/SuppliersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
											<xsl:if test="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2">
												<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3">
												<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4">
												<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress/PostCode">
												<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/Supplier/SuppliersAddress/PostCode"/>
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
								<xsl:if test="//CreditNote//CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/ShipTo/ContactName">
									<tr>
										<th width="50%">Contact Name</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/ShipTo/ContactName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/ShipTo/ShipToName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/ShipTo/ShipToName"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%" valign="top">Address</th>
									<td>
										<xsl:value-of select="//CreditNote//CreditNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
										<xsl:if test="//CreditNote//CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2">
											<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
										</xsl:if>
										<xsl:if test="//CreditNote//CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3">
											<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
										</xsl:if>
										<xsl:if test="//CreditNote//CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4">
											<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4"/>
										</xsl:if>
										<xsl:if test="//CreditNote//CreditNoteHeader/ShipTo/ShipToAddress/PostCode">
											<br/><xsl:value-of select="//CreditNote//CreditNoteHeader/ShipTo/ShipToAddress/PostCode"/>
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
									<th width="50%">CRN Ref</th>
									<td><xsl:value-of select="//CreditNote//CreditNoteHeader//CreditNoteReferences//CreditNoteReference"/></td>
								</tr>
								<tr>
									<th width="50%">CRN Date</th>
									<td><xsl:value-of select="user:gsFormatDate(//CreditNote//CreditNoteHeader//CreditNoteReferences//CreditNoteDate)"/></td>
								</tr>
								<tr>
									<th width="50%">INV Ref</th>
									<td><xsl:value-of select="//CreditNote//CreditNoteHeader/InvoiceReferences/InvoiceReference"/></td>
								</tr>
								<tr>
									<th width="50%">INV Date</th>
									<td><xsl:value-of select="user:gsFormatDate(//CreditNote//CreditNoteHeader/InvoiceReferences/InvoiceDate)"/></td>
								</tr>
								<xsl:if test="//CreditNote//CreditNoteHeader/DeliveryNoteReferences">
									<tr>
										<th width="50%">DN Ref</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/></td>
									</tr>
									<tr>
										<th width="50%">DN Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//CreditNote//CreditNoteHeader/DeliveryNoteReferences/DeliveryNoteDate)"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/PurchaseOrderReferences">
									<tr>
										<th width="50%">PO Ref</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
									</tr>
									<tr>
										<th width="50%">PO Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//CreditNote//CreditNoteHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
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
								<xsl:if test="//CreditNote//CreditNoteHeader/BatchInformation/FileGenerationNo">
									<tr>
										<th width="50%">File Generation No</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/BatchInformation/FileGenerationNo"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/BatchInformation/FileVersionNo">
									<tr>
										<th width="50%">File Version No</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/BatchInformation/FileVersionNo"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/BatchInformation/FileCreationDate">
									<tr>
										<th width="50%">File Creation Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//CreditNote//CreditNoteHeader/BatchInformation/FileCreationDate)"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/BatchInformation/SendersTransmissionReference">
									<tr>
										<th width="50%">Senders Trans Ref</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/BatchInformation/SendersTransmissionReference"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/BatchInformation/SendersTransmissionDate">
									<tr>
										<th width="50%">Senders Trans Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//CreditNote//CreditNoteHeader/BatchInformation/SendersTransmissionDate)"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/HeaderExtraData/FinancialPeriod">
									<tr>
										<th width="50%">Financial Period</th>
										<td><xsl:value-of select="substring(//CreditNote//CreditNoteHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>/<xsl:value-of select="substring(//CreditNote//CreditNoteHeader/HeaderExtraData/FinancialPeriod, 5)"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteHeader/HeaderExtraData/CodaCompanyCode">
									<tr>
										<th width="50%">Coda Company Code</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/HeaderExtraData/CodaCompanyCode"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%">INV Tax Point Date</th>
									<td><xsl:value-of select="user:gsFormatDate(//CreditNote//CreditNoteHeader/InvoiceReferences/TaxPointDate)"/></td>
								</tr>
								<tr>
									<th width="50%">INV VAT Reg No</th>
									<td><xsl:value-of select="//CreditNote//CreditNoteHeader/InvoiceReferences/VATRegNo"/></td>
								</tr>
								<tr>
									<th width="50%">CRN Tax Point Date</th>
									<td><xsl:value-of select="user:gsFormatDate(//CreditNote//CreditNoteHeader//CreditNoteReferences/TaxPointDate)"/></td>
								</tr>
								<tr>
									<th width="50%">CRN VAT Reg No</th>
									<td><xsl:value-of select="//CreditNote//CreditNoteHeader//CreditNoteReferences/VATRegNo"/></td>
								</tr>
								<xsl:if test="//CreditNote//CreditNoteHeader/Currency">
									<tr>
										<th width="50%">Currency</th>
										<td><xsl:value-of select="//CreditNote//CreditNoteHeader/Currency"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditNote/CreditNoteHeader/HeaderExtraData/StockSystemIdentifier">
									<tr>
										<th width="50%">Stock System Identifier</th>
										<tr><xsl:value-of select="/CreditNote/CreditNoteHeader/HeaderExtraData/StockSystemIdentifier"/></tr>
									</tr>
								</xsl:if>
							</table>
						</td>
						<td valign="top" width="50%">
							<!--TradeAgreement-->
							<xsl:choose>
								<xsl:when test="//CreditNote//CreditNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
									<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
										<tr>
											<th colspan="2">Trade Agreement</th>
										</tr>
										<tr>
											<th width="50%">Contract Reference</th>
											<td><xsl:value-of select="//CreditNote//CreditNoteDetail//CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement/ContractReference"/></td>
										</tr>
										<xsl:if test="//CreditNote//CreditNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
											<tr>
												<th width="50%">Contract Date</th>
												<td><xsl:value-of select="user:gsFormatDate(//CreditNote//CreditNoteDetail//CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement/ContractDate)"/></td>
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
									<th colspan="18">Credit Note Lines</th>
								</tr>
								<xsl:for-each select="//CreditNote//CreditNoteDetail//CreditNoteLine">
									<xsl:sort select="DeliveryNoteReferences/DeliveryNoteReference"/>
									<xsl:sort select="PurchaseOrderReferences/PurchaseOrderReference"/>
									<xsl:if test="user:gbIsNewRefPair(DeliveryNoteReferences/DeliveryNoteReference, PurchaseOrderReferences/PurchaseOrderReference)">
										<xsl:if test="not(//CreditNote//CreditNoteHeader/DeliveryNoteReferences)">
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
													<th colspan="3" align="left">Delivery/Despatch Date</th>
													<td colspan="15">
														<xsl:value-of select="user:gsFormatDate(DeliveryNoteReferences/DespatchDate)"/>
													</td>
												</tr>
											</xsl:if>	
										</xsl:if>
										<xsl:if test="not(//CreditNote//CreditNoteHeader/PurchaseOrderReferences)">
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
											<xsl:if test="not(//CreditNote//CreditNoteHeader/DeliveryNoteReferences) and not(//CreditNote//CreditNoteHeader/PurchaseOrderReferences)">
												<td width="20" rowspan="2">&#xa0;</td>
											</xsl:if>
											<th rowspan="2"/>
											<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/LineExtraData/ProductGroup">
												<th rowspan="2">Product Group</th>
											</xsl:if>
											<th rowspan="2">Suppliers Code</th>
											<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/ProductID/BuyersProductCode">
												<th rowspan="2">Buyers Code</th>
											</xsl:if>
											<th rowspan="2">Description</th>
											<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/InvoicedQuantity">
												<th colspan="2">Invoiced</th>
											</xsl:if>
											<th colspan="2">Credited</th>
											<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/PackSize">
												<th rowspan="2">Pack</th>
											</xsl:if>
											<th rowspan="2">Price</th>
											<th rowspan="2">Line Value</th>
											<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/LineDiscountRate">
												<th rowspan="2">Disc %</th>
											</xsl:if>
											<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/LineDiscountValue">
												<th rowspan="2">Disc</th>
											</xsl:if>
											<th rowspan="2">VAT Code</th>
											<th rowspan="2">VAT %</th>
										</tr>
										<tr>
											<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/InvoicedQuantity">
												<th>Qty</th>
												<th>UOM</th>
											</xsl:if>
											<th>Qty</th>
											<th>UOM</th>
										</tr>
									</xsl:if>
									<xsl:variable name="RowClass">
										<xsl:value-of select="user:gsGetRowClass()"/>
									</xsl:variable>
									<tr>
										<xsl:attribute name="class">
											<xsl:value-of select="$RowClass"/>
										</xsl:attribute>
										<xsl:if test="not(//CreditNote//CreditNoteHeader/DeliveryNoteReferences) and not(//CreditNote//CreditNoteHeader/PurchaseOrderReferences)">
											<td width="20">&#xa0;</td>
										</xsl:if>
										<td align="center"><xsl:value-of select="LineNumber"/></td>
										<xsl:if test="LineExtraData/ProductGroup">
											<td><xsl:value-of select="LineExtraData/ProductGroup"/>&#xa0;</td>
										</xsl:if>
										<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
										<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/ProductID/BuyersProductCode">
											<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
										</xsl:if>
										<td><xsl:value-of select="ProductDescription"/></td>
										<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/InvoicedQuantity">
											<td align="right">
												<xsl:if test="InvoicedQuantity">
													<xsl:value-of select="format-number(InvoicedQuantity,'0.0000')"/>
												</xsl:if>
												&#xa0;
											</td>
											<td align="right">
												<xsl:if test="InvoicedQuantity">
													<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
												</xsl:if>
												&#xa0;
											</td>
										</xsl:if>
										<td align="right"><xsl:value-of select="format-number(CreditedQuantity,'0.0000')"/></td>
										<td align="right"><xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/></td>
										<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/PackSize">
											<td align="right"><xsl:value-of select="PackSize"/>&#xa0;</td>
										</xsl:if>
										<td align="right"><xsl:value-of select="format-number(UnitValueExclVAT, '0.00')"/></td>
										<td align="right"><xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/></td>
										<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/LineDiscountRate">
											<td align="right">
												<xsl:if test="LineDiscountRate">
													<xsl:value-of select="format-number(LineDiscountRate, '0.00')"/>
												</xsl:if>
												&#xa0;
											</td>
										</xsl:if>
										<xsl:if test="//CreditNote//CreditNoteDetail//CreditNoteLine/LineDiscountValue">
											<td align="right">
												<xsl:if test="LineDiscountValue">
													<xsl:value-of select="format-number(LineDiscountValue, '0.00')"/>
												</xsl:if>
												&#xa0;
											</td>
										</xsl:if>
										<td align="right"><xsl:value-of select="VATCode"/></td>
										<td align="right"><xsl:value-of select="format-number(VATRate, '0.00')"/></td>
									</tr>
									<xsl:if test="Narrative">
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="$RowClass"/>
											</xsl:attribute>
											<xsl:if test="not(//CreditNote//CreditNoteHeader/DeliveryNoteReferences) and not(//CreditNote//CreditNoteHeader/PurchaseOrderReferences)">
												<td width="20">&#xa0;</td>
											</xsl:if>
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
									<th colspan="9">VAT SubTotals</th>
								</tr>
								<tr>
									<th>VAT Code</th>
									<th>VAT %</th>
									<th>No. Lines</th>
									<xsl:if test="//CreditNote//CreditNoteTrailer/VATSubTotals/VATSubTotal/NumberOfItemsAtRate">
										<th>No. Items</th>
									</xsl:if>
									<th>Lines Total</th>
									<th>Disc</th>
									<th>Settlement Disc</th>
									<th>Taxable Total</th>
									<th>VAT</th>
								</tr>
								<xsl:for-each select="//CreditNote//CreditNoteTrailer/VATSubTotals/VATSubTotal">
									<tr>
										<xsl:attribute name="class">
											<xsl:value-of select="user:gsGetRowClass()"/>
										</xsl:attribute>
										<td><xsl:value-of select="@VATCode"/></td>
										<td align="right"><xsl:value-of select="format-number(@VATRate, '0.00')"/></td>
										<td align="right"><xsl:value-of select="NumberOfLinesAtRate"/></td>
										<xsl:if test="//CreditNote//CreditNoteTrailer/VATSubTotals/VATSubTotal/NumberOfItemsAtRate">
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
									<td align="right"><xsl:value-of select="//CreditNote//CreditNoteTrailer/NumberOfLines"/></td>
								</tr>
								<xsl:if test="//CreditNote//CreditNoteTrailer/DocumentDiscountRate">
									<tr>
										<th width="50%">Document Disc %</th>
										<td align="right"><xsl:value-of select="format-number(//CreditNote//CreditNoteTrailer/DocumentDiscountRate, '0.00')"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteTrailer/SettlementDiscountRate">
									<tr>
										<th width="50%">Settlement Disc %</th>
										<td align="right"><xsl:value-of select="format-number(//CreditNote//CreditNoteTrailer/SettlementDiscountRate, '0.00')"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//CreditNote//CreditNoteTrailer/SettlementDiscountRate/@SettlementDiscountDays">
									<tr>
										<th width="50%">Settlement Discount Days</th>
										<td align="right"><xsl:value-of select="//CreditNote//CreditNoteTrailer/SettlementDiscountRate/@SettlementDiscountDays"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%">Document Total</th>
									<td align="right"><xsl:value-of select="format-number(//CreditNote//CreditNoteTrailer/DocumentTotalExclVAT, '0.00')"/></td>
								</tr>
								<tr>
									<th width="50%">Settlement Total</th>
									<td align="right"><xsl:value-of select="format-number(//CreditNote//CreditNoteTrailer/SettlementTotalExclVAT, '0.00')"/></td>
								</tr>
								<tr>
									<th width="50%">VAT Amount</th>
									<td align="right"><xsl:value-of select="format-number(//CreditNote//CreditNoteTrailer/VATAmount, '0.00')"/></td>
								</tr>
								<tr>
									<th width="50%">Document Total Incl VAT</th>
									<td align="right"><xsl:value-of select="format-number(//CreditNote//CreditNoteTrailer/DocumentTotalInclVAT, '0.00')"/></td>
								</tr>
								<tr>
									<th width="50%">Settlement Total Incl VAT</th>
									<td align="right"><xsl:value-of select="format-number(//CreditNote//CreditNoteTrailer/SettlementTotalInclVAT, '0.00')"/></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>	
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>