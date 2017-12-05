<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Consolidated Restaurant Operations Inc. (CRO) R9 Mapper for Invoice Credit Export Export to CSV.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 18/10/2017	| Warith Nassor	| FB12162 - CRO Invoice Credit Export - Splitting/Grouping by Nominal based on Doc Type & Invoice Ref.
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">

	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	
	<xsl:variable name="FieldSeperator" select="','"/>
	
	
	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyLines" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal)"/>

	<xsl:template match="/">
			<xsl:text>Database-Legal Entity Name,Seg1-GLAcct-Natural,Seg2-Store,Seg3-GLAcct-CompanyCode,VendorCode,VendorName,InvoiceNo,InvoiceType,InvoiceDate,Amount,ReleaseUser</xsl:text>
			<xsl:value-of select="$RecordSeperator"/>
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>
	
	<xsl:template match="BatchDocument">
	
		<xsl:for-each select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLines',concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal))[1])]">
			<!--Store the Account Code-->
			<xsl:variable name="key" select="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal)"/>
			
			<!--Database-Legal Entity Name #EMPTY#-->
			<xsl:value-of select="$FieldSeperator"/>    
		
			<!-- Seg1-GLAcct-Natural -->
			<xsl:value-of select="CategoryNominal"/>
			<xsl:value-of select="$FieldSeperator"/>

			<!-- Seg2-Store  -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersUnitCode"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Seg3-GLAcct-CompanyCode #EMPTY# -->
			<xsl:value-of select="$FieldSeperator"/>
		
			<!--VendorCode-->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersCodeForSupplier"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- VendorName -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/SupplierName"/>
			<xsl:value-of select="$FieldSeperator"/>

			<!-- Vendor Invoice No. -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- InvoiceType -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/TransactionType"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Date -->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="DateTimeStr" select="../../InvoiceCreditJournalEntriesHeader/InvoiceDate"/>
			</xsl:call-template>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Net Amount -->
			<xsl:choose>
				<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType = 'CRN'">
					<xsl:value-of select="format-number(-1 * (sum(../InvoiceCreditJournalEntriesLine[concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal) = $key]/LineNet)),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal) = $key]/LineNet),'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- ReleaseUser -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/CreatedBy"/>
			
			<xsl:value-of select="$RecordSeperator"/>
		</xsl:for-each>
	</xsl:template>
	
		<xsl:template name="formatDate">
	     <xsl:param name="DateTimeStr" />
      <xsl:variable name="mm">
         <xsl:value-of select="substring($DateTimeStr,6,2)" />
     </xsl:variable>
      <xsl:variable name="dd">
        <xsl:value-of select="substring($DateTimeStr,9,2)" />
     </xsl:variable>
      <xsl:variable name="yyyy">
        <xsl:value-of select="substring($DateTimeStr,1,4)" />
     </xsl:variable>
      <xsl:value-of select="concat($mm,'/', $dd, '/', $yyyy)" />
       </xsl:template>


</xsl:stylesheet>
