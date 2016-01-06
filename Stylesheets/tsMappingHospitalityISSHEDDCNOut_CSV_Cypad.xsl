<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
ISS Facility Services HED Cypad CSV DCN mapper
**********************************************************************
Name				| Date			| Change
*********************************************************************
Andrew Barber	| 21/04/2013	| 6259: Created.
*********************************************************************
Andrew Barber	| 04/07/2013	| 6737: Added logic for supplier code output.
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://mycompany.com/mynamespace">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/DeliveryNote">

		<xsl:variable name="one_quote">"</xsl:variable>
		<xsl:variable name="two_quotes">""</xsl:variable>

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="Sep">
			<xsl:text>,</xsl:text>
		</xsl:variable>
	
		<!-- Confirmation Header -->
		<xsl:text>H</xsl:text>
		<xsl:value-of select="$Sep"/>
		<xsl:choose>
			<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'/')">
					<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$Sep"/>
		<xsl:choose>
			<xsl:when test="TradeSimpleHeader/TestFlag='true'">
					<xsl:text>Y</xsl:text>
			</xsl:when>
			<xsl:when test="TradeSimpleHeader/TestFlag='1'">
					<xsl:text>Y</xsl:text>
			</xsl:when>
			<xsl:otherwise>
					<xsl:text>N</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="concat(substring(DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate,1,4),
		substring(DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate,6,2),
		substring(DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate,9,2)
		)"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="concat(substring(DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate,1,4),
		substring(DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate,6,2),
		substring(DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate,9,2)
		)"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="concat(substring(DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate,1,4),
		substring(DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate,6,2),
		substring(DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate,9,2)
		)"/>
		<xsl:value-of select="$Sep"/>
		<!--Delivery Slot Start Time-->
		<xsl:value-of select="$Sep"/>
		<!--Delivery Slot End Time-->
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ContactName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ContactName,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ContactName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToName,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine1,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine2,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine2,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine2,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine3,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine4,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/PostCode,1,9))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(DeliveryNoteHeader/ShipTo/ShipToAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="DeliveryNoteTrailer/NumberOfLines"/>		
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:value-of select="$Sep"/>
		<!--Supplier's Code for Customer-->
		<xsl:value-of select="$Sep"/>
		<!--Original Purchase Order Number-->
		<xsl:value-of select="$NewLine"/>
		
		<!-- Confirmation Detail -->
		<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">
			<xsl:text>D</xsl:text>
			<xsl:value-of select="$Sep"/>
			<xsl:if test="contains(user:msEscapeQuotes(string(ProductID/SuppliersProductCode)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(string(ProductID/SuppliersProductCode))"/>
			<xsl:if test="contains(user:msEscapeQuotes(string(ProductID/SuppliersProductCode)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="$Sep"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(ProductDescription,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(ProductDescription,1,40))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(ProductDescription,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="$Sep"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(PackSize,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(PackSize,1,40))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(PackSize,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="$Sep"/>
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:value-of select="$Sep"/>
			<xsl:value-of select="ConfirmedQuantity"/>
			<xsl:value-of select="$Sep"/>
			<xsl:value-of select="DespatchedQuantity"/>
			<xsl:value-of select="$Sep"/>
			<!--Expiry Date-->
			<xsl:value-of select="$Sep"/>
			<!--Sell By Date-->
			<xsl:value-of select="$Sep"/>
			<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:value-of select="$Sep"/>
			<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
			<xsl:value-of select="$Sep"/>
			<xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/>
			<xsl:value-of select="$Sep"/>
			<xsl:value-of select="$NewLine"/>
		</xsl:for-each>
	
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="user"><![CDATA[ 
	
		Function msEscapeQuotes(inputValue)
			Dim sReturn
				       	
			'sReturn = inputValue.item(0).nodeTypedValue
			sReturn = inputValue
	      		msEscapeQuotes = Replace(sReturn,"""","""" & """")
			
			End Function 
	]]></msxsl:script>
	
</xsl:stylesheet>
