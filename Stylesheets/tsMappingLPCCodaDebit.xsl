<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Debit Note into
 a Coda Debit XML file

 © Alternative Business Solutions Ltd., 2006.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 20/05/2003 | L Beattie  | Created module.
******************************************************************************************
 24/06/2003 | A Sheppard | Bug fix.
******************************************************************************************
 04/11/2004 | Lee Boyton | Modified to use new Hospitality internal schemas
                         | and use key method for grouping lines.
******************************************************************************************
 16/06/2006 | A Sheppard | H605. Changed into a debit note mapper
******************************************************************************************
 29/06/2006 | Lee Boyton | H604. Remove trailing /n from Coda code for Supplier if present.
                         |       The house code has moved from the suppliers to buyers code.
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="xml"/>
	
	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct Debit note line information (note the '::' literal is simply used as a convenient separator for the 2 values that make up the second key)-->
	<xsl:key name="keyDebitLinesByLedgerCode" match="DebitNoteLine" use="LineExtraData/CodaLedgerCode"/>
	<xsl:key name="keyDebitLinesByLedgerAndVATCode" match="DebitNoteDetail/DebitNoteLine" use="concat(LineExtraData/CodaLedgerCode,'::',LineExtraData/CodaVATCode)"/>
	
	<xsl:template match="/DebitNote">
		<xsl:if test="not(DebitNoteHeader/HeaderExtraData/CodaPLAccount1) or not(TradeSimpleHeader/RecipientsCodeForSender) or not(DebitNoteHeader/HeaderExtraData/CodaPLAccount2)">
			<xsl:value-of select="user:mRaiseError()"/>
		</xsl:if>
		
		<ABSformatEDIdocument>
			<coda-document-code>PCEDI</coda-document-code>
			<supplier-invoice-date>
				<xsl:value-of select="DebitNoteHeader/DebitNoteReferences/DebitNoteDate"/>
			</supplier-invoice-date>
			<year>
				<xsl:value-of select="substring(DebitNoteHeader/HeaderExtraData/FinancialPeriod,1,4)"/>
			</year>
			<period>
				<xsl:value-of select="substring(DebitNoteHeader/HeaderExtraData/FinancialPeriod,5,2)"/>
			</period>
			<supplier-invoice-number>
				<xsl:text>C</xsl:text>
				<xsl:value-of select="DebitNoteHeader/DebitNoteReferences/DebitNoteReference"/>
			</supplier-invoice-number>
			<file-generation-and-version>
				<xsl:value-of select="DebitNoteHeader/BatchInformation/FileGenerationNo"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="DebitNoteHeader/BatchInformation/FileVersionNo"/>
			</file-generation-and-version>
			<edi-sequence>
				<xsl:value-of select="DebitNoteHeader/SequenceNumber"/>
			</edi-sequence>
			<delivery-date>
				<xsl:value-of select="DebitNoteDetail/DebitNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
			</delivery-date>
			<batch-reference>
				<xsl:value-of select="DebitNoteHeader/HeaderExtraData/CodaBatchID"/>
			</batch-reference>
			<summary-line>
				<pl-control-account>
					<xsl:value-of select="DebitNoteHeader/HeaderExtraData/CodaPLAccount1"/>
				</pl-control-account>
				<supplier-account>
					<!-- where Laurel refer to different Supplier "PL" accounts by the same Coda code
					     a /n is added to the end of the Coda code to make them unique in the trading relationship;
					     this needs to be removed here -->
					<xsl:choose>
						<xsl:when test="contains(TradeSimpleHeader/SendersCodeForRecipient,'/')">
							<xsl:value-of select="substring-before(TradeSimpleHeader/SendersCodeForRecipient,'/')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
						</xsl:otherwise>
					</xsl:choose>					
				</supplier-account>
				<house-number>
					<xsl:value-of select="DebitNoteHeader/HeaderExtraData/CodaPLAccount2"/>
				</house-number>
				<summary-line-description>EDI Debit Note</summary-line-description>
				<summary-line-value>
					<xsl:value-of select="format-number(DebitNoteTrailer/DocumentTotalInclVAT,'0.00')"/>
				</summary-line-value>
				<summary-line-type>Debit</summary-line-type>
				<tax-summary-value>
					<xsl:value-of select="format-number(DebitNoteTrailer/VATAmount,'0.00')"/>
				</tax-summary-value>
			</summary-line>
			<analysis-lines>
				<!-- use the Muenchian method (i.e. uses keys) for grouping Debit Note Lines by Coda Ledger Code and then by Coda VAT Code -->
				<!-- the first loop will match the first Debit line in each set of lines grouped by Coda Ledger Code -->
				<xsl:for-each select="DebitNoteDetail/DebitNoteLine[generate-id() = generate-id(key('keyDebitLinesByLedgerCode',LineExtraData/CodaLedgerCode)[1])]">
					<xsl:sort select="LineExtraData/CodaLedgerCode" data-type="text"/>
					<xsl:variable name="LedgerCode" select="LineExtraData/CodaLedgerCode"/>
					<!-- now, given we can find all Debit lines for the current Coda Ledger Code, loop through and match the first line for each unique Coda VAT code -->
					<xsl:for-each select="key('keyDebitLinesByLedgerCode',$LedgerCode)[generate-id() = generate-id(key('keyDebitLinesByLedgerAndVATCode',concat($LedgerCode,'::',LineExtraData/CodaVATCode))[1])]">
						<xsl:sort select="LineExtraData/CodaVATCode" data-type="text"/>
						<xsl:variable name="VATCode" select="LineExtraData/CodaVATCode"/>
						<!-- now that we have our distinct and sorted list of lines we can output the required analysis lines -->
						<xsl:variable name="LineValue" select="sum(key('keyDebitLinesByLedgerAndVATCode',concat($LedgerCode,'::',$VATCode))/LineValueExclVAT)"/>
						<analysis-line>
							<nominal-account>
								<xsl:value-of select="$LedgerCode"/>
							</nominal-account>
							<house-number>
								<xsl:value-of select="/DebitNote/DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
							</house-number>
							<detail-line-description>
								<xsl:choose>
									<xsl:when test="not(DeliveryNoteReferences/DeliveryNoteDate)">Unknown Delivery Date EDI</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="DeliveryNoteReferences/DeliveryNoteDate"/>
										<xsl:text> EDI</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</detail-line-description>
							<detail-line-value>
								<xsl:choose>
									<xsl:when test="$LineValue &lt; 0">
										<xsl:value-of select="format-number(-1 * $LineValue, '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number($LineValue, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</detail-line-value>
							<detail-line-type>
								<xsl:choose>
									<xsl:when test="$LineValue &lt; 0">Debit</xsl:when>
									<xsl:otherwise>Credit</xsl:otherwise>
								</xsl:choose>
							</detail-line-type>
							<detail-line-tax-code>
								<xsl:value-of select="$VATCode"/>
							</detail-line-tax-code>
							<detail-line-tax-value>
								<xsl:choose>
									<xsl:when test="$LineValue &lt; 0">
										<xsl:value-of select="format-number(-1 * VATRate * $LineValue div 100, '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(VATRate * $LineValue div 100, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</detail-line-tax-value>
						</analysis-line>
					</xsl:for-each>
				</xsl:for-each>
			</analysis-lines>
			<tax-lines>
				<xsl:for-each select="DebitNoteTrailer/VATSubTotals/VATSubTotal">
					<tax-line>
						<tax-account-element-1>
							<xsl:value-of select="/DebitNote/DebitNoteHeader/HeaderExtraData/CodaVATNominalCode"/>
						</tax-account-element-1>
						<tax-account-element-2>
							<xsl:value-of select="VATTrailerExtraData/CodaVATCode"/>
						</tax-account-element-2>
						<tax-line-description>EDI Debit Note</tax-line-description>
						<tax-line-value>
							<xsl:value-of select="format-number(VATAmountAtRate,'0.00')"/>
						</tax-line-value>
						<tax-line-type>Credit</tax-line-type>
						<tax-line-tax-code>
							<xsl:value-of select="VATTrailerExtraData/CodaVATCode"/>
						</tax-line-tax-code>
						<tax-line-tax-turnover>
							<xsl:value-of select="format-number(DocumentTotalExclVATAtRate,'0.00')"/>
						</tax-line-tax-turnover>
					</tax-line>
				</xsl:for-each>
			</tax-lines>
		</ABSformatEDIdocument>
	</xsl:template>
	
	<xsl:template match="DeliveryNoteDate">
		<xsl:value-of select="substring(.,9,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(.,6,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(.,1,4)"/>
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[ 
		function mRaiseError()
		{}
	]]></msxsl:script>
</xsl:stylesheet>
