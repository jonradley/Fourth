<!--
'******************************************************************************************
' BRANCHES LOCATED IN: SSP, SSP Equipment Ordering
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Purchase Order Confirmation into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 02/02/2004 | A Sheppard | Created module.
******************************************************************************************
 07/04/2005 | A Sheppard | Added print button
******************************************************************************************
 20/04/2005 | A Sheppard | Added contact name
******************************************************************************************
 29/07/2005 | S Hewitt       | H438, COM020. Changed the back colour when the delivery dates do not match
****************************************************************************************** 
 10/08/2005 | S Hewitt       | Small fixes for H438 
******************************************************************************************
 30/08/2005 | A Sheppard | H488. Display subtituted product code if present
******************************************************************************************
 22/09/2005 | A Sheppard | H495. Converted to outbound mapping xsl.
****************************************************************************************** 
 18/01/2006 | A Sheppard | H548. Change Buyer to Buyer/Invoice To
****************************************************************************************** 
 10/09/2006 | Lee Boyton | 452. Changed the style for 'Added' lines to differentiate between 'Accepted' lines.
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="html"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	
	<!-- constants for default values -->
	<xsl:variable name="changedLineClass" select="'Changed'"/>
	
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
				    BACKGROUND-COLOR: plum
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
									<th align="center">Purchase Order Confirmation (<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/DocumentStatus"/>)</th>
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
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine1"/>
											<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine2">
												<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine3">
												<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine4">
												<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/PostCode">
												<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersAddress/PostCode"/>
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
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine1"/>
											<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine2">
												<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine3">
												<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine4">
												<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/PostCode">
												<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersAddress/PostCode"/>
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
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ContactName">
									<tr>
										<th width="50%">Contact Name</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ContactName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToName"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%" valign="top">Address</th>
									<td>
										<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1"/>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2">
											<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2"/>
										</xsl:if>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3">
											<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3"/>
										</xsl:if>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4">
											<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4"/>
										</xsl:if>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode">
											<br/><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode"/>
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
									<th width="50%">Ord Del Type</th>
									<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryType"/></td>
								</tr>
								<tr>
									<th width="50%">Ord Del Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate)"/></td>
								</tr>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliverySlot">
									<tr>
										<th width="50%">Ord Slot Start</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/></td>
									</tr>
									<tr>
										<th width="50%">Ord Slot End</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%">Conf Del Type</th>
									<td>
										<!-- the cell colour may now be overridden by the two delivery types not matching -->
										<xsl:choose>
											<xsl:when test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryType != /PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryType">
												<xsl:attribute name="class">
													<xsl:value-of select="$changedLineClass"/>
												</xsl:attribute>
											</xsl:when>
										</xsl:choose>							
										<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryType"/>
									</td>
								</tr>
								
								<tr>
									<th width="50%">Conf Del Date</th>
									<td>
										<!-- the cell colour may now be overridden by the dates not matching -->
										<xsl:choose>
											<xsl:when test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate != /PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate">
												<xsl:attribute name="class">
													<xsl:value-of select="$changedLineClass"/>
												</xsl:attribute>
											</xsl:when>
										</xsl:choose>
										<xsl:value-of select="user:gsFormatDate(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate)"/>
									</td>
								</tr>
													
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot">
									<tr>
										<th width="50%">Conf Slot Start</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart"/></td>
									</tr>
									<tr>
										<th width="50%">Conf Slot End</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotEnd"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">
									<tr>
										<th width="50%">Special Del Instructions</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/></td>
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
							<!--References-->
							<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
								<tr>
									<th colspan="2">References</th>
								</tr>
								<tr>
									<th width="50%">POConf Ref</th>
									<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/></td>
								</tr>
								<tr>
									<th width="50%">POConf Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate)"/></td>
								</tr>
								<tr>
									<th width="50%">PO Ref</th>
									<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
								</tr>
								<tr>
									<th width="50%">PO Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
								</tr>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
									<tr>
										<th width="50%">Customers PO Ref</th>
										<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/></td>
									</tr>
								</xsl:if>
							</table>
						</td>
						<td valign="top" width="50%">
							<!--TradeAgreement-->
							<xsl:choose>
								<xsl:when test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
									<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
										<tr>
											<th colspan="2">Trade Agreement</th>
										</tr>
										<tr>
											<th width="50%">Contract Reference</th>
											<td><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/></td>
										</tr>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
											<tr>
												<th width="50%">Contract Date</th>
												<td><xsl:value-of select="user:gsFormatDate(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/TradeAgreement/ContractDate)"/></td>
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
									<th rowspan="2"/>
									<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/ProductID/SuppliersProductCode">
										<th rowspan="2">Suppliers Code</th>
									</xsl:if>
									<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/ProductID/BuyersProductCode">
										<th rowspan="2">Buyers Code</th>
									</xsl:if>
									<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/SubstitutedProductID/SuppliersProductCode">
										<th rowspan="2">Substituted Product</th>
									</xsl:if>
									<th rowspan="2">Description</th>
									<th colspan="2">Ordered</th>
									<th colspan="2">Confirmed</th>
									<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/PackSize">
										<th rowspan="2">Pack</th>
									</xsl:if>
									<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/UnitValueExclVAT">
										<th rowspan="2">Price</th>
									</xsl:if>
									<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/LineValueExclVAT">
										<th rowspan="2">Line Value</th>
									</xsl:if>
								</tr>
								<tr>
									<th>Qty</th>
									<th>UOM</th>
									<th>Qty</th>
									<th>UOM</th>
								</tr>
								<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
									<tr>
										<xsl:attribute name="class">
											<xsl:value-of select="@LineStatus"/>
										</xsl:attribute>								
										<td align="center"><xsl:value-of select="LineNumber"/></td>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/ProductID/SuppliersProductCode">
											<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
										</xsl:if>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/ProductID/BuyersProductCode">
											<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
										</xsl:if>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/SubstitutedProductID/SuppliersProductCode">
											<td><xsl:value-of select="SubstitutedProductID/SuppliersProductCode"/>&#xa0;</td>
										</xsl:if>
										<td><xsl:value-of select="ProductDescription"/></td>
										<td align="right"><xsl:value-of select="format-number(OrderedQuantity, '0.0000')"/></td>
										<td align="right"><xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/></td>
										<td align="right"><xsl:value-of select="format-number(ConfirmedQuantity, '0.0000')"/></td>
										<td align="right"><xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/></td>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/PackSize">
											<td align="right"><xsl:value-of select="PackSize"/>&#xa0;</td>
										</xsl:if>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/UnitValueExclVAT">
											<td align="right">
												<xsl:if test="UnitValueExclVAT">
													<xsl:value-of select="format-number(UnitValueExclVAT, '0.00')"/>
												</xsl:if>
												&#xa0;
											</td>
										</xsl:if>
										<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/LineValueExclVAT">
											<td align="right">
												<xsl:if test="LineValueExclVAT">
													<xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/>
												</xsl:if>
												&#xa0;
											</td>
										</xsl:if>
									</tr>
									<xsl:if test="Narrative">
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="@LineStatus"/>
											</xsl:attribute>
											<td colspan="13">
												<xsl:if test="Narrative/@Code"><xsl:value-of select="Narrative/@Code"/>: </xsl:if><xsl:value-of select="Narrative"/>
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
									<td align="right"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationTrailer/NumberOfLines"/></td>
								</tr>
								<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationTrailer/TotalExclVAT">
									<tr>
										<th width="50%">Total Excl VAT</th>
										<td align="right"><xsl:value-of select="format-number(/PurchaseOrderConfirmation/PurchaseOrderConfirmationTrailer/TotalExclVAT, '0.00')"/></td>
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