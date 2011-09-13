<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Hospitality Credit Request into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 27/09/2004 | A Sheppard | Created module.
******************************************************************************************
 13/01/2005 | A Sheppard | H298. Display line status to user
****************************************************************************************** 
 18/01/2006 | A Sheppard | H548. Change Buyer to Buyer/Invoice To
****************************************************************************************** 
 06/12/2006 | Lee Boyton | 595. The unit value, line value and total are now optional.
****************************************************************************************** 
 15/01/2007 | Lee Boyton | 696. Support for quality issue credit request.
****************************************************************************************** 
 23/03/2007 | Lee Boyton | 934. Display both the batch code and best before date if specified.
****************************************************************************************** 
 27/03/2007 | Lee Boyton | 934. Fixed invalid colspan references.
****************************************************************************************** 
 07/08/2007 | A Sheppard | 1351. Added return type
****************************************************************************************** 
 10/08/2007 | Lee Boyton | 1183. Display invoice reference and date if available.
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="html"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	<xsl:template match="/">
		<style>
			BODY
			{
			    FONT-SIZE: 12px;
			    COLOR: #666666;
			    FONT-FAMILY: Verdana, Arial;
			    BACKGROUND-COLOR: white;
			    style: "text-decoration: none"
			}
			TR.listrow0
			{
			    BACKGROUND-COLOR: #cbe6ff
			}
			TR.listrow1
			{
			    BACKGROUND-COLOR: #e3f1ff
			}
			TH
			{
			    FONT-WEIGHT: bold;
			    FONT-SIZE: 12px;
			    PADDING-BOTTOM: 2pt;
			    COLOR: black;
			    PADDING-TOP: 2pt;
			    FONT-FAMILY: Verdana, Arial;
			    BACKGROUND-COLOR: #99ccff
			}
			THEAD TH
			{
			    BORDER-RIGHT: thin;
			    BORDER-TOP: thin;
			    BORDER-LEFT: thin;
			    COLOR: white;
			    BORDER-BOTTOM: thin;
			    BACKGROUND-COLOR: #73738c
			}
			TR.label
			{
			    BACKGROUND-COLOR: #99ccff
			}
			TD
			{
			    FONT-SIZE: 12px
			}
			TABLE.DocumentSurround
			{
			    WIDTH: 100%;
			    BACKGROUND-COLOR: #cbe6ff
			}
			TABLE.DocumentSurround TH
			{
			    FONT-SIZE: larger;
			    COLOR: white;
			    BACKGROUND-COLOR: #73738c
			}
			TABLE.DocumentInner
			{
			    WIDTH: 100%;
			    BACKGROUND-COLOR: white
			}
			TABLE.DocumentInner TH
			{
			    FONT-SIZE: smaller;
			    COLOR: white;
			    BACKGROUND-COLOR: #73738c
			}
			TABLE.DocumentLines
			{
			    WIDTH: 100%;
			    BACKGROUND-COLOR: white
			}
			TABLE.DocumentLines TH
			{
			    FONT-SIZE: smaller
			}
		</style>
		<html>
			<body>
				<table class="DocumentSurround">	
					<!--Header-->
					<tr>
						<td align="center" colspan="2">
							<table width="100%">
								<tr>
									<th align="center">
										<xsl:text>Request For Credit</xsl:text>
										<xsl:if test="/CreditRequest/CreditRequestHeader/QualityCreditRequest = 'true' or /CreditRequest/CreditRequestHeader/QualityCreditRequest = '1'">
											<xsl:text> (Product Complaint Form)</xsl:text>
										</xsl:if>
									</th>
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
								<xsl:if test="number(/CreditRequest/CreditRequestHeader/Buyer/BuyersLocationID/GLN) != 0">
									<tr>
										<th width="50%">GLN</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/Buyer/BuyersLocationID/GLN"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/Buyer/BuyersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code For Location</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/Buyer/BuyersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/Buyer/BuyersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code For Location</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/Buyer/BuyersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/Buyer/BuyersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/Buyer/BuyersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress/AddressLine1"/>
											<xsl:if test="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress/AddressLine2">
												<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress/AddressLine3">
												<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress/AddressLine4">
												<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress/PostCode">
												<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/Buyer/BuyersAddress/PostCode"/>
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
								<xsl:if test="number(/CreditRequest/CreditRequestHeader/Supplier/SuppliersLocationID/GLN) != 0">
									<tr>
										<th width="50%">GLN</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/Supplier/SuppliersLocationID/GLN"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/Supplier/SuppliersLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code For Location</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/Supplier/SuppliersLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/Supplier/SuppliersLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code For Location</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/Supplier/SuppliersName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/Supplier/SuppliersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress">
									<tr>
										<th width="50%" valign="top">Address</th>
										<td>
											<xsl:value-of select="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress/AddressLine1"/>
											<xsl:if test="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress/AddressLine2">
												<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress/AddressLine3">
												<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress/AddressLine4">
												<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress/PostCode">
												<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/Supplier/SuppliersAddress/PostCode"/>
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
								<xsl:if test="number(/CreditRequest/CreditRequestHeader/ShipTo/ShipToLocationID/GLN) != 0">
									<tr>
										<th width="50%">GLN</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/ShipTo/ShipToLocationID/GLN"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/ShipTo/ShipToLocationID/BuyersCode">
									<tr>
										<th width="50%">Buyers Code For Location</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/ShipTo/ShipToLocationID/BuyersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/ShipTo/ShipToLocationID/SuppliersCode">
									<tr>
										<th width="50%">Suppliers Code For Location</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/ShipTo/ShipToLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/ShipTo/ShipToName">
									<tr>
										<th width="50%">Name</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/ShipTo/ShipToName"/></td>
									</tr>
								</xsl:if>
								<tr>
									<th width="50%" valign="top">Address</th>
									<td>
										<xsl:value-of select="/CreditRequest/CreditRequestHeader/ShipTo/ShipToAddress/AddressLine1"/>
										<xsl:if test="/CreditRequest/CreditRequestHeader/ShipTo/ShipToAddress/AddressLine2">
											<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/ShipTo/ShipToAddress/AddressLine2"/>
										</xsl:if>
										<xsl:if test="/CreditRequest/CreditRequestHeader/ShipTo/ShipToAddress/AddressLine3">
											<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/ShipTo/ShipToAddress/AddressLine3"/>
										</xsl:if>
										<xsl:if test="/CreditRequest/CreditRequestHeader/ShipTo/ShipToAddress/AddressLine4">
											<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/ShipTo/ShipToAddress/AddressLine4"/>
										</xsl:if>
										<xsl:if test="/CreditRequest/CreditRequestHeader/ShipTo/ShipToAddress/PostCode">
											<br/><xsl:value-of select="/CreditRequest/CreditRequestHeader/ShipTo/ShipToAddress/PostCode"/>
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
									<th width="50%">Credit Request Reference</th>
									<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/CreditRequestReferences/CreditRequestReference"/></td>
								</tr>
								<tr>
									<th width="50%">Credit Request Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/CreditRequest/CreditRequestHeader/CreditRequestReferences/CreditRequestDate)"/></td>
								</tr>
								<xsl:if test="/CreditRequest/CreditRequestHeader/InvoiceReferences">
									<tr>
										<th width="50%">Invoice Reference</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/InvoiceReferences/InvoiceReference"/></td>
									</tr>
									<tr>
										<th width="50%">Invoice Date</th>
										<td><xsl:value-of select="user:gsFormatDate(/CreditRequest/CreditRequestHeader/InvoiceReferences/InvoiceDate)"/></td>
									</tr>
								</xsl:if>								
								<tr>
									<th width="50%">Delivery Note Reference</th>
									<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/DeliveryNoteReferences/DeliveryNoteReference"/></td>
								</tr>
								<tr>
									<th width="50%">Delivery Note Date</th>
									<td><xsl:value-of select="user:gsFormatDate(/CreditRequest/CreditRequestHeader/DeliveryNoteReferences/DeliveryNoteDate)"/></td>
								</tr>
								<xsl:if test="/CreditRequest/CreditRequestHeader/PurchaseOrderReferences">
									<tr>
										<th width="50%">Purchase Order Reference</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
									</tr>
									<tr>
										<th width="50%">Purchase Order Date</th>
										<td><xsl:value-of select="user:gsFormatDate(/CreditRequest/CreditRequestHeader/PurchaseOrderReferences/PurchaseOrderDate)"/></td>
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
							<!--Other CreditRequest Info-->
							<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
								<tr>
									<th colspan="2">Other Details</th>
								</tr>
								<xsl:if test="/CreditRequest/CreditRequestHeader/BatchInformation/FileGenerationNo">
									<tr>
										<th width="50%">File Generation No</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/BatchInformation/FileGenerationNo"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/BatchInformation/FileVersionNo">
									<tr>
										<th width="50%">File Version No</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/BatchInformation/FileVersionNo"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/BatchInformation/FileCreationDate">
									<tr>
										<th width="50%">File Creation Date</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/BatchInformation/FileCreationDate"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/BatchInformation/SendersTransmissionReference">
									<tr>
										<th width="50%">Senders Trans Ref</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/BatchInformation/SendersTransmissionReference"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/BatchInformation/SendersTransmissionDate">
									<tr>
										<th width="50%">Senders Trans Date</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/BatchInformation/SendersTransmissionDate"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/CreditRequestReferences/VATRegNo">
									<tr>
										<th width="50%">VAT Reg No</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/CreditRequestReferences/VATRegNo"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/CreditRequest/CreditRequestHeader/CreditRequestReferences/ContactName">
									<tr>
										<th width="50%">Contact Name</th>
										<td><xsl:value-of select="/CreditRequest/CreditRequestHeader/CreditRequestReferences/ContactName"/></td>
									</tr>
								</xsl:if>
							</table>
						</td>
						<td valign="top" width="50%"><br/></td>
					</tr>
					<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine[not(NotAuthorised) or NotAuthorised='0']">
						<tr>
							<td colspan="2"><br/></td>
						</tr>
						<tr>
							<td colspan="2">
								<!--Authorised Credit Request Lines-->
								<table class="DocumentLines" cellpadding="1" cellspacing="1">			
									<tr>
										<th colspan="9">
											Credit Request Lines
										</th>
									</tr>
									<tr>
										<th>Line Status</th>
										<th>Suppliers Code</th>
										<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/ProductID/BuyersProductCode">
											<th>Buyers Code</th>
										</xsl:if>
										<th>Description</th>
										<th>Requested Qty</th>
										<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/PackSize">
											<th>Pack</th>
										</xsl:if>							
										<th>Price</th>
										<th>Line Value</th>
										<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/ReturnType">
											<th>Return Type</th>
										</xsl:if>
									</tr>
									<xsl:for-each select="/CreditRequest/CreditRequestDetail/CreditRequestLine[not(NotAuthorised) or NotAuthorised='0']">
										<xsl:variable name="LineClass">
											<xsl:value-of select="user:gsGetRowClass()"/>
										</xsl:variable>
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="$LineClass"/>
											</xsl:attribute>								
											<td>
												<xsl:choose>
													<xsl:when test="@LineStatus = 'PriceChanged'">Price Change</xsl:when>
													<xsl:when test="@LineStatus = 'QuantityChanged'">Quantity Change</xsl:when>
													<xsl:when test="@LineStatus = 'Rejected'">Reject</xsl:when>
													<xsl:when test="@LineStatus = 'QualityIssue'">Quality Issue</xsl:when>
													<xsl:otherwise><xsl:value-of select="@LineStatus"/></xsl:otherwise>
												</xsl:choose>
											</td>
											<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
											<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/ProductID/BuyersProductCode">
												<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
											</xsl:if>
											<td><xsl:value-of select="ProductDescription"/></td>
											<td align="right"><xsl:value-of select="RequestedQuantity"/></td>
											<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/PackSize">
												<td><xsl:value-of select="PackSize"/>&#xa0;</td>
											</xsl:if>								
											<td align="right"><xsl:value-of select="UnitValueExclVAT"/>&#xa0;</td>
											<td align="right"><xsl:value-of select="LineValueExclVAT"/>&#xa0;</td>
											<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/ReturnType">
												<td align="right"><xsl:value-of select="ReturnType"/>&#xa0;</td>
											</xsl:if>
										</tr>
										<xsl:if test="Narrative">
											<xsl:if test="BatchCode">
												<tr>
													<xsl:attribute name="class">
														<xsl:value-of select="$LineClass"/>
													</xsl:attribute>
													<td colspan="9">
														<xsl:text>Batch code: </xsl:text>
														<xsl:value-of select="BatchCode"/>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="BestBeforeDate">
												<tr>
													<xsl:attribute name="class">
														<xsl:value-of select="$LineClass"/>
													</xsl:attribute>	
													<td colspan="9">
														<xsl:text>Best before date: </xsl:text>
														<!-- switch to handle old corrupt data that was not formatted correctly in the xml -->
														<xsl:choose>
															<xsl:when test="contains(BestBeforeDate,'-')">
																<xsl:value-of select="user:gsFormatDate(BestBeforeDate)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="BestBeforeDate"/>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<xsl:attribute name="class">
													<xsl:value-of select="$LineClass"/>
												</xsl:attribute>	
												<td colspan="9">
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
										<td align="right"><xsl:value-of select="/CreditRequest/CreditRequestTrailer/NumberOfLines"/></td>
									</tr>
									<tr>
										<th width="50%">Number Of Items</th>
										<td align="right"><xsl:value-of select="/CreditRequest/CreditRequestTrailer/NumberOfItems"/></td>
									</tr>					
									<tr>
										<th width="50%">Total Excl VAT</th>
										<td align="right"><xsl:value-of select="/CreditRequest/CreditRequestTrailer/TotalExclVAT"/>&#xa0;</td>
									</tr>
								</table>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine[NotAuthorised='1']">
						<tr>
							<td colspan="2"><br/></td>
						</tr>
						<tr>
							<td colspan="2">
								<!--Unauthorised Credit Request Lines-->
								<table class="DocumentLines" cellpadding="1" cellspacing="1">				
									<tr>
										<th colspan="8">
											Unauthorised Credit Request Lines
										</th>
									</tr>
									<tr>
										<th>Line Status</th>
										<th>Suppliers Code</th>
										<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/ProductID/BuyersProductCode">
											<th>Buyers Code</th>
										</xsl:if>
										<th>Description</th>
										<th>Requested Qty</th>
										<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/PackSize">
											<th>Pack</th>
										</xsl:if>						
										<th>Price</th>
										<th>Line Value</th>
									</tr>
									<xsl:for-each select="/CreditRequest/CreditRequestDetail/CreditRequestLine[NotAuthorised='1']">
										<xsl:variable name="LineClass">
											<xsl:value-of select="user:gsGetRowClass()"/>
										</xsl:variable>
										<tr>
											<xsl:attribute name="class">
												<xsl:value-of select="$LineClass"/>
											</xsl:attribute>								
											<td>
												<xsl:choose>
													<xsl:when test="@LineStatus = 'PriceChanged'">Price Change</xsl:when>
													<xsl:when test="@LineStatus = 'QuantityChanged'">Quantity Change</xsl:when>
													<xsl:when test="@LineStatus = 'Rejected'">Reject</xsl:when>
													<xsl:when test="@LineStatus = 'QualityIssue'">Quality Issue</xsl:when>
													<xsl:otherwise><xsl:value-of select="@LineStatus"/></xsl:otherwise>
												</xsl:choose>
											</td>
											<td><xsl:value-of select="ProductID/SuppliersProductCode"/>&#xa0;</td>
											<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/ProductID/BuyersProductCode">
												<td><xsl:value-of select="ProductID/BuyersProductCode"/>&#xa0;</td>
											</xsl:if>
											<td><xsl:value-of select="ProductDescription"/></td>
											<td align="right"><xsl:value-of select="RequestedQuantity"/></td>
											<xsl:if test="/CreditRequest/CreditRequestDetail/CreditRequestLine/PackSize">
												<td><xsl:value-of select="PackSize"/>&#xa0;</td>
											</xsl:if>							
											<td align="right"><xsl:value-of select="UnitValueExclVAT"/>&#xa0;</td>
											<td align="right"><xsl:value-of select="LineValueExclVAT"/>&#xa0;</td>
										</tr>
										<xsl:if test="Narrative">
											<xsl:if test="BatchCode">
												<tr>
													<xsl:attribute name="class">
														<xsl:value-of select="$LineClass"/>
													</xsl:attribute>
													<td colspan="8">
														<xsl:text>Batch code: </xsl:text>
														<xsl:value-of select="BatchCode"/>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="BestBeforeDate">
												<tr>
													<xsl:attribute name="class">
														<xsl:value-of select="$LineClass"/>
													</xsl:attribute>	
													<td colspan="8">
														<xsl:text>Best before date: </xsl:text>
														<!-- switch to handle old corrupt data that was not formatted correctly in the xml -->
														<xsl:choose>
															<xsl:when test="contains(BestBeforeDate,'-')">
																<xsl:value-of select="user:gsFormatDate(BestBeforeDate)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="BestBeforeDate"/>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<xsl:attribute name="class">
													<xsl:value-of select="$LineClass"/>
												</xsl:attribute>
												<td colspan="8">
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
										<th colspan="2">Unauthorised Totals</th>
									</tr>
									<tr>
										<th width="50%">Number Of Lines</th>
										<td align="right">
											<xsl:choose>
												<xsl:when test="/CreditRequest/CreditRequestDetail/CreditRequestLine[not(NotAuthorised) or NotAuthorised='0']">
													<xsl:value-of select="/CreditRequest/CreditRequestTrailer/UnauthorisedLines/NumberOfLines"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/CreditRequest/CreditRequestTrailer/NumberOfLines"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr>
										<th width="50%">Number Of Items</th>
										<td align="right">
											<xsl:choose>
												<xsl:when test="/CreditRequest/CreditRequestDetail/CreditRequestLine[not(NotAuthorised) or NotAuthorised='0']">
													<xsl:value-of select="/CreditRequest/CreditRequestTrailer/UnauthorisedLines/NumberOfItems"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/CreditRequest/CreditRequestTrailer/NumberOfItems"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
			
									<!-- we may now be hiding monetary values -->					
									<tr>
										<th width="50%">Total Excl VAT</th>
										<td align="right">
											<xsl:choose>
												<xsl:when test="/CreditRequest/CreditRequestDetail/CreditRequestLine[not(NotAuthorised) or NotAuthorised='0']">
													<xsl:value-of select="/CreditRequest/CreditRequestTrailer/UnauthorisedLines/TotalExclVAT"/>&#xa0;
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/CreditRequest/CreditRequestTrailer/TotalExclVAT"/>&#xa0;
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</xsl:if>
				</table>	
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>