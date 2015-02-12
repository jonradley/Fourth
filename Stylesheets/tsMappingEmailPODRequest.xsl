<!--
'******************************************************************************************

******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Proof Of Delivery Requestinto an HTML page

 © Fourth Hospitality 2012
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 26/01/2012 | S Sehgal | 5171 Created module.
******************************************************************************************

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
				    COLOR: #666666;
				    FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;
				    BACKGROUND-COLOR: #ffffff;
				    style: "text-decoration: none"
				}
				TR.listrow0
				{
				    BACKGROUND-COLOR: #666666
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
				    BACKGROUND-COLOR: #999999				
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
				    BACKGROUND-COLOR: #e0e0e0;
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
									<th align="center">Proof Of Delivery Request (<xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/DocumentStatus"/>)</th>
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
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress/AddressLine1"/>
											<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress/AddressLine2">
												<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress/AddressLine3">
												<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress/AddressLine4">
												<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress/PostCode">
												<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Buyer/BuyersAddress/PostCode"/>
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
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress/AddressLine1"/>
											<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress/AddressLine2">
												<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress/AddressLine3">
												<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress/AddressLine4">
												<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress/PostCode">
												<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/Supplier/SuppliersAddress/PostCode"/>
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
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ContactName">
									<tr>
										<th width="50%">Contact Name</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ContactName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToName"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%" valign="top">Address</th>
									<td>
										<xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToAddress/AddressLine1"/>
										<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToAddress/AddressLine2">
											<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToAddress/AddressLine2"/>
										</xsl:if>
										<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToAddress/AddressLine3">
											<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToAddress/AddressLine3"/>
										</xsl:if>
										<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToAddress/AddressLine4">
											<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToAddress/AddressLine4"/>
										</xsl:if>
										<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToAddress/PostCode">
											<br/><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ShipTo/ShipToAddress/PostCode"/>
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
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/DeliveryNoteReferences">
									<tr>
										<th width="50%">DN Ref</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/DeliveryNoteReferences/DeliveryNoteReference"/></td>
									</tr>
									<tr>
										<th width="50%">DN Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/DeliveryNoteReferences/DeliveryNoteDate)"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%">INV Ref</th>
									<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/InvoiceReferences/InvoiceReference"/></td>
								</tr>
								<tr>
									<th width="50%">INV Date</th>
									<td><xsl:value-of select="user:gsFormatDate(//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/InvoiceReferences/InvoiceDate)"/></td>
								</tr>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/PurchaseOrderReferences">
									<tr>
										<th width="50%">PO Ref</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
									</tr>
									<tr>
										<th width="50%">PO Date</th>
										<td><xsl:value-of select="user:gsFormatDate(//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
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
							<!--Other ProofOfDeliveryRequest Info-->
							<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
								<tr>
									<th colspan="2">Request Details</th>
								</tr>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestDate">
									<tr>
										<th width="50%">Request Date</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestDate"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestTime">
									<tr>
										<th width="50%">Request Time</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestTime"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestUser">
									<tr>
										<th width="50%">Requested By</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestUser"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestUserEmail">																<tr>
										<th width="50%">Email</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestUserEmail"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestUserFax">
									<tr>
										<th width="50%">Fax</th>
										<td><xsl:value-of select="//ProofOfDeliveryRequest//ProofOfDeliveryRequestHeader/ProofOfDeliveryRequestDetails/ProofOfDeliveryRequestUserFax"/></td>
									</tr>
								</xsl:if>
							
							</table>
						</td>
						<td valign="top" width="50%">
						<br></br>
						</td>
					</tr>
					<tr>
						<td colspan="2"><br/></td>
					</tr>
				</table>	
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>