<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

	Invoice/credit approval report to Spirit's Peoplesoft system

==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 01/05/2011	| A Barber				| 4376 Created module
==========================================================================================
 18/05/2011	| R Cambridge			| 4376 system testing changes
==========================================================================================
 20/07/2011 | A Barber         	| 4376 Updated all name references from Punch to Spirit.
==========================================================================================
 04/08/2011	| R Cambridge			| 4686 UAT change: don't create PO refs element if PO blank
==========================================================================================
 13/02/2012	| H Robson			| 5236 Modify to determine the correct document type based on document value (positive/negative)
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl msxsl">
	<xsl:output method="xml" encoding="utf-8"/>
	<!-- outputs a batch of batches, outer batches are grouped by type then supplier -->
	<!--=======================================================================================
  Routine        : {default template}
  Description    : strip + signs out of line values in the input XML, because you cant sum numbers with plus signs or remove the 
  					plus signs dynamically, and puts the resulting xml in a variable. 
  Author         : H Robson 5236 17/02/12
 =======================================================================================-->
	<xsl:template match="/">
		<!-- variable for new XML -->
		<xsl:variable name="xmlNoPlusSigns">
			<xsl:apply-templates/>
		</xsl:variable>
		<!-- DEBUGGING
		<xsl:copy-of select="msxsl:node-set($xmlNoPlusSigns)"/> -->
		<!--perform the rest of the transformation as normal -->
		<xsl:call-template name="mainTransformation">
			<xsl:with-param name="vobNode" select="msxsl:node-set($xmlNoPlusSigns)"/>
		</xsl:call-template>
	</xsl:template>
	<!-- remove plus signs, and replace with another leading 0 so that everything is still padded the same -->
	<xsl:template match="LineValueExclVAT">
		<LineValueExclVAT>
			<xsl:value-of select="translate(.,'+','0')"/>
		</LineValueExclVAT>
	</xsl:template>
	<!-- copy template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!--=======================================================================================
  Routine        : mainTransformation
  Description    : creates the output xml as before, except now it is acting on a variable and not directly on the input xml
  Author         : H Robson 5236 17/02/12
 =======================================================================================-->
	<xsl:template name="mainTransformation">
		<xsl:param name="vobNode"/>
		<xsl:variable name="SPIRIT_PREFIX" select="'SPIRIT_'"/>
		<BatchRoot>
			<!-- Generate Invoices-->
			<!-- one iteration of this loop for every distinct buyerscode -->
			<!-- 20/02/12 checks that the buyers code in the current document is not equal to any buyers code in a previous document with a positive total, and that the current document has a positive total --> 
			<xsl:for-each select="$vobNode/Batch/BatchDocuments/BatchDocument/Invoice[not(InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode = preceding::InvoiceHeader[sum(../InvoiceDetail/InvoiceLine/LineValueExclVAT) &gt; 0]/Supplier/SuppliersLocationID/BuyersCode) and sum(InvoiceDetail/InvoiceLine/LineValueExclVAT) &gt; 0]">
				<xsl:variable name="buyersCode" select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				<Document>
					<xsl:attribute name="TypePrefix"><xsl:text>INV</xsl:text></xsl:attribute>
					<Batch>
						<BatchDocuments>
							<!-- one iteration of this loop for every occurence of the same buyerscode as in the outer loop, where the document total is positive -->
							<xsl:for-each select="$vobNode/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode = $buyersCode and sum(InvoiceDetail/InvoiceLine/LineValueExclVAT) &gt; 0]">
								<BatchDocument>
									<Invoice>
										<TradeSimpleHeader>
											<SendersCodeForRecipient>
												<!-- SCR is defined by POunch but need to ensure Spirit's codes do not clash with supplier defined codes for other customers -->
												<xsl:value-of select="concat($SPIRIT_PREFIX,TradeSimpleHeader/SendersCodeForRecipient)"/>
											</SendersCodeForRecipient>
										</TradeSimpleHeader>
										<InvoiceHeader>
											<!--Buyer>
													<BuyersLocationID>
														<SuppliersCode/>
													</BuyersLocationID>
												</Buyer-->
											<Supplier>
												<SuppliersLocationID>
													<BuyersCode>
														<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
													</BuyersCode>
												</SuppliersLocationID>
											</Supplier>
											<ShipTo>
												<!--ShipToLocationID>
														<SuppliersCode>
															<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
														</SuppliersCode>
													</ShipToLocationID-->
											</ShipTo>
											<InvoiceReferences>
												<InvoiceReference>
													<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
												</InvoiceReference>
												<InvoiceDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
													</xsl:call-template>
												</InvoiceDate>
												<TaxPointDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
													</xsl:call-template>
												</TaxPointDate>
											</InvoiceReferences>
											<HeaderExtraData>
												<VoucherID>
													<xsl:value-of select="*/Buyer/BuyersAddress/AddressLine1"/>
												</VoucherID>
												<InvoiceType>
													<xsl:value-of select="*/Buyer/BuyersAddress/AddressLine2"/>
												</InvoiceType>
											</HeaderExtraData>
										</InvoiceHeader>
										<InvoiceDetail>
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
												<InvoiceLine>
													<xsl:if test="string(../*[1]/PurchaseOrderReferences/PurchaseOrderReference) != '' and string(../*[1]/PurchaseOrderReferences/PurchaseOrderDate) != ''">
														<PurchaseOrderReferences>
															<PurchaseOrderReference>
																<xsl:value-of select="../*[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
															</PurchaseOrderReference>
															<PurchaseOrderDate>
																<xsl:call-template name="utcDate">
																	<xsl:with-param name="input" select="../*[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
																</xsl:call-template>
															</PurchaseOrderDate>
														</PurchaseOrderReferences>
													</xsl:if>
													<DeliveryNoteReferences>
														<DeliveryNoteReference>
															<xsl:value-of select="../*[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
														</DeliveryNoteReference>
														<DeliveryNoteDate>
															<xsl:call-template name="utcDate">
																<xsl:with-param name="input" select="../*[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
															</xsl:call-template>
														</DeliveryNoteDate>
													</DeliveryNoteReferences>
													<ProductID>
														<SuppliersProductCode>
															<xsl:value-of select="ProductID/SuppliersProductCode"/>
														</SuppliersProductCode>
													</ProductID>
													<!-- quantities to 4dp -->
													<InvoicedQuantity>
														<xsl:choose>
															<xsl:when test="substring(InvoicedQuantity,1,1) = '-'">
																<xsl:value-of select="format-number(concat(substring(InvoicedQuantity,1,12),'.',substring(InvoicedQuantity,13,4)),'0.0000')"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="format-number(concat(substring(InvoicedQuantity,2,11),'.',substring(InvoicedQuantity,13,4)),'0.0000')"/>
															</xsl:otherwise>
														</xsl:choose>
													</InvoicedQuantity>
													<UnitValueExclVAT>
														<xsl:value-of select="format-number(format-number(concat(substring(LineValueExclVAT,2,13),'.',substring(LineValueExclVAT,15,2)),'0.00') div format-number(concat(substring(InvoicedQuantity,2,11),'.',substring(InvoicedQuantity,13,4)),'0.0000'),'0.00')"/>
													</UnitValueExclVAT>
													<LineValueExclVAT>
														<xsl:choose>
															<xsl:when test="substring(LineValueExclVAT,1,1) = '-'">
																<xsl:value-of select="format-number(concat(substring(LineValueExclVAT,1,14),'.',substring(LineValueExclVAT,15,2)),'0.00')"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="format-number(concat(substring(LineValueExclVAT,2,13),'.',substring(LineValueExclVAT,15,2)),'0.00')"/>
															</xsl:otherwise>
														</xsl:choose>
													</LineValueExclVAT>
													<VATCode>Z</VATCode>
													<VATRate>0.00</VATRate>
												</InvoiceLine>
											</xsl:for-each>
										</InvoiceDetail>
									</Invoice>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			</xsl:for-each>
			<!-- Generate Credit Notes -->
			<!-- 20/02/12 checks that the buyers code in the current document is not equal to any buyers code in a previous document with a negative total, and that the current document has a negative total --> 
			<xsl:for-each select="$vobNode/Batch/BatchDocuments/BatchDocument/Invoice[not(InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode = preceding::InvoiceHeader[sum(../InvoiceDetail/InvoiceLine/LineValueExclVAT) &lt; 0]/Supplier/SuppliersLocationID/BuyersCode) and sum(InvoiceDetail/InvoiceLine/LineValueExclVAT) &lt; 0]">
				<xsl:variable name="buyersCode" select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				<Document>
					<xsl:attribute name="TypePrefix"><xsl:text>CRN</xsl:text></xsl:attribute>
					<Batch>
						<BatchDocuments>
							<!-- one iteration of this loop for every occurence of the same buyerscode as in the outer loop, where the document total is negative -->
							<xsl:for-each select="$vobNode/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode = $buyersCode and sum(InvoiceDetail/InvoiceLine/LineValueExclVAT) &lt; 0]">
								<BatchDocument>
									<CreditNote>
										<TradeSimpleHeader>
											<SendersCodeForRecipient>
												<!-- SCR is defined by POunch but need to ensure Spirit's codes don not clash with supplier defined codes for other customs -->
												<xsl:value-of select="concat($SPIRIT_PREFIX,TradeSimpleHeader/SendersCodeForRecipient)"/>
											</SendersCodeForRecipient>
										</TradeSimpleHeader>
										<CreditNoteHeader>
											<!--Buyer>
													<BuyersLocationID>
														<SuppliersCode/>
													</BuyersLocationID>
												</Buyer-->
											<Supplier>
												<SuppliersLocationID>
													<BuyersCode>
														<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
													</BuyersCode>
												</SuppliersLocationID>
											</Supplier>
											<ShipTo>
												<ShipToLocationID>
													<BuyersCode>
														<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
													</BuyersCode>
												</ShipToLocationID>
											</ShipTo>
											<InvoiceReferences>
												<InvoiceReference>
													<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
												</InvoiceReference>
												<InvoiceDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
													</xsl:call-template>
												</InvoiceDate>
												<TaxPointDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
													</xsl:call-template>
												</TaxPointDate>
											</InvoiceReferences>
											<CreditNoteReferences>
												<CreditNoteReference>
													<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
												</CreditNoteReference>
												<CreditNoteDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
													</xsl:call-template>
												</CreditNoteDate>
												<TaxPointDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
													</xsl:call-template>
												</TaxPointDate>
											</CreditNoteReferences>
											<HeaderExtraData>
												<VoucherID>
													<xsl:value-of select="*/Buyer/BuyersAddress/AddressLine1"/>
												</VoucherID>
												<InvoiceType>
													<xsl:value-of select="*/Buyer/BuyersAddress/AddressLine2"/>
												</InvoiceType>
											</HeaderExtraData>
										</CreditNoteHeader>
										<CreditNoteDetail>
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
												<CreditNoteLine>
													<xsl:if test="string(../*[1]/PurchaseOrderReferences/PurchaseOrderReference) != '' and string(../*[1]/PurchaseOrderReferences/PurchaseOrderDate) != ''">
														<PurchaseOrderReferences>
															<PurchaseOrderReference>
																<xsl:value-of select="../*[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
															</PurchaseOrderReference>
															<PurchaseOrderDate>
																<xsl:call-template name="utcDate">
																	<xsl:with-param name="input" select="../*[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
																</xsl:call-template>
															</PurchaseOrderDate>
														</PurchaseOrderReferences>
													</xsl:if>
													<DeliveryNoteReferences>
														<DeliveryNoteReference>
															<xsl:value-of select="../*[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
														</DeliveryNoteReference>
														<DeliveryNoteDate>
															<xsl:call-template name="utcDate">
																<xsl:with-param name="input" select="../*[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
															</xsl:call-template>
														</DeliveryNoteDate>
													</DeliveryNoteReferences>
													<ProductID>
														<SuppliersProductCode>
															<xsl:value-of select="ProductID/SuppliersProductCode"/>
														</SuppliersProductCode>
													</ProductID>
													<CreditedQuantity>
														<xsl:choose>
															<xsl:when test="substring(InvoicedQuantity,1,1) = '+'">
																<xsl:value-of select="(format-number(concat(substring(InvoicedQuantity,2,11),'.',substring(InvoicedQuantity,13,4)),'0.0000')) * -1"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="format-number(concat(substring(InvoicedQuantity,2,11),'.',substring(InvoicedQuantity,13,4)),'0.0000')"/>
															</xsl:otherwise>
														</xsl:choose>
													</CreditedQuantity>
													<UnitValueExclVAT>
														<xsl:value-of select="format-number(format-number(concat(substring(LineValueExclVAT,2,13),'.',substring(LineValueExclVAT,15,2)),'0.00') div format-number	(concat(substring(InvoicedQuantity,2,11),'.',substring(InvoicedQuantity,13,4)),'0.0000'),'0.00')"/>
													</UnitValueExclVAT>
													<LineValueExclVAT>
														<xsl:choose>
															<!-- 2012 02 21 - this test used to check that the first character was '+' but now we are changing the plus sign to '0' in the LineValueExclVAT field -->
															<xsl:when test="substring(LineValueExclVAT,1,1) = '0'">
																<xsl:value-of select="(format-number(concat(substring(LineValueExclVAT,2,13),'.',substring(LineValueExclVAT,15,2)),'0.00')) * -1"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="format-number(concat(substring(LineValueExclVAT,2,13),'.',substring(LineValueExclVAT,15,2)),'0.00')"/>
															</xsl:otherwise>
														</xsl:choose>
													</LineValueExclVAT>
													<VATCode>Z</VATCode>
													<VATRate>0.00</VATRate>
												</CreditNoteLine>
											</xsl:for-each>
										</CreditNoteDetail>
									</CreditNote>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			</xsl:for-each>
		</BatchRoot>
	</xsl:template>
	<xsl:template name="utcDate">
		<xsl:param name="input"/>
		<xsl:value-of select="concat(substring($input,1,4),'-',substring($input,5,2),'-',substring($input,7,2))"/>
	</xsl:template>
</xsl:stylesheet>
