<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal GRNs into a Aramark fixed width format.
 The files will be concatenated by the outbound batch processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 07/05/2008	| A Sheppard	| Created Module
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="xml"/>
	<xsl:include href="HospitalityInclude.xsl"/>

	<xsl:template match="/">
	
		<GoodsReceivedNote>
			<xsl:copy-of select="/GoodsReceivedNote/TradeSimpleHeader"/>
			<xsl:copy-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader"/>
			
			<GoodsReceivedNoteDetail>
				<xsl:for-each select="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
					<GoodsReceivedNoteLine>
						<xsl:copy-of select="LineStatus"/>
						<xsl:copy-of select="LineNumber"/>
						<xsl:copy-of select="ProductDescription"/>
						<xsl:copy-of select="OrderedQuantity"/>
						<xsl:copy-of select="ConfirmedQuantity"/>
						<xsl:copy-of select="DeliveredQuantity"/>
						<xsl:copy-of select="AcceptedQuantity"/>
						<!--xsl:copy-of select="PackSize"/-->
						<PackSize>EA</PackSize>
						<xsl:copy-of select="UnitValueExclVAT"/>
						<xsl:copy-of select="LineValueExclVAT"/>
						<xsl:copy-of select="LineDiscountRate"/>
						<xsl:copy-of select="LineDiscountValue"/>
						<xsl:copy-of select="LineExtraData"/>
						<tsDescription><xsl:value-of select="ProductDescription"/></tsDescription>
						<tsPackSize><xsl:value-of select="PackSize"/></tsPackSize>
						<tsSupplierDeliveryUOM><xsl:value-of select="AcceptedQuantity/@UnitOfMeasure"/></tsSupplierDeliveryUOM>
					</GoodsReceivedNoteLine>
				</xsl:for-each>
			</GoodsReceivedNoteDetail>
			
			<xsl:copy-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer"/>
		</GoodsReceivedNote>

	</xsl:template>
</xsl:stylesheet>