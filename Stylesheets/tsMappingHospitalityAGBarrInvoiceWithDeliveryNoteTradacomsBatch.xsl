<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************
Alterations
**********************************************************************
Name				| Date				| Change
**********************************************************************
Moty Dimant 	| 15/01/2009 		| Created
**********************************************************************
R Cambridge 	| 07/09/2009 		| Use DN ref as PO ref when no PO ref provided
**********************************************************************
            	|            		|        
**********************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
<xsl:output method="xml" encoding="UTF-8"/>
<!-- Start point - ensure required outer BatchRoot tag is applied -->
<xsl:template match="/">
	<BatchRoot>
		<Document>
            <xsl:attribute name="TypePrefix">INV</xsl:attribute>
			<Batch>
				<BatchDocuments>
					<xsl:for-each select="Batch/BatchDocuments/BatchDocument/Invoice">
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo">86</xsl:attribute>
							<!--xsl:copy-of select="."/-->
							<Invoice>
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
									</SendersCodeForRecipient>
									<xsl:if test="TradeSimpleHeader/SendersBranchReference != ''">
										<SendersBranchReference>
											<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
										</SendersBranchReference>
									</xsl:if>
									<xsl:if test="TradeSimpleHeader/TestFlag != ''">
										<TestFlag>
											<xsl:choose>
												<xsl:when test="TradeSimpleHeader/TestFlag = 'Y'">true</xsl:when>
												<xsl:when test="TradeSimpleHeader/TestFlag = 'y'">true</xsl:when>
												<xsl:when test="TradeSimpleHeader/TestFlag = '1'">true</xsl:when>
												<xsl:when test="TradeSimpleHeader/TestFlag = 'True'">true</xsl:when>
												<xsl:when test="TradeSimpleHeader/TestFlag = 'TRUE'">true</xsl:when>
												<xsl:otherwise>false</xsl:otherwise>
											</xsl:choose>
										</TestFlag>
									</xsl:if>
								</TradeSimpleHeader>
								<InvoiceHeader>
									<xsl:if test="InvoiceHeader/BatchInformation">
										<BatchInformation>
											<xsl:if test="InvoiceHeader/BatchInformation/FileGenerationNo != ''">
												<FileGenerationNo>
													<xsl:value-of select="InvoiceHeader/BatchInformation/FileGenerationNo"/>
												</FileGenerationNo>
											</xsl:if>
											<xsl:if test="InvoiceHeader/BatchInformation/FileVersionNo != ''">
												<FileVersionNo>
													<xsl:value-of select="InvoiceHeader/BatchInformation/FileVersionNo"/>
												</FileVersionNo>
											</xsl:if>
											<xsl:if test="InvoiceHeader/BatchInformation/FileCreationDate != ''">
												<xsl:variable name="sFileDate">
													<xsl:value-of select="InvoiceHeader/BatchInformation/FileCreationDate"/>
												</xsl:variable>
												<FileCreationDate>
													<xsl:value-of select="concat('20',substring($sFileDate,1,2),'-',substring($sFileDate,3,2),'-',substring($sFileDate,5,2))"/>
												</FileCreationDate>
											</xsl:if>
											<xsl:if test="InvoiceHeader/BatchInformation/SendersTransmissionReference != ''">
												<SendersTransmissionReference>
													<xsl:value-of select="InvoiceHeader/BatchInformation/SendersTransmissionReference"/>
												</SendersTransmissionReference>
											</xsl:if>
											<xsl:if test="InvoiceHeader/BatchInformation/SendersTransmissionDate != ''">
												<xsl:variable name="sSendersTransDate">
													<xsl:value-of select="InvoiceHeader/BatchInformation/SendersTransmissionDate"/>
												</xsl:variable>
												<SendersTransmissionDate>
													<xsl:value-of select="concat('20',substring($sSendersTransDate,1,2),'-',substring($sSendersTransDate,3,2),'-',substring($sSendersTransDate,5,2),'T00:00:00')"/>
												</SendersTransmissionDate>
											</xsl:if>
										</BatchInformation>
									</xsl:if>
									<xsl:copy-of select="InvoiceHeader/Buyer"/>
									<xsl:copy-of select="InvoiceHeader/Supplier"/>
									<xsl:copy-of select="InvoiceHeader/ShipTo"/>
									<InvoiceReferences>
										<InvoiceReference>
											<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
										</InvoiceReference>
										<xsl:variable name="sInvDate">
											<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
										</xsl:variable>
										<InvoiceDate>
											<xsl:value-of select="concat('20',substring($sInvDate,1,2),'-',substring($sInvDate,3,2),'-',substring($sInvDate,5,2))"/>
										</InvoiceDate>
										<xsl:variable name="sTaxDate">
											<xsl:choose>
												<xsl:when test="InvoiceHeader/InvoiceReferences/TaxPointDate != ''">
													<xsl:value-of select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<TaxPointDate>
											<xsl:value-of select="concat('20',substring($sTaxDate,1,2),'-',substring($sTaxDate,3,2),'-',substring($sTaxDate,5,2))"/>
										</TaxPointDate>
										<VATRegNo>
											<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/>
										</VATRegNo>
									</InvoiceReferences>
									<xsl:if test="InvoiceHeader/Currency !=''">
										<Currency>
											<xsl:value-of select="InvoiceHeader/Currency"/>
										</Currency>
									</xsl:if>
								</InvoiceHeader>
								<InvoiceDetail>
									<xsl:for-each select="InvoiceDetail/InvoiceLine">
										<InvoiceLine>
											
											<PurchaseOrderReferences>
												<PurchaseOrderReference>
													<xsl:value-of select="(PurchaseOrderReferences/PurchaseOrderReference | DeliveryNoteReferences/DeliveryNoteReference)[1]"/>
												</PurchaseOrderReference>
												<xsl:variable name="sPODate">
													<xsl:value-of select="(PurchaseOrderReferences/PurchaseOrderDate | DeliveryNoteReferences/DeliveryNoteDate)[1]"/>
												</xsl:variable>
												<PurchaseOrderDate>
													<xsl:value-of select="concat('20',substring($sPODate,1,2),'-',substring($sPODate,3,2),'-',substring($sPODate,5,2))"/>
												</PurchaseOrderDate>
											</PurchaseOrderReferences>
											
											<DeliveryNoteReferences>
												<DeliveryNoteReference>
													<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
												</DeliveryNoteReference>
												<xsl:variable name="sDelNoteDate">
													<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
												</xsl:variable>
												<DeliveryNoteDate>
													<xsl:value-of select="concat('20',substring($sDelNoteDate,1,2),'-',substring($sDelNoteDate,3,2),'-',substring($sDelNoteDate,5,2))"/>
												</DeliveryNoteDate>
											</DeliveryNoteReferences>
											<ProductID>
												<SuppliersProductCode>
													<xsl:value-of select="ProductID/SuppliersProductCode"/>
												</SuppliersProductCode>
											</ProductID>
											<xsl:copy-of select="ProductDescription"/>
											<InvoicedQuantity>
												<xsl:value-of select="InvoicedQuantity"/>
											</InvoicedQuantity>
											<xsl:if test="PackSize != ''">
												<PackSize>
													<xsl:value-of select="PackSize"/>
												</PackSize>
											</xsl:if>
											<UnitValueExclVAT>
												<xsl:value-of select="format-number((UnitValueExclVAT) div 10000.0,'0.00#')"/>   
											</UnitValueExclVAT>
											<xsl:if test="LineValueExclVAT != ''">
												<LineValueExclVAT>
													<xsl:value-of select="format-number((LineValueExclVAT) div 10000.0,'0.00#')"/>
												</LineValueExclVAT>
											</xsl:if>
											<VATCode>
												<xsl:value-of select="VATCode"/>
											</VATCode>
											<VATRate>
												<xsl:value-of select="format-number((VATRate) div 1000.0, '0.00#')"/>
											</VATRate>
										</InvoiceLine>
									</xsl:for-each>
								</InvoiceDetail>
								<InvoiceTrailer>
									<xsl:if test="InvoiceTrailer/NumberOfLines != ''">
										<NumberOfLines>
											<xsl:value-of select="InvoiceTrailer/NumberOfLines"/>
										</NumberOfLines>
									</xsl:if>
									<xsl:if test="InvoiceTrailer/NumberOfItems">
										<NumberOfItems>
											<xsl:value-of select="InvoiceTrailer/NumberOfItems"/>
										</NumberOfItems>
									</xsl:if>
									<xsl:if test="InvoiceTrailer/NumberOfDeliveries">
										<NumberOfDeliveries>
											<xsl:value-of select="InvoiceTrailer/NumberOfDeliveries"/>
										</NumberOfDeliveries>
									</xsl:if>
									<VATSubTotals>
										<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
											<VATSubTotal>
												<xsl:attribute name="VATCode"><xsl:value-of select="./@VATCode"/></xsl:attribute>
												<xsl:attribute name="VATRate"><xsl:value-of select="format-number((./@VATRate) div 1000.0, '0.00#')"/></xsl:attribute>
												<xsl:if test="NumberOfLinesAtRate != ''">
													<NumberOfLinesAtRate>
														<xsl:value-of select="NumberOfLinesAtRate"/>
													</NumberOfLinesAtRate>
												</xsl:if>
												<xsl:if test="NumberOfItemsAtRate != ''">
													<NumberOfItemsAtRate>
														<xsl:value-of select="NumberOfItemsAtRate"/>
													</NumberOfItemsAtRate>
												</xsl:if>
												<xsl:if test="DocumentTotalExclVATAtRate != ''">
													<DocumentTotalExclVATAtRate>
														<xsl:value-of select="format-number((DocumentTotalExclVATAtRate) div 100.0, '0.00#')"/>
													</DocumentTotalExclVATAtRate>
												</xsl:if>
												<xsl:if test="SettlementDiscountAtRate != ''">
													<SettlementDiscountAtRate>
														<xsl:value-of select="format-number((SettlementDiscountAtRate ) div 100.0, '0.00#')"/>
													</SettlementDiscountAtRate>
												</xsl:if>
												<xsl:if test="SettlementTotalExclVATAtRate != ''">
													<SettlementTotalExclVATAtRate>
														<xsl:value-of select="format-number((SettlementTotalExclVATAtRate) div 100.0, '0.00#')"/>
													</SettlementTotalExclVATAtRate>
												</xsl:if>
												<xsl:if test="VATAmountAtRate != ''">
													<VATAmountAtRate>
														<xsl:value-of select="format-number((VATAmountAtRate) div 100.0, '0.00#')"/>
													</VATAmountAtRate>
												</xsl:if>
												<xsl:if test="DocumentTotalInclVATAtRate != ''">
													<DocumentTotalInclVATAtRate>
														<xsl:value-of select="format-number((DocumentTotalInclVATAtRate) div 100.0, '0.00#')"/>
													</DocumentTotalInclVATAtRate>
												</xsl:if>
												<xsl:if test="SettlementTotalInclVATAtRate">
													<SettlementTotalInclVATAtRate>
														<xsl:value-of select="format-number((SettlementTotalInclVATAtRate) div 100.0, '0.00#')"/>
													</SettlementTotalInclVATAtRate>
												</xsl:if>
											</VATSubTotal>
										</xsl:for-each>
									</VATSubTotals>
									<xsl:variable name="sDTEV">
										<xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/>
									</xsl:variable>
									<xsl:if test="InvoiceTrailer/DocumentTotalExclVAT != ''">
										<DocumentTotalExclVAT>
											<xsl:value-of select="format-number(($sDTEV) div 100.0, '0.00#')"/>
										</DocumentTotalExclVAT>
									</xsl:if>
									<xsl:variable name="sSettDisc">
										<xsl:value-of select="InvoiceTrailer/SettlementDiscount"/>
									</xsl:variable>
									<xsl:if test="InvoiceTrailer/SettlementDiscount != ''">
										<SettlementDiscount>
											<xsl:value-of select="format-number(($sSettDisc) div 100.0, '0.00#')"/>
										</SettlementDiscount>
									</xsl:if>
									<xsl:variable name="sSTEV">
										<xsl:value-of select="InvoiceTrailer/SettlementTotalExclVAT"/>
									</xsl:variable>
									<xsl:if test="InvoiceTrailer/SettlementTotalExclVAT != ''">
										<SettlementTotalExclVAT>
											<xsl:value-of select="format-number(($sSTEV) div 100.0, '0.00#')"/>
										</SettlementTotalExclVAT>
									</xsl:if>
										<xsl:variable name="sVATAm">
										<xsl:value-of select="InvoiceTrailer/VATAmount"/>
									</xsl:variable>
									<xsl:if test="InvoiceTrailer/VATAmount != ''">
										<VATAmount>
											<xsl:value-of select="format-number(($sVATAm) div 100.0, '0.00#')"/>
										</VATAmount>
									</xsl:if>
									<xsl:variable name="sDTIV">
										<xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
									</xsl:variable>
									<xsl:if test="InvoiceTrailer/DocumentTotalInclVAT != ''">
										<DocumentTotalInclVAT>
											<xsl:value-of select="format-number(($sDTIV) div 100.0, '0.00#')"/>
										</DocumentTotalInclVAT>
									</xsl:if>
								</InvoiceTrailer>
							</Invoice>
						</BatchDocument>
				   	</xsl:for-each>
				</BatchDocuments>
			</Batch>
		</Document>

											
		<!--DELIVERY NOTES-->
		<Document>
            <xsl:attribute name="TypePrefix">DNB</xsl:attribute>
			<Batch>
				<BatchDocuments>
					<xsl:for-each select="Batch/BatchDocuments/BatchDocument/Invoice">
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
							<DeliveryNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
									</SendersCodeForRecipient>
									<xsl:if test="TradeSimpleHeader/SendersBranchReference != ''">
										<SendersBranchReference>
											<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
										</SendersBranchReference>
									</xsl:if>
									<TestFlag>
										<xsl:choose>
											<xsl:when test="string(TradeSimpleHeader/TestFlag) = 'N'">
												<xsl:value-of select="'0'"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'1'"/>
											</xsl:otherwise>
										</xsl:choose>
									</TestFlag>
								</TradeSimpleHeader>
								<DeliveryNoteHeader>
									<DocumentStatus>Original</DocumentStatus>
									<xsl:copy-of select="InvoiceHeader/Buyer"/>
									<xsl:copy-of select="InvoiceHeader/Supplier"/>
									<xsl:copy-of select="InvoiceHeader/ShipTo"/>
									
									<PurchaseOrderReferences>									
										<PurchaseOrderReference>
											<xsl:value-of select="(InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference | InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference)[1]"/>
										</PurchaseOrderReference>
										<xsl:variable name="sDPODate">
											<xsl:value-of select="(InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate | InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate)[1]"/>
										</xsl:variable>
										<PurchaseOrderDate>
											<xsl:value-of select="concat('20',substring($sDPODate,1,2),'-',substring($sDPODate,3,2),'-',substring($sDPODate,5,2))"/>
										</PurchaseOrderDate>
									</PurchaseOrderReferences>

									
									<DeliveryNoteReferences>
										<DeliveryNoteReference>
											<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
										</DeliveryNoteReference>
										<xsl:variable name="dDDelNoteDate">
											<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
										</xsl:variable>
										<DeliveryNoteDate>
											<xsl:value-of select="concat('20',substring($dDDelNoteDate,1,2),'-',substring($dDDelNoteDate,3,2),'-',substring($dDDelNoteDate,5,2))"/>
										</DeliveryNoteDate>
									</DeliveryNoteReferences>
								</DeliveryNoteHeader>
								<DeliveryNoteDetail>
									<xsl:for-each select="InvoiceDetail/InvoiceLine">
										<DeliveryNoteLine>
											<LineNumber>
												<xsl:value-of select="count(preceding-sibling::*) + 1"/>
											</LineNumber>
											<xsl:copy-of select="ProductID"/>
											<xsl:copy-of select="ProductDescription"/>
											<DespatchedQuantity>
												<xsl:value-of select="InvoicedQuantity"/>
											</DespatchedQuantity>
											<xsl:copy-of select="PackSize"/>
										</DeliveryNoteLine>
									</xsl:for-each>
								</DeliveryNoteDetail>
								<xsl:if test="InvoiceTrailer/NumberOfLines != ''">
									<DeliveryNoteTrailer>
										<xsl:copy-of select="InvoiceTrailer/NumberOfLines"/>
									</DeliveryNoteTrailer>
								</xsl:if>
							</DeliveryNote>
						</BatchDocument>
					</xsl:for-each>
				</BatchDocuments>
			</Batch>
		</Document>
	</BatchRoot>
</xsl:template>
	
	<xsl:template name="msFormatDate">
		<xsl:param name="vsYYMMDD"/>
			<xsl:value-of select="concat('20',substring($vsYYMMDD,1,2),'-',substring($vsYYMMDD,3,2),'-',substring($vsYYMMDD,5,2))"/>
		</xsl:template>

	<!--END of DATE CONVERSIONS -->
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 
		Dim lLineNumber
		
		Function resetLineNumber()
			lLineNumber = 1
			resetLineNumber = 1
		End Function
		
		Function getLineNumber()
			getLineNumber = lLineNumber
			lLineNumber = lLineNumber + 1
		End Function
]]></msxsl:script>
</xsl:stylesheet>
