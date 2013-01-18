<!-- *******************************************************
Date	|Name		| Information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
27/07/2011| KOshaughnessy| FB4970 Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
28/12/2012	|M Emanuel	| FB 5840 Harrods INV out mapper; added scripts to format and get date
************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:userfuncs="http://mycompany.com/mynamespace" >
	<xsl:output method="text"/>
	<xsl:template match="/Invoice">
	
		<xsl:variable name="sClockTime" select="userfuncs:getClockTime()"/>
	
		<!-- UNA Batch Header -->

		<xsl:text>UNA:</xsl:text>
		
		<xsl:text>+.? '</xsl:text>
		
		<xsl:text>&#13;&#10;</xsl:text>

			<xsl:text>UNB+</xsl:text>

			<!-- S001/0001, Syntax Identifier -->
			<xsl:text>UNOB:</xsl:text>
		
			<!-- S001/0002, Syntax Version Number -->
			<xsl:text>3+</xsl:text>
		
			<!-- S002/0004, Sender Identification -->
			<!--Our mailbox reference-->
			<xsl:choose>
				<xsl:when test="TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
					<xsl:text>5013546145710</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>5013546164209</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>+</xsl:text>
		
			<!-- S003/0010, Interchange recipient -->
			<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>+</xsl:text>
		
			<!-- S004/0017, Date -->
			<xsl:value-of select="userfuncs:getDate()"/>
			<xsl:text>:</xsl:text>
		
			<!-- S004/0019, Time -->
			<xsl:value-of select="$sClockTime"/>
			<xsl:text>+</xsl:text>
		
			<!-- 0020, control reference -->
			<xsl:value-of select="InvoiceHeader/BatchInformation/FileGenerationNo"/>
			<!--
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>ORDERS</xsl:text>
			-->
			<xsl:text>'</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
			
		<!-- HR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	
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
		<xsl:call-template name="msFormatDate">
			<xsl:with-param name="vsUTCDate" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
		</xsl:call-template>
		<!--	Date/time/period format qualifier-->
		<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify the date or period of the delivery note -->
		<xsl:text>DTM+</xsl:text>
		<!-- Date/time/period qualifier-->
		<xsl:text>35:</xsl:text>
		<!--Delivery Date	Date Format YYYYMMDD -->
		<xsl:call-template name="msFormatDate">
			<xsl:with-param name="vsUTCDate" select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate"/>
		</xsl:call-template>
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
		<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
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
		<xsl:text>0604619000002</xsl:text>
		<xsl:text>::9</xsl:text>
		<xsl:text>++</xsl:text>
		<!--Name Invoicee -->
		<xsl:value-of select="substring(InvoiceHeader/ShipTo/ShipToName,1,34)"/>
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
		<xsl:text>GB629273423</xsl:text>
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
		<!--We do not currently hold this data in tradesimple, but since Harrods insisted on this, populating this field with the invoice date -->
		<xsl:call-template name="msFormatDate">
			<xsl:with-param name="vsUTCDate" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
		</xsl:call-template>
		<!--Date/time/period format qualifier-->
		<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to indicate the beginning of the detail section of the Invoice message. The detail section is formed by a repeating group of segments, always starting with a LIN segment-->
		<xsl:for-each select="InvoiceDetail/InvoiceLine">
			<xsl:text>LIN+</xsl:text>
			<xsl:value-of select="position()"/>
			<xsl:text>++</xsl:text>
			<xsl:value-of select="ProductID/GTIN"/>
			<xsl:text>:EN</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
			<xsl:text>PIA+</xsl:text>
			<!--Product id. function qualifier-->
			<xsl:text>1+</xsl:text>
			<!--Customer reference-->
			<xsl:value-of select="ProductID/BuyersProductCode"/>
			<xsl:text>:IN</xsl:text>
			<!--Item number type-->
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<xsl:text>PIA+</xsl:text>
			<!--Product id. function qualifier-->
			<xsl:text>1+</xsl:text>
			<!--Supplier reference-->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>:SA</xsl:text>
			<!--Item number type-->
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
			<xsl:text>:</xsl:text>
			<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--Line amount-->
			<xsl:text>MOA+</xsl:text>
			<!--Monetary amount type -->
			<xsl:text>203:</xsl:text>
			<!--Line item amount-->
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--Net unit Price-->
			<xsl:text>PRI+</xsl:text>
			<!--Price qualifier-->
			<xsl:text>AAA:</xsl:text>
			<!--Net unit Price-->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--Gross Unit Price-->
			<xsl:text>PRI+</xsl:text>
			<!--Price qualifier-->
			<xsl:text>AAB:</xsl:text>
			<!--Net unit Price-->
			<xsl:choose>
				<xsl:when test="LineDiscountValue > 0">
					<xsl:value-of select="format-number(UnitValueExclVAT - LineDiscountValue,'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="UnitValueExclVAT"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--CustomerPurchase Order Number-->
			<xsl:text>RFF+</xsl:text>
			<!--Reference qualifier-->
			<xsl:text>ON:</xsl:text>
			<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
			<!--Purchase Order Number Item-->
			<xsl:text>:</xsl:text>
			<xsl:value-of select="LineNumber"/>
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
			<!--We dont currently hold the line VAT ammount, but populating it as Harrod's need this information to process invoices-->
			<xsl:value-of select="format-number(LineValueExclVAT * (VATRate div 100),'0.00')"/>
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
		
		<!--Line total at rate-->
		<xsl:text>MOA+</xsl:text>
		<!--Monetary amount type qualifier-->
		<xsl:text>125:</xsl:text>
		<!--Taxable amount-->
		<xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
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
		
		<xsl:for-each select="InvoiceTrailer/VATSubTotals">
			<xsl:text>TAX+</xsl:text>
			<!--Duty/tax/fee function qualifier-->
			<xsl:text>7+</xsl:text>
			<!--Duty/tax/fee type-->
			<xsl:text>VAT</xsl:text>
			<xsl:text>+++:::</xsl:text>
			<!--Duty/tax/fee rate-->
			<xsl:value-of select="VATSubTotal/@VATRate"/>
			<!--xsl:text>+</xsl:text-->
			<!--VAT code-->
			<!--xsl:value-of select="VATSubTotal/@VATCode"/-->
			<xsl:text>'&#13;&#10;</xsl:text>
		</xsl:for-each>
		
			
		<xsl:text>MOA+</xsl:text>
		<!--Monetary amount type qualifier-->
		<xsl:text>124:</xsl:text>
		<!--Total Tax amount-->
		<xsl:value-of select="InvoiceTrailer/VATAmount"/>
		<xsl:text>'&#13;&#10;</xsl:text>
			
		<xsl:text>MOA+</xsl:text>
		<!--Monetary amount type qualifier-->
		<xsl:text>125:</xsl:text>
		<!--Total Tax amount-->
		<xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		

		<!--This segment is a mandatory UN/EDIFACT segment. It must always be the last segment in the message.-->
		<xsl:text>UNT+</xsl:text>
		<!--The total number of segments in the message is detailed here-->
		<xsl:variable name="TotalLines" select="count(//InvoiceLine)"/>		
			
			<xsl:choose>
				<xsl:when test="$TotalLines = 1">
					<xsl:text>36</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="($TotalLines) * 19 + 17"/>
				</xsl:otherwise>
			</xsl:choose>
		<xsl:text>+</xsl:text>
		<!--Message reference number-->
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!-- HR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		
		<!-- UNZ, Batch Trailer -->
		<xsl:text>UNZ+</xsl:text>
			
			<!-- 0036, Interchange Control Count -->
			
			<xsl:text>1+</xsl:text>
			
			<!--	 0020, Interchange Control Reference -->
			<xsl:value-of select="InvoiceHeader/BatchInformation/FileGenerationNo"/>
			<xsl:text>'</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
		
	</xsl:template>
	
	<!--=======================================================================================
  Routine        : msFormateDate()
  Description    :  
  Inputs         : vsUTCDate
  Outputs        : 
  Returns        : A string
  Author         : M Emanuel
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msFormatDate">
		<xsl:param name="vsUTCDate"/>
	
		<xsl:value-of select="translate($vsUTCDate,'-','')"/>
	
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="userfuncs">
	<![CDATA[
		//Get a properly formatted version of todays date
		function getDate() {
			var now;
			var day, month, year;
			now = new Date();
			curYear = now.getFullYear();
			curYear = curYear.toString().slice(2);
			month = now.getMonth()+1;
			day = now.getDate();
			
			if (day.toString().length < 2 )
				day = '0' + day;

			if (month.toString().length < 2)
				month = '0' + month;
	
			return (curYear + month + day);
		}
		

      function getClockTime() {
  
	     var currentTime = new Date()
	     var hours = currentTime.getHours()     
	     hours = hours.toString();
	     var minutes = currentTime.getMinutes()
	     minutes = minutes.toString();
	     
	     if (hours.toString().length < 2 )
	     hours = '0' + hours;     
	   
	     if (minutes.toString().length < 2 )
	     minutes = '0' + minutes;
	      
	     return (hours + minutes);
	}
	]]>
 </msxsl:script>
	
</xsl:stylesheet>
