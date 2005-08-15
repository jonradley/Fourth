<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to pre-map an Elior Invoice before it is run through
 the outbound batch processor (tsProcessorEliorBatch)

The CompanyPLCode, CostCentreCode, and FinancialPeriod fields
have been pulled out into a root <TransactionEntry> element as
they are the key to each output file produced by the batch mapper.
Only the <Transaction> element and its children will actually appear in
the final file produced by the batch mapper.

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name        | Description of modification
******************************************************************************************
 26/09/2004 | Lee Boyton  | Created module.
******************************************************************************************
 21/12/2004 | Lee Boyton  | H290. Added missing PONumber and Description elements.
******************************************************************************************
 04/01/2005 | Lee Boyton  | H297. Output summary elements even if zero.
******************************************************************************************
 15/08/2005 | Lee Boyton  | H487. ELI011. Remove trailing /n from PL Account Code if present.
******************************************************************************************
            |             |
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
<xsl:output method="xml"/>

<xsl:template match="/Invoice">
<TransactionEntry>
	<!-- CompanyPLCode, CostCentreCode, and FinancialPeriod are required as they are the key to each output file produced by the batch mapper -->
	<CompanyPLCode>
		<xsl:value-of select="DistributionsHeader/CompanyPLCode"/>
	</CompanyPLCode>
	<CostCentreCode>
		<xsl:value-of select="DistributionsHeader/CostCentreCode"/>
	</CostCentreCode>
	<FinancialPeriod>
		<xsl:value-of select="InvoiceHeader/HeaderExtraData/FinancialPeriod"/>
	</FinancialPeriod>
	<!-- company code is stored in the CompanyID attribute of the PURCH type distributions (of which there will always be at least one -->
	<CompanyCode>
		<xsl:value-of select="DistributionsDetail/DistributionsLine[DistributionType = 'Purchases'][1]/CompanyCode"/>
	</CompanyCode>
	<Transaction DocumentType="Invoice">
		<xsl:attribute name="SupplierID">
			<!-- Supplier ID is the root of the PL Account code (bit before the / if present) -->
			<xsl:choose>
				<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'/')">
					<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="DocumentDate">
			<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
		</xsl:attribute>
		<xsl:attribute name="DocumentNumber">
			<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		</xsl:attribute>
		<xsl:attribute name="PONumber"/>
		<!-- VoucherNumber will be filled in by the batch mapper and is an incrementing sequence stored in the database -->
		<xsl:attribute name="VoucherNumber">
			<xsl:value-of select="0"/>
		</xsl:attribute>
		<xsl:attribute name="InterCompany">
			<xsl:value-of select="DistributionsHeader/InterCompanyFlag"/>
		</xsl:attribute>
		<xsl:element name="Description"/>
		<xsl:apply-templates select="DistributionsDetail"/>
		<xsl:call-template name="DistributionTrailerTemplate">
			<xsl:with-param name="Currency" select="InvoiceHeader/Currency"/>
		</xsl:call-template>
	</Transaction>
</TransactionEntry>
</xsl:template>

<xsl:template match="/CreditNote">
<TransactionEntry>
	<!-- CompanyPLCode, CostCentreCode, and FinancialPeriod are required as they are the key to each output file produced by the batch mapper -->
	<CompanyPLCode>
		<xsl:value-of select="DistributionsHeader/CompanyPLCode"/>	
	</CompanyPLCode>
	<CostCentreCode>
		<xsl:value-of select="DistributionsHeader/CostCentreCode"/>
	</CostCentreCode>
	<FinancialPeriod>
		<xsl:value-of select="CreditNoteHeader/HeaderExtraData/FinancialPeriod"/>
	</FinancialPeriod>
	<!-- company code is stored in the CompanyID attribute of the PURCH type distributions (of which there will always be at least one -->
	<CompanyCode>
		<xsl:value-of select="DistributionsDetail/DistributionsLine[DistributionType = 'Purchases'][1]/CompanyCode"/>
	</CompanyCode>
	<Transaction DocumentType="CreditMemo">
		<xsl:attribute name="SupplierID">
			<!-- Supplier ID is the root of the PL Account code (bit before the / if present) -->
			<xsl:choose>
				<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'/')">
					<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="DocumentDate">
			<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
		</xsl:attribute>
		<xsl:attribute name="DocumentNumber">
			<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		</xsl:attribute>
		<xsl:attribute name="PONumber"/>
		<!-- VoucherNumber will be filled in by the batch mapper and is an incrementing sequence stored in the database -->
		<xsl:attribute name="VoucherNumber">
			<xsl:value-of select="0"/>
		</xsl:attribute>
		<xsl:attribute name="InterCompany">
			<xsl:value-of select="DistributionsHeader/InterCompanyFlag"/>
		</xsl:attribute>
		<xsl:element name="Description"/>
		<xsl:apply-templates select="DistributionsDetail"/>
		<xsl:call-template name="DistributionTrailerTemplate">
			<xsl:with-param name="Currency" select="CreditNoteHeader/Currency"/>
		</xsl:call-template>
	</Transaction>
