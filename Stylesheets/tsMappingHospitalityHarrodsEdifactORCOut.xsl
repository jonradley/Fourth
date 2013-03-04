<!-- *******************************************************
Date	|Name		| Information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2012-06-25 |  H Robson | FB 4970 Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2012-08-28	| M Emanauel	| Made Changes to match Harrod's EDI requirement
************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:userfuncs="http://mycompany.com/mynamespace">
	<xsl:output method="text"/>
	<xsl:template match="/PurchaseOrderConfirmation">
	
		<xsl:variable name="sClockTime" select="userfuncs:getClockTime()"/>
	
		<!-- UNA Batch Header -->

		<xsl:text>UNA:</xsl:text>
		
		<xsl:text>+.? '</xsl:text>
		
		<xsl:text>&#13;&#10;</xsl:text>
		
			<xsl:text>UNB+</xsl:text>
		
			<!-- S001/0001, Syntax Identifier -->
			<xsl:text>UNOD:</xsl:text>
		
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
			<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>+</xsl:text>
		
			<!-- S004/0017, Date -->
			<xsl:value-of select="userfuncs:getDate()"/>
			<xsl:text>:</xsl:text>
		
			<!-- S004/0019, Time -->
			<xsl:value-of select="$sClockTime"/>
			<xsl:text>+</xsl:text>
		
			<!-- 0020, control reference -->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/FileGenerationNumber"/>
			<!--
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>ORDERS</xsl:text>
			-->
			<xsl:text>'</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
			
			<!-- HR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	
		<!--This segment is used to head, identify and specify a message-->
		<xsl:text>UNH+</xsl:text>
			<!--Message reference number-->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
			<xsl:text>+ORDRSP:D:96A:UN:EAN005</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to indicate the type and function of a message and to transmit the identifying number-->
		<xsl:text>BGM+</xsl:text>
			<!--Document/message name-->
			<xsl:text>231+</xsl:text>
			<!--Message reference number-->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
			<!--This is the status of the message, 29 means the order has been accepted as this is coming from an ack-->
			<xsl:text>+29</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify dates/times relating to the Purchase Order Response-->
		<xsl:text>DTM+</xsl:text>
			<!--Date/time/period qualifier-->
			<xsl:text>137:</xsl:text>
			<!--Order Response Date YYYYMMDD-->
			<xsl:variable name="POConfDate" select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
			<xsl:value-of select="concat(substring($POConfDate,1,4),substring($POConfDate,6,2),substring($POConfDate,9,2))"/>
			<!--Date/time/period qualifier-->
			<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Purchase Order Number-->
		<xsl:text>RFF+</xsl:text>
			<!--Reference qualifier-->
			<xsl:text>ON:</xsl:text>
			<!--Purchase Order Number-->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Buyer details-->
		<xsl:text>NAD+</xsl:text>
			<!--Party qualifier -->
			<xsl:text>BY+</xsl:text>
			<!--Buyer GLN-->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/GLN"/>
			<!--Code list responsible agency-->
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Supplier details-->
		<xsl:text>NAD+</xsl:text>
			<!--Party qualifier-->
			<xsl:text>SE+</xsl:text>
			<!--Suppliers GLN-->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
			<!--Code list responsible agency-->
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!-- Buyers code for supplier-->
		<xsl:text>RFF+</xsl:text>
			<!--Reference qualifier-->
			<!-- Change 1 -->
			<!--xsl:text>IA:</xsl:text-->
			<xsl:text>IA:</xsl:text>
			<!--Buyers code for supplier-->
			<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
			<!--xsl:value-of select=""/-->
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify currency information for the complete order-->
		<xsl:text>CUX+</xsl:text>
			<!--Currency details qualifier-->
			<xsl:text>2:</xsl:text>
			<!--Currency-->
			<xsl:text>GBP</xsl:text>
			<!--Currency qualifier-->
			<xsl:text>:9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
			<!--This segment is used to identify the product being responded to by means of an EAN article number. The detail section of the Purchase Order Response is formed by a repeating group of segments-->
			<xsl:text>LIN+</xsl:text>
				<xsl:value-of select="LineNumber"/>
				<xsl:text>+</xsl:text>
				<xsl:choose>
					<xsl:when test="@LineStatus = 'Accepted' ">
						<xsl:text>5</xsl:text>
					</xsl:when>
					<xsl:when test="@LineStatus = 'Rejected'">
						<xsl:text>7</xsl:text>
					</xsl:when>
					<xsl:when test="@LineStatus = 'Changed'">
						<xsl:text>3</xsl:text>
					</xsl:when>
					<xsl:otherwise>error</xsl:otherwise>
				</xsl:choose>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="ProductID/GTIN"/>
				<xsl:text>:EN</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--This segment is used to specify additional or substitutional item identification codes such as a buyer's, or seller's item number-->
			<xsl:text>PIA+</xsl:text>
				<xsl:text>1+</xsl:text>
				<!--Buyers product code-->
				<xsl:choose>
					<xsl:when test="ProductID/BuyersProductCode !=''">
						<xsl:value-of select="ProductID/BuyersProductCode"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ProductID/GTIN"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>:BP</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<xsl:text>PIA+</xsl:text>
				<xsl:text>1+</xsl:text>
				<xsl:value-of select="ProductID/SuppliersProductCode"/>
				<xsl:text>:SA</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--This segment is used to describe the current line item-->
			<xsl:text>IMD+</xsl:text>
				<xsl:text>F++:::</xsl:text>
				<xsl:value-of select="ProductDescription"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			
			<!--This segment is used to specify the total quantity ordered for the current line identified in the LIN segment-->
			<xsl:text>QTY+</xsl:text>
				<xsl:text>21:</xsl:text>
				<xsl:value-of select="ConfirmedQuantity"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--To specify a pertinent quantity-->
			<!--
			<xsl:text>QTY+</xsl:text>
				<xsl:text>192:</xsl:text>
				<xsl:value-of select="ConfirmedQuantity"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			-->
			<!--This segment is used to detail the price for the current product identified in the LIN segment-->
			<xsl:text>PRI+</xsl:text>
				<xsl:text>AAA:</xsl:text>
				<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--This segment is used to refer to the Purchase Order Item or Purchase Order Change Request to which the Purchase Order Response is responding-->
			<xsl:text>RFF+</xsl:text>
				<!-- Change 2 -->
				<!--xsl:text>ON:</xsl:text-->
				<xsl:text>ON:</xsl:text>
				<!--Customer order number-->
				<xsl:value-of select="//PurchaseOrderReferences/PurchaseOrderReference"/>
				<xsl:text>:</xsl:text>
				<!-- Customer Order Line No-->
				<xsl:value-of select="Narrative"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--This segment is used to identify the location of delivery for a split delivery order-->
			
			<xsl:text>LOC+</xsl:text>
				<xsl:text>7+</xsl:text>
				<!--EAN Location Number - Buyer's code for location-->
				<xsl:value-of select="../../PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				<xsl:text>::9</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--This segment is used to indicate the delivery quantity for the delivery location specified in the previous LOC segment-->
			<xsl:text>QTY+</xsl:text>
				<xsl:text>11:</xsl:text>
				<xsl:value-of select="ConfirmedQuantity"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--This segment is used to indicate the date/time on which the split delivery will take place to the location identified in the LOC segment-->
			<xsl:variable name="DelDate" select="../../PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
			<xsl:text>DTM+</xsl:text>
				<xsl:text>2:</xsl:text>
				<xsl:value-of select="concat(substring($DelDate,1,4),substring($DelDate,6,2),substring($DelDate,9,2))"/>
				<xsl:text>:102</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
		
		</xsl:for-each>
		
		<!--This segment is used to separate the detail and summary sections of the message-->
		<xsl:text>UNS+S'&#13;&#10;</xsl:text>
		
		<!--Line totals-->
		<xsl:text>MOA+</xsl:text>
			<xsl:text>79:</xsl:text>
			<xsl:value-of select="PurchaseOrderConfirmationTrailer/TotalExclVAT"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is a mandatory UN/EDIFACT segment. It must always be the last segment in the message-->
		<xsl:text>UNT+</xsl:text>
		
			<xsl:variable name="TotalLines" select="count(//PurchaseOrderConfirmationLine)"/>		
			
			<xsl:choose>
				<xsl:when test="$TotalLines = 1">
					<xsl:text>21</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="($TotalLines) * 9 + 12"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:text>+</xsl:text>
			<!--xsl:text>35+</xsl:text-->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
			<!-- HR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		
		<!-- UNZ, Batch Trailer -->
		<xsl:text>UNZ+</xsl:text>
			
			<!-- 0036, Interchange Control Count -->
			
			<xsl:text>1+</xsl:text>
			
			<!--	 0020, Interchange Control Reference -->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/FileGenerationNumber"/>
			<xsl:text>'</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
		
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