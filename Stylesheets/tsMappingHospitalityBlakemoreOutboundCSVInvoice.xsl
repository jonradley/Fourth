<?xml version="1.0" encoding="UTF-16"?>
<!--======================================================================================
 Overview

 Outbound invoice csv mapper, based on inbound CSV format. 

======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="utf-8"/>
	<xsl:template match="/">
		
		<xsl:text>I</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/TradeSimpleHeader/SendersBranchReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="translate(/Invoice/TradeSimpleHeader/TestFlag,'TRUE','true') = 'true'">Y</xsl:when>
			<xsl:when test="/Invoice/TradeSimpleHeader/TestFlag ='1'">Y</xsl:when>
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>		
		<xsl:text>,</xsl:text>
		<xsl:value-of select="translate(/Invoice/InvoiceHeader/BatchInformation/FileCreationDate,'-','')"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/FileGenerationNo"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/FileVersionNo"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/SendersTransmissionReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="translate(/Invoice/InvoiceHeader/BatchInformation/SendersTransmissionDate,'T-:', ' ')"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:text>H</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/TradeSimpleHeader/RecipientsCodeForSender"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/TradeSimpleHeader/RecipientsBranchReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Supplier/SuppliersName"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine4"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/PostCode"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/VATRegNo"/>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Buyer/BuyersName"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/PostCode"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="translate(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate,'-','')"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="translate(/Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate,'-','')"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/Currency"/>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/ShipTo/ShipToName"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/PostCode"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/NumberOfDeliveries"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/NumberOfLines"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/NumberOfItems"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalExclVAT"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementDiscount"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementTotalExclVAT"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/VATAmount"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalInclVAT"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementTotalInclVAT"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="/Invoice/InvoiceDetail/InvoiceLine">
		
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="PurchaseOrderReferences/PurchaseOrderReference"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="translate(PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="DeliveryNoteReferences/DeliveryNoteReference"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="translate(DeliveryNoteReferences/DeliveryNoteDate,'-','')"/>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="ProductID/SuppliersProductCode"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="ProductDescription"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="normalize-space(PackSize)"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="InvoicedQuantity"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="VATCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="VATRate"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>
		
		<xsl:for-each select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal">
		
			<xsl:text>V</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="@VATCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="@VATRate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="NumberOfLinesAtRate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="NumberOfItemsAtRate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="DocumentTotalExclVATAtRate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="SettlementDiscountAtRate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="SettlementTotalExclVATAtRate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="VATAmountAtRate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="DocumentTotalInclVATAtRate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="SettlementTotalInclVATAtRate"/>
			<xsl:if test="position() != last()">
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:if>
			
		</xsl:for-each>
		
	</xsl:template>
	
	
<!--=======================================================================================
  Routine        : msCSV()
  Description    : Puts " around a string if it contains a comma and replaces " with ""
  Inputs         : A string
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msCSV">
		<xsl:param name="vs"/>
		<xsl:if test="contains($vs,',') or contains($vs,'&quot;')">
			<xsl:text>"</xsl:text>	
		</xsl:if>
		<xsl:call-template name="msQuotes">
			<xsl:with-param name="vs" select="$vs"/>
		</xsl:call-template>
		<xsl:if test="contains($vs,',') or contains($vs,'&quot;')">
			<xsl:text>"</xsl:text>	
		</xsl:if>
	</xsl:template>

<!--=======================================================================================
  Routine        : msQuotes
  Description    : Recursively searches for " and replaces it with ""
  Inputs         : A string
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msQuotes">
		<xsl:param name="vs"/>
		
		<xsl:choose>
		
			<xsl:when test="$vs=''"/><!-- base case-->
			
			<xsl:when test="substring($vs,1,1)='&quot;'"><!-- " found -->
				<xsl:value-of select="substring($vs,1,1)"/>
				<xsl:value-of select="'&quot;'"/>				
				<xsl:call-template name="msQuotes">
					<xsl:with-param name="vs" select="substring($vs,2)"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:otherwise><!-- other character -->
				<xsl:value-of select="substring($vs,1,1)"/>
				<xsl:call-template name="msQuotes">
					<xsl:with-param name="vs" select="substring($vs,2)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
</xsl:stylesheet>
