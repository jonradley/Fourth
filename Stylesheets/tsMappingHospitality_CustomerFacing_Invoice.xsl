<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">


<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="Invoice">
	
		<xsl:element name="Invoice">
		
			<xsl:element name="TradeSimpleHeaderRecieved">
				<xsl:copy-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				<xsl:copy-of select="TradeSimpleHeader/SendersBranchReference"/>
				<xsl:copy-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				<xsl:copy-of select="TradeSimpleHeader/RecipientsBranchReference"/>
			</xsl:element><!--TradeSimpleHeaderRecieved-->
			
			<xsl:element name="InvoiceHeader">
				<xsl:copy-of select="InvoiceHeader/BatchInformation"/>
				<xsl:copy-of select="InvoiceHeader/Buyer"/>
				<xsl:copy-of select="InvoiceHeader/Supplier"/>
				<xsl:copy-of select="InvoiceHeader/ShipTo"/>
				<xsl:copy-of select="InvoiceHeader/InvoiceReferences"/>
				<xsl:copy-of select="InvoiceHeader/Currency"/>
			</xsl:element><!--InvoiceHeader-->
			<xsl:element name="InvoiceDetail">
				<xsl:for-each select="InvoiceDetail/InvoiceLine">
					<xsl:element name="InvoiceLine">
						<xsl:copy-of select="LineNumber"/>
						<xsl:copy-of select="PurchaseOrderReferences"/>
						<xsl:copy-of select="DeliveryNoteReferences"/>
						<xsl:element name="ProductID">
							<xsl:element name="GTIN">
								<xsl:value-of select="ProductID/GTIN"/>
							</xsl:element>
							<xsl:element name="SuppliersProductCode">
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</xsl:element>
						</xsl:element>				
						<xsl:copy-of select="ProductDescription"/>
						<xsl:copy-of select="InvoiceQuantity"/>
						<xsl:element name="UnitValueExclVAT">
							<xsl:value-of select="UnitValueExclVAT"/>
						</xsl:element>
						<xsl:copy-of select="LineValueExclVAT"/>
						<xsl:copy-of select="VATCode"/>
						<xsl:copy-of select="VATRate"/>		
					</xsl:element><!--InvoiceLine-->
				</xsl:for-each>
			</xsl:element><!--InvoiceDetail-->
			<xsl:copy-of select="InvoiceTrailer"/>
		
		</xsl:element><!--Invoice-->
		
	</xsl:template>
	
</xsl:stylesheet>