</TransactionEntry>
</xsl:template>

<xsl:template match="DistributionsDetail">
	<Distributions>
		<xsl:for-each select="DistributionsLine">
			<Distribution>
				<xsl:attribute name="Type">
					<xsl:choose>
						<xsl:when test="DistributionType = 'FinancialCharge'">FNCHG</xsl:when>
						<xsl:when test="DistributionType = 'Other'">OTHER</xsl:when>						
						<xsl:when test="DistributionType = 'Pay'">PAY</xsl:when>						
						<xsl:when test="DistributionType = 'Purchases'">PURCH</xsl:when>
						<xsl:when test="DistributionType = 'Taxes'">TAXES</xsl:when>
						<xsl:when test="DistributionType = 'Trade'">TRADE</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="DiscountType != ''">
					<xsl:attribute name="DiscountType">
						<xsl:value-of select="DiscountType"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="AccountAction">
					<xsl:choose>
						<xsl:when test="CreditOrDebitAmount[@CreditOrDebit = 'Credit']">CREDIT</xsl:when>
						<xsl:when test="CreditOrDebitAmount[@CreditOrDebit = 'Debit']">DEBIT</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<!-- The AccountCode value requires formatting, but the information to do this is stored 
				in the database and so will be handled by the batch mapper -->
				<xsl:attribute name="AccountCode">
					<xsl:value-of select="DistributionAccount"/>
				</xsl:attribute>
				<xsl:attribute name="Amount">
					<xsl:value-of select="CreditOrDebitAmount"/>
				</xsl:attribute>
				<xsl:attribute name="CompanyID">
					<xsl:value-of select="CompanyCode"/>
				</xsl:attribute>
			</Distribution>
		</xsl:for-each>
	</Distributions>
</xsl:template>

<xsl:template name="DistributionTrailerTemplate">
	<xsl:param name="Currency" select="GBP"/>
	<TransactionSummary>
		<xsl:attribute name="TaxScheduleID">		
			<xsl:value-of select="DistributionsHeader/VATSchedule"/>
		</xsl:attribute>
		<xsl:attribute name="Currency">
			<xsl:value-of select="$Currency"/>
		</xsl:attribute>
		<xsl:if test="DistributionsTrailer/PurchasesDistributionsTotal >= 0">
			<Purchases>
				<xsl:value-of select="DistributionsTrailer/PurchasesDistributionsTotal"/>
			</Purchases>
		</xsl:if>
		<xsl:if test="DistributionsTrailer/TaxDistributionsTotal >= 0">
			<Tax>
				<xsl:value-of select="DistributionsTrailer/TaxDistributionsTotal"/>
			</Tax>
		</xsl:if>
		<xsl:if test="DistributionsDetail/DistributionsLine[DistributionType = 'Pay']/CreditOrDebitAmount >= 0">
			<Total>
				<xsl:value-of select="DistributionsDetail/DistributionsLine[DistributionType = 'Pay']/CreditOrDebitAmount"/>
			</Total>
		</xsl:if>
	</TransactionSummary>
</xsl:template>

</xsl:stylesheet>