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
18/11/2010  | J Cahill		  | Created module. 
						  | Based on tsMappingPurchaseOrderAcknowlegement.xsl
						  | and tsMappingEmailPurchaseOrderConfirmation.xsl						  
13/12/2010 | Graham Neicho | FB4001. Altered LocaleID to MessagingEngineLocaleID, 
							so this parameter name and its usage are unique
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="html"/>
	<xsl:include href="Internationalisation.xsl"/>
	
	<!-- constants for default values -->
	<xsl:variable name="changedLineClass" select="'Changed'"/>
	<xsl:param name="HideMoneyValues" select="'0'"/>	
	<xsl:param name="RootFolderPath" select="'Translations'"/>	
	<xsl:param name="TranslationFile" select="'HospitalityPurchaseOrderAcknowledgement.xml'"/>	
	
	<!-- MessagingEngineLocaleID is supplied when calling DocTransform method in processor. English is default -->
	<xsl:param name="MessagingEngineLocaleID" select="'2057'"/>
	<xsl:param name="LocaleID" select="$MessagingEngineLocaleID"/>
	
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
									<th align="center">
										<xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template>
										<xsl:text> (</xsl:text><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/DocumentStatus"/><xsl:text>)</xsl:text></th>		
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
									<!-- Buyer/Invoice To -->
									<th colspan="2"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></th>
								</tr>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/BuyersCode">
									<tr>
										<!-- Buyers Code -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></th>
										<td>
											<xsl:choose>
												<xsl:when test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/BuyersCode='Not provided'">
													<xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="29"/></xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/BuyersCode"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/SuppliersCode">
									<tr>
										<!-- Supppliers Code -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></th>
										<td>
											<xsl:choose>
												<xsl:when test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/SuppliersCode='Not provided'">
													<xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="29"/></xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/SuppliersCode"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersName">
									<tr>
										<!-- Name -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></th>
										<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress">
									<tr>
										<!-- Address -->
										<th width="50%" valign="top"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></th>
										<td>
											<xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine1"/>
											<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine2">
												<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine3">
												<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine4">
												<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/PostCode">
												<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/PostCode"/>
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
									<!-- Supplier -->
									<th colspan="2"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></th>
								</tr>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/BuyersCode">
									<tr>
										<!-- Buyers Code -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></th>
										<td>
											<xsl:choose>
												<xsl:when test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/BuyersCode='Not provided'">
													<xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="29"/></xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/BuyersCode"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/SuppliersCode">
									<tr>
										<!-- Suppliers Code -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></th>
										<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/SuppliersCode"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersName">
									<tr>
										<!-- Name -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></th>
										<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress">
									<tr>
										<!-- Address -->
										<th width="50%" valign="top"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></th>
										<td>
											<xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine1"/>
											<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine2">
												<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine2"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine3">
												<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine3"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine4">
												<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine4"/>
											</xsl:if>
											<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/PostCode">
												<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/PostCode"/>
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
									<!-- ShipTo -->
									<th colspan="2"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></th>
								</tr>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/BuyersCode">
									<tr>
										<!-- Buyers Code -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></th>
										<td>
											<xsl:choose>
												<xsl:when test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/BuyersCode='Not provided'">
													<xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="29"/></xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/BuyersCode"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/SuppliersCode">
									<tr>
										<!-- Suppliers Code -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></th>
										<td>
											<xsl:choose>
												<xsl:when test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/SuppliersCode='Not provided'">
													<xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="29"/></xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ContactName">
									<tr>
										<!-- Contact Name -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></th>
										<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ContactName"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToName">
									<tr>
										<!-- Name -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></th>
										<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToName"/></td>
									</tr>
								</xsl:if>
								<tr>
									<!-- Address -->
									<th width="50%" valign="top"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></th>
									<td>
										<xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine1"/>
										<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine2">
											<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine2"/>
										</xsl:if>
										<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine3">
											<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine3"/>
										</xsl:if>
										<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine4">
											<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine4"/>
										</xsl:if>
										<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/PostCode">
											<br/><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/PostCode"/>
										</xsl:if>
									</td>
								</tr>
							</table>
						</td>
						<td valign="top" width="50%">
							<!--Delivery Details-->
							<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
								<tr>
									<!-- Delivery -->
									<th colspan="2"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></th>
								</tr>
								<tr>
									<!-- Delivery Type -->
									<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></th>
									<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/OrderedDeliveryDetails/DeliveryType"/></td>
								</tr>
								<tr>
									<!-- Delivery Date -->
									<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></th>
									<td><xsl:value-of select="user:gsFormatDateByLocale(/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/OrderedDeliveryDetails/DeliveryDate,$LocaleID)"/></td>
								</tr>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/OrderedDeliveryDetails/DeliverySlot">
									<tr>
										<!-- Slot Start -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></th>
										<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/></td>
									</tr>
									<tr>
										<!-- Slot End -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></th>
										<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/></td>
									</tr>
								</xsl:if>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">
									<tr>
										<!-- Special Delivery instructions -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></th>
										<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/></td>
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
									<!-- references -->
									<th colspan="2"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></th>
								</tr>
								<tr>
									<!-- PO Ack Ref -->
									<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></th>
									<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementReference"/></td>
								</tr>
								<tr>
									<!-- PO Ack Date -->
									<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></th>
									<td><xsl:value-of select="user:gsFormatDateByLocale(/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementDate,$LocaleID)"/></td>
								</tr>
								<tr>
									<!-- PO ref -->
									<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></th>
									<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/PurchaseOrderReference"/></td>
								</tr>
								<tr>
									<!-- PO Date -->
									<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="20"/></xsl:call-template></th>
									<td><xsl:value-of select="user:gsFormatDateByLocale(/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/PurchaseOrderDate,$LocaleID)"/></td>
								</tr>
								<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
									<tr>
										<!-- Customers PO Ref -->
										<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="21"/></xsl:call-template></th>
										<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/></td>
									</tr>
								</xsl:if>
							</table>
						</td>
						<td valign="top" width="50%">
							<!--TradeAgreement-->
							<xsl:choose>
								<xsl:when test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">
									<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
										<tr>
											<!-- Trade Agreement -->
											<th colspan="2"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="22"/></xsl:call-template></th>
										</tr>
										<tr>
											<!-- Contract Reference -->
											<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="23"/></xsl:call-template></th>
											<td><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/></td>
										</tr>
										<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">
											<tr>
												<!-- Contract Date -->
												<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="24"/></xsl:call-template></th>
												<td><xsl:value-of select="user:gsFormatDateByLocale(/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/TradeAgreement/ContractDate,$LocaleID)"/></td>
											</tr>
										</xsl:if>
									</table>
								</xsl:when>
								<xsl:otherwise>&#xa0;</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementTrailer">
						<tr>
							<td colspan="2"><br/></td>
						</tr>
						<tr>
							<td><br/></td>
							<td>
								<!--Totals-->
								<table class="DocumentInner" cellpadding="1" cellspacing="1">
									<tr>
										<!-- Totals -->
										<th colspan="2"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="25"/></xsl:call-template></th>
									</tr>
									<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementTrailer/NumberOfLines">
										<tr>
											<!-- Number Of Lines -->
											<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="26"/></xsl:call-template></th>
											<td align="right"><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementTrailer/NumberOfLines"/></td>
										</tr>
									</xsl:if>
									
									<!-- we may now be hiding monetary values -->
									<xsl:if test="$HideMoneyValues != 1">	
										<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementTrailer/TotalExclVAT">
											<tr>
												<!-- Total Excl VAT -->
												<th width="50%"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="27"/></xsl:call-template></th>
												<td align="right"><xsl:value-of select="user:gsFormatNumberByLocale(/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementTrailer/TotalExclVAT, 2,$LocaleID,1)"/></td>
											</tr>
										</xsl:if>
									</xsl:if>
								</table>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/OrderStatusURL">
						<tr>
							<td colspan="2"><br/></td>
						</tr>
						<tr>
							<td colspan="2"  class="StatusLink">
								<a target="window">
									<xsl:attribute name="href"><xsl:value-of select="/PurchaseOrderAcknowledgement/PurchaseOrderAcknowledgementHeader/OrderStatusURL"/></xsl:attribute>
									<!-- Click here to view the supplier's order information -->
									<xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="28"/></xsl:call-template>
								</a>
							</td>
						</tr>
					</xsl:if>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>