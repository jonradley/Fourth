<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 La Tasca mapper for invoices and credits journal format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 		| Description of modification
==========================================================================================
 04/03/2015	| Jose Miguel	| FB10182 - La Tasca - Add FnB Invoice and Credit Journal Entries Feed
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

	<xsl:key name="keyLinesByRefAndNominalCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', CategoryNominal)"/>
	<xsl:key name="keyLinesByRefNominalAndVATCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', CustomerVATCode)"/>
	<xsl:key name="keyLinesByRefAndVATCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CustomerVATCode)"/>

	<xsl:template match="/">
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>
	
	<xsl:template match="BatchDocument">
		<ABSformatEDIdocument>
			<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader"/>
			<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail"/>
		</ABSformatEDIdocument>
	</xsl:template>
	
	<!-- Header information for the invoice / credit note -->
	<xsl:template match="InvoiceCreditJournalEntriesHeader">
		<!-- decide the type of document -->
		<coda-document-code>
			<xsl:choose>
				<xsl:when test="TransactionType='INV'">PIEDI</xsl:when>
				<xsl:when test="TransactionType='CRN'">PCEDI</xsl:when>
			</xsl:choose>
		</coda-document-code>
		<supplier-invoice-date>
			<xsl:value-of select="InvoiceDate"/>
		</supplier-invoice-date>			
		<year>
			<xsl:value-of select="StockFinancialYear"/>
		</year>
		<period>
			<xsl:value-of select="StockFinancialPeriod"/>
		</period>
		<supplier-invoice-number>
			<xsl:choose>
				<xsl:when test="TransactionType='INV'"><xsl:text>I</xsl:text></xsl:when>
				<xsl:when test="TransactionType='CRN'"><xsl:text>C</xsl:text></xsl:when>
			</xsl:choose>
			<xsl:value-of select="InvoiceReference"/>
		</supplier-invoice-number>
		<file-generation-and-version>
			<xsl:value-of select="user:msFileGenerationDate()"/>
		</file-generation-and-version>
		<edi-sequence>
			<xsl:text>1</xsl:text>
		</edi-sequence>
		<delivery-date>
			<xsl:value-of select="DeliveryDate"/>
		</delivery-date>
		<batch-reference>
