<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Takes the TownandCountry version of a Invoice and map it  into the internal xml invoice format.
 
 © Alternative Business Solutions Ltd., 2000.
******************************************************************************************
 Module History
******************************************************************************************
 Version     | 
******************************************************************************************
 Date        | Name             | Description of modification
******************************************************************************************
08/07/2009  | Rave Tech			| FB2994 Created stylesheet
******************************************************************************************
21/07/2009  | R Cambridge			| FB2994 shuffle up blank address details                                                                            
******************************************************************************************
04/08/2009  | R Cambridge			| FB2994 Loop through all lines                                                       
******************************************************************************************
05/08/2009  | H Mahbub      		| FB2994 Corrected X path for PO date  
******************************************************************************************  
            |            			|                                                                             
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>			
						<xsl:element name="Invoice">
							<xsl:element name="TradeSimpleHeader">
								<xsl:element name="SendersCodeForRecipient">
									<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='shipTo']/@addressID"/>
								</xsl:element>
								<xsl:if test="//InvoiceDetailOrder/InvoiceDetailOrderInfo/MasterAgreementReference/@agreementID">
									<xsl:element name="SendersBranchReference">
										<xsl:value-of select="//InvoiceDetailOrder/InvoiceDetailOrderInfo/MasterAgreementReference/@agreementID"/>
									</xsl:element>
								</xsl:if>					
							</xsl:element>
							<!-- InvoiceHeader -->
							<xsl:element name="InvoiceHeader">					
								<!-- Buyer -->
								<xsl:element name="Buyer">
									<xsl:element name="BuyersLocationID">							
										<xsl:if test="//InvoicePartner/Contact[@Role='billTo']/@addressID">
											<xsl:element name="SuppliersCode">
												<xsl:value-of select="//InvoicePartner/Contact[@Role='billTo']/@addressID"/>
											</xsl:element>
										</xsl:if>
									</xsl:element>
									<!-- BuyersName -->
									<xsl:if test="//InvoicePartner/Contact[@Role='billTo']/Name">
										<xsl:element name="BuyersName">
											<xsl:value-of select="//InvoicePartner/Contact[@Role='billTo']/Name"/>
										</xsl:element>
									</xsl:if>
									<!-- BuyersAddress-->
									<xsl:element name="BuyersAddress">
										<!--xsl:element name="AddressLine1">
											<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='billTo']/PostalAddress/Street"/>
										</xsl:element>
										<xsl:element name="AddressLine2">
											<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='billTo']/PostalAddress/City"/>
										</xsl:element>
										<xsl:element name="AddressLine3">
											<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='billTo']/PostalAddress/Country"/>
										</xsl:element-->
										
										<xsl:for-each select="//InvoicePartner/Contact[@Role='billTo']/PostalAddress/*[name()='Street' or name()='City' or name()='Country'][. != '']">
											<xsl:element name="{concat('AddressLine', string(position()))}">
												<xsl:value-of select="."/>											
											</xsl:element>											
										</xsl:for-each>
										
										<xsl:element name="PostCode">
											<xsl:value-of select="//InvoicePartner/Contact[@Role='billTo']/PostalAddress/PostalCode"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
								<!-- Supplier -->
								<xsl:element name="Supplier">
									<xsl:element name="SuppliersLocationID">							
										<!-- SuppliersCode -->
										<xsl:if test="//InvoicePartner/Contact[@Role='from']/@addressID">
											<xsl:element name="SuppliersCode">
												<xsl:value-of select="//InvoicePartner/Contact[@Role='from']/@addressID"/>
											</xsl:element>
										</xsl:if>
									</xsl:element>
									<!-- SuppliersName -->
									<xsl:if test="//InvoicePartner/Contact[@Role='from']/Name">
										<xsl:element name="SuppliersName">
											<xsl:value-of select="//InvoicePartner/Contact[@Role='from']/Name"/>
										</xsl:element>
									</xsl:if>
									<!-- SuppliersAddress -->
									<xsl:element name="SuppliersAddress">
										<!--xsl:element name="AddressLine1">
											<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='from']/PostalAddress/Street"/>
										</xsl:element>
										<xsl:element name="AddressLine2">
											<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='from']/PostalAddress/City"/>
										</xsl:element>
										<xsl:element name="AddressLine3">
											<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='from']/PostalAddress/Country"/>
										</xsl:element-->
										<xsl:for-each select="//InvoicePartner/Contact[@Role='from']/PostalAddress/*[name()='Street' or name()='City' or name()='Country'][. != '']">
											<xsl:element name="{concat('AddressLine', string(position()))}">
												<xsl:value-of select="."/>											
											</xsl:element>											
										</xsl:for-each>
										
										<xsl:element name="PostCode">
											<xsl:value-of select="//InvoicePartner/Contact[@Role='from']/PostalAddress/PostalCode"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
								<!-- ShipTo -->
								<xsl:element name="ShipTo">
									<xsl:element name="ShipToLocationID">							
										<!-- SuppliersCode -->
										<xsl:if test="//InvoiceDetailShipping/Contact[@Role='shipTo']/@addressID">
											<xsl:element name="SuppliersCode">
												<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='shipTo']/@addressID"/>
											</xsl:element>
										</xsl:if>
									</xsl:element>
									<!-- ShipToName -->
									<xsl:if test="//InvoiceDetailShipping/Contact[@Role='shipTo']/Name">
										<xsl:element name="ShipToName">
											<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='shipTo']/Name"/>
										</xsl:element>
									</xsl:if>
									<!-- ShipToAddress -->
									<xsl:element name="ShipToAddress">
										<!--xsl:element name="AddressLine1">
											<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='shipTo']/PostalAddress/Street"/>
										</xsl:element>
										<xsl:if test="//InvoiceDetailShipping/Contact[@Role='shipTo']/PostalAddress/City">
											<xsl:element name="AddressLine2">
												<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='shipTo']/PostalAddress/City"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="//InvoiceDetailShipping/Contact[@Role='shipTo']/PostalAddress/Country">
											<xsl:element name="AddressLine3">
												<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='shipto']/PostalAddress/Country"/>
											</xsl:element>
										</xsl:if-->
										
										<xsl:for-each select="//InvoiceDetailShipping/Contact[@Role='shipTo']/PostalAddress/*[name()='Street' or name()='City' or name()='Country'][. != '']">
											<xsl:element name="{concat('AddressLine', string(position()))}">
												<xsl:value-of select="."/>											
											</xsl:element>											
										</xsl:for-each>
										
										<xsl:if test="//InvoiceDetailShipping/Contact[@Role='shipTo']/PostalAddress/PostalCode">
											<xsl:element name="PostCode">
												<xsl:value-of select="//InvoiceDetailShipping/Contact[@Role='shipTo']/PostalAddress/PostalCode"/>
											</xsl:element>
										</xsl:if>
									</xsl:element>
								</xsl:element>
								<!-- Invoice References-->
								<xsl:element name="InvoiceReferences">
									<xsl:element name="InvoiceReference">
										<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceID"/>
									</xsl:element>
									<xsl:element name="InvoiceDate">
										<xsl:value-of select="substring-before(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate,'T')"/>
									</xsl:element>
									<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate">
										<xsl:element name="TaxPointDate">
											<xsl:value-of select="substring-before(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate,'T')"/>
										</xsl:element>
									</xsl:if>						
								</xsl:element>
								<!-- Currency -->
								<xsl:element name="Currency">
									<xsl:text>GBP</xsl:text>
								</xsl:element>
							</xsl:element>
							<!-- Invoice  Details-->
							<xsl:element name="InvoiceDetail">
								<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem">
									<xsl:element name="InvoiceLine">
										<!-- LineNumber -->
										<xsl:element name="LineNumber">
											<xsl:value-of select="@InvoiceLineNumber"/>
										</xsl:element>
										<!-- PurchaseOrderReferences-->
										<xsl:if test="../InvoiceDetailOrderInfo/OrderIDInfo/@orderID">
											<xsl:element name="PurchaseOrderReferences">
												<xsl:element name="PurchaseOrderReference">
													<xsl:value-of select="../InvoiceDetailOrderInfo/OrderIDInfo/@orderID"/>
												</xsl:element>
												<xsl:element name="PurchaseOrderDate">
													<xsl:value-of select="substring-before(../InvoiceDetailOrderInfo/OrderIDInfo/@orderDate,'T')"/>
												</xsl:element>
												<xsl:if test="../InvoiceDetailOrderInfo/MasterAgreementReference/@agreementID">
													<xsl:element name="TradeAgreement">
														<xsl:element name="ContractReference">
															<xsl:value-of select="../InvoiceDetailOrderInfo/MasterAgreementReference/@agreementID"/>
														</xsl:element>
													</xsl:element>
												</xsl:if>
											</xsl:element>
										</xsl:if>
										<!-- DeliveryNoteReferences-->
										<xsl:if test="//InvoiceDetailRequestHeader/InvoiceDetailShipping/ShipmentIdentifier">
											<xsl:element name="DeliveryNoteReferences">
												<xsl:element name="DeliveryNoteReference">
													<xsl:value-of select="//InvoiceDetailRequestHeader/InvoiceDetailShipping/ShipmentIdentifier"/>
												</xsl:element>
												<xsl:element name="DeliveryNoteDate">
													<xsl:value-of select="substring-before(//InvoiceDetailRequestHeader/InvoiceDetailShipping/shippingDate,'T')"/>
												</xsl:element>
												<xsl:element name="DespatchDate">
													<xsl:value-of select="substring-before(//InvoiceDetailRequestHeader/InvoiceDetailShipping/shippingDate,'T')"/>
												</xsl:element>
											</xsl:element>
										</xsl:if>
										<!-- ProductID-->
										<xsl:element name="ProductID">
											<xsl:if test="InvoiceDetailItemReference/ItemID/SupplierPartID">
												<xsl:element name="SuppliersProductCode">
													<xsl:value-of select="InvoiceDetailItemReference/ItemID/SupplierPartID"/>
												</xsl:element>
											</xsl:if>
										</xsl:element>
										<!-- ProductDescription -->
										<xsl:element name="ProductDescription">
											<xsl:value-of select="InvoiceDetailItemReference/Description"/>
										</xsl:element>
										<!-- InvoicedQuantity-->
										<xsl:element name="InvoicedQuantity">
											<xsl:value-of select="@quantity"/>
										</xsl:element>
										<!-- UnitValueExclVAT-->
										<xsl:element name="UnitValueExclVAT">
											<xsl:value-of select="format-number(UnitPrice/Money,'0.00')"/>
										</xsl:element>
										<!-- LineValueExclVAT-->
										<xsl:element name="LineValueExclVAT">
											<xsl:value-of select="format-number(SubtotalAmount/Money,'0.00')"/>
										</xsl:element>
										<!-- VATCode-->
										<xsl:element name="VATCode">
											<xsl:choose>
												<xsl:when test="number(Tax/TaxDetail/@percentageRate) = 15 or number(Tax/TaxDetail/@percentageRate) = 17.5 or number(Tax/TaxDetail/@percentageRate) = 20.0 or number(Tax/TaxDetail/@percentageRate) = 20.00">
													<xsl:text>S</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Z</xsl:text>
												</xsl:otherwise>
											</xsl:choose>							
										</xsl:element>												
										<!-- VATRate-->
										<xsl:element name="VATRate">
											<xsl:value-of select="format-number(Tax/TaxDetail/@percentageRate,'0.00')"/>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
							
							<!-- InvoiceTrailer -->
							<xsl:element name="InvoiceTrailer">					
								<!-- VATSubTotals -->
								<xsl:element name="VATSubTotals">
									<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail">
										<!-- store the VATRate and VATCode in variables as we use them more than once below -->
										<xsl:variable name="currentVATCode">
											<xsl:choose>
												<xsl:when test="number(@percentageRate) = 15 or number(@percentageRate) = 17.5 or number(@percentageRate) = 20.0 or number(@percentageRate) = 20.00">
													<xsl:text>S</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Z</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="currentVATRate">
											<xsl:value-of select="@percentageRate"/>
										</xsl:variable>
															
										<xsl:element name="VATSubTotal">
											<xsl:attribute name="VATCode"><xsl:value-of select="$currentVATCode"/></xsl:attribute>
											<xsl:attribute name="VATRate"><xsl:value-of select="format-number($currentVATRate,'0.00')"/></xsl:attribute>										
											<xsl:element name="DiscountedLinesTotalExclVATAtRate">
												<xsl:value-of select="format-number(TaxableAmount,'0.00')"/>
											</xsl:element>
											<xsl:element name="DocumentDiscountAtRate">
												<xsl:value-of select="0"/>
											</xsl:element>
											<xsl:element name="DocumentTotalExclVATAtRate">
												<xsl:value-of select="format-number(TaxableAmount,'0.00')"/>
											</xsl:element>
											<xsl:element name="SettlementDiscountAtRate">
												<xsl:value-of select="0"/>
											</xsl:element>
											<xsl:element name="SettlementTotalExclVATAtRate">
												<xsl:value-of select="format-number(TaxableAmount,'0.00')"/>
											</xsl:element>
											<xsl:element name="VATAmountAtRate">
												<xsl:value-of select="format-number(TaxAmount,'0.00')"/>
											</xsl:element>
											<xsl:element name="DocumentTotalInclVATAtRate">
												<xsl:value-of select="format-number(number(TaxableAmount) + number(TaxAmount),'0.00')"/>								
											</xsl:element>
											<xsl:element name="SettlementTotalInclVATAtRate">
												<xsl:value-of select="format-number(number(TaxableAmount) + number(TaxAmount),'0.00')"/>
											</xsl:element>							
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
								<xsl:element name="DiscountedLinesTotalExclVAT">
									<xsl:value-of select="format-number(/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount,'0.00')"/>
								</xsl:element>
								<xsl:element name="DocumentDiscount">
									<xsl:value-of select="0"/>
								</xsl:element>
								<xsl:element name="DocumentTotalExclVAT">
									<xsl:value-of select="format-number(/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount,'0.00')"/>
								</xsl:element>
								<xsl:element name="SettlementDiscount">
									<xsl:value-of select="0"/>
								</xsl:element>
								<xsl:element name="SettlementTotalExclVAT">
									<xsl:value-of select="format-number(/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/NetAmount/Money,'0.00')"/>
								</xsl:element>
								<xsl:element name="DocumentTotalInclVAT">
									<xsl:value-of select="format-number(/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/GrossAmount/Money,'0.00')"/>
								</xsl:element>
								<xsl:element name="SettlementTotalInclVAT">
									<xsl:value-of select="format-number(/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/DueAmount/Money,'0.00')"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
						</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
