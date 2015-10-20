<!--
'******************************************************************************************
' BRANCHES LOCATED IN: SSP
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Delivery Note into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 02/03/2004 | A Sheppard | Created module.
******************************************************************************************
 21/01/2005 | A Sheppard | H301. Format the expiry and sell by dates
******************************************************************************************
 07/04/2005 | A Sheppard | Added print button
******************************************************************************************
 20/04/2005 | A Sheppard | Added contact name
****************************************************************************************** 
 18/01/2006 | A Sheppard | H548. Change Buyer to Buyer/Invoice To
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="html"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	<xsl:template match="/BatchRoot">
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
									<th align="center">Delivery Note (<xsl:value-of select="DeliveryNote/DeliveryNoteHeader/DocumentStatus"/>)</th>
								</tr>
							</table>
						</td>
					</tr>
					<!--Addresses-->
					<tr>
						<td valign="top" width="50%">
							<!--Buyer-->
							<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
								
								<!-- Display the buyer branch (ie 3663 depot) info as if it were the invoice-to party -->
								
								<tr>
									<th colspan="2">Buyer/Invoice To</th>
								</tr>
								<xsl:if test="DeliveryNote/TradeSimpleHeader/SendersCodeForRecipient">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="substring-after(DeliveryNote/TradeSimpleHeader/SendersCodeForRecipient,'/')"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="DeliveryNote/TradeSimpleHeader/SendersCodeForRecipient">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="DeliveryNote/TradeSimpleHeader/SendersCodeForRecipient"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
											<xsl:if test="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine2">
												<br/><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine3">
												<br/><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine4">
												<br/><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToAddress/PostCode">
												<br/><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToAddress/PostCode"/>
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
								<xsl:if test="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
											<xsl:if test="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress/AddressLine2">
												<br/><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress/AddressLine3">
												<br/><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress/AddressLine4">
												<br/><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress/PostCode">
												<br/><xsl:value-of select="DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersAddress/PostCode"/>
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
					
					
					<xsl:for-each select="DeliveryNote">
					
						<tr>
							<td colspan="2"><br/><br/><br/><br/></td>
						</tr>
						
						<tr>
							<td valign="top" width="50%">
								<!--ShipTo-->
								<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
									<tr>
										<th colspan="2">ShipTo</th>
									</tr>
									<xsl:if test="DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
										<tr>
											<th width="50%">Buyers Code</th>
											<td><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
										</tr>
									</xsl:if>
									<xsl:if test="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
										<tr>
											<th width="50%">Suppliers Code</th>
											<td><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
										</tr>
									</xsl:if>

								</table>
							</td>
							
							<td valign="top" width="50%">
								<!--TradeAgreement-->

									<xsl:choose>										

										<xsl:when test="DeliveryNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
										
											<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
										
												<tr>
													<th colspan="2">Trade Agreement</th>
												</tr>
												<tr>
													<th width="50%">Contract Reference</th>
													<td><xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/></td>
												</tr>
												<xsl:if test="DeliveryNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
													<tr>
														<th width="50%">Contract Date</th>
														<td><xsl:value-of select="user:gsFormatDate(DeliveryNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate)"/></td>
													</tr>
												</xsl:if>
												
												<tr><td>&#xa0;</td></tr>
													
											</table>		

										</xsl:when>				
										
									</xsl:choose>
									
									<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
	
										<tr>
											<th colspan="2">Totals</th>
										</tr>
										<tr>
											<th width="50%">Number Of Lines</th>
											<td align="right"><xsl:value-of select="DeliveryNoteTrailer/NumberOfLines"/></td>
										</tr>
										
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
										<th width="50%">DN Ref</th>
										<td><xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/></td>
									</tr>
									<tr>
										<th width="50%">DN Date</th>
										<td><xsl:value-of select="user:gsFormatDate(DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate)"/></td>
									</tr>
									<tr>
										<th width="50%">PO Ref</th>
										<td><xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
									</tr>
									<tr>
										<th width="50%">PO Date</th>
										<td><xsl:value-of select="user:gsFormatDate(DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
									</tr>
									<xsl:if test="DeliveryNoteHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
										<tr>
											<th width="50%">Customers PO Ref</th>
											<td><xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/></td>
										</tr>
									</xsl:if>
								</table>
							</td>
							
							
							<td valign="top" width="50%">
								<!--Delivery Details-->
								<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
									<tr>
										<th colspan="2">Delivery</th>
									</tr>
									<tr>
										<th width="50%">Del Type</th>
										<td><xsl:value-of select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryType"/></td>
									</tr>
									<tr>
										<th width="50%">Del Date</th>
										<td><xsl:value-of select="user:gsFormatDate(DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate)"/></td>
									</tr>
									<xsl:if test="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliverySlot">
										<tr>
											<th width="50%">Slot Start</th>
											<td><xsl:value-of select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliverySlot/SlotStart"/></td>
										</tr>
										<tr>
											<th width="50%">Slot End</th>
											<td><xsl:value-of select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliverySlot/SlotEnd"/></td>
										</tr>
									</xsl:if>
									<tr>
										<th width="50%">Despatch Date</th>
										<td><xsl:value-of select="user:gsFormatDate(DeliveryNoteHeader/DeliveryNoteReferences/DespatchDate)"/></td>
									</tr>
									<xsl:if test="DeliveryNoteHeader/DeliveredDeliveryDetails/SpecialDeliveryInstructions">
										<tr>
											<th width="50%">Special Del Instructions</th>
											<td><xsl:value-of select="DeliveryNoteHeader/DeliveredDeliveryDetails/SpecialDeliveryInstructions"/></td>
										</tr>
									</xsl:if>
								</table>
							</td>
							
							
						</tr>
						<tr>
							<td colspan="2"><br/></td>
						</tr>
						<tr>
							<td colspan="2">
								<!--Delivery Note Lines-->
								<table class="DocumentLines" cellpadding="1" cellspacing="1">
									<tr>
										<th rowspan="2"/>
										<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/ProductID/SuppliersProductCode">
											<th rowspan="2">Suppliers Code</th>
										</xsl:if>
										<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/ProductID/BuyersProductCode">
											<th rowspan="2">Buyers Code</th>
										</xsl:if>
										<th rowspan="2">Description</th>
										<th colspan="2">Ordered</th>
										<th colspan="2">Confirmed</th>
										<th colspan="2">Despatched</th>
										<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/PackSize">
											<th rowspan="2">Pack</th>
										</xsl:if>
										<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/ExpiryDate">
											<th rowspan="2">Expiry Date</th>
										</xsl:if>
										<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/SellByDate">
											<th rowspan="2">Sell By Date</th>
										</xsl:if>
										<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/SSCC">
											<th rowspan="2">SSCC</th>
										</xsl:if>
									</tr>
									<tr>
										<th>Qty</th>
										<th>UOM</th>
										<th>Qty</th>
										<th>UOM</th>
										<th>Qty</th>
										<th>UOM</th>
									</tr>
									<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="user:gsGetRowClass()"/>
											</xsl:attribute>
											<td align="center"><xsl:value-of select="LineNumber"/></td>
											<xsl:if test="ProductID/SuppliersProductCode">
												<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
											</xsl:if>
											<xsl:if test="ProductID/BuyersProductCode">
												<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
											</xsl:if>
											<td><xsl:value-of select="ProductDescription"/></td>
											<td align="right"><xsl:value-of select="format-number(OrderedQuantity,'0.0000')"/></td>
											<td align="right"><xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/></td>
											<td align="right"><xsl:value-of select="format-number(ConfirmedQuantity,'0.0000')"/></td>
											<td align="right"><xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/></td>
											<td align="right"><xsl:value-of select="format-number(DespatchedQuantity,'0.0000')"/></td>
											<td align="right"><xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/></td>
											<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/PackSize">
												<td align="right"><xsl:value-of select="PackSize"/>&#xa0;</td>
											</xsl:if>
											<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/ExpiryDate">
												<td align="right"><xsl:value-of select="user:gsFormatDate(ExpiryDate)"/></td>
											</xsl:if>
											<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/SellByDate">
												<td align="right"><xsl:value-of select="user:gsFormatDate(SellByDate)"/></td>
											</xsl:if>
											<xsl:if test="DeliveryNoteDetail/DeliveryNoteLine/SSCC">
												<td align="right"><xsl:value-of select="SSCC"/></td>
											</xsl:if>
										</tr>
									</xsl:for-each>
								</table>
							</td>
						</tr>
						<!--tr>
							<td><br/></td>
							<td>
								<Totals>
								<table class="DocumentInner" cellpadding="1" cellspacing="1">
									<tr>
										<th colspan="2">Totals</th>
									</tr>
									<tr>
										<th width="50%">Number Of Lines</th>
										<td align="right"><xsl:value-of select="DeliveryNoteTrailer/NumberOfLines"/></td>
									</tr>
								</table>
							</td>
						</tr-->
				
						
					</xsl:for-each>	
					
				</table>	
			
			</body>
		
		</html>
			
	</xsl:template>
</xsl:stylesheet>