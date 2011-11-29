<!-- *******************************************************
Date	|Name		| Information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
27/07/2011| KOshaughnessy| FB4970 Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	|	|	|
************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="/Invoice">
	
		<!--Message header-->
		<xsl:text>UNH+</xsl:text>
		<!--Message reference number-->
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>+</xsl:text>
		<xsl:text>INVOIC:D:96A:UN:</xsl:text>
		<!--Association assigned code -->
		<xsl:text>EAN008</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to indicate the type and function of a message and to transmit the identifying number -->
		<xsl:text>BGM+</xsl:text>
		<!--To identify an invoice -->
		<xsl:text>380+</xsl:text>
		<!--Invoice number-->
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<!--Message function -->
		<xsl:text>+9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify the date or period of the invoice-->
		<xsl:text>DTM+</xsl:text>
		<!-- Date/time/period qualifier-->
		<xsl:text>137:</xsl:text>
		<!-- Date Format YYYYMMDD-->
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
		<!--	Date/time/period format qualifier-->
		<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify the date or period of the delivery note -->
		<xsl:text>DTM+</xsl:text>
		<!-- Date/time/period qualifier-->
		<xsl:text>35:</xsl:text>
		<!--Delivery Date	Date Format YYYYMMDD -->
		<xsl:value-of select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate"/>
		<!--Date/time/period format qualifier -->
		<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Delivery note reference -->
		<xsl:text>RFF+</xsl:text>
		<!--Reference qualifier -->
		<xsl:text>DQ:</xsl:text>
		<!--Delivery note reference number -->
		<xsl:value-of select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		<!--Purchase order reference -->
		
		<xsl:text>RFF+</xsl:text>
		<!--Reference qualifier -->
		<xsl:text>ON:</xsl:text>
		<!--Purchase Order Number	Reference number-->
		<xsl:value-of select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to identify the trading partners involved in the Order process-->
		<xsl:text>NAD+</xsl:text>
		<!--Party qualifier-->
		<xsl:text>BY+</xsl:text>
		<!--EAN Location Number EDI Code identifying the buyer-->
		<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
		<!--Code list responsible agency-->
		<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Trading partners -->
		<xsl:text>NAD+</xsl:text>
		<!--Party qualifier -->
		<xsl:text>SE+</xsl:text>
		<!-- Suppliers EAN Location Number-->
		<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/GLN"/>
		<!--Code list responsible agency, coded -->
		<xsl:text>::9</xsl:text>
		<xsl:text>++</xsl:text>
		<!--Suppliers name -->
		<xsl:value-of select="InvoiceHeader/Supplier/SuppliersName"/>
		<xsl:text>+</xsl:text>
		<!--Address line 1 -->
		<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/>
		<xsl:text>+</xsl:text>
		<!--City -->
		<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/>
		<xsl:text>++</xsl:text>
		<!--Post code-->
		<xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/PostCode"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to refer Harrods internal supplier number.-->
		<xsl:text>RFF+</xsl:text>
		<!--Reference qualifier -->
		<xsl:text>IA:</xsl:text>
		<!--Internal supplier number -->
		<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--References-->
		<xsl:text>RFF+</xsl:text>
		<!--Reference qualifier -->
		<xsl:text>VA:</xsl:text>
		<!--Suppliers VAT registration number -->
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Trading partners -->
		<xsl:text>NAD+</xsl:text>
		<!--Party qualifier  -->
		<xsl:text>IV+</xsl:text>
		<!--Unit EAN Location Number -->
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
		<xsl:text>::9</xsl:text>
		<xsl:text>++</xsl:text>
		<!--Name Invoicee -->
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/>
		<xsl:text>+</xsl:text>
		<!--Street and number -->
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/>
		<xsl:text>+</xsl:text>
		<!--City-->
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/>
		<xsl:text>++</xsl:text>
		<!--Post code -->
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/PostCode"/>
		<xsl:text>+</xsl:text>
		<!--Country -->
		<xsl:text>GB</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--References -->
		<xsl:text>RFF+</xsl:text>
		<!--Reference qualifier -->
		<xsl:text>VA:</xsl:text>
		<!--Buyers VAT registration number -->
		<!--xsl:value-of select=""/-->
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Trading partners -->
		<xsl:text>NAD+</xsl:text>
		<!--Party qualifier  -->
		<xsl:text>DP+</xsl:text>
		<!-- Ship to GLN-->
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
		<!--Code list responsible agency -->
		<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!-- Currencies-->
		<xsl:text>CUX+</xsl:text>
		<!--Currency details qualifier -->
		<xsl:text>2:</xsl:text>
		<!--Currency-->
		<xsl:text>GBP</xsl:text>
		<!--Currency qualifier-->
		<xsl:text>:4</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		<!--Currencies-->
		<xsl:text>PAT+</xsl:text>
		<!--Payment terms type qualifier-->
		<xsl:text>1</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify any dates associated with the payment terms for the invoice.-->
		<xsl:text>DTM+</xsl:text>
		<!--Date/time/period qualifier-->
		<xsl:text>13:</xsl:text>
		<!--Terms net due date YYYYMMDD-->
		<!--We do not currently hold this data in tradesimple -->
		<!--xsl:value-of select=""/-->
		<!--Date/time/period format qualifier-->
		<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to indicate the beginning of the detail section of the Invoice message. The detail section is formed by a repeating group of segments, always starting with a LIN segment-->
		<xsl:for-each select="InvoiceDetail/InvoiceLine">
			<xsl:text>LIN+</xsl:text>
			<xsl:text>1++</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>:EN::9</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
			<xsl:text>PIA+</xsl:text>
			<!--Product id. function qualifier-->
			<xsl:text>1+</xsl:text>
			<!--Customer reference-->
			<!--xsl:value-of select=""/-->
			<xsl:text>:</xsl:text>
			<!--Item number type-->
			<!--xsl:value-of select=""/-->
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<xsl:text>PIA+</xsl:text>
			<!--Product id. function qualifier-->
			<xsl:text>1+</xsl:text>
			<!--Supplier reference-->
			<!--xsl:value-of select=""/-->
			<xsl:text>:</xsl:text>
			<!--Item number type-->
			<!--xsl:value-of select=""/-->
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<xsl:text>IMD+</xsl:text>
			<!--Item description type-->
			<xsl:text>F++:::</xsl:text>
			<!--Description-->
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			<xsl:text>QTY+</xsl:text>
			<!--Quantity qualifier-->
			<xsl:text>47:</xsl:text>
			<!--Invoiced quantity-->
			<xsl:value-of select="InvoicedQuantity"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--Line amount-->
			<xsl:text>MOA+</xsl:text>
			<!--Monetary amount type -->
			<xsl:text>203:</xsl:text>
			<!--Line item amount-->
			<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine/LineValueExclVAT"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--unit value-->
			<xsl:text>PRI+</xsl:text>
			<!--Price qualifier-->
			<xsl:text>AAA:</xsl:text>
			<!--Net unit Price-->
			<xsl:value-of select="InvoiceDetail/InvoiceLine/UnitValueExclVAT/@ValidationResult"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<xsl:text>RFF+</xsl:text>
			<!--Reference qualifier-->
			<xsl:text>ON:</xsl:text>
			<!--CustomerPurchase Order Number-->
			<xsl:value-of select="../InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/>
			<!--Purchase Order Number Item-->
			<!--xsl:value-of select=""/-->
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<xsl:text>TAX+</xsl:text>
			<!--Duty/tax/fee function qualifier-->
			<xsl:text>7+</xsl:text>
			<!--Duty/tax/fee type-->
			<xsl:text>VAT</xsl:text>
			<xsl:text>+++:::</xsl:text>
			<!--Rate of tax-->
			<xsl:value-of select="VATRate"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<xsl:text>MOA+</xsl:text>
			<!--Monetary amount type qualifier-->
			<xsl:text>124:</xsl:text>
			<!--Tax amount-->
			<!--We dont currently hold the line VAT ammount-->
			<!--xsl:value-of select=""/-->
			<xsl:text>'&#13;&#10;</xsl:text>
		</xsl:for-each>
		
		<!--This segment is used to separate the detail and summary sections of the message.-->
		<xsl:text>UNS+</xsl:text>
		<!--Detail/summary section separation-->
		<xsl:text>S</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		<!--Document total excluding VAT-->
		<xsl:text>MOA+</xsl:text>
		<!--Monetary amount type qualifier-->
		<xsl:text>79:</xsl:text>
		<!--Sum of Total Value Line-->
		<xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--VAT ammount-->
		<xsl:text>MOA+</xsl:text>
		<!--Monetary amount type qualifier-->
		<xsl:text>176:</xsl:text>
		<!--Total amount of the taxes-->
		<xsl:value-of select="InvoiceTrailer/VATAmount"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Document total including VAT-->
		<xsl:text>MOA+</xsl:text>
		<!--Monetary amount type qualifier-->
		<xsl:text>86:</xsl:text>
		<!--total monetary amount-->
		<xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Line total at rate-->
		<xsl:text>MOA+</xsl:text>
		<!--Monetary amount type qualifier-->
		<xsl:text>125:</xsl:text>
		<!--Taxable amount-->
		<xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<xsl:for-each select="InvoiceTrailer/VATSubTotals">
			<xsl:text>TAX+</xsl:text>
			<!--Duty/tax/fee function qualifier-->
			<xsl:text>7+</xsl:text>
			<!--Duty/tax/fee type-->
			<xsl:text>VAT</xsl:text>
			<xsl:text>+++:::</xsl:text>
			<!--Duty/tax/fee rate-->
			<xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/@VATRate"/>
			<xsl:text>+</xsl:text>
			<!--VAT code-->
			<xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/@VATCode"/>
			<xsl:text>'&#13;&#10;</xsl:text>
		</xsl:for-each>
		
		<xsl:text>MOA+</xsl:text>
		<!--Monetary amount type qualifier-->
		<xsl:text>124:</xsl:text>
		<!--Total Tax amount-->
		<xsl:value-of select="/Invoice/InvoiceTrailer/VATAmount"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is a mandatory UN/EDIFACT segment. It must always be the last segment in the message.-->
		<xsl:text>UNT+</xsl:text>
		<!--The total number of segments in the message is detailed here-->
		<!--xsl:value-of select="count()"/-->
		<xsl:text>+</xsl:text>
		<!--Message reference number-->
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
	</xsl:template>
</xsl:stylesheet>
