<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
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
				<!--xsl:if test="InvoiceHeader/BatchInformation">
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
								<xsl:value-of select="concat(substring($sFileDate,1,4),'-',substring($sFileDate,5,2),'-',substring($sFileDate,7,2))"/>
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
								<xsl:value-of select="concat(substring($sSendersTransDate,1,4),'-',substring($sSendersTransDate,5,2),'-',substring($sSendersTransDate,7,2))"/>
							</SendersTransmissionDate>
						</xsl:if>

					</BatchInformation>
				</xsl:if-->
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
						<xsl:value-of select="concat(substring($sInvDate,1,4),'-',substring($sInvDate,5,2),'-',substring($sInvDate,7,2))"/>
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
						<xsl:value-of select="concat(substring($sTaxDate,1,4),'-',substring($sTaxDate,5,2),'-',substring($sTaxDate,7,2))"/>
					</TaxPointDate>
					<VATRegNo>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/>
					</VATRegNo>
				</InvoiceReferences>
				<Currency>
					<xsl:value-of select="InvoiceHeader/Currency"/>
				</Currency>
			</InvoiceHeader>
			<InvoiceDetail>
				<xsl:for-each select="InvoiceDetail/InvoiceLine">
					<InvoiceLine>
						<xsl:if test="PurchaseOrderReferences/PurchaseOrderReference != '' and PurchaseOrderReferences/PurchaseOrderDate != ''">
							<PurchaseOrderReferences>
								<PurchaseOrderReference>
									<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
								</PurchaseOrderReference>
								<xsl:variable name="sPODate">
									<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
								</xsl:variable>
								<PurchaseOrderDate>
									<xsl:value-of select="concat(substring($sPODate,1,4),'-',substring($sPODate,5,2),'-',substring($sPODate,7,2))"/>
								</PurchaseOrderDate>
							</PurchaseOrderReferences>
						</xsl:if>
						<DeliveryNoteReferences>
							<DeliveryNoteReference>
								<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
							</DeliveryNoteReference>
							<xsl:variable name="sDelNoteDate">
								<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
							</xsl:variable>
							<DeliveryNoteDate>
								<xsl:value-of select="concat(substring($sDelNoteDate,1,4),'-',substring($sDelNoteDate,5,2),'-',substring($sDelNoteDate,7,2))"/>
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
							<xsl:value-of select="UnitValueExclVAT"/>
						</UnitValueExclVAT>
						<xsl:if test="LineValueExclVAT != ''">
							<LineValueExclVAT>
								<xsl:value-of select="LineValueExclVAT"/>
							</LineValueExclVAT>
						</xsl:if>
						<VATCode>
							<xsl:value-of select="VATCode"/>
						</VATCode>
						<VATRate>
							<xsl:value-of select="VATRate"/>
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
							<xsl:attribute name="VATCode">
								<xsl:value-of select="./@VATCode"/>
							</xsl:attribute>
							<xsl:attribute name="VATRate">
								<xsl:value-of select="./@VATRate"/>
							</xsl:attribute>
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
									<xsl:value-of select="DocumentTotalExclVATAtRate"/>
								</DocumentTotalExclVATAtRate>
							</xsl:if>
							<xsl:if test="SettlementDiscountAtRate != ''">
								<SettlementDiscountAtRate>
									<xsl:value-of select="SettlementDiscountAtRate"/>
								</SettlementDiscountAtRate>
							</xsl:if>
							<xsl:if test="SettlementTotalExclVATAtRate != ''">
								<SettlementTotalExclVATAtRate>
									<xsl:value-of select="SettlementTotalExclVATAtRate"/>
								</SettlementTotalExclVATAtRate>
							</xsl:if>
							<xsl:if test="VATAmountAtRate != ''">
								<VATAmountAtRate>
									<xsl:value-of select="VATAmountAtRate"/>
								</VATAmountAtRate>
							</xsl:if>
							<xsl:if test="DocumentTotalInclVATAtRate != ''">
								<DocumentTotalInclVATAtRate>
									<xsl:value-of select="DocumentTotalInclVATAtRate"/>
								</DocumentTotalInclVATAtRate>
							</xsl:if>
							<xsl:if test="SettlementTotalInclVATAtRate">
								<SettlementTotalInclVATAtRate>
									<xsl:value-of select="SettlementTotalInclVATAtRate"/>
								</SettlementTotalInclVATAtRate>
							</xsl:if>
						</VATSubTotal>
					</xsl:for-each>
				</VATSubTotals>
				<xsl:if test="InvoiceTrailer/DocumentTotalExclVAT != ''">
					<DocumentTotalExclVAT>
						<xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/>
					</DocumentTotalExclVAT>
				</xsl:if>
				<xsl:if test="InvoiceTrailer/SettlementDiscount != ''">
					<SettlementDiscount>
						<xsl:value-of select="InvoiceTrailer/SettlementDiscount"/>
					</SettlementDiscount>
				</xsl:if>
				<xsl:if test="InvoiceTrailer/SettlementTotalExclVAT != ''">
					<SettlementTotalExclVAT>
						<xsl:value-of select="InvoiceTrailer/SettlementTotalExclVAT"/>
					</SettlementTotalExclVAT>
				</xsl:if>
				<xsl:if test="InvoiceTrailer/VATAmount != ''">
					<VATAmount>
						<xsl:value-of select="InvoiceTrailer/VATAmount"/>
					</VATAmount>
				</xsl:if>
				<xsl:if test="InvoiceTrailer/DocumentTotalInclVAT != ''">
					<DocumentTotalInclVAT>
						<xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
					</DocumentTotalInclVAT>
				</xsl:if>
			</InvoiceTrailer>
		</Invoice>
	</xsl:template>
	
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
