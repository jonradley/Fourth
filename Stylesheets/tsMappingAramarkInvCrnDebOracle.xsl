<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Hospitality Invoice/Credit note/ Debit note into the Oracle file for Aramark Spain

 © Fourth Hospitality
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 
******************************************************************************************
 04/10/2011      | S Sehgal       | 4854 Header field is now calculated based on the document financial period when provided or using document date. 
******************************************************************************************
 05/10/2011      | R Cambridge    | 4992 read buyers code for supplier from SuppliersLocationID/BuyersCode
******************************************************************************************
09/12/2011       | Graham Neicho | 5066 Format ShipToLocationID/BuyersCode so it does not display the "secondary" part
******************************************************************************************
04/01/2012       | S Sehgal | 5147 Upgrade file format for Oracle r12. New fields added to Header and Line rows and couple of existing header fields set to blank
******************************************************************************************
26/01/2012       | S Sehgal | 5216 Field 63 for Line level set to empty
******************************************************************************************
14/05/2012       | Graham Neicho | FB5450 Reversed previous change, so Field 63 contains "MOD340NONE" once again
******************************************************************************************
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
<xsl:output method="text"
		     encoding="UTF-8"/>

<xsl:param name="separator" select="'|'"/>
<xsl:param name="line-separator" select="'&#13;&#10;'"/>
<xsl:param name="SITE_CODE_SEPARATOR" select="' '"/>

	<xsl:template match="//Invoice | //CreditNote | //DebitNote">
		<xsl:variable name="primaryCodeForSite" select="substring-before(concat(InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode, $SITE_CODE_SEPARATOR), $SITE_CODE_SEPARATOR)" />
		<xsl:variable name="primaryCodePrefix" select="substring($primaryCodeForSite, 1, 4)" />

		<xsl:text>IH</xsl:text>
		<xsl:value-of select="$separator"/>
	       <xsl:choose>
	          <xsl:when test="$primaryCodePrefix = '1801'">
	          	<xsl:text>ARAMARK Servicios de Catering S.L.U</xsl:text>
	          </xsl:when>
	          <xsl:when test="$primaryCodePrefix = '1802'">
	          	<xsl:text>ARAMARK Servicios Integrales S.A.U</xsl:text>
	          </xsl:when>
	          <xsl:when test="$primaryCodePrefix = '1805'">
	          	<xsl:text>COMERTEL S.A.</xsl:text>
	          </xsl:when>
	          <xsl:when test="$primaryCodePrefix = '1806'">
	          	<xsl:text>GESALCO S.L.</xsl:text>
	          </xsl:when>
	          <xsl:when test="$primaryCodePrefix = '1807'">
	          	<xsl:text>COMERTEL SERVICIOS DE CATERING S.L.</xsl:text>
	          </xsl:when>
	          <xsl:when test="$primaryCodePrefix = '1808'">
	          	<xsl:text>COMERTEL RESIDENCIAS S.L.</xsl:text>
	          </xsl:when>
	          <xsl:otherwise>
	          	<xsl:text>Unknown</xsl:text>
	          </xsl:otherwise>
	       </xsl:choose>
	       <xsl:value-of select="$separator"/>
	        	<xsl:text>18_ARATRADE</xsl:text>
	       <xsl:value-of select="$separator"/>
	       <xsl:choose>	
		       <xsl:when test="name()='Invoice'">	
		       	<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		       	<xsl:text>(</xsl:text>
		       	<xsl:value-of select="substring(InvoiceHeader/InvoiceReferences/InvoiceDate,1,4)"/>
		       	<xsl:text>)</xsl:text>
		       </xsl:when>
		       <xsl:when test="name()='CreditNote'">	
		       	<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		       	<xsl:text>(</xsl:text>
		       	<xsl:value-of select="substring(CreditNoteHeader/CreditNoteReferences/CreditNoteDate,1,4)"/>
		       	<xsl:text>)</xsl:text>
		       </xsl:when>		       	
		       <xsl:when test="name()='DebitNote'">		
		       	<xsl:value-of select="DebitNoteHeader/DebitNoteReferences/DebitNoteReference"/>	
		       	<xsl:text>(</xsl:text>
		       	<xsl:value-of select="substring(DebitNoteHeader/DebitNoteReferences/DebitNoteDate,1,4)"/>
		       	<xsl:text>)</xsl:text>
		       </xsl:when>
		</xsl:choose>		       
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="translate(InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/InvoiceReferences/InvoiceDate | DebitNoteHeader/InvoiceReferences/InvoiceDate,'-','')"/>
		<xsl:value-of select="$separator"/>
		<!-- 4992 R Cambridge use buyer's code for supplier -->
		<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode | CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode | DebitNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:text>PRINCIPAL</xsl:text>
		<xsl:value-of select="$separator"/>
	       <xsl:choose>	
		       <xsl:when test="name()='Invoice'">	
				<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:when>
		       <xsl:when test="name()='CreditNote'">	
				<xsl:value-of select="format-number(number(CreditNoteTrailer/DocumentTotalInclVAT)*-1,'0.00')"/>
			</xsl:when>
		       <xsl:when test="name()='DebitNote'">	
				<xsl:value-of select="format-number(number(DebitNoteTrailer/DocumentTotalInclVAT)*-1,'0.00')"/>
			</xsl:when>
	       </xsl:choose>
		<xsl:value-of select="$separator"/>
		<xsl:text>EUR</xsl:text>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:text>XARAES_INV_HEADER</xsl:text>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$primaryCodeForSite"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>			
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:choose>
			<xsl:when test="InvoiceHeader/HeaderExtraData/FinancialPeriod | CreditNoteHeader/HeaderExtraData/FinancialPeriod | DebitNoteHeader/HeaderExtraData/FinancialPeriod">
				<xsl:value-of select="InvoiceHeader/HeaderExtraData/FinancialPeriod | CreditNoteHeader/HeaderExtraData/FinancialPeriod | 	DebitNoteHeader/HeaderExtraData/FinancialPeriod"/>
				   <xsl:choose>
		          <xsl:when test="substring(InvoiceHeader/HeaderExtraData/FinancialPeriod | CreditNoteHeader/HeaderExtraData/FinancialPeriod | 	DebitNoteHeader/HeaderExtraData/FinancialPeriod,5,2)='02'">
		          	<xsl:text>28</xsl:text>
		          </xsl:when>
		          <xsl:otherwise>
		          	<xsl:text>30</xsl:text>
		          </xsl:otherwise>
		       </xsl:choose>

			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(substring(InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/InvoiceReferences/InvoiceDate | 	DebitNoteHeader/InvoiceReferences/InvoiceDate,1,7),'-','')"/>
		       <xsl:choose>
		          <xsl:when test="substring(InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/InvoiceReferences/InvoiceDate | 	DebitNoteHeader/InvoiceReferences/InvoiceDate,6,2)='02'">
		          	<xsl:text>28</xsl:text>
		          </xsl:when>
		          <xsl:otherwise>
		          	<xsl:text>30</xsl:text>
		          </xsl:otherwise>
		       </xsl:choose>
			</xsl:otherwise>       
	       </xsl:choose>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$primaryCodePrefix"/>
		<xsl:text>_ARATRADE</xsl:text>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$primaryCodePrefix"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$primaryCodeForSite"/>
		<xsl:value-of select="$separator"/>			
		<xsl:text>8100</xsl:text>
		<xsl:value-of select="$separator"/>			
		<xsl:text>184000</xsl:text>
		<xsl:value-of select="$separator"/>					
		<xsl:text>000</xsl:text>
		<xsl:value-of select="$separator"/>	
		<xsl:text>0</xsl:text>
		<xsl:value-of select="$separator"/>				
		<xsl:text>0000</xsl:text>
		<xsl:value-of select="$separator"/>		
		<xsl:text>00</xsl:text>
		<xsl:value-of select="$separator"/>	
		<xsl:text>00000</xsl:text>
		<xsl:value-of select="$separator"/>	
		<xsl:text>0000</xsl:text>
		<xsl:value-of select="$separator"/>	
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:text>ES</xsl:text>
		<xsl:value-of select="$separator"/>
		<xsl:text>MOD340_EXCL</xsl:text>
		<xsl:value-of select="$separator"/>
		<xsl:text>Y</xsl:text>		
		<xsl:value-of select="$separator"/>
		
		<xsl:for-each select="InvoiceDetail/InvoiceLine | CreditNoteDetail/CreditNoteLine | DebitNoteDetail/DebitNoteLine">
			<xsl:sort select="VATCode"/>
			<xsl:sort select="VATRate"/>
			<xsl:sort select="LineExtraData/AccountCode"/>
			<xsl:value-of select="$line-separator"/>
			<xsl:text>IL</xsl:text>
			<xsl:value-of select="$separator"/>	
			<xsl:value-of select="LineNumber"/>
			<xsl:value-of select="$separator"/>	
			<xsl:text>ITEM</xsl:text>
			<xsl:value-of select="$separator"/>
		       <xsl:choose>	
			       <xsl:when test="name()!='InvoiceLine'">	
					<xsl:value-of select="format-number(LineValueExclVAT*-1,'0.00')"/>
				</xsl:when>
			       <xsl:otherwise>	
					<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
				</xsl:otherwise>
		       </xsl:choose>
			<xsl:value-of select="$separator"/>	
			<xsl:value-of select="$separator"/>	
			<xsl:value-of select="$primaryCodePrefix"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$primaryCodeForSite"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="substring(LineExtraData/AccountCode,1,4)"/>
			<xsl:value-of select="$separator"/>
			<xsl:choose>
				<xsl:when test="string-length(LineExtraData/AccountCode)>5">
					<xsl:value-of select="substring(LineExtraData/AccountCode,string-length(LineExtraData/AccountCode)-5,6)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="LineExtraData/AccountCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$separator"/>
			<xsl:text>000</xsl:text>
			<xsl:value-of select="$separator"/>
			<xsl:text>0</xsl:text>
			<xsl:value-of select="$separator"/>
			<xsl:text>0000</xsl:text>
			<xsl:value-of select="$separator"/>
			<xsl:text>00</xsl:text>
			<xsl:value-of select="$separator"/>
			<xsl:text>00000</xsl:text>
			<xsl:value-of select="$separator"/>
			<xsl:text>0000</xsl:text>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="VATCode"/>
			<xsl:text> SOP </xsl:text>
			<xsl:value-of select="number(VATRate)"/>
			<xsl:text>%</xsl:text>
			<xsl:value-of select="$separator"/>
				<xsl:choose>	
				       <xsl:when test="VATCode='IVA'">
						<xsl:text>PURCHASE_TRANSACTION/INVOICE TYPE/MOD347/A</xsl:text>						
					</xsl:when>
					<xsl:when test="VATCode='IGIC'">
						<xsl:text>PURCHASE_TRANSACTION/INVOICE TYPE/MOD415/A</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Unknown</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			<xsl:value-of select="$separator"/>
			<xsl:text>MOD340NONE</xsl:text>
		</xsl:for-each>
	  
	</xsl:template>

</xsl:stylesheet>
