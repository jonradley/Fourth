<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"> 
<xsl:output method="text" encoding="UTF-8"/>

	<xsl:template match="DeliveryNote">
	
		<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">

			<xsl:value-of select="//DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="//DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>|</xsl:text>
			<xsl:text>|</xsl:text>
				<xsl:value-of select="DespatchedQuantity"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>&#13;</xsl:text>
			
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
