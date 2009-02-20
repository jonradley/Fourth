<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="text" encoding="UTF-8"/>

	<xsl:template match="Invoice">
	
		<xsl:text>&quot;</xsl:text>
		<xsl:text>CSV  DD/MM/YYYY hhmm    HEAD LINE VAT  TRAIL               NN</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>


		<xsl:text>&quot;</xsl:text>
		<xsl:text>HEAD</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:call-template name="formatDate">
			<xsl:with-param name="sInput">
				<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:call-template name="formatDate">
			<xsl:with-param name="sInput">
				<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:call-template name="formatDate">
			<xsl:with-param name="sInput">
				<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<!-- This should be payment due date -->
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<!-- "N"? -->		
		<xsl:text>&quot;</xsl:text>
		<xsl:text>N</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>


		<xsl:for-each select="InvoiceDetail/InvoiceLine">
		
			<xsl:text>&quot;</xsl:text>
			<xsl:text>LINE</xsl:text>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:text>&quot;</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:if test="InvoicedQuantity/@UnitOfMeasure != 'KGM'">
				<xsl:text>1</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:if test="InvoicedQuantity/@UnitOfMeasure = 'KGM'">
				<xsl:text>1</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:if test="InvoicedQuantity/@UnitOfMeasure = 'KGM'">
				<xsl:text>&quot;</xsl:text>
				<xsl:text>KG</xsl:text>
				<xsl:text>&quot;</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:if test="InvoicedQuantity/@UnitOfMeasure != 'KGM'">
				<xsl:value-of select="InvoicedQuantity"/>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:if test="InvoicedQuantity/@UnitOfMeasure = 'KGM'">
				<xsl:value-of select="InvoicedQuantity"/>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<!-- "0" /-->

			<xsl:text>&quot;</xsl:text>
			<xsl:text>0</xsl:text>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>&quot;</xsl:text>
			<xsl:text>N</xsl:text>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>&quot;</xsl:text>
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
	
		</xsl:for-each>
	
	</xsl:template>

	<xsl:template name="formatDate">
		<xsl:param name="sInput"/>
	
		<xsl:value-of select="concat(substring($sInput,9,2),'/',substring($sInput,6,2),'/',substring($sInput,1,4))"/>
	
	</xsl:template>


</xsl:stylesheet>
