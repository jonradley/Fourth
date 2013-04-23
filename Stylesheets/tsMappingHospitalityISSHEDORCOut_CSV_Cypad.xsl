<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
ISS Facility Services HED Cypad CSV ORC mapper
**********************************************************************
Name				| Date			| Change
*********************************************************************
Andrew Barber	| 21/04/2013	| Created.
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://mycompany.com/mynamespace">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/PurchaseOrderConfirmation">

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
		<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/')"/>
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
		<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="concat(substring(PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate,1,4),
		substring(PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate,6,2),
		substring(PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate,9,2)
		)"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="concat(substring(PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate,1,4),
		substring(PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate,6,2),
		substring(PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate,9,2)
		)"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotEnd"/>
		<xsl:value-of select="$Sep"/>		
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ContactName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ContactName,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ContactName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToName,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode,1,9))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="PurchaseOrderConfirmationTrailer/NumberOfLines"/>		
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="sum(//ConfirmedQuantity)"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="PurchaseOrderConfirmationTrailer/TotalExclVAT"/>
		<xsl:value-of select="$Sep"/>
		<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:value-of select="$NewLine"/>
		
		<!-- Confirmation Detail -->
		<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
			<xsl:text>D</xsl:text>
			<xsl:value-of select="$Sep"/>
			<xsl:choose>
				<xsl:when test="@LineStatus='Accepted'">
					<xsl:text>A</xsl:text>
				</xsl:when>
				<xsl:when test="@LineStatus='Rejected'">
					<xsl:text>R</xsl:text>
				</xsl:when>
				<xsl:when test="@LineStatus='Changed'">
					<xsl:text>C</xsl:text>
				</xsl:when>
				<xsl:when test="@LineStatus='Added'">
					<xsl:text>S</xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="$Sep"/>
			<xsl:if test="contains(user:msEscapeQuotes(string(ProductID/SuppliersProductCode)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(string(ProductID/SuppliersProductCode))"/>
			<xsl:if test="contains(user:msEscapeQuotes(string(ProductID/SuppliersProductCode)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="$Sep"/>
			<xsl:if test="contains(user:msEscapeQuotes(string(SubstitutedProductID/SuppliersProductCode)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(string(SubstitutedProductID/SuppliersProductCode))"/>
			<xsl:if test="contains(user:msEscapeQuotes(string(SubstitutedProductID/SuppliersProductCode)),',')">
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
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:value-of select="$Sep"/>
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:value-of select="$Sep"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(Narrative,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(Narrative,1,40))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(Narrative,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="$Sep"/>
			<!-- Quantity on back order -->
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