<!--			<xsl:text>PENDING</xsl:text>-->
		</batch-reference>
		<summary-line>
			<pl-control-account>
				<xsl:text>761120</xsl:text>
			</pl-control-account>
			<supplier-account>
				<xsl:value-of select="SupplierNominalCode"/>
			</supplier-account>
			<house-number>
				<xsl:text>9000</xsl:text>
			</house-number>
			<summary-line-description>
				<xsl:choose>
					<xsl:when test="TransactionType='INV'"><xsl:text>EDI Invoice</xsl:text></xsl:when>
					<xsl:when test="TransactionType='CRN'"><xsl:text>EDI Credit Note</xsl:text></xsl:when>
				</xsl:choose>
			</summary-line-description>
			<summary-line-value>
				<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineGross),'0.00')"/>
			</summary-line-value>
			<summary-line-type>
				<xsl:choose>
					<xsl:when test="TransactionType='INV'"><xsl:text>Credit</xsl:text></xsl:when>
					<xsl:when test="TransactionType='CRN'"><xsl:text>Debit</xsl:text></xsl:when>
				</xsl:choose>
			</summary-line-type>
			<tax-summary-value>
				<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineVAT),'0.00')"/>
			</tax-summary-value>
		</summary-line>
	</xsl:template>

	<!-- Process the detail group the lines by Nominal Code and then by VATCode -->
	<xsl:template match="InvoiceCreditJournalEntriesDetail">
		<xsl:variable name="currentDocReference" select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
		<analysis-lines>
			<xsl:value-of select="$currentDocReference"/>
			<!-- For each Nominal code within the document -->
			<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', CategoryNominal))[1])]">
				<xsl:sort select="CategoryNominal" data-type="text"/>
				<!-- for each VATCOde within the current Nominal Code group of the same document -->
				<xsl:variable name="currentCategoryNominal" select="CategoryNominal"/>
				<xsl:for-each select="key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', $currentCategoryNominal))[generate-id() = generate-id(key('keyLinesByRefNominalAndVATCode', concat($currentDocReference, '|', $currentCategoryNominal, '|', CustomerVATCode))[1])]">
					<xsl:sort select="CustomerVATCode" data-type="text"/>
					<xsl:variable name="currentVATCode" select="CustomerVATCode"/>
					<xsl:variable name="currentGroupNet" select="sum(key('keyLinesByRefNominalAndVATCode',concat($currentDocReference, '|', $currentCategoryNominal, '|', $currentVATCode))/LineNet)"/>
					<xsl:variable name="currentGroupVAT" select="sum(key('keyLinesByRefNominalAndVATCode',concat($currentDocReference, '|', $currentCategoryNominal, '|', $currentVATCode))/LineVAT)"/>
						<analysis-line>
							<nominal-account>
								<xsl:value-of select="$currentCategoryNominal"/>
							</nominal-account>
							<house-number>
								<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersUnitCode"/>
							</house-number>
							<detail-line-description>
								<xsl:value-of select="concat(../../InvoiceCreditJournalEntriesHeader/DeliveryDate, 'EDI')"/>
							</detail-line-description>
							<detail-line-value>
								<xsl:choose>
									<xsl:when test="$currentGroupNet &lt; 0">
										<xsl:value-of select="format-number(-1 * $currentGroupNet, '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number($currentGroupNet, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</detail-line-value>
							<detail-line-type>
								<xsl:choose>
									<xsl:when test="$currentGroupNet &lt; 0">Credit</xsl:when>
									<xsl:otherwise>Debit</xsl:otherwise>
								</xsl:choose>
							</detail-line-type>
							<detail-line-tax-code>
								<xsl:value-of select="$currentVATCode"/>
							</detail-line-tax-code>
							<detail-line-tax-value>
								<xsl:choose>
									<xsl:when test="$currentGroupNet &lt; 0">
										<xsl:value-of select="format-number(-1 * $currentGroupVAT, '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number($currentGroupVAT, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</detail-line-tax-value>
						</analysis-line>
				</xsl:for-each>
			</xsl:for-each>
		</analysis-lines>
		<tax-lines>
			<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefAndVATCode', concat($currentDocReference, '|', CustomerVATCode))[1])]">
				<xsl:variable name="currentVATCode" select="CustomerVATCode"/>
				<tax-line>
					<tax-account-element-1>
						<xsl:text>768120</xsl:text>
					</tax-account-element-1>
					<tax-account-element-2>
						<xsl:value-of select="CustomerVATCode"/>
					</tax-account-element-2>
					<tax-line-description>
						<xsl:choose>
							<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType='INV'"><xsl:text>EDI Invoice</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>EDI Credit Note</xsl:text></xsl:otherwise>
						</xsl:choose>
					</tax-line-description>
					<tax-line-value>
						<xsl:value-of select="sum(key('keyLinesByRefNominalAndVATCode',concat($currentDocReference,'|', $currentVATCode))/LineVAT)"/>
					</tax-line-value>
					<tax-line-type>
						<xsl:choose>
							<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType='INV'"><xsl:text>Debit</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>Credit</xsl:text></xsl:otherwise>
						</xsl:choose>
					</tax-line-type>
					<tax-line-tax-code>
						<xsl:value-of select="CustomerVATCode"/>
					</tax-line-tax-code>
					<tax-line-tax-turnover>
						<xsl:value-of select="sum(key('keyLinesByRefNominalAndVATCode',concat($currentDocReference,'|', $currentVATCode))/LineNet)"/>
					</tax-line-tax-turnover>
				</tax-line>
			</xsl:for-each>
		</tax-lines>		
	</xsl:template>

	<xsl:template match="DeliveryNoteDate">
		<xsl:value-of select="substring(.,9,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(.,6,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(.,1,4)"/>
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[ 
		function right (str, count)
		{
			return str.substring(str.length - count, str.length);
		}
		
		function pad2 (str)
		{
			return right('0' + str, 2);
		}
		
		/*=========================================================================================
		' Routine        : msFileGenerationDate()
		' Description    : Gets the date in 'YYMMDDhhmmss' format and works in all regions and date configurations (UK, US).
		' Returns        : A string
		' Author         : Jose Miguel
		' Version        : 1.0
		' Alterations    : (none)
		'========================================================================================*/
		function msFileGenerationDate ()
		{
			var today = new Date();
			var year = today.getYear();
			var month = today.getMonth()+1;
			var day = today.getDate();
			var hours = today.getHours();
			var minutes = today.getMinutes();
			var secs = today.getSeconds();

			return '' + pad2(year) + pad2(month) + pad2(day) + pad2(hours) + pad2(minutes) + pad2(secs);
		}
		
		/*=========================================================================================
		' Routine        : msFileGenerationTime()
		' Description    : Gets the date in 'hhmm' format and works in all regions and time configurations (UK, US).
		' Returns        : A string
		' Author         : Jose Miguel
		' Version        : 1.0
		' Alterations    : (none)
		'========================================================================================*/
		function msFileGenerationTime()
		{

		}	
	]]></msxsl:script>
</xsl:stylesheet>

