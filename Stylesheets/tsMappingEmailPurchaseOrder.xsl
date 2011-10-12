<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Purchase Order into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 02/02/2004 | A Sheppard | Created module.
******************************************************************************************
 30/09/2005 | Lee Boyton | H488. Added banner for test documents.
****************************************************************************************** 
 18/01/2006 | A Sheppard | H548. Change Buyer to Buyer/Invoice To
******************************************************************************************
 23/10/2007 | Lee Boyton | FB1542. Added contact name
****************************************************************************************** 
 03/12/2008 | A Sheppard | 2581. Added narrative row if required
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
					<!-- if this is a test document then add a distinctive banner to indicate this fact -->
					<xsl:if test="/PurchaseOrder/TradeSimpleHeader/TestFlag = 'true' or /PurchaseOrder/TradeSimpleHeader/TestFlag = '1'">
						<tr>
							<td align="center" colspan="2">
								<table class="Test" width="100%">
									<tr>
										<td align="center"><b>TEST ORDER</b></td>		
									</tr>
									<tr>
										<td><b>This order should <u>not</u> be fulfilled.</b> This order has been generated from the ABS test Portal or under a test account from the live Portal. It is a test order, and does not constitute a request for provisions or services. If you have received this on a live trading account, then please contact the ABS Helpdesk team on 01993 899294.</td>
									</tr>
								</table>
							</td>
						</tr>
					</xsl:if>				
					<!--Header-->
					<tr>
						<td align="center" colspan="2">
							<table width="100%">
								<tr>
									<th align="center">Purchase Order (<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/DocumentStatus"/>)</th>		
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
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1"/>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2">
												<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3">
												<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4">
												<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/PostCode">
												<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/PostCode"/>
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
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1"/>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2">
												<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3">
												<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4">
												<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode">
												<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode"/>
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
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ContactName">
									<tr>
										<th width="50%">Contact Name</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ContactName"/></td>
									</tr>
								</xsl:if>								
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%" valign="top">Address</th>
									<td>
										<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
										<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2">
											<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
										</xsl:if>
										<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3">
											<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
										</xsl:if>
										<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4">
											<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
										</xsl:if>
										<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode">
											<br/><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
										</xsl:if>
									</td>
								</tr>
							</table>
						</td>
						<td valign="top" width="50%">
							<!--Delivery Details-->
							<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
								<tr>
									<th colspan="2">Delivery</th>
								</tr>
								<tr>
									<th width="50%">Delivery Type</th>
									<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryType"/></td>
								</tr>
								<tr>
									<th width="50%">Delivery Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate)"/></td>
								</tr>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot">
									<tr>
										<th width="50%">Slot Start</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/></td>
									</tr>
									<tr>
										<th width="50%">Slot End</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">
									<tr>
										<th width="50%">Special Delivery Instructions</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/></td>
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
							<!--PO References-->
							<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
								<tr>
									<th colspan="2">References</th>
								</tr>
								<tr>
									<th width="50%">PO Ref</th>
									<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
								</tr>
								<tr>
									<th width="50%">PO Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
								</tr>
								<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
									<tr>
										<th width="50%">Customers PO Ref</th>
										<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/></td>
									</tr>
								</xsl:if>
							</table>
						</td>
						<td valign="top" width="50%">
							<!--TradeAgreement-->
							<xsl:choose>
								<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
									<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
										<tr>
											<th colspan="2">Trade Agreement</th>
										</tr>
										<tr>
											<th width="50%">Contract Ref</th>
											<td><xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/></td>
										</tr>
										<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
											<tr>
												<th width="50%">Contract Date</th>
												<td><xsl:value-of select="user:gsFormatDate(/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate)"/></td>
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
							<!--Order Lines-->
							<table class="DocumentLines" cellpadding="1" cellspacing="1">
								<tr>
									<th/>
									<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/ProductID/SuppliersProductCode">
										<th>Suppliers Code</th>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/ProductID/BuyersProductCode">
										<th>Buyers Code</th>
									</xsl:if>
									<th>Description</th>
									<th>Qty</th>
									<th>UOM</th>
									<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/PackSize">
										<th>Pack</th>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/UnitValueExclVAT">
										<th>Price</th>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/LineValueExclVAT">
										<th>Line Value</th>
									</xsl:if>
								</tr>
								<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
									<xsl:variable name="RowClass">
										<xsl:value-of select="user:gsGetRowClass()"/>
									</xsl:variable>
									<tr>
										<xsl:attribute name="class">
											<xsl:value-of select="@RowClass"/>
										</xsl:attribute>
										<td align="center"><xsl:value-of select="LineNumber"/></td>
										<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/ProductID/SuppliersProductCode">
											<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
										</xsl:if>
										<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/ProductID/BuyersProductCode">
											<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
										</xsl:if>
										<td><xsl:value-of select="ProductDescription"/></td>
										<td align="right">
											<xsl:value-of select="format-number(OrderedQuantity,'0.0000')"/>
										</td>
										<td align="right"><xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/></td>
										<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/PackSize">
											<td align="right"><xsl:value-of select="PackSize"/>&#xa0;</td>
										</xsl:if>
										<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/UnitValueExclVAT">
											<td align="right">
												<xsl:if test="UnitValueExclVAT">
													<xsl:value-of select="format-number(UnitValueExclVAT, '0.00')"/>
												</xsl:if>
												&#xa0;
											</td>
										</xsl:if>
										<xsl:if test="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/LineValueExclVAT">
											<td align="right">
												<xsl:if test="LineValueExclVAT">
													<xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/>
												</xsl:if>
												&#xa0;
											</td>
										</xsl:if>
									</tr>
									<xsl:if test="LineExtraData/Narrative">
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="@RowClass"/>
											</xsl:attribute>
											<td>&#xa0;</td>
											<td colspan="7">
												<xsl:value-of select="LineExtraData/Narrative"/>
											</td>
										</tr>
									</xsl:if>
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
									<td align="right"><xsl:value-of select="/PurchaseOrder/PurchaseOrderTrailer/NumberOfLines"/></td>
								</tr>
								<xsl:if test="/PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT">
									<tr>
										<th width="50%">Total Excl VAT</th>
										<td align="right"><xsl:value-of select="format-number(/PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT, '0.00')"/></td>
									</tr>
								</xsl:if>
							</table>
						</td>
					</tr>
				</table>	
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>