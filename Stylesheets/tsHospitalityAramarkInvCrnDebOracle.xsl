<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
<xsl:output method="text"
		     encoding="UTF-8"/>

<xsl:param name="separator" select="'|'"/>
<xsl:param name="line-separator" select="'&#13;&#10;'"/>

	<xsl:template match="//Invoice | //CreditNote | //DebitNote">
		<xsl:text>IH</xsl:text>
		<xsl:value-of select="$separator"/>
	       <xsl:choose>
	          <xsl:when test="substring(InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode,1,4)=1801">
	          	<xsl:text>Aramark Servicios de Catering S.L.U</xsl:text>
	          </xsl:when>
	          <xsl:when test="substring(InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode,1,4)=1802">
	          	<xsl:text>Aramark Servicios Integrales S.A.</xsl:text>
	          </xsl:when>
	          <xsl:otherwise>
	          	<xsl:text>Unknown</xsl:text>
	          </xsl:otherwise>
	        </xsl:choose>
	        <xsl:value-of select="$separator"/>
	        	<xsl:text>18_ARATRADE</xsl:text>
	        <xsl:value-of select="$separator"/>
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference | CreditNoteHeader/InvoiceReferences/InvoiceReference | DebitNoteHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="substring(InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/InvoiceReferences/InvoiceDate | DebitNoteHeader/InvoiceReferences/InvoiceDate,1,4)"/>
		<xsl:text>)</xsl:text>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="translate(InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/InvoiceReferences/InvoiceDate | DebitNoteHeader/InvoiceReferences/InvoiceDate,'-','')"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode | CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode | DebitNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:text>PRINCIPAL</xsl:text>
		<xsl:value-of select="$separator"/>
	       <xsl:choose>	
		       <xsl:when test="name()!='Invoice'">	
				<xsl:value-of select="number(InvoiceTrailer/DocumentTotalExclVAT | CreditNoteTrailer/DocumentTotalExclVAT | DebitNoteTrailer/DocumentTotalExclVAT)*-1"/>
			</xsl:when>
		       <xsl:otherwise>	
				<xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT | CreditNoteTrailer/DocumentTotalExclVAT | DebitNoteTrailer/DocumentTotalExclVAT"/>
			</xsl:otherwise>
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
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
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
		       <xsl:when test="InvoiceDetail/InvoiceLine/VATCode[1]='IVA'">
				<xsl:text>JE.ES.APXIISIM.MODELO347</xsl:text>
				<xsl:value-of select="$separator"/>
				<xsl:text>MOD347</xsl:text>
			</xsl:when>
			<xsl:when test="InvoiceDetail/InvoiceLine/VATCode[1]='IGIC'">
				<xsl:text>JE.ES.APXIISIM.MODELO415</xsl:text>
				<xsl:value-of select="$separator"/>
				<xsl:text>MOD415</xsl:text>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Unknown</xsl:text>
				<xsl:value-of select="$separator"/>
				<xsl:text>Unknown</xsl:text>			
			</xsl:otherwise>
		</xsl:choose>
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
		<xsl:value-of select="translate(substring(InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/InvoiceReferences/InvoiceDate | DebitNoteHeader/InvoiceReferences/InvoiceDate,1,7),'-','')"/>
	       <xsl:choose>
	          <xsl:when test="substring(InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/InvoiceReferences/InvoiceDate | DebitNoteHeader/InvoiceReferences/InvoiceDate,6,2)='02'">
	          	<xsl:text>28</xsl:text>
	          </xsl:when>
	          <xsl:otherwise>
	          	<xsl:text>30</xsl:text>
	          </xsl:otherwise>
	       </xsl:choose>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="substring(InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode,1,4)"/>
		<xsl:text>_ARATRADE</xsl:text>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="substring(InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode,1,4)"/>
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:value-of select="$separator"/>			
		<xsl:text>8100</xsl:text>
		<xsl:value-of select="$separator"/>			
		<xsl:text>180000</xsl:text>
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
			       <xsl:when test="name()!='Invoice'">	
					<xsl:value-of select="LineValueExclVAT*-1"/>
				</xsl:when>
			       <xsl:otherwise>	
					<xsl:value-of select="LineValueExclVAT"/>
				</xsl:otherwise>
		       </xsl:choose>
			<xsl:value-of select="$separator"/>	
			<xsl:value-of select="$separator"/>	
			<xsl:value-of select="substring(../../InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | ../../CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | ../../DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode,1,4)"/>
			<xsl:value-of select="$separator"/>
			<xsl:value-of select="../../InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | ../../CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | ../../DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
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
			<xsl:text>SOP</xsl:text>
			<xsl:value-of select="VATRate"/>
		</xsl:for-each>
	  
	</xsl:template>

</xsl:stylesheet>
