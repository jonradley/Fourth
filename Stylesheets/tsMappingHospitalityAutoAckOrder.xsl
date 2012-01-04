<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for Acknowledgement notification into an HTML page

 © Alternative Business Solutions Ltd., 2009.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 03/12/2009 | Rave Tech   | Created module.
****************************************************************************************** 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="html"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	<xsl:param name="MessageID" select="'0'"/>
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
				<form name="frmMain" action="http://staging7.abs-ltd.com/Messaging/AutoAcknowledgement.asp"  method="post" onsubmit="return mbValidateDocument();">
					<input type="hidden">
						<xsl:attribute name="name">txtMessageID</xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$MessageID"/></xsl:attribute>
					</input>					
					<table class="DocumentSurround">
						<!--Header-->
						<tr>
							<td align="center" colspan="2">
								<table width="100%">
									<tr>
										<th align="center">Purchase Order Acknowledgement Request</th>
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
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode">
										<tr>
											<th width="50%">Buyers Code</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
										<tr>
											<th width="50%">Suppliers Code</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName">
										<tr>
											<th width="50%">Name</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress">
										<tr>
											<th width="50%" valign="top">Address</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1"/>
												<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2">
													<br/>
													<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2"/>
												</xsl:if>
												<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3">
													<br/>
													<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3"/>
												</xsl:if>
												<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4">
													<br/>
													<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4"/>
												</xsl:if>
												<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/PostCode">
													<br/>
													<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/PostCode"/>
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
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode">
										<tr>
											<th width="50%">Buyers Code</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode">
										<tr>
											<th width="50%">Suppliers Code</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName">
										<tr>
											<th width="50%">Name</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress">
										<tr>
											<th width="50%" valign="top">Address</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1"/>
												<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2">
													<br/>
													<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2"/>
												</xsl:if>
												<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3">
													<br/>
													<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3"/>
												</xsl:if>
												<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4">
													<br/>
													<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4"/>
												</xsl:if>
												<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode">
													<br/>
													<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode"/>
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
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode">
										<tr>
											<th width="50%">Buyers Code</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode">
										<tr>
											<th width="50%">Suppliers Code</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ContactName">
										<tr>
											<th width="50%">Contact Name</th>
											<td><xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ContactName"/></td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName">
										<tr>
											<th width="50%">Name</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName"/>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
											<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2">
												<br/>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3">
												<br/>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4">
												<br/>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode">
												<br/>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
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
										<th width="50%">Del Type</th>
										<td>
											<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryType"/>
										</td>
									</tr>
									<tr>
										<th width="50%">Del Date</th>
										<td>
											<xsl:value-of select="user:gsFormatDate(//PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate)"/>
										</td>
									</tr>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot">
										<tr>
											<th width="50%">Slot Start</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
											</td>
										</tr>
										<tr>
											<th width="50%">Slot End</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/>
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">
										<tr>
											<th width="50%">Special Del Instructions</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
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
										<th width="50%">PO Ref</th>
										<td>
											<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
										</td>
									</tr>
									<tr>
										<th width="50%">PO Date</th>
										<td>
											<xsl:value-of select="user:gsFormatDate(//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate)"/>
										</td>
									</tr>
									<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
										<tr>
											<th width="50%">Customers PO Ref</th>
											<td>
												<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
											</td>
										</tr>
									</xsl:if>									
								</table>
							</td>
							<td valign="top" width="50%">
								<!--TradeAgreement-->
								<xsl:choose>
									<xsl:when test="//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
										<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
											<tr>
												<th colspan="2">Trade Agreement</th>
											</tr>
											<tr>
												<th width="50%">Contract Reference</th>
												<td>
													<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
												</td>
											</tr>
											<xsl:if test="//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
												<tr>
													<th width="50%">Contract Date</th>
													<td>
														<xsl:value-of select="user:gsFormatDate(//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate)"/>
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
							<td colspan="2">
								<!--Order Lines-->
								<table class="DocumentLines" cellpadding="1" cellspacing="1" id="LinesTable">
									<tr>
										<th/>
										<th>Suppliers Code</th>
										<th>Buyers Code</th>
										<th>Description</th>
										<th>Qty</th>
										<th>UOM</th>
										<th>Pack Size</th>
										<th>Price</th>
										<th>Line Value</th>
									</tr>
									<xsl:for-each select="//PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
										<xsl:variable name="lRowNumber">
											<xsl:value-of select="user:glGetRowNumber()"/>
										</xsl:variable>
										<tr>
											<xsl:attribute name="id">Row<xsl:value-of select="$lRowNumber"/></xsl:attribute>
											<xsl:attribute name="class"><xsl:value-of select="user:gsGetRowClass()"/></xsl:attribute>
											<td align="center">
												<xsl:value-of select="$lRowNumber"/>
											</td>
											<td>
												<xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;
											</td>
											<td>
												<xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;
											</td>
											<td>
												<xsl:value-of select="ProductDescription"/>
											</td>
											<td align="right">
												<xsl:value-of select="format-number(OrderedQuantity,'0.0000')"/>
											</td>
											<td align="right">
												<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
											</td>
											<td align="right">
												<xsl:value-of select="PackSize"/>&#xa0;
											</td>
											<td align="right">
												<xsl:choose>
													<xsl:when test="UnitValueExclVAT">
														<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
													</xsl:when>
													<xsl:otherwise>0.00</xsl:otherwise>
												</xsl:choose>
											</td>
											<td align="right">
												<xsl:choose>
													<xsl:when test="LineValueExclVAT">
														<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
													</xsl:when>
													<xsl:otherwise>0.00</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
									</xsl:for-each>
								</table>
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
											<xsl:value-of select="//PurchaseOrder/PurchaseOrderTrailer/NumberOfLines"/>
										</td>
									</tr>
									<xsl:if test="//PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT">
										<tr>
											<th width="50%">Total Excl VAT</th>
											<td align="right">
												<xsl:choose>
													<xsl:when test="//PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT">
														<xsl:value-of select="format-number(//PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT, '0.00')"/>
													</xsl:when>
													<xsl:otherwise>0.00</xsl:otherwise>
												</xsl:choose>
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
								<xsl:choose>
									<xsl:when test="//AuthorisationType = 'Budget'">
										<xsl:text>Current spend with </xsl:text><xsl:value-of select="//SuppliersName"/><xsl:text> for this period (</xsl:text><xsl:value-of select="substring(//Period,5)"/><xsl:text>/</xsl:text><xsl:value-of select="substring(//Period,1,4)"/><xsl:text>) including this order is £</xsl:text><xsl:value-of select="format-number(//SpendValue, '#,##0.00')"/><xsl:text>*.</xsl:text>
										<br/><br/>
										<xsl:text>This is £</xsl:text><xsl:value-of select="format-number(//Overspend, '#,##0.00')"/><xsl:text> more than their budget of £</xsl:text><xsl:value-of select="format-number(//BudgetValue, '#,##0.00')"/><xsl:text>.</xsl:text>
										<br/><br/>
										<xsl:text>*Note that this information was correct at the time of sending (</xsl:text><xsl:value-of select="//BudgetCalculationTime"/><xsl:text>).</xsl:text>
									</xsl:when>
									<xsl:when test="//AuthorisationType = 'NonStandardDelivery'">
										<xsl:text>This order was placed with an off-day delivery date</xsl:text>
									</xsl:when>
								</xsl:choose>
								
								<br/><br/>
								<xsl:if test="//AuthorisationComments">
									<xsl:text>Authorisation comment: </xsl:text>
									<xsl:value-of select="//AuthorisationComments"/>
									<br/><br/>
								</xsl:if>							
								<xsl:text>To acknowledge this order:</xsl:text>
								<br/>
								<xsl:text>1. Please enter your username and password.</xsl:text>
								<br/>
								<xsl:text>2. Click on the Acknowledge button.</xsl:text>								
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								Username <input type="text" name="txtUsername"/>
								Password <input type="password" name="txtPassword"/>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">								
								<input type="submit" name="btnAction" value="Acknowledge"/>				
							</td>
						</tr>
					</table>					
				</form>
			</body>
		</html>
		<script language="javascript"><![CDATA[ 			
			function trim(s) 
			{ 
			    return s.replace(/^\s+/,"").replace(/\s+$/,""); 
			} 
			
			function mbValidateDocument()
			{
				var sValidationError = '';
							
				// must specify a username and password
				if(trim(document.all.txtUsername.value) == '' || trim(document.all.txtPassword.value) == '')
				{
					sValidationError = sValidationError + '\nA username and password must be entered.';
				}
								
				if(sValidationError == '')
				{				
					return true;				
				}	
				else
				{
					alert('Validation Error:' + sValidationError);
					return false;
				}
			}		


		]]></script>

	</xsl:template>
</xsl:stylesheet>
