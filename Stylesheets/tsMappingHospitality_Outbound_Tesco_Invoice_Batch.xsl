<?xml version="1.0" encoding="UTF-8"?>
<!-- 

NOTES:

This has been written specifically for Bibendum to Tesco, for other suppliers we may need to extend the logic, 
particularly around the Delviery Quantities and so on.  Tesco have some pretty complex logic around catchweight 
etc. which don't apply to Bibendum.


-->



<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                              xmlns:HelperObj="urn:XSLHelper">

	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:param name="sDocumentDate">Not Provided</xsl:param>
	<xsl:param name="sDocumentTime">Not Provided</xsl:param>
	<xsl:param name="nBatchID">Not Provided</xsl:param>
	<xsl:param name="nLastBatchID">Not Provided</xsl:param>

	<xsl:template match="/BatchRoot">
		
		<xsl:value-of select="HelperObj:ResetCounter('MessageRefNo')"/>
		<xsl:value-of select="HelperObj:ResetCounter('InvoiceLineNo')"/>

	
			<!-- Segment -->
			<xsl:text>UNB+</xsl:text>		
				<!-- S001, Syntax Identifier -->
					<!-- 0001, Identifier -->
					<xsl:text>UNOA</xsl:text>
					<xsl:text>:</xsl:text>
					<!-- 0002, Version -->
					<xsl:text>3</xsl:text>
					<xsl:text>+</xsl:text>
				<!-- S002, Interchange Sender -->
					<!-- 0004, Sender Identification -->
					<!--xsl:choose>
						<xsl:when test="count(Invoice[./TradeSimpleHeader/TestFlag = 'false' or ./TradeSimpleHeader/TestFlag = 'FALSE' or ./TradeSimpleHeader/TestFlag = 'False' or ./TradeSimpleHeader/TestFlag = '0']) != 0">
							<xsl:text>5013546145710</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>5013546164209</xsl:text>
						</xsl:otherwise>
					</xsl:choose-->
					<!--Bibendum's ANA reference-->
					<xsl:text>5013546164209</xsl:text>
					<xsl:text>:</xsl:text>
					<!-- 0007, Partner Identification Qualifier -->
					<xsl:text>14</xsl:text>
					<xsl:text>+</xsl:text>
				<!-- S003, Interchange Recipient -->
					<!-- 0010, REcipient Identification -->
					<!--xsl:choose>
						<xsl:when test="count(Invoice[./TradeSimpleHeader/TestFlag = 'false' or ./TradeSimpleHeader/TestFlag = 'FALSE' or ./TradeSimpleHeader/TestFlag = 'False' or ./TradeSimpleHeader/TestFlag = '0']) != 0"-->
							<xsl:text>5000119000006</xsl:text>
						<!--/xsl:when>
						<xsl:otherwise>
							<xsl:text>5000119000019</xsl:text>
						</xsl:otherwise>
					</xsl:choose-->
					<xsl:text>:</xsl:text>
					<!-- 0007, Partner Identification Qualifier -->
					<xsl:text>14</xsl:text>
					<xsl:text>+</xsl:text>
				<!-- S004, Date of Preparation -->
					<!-- 0017, Date -->
					<xsl:value-of select="$sDocumentDate"/>
					<xsl:text>:</xsl:text>
					<!-- 0019, Time -->
					<xsl:value-of select="substring($sDocumentTime,1,4)"/>
					<xsl:text>+</xsl:text>
				<!-- 0020, Interchange Control reference -->
					<!-- 5 digit tesco supplier number -->
					<xsl:value-of select="substring-after(//TradeSimpleHeader[1]/RecipientsCodeForSender,'~')"/>
					<!-- 4 Digit Version -->
					<xsl:text>0001</xsl:text>
					<!-- Generation Number -->
					<xsl:value-of select="$nBatchID"/>
					<!-- Zero, a check digit that isn't checked -->
					<xsl:text>0</xsl:text>
					<xsl:text>+</xsl:text>
				<!-- unknown -->
					<xsl:text>+</xsl:text>
				<!-- Application Reference -->
					<xsl:text>INVOIC</xsl:text>
					<xsl:if test="count(Invoice[./TradeSimpleHeader/TestFlag = 'false' or ./TradeSimpleHeader/TestFlag = 'FALSE' or ./TradeSimpleHeader/TestFlag = 'False' or ./TradeSimpleHeader/TestFlag = '0']) = 0">
						<xsl:text>+</xsl:text>
						<xsl:text>+</xsl:text>
						<xsl:text>+</xsl:text>
						<xsl:text>+</xsl:text>
						<!-- 0035, Test Indicator -->
						<xsl:text>1</xsl:text>
					</xsl:if>
				<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

				<xsl:for-each select="Invoice">
				
					<!-- UNH Segment, Start of message -->
					<xsl:text>UNH</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 0062, Message Reference Number -->
							<xsl:value-of select="HelperObj:GetNextCounterValue('MessageRefNo')"/>
							<xsl:text>+</xsl:text>
						<!-- S009, Message Identifier -->
							<!-- 0065, Identifier -->
							<xsl:text>INVOIC</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 0052, Version Number -->
							<xsl:text>D</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 0054, Release Number -->
							<xsl:text>96A</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 0051, Controlling Agency -->
							<xsl:text>UN</xsl:text>					
							<xsl:text>:</xsl:text>
							<!-- 0057, Association Assigned Code -->
							<xsl:text>EAN008</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

					
					
					<!-- BGM Segment, Begin Message -->
					<xsl:text>BGM</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C002, Document/Message Name -->
							<!-- 1001, Name (coded) -->
							<xsl:text>380</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- 1004, Invoice Number -->
							<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
						<!-- 1225, Message Function, coded -->
							<xsl:text>9</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>




					<!-- DTM Segment, Document/Message Date -->
					<xsl:text>DTM</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C507 -->
							<!-- 2007, Qualifier -->
							<xsl:text>137</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 2380, Document Message Date -->
							<xsl:call-template name="convDate">
								<xsl:with-param name="sDate">
									<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:</xsl:text>
							<!-- 2379, Format Qualifier -->
							<xsl:text>102</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>




					<!-- RFF Segment, Delivery Note Details -->
					<xsl:text>RFF</xsl:text>					
					<xsl:text>+</xsl:text>
						<!-- C506, Reference Qualifier -->
							<!-- 1153, Reference Qualifier -->
							<xsl:text>DQ</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 1154, Delivery Note Reference -->
							<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

					

					<!-- DTM Segment, Delivery Note date -->
					<xsl:text>DTM</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C507 -->
							<!-- 2005, Qualifer -->
							<xsl:text>171</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 2380, Delivery Note Date -->
							<xsl:call-template name="convDate">
								<xsl:with-param name="sDate">
									<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:</xsl:text>
							<!-- 2379, Format Qualifier -->
							<xsl:text>102</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

					


					<!-- RFF Segment, Purchase Order Details -->
					<xsl:text>RFF</xsl:text>					
					<xsl:text>+</xsl:text>
						<!-- C506, Reference Qualifier -->
							<!-- 1153, Reference Qualifier -->
							<xsl:text>ON</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 1154, Delivery Note Reference -->
							<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

					

					<!-- DTM Segment, Purchase Order date -->
					<xsl:text>DTM</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C507 -->
							<!-- 2005, Qualifer -->
							<xsl:text>171</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 2380, Delivery Note Date -->
							<xsl:call-template name="convDate">
								<xsl:with-param name="sDate">
									<!--xsl:value-of select="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/-->
									<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:</xsl:text>
							<!-- 2379, Format Qualifier -->
							<xsl:text>102</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

							
							
					
					
					<!-- NAD Segment, Seller Name and Address -->
					<xsl:text>NAD</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 3035, Party Qualifier -->
							<xsl:text>SE</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C082, Party ID -->
							<!-- 3039, Party Identification -->
							<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'~')"/>
							<xsl:text>:</xsl:text>
							<!-- unknown -->
							<xsl:text>:</xsl:text>
							<!-- 3055, Code List responsible agency -->
							<xsl:text>9</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C058, Name and Address -->
							<xsl:text>+</xsl:text>
						<!-- C080, supplier name -->
							<!-- 3036, name -->
							<xsl:value-of select="js:msTruncate(string(InvoiceHeader/Supplier/SuppliersName),35)"/>
							<!--xsl:text>+</xsl:text-->
						<!-- C059, Supplier Address -->
							<!-- 3042, Street -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/Supplier/SuppliersAddress/AddressLine1),35)"/-->
							<!--xsl:text>:</xsl:text-->
							<!-- 3164, City -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/Supplier/SuppliersAddress/AddressLine2),35)"/-->
							<!--xsl:text>:</xsl:text-->
							<!-- 3229, Country sub-entry -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/Supplier/SuppliersAddress/AddressLine3),9)"/-->
							<!--xsl:text>:</xsl:text-->
							<!-- 3251, PostCode -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/Supplier/SuppliersAddress/PostCode),9)"/-->
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


					<!-- RFF Segment, Suppliers VAT Number -->
					<xsl:text>RFF</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C506, Reference Qualifier -->
							<!-- 1153, Reference Qualifier -->
							<xsl:text>VA</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 1154, Seller's VAT Number -->
							<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>



					<!-- NAD Segment, Buyer Name and Address -->
					<xsl:text>NAD</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 3035, Party Qualifier -->
							<xsl:text>BY</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C082, Party ID -->
							<!-- 3039, Party Identification -->
							<xsl:text>5000119000006</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- unknown -->
							<xsl:text>:</xsl:text>
							<!-- 3055, Code List responsible agency -->
							<xsl:text>9</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C058, Name and Address -->
							<xsl:text>+</xsl:text>
						<!-- C080, buyer name -->
							<!-- 3036, name -->
							<xsl:text>TESCO STORES LTD</xsl:text>
							<!--xsl:text>+</xsl:text-->
						<!-- C059, buyers Address -->
							<!-- 3042, Street -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/Buyer/BuyersAddress/AddressLine1),35)"/-->
							<!--xsl:text>:</xsl:text-->
							<!-- 3164, City -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/Buyer/BuyersAddress/AddressLine2),35)"/-->
							<!--xsl:text>:</xsl:text-->
							<!-- 3229, Country sub-entry -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/Buyer/BuyersAddress/AddressLine3),9)"/-->
							<!--xsl:text>:</xsl:text-->
							<!-- 3251, PostCode -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/Buyer/BuyersAddress/PostCode),9)"/-->
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

					<!-- RFF Segment, Suppliers VAT Number -->
					<xsl:text>RFF</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C506, Reference Qualifier -->
							<!-- 1153, Reference Qualifier -->
							<xsl:text>VA</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 1154, Seller's VAT Number -->
							<xsl:text>220430231</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


					<!-- NAD Segment, Buyer Name and Address -->
					<xsl:text>NAD</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 3035, Party Qualifier -->
							<xsl:text>SN</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C082, Party ID -->
							<!-- 3039, Party Identification -->
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
							<xsl:text>:</xsl:text>
							<!-- unknown -->
							<xsl:text>:</xsl:text>
							<!-- 3055, Code List responsible agency -->
							<xsl:text>9</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C058, Name and Address -->
							<xsl:text>+</xsl:text>
						<!-- C080, buyer name -->
							<!-- 3036, name -->
							<xsl:value-of select="js:msTruncate(string(InvoiceHeader/ShipTo/ShipToAddress/AddressLine1),35)"/>
							<!--xsl:text>+</xsl:text-->
						<!-- C059, buyers Address -->
							<!-- 3042, Street -->
							<!--xsl:text>:</xsl:text-->
							<!-- 3164, City -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/ShipTo/ShipToAddress/AddressLine2),35)"/-->
							<!--xsl:text>:</xsl:text-->
							<!-- 3229, Country sub-entry -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/ShipTo/ShipToAddress/AddressLine3),9)"/-->
							<!--xsl:text>:</xsl:text-->
							<!-- 3251, PostCode -->
							<!--xsl:value-of select="js:msTruncate(string(InvoiceHeader/ShipTo/ShipToAddress/PostCode),9)"/-->
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>




					<!-- CUX Segment, Invoicing Currencies -->
					<xsl:text>CUX</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C504, Reference Currency Details -->
							<!-- 6347, Reference Currency Qualifier -->
							<xsl:text>2</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 6345, Invoicing Currency (coded) -->
							<xsl:value-of select="InvoiceHeader/Currency"/>
							<xsl:text>:</xsl:text>
							<!-- 6343, Currency Qualifier -->
							<xsl:text>4</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>






					<xsl:for-each select="InvoiceDetail/InvoiceLine">
					
						<!-- LIN Segment, Line Item -->
						<xsl:text>LIN</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- 1082, Line Item Number -->
								<xsl:value-of select="HelperObj:GetNextCounterValue('InvoiceLineNo')"/>
								<xsl:text>+</xsl:text>
								<!-- unknown -->
								<xsl:text>+</xsl:text>
							<!-- C212, Item Number -->
								<!-- 7140, Item Number -->
								<xsl:value-of select="ProductID/BuyersProductCode"/>
								<xsl:text>:</xsl:text>
								<!-- 7143, Item Number Type -->
								<xsl:text>EN</xsl:text>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

					
					
					
						<!-- IMD Segment, Item Description -->
						<xsl:text>IMD</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- 7077, Item Description type -->
								<xsl:text>F</xsl:text>
								<xsl:text>+</xsl:text>
							<!-- unknown -->
								<xsl:text>+</xsl:text>
							<!-- C273, Item Description -->
								<!-- 7009, Identification -->
								<xsl:text>TU</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- unknown -->
								<xsl:text>:</xsl:text>
								<!-- unknown -->
								<xsl:text>:</xsl:text>
								<!-- 7008, Description, free form -->
								<xsl:value-of select="js:msTruncate(string(ProductDescription),35)"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


						<!-- QTY Segment, Delivered Quantity -->
						<xsl:text>QTY</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C186, Delivered Quantity -->
								<!-- 6063, Qualifier -->
								<xsl:text>47</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 6060, Invoiced Quantity -->
								<!--xsl:value-of select="format-number(InvoicedQuantity div Measure/UnitsInPack,'0.00')"/-->
								<xsl:value-of select="format-number(InvoicedQuantity,'0.00')"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>



						<!-- QTY Segment, Units in Case -->
						<xsl:text>QTY</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C186, Delivered Quantity -->
								<!-- 6063, Qualifier -->
								<xsl:text>59</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 6060, Units in case -->
								<xsl:value-of select="Measure/UnitsInPack"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>
				
				
				
						<!-- MOA Segment, Net Monetary Amount -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>66</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Net Line Item Amount -->
								<xsl:value-of select="LineValueExclVAT"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>



						<!-- MOA Segment, Gross Monetary Amount -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>203</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Gross Line Item Amount -->
								<xsl:value-of select="LineValueExclVAT"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

						

						<!-- PRI Segment, Net Price Details -->
						<xsl:text>PRI</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C509, net price -->
								<!-- 5125, Qualifier -->
								<xsl:text>AAA</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5118, Net Price -->
								<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>



						<!-- PRI Segment, Gross Price Details -->
						<xsl:text>PRI</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C509, gross price -->
								<!-- 5125, Qualifier -->
								<xsl:text>AAB</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5118, gross Price -->
								<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>



						<!-- TAX Segment, Tax Detail -->
						<xsl:text>TAX</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- 5283, Qualifier -->
								<xsl:text>7</xsl:text>
								<xsl:text>+</xsl:text>
							<!-- C241 -->
								<!-- Duty/Tax type coded -->
								<xsl:text>VAT</xsl:text>
								<xsl:text>+</xsl:text>
							<!-- unknown -->
								<xsl:text>+</xsl:text>
							<!-- unknown -->
								<xsl:text>+</xsl:text>
							<!-- C243, Tax Rate for Line -->
								<!-- unknown -->
								<xsl:text>:</xsl:text>
								<!-- unknown -->
								<xsl:text>:</xsl:text>
								<!-- unknown -->
								<xsl:text>:</xsl:text>
								<!-- 5278, Tax Rate -->
								<xsl:value-of select="VATRate"/>
								<xsl:text>+</xsl:text>
							<!-- 5305, Tax Category -->
								<xsl:value-of select="VATCode"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


						<!-- MOA Segment, Tax Amount -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>124</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Tax Line Item Amount -->
								<xsl:value-of select="format-number(LineValueExclVAT * (VATRate div 100),'0.00')"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

					
					</xsl:for-each>


				<!-- UNS Segment -->
				<xsl:text>UNS</xsl:text>
				<xsl:text>+</xsl:text>
					<!-- 0081, Detail/Summary Section Separation -->
					<xsl:text>S</xsl:text>
					<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


				<!-- CNT Segment, Count of Lines -->
				<xsl:text>CNT</xsl:text>
				<xsl:text>+</xsl:text>
					<!-- C270 Line Item count -->
						<!-- 6069, Qualifier -->
						<xsl:text>2</xsl:text>
						<xsl:text>:</xsl:text>
						<!-- 6066, Number of Lines -->
						<xsl:value-of select="InvoiceTrailer/NumberOfLines"/>
						<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


						<!-- MOA Segment, Net Invoice Value -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>9</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Tax Line Item Amount -->
								<xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


						<!-- MOA Segment, Gross Invoice Value -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>79</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Tax Line Item Amount -->
								<xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


					<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
						<!-- TAX Segment, Tax Detail -->
						<xsl:text>TAX</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- 5283, Qualifier -->
								<xsl:text>7</xsl:text>
								<xsl:text>+</xsl:text>
							<!-- C241 -->
								<!-- Duty/Tax type coded -->
								<xsl:text>VAT</xsl:text>
								<xsl:text>+</xsl:text>
							<!-- unknown -->
								<xsl:text>+</xsl:text>
							<!-- unknown -->
								<xsl:text>+</xsl:text>
							<!-- C243, Tax Rate for Line -->
								<!-- unknown -->
								<xsl:text>:</xsl:text>
								<!-- unknown -->
								<xsl:text>:</xsl:text>
								<!-- unknown -->
								<xsl:text>:</xsl:text>
								<!-- 5278, Tax Rate -->
								<xsl:value-of select="@VATRate"/>
								<xsl:text>+</xsl:text>
							<!-- 5305, Tax Category -->
								<xsl:value-of select="@VATCode"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


						<!-- MOA Segment, Net Invoice Value -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>124</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Tax Line Item Amount -->
								<xsl:value-of select="VATAmountAtRate"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


						<!-- MOA Segment, Net Invoice Value -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>125</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Tax Line Item Amount -->
								<xsl:value-of select="DocumentTotalExclVATAtRate"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>





					</xsl:for-each>



					<!-- UNT Segment, Message Trailer -->
					<xsl:text>UNT</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 0074, Number of Segments in message -->
						<xsl:value-of select="18 + (count(InvoiceDetail/InvoiceLine) * 10) + (count(InvoiceTrailer/VATSubTotals/VATSubTotal) * 3)"/>
						<xsl:text>+</xsl:text>
						<!-- 0062, Message Reference Number -->
						<xsl:value-of select="HelperObj:GetCurrentCounterValue('MessageRefNo')"/>
						<xsl:text>'</xsl:text>

					
					<xsl:text>&#13;&#10;</xsl:text>

				</xsl:for-each>

				<!-- UNH, Tax Control Message Header -->
					<xsl:text>UNH</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 0062, Message Reference Number -->
							<xsl:value-of select="HelperObj:GetNextCounterValue('MessageRefNo')"/>
							<xsl:text>+</xsl:text>
						<!-- S009, Message Identifier -->
							<!-- 0065, Identifier -->
							<xsl:text>TAXCON</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 0052, Version Number -->
							<xsl:text>D</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 0054, Release Number -->
							<xsl:text>96A</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 0051, Controlling Agency -->
							<xsl:text>EN</xsl:text>					
							<xsl:text>:</xsl:text>
							<!-- 0057, Association Assigned Code -->
							<xsl:text>EAN002</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

				
					<!-- BGM Segment, Begin Message -->
					<xsl:text>BGM</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C002, Document/Message Name -->
							<!-- 1001, Name (coded) -->
							<xsl:text>938</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- 1004, Document Number, Interchange control reference -->
							<!-- 5 digit tesco supplier number -->
							<xsl:value-of select="substring-after(//TradeSimpleHeader[1]/RecipientsCodeForSender,'~')"/>
							<!-- 4 Digit Version -->
							<xsl:text>0001</xsl:text>
							<!-- Generation Number -->
							<xsl:value-of select="$nBatchID"/>
							<!-- Zero, a check digit that isn't checked -->
							<xsl:text>0</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- 1225, Message Function, coded -->
							<xsl:text>9</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>




					<!-- DTM Segment, Document/Message Date -->
					<xsl:text>DTM</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C507 -->
							<!-- 2007, Qualifier -->
							<xsl:text>137</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 2380, Document Message Date -->
							<xsl:value-of select="concat('20',$sDocumentDate)"/>
							<xsl:text>:</xsl:text>
							<!-- 2379, Format Qualifier -->
							<xsl:text>102</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


					<!-- RFF Segment, Delivery Note Details -->
					<xsl:text>RFF</xsl:text>					
					<xsl:text>+</xsl:text>
						<!-- C506, Reference Qualifier -->
							<!-- 1153, Reference Qualifier -->
							<xsl:text>ALT</xsl:text>
							<xsl:text>:</xsl:text>
						<!-- 1154, Previous Tax Control Reference Number -->
							<!-- 5 digit tesco supplier number -->
							<xsl:value-of select="substring-after(//TradeSimpleHeader[1]/RecipientsCodeForSender,'~')"/>
							<!-- 4 Digit Version -->
							<xsl:text>0001</xsl:text>
							<!-- Generation Number -->
							<xsl:value-of select="$nLastBatchID"/>
							<!-- Zero, a check digit that isn't checked -->
							<xsl:text>0</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

					

					<!-- DTM Segment, Delivery Note date -->
					<xsl:text>DTM</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C507 -->
							<!-- 2005, Qualifer -->
							<xsl:text>171</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 2380, Document Date -->
							<xsl:value-of select="concat('20',$sDocumentDate)"/>
							<xsl:text>:</xsl:text>
							<!-- 2379, Format Qualifier -->
							<xsl:text>102</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>
				
				
					<!-- NAD Segment, Buyer Name and Address -->
					<xsl:text>NAD</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 3035, Party Qualifier -->
							<xsl:text>BY</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C082, Party ID -->
							<!-- 3039, Party Identification -->
							<xsl:text>5000119000006</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- unknown -->
							<xsl:text>:</xsl:text>
							<!-- 3055, Code List responsible agency -->
							<xsl:text>9</xsl:text>
							<xsl:text>+</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C080, buyer name -->
							<!-- 3036, name -->
							<xsl:text>TESCO STORES LTD</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>
				
					<!-- NAD Segment, Seller Name and Address -->
					<xsl:text>NAD</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 3035, Party Qualifier -->
							<xsl:text>SE</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C082, Party ID -->
							<!-- 3039, Party Identification -->
							<xsl:value-of select="substring-before(Invoice[1]/TradeSimpleHeader/RecipientsCodeForSender,'~')"/>
							<xsl:text>:</xsl:text>
							<!-- unknown -->
							<xsl:text>:</xsl:text>
							<!-- 3055, Code List responsible agency -->
							<xsl:text>9</xsl:text>
							<xsl:text>+</xsl:text>
							<xsl:text>+</xsl:text>
						<!-- C080, supplier name -->
							<!-- 3036, name -->
							<xsl:value-of select="js:msTruncate(string(Invoice[1]/InvoiceHeader/Supplier/SuppliersName),35)"/>
							<xsl:text>+</xsl:text>
							<xsl:value-of select="js:msTruncate(string(Invoice[1]/InvoiceHeader/Supplier/SuppliersAddress/AddressLine1),35)"/>
							<xsl:text>+</xsl:text>
							<xsl:value-of select="js:msTruncate(string(Invoice[1]/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2),35)"/>
							<xsl:text>+</xsl:text>
							<xsl:value-of select="js:msTruncate(string(Invoice[1]/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3),9)"/>
							<xsl:text>+</xsl:text>
							<xsl:value-of select="js:msTruncate(string(Invoice[1]/InvoiceHeader/Supplier/SuppliersAddress/PostCode),9)"/>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>
				
					<!-- RFF Segment, Suppliers VAT Number -->
					<xsl:text>RFF</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C506, Reference Qualifier -->
							<!-- 1153, Reference Qualifier -->
							<xsl:text>VA</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 1154, Seller's VAT Number -->
							<xsl:value-of select="Invoice[1]/InvoiceHeader/InvoiceReferences/VATRegNo"/>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>



				<!-- UNS Segment -->
				<xsl:text>UNS</xsl:text>
				<xsl:text>+</xsl:text>
					<!-- 0081, Detail/Summary Section Separation -->
					<xsl:text>D</xsl:text>
					<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>
				
				
					<!-- RFF Segment, Delivery Note Details -->
					<xsl:text>RFF</xsl:text>					
					<xsl:text>+</xsl:text>
						<!-- C506, Reference Qualifier -->
							<!-- 1153, Reference Qualifier -->
							<xsl:text>ALL</xsl:text>
							<xsl:text>:</xsl:text>
						<!-- 1154, Previous Tax Control Reference Number -->
							<!-- 5 digit tesco supplier number -->
							<xsl:value-of select="substring-after(//TradeSimpleHeader[1]/RecipientsCodeForSender,'~')"/>
							<!-- 4 Digit Version -->
							<xsl:text>0001</xsl:text>
							<!-- Generation Number -->
							<xsl:value-of select="$nBatchID"/>
							<!-- Zero, a check digit that isn't checked -->
							<xsl:text>0</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

					

					<!-- DTM Segment, Delivery Note date -->
					<xsl:text>DTM</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C507 -->
							<!-- 2005, Qualifer -->
							<xsl:text>171</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 2380, Document Date -->
							<xsl:value-of select="concat('20',$sDocumentDate)"/>
							<xsl:text>:</xsl:text>
							<!-- 2379, Format Qualifier -->
							<xsl:text>102</xsl:text>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>
				
				
				
				<!-- DOC Segment, Document Totals -->
				<xsl:text>DOC</xsl:text>
				<xsl:text>+</xsl:text>
					<!-- C002, Document Name -->
					<xsl:text>380</xsl:text>
					<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


					
						<!-- MOA Segment, Gross Invoice Value -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>128</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Tax Line Item Amount -->
								<xsl:value-of select="format-number(sum(Invoice/InvoiceTrailer/DocumentTotalInclVAT),'0.00')"/>
								<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>


					<!-- CNT Segment, Count of Invoices -->
					<xsl:text>CNT</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- C270 Control -->
							<!-- 6069, Qualifier -->
							<xsl:text>31</xsl:text>
							<xsl:text>:</xsl:text>
							<!-- 6066, Number of Invoices in transmission -->
							<xsl:value-of select="count(Invoice)"/>
							<xsl:text>'</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>

							
							

					<xsl:variable name="nsTaxRates">
						<xsl:copy-of select="/"/>
						<xsl:for-each select="Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal">
							<xsl:sort select="number(@VATRate)"/>
							<xsl:if test="position() = 1 or (number(./@VATRate) != number(preceding-sibling::*[1]/@VATRate))">
								<Line>
									<VatCode>
										<xsl:value-of select="@VATCode"/>
									</VatCode>
									<VatRate>
										<xsl:value-of select="@VATRate"/>
									</VatRate>
								</Line>
							</xsl:if>
						
						</xsl:for-each>
					</xsl:variable>


					<xsl:for-each select="msxsl:node-set($nsTaxRates)/Line">
					
					

						<xsl:text>TAX</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- 5283, Qualifier -->
							<xsl:text>7</xsl:text>
							<xsl:text>+</xsl:text>
							<!-- C241, tax type coded -->
							<xsl:text>VAT</xsl:text>
							<xsl:text>+</xsl:text>
							<!-- unknown -->
							<xsl:text>+</xsl:text>
							<!-- unknown -->
							<xsl:text>+</xsl:text>
							<!-- unknown -->
							<xsl:text>:</xsl:text>
							<!-- unknown -->
							<xsl:text>:</xsl:text>
							<!-- unknown -->
							<xsl:text>:</xsl:text>
							<!-- 5278, Tax Rate -->
							<xsl:value-of select="VatRate"/>
							<xsl:text>+</xsl:text>
							<!-- 5305, Tax Category -->
							<xsl:value-of select="VatCode"/>
							<xsl:text>'</xsl:text>
						<xsl:text>&#13;&#10;</xsl:text>



						<!-- MOA Segment, Tax Amount for Rate -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>124</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Tax Line Item Amount -->
								<xsl:value-of select="format-number(sum(msxsl:node-set($nsTaxRates)/BatchRoot/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal[number(@VATRate) = number(current()/VatRate)]/VATAmountAtRate),'0.00')"/>
								<!-- Currency -->
								<xsl:text>:</xsl:text>
								<xsl:value-of select="/BatchRoot/Invoice/InvoiceHeader/Currency"/>
								<xsl:text>:</xsl:text>
								<xsl:text>4</xsl:text>
								<xsl:text>'</xsl:text>
						<xsl:text>&#13;&#10;</xsl:text>
						
						
						<!-- MOA Segment, Taxable Amount for Rate -->
						<xsl:text>MOA</xsl:text>
						<xsl:text>+</xsl:text>
							<!-- C506, Qualifier -->
								<!-- 5025, Qualifier -->
								<xsl:text>125</xsl:text>
								<xsl:text>:</xsl:text>
								<!-- 5004, Tax Line Item Amount -->
								<xsl:value-of select="format-number(sum(msxsl:node-set($nsTaxRates)/BatchRoot/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal[number(@VATRate) = number(current()/VatRate)]/DocumentTotalExclVATAtRate),'0.00')"/>
								<!-- Currency -->
								<xsl:text>:</xsl:text>
								<xsl:value-of select="/BatchRoot/Invoice/InvoiceHeader/Currency"/>
								<xsl:text>:</xsl:text>
								<xsl:text>4</xsl:text>
								<xsl:text>'</xsl:text>
						<xsl:text>&#13;&#10;</xsl:text>




					</xsl:for-each>


					<!-- UNT Segment, Message Trailer -->
					<xsl:text>UNT</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 0074, Number of Segments in message -->
						<xsl:value-of select="15 + (count(msxsl:node-set($nsTaxRates)/Line) * 3)"/>
						<xsl:text>+</xsl:text>
						<!-- 0062, Message Reference Number -->
						<xsl:value-of select="HelperObj:GetCurrentCounterValue('MessageRefNo')"/>
						<xsl:text>'</xsl:text>

					
					<xsl:text>&#13;&#10;</xsl:text>



					<!-- UNZ Segment, End of Transmission -->
					<xsl:text>UNZ</xsl:text>
					<xsl:text>+</xsl:text>
						<!-- 0036, Interchange control count -->
						<xsl:value-of select="count(Invoice) + 1"/>
						<xsl:text>+</xsl:text>
				<!-- 0020, Interchange Control reference -->
					<!-- 5 digit tesco supplier number -->
					<xsl:value-of select="substring-after(//TradeSimpleHeader[1]/RecipientsCodeForSender,'~')"/>
					<!-- 4 Digit Version -->
					<xsl:text>0001</xsl:text>
					<!-- Generation Number -->
					<xsl:value-of select="$nBatchID"/>
					<!-- Zero, a check digit that isn't checked -->
					<xsl:text>0</xsl:text>
					<xsl:text>'</xsl:text>	



		</xsl:template>
		
		
<xsl:template name="convDate">
	<xsl:param name="sDate"/>
	
	<xsl:value-of select="concat(substring($sDate,1,4),substring($sDate,6,2),substring($sDate,9,2))"/>
	
</xsl:template>


	<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 

/*=========================================================================================
' Routine        : msTruncate()
' Description    : truncates a string in an escape-char-aware manner
' Inputs         : the field, the maximum length
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/

function msTruncate(vsField, nLength){

var sText;
var objRegExp = new RegExp("[?]*$");

	//truncate the string
	sText = vsField.substring(0,nLength);
	
	//capture any sequence of '?' at the end of the string
	objRegExp.exec(sText);
	
	//length of a sequence of '?' is odd the last one 
	//is acting as an escape character and should be removed
	if((RegExp.lastMatch.length % 2) == 1){
		sText = sText.substring(0,nLength-1)
	}
	
	return sText;
	
}
   
   
function msLeadingZeros(vsField, nLength) {

var sText;

sText = '000' + vsField;



return sText.length;


}

]]></msxsl:script>
	


</xsl:stylesheet>
