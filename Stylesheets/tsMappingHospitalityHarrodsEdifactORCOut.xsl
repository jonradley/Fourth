<!-- *******************************************************
Date	|Name		| Information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2012-06-25 |  H Robson | FB 4970 Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	|	|	|
************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="/PurchaseOrderConfirmation">
		<!-- This segment is used to head, identify and specify a message. -->
		<xsl:text>UNH+</xsl:text>
		<!-- message reference number -->
		<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>+ORDRSP:D:96A:UN:EAN005'</xsl:text>
		
		<!-- This segment is used to indicate the type and function of a message and to transmit the identifying number. -->
		<xsl:text>BGM+231+</xsl:text>
		<!-- message reference number -->
		<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
		<!-- look at all the line level statuses to determine overall doc status -->
		<xsl:choose>
			<!-- not accepted (all lines are rejected) -->
			<xsl:when test="count(//PurchaseOrderConfirmationLine[@LineStatus='Rejected']) = count(//PurchaseOrderConfirmationLine)"><xsl:text>+27</xsl:text></xsl:when>
			<!-- accepted without change (all lines are accepted -->
			<xsl:when test="count(//PurchaseOrderConfirmationLine[@LineStatus='Accepted']) = count(//PurchaseOrderConfirmationLine)"><xsl:text>+29</xsl:text></xsl:when>
			<!-- otherwise: accepted with change -->
			<xsl:otherwise><xsl:text>+4</xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:text>'</xsl:text>
		
		<!-- This segment is used to specify the date of the Order and, where required, requested dates concerning the delivery of the goods. -->
		<xsl:text>DTM+137:</xsl:text>
		<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
		<xsl:text>:102'</xsl:text>
		
		<!-- This segment is used to refer to the Purchase Order or Purchase Order Change Request to which the Purchase Order Response is responding. -->
		<xsl:text>RFF+ON:</xsl:text>
		<!-- Harrods Purchase Order Number -->
		<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>'</xsl:text>
		
		<!-- This segment is used to identify the trading partners involved in the Purchase Order Response. Identification of the buyer and supplier of goods and services is mandatory using DE's 3035 and C082. Additional parties can be identified as a clarification or correction to a previously sent Purchase Order or Purchase Order Change Request. -->
		<xsl:text>NAD+BY+</xsl:text>
		<!-- EAN Code for buyer -->
		<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>::9'</xsl:text>
		<xsl:text>NAD+SE+</xsl:text>
		<!-- EAN Code for suppier -->
		<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
		<xsl:text>::9'</xsl:text>
		
		<!-- This segment is used to refer Harrods internal supplier number. -->
		<xsl:text>RFF+IA:</xsl:text>
			<!--Buyers code for supplier-->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>'</xsl:text>
		
		<!-- This segment is used to specify currency information for the complete purchase order response.   -->
		<xsl:text>CUX+2:GBP:9</xsl:text>
		<xsl:text>'</xsl:text>
		
		<!-- Confirmation Purchase Order Detail Section -->
		<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
			<!-- This segment is used to identify the product being responded to by means of an EAN article number. The detail section of the Purchase Order Response is formed by a repeating group of segments, always starting with the LIN segment. -->
			<xsl:text>LIN+</xsl:text>
			<!-- line number -->
			<xsl:value-of select="LineNumber"/>
			<xsl:text>+</xsl:text>
			<!-- Action request/notification, coded -->
			<xsl:choose>
				<xsl:when test="@LineStatus = 'Added'"><xsl:text>1</xsl:text></xsl:when><!-- Added -->
				<xsl:when test="@LineStatus = 'Changed'"><xsl:text>3</xsl:text></xsl:when><!-- Changed -->
				<xsl:when test="@LineStatus = 'Accepted'"><xsl:text>5</xsl:text></xsl:when><!-- Accepted without amendment -->
				<xsl:when test="@LineStatus = 'Rejected'"><xsl:text>7</xsl:text></xsl:when><!-- Not accepted -->
			</xsl:choose>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="ProductID/GTIN"/>
			<xsl:text>:EN'</xsl:text>
			
			<!-- This segment is used to specify additional or substitutional item identification codes such as a buyers, or sellers item number. -->
			<xsl:text>PIA+1+</xsl:text>
				<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>:SA'</xsl:text>
			
			<!-- This segment is used to describe the current line item. -->
			<xsl:text>IMD+F++:::</xsl:text>
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>'</xsl:text>
			
			<!-- This segment is used to specify quantity information related to the current line item. -->
			<xsl:text>QTY+21:</xsl:text>
			<xsl:value-of select="ConfirmedQuantity"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
			<xsl:text>'</xsl:text>
			
			<!-- This segment is used to provide price information for the current line item. -->
			<xsl:text>PRI+AAA:</xsl:text>
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>'</xsl:text>
			
			<!-- This segment is used to specify any references which are applicable to the current line item only. References stated here will override those specified in the heading section when the same qualifier is used.   -->
			<xsl:text>RFF+ON:</xsl:text>
			<!-- Harrods Purchase Order Number -->
			<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>'</xsl:text>
			
			<!-- THE FOLLOWING THREE SEGMENTS (LOC, QTY, DTM) ONLY NEED TO BE IMPLEMENTED TO SUPPORT SPLIT DELIVERIES -->
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
			<!-- This segment is used to identify the location of delivery for a split delivery order. -->
			<!-- There will always be at least one of this segments. In case of not split there will be 1 segment with the whole quantity. -->
			<!-- <xsl:text>LOC+7+</xsl:text> -->
			<!-- EAN Location Number for delivery location -->
			<!-- <xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/GLN"/> -->
			<!-- <xsl:text>::9'</xsl:text> -->
			
			<!-- This segment is used to indicate the delivery quantity for the delivery location specified in the previous LOC segment. -->
			<!-- The total of all quantities specified in segment group 33 for the line, must equal the value for the total quantity detailed in the QTY segment at line level. -->
			<!-- <xsl:text>QTY+</xsl:text> -->
			<!-- <xsl:text>'</xsl:text> -->
						
			<!-- This segment is used to indicate the date, time or period on which the split delivery will take place to the location identified in the LOC segment. -->
			<!-- <xsl:text>DTM+</xsl:text> -->
			<!-- <xsl:text>'</xsl:text> -->
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
			
		</xsl:for-each>
		
		<!-- Confirmation Purchase Order Summary Section -->
		<!-- This segment is used to separate the detail and summary sections of the message. -->
		<xsl:text>UNS+S'</xsl:text>
		
		<!-- This segment is used to indicate total amounts for the purchase order response. Optional. -->
		<!-- <xsl:text>MOA+'</xsl:text> -->

		<!-- This segment is a mandatory UN/EDIFACT segment. It must always be the last segment in the message. -->
		<xsl:text>UNT+</xsl:text>
		<xsl:text>'</xsl:text>
	</xsl:template>
</xsl:stylesheet>
