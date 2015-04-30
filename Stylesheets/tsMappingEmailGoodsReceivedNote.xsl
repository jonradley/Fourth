<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Goods Received Note into an HTML page for mailing out

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 08/04/2004 | A Sheppard | Created module.
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
				    BACKGROUND-COLOR: #dde6e4
				}
				TABLE.DocumentSurround TH
				{
				    FONT-SIZE: larger
				}
				TABLE.DocumentInner
				{
				    WIDTH: 100%;
				    BACKGROUND-COLOR: white
				}
				TABLE.DocumentInner TH
				{
				    FONT-SIZE: smaller
				}
				TABLE.DocumentLines
				{
				    BACKGROUND-COLOR: white
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
									<th align="center">Goods Received Note (<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DocumentStatus"/>)</th>
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
								<tr>
									<th width="50%">GLN</th>
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/GLN"/></td>
								</tr>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code For Location</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code For Location</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
											<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine2">
												<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine3">
												<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine4">
												<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/PostCode">
												<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/PostCode"/>
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
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/GLN"/></td>
								</tr>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code For Location</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code For Location</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
											<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine2">
												<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine3">
												<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine4">
												<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/PostCode">
												<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/PostCode"/>
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
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/GLN"/></td>
								</tr>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code For Location</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code For Location</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToName"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%" valign="top">Address</th>
									<td>
										<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2">
											<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
										</xsl:if>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine3">
											<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
										</xsl:if>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine4">
											<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine4"/>
										</xsl:if>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/PostCode">
											<br/><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/PostCode"/>
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
									<th width="50%">Delivered Delivery Type</th>
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliveryType"/></td>
								</tr>
								<tr>
									<th width="50%">Delivered Delivery Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliveryDate)"/></td>
								</tr>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliverySlot">
									<tr>
										<th width="50%">Delivered Slot Start</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliverySlot/SlotStart"/></td>
									</tr>
									<tr>
										<th width="50%">Delivered Slot End</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliverySlot/SlotEnd"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%">Despatch Date</th>
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DespatchDate"/></td>
								</tr>
								<tr>
									<th width="50%">Received Delivery Type</th>
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryType"/></td>
								</tr>
								<tr>
									<th width="50%">Received Delivery Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryDate)"/></td>
								</tr>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliverySlot">
									<tr>
										<th width="50%">Received Slot Start</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliverySlot/SlotStart"/></td>
									</tr>
									<tr>
										<th width="50%">Received Slot End</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliverySlot/SlotEnd"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/SpecialDeliveryInstructions">
									<tr>
										<th width="50%">Special Delivery Instructions</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/SpecialDeliveryInstructions"/></td>
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
									<th width="50%">Goods Received Note Reference</th>
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/></td>
								</tr>
								<tr>
									<th width="50%">Goods Received Note Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate)"/></td>
								</tr>
								<tr>
									<th width="50%">Delivery Note Reference</th>
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/></td>
								</tr>
								<tr>
									<th width="50%">Delivery Note Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteDate)"/></td>
								</tr>
								<tr>
									<th width="50%">Purchase Order Confirmation Reference</th>
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/></td>
								</tr>
								<tr>
									<th width="50%">Purchase Order Confirmation Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate)"/></td>
								</tr>
								<tr>
									<th width="50%">Purchase Order Reference</th>
									<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
								</tr>
								<tr>
									<th width="50%">Purchase Order Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
								</tr>
								<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
									<tr>
										<th width="50%">Customers Purchase Order Reference</th>
										<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/></td>
									</tr>
								</xsl:if>
							</table>
						</td>
						<td valign="top" width="50%">
							<!--TradeAgreement-->
							<xsl:choose>
								<xsl:when test="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
									<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
										<tr>
											<th colspan="2">Trade Agreement</th>
										</tr>
										<tr>
											<th width="50%">Contract Reference</th>
											<td><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/></td>
										</tr>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
											<tr>
												<th width="50%">Contract Date</th>
												<td><xsl:value-of select="user:gsFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate)"/></td>
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
							<!--Delivery Note Lines-->
							<table class="DocumentLines" cellpadding="1" cellspacing="1">
								<tr>
									<th>Line Number</th>
									<th>GTIN</th>
									<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/ProductID/SuppliersProductCode">
										<th>Suppliers Product Code</th>
									</xsl:if>
									<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/ProductID/BuyersProductCode">
										<th>Buyers Product Code</th>
									</xsl:if>
									<th>Product Description</th>
									<th>Delivered Qty</th>
									<th>UOM</th>
									<th>Accepted Qty</th>
									<th>UOM</th>
									<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/PackSize">
										<th>Pack Size</th>
									</xsl:if>
									<th>Unit Value Excl VAT</th>
									<th>Line Value Excl VAT</th>
									<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountRate">
										<th>Line Discount Rate</th>
									</xsl:if>
									<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue">
										<th>Line Discount Value</th>
									</xsl:if>
									<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/SSCC">
										<th>SSCC</th>
									</xsl:if>
								</tr>
								<xsl:for-each select="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
									<tr>
										<xsl:attribute name="class">
											<xsl:value-of select="@LineStatus"/>
										</xsl:attribute>
										<td><xsl:value-of select="LineNumber"/></td>
										<td><xsl:value-of select="ProductID/GTIN"/></td>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/ProductID/SuppliersProductCode">
											<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
										</xsl:if>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/ProductID/BuyersProductCode">
											<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
										</xsl:if>
										<td><xsl:value-of select="ProductDescription"/></td>
										<td align="right"><xsl:value-of select="DeliveredQuantity"/></td>
										<td><xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/></td>
										<td align="right"><xsl:value-of select="AcceptedQuantity"/></td>
										<td><xsl:value-of select="AcceptedQuantity/@UnitOfMeasure"/></td>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/PackSize">
											<td><xsl:value-of select="PackSize"/>&#xa0;</td>
										</xsl:if>
										<td><xsl:value-of select="UnitValueExclVAT"/></td>
										<td><xsl:value-of select="LineValueExclVAT"/></td>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountRate">
											<td align="right"><xsl:value-of select="LineDiscountRate"/></td>
										</xsl:if>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue">
											<td align="right"><xsl:value-of select="LineDiscountValue"/></td>
										</xsl:if>
										<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/SSCC">
											<td><xsl:value-of select="SSCC"/></td>
										</xsl:if>
									</tr>
									<xsl:if test="Breakages">
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="@LineStatus"/>
											</xsl:attribute>
											<td colspan="15" align="left">
												<table cellpadding="0" cellspacing="0">
													<tr>
														<xsl:attribute name="class">
															<xsl:value-of select="../../@LineStatus"/>
														</xsl:attribute>
														<td align="right" style="width:50">Breakages:</td>
														<td align="center" style="width:50">Line</td>
														<td align="center" style="width:50">Quantity</td>
														<td align="center" style="width:80">Base Unit</td>
														<td align="center" style="width:80">Base Amount</td>
														<td align="center" style="width:100">Sub Unit Desc</td>
													</tr>
													<xsl:for-each select="Breakages/Breakage">
														<tr>
															<xsl:attribute name="class">
																<xsl:value-of select="../../@LineStatus"/>
															</xsl:attribute>
															<td align="center">&#xa0;</td>
															<td align="center"><xsl:value-of select="@BreakageID"/></td>
															<td align="center"><xsl:value-of select="BreakageQuantity"/></td>
															<td align="center"><xsl:value-of select="BaseUnit"/></td>
															<td align="center"><xsl:value-of select="BaseAmount"/></td>
															<td align="center"><xsl:value-of select="SubUnitDescription"/></td>
														</tr>
													</xsl:for-each>
												</table>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="Narrative">
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="@LineStatus"/>
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
						<td><br/></td>
						<td>
							<!--Totals-->
							<table class="DocumentInner" cellpadding="1" cellspacing="1">
								<tr>
									<th colspan="2">Totals</th>
								</tr>
								<tr>
									<th width="50%">Number Of Lines</th>
									<td align="right"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer/NumberOfLines"/></td>
								</tr>
								<tr>
									<th width="50%">Document Discount Rate</th>
									<td align="right"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate"/></td>
								</tr>
								<tr>
									<th width="50%">Discounted Lines Total Excl VAT</th>
									<td align="right"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer/DiscountedLinesTotalExclVAT"/></td>
								</tr>
								<tr>
									<th width="50%">Document Discount</th>
									<td align="right"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscount"/></td>
								</tr>
								<tr>
									<th width="50%">Total Excl VAT</th>
									<td align="right"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT"/></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>	
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>