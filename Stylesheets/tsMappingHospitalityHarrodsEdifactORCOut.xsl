<!-- *******************************************************
Date	|Name		| Information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
27/07/2011| KOshaughnessy|FB4970 Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	|	|	|
************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="/PurchaseOrderAcknowledgement">
	
		<!--This segment is used to head, identify and specify a message-->
		<xsl:text>UNH+</xsl:text>
			<!--Message reference number-->
			<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementReference"/>
			<xsl:text>+ORDRSP:D:96A:UN:EAN005</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to indicate the type and function of a message and to transmit the identifying number-->
		<xsl:text>BGM+</xsl:text>
			<!--Document/message name-->
			<xsl:text>231+</xsl:text>
			<!--Message reference number-->
			<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementReference"/>
			<!--This is the status of the message, 29 means the order has been accepted as this is coming from an ack-->
			<xsl:text>+29</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify dates/times relating to the Purchase Order Response-->
		<xsl:text>DTM+</xsl:text>
			<!--Date/time/period qualifier-->
			<xsl:text>137:</xsl:text>
			<!--Order Response Date YYYYMMDD-->
			<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementDate"/>
			<!--Date/time/period qualifier-->
			<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Purchase Order Number-->
		<xsl:text>RFF+</xsl:text>
			<!--Reference qualifier-->
			<xsl:text>ON:</xsl:text>
			<!--Purchase Order Number-->
			<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Buyer details-->
		<xsl:text>NAD+</xsl:text>
			<!--Party qualifier -->
			<xsl:text>BY+</xsl:text>
			<!--Buyer GLN-->
			<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/GLN"/>
			<!--Code list responsible agency-->
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Supplier details-->
		<xsl:text>NAD+</xsl:text>
			<!--Party qualifier-->
			<xsl:text>SE+</xsl:text>
			<!--Suppliers GLN-->
			<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/GLN"/>
			<!--Code list responsible agency-->
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!-- Buyers code for supplier-->
		<xsl:text>RFF+</xsl:text>
			<!--Reference qualifier-->
			<xsl:text>IA:</xsl:text>
			<!--Buyers code for supplier-->
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
		
		<!--This segment is used to identify the product being responded to by means of an EAN article number. The detail section of the Purchase Order Response is formed by a repeating group of segments-->
		<xsl:text>LIN+</xsl:text>
			1+3+85805103767:EN'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify additional or substitutional item identification codes such as a buyer's, or seller's item number-->
		<xsl:text>PIA+</xsl:text>
			1+1227:BP'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<xsl:text>PIA+</xsl:text>
			1+TEST PSS TEST PSSS:SA'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to describe the current line item-->
		<xsl:text>IMD+</xsl:text>
			F++:::EXCEPTIONAL LIPSTICK CHERRY 4Gts'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify the total quantity ordered for the current line identified in the LIN segment-->
		<xsl:text>QTY+</xsl:text>
			21:50:EA'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to detail the price for the current product identified in the LIN segment-->
		<xsl:text>PRI+</xsl:text>
			AAA:6.4'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to refer to the Purchase Order Item or Purchase Order Change Request to which the Purchase Order Response is responding-->
		<xsl:text>RFF+</xsl:text>
			ON:5000010446:10'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to identify the location of delivery for a split delivery order-->
		<xsl:text>LOC+</xsl:text>
			7+0604619201027::9'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to indicate the delivery quantity for the delivery location specified in the previous LOC segment-->
		<xsl:text>QTY+</xsl:text>
			11:50'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to indicate the date/time on which the split delivery will take place to the location identified in the LOC segment-->
		<xsl:text>DTM+</xsl:text>
			2:20051208:102'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to separate the detail and summary sections of the message-->
		<xsl:text>UNS+</xsl:text>
			S'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Line totals-->
		<xsl:text>MOA+</xsl:text>
			79:960'
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is a mandatory UN/EDIFACT segment. It must always be the last segment in the message-->
		<xsl:text>UNT+</xsl:text>
			35+EW368923526'
		<xsl:text>'&#13;&#10;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
