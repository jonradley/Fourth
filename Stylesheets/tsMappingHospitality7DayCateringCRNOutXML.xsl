<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************************************************************************************************
Name			| Date 			|	Description
******************************************************************************************************************************************************************************
M Emanuel	| 29/01/2013	| FB Case 5946 Created New Credit note out mapper
============================================================================================================
M Dimant		| 30/04/2015	| FB Case: 10248 - Map UnitCode and CustomerLocationCode when one is present
******************************************************************************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                              xmlns:user="http://mycompany.com/mynamespace" 
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                              exclude-result-prefixes="#default xsl msxsl user">

	<xsl:output method="xml" encoding="utf-8"/>
	
	<xsl:template match="/CreditNote">
	
		<xsl:element name="FDHCreditNotes">
			<xsl:element name="SupplierCode">
				<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
			</xsl:element>
			<xsl:element name="CreditNote">
				<xsl:element name="CustomerCode">
					<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
				</xsl:element>
				<xsl:element name="UnitCode">
					<xsl:choose>
						<xsl:when test="CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode != 'Not provided'">
							<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
						</xsl:otherwise>
					</xsl:choose>		
				</xsl:element>
				<xsl:element name="CustomersLocationCode">
					<xsl:choose>
						<xsl:when test="CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode != 'Not provided'">
							<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
						</xsl:otherwise>
					</xsl:choose>		
				</xsl:element>
				<xsl:element name="SuppliersLocationCode">
					<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
				</xsl:element>
				<xsl:element name="DeliveryLocationEANCode">
					<xsl:text>0000000000000</xsl:text>
				</xsl:element>
				<xsl:element name="LocationName">
					<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToName"/>
				</xsl:element>
				<xsl:element name="LocationAddress1">
					<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
				</xsl:element>
				<xsl:element name="LocationAddress2">
					<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
				</xsl:element>
				<xsl:element name="LocationAddress3">
					<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
				</xsl:element>
				<xsl:element name="LocationAddress4">
					<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4"/>
				</xsl:element>
				<xsl:element name="LocationPostalCode">
					<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/PostCode"/>
				</xsl:element>
				<xsl:element name="CreditNoteNumber">
					<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				</xsl:element>
				<xsl:variable name="Crndate" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
				<xsl:element name="CreditNoteDate">
					<xsl:value-of select="concat(substring($Crndate,1,4),substring($Crndate,6,2),substring($Crndate,9,2))"/>
				</xsl:element>
				<xsl:element name="CreditNoteCurrency">
					<xsl:value-of select="CreditNoteHeader/Currency"/>
				</xsl:element>
				<xsl:element name="ReferenceDocumentNumber">
					<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
				</xsl:element>
				<xsl:element name="ReferenceDocumentDate">
					<xsl:variable name="InvDate" select="CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
					<xsl:value-of select="concat(substring($InvDate,1,4),substring($InvDate,6,2),substring($InvDate,9,2))"/>
				</xsl:element>			
				<xsl:element name="PaymentDays">
					<xsl:text>00</xsl:text>
				</xsl:element>
				<xsl:element name="OrderList">
					<xsl:element name="Order">
						<xsl:element name="CustomersOrderNumber">
							<xsl:choose>
								<xsl:when test="CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference !=''">
									<xsl:value-of select="CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference"/>
								</xsl:when>
								<xsl:otherwise><xsl:text>Not Provided</xsl:text></xsl:otherwise>
							</xsl:choose>								
						</xsl:element>
						<xsl:variable name="OrdDate" select="CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderDate"/>
						<xsl:element name="CustomersOrderDate">
							<xsl:value-of select="concat(substring($OrdDate,1,4),substring($OrdDate,6,2),substring($OrdDate,9,2))"/>
						</xsl:element>
						<xsl:element name="SuppliersOrderNumber">
							<xsl:value-of select="CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference"/>
						</xsl:element>
						<xsl:variable name="PoDate" select="CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderDate"/>
						<xsl:element name="DateOrderReceivedBySupplier">
							<xsl:value-of select="concat(substring($PoDate,1,4),substring($PoDate,6,2),substring($PoDate,9,2))"/>
						</xsl:element>
						<xsl:element name="LineList">
							<xsl:for-each select="CreditNoteDetail/CreditNoteLine">
								<xsl:element name="Line">
									<xsl:element name="ItemEANCode">
										<!-- Restrict to first 13 characters -->
										<xsl:value-of select="substring(ProductID/GTIN,1,13)"/>
									</xsl:element>
									<xsl:element name="SuppliersProductCode">
										<xsl:value-of select="ProductID/SuppliersProductCode"/>
									</xsl:element>
									<xsl:element name="Quantity">
										<xsl:value-of select="CreditedQuantity"/>
									</xsl:element>
									<xsl:element name="UnitPrice">
										<xsl:value-of select="UnitValueExclVAT"/>
									</xsl:element>
									<xsl:element name="LinePrice">
										<xsl:value-of select="LineValueExclVAT"/>
									</xsl:element>
									<xsl:element name="VATCode">
										<xsl:value-of select="VATCode"/>
									</xsl:element>
									<xsl:element name="ProductDescription">
										<xsl:value-of select="ProductDescription"/>
									</xsl:element>									
									<xsl:element name="LineDiscountAmount">
										<xsl:choose>
											<xsl:when test="LineDiscountValue"><xsl:value-of select="LineDiscountValue"/></xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>																					
									</xsl:element>
									<xsl:element name="AgreementCode">
										<xsl:choose>
											<xsl:when test="PurchaseOrderReferences/TradeAgreement/ContractReference !=''">
												<xsl:value-of select="PurchaseOrderReferences/TradeAgreement/ContractReference"/>
											</xsl:when>
											<xsl:otherwise><xsl:text>*ALL</xsl:text></xsl:otherwise>
										</xsl:choose>										
									</xsl:element>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="TaxSummary">
					<xsl:element name="Tax">
						<xsl:element name="VATCode">
							<xsl:value-of select="CreditNoteTrailer/VATSubTotals/VATSubTotal/@VATCode"/>
						</xsl:element>
						<xsl:element name="VATPercentage">
							<xsl:value-of select="CreditNoteTrailer/VATSubTotals/VATSubTotal/@VATRate"/>
						</xsl:element>
						<xsl:element name="NumberOfLineItems">
							<xsl:value-of select="CreditNoteTrailer/VATSubTotals/VATSubTotal/NumberOfLinesAtRate"/>
						</xsl:element>
						<xsl:element name="AmountSubjectToVAT">
							<xsl:value-of select="CreditNoteTrailer/VATSubTotals/VATSubTotal/DocumentTotalExclVATAtRate"/>
						</xsl:element>
						<xsl:element name="VATAmount">
							<xsl:value-of select="CreditNoteTrailer/VATSubTotals/VATSubTotal/VATAmountAtRate"/>
						</xsl:element>
						<xsl:element name="PayableAmount">
							<xsl:value-of select="CreditNoteTrailer/VATSubTotals/VATSubTotal/DocumentTotalInclVATAtRate"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="CreditNoteSummary">
					<xsl:element name="TotalCreditNoteAmount">
						<xsl:value-of select="CreditNoteTrailer/DocumentTotalExclVAT"/>
					</xsl:element>
					<xsl:element name="TotalVAT">
						<xsl:value-of select="CreditNoteTrailer/VATAmount"/>
					</xsl:element>
					<xsl:element name="TotalPayable">
						<xsl:value-of select="CreditNoteTrailer/DocumentTotalInclVAT"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
