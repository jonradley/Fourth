<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
Calum Scott	|   ??????? 		| 3541 Created Module
**********************************************************************
M Hordern	| 2010-05-27		| 3541 added fixed email address
**********************************************************************
A Barber	| 2010-06-03		| 3541: Updated fixed email address.				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://abs-Ltd.com">
	<xsl:output method="text"/>
	<xsl:template match="PurchaseOrder">
		<xsl:text>DHS</xsl:text>
		<xsl:value-of select="substring(concat('               ',PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference),string-length(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference)+1,15)"/>
		<xsl:value-of select="user:spaces(255)"/>
		<xsl:value-of select="concat(substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,6,2),'-',substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,9,2),'-',substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,1,4))"/>
		<xsl:value-of select="substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime,1,5)"/>
		<xsl:value-of select="user:spaces(35)"/>
		<xsl:value-of select="user:spaces(10)"/>
		<xsl:text>Y</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		<xsl:text>DHC</xsl:text>
		<xsl:value-of select="substring(concat('0000000000',TradeSimpleHeader/RecipientsCodeForSender),string-length(TradeSimpleHeader/RecipientsCodeForSender)+1,10)"/>
		<xsl:value-of select="substring(concat('Naomi.Reece@foodtravelexperts.com',user:spaces(75)),1,75)"/>
		<xsl:value-of select="user:spaces(15)"/>
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<xsl:text>&#13;&#10;</xsl:text>
			<xsl:text>DNQ</xsl:text>
			<xsl:value-of select="substring(concat('0000000',ProductID/SuppliersProductCode),string-length(ProductID/SuppliersProductCode)+1,7)"/>
			<xsl:value-of select="substring(concat('0000',OrderedQuantity),string-length(floor(OrderedQuantity))+1,4)"/>
			<xsl:text>0000</xsl:text>
			<xsl:if test="position() = last()">
				<xsl:text>Y</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<msxsl:script implements-prefix="user"><![CDATA[
function spaces(length) {
	var retstr = ''
	for (i=1;i<=length;i++) {
		retstr = retstr + ' '
	}
	return retstr
}
]]></msxsl:script>
</xsl:stylesheet>
