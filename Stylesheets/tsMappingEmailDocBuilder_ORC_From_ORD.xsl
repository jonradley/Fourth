<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Purchase Order into an HTML page
 for creating an order confirmation.
 
 NOTE:
 This stylesheet relies on the xml having been through the DocBuilderPreMapOut processor.
 This processor adds some required elements to the internal XML:
 /*/DocBuilder/Url
 /*/DocBuilder/MessageID
 
 NOTE2:
 The CSS styles are based on the SSP brand colours so if you want this to work for another
 brand you will need to create a new stylesheet based on this one and update the CSS styles
 as required.
 
 © Alternative Business Solutions Ltd., 2005.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 24/03/2005 | Lee Boyton | Created module.
******************************************************************************************
 22/06/2005 | Lee Boyton | H369. Display new contact name field.
****************************************************************************************** 
 18/01/2006 | A Sheppard | H548. Change Buyer to Buyer/Invoice To
******************************************************************************************
            |            | 
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="html"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	<xsl:template match="/">
		<html>
			<style>
				BODY
				{
				    FONT-SIZE: 8pt;
				    COLOR: #00299c;
				    FONT-FAMILY: Tahoma, Arial;
				    BACKGROUND-COLOR: white;
				    style: "text-decoration: none"
				}
				TR.listrow0
				{
				    BACKGROUND-COLOR: #cbe7ff
				}
				TR.listrow1
				{
				    BACKGROUND-COLOR: #ddf0ff
				}
				TH
				{
				    FONT-WEIGHT: bold;
				    FONT-SIZE: 8pt;
				    PADDING-BOTTOM: 2pt;
				    COLOR: white;
				    PADDING-TOP: 2pt;
				    FONT-FAMILY: Tahoma, Arial;
				    BACKGROUND-COLOR: #629acd
				}
				TD
				{
				    FONT-SIZE: 8pt
				}
				TABLE.DocumentSurround
				{
				    WIDTH: 100%;
				    BACKGROUND-COLOR: #629acd
				}
				TABLE.DocumentSurround TH
				{
				    FONT-SIZE: larger;
				    BACKGROUND-COLOR: #00299c
				}
				TABLE.DocumentInner
				{
				    WIDTH: 100%;
				    BACKGROUND-COLOR: white
				}
				TABLE.DocumentInner TH
				{
				    FONT-SIZE: 8pt
				}
				TABLE.DocumentLines
				{
				    WIDTH: 100%;
				    BACKGROUND-COLOR: white
				}
				TABLE.DocumentLines TH
				{
				    FONT-SIZE: 8pt
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
				<form name="frmMain" method="post" onsubmit="return mbValidateDocument();">
					<xsl:attribute name="action">
						<!-- read POST url added by pre-map out processor -->
						<xsl:value-of select="/PurchaseOrder/DocBuilder/Url"/>
					</xsl:attribute>
					<!-- put the message id of this document in a hidden field, added by pre-map out processor -->
					<input type="hidden" name="txtMessageID">
						<xsl:attribute name="value">
							<xsl:value-of select="/PurchaseOrder/DocBuilder/MessageID"/>
						</xsl:attribute>
					</input>
					<table class="DocumentSurround">
						<!--Header-->
						<tr>
							<td align="center" colspan="2">
								<table width="100%">
									<tr>
										<th align="center">Purchase Order Confirmation Creation</th>
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
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
										<tr>
											<th width="50%">Suppliers Code</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName">
										<tr>
											<th width="50%">Name</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress">
										<tr>
											<th width="50%" valign="top">Address</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1"/>
												<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2">
													<br/>
													<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2"/>
												</xsl:if>
												<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3">
													<br/>
													<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3"/>
												</xsl:if>
												<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4">
													<br/>
													<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4"/>
												</xsl:if>
												<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/PostCode">
													<br/>
													<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/PostCode"/>
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
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode">
										<tr>
											<th width="50%">Suppliers Code</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName">
										<tr>
											<th width="50%">Name</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress">
										<tr>
											<th width="50%" valign="top">Address</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1"/>
												<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2">
													<br/>
													<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2"/>
												</xsl:if>
												<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3">
													<br/>
													<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3"/>
												</xsl:if>
												<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4">
													<br/>
													<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4"/>
												</xsl:if>
												<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode">
													<br/>
													<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode"/>
												</xsl:if>
											</td>
										</tr>
									</xsl:if>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<br/>
							</td>
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
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode">
										<tr>
											<th width="50%">Suppliers Code</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
											</td>
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
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName"/>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2">
												<br/>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3">
												<br/>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4">
												<br/>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode">
												<br/>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
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
										<td>
											<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryType"/>
										</td>
									</tr>
									<tr>
										<th width="50%">Ord Del Date</th>
										<td>
											<xsl:value-of select="user:gsFormatDate(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate)"/>
										</td>
									</tr>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot">
										<tr>
											<th width="50%">Ord Slot Start</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
											</td>
										</tr>
										<tr>
											<th width="50%">Ord Slot End</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<th width="50%">Conf Del Type</th>
										<td>
											<select name="cboORCDelType" style="width:100%">
												<option value="Delivery">Delivery</option>
												<option value="Collect">
													<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryType = 'Collect'">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>
													Collect
												</option>
											</select>
										</td>
									</tr>
									<tr>
										<th width="50%">Conf Delivery Date</th>
										<td>
										<!--  onclick="fPopCalendar(txtORCDelDate, txtORCDelDate);" -->
											<input name="txtORCDelDate" style="width:100%" maxlength="50">
												<xsl:attribute name="value"><xsl:value-of select="user:gsFormatDate(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate)"/></xsl:attribute>
											</input>
										</td>
									</tr>
									<tr>
										<th width="50%">Conf Slot Start</th>
										<td>
											<input name="txtORCSlotStart" style="width:100%" maxlength="50">
												<xsl:attribute name="value"><xsl:value-of select="substring(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart,1,5)"/></xsl:attribute>
											</input>
										</td>
									</tr>
									<tr>
										<th width="50%">Conf Slot End</th>
										<td>
											<input name="txtORCSlotEnd" style="width:100%" maxlength="50">
												<xsl:attribute name="value"><xsl:value-of select="substring(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd,1,5)"/></xsl:attribute>
											</input>
										</td>
									</tr>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">
										<tr>
											<th width="50%">Special Del Instructions</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
											</td>
										</tr>
									</xsl:if>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<br/>
							</td>
						</tr>
						<tr>
							<td valign="top" width="50%">
								<!--PO References-->
								<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
									<tr>
										<th colspan="2">References</th>
									</tr>
									<tr>
										<th width="50%">POConf Ref</th>
										<td>
											<input name="txtORCRef" value="" style="width:100%" maxlength="50"/>
										</td>
									</tr>
									<tr>
										<th width="50%">POConf Date</th>
										<td>
											<!--  onclick="fPopCalendar(txtORCDate, txtORCDate);" -->
											<input name="txtORCDate" style="width:100%" maxlength="50">
												<xsl:attribute name="value"><xsl:value-of select="user:gsGetTodaysDate()"/></xsl:attribute>
											</input>
										</td>
									</tr>
									<tr>
										<th width="50%">PO Ref</th>
										<td>
											<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
										</td>
									</tr>
									<tr>
										<th width="50%">PO Date</th>
										<td>
											<xsl:value-of select="user:gsFormatDate(/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate)"/>
										</td>
									</tr>
									<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
										<tr>
											<th width="50%">Customers PO Ref</th>
											<td>
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
											</td>
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
												<th width="50%">Contract Reference</th>
												<td>
													<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
												</td>
											</tr>
											<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
												<tr>
													<th width="50%">Contract Date</th>
													<td>
														<xsl:value-of select="user:gsFormatDate(/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate)"/>
													</td>
												</tr>
											</xsl:if>
										</table>
									</xsl:when>
									<xsl:otherwise>&#xa0;</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<br/>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<input type="button" value="Accept All Unchanged Lines" onclick="javascript:mAcceptAll();"/>
								<input type="button" value="Reject All Unchanged Lines" onclick="javascript:mRejectAll();"/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<!--Order Lines-->
								<table class="DocumentLines" cellpadding="1" cellspacing="1" id="LinesTable">
									<tr>
										<th rowspan="2"/>
										<th rowspan="2">Suppliers Code</th>
										<th rowspan="2">Buyers Code</th>
										<th rowspan="2">Description</th>
										<th colspan="2">Ordered</th>
										<th colspan="2">Confirmed</th>
										<th rowspan="2">Pack Size</th>
										<th rowspan="2">Price</th>
										<th rowspan="2">Line Value</th>
										<th rowspan="2">Actions</th>
									</tr>
									<tr>
										<th>Qty</th>
										<th>UOM</th>
										<th>Qty</th>
										<th>UOM</th>
									</tr>
									<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
										<xsl:variable name="lRowNumber">
											<xsl:value-of select="user:glGetRowNumber()"/>
										</xsl:variable>
										<tr>
											<xsl:attribute name="id">Row<xsl:value-of select="$lRowNumber"/></xsl:attribute>
											<xsl:attribute name="class"><xsl:value-of select="user:gsGetRowClass()"/></xsl:attribute>
											<input type="hidden">
												<xsl:attribute name="name">txtLineStatus<xsl:value-of select="$lRowNumber"/></xsl:attribute>
											</input>
											<td align="center">
												<input type="hidden">
													<xsl:attribute name="name">txtLineNumber<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value"><xsl:value-of select="$lRowNumber"/></xsl:attribute>
												</input>
												<xsl:value-of select="$lRowNumber"/>
											</td>
											<td>
												<input type="hidden">
													<xsl:attribute name="name">txtGTIN<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value">0000000000000</xsl:attribute>
												</input>
												<input type="hidden">
													<xsl:attribute name="name">txtSuppliersProductCode<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value"><xsl:value-of select="ProductID/SuppliersProductCode"/></xsl:attribute>
												</input>
												<xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;
											</td>
											<td>
												<input type="hidden">
													<xsl:attribute name="name">txtBuyersProductCode<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value"><xsl:value-of select="ProductID/BuyersProductCode"/></xsl:attribute>
												</input>
												<xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;
											</td>
											<td>
												<input type="hidden">
													<xsl:attribute name="name">txtProductDescription<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value"><xsl:value-of select="ProductDescription"/></xsl:attribute>
												</input>
												<xsl:value-of select="ProductDescription"/>
											</td>
											<td align="right">
												<xsl:value-of select="format-number(OrderedQuantity,'0.0000')"/>
											</td>
											<td align="right">
												<input type="hidden">
													<xsl:attribute name="name">txtOrderedQuantity<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value"><xsl:value-of select="OrderedQuantity"/></xsl:attribute>
												</input>
												<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
											</td>
											<td align="right">
												<input type="text" style="width:100%; text-align: right; display: none;">
													<xsl:attribute name="name">txtQuantity<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value"><xsl:value-of select="format-number(OrderedQuantity,'0.0000')"/></xsl:attribute>
													<xsl:attribute name="onchange">javascript:mCalcLineTotal(<xsl:value-of select="$lRowNumber"/>);</xsl:attribute>
												</input>
												<div>
													<xsl:attribute name="id">divQuantity<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:value-of select="format-number(OrderedQuantity,'0.0000')"/>
												</div>
											</td>
											<td align="right">
												<input type="hidden">
													<xsl:attribute name="name">txtUOM<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value"><xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/></xsl:attribute>
												</input>
												<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
											</td>
											<td align="right">
												<input type="hidden">
													<xsl:attribute name="name">txtPackSize<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value"><xsl:value-of select="PackSize"/></xsl:attribute>
												</input>
												<xsl:value-of select="PackSize"/>&#xa0;
											</td>
											<td align="right">
												<input type="text" style="width:100%; text-align: right; display: none;">
													<xsl:attribute name="name">txtUnitValueExclVAT<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value">
														<xsl:choose>
															<xsl:when test="UnitValueExclVAT">
																<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
															</xsl:when>
															<xsl:otherwise>0.00</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:attribute name="onchange">javascript:mCalcLineTotal(<xsl:value-of select="$lRowNumber"/>);</xsl:attribute>
												</input>
												<div>
													<xsl:attribute name="id">divUnitValueExclVAT<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:choose>
														<xsl:when test="UnitValueExclVAT">
															<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
														</xsl:when>
														<xsl:otherwise>0.00</xsl:otherwise>
													</xsl:choose>
												</div>
											</td>
											<td align="right">
												<input type="hidden">
													<xsl:attribute name="name">txtOldLineValueExclVAT<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value">
														<xsl:choose>
															<xsl:when test="LineValueExclVAT">
																<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
															</xsl:when>
															<xsl:otherwise>0.00</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
												</input>
												<input type="hidden">
													<xsl:attribute name="name">txtLineValueExclVAT<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:attribute name="value">
														<xsl:choose>
															<xsl:when test="LineValueExclVAT">
																<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
															</xsl:when>
															<xsl:otherwise>0.00</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
												</input>
												<div>
													<xsl:attribute name="id">divLineValueExclVAT<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<xsl:choose>
														<xsl:when test="LineValueExclVAT">
															<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
														</xsl:when>
														<xsl:otherwise>0.00</xsl:otherwise>
													</xsl:choose>
												</div>
											</td>
											<td align="center">
												<div>
													<xsl:attribute name="id">divActions<xsl:value-of select="$lRowNumber"/></xsl:attribute>
													<input type="button" title="Accept" value="A">
														<xsl:attribute name="onclick">javascript:mAcceptLine(<xsl:value-of select="$lRowNumber"/>)</xsl:attribute>
													</input>
													<input type="button" title="Change" value="C">
														<xsl:attribute name="onclick">javascript:mChangeLine(<xsl:value-of select="$lRowNumber"/>)</xsl:attribute>
													</input>
													<input type="button" title="Reject" value="R">
														<xsl:attribute name="onclick">javascript:mRejectLine(<xsl:value-of select="$lRowNumber"/>)</xsl:attribute>
													</input>
												</div>
											</td>
										</tr>
									</xsl:for-each>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="right">
								<input type="button" value="Add New Line" onclick="javascript:mAddLine();"/>
								<input type="hidden" name="txtNextLineNumber">
									<xsl:attribute name="value"><xsl:value-of select="user:glGetRowNumber()"/></xsl:attribute>
								</input>
							</td>
						</tr>
						<tr>
							<td>
								<br/>
							</td>
							<td>
								<!--Totals-->
								<table class="DocumentInner" cellpadding="1" cellspacing="1">
									<tr>
										<th colspan="2">Totals</th>
									</tr>
									<tr>
										<th width="50%">Number Of Lines</th>
										<td align="right">
											<div id="divNoLines">
												<xsl:value-of select="/PurchaseOrder/PurchaseOrderTrailer/NumberOfLines"/>
											</div>
										</td>
									</tr>
									<xsl:if test="/PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT">
										<tr>
											<th width="50%">Total Excl VAT</th>
											<td align="right">
												<input type="hidden" name="txtTotalExclVAT">
													<xsl:attribute name="value">
														<xsl:choose>
															<xsl:when test="/PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT">
																<xsl:value-of select="format-number(/PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT, '0.00')"/>
															</xsl:when>
															<xsl:otherwise>0.00</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
												</input>
												<div id="divTotalExclVAT">
													<xsl:choose>
														<xsl:when test="/PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT">
															<xsl:value-of select="format-number(/PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT, '0.00')"/>
														</xsl:when>
														<xsl:otherwise>0.00</xsl:otherwise>
													</xsl:choose>
												</div>
											</td>
										</tr>
									</xsl:if>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<br/>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								Username <input type="text" name="txtUsername"/>
								Password <input type="password" name="txtPassword"/>
							</td>
						</tr>
					</table>					
					<center>
						<input type="submit" value="Send Document"/>
						<input type="reset" value="Reset" onclick="javascript:mResetTable();"/>
					</center>
				</form>
			</body>
		</html>
		<script language="javascript"><![CDATA[ 
			function keyDown(e) 
			{
				// Disable the backspace keypress unless the event came from an input box
				// keyCode==8 means backspace has been pressed
				if(window.event.keyCode==8) 
				{
					if(window.event.srcElement.tagName != 'INPUT') 
					{
						if(window.event.srcElement.tagName != 'Input') 
						{
							return false; 
						}
					}
				}	
				
				//Always disable the return press		
				if(window.event.keyCode==13) 
				{
					return false;
				}
			}
			document.onkeydown=keyDown;
			
			function mbValidateDocument()
			{
				var sValidationError = '';
				
				if(document.all.txtORCDelDate.value == '')
				{
					sValidationError = sValidationError + '\nConfirmed Delivery Date must be completed.'
				}
				else
				{
					if(!isDate(document.all.txtORCDelDate.value))
					{
						sValidationError = sValidationError + '\nConfirmed Delivery Date must be a valid date.'
					}
				}
				
				if(document.all.txtORCRef.value == '')
				{
					sValidationError = sValidationError + '\nPurchase Order Confirmation Reference must be completed.'
				}
				
				if(document.all.txtORCDate.value == '')
				{
					sValidationError = sValidationError + '\nPurchase Order Confirmation Date must be completed.'
				}
				else
				{
					if(!isDate(document.all.txtORCDate.value))
					{
						sValidationError = sValidationError + '\nPurchase Order Confirmation Date must be a valid date.'
					}
				}
				
				if(document.all.txtORCSlotStart.value != '' || document.all.txtORCSlotEnd.value != '')
				{
					if(document.all.txtORCSlotStart.value == '' || document.all.txtORCSlotEnd.value == '')
					{
						sValidationError = sValidationError + '\nIf one of Slot Start or Slot End is supplied, both must be supplied';
					}
					else
					{
						var sSlotStart = document.all.txtORCSlotStart.value;
						if(!(isNumeric(sSlotStart.substr(0,2))) || !(sSlotStart.substr(2,1) == ':') || !(isNumeric(sSlotStart.substr(3,2))) || !(sSlotStart.length == 5))
						{
							sValidationError = sValidationError + '\nSlot Start must be in the format hh:nn.'
						}
						var sSlotEnd = document.all.txtORCSlotEnd.value;
						if(!(isNumeric(sSlotEnd.substr(0,2))) || !(sSlotEnd.substr(2,1) == ':') || !(isNumeric(sSlotEnd.substr(3,2))) || !(sSlotEnd.length == 5))
						{
							sValidationError = sValidationError + '\nSlot End must be in the format hh:nn.'
						}
					}
				}
				
				// must specify a username and password to login to the Portal
				if(document.all.txtUsername.value == '' || document.all.txtPassword.value == '')
				{
					sValidationError = sValidationError + '\nA username and password must be entered.';
				}
				
				var bFinishedLoop = false;
			
				for(var n1=1; !bFinishedLoop; n1++)
				{
					try
					{
						switch(document.all.item('txtLineStatus' + n1).value)
						{
						 	case 'Accepted':
						 		//Nothing to do here
						 		break;
						 	
						 	case 'Changed':
						 		//Validate price and quantity
						 		if(!isNumeric(document.all.item('txtQuantity' + n1).value))
						 		{
						 			sValidationError = sValidationError + '\nQuantity on line ' + n1 + ' must be completed and must be numeric';
						 		}
						 		else
						 		{
						 			if(parseFloat(document.all.item('txtQuantity' + n1).value) < 0)
						 			{
						 				sValidationError = sValidationError + '\nQuantity on line ' + n1 + ' must be greater than zero';
						 			}
						 		}
						 		if(!isNumeric(document.all.item('txtUnitValueExclVAT' + n1).value))
						 		{
						 			sValidationError = sValidationError + '\nUnitValue on line ' + n1 + ' must be completed and must be numeric';
						 		}
						 		else
						 		{
						 			if(parseFloat(document.all.item('txtUnitValueExclVAT' + n1).value) < 0)
						 			{
						 				sValidationError = sValidationError + '\nUnitValue on line ' + n1 + ' must be greater than zero';
						 			}
						 		}
						 		break;
						 		
						 	case 'Rejected':
						 		//Nothing to do here
						 		break;
						 		
						 	case 'Added':
						 		//Validate everything
						 		if(document.all.item('txtGTIN' + n1).value == '')
						 		{
						 			sValidationError = sValidationError + '\nGTIN on line ' + n1 + ' must be completed';
						 		}
						 		if(document.all.item('txtSuppliersProductCode' + n1).value == '')
						 		{
						 			sValidationError = sValidationError + '\nSuppliers Product Code on line ' + n1 + ' must be completed';
						 		}
						 		if(document.all.item('txtProductDescription' + n1).value == '')
						 		{
						 			sValidationError = sValidationError + '\nProduct Description on line ' + n1 + ' must be completed';
						 		}
						 		if(!isNumeric(document.all.item('txtQuantity' + n1).value))
						 		{
						 			sValidationError = sValidationError + '\nQuantity on line ' + n1 + ' must be completed and must be numeric';
						 		}
						 		else
						 		{
						 			if(parseFloat(document.all.item('txtQuantity' + n1).value) < 0)
						 			{
						 				sValidationError = sValidationError + '\nQuantity on line ' + n1 + ' must be greater than zero';
						 			}
						 		}
						 		if(!isNumeric(document.all.item('txtUnitValueExclVAT' + n1).value))
						 		{
						 			sValidationError = sValidationError + '\nUnitValue on line ' + n1 + ' must be completed and must be numeric';
						 		}
						 		else
						 		{
						 			if(parseFloat(document.all.item('txtUnitValueExclVAT' + n1).value) < 0)
						 			{
						 				sValidationError = sValidationError + '\nUnitValue on line ' + n1 + ' must be greater than zero';
						 			}
						 		}
						 		break;
						}
					}
					catch(exception)
					{
						bFinishedLoop = true;
					}
				}
				
				if(sValidationError == '')
				{
					if(confirm('Are you sure you wish to create and send the purchase order confirmation?'))
					{
						mAcceptAll();
						return true;
					}
					else
					{
						return false;
					}
				}	
				else
				{
					alert('Validation Errors:' + sValidationError);
					return false;
				}
			}		

			function mResetTable()
			{
				window.location.reload();
			}
			
			function mAddLine()
			{
			var lLineNumber;
			var objNewRow;
			var objNewCell;
			
				lLineNumber = document.all.item('txtNextLineNumber').value;
			
				objNewRow = document.all.item('LinesTable').insertRow();
				objNewRow.className = 'Added';
				
				objNewCell = objNewRow.insertCell();
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="hidden" name="txtLineStatus' + lLineNumber + '" value="Added">');
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="hidden" name="txtLineNumber' + lLineNumber + '" value="' + lLineNumber + '">');
				objNewCell.insertAdjacentText('beforeEnd', lLineNumber);       

				objNewCell = objNewRow.insertCell();   
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="hidden" name="txtGTIN' + lLineNumber + '" value="55555555555555">');
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtSuppliersProductCode' + lLineNumber + '" style="width:100%">');
				
				objNewCell = objNewRow.insertCell();   
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtBuyersProductCode' + lLineNumber + '" style="width:100%">');
				
				objNewCell = objNewRow.insertCell();   
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtProductDescription' + lLineNumber + '" style="width:100%">');
				
				objNewCell = objNewRow.insertCell();
				objNewCell.align = 'right';
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="hidden" name="txtOrderedQuantity' + lLineNumber + '" value="0.0000">');
				objNewCell.insertAdjacentText('beforeEnd', '0.0000');  
				
				objNewCell = objNewRow.insertCell();
				objNewCell.align = 'right';
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="hidden" name="txtOrderedUOM' + lLineNumber + '" value="EA">');
				objNewCell.insertAdjacentHTML('beforeEnd', '<div id="divOrderedUOM' + lLineNumber + '">EA</div>');

				objNewCell = objNewRow.insertCell();
				objNewCell.align = 'right';
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtQuantity' + lLineNumber + '" style="width:100%; text-align: right" value="0.0000" onchange="javascript:mCalcLineTotal(' + lLineNumber + ');">');

				objNewCell = objNewRow.insertCell();
				objNewCell.width = '60';
				objNewCell.insertAdjacentHTML('beforeEnd', 	'<select name="txtUOM' + lLineNumber + '" style="width=60" onchange="javascript:mUpdateUOMs(' + lLineNumber + ');">' + 
																'<option value="CS">CS</option>' +
																'<option value="GRM">GRM</option>' +
																'<option value="KGM">KGM</option>' +
																'<option value="PND">PND</option>' +
																'<option value="ONZ">ONZ</option>' +
																'<option value="GLI">GLI</option>' +
																'<option value="LTR">LTR</option>' +
																'<option value="OZI">OZI</option>' +
																'<option value="PTI">PTI</option>' +
																'<option value="PTN">PTN</option>' +
																'<option value="001">001</option>' +
																'<option value="DZN">DZN</option>' +
																'<option value="EA" selected="selected">EA</option>' +
																'<option value="PF">PF</option>' +
																'<option value="PR">PR</option>' +
																'<option value="HUR">HUR</option>' +
															'</select>');
				
				objNewCell = objNewRow.insertCell();
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtPackSize' + lLineNumber + '" style="width:100%; text-align: right">');
				
				objNewCell = objNewRow.insertCell();
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtUnitValueExclVAT' + lLineNumber + '" style="width:100%; text-align: right" onchange="javascript:mCalcLineTotal(' + lLineNumber + ');" value="0.00">');
				
				objNewCell = objNewRow.insertCell();
				objNewCell.align = 'right';
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="hidden" name="txtOldLineValueExclVAT' + lLineNumber + '" value="0.00">');
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="hidden" name="txtLineValueExclVAT' + lLineNumber + '" value="0.00">');
				objNewCell.insertAdjacentHTML('beforeEnd', '<div id="divLineValueExclVAT' + lLineNumber + '">0.00</div>');
				
				objNewCell = objNewRow.insertCell();
				objNewCell.insertAdjacentHTML('beforeEnd', '&nbsp;');
				
				objNewRow = document.all.item('LinesTable').insertRow();
				objNewRow.className = 'Added';
				
				objNewCell = objNewRow.insertCell();
				objNewCell.align = 'right';
				objNewCell.colSpan = '2';
				objNewCell.insertAdjacentText('beforeEnd', 'Reason For Addition:');  
				
				objNewCell = objNewRow.insertCell();
				objNewCell.colSpan = '7';
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtNarrative' + lLineNumber + '" style="width:100%"/>');
				
				objNewCell = objNewRow.insertCell();
				objNewCell.align = 'right';
				objNewCell.insertAdjacentText('beforeEnd', 'Code:');  
				
				objNewCell = objNewRow.insertCell();
				objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtNarrativeCode' + lLineNumber + '" style="width:100%"/>');
				
				objNewCell = objNewRow.insertCell();
				objNewCell.insertAdjacentHTML('beforeEnd', '&nbsp;');
				
				document.all.item('txtNextLineNumber').value = parseInt(document.all.item('txtNextLineNumber').value) + 1;
				document.all.divNoLines.innerHTML = parseInt(document.all.divNoLines.innerHTML) + 1;
			}

			function mAcceptLine(vlLineNumber)
			{
				document.all.item('Row' + vlLineNumber).className = 'Accepted';
				document.all.item('txtLineStatus' + vlLineNumber).value = 'Accepted';
				document.all.item('divActions' + vlLineNumber).outerHTML = '';
			}
			
			function mAcceptAll(vsMode)
			{
			var lLineNumber;
				for(var n1=document.all.item('LinesTable').rows.length - 1; n1 >= 1; n1--)
				{
					if(document.all.item('LinesTable').rows(n1).id.substr(0,3) == 'Row')
					{
						lLineNumber = document.all.item('LinesTable').rows(n1).id.substr(3,document.all.item('LinesTable').rows(n1).id.length)
						
						if(document.all.item('txtLineStatus' + lLineNumber).value == '')
						{
							mAcceptLine(lLineNumber);
						}
					}
				}
			}
			
			function mRejectLine(vlLineNumber)
			{
			var objNewRow;
			var objNewCell;

				document.all.item('Row' + vlLineNumber).className = 'Rejected';
				document.all.item('txtLineStatus' + vlLineNumber).value = 'Rejected';
				document.all.item('divActions' + vlLineNumber).outerHTML = '';
				document.all.item('txtQuantity' + vlLineNumber).value = '0.0000';
				document.all.item('divQuantity' + vlLineNumber).innerText = '0.0000';
			
				for(var n1=1; n1<=document.all.item('LinesTable').rows.length; n1++)
		            	{
					if(document.all.item('LinesTable').rows(n1).id == 'Row' + vlLineNumber)
					{
						objNewRow = document.all.item('LinesTable').insertRow(n1+1);
						objNewRow.className = 'Rejected';
						
						objNewCell = objNewRow.insertCell();
						objNewCell.align = 'right';
						objNewCell.colSpan = '2';
						objNewCell.insertAdjacentText('beforeEnd', 'Reason For Rejection:');  
						
						objNewCell = objNewRow.insertCell();
						objNewCell.colSpan = '7';
						objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtNarrative' + vlLineNumber + '" style="width:100%"/>');
						
						objNewCell = objNewRow.insertCell();
						objNewCell.align = 'right';
						objNewCell.insertAdjacentText('beforeEnd', 'Code:');  
						
						objNewCell = objNewRow.insertCell();
						objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtNarrativeCode' + vlLineNumber + '" style="width:100%"/>');
						
						objNewCell = objNewRow.insertCell();
						objNewCell.insertAdjacentHTML('beforeEnd', '&nbsp;');

						break;
		                }
		            } 

		            mCalcLineTotal(vlLineNumber);
			}
			
			function mRejectAll(vsMode)
			{
			var lLineNumber;
			var objNewRow;
			var objNewCell;
			
				for(var n1=document.all.item('LinesTable').rows.length - 1; n1 >= 1; n1--)
				{
					if(document.all.item('LinesTable').rows(n1).id.substr(0,3) == 'Row')
					{
						lLineNumber = document.all.item('LinesTable').rows(n1).id.substr(3,document.all.item('LinesTable').rows(n1).id.length)
						
						if(document.all.item('txtLineStatus' + lLineNumber).value == '')
						{
							document.all.item('Row' + lLineNumber).className = 'Rejected';
							document.all.item('txtLineStatus' + lLineNumber).value = 'Rejected';
							document.all.item('divActions' + lLineNumber).outerHTML = '';
							document.all.item('txtQuantity' + lLineNumber).value = '0.0000';
							document.all.item('divQuantity' + lLineNumber).innerText = '0.0000';
							
							objNewRow = document.all.item('LinesTable').insertRow(n1+1);
							objNewRow.className = 'Rejected';
							
							objNewCell = objNewRow.insertCell();
							objNewCell.align = 'right';
							objNewCell.colSpan = '2';
							objNewCell.insertAdjacentText('beforeEnd', 'Reason For Rejection:');  
							
							objNewCell = objNewRow.insertCell();
							objNewCell.colSpan = '7';
							objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtNarrative' + lLineNumber + '" style="width:100%"/>');
							
							objNewCell = objNewRow.insertCell();
							objNewCell.align = 'right';
							objNewCell.insertAdjacentText('beforeEnd', 'Code:');  
							
							objNewCell = objNewRow.insertCell();
							objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtNarrativeCode' + lLineNumber + '" style="width:100%"/>');
							
							objNewCell = objNewRow.insertCell();
							objNewCell.insertAdjacentHTML('beforeEnd', '&nbsp;');
	
							mCalcLineTotal(lLineNumber);
						}
					}
				}
			}
			
			function mChangeLine(vlLineNumber)
			{
			var objNewRow;
			var objNewCell;
			
				document.all.item('Row' + vlLineNumber).className = 'Changed';
				document.all.item('txtLineStatus' + vlLineNumber).value = 'Changed';
				document.all.item('divActions' + vlLineNumber).outerHTML = '';
				document.all.item('txtQuantity' + vlLineNumber).style.display = '';
				document.all.item('divQuantity' + vlLineNumber).outerHTML = '';
				document.all.item('txtUnitValueExclVAT' + vlLineNumber).style.display = '';
				document.all.item('divUnitValueExclVAT' + vlLineNumber).outerHTML = '';
			
				for(var n1=1; n1<=document.all.item('LinesTable').rows.length; n1++)
		            	{
					if(document.all.item('LinesTable').rows(n1).id == 'Row' + vlLineNumber)
					{
						objNewRow = document.all.item('LinesTable').insertRow(n1+1);
						objNewRow.className = 'Changed';
						
						objNewCell = objNewRow.insertCell();
						objNewCell.align = 'right';
						objNewCell.colSpan = '2';
						objNewCell.insertAdjacentText('beforeEnd', 'Reason For Change:');  
						
						objNewCell = objNewRow.insertCell();
						objNewCell.colSpan = '7';
						objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtNarrative' + vlLineNumber + '" style="width:100%"/>');
						
						objNewCell = objNewRow.insertCell();
						objNewCell.align = 'right';
						objNewCell.insertAdjacentText('beforeEnd', 'Code:');  
						
						objNewCell = objNewRow.insertCell();
						objNewCell.insertAdjacentHTML('beforeEnd', '<input type="text" name="txtNarrativeCode' + vlLineNumber + '" style="width:100%"/>');
						
						objNewCell = objNewRow.insertCell();
						objNewCell.insertAdjacentHTML('beforeEnd', '&nbsp;');

						break;
		                }
		            } 
			}
			
			function mUpdateUOMs(vlLineNumber)
			{	
				document.all.item('txtOrderedUOM' + vlLineNumber).value = document.all.item('txtUOM' + vlLineNumber).value;
				document.all.item('divOrderedUOM' + vlLineNumber).innerText = document.all.item('txtUOM' + vlLineNumber).value;
			}

			function mCalcLineTotal(vlLineNumber)
			{
			var sQuantity = document.all.item('txtQuantity' + vlLineNumber).value;
			var sUnitValue = document.all.item('txtUnitValueExclVAT' + vlLineNumber).value;
			var sResult = '';

				if(isNumeric(sQuantity) && isNumeric(sUnitValue))
				{
					sResult = msFormat2DP(Math.round(parseFloat(sQuantity) * parseFloat(sUnitValue) * 100) / 100);
				}
				else
				{
					sResult = '0.00';
				}
				
				document.all.item('txtLineValueExclVAT' + vlLineNumber).value = sResult;
				document.all.item('divLineValueExclVAT' + vlLineNumber).innerText = sResult;
				mCalcTotals(vlLineNumber);
			}
			
			function mCalcTotals(vlLineNumber)
			{
			var dChangeToTotal;
					
				dChangeToTotal = parseFloat(document.all.item('txtLineValueExclVAT' + vlLineNumber).value) - parseFloat(document.all.item('txtOldLineValueExclVAT' + vlLineNumber).value);
				
				document.all.item('txtOldLineValueExclVAT' + vlLineNumber).value = document.all.item('txtLineValueExclVAT' + vlLineNumber).value
				
				document.all.item('txtTotalExclVAT').value = msFormat2DP(Math.round((parseFloat(document.all.item('txtTotalExclVAT').value) + dChangeToTotal) * 100) / 100);
				document.all.item('divTotalExclVAT').innerText = document.all.item('txtTotalExclVAT').value;
			}

			function msFormat2DP(vsNumber)
			{
			var sNumber = '' + vsNumber;
			
				if(sNumber.indexOf('.') == -1)
				{
					sNumber = sNumber + '.';
				}
				
				while((sNumber.length - sNumber.indexOf('.') ) < 3)
				{
					sNumber += '0';
				}
				
				return sNumber;
			}
			function isNumeric(sString)
			{
				var sValidChars = "0123456789.-";
				var sChar;
				var bResult = true;
			
				if (sString.length == 0) return false;
				
				//test sString consists of valid characters listed above
				for (i = 0; i < sString.length && bResult == true; i++)
				{
				sChar = sString.charAt(i);
					if (sValidChars.indexOf(sChar) == -1)
					{
						bResult = false;
					}
				}
				return bResult;
			}

			function isDate(DateToCheck)
			{
				if(DateToCheck=='')
				{
					return true;
				}
				
				var m_strDate = FormatDate(DateToCheck);
				
				if(m_strDate=='')
				{
					return false;
				}
				
				var m_arrDate = m_strDate.split('/');
				var m_DAY = m_arrDate[0];
				var m_MONTH = m_arrDate[1];
				var m_YEAR = m_arrDate[2];
				
				if(m_YEAR.length > 4)
				{
					return false;
				}
			
				m_strDate = m_MONTH + '/' + m_DAY + '/' + m_YEAR;
				var testDate=new Date(m_strDate);
				if(testDate.getMonth()+1==m_MONTH)
				{
					return true;
				} 
				else
				{
					return false;
				}
			}
	
			function FormatDate(DateToFormat,FormatAs)
			{
				if(DateToFormat=='')
				{
					return '';
				}
				
				if(!FormatAs)
				{
					FormatAs='dd/mm/yyyy';
				}
			
				var strReturnDate;
				
				FormatAs = FormatAs.toLowerCase();
				DateToFormat = DateToFormat.toLowerCase();
				
				var arrDate
				var arrMonths = new Array('January','February','March','April','May','June','July','August','September','October','November','December');
				var strMONTH;
				var Separator;
			
				while(DateToFormat.indexOf('st')>-1)
				{
					DateToFormat = DateToFormat.replace('st','');
				}
			
				while(DateToFormat.indexOf('nd')>-1)
				{
					DateToFormat = DateToFormat.replace('nd','');
				}
			
				while(DateToFormat.indexOf('rd')>-1)
				{
					DateToFormat = DateToFormat.replace('rd','');
				}
			
				while(DateToFormat.indexOf('th')>-1)
				{
					DateToFormat = DateToFormat.replace('th','');
				}
			
				if(DateToFormat.indexOf('.')>-1)
				{
					Separator = '.';
				}
			
				if(DateToFormat.indexOf('-')>-1)
				{
					Separator = '-';
				}
			
				if(DateToFormat.indexOf('/')>-1)
				{
					Separator = '/';
				}
			
				if(DateToFormat.indexOf(' ')>-1)
				{
					Separator = ' ';
				}
			
				arrDate = DateToFormat.split(Separator);
				DateToFormat = '';
				
				for(var iSD = 0;iSD < arrDate.length;iSD++)
				{
					if(arrDate[iSD]!='')
					{
						DateToFormat += arrDate[iSD] + Separator;
					}
				}
			
				DateToFormat = DateToFormat.substring(0,DateToFormat.length-1);
				arrDate = DateToFormat.split(Separator);
			
				if(arrDate.length < 3)
				{
					return '';
				}
			
				var DAY = arrDate[0];
				var MONTH = arrDate[1];
				var YEAR = arrDate[2];
			
				if(parseFloat(arrDate[1]) > 12)
				{
					DAY = arrDate[1];
					MONTH = arrDate[0];
				}
			
				if(parseFloat(DAY) && DAY.toString().length==4)
				{
					YEAR = arrDate[0];
					DAY = arrDate[2];
					MONTH = arrDate[1];
				}
			
				for(var iSD = 0;iSD < arrMonths.length;iSD++)
				{
					var ShortMonth = arrMonths[iSD].substring(0,3).toLowerCase();
					var MonthPosition = DateToFormat.indexOf(ShortMonth);
			
					if(MonthPosition > -1)
					{
						MONTH = iSD + 1;
			
						if(MonthPosition == 0)
						{
							DAY = arrDate[1];
							YEAR = arrDate[2];
						}
						
						break;
					}
				}
			
				var strTemp = YEAR.toString();
				
				if(strTemp.length==2)
				{
			
					if(parseFloat(YEAR)>40)
					{
						YEAR = '19' + YEAR;
					}
					else
					{
						YEAR = '20' + YEAR;
					}
				}
			
			
				if(parseInt(MONTH)< 10 && MONTH.toString().length < 2)
				{
					MONTH = '0' + MONTH;
				}
			
				if(parseInt(DAY)< 10 && DAY.toString().length < 2)
				{
					DAY = '0' + DAY;
				}
				
				switch (FormatAs)
				{
					case 'dd/mm/yyyy':
						return DAY + '/' + MONTH + '/' + YEAR;
					case 'mm/dd/yyyy':
						return MONTH + '/' + DAY + '/' + YEAR;
					case 'dd/mmm/yyyy':
						return DAY + ' ' + arrMonths[MONTH -1].substring(0,3) + ' ' + YEAR;
					case 'mmm/dd/yyyy':
						return arrMonths[MONTH -1].substring(0,3) + ' ' + DAY + ' ' + YEAR;
					case 'dd/mmmm/yyyy':
						return DAY + ' ' + arrMonths[MONTH -1] + ' ' + YEAR;	
					case 'mmmm/dd/yyyy':
						return arrMonths[MONTH -1] + ' ' + DAY + ' ' + YEAR;
					}
			
				return DAY + '/' + strMONTH + '/' + YEAR;;
			}	
		]]></script>
	</xsl:template>
</xsl:stylesheet>
