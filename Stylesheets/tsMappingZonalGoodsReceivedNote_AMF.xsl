<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' Overview 
'  XSL Goods Received Note mapper
'  Hospitality iXML to Zonal XML format.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' ??/??/????  | ?            | Created        
'******************************************************************************************
' 02/09/2005  | Lee Boyton   | H488. Cater for the SiteRef for Urbium messages being in the
'                            | recipient's branch reference field.
'******************************************************************************************
' 20/08/2007  | Lee Boyton   | 1390. Cater for extended characters.
'******************************************************************************************
' 01/10/2010  | R Cambridge  | 3920. Allow trade simple's 4 supplier codes for 3663 agreements to map into Aztec's 2 codes
'******************************************************************************************
'             |              | 
'******************************************************************************************

*** IMPORTANT NOTE ***
This stylesheet has been branched for Fullers. Any changes made to this
may have to be merged over to tsMappingZonalGoodsReceivedNote.xsl
and tsMappingZonalGoodsReceivedNote_Fullers.xsl
**********************
-->
<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="ISO-8859-1"/>
	<!-- store the Aztec Compressed Output product code in a local variable
	     this is an optional field and if non-blank will result in only a single product line being output -->
	<xsl:variable name="CompressedOutput">
		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/HeaderExtraData/CompressedAztecOutput"/>
	</xsl:variable>
	<xsl:template match="/">	
		<DeliveryNote>
			<xsl:attribute name="SiteCode"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/AztecSiteID"/></xsl:attribute>
			<!-- The location of the SiteRef depends on the buyer.
			     H&H have an additional element (HardysSiteID) added by the zonal pre mapper, where as
			     Urbium use the value in the branch reference (proxy relationship) -->
			<xsl:attribute name="SiteRef">
				<xsl:choose>
					<xsl:when test="/GoodsReceivedNote/GoodsReceivedNoteHeader/HardysSiteID != ''">
						<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/HardysSiteID"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- Note that you would expect the branch reference to be the SendersBranchReference, as
						     the sender of a goods received note is the buyer, however this has been cc-ed back to the
						     buyer and so the branch reference ends up in the recipient section -->
						<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/RecipientsBranchReference"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="Supplier">
				
				<!-- 3920 trim supplier's codes before a '-' -->
				<!-- AMF's invoice/credit mapper trims codes on a '/' so also catch the case where the code contains'/-' -->
				<!-- Codes can have the form
				
					ts TRs				output to 			output to		
											stock system		financial system
											
					{code}				{code}				{code}
					{code}/c				{code}/c				{code}
					{code}/-OBC			{code}				{code}
					{code}/c-OBC		{code}/c				{code}
				
				 -->
				
				<xsl:choose>
				
					<xsl:when test="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient = 'THR001/d'">THR001/c</xsl:when>
					<xsl:when test="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient = 'THR001/e'">THR001</xsl:when>
					
					<xsl:when test="contains(/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient,'/-')">			      
						<xsl:value-of select="substring-before(/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient,'/-')"/>			     
					</xsl:when>
					<xsl:when test="contains(/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient,'-')">			      
						<xsl:value-of select="substring-before(/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient,'-')"/>			     
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient"/>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:attribute>
			<xsl:attribute name="OrderNo"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:attribute>
			<!-- If the compressed Aztec output product code exists then there will only be a single line -->
			<xsl:attribute name="Lines">
				<xsl:choose>
					<xsl:when test="$CompressedOutput != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT">
				<xsl:attribute name="Value"><xsl:value-of select="format-number((sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT) - sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue)) * (100 - /GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate) div 100, '0.00')"/></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$CompressedOutput != ''">
					<Line>
						<xsl:attribute name="LineNo">1</xsl:attribute>
						<xsl:attribute name="ImpExpRef"><xsl:value-of select="$CompressedOutput"/></xsl:attribute>
						<xsl:attribute name="Description"><xsl:value-of select="$CompressedOutput"/></xsl:attribute>
						<xsl:attribute name="Quantity">1</xsl:attribute>
						<xsl:attribute name="UnitCost"><xsl:value-of select="format-number((sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT) - sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue)) * (100 - /GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate) div 100, '0.00')"/></xsl:attribute>
					</Line>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
						<Line>
							<xsl:attribute name="LineNo"><xsl:value-of select="LineNumber"/></xsl:attribute>
							<xsl:attribute name="ImpExpRef"><xsl:value-of select="ProductID/SuppliersProductCode"/></xsl:attribute>
							<xsl:if test="ProductDescription">
								<xsl:attribute name="Description"><xsl:value-of select="ProductDescription"/></xsl:attribute>
							</xsl:if>
							<xsl:attribute name="Quantity"><xsl:value-of select="AcceptedQuantity"/></xsl:attribute>
							<xsl:if test="UnitValueExclVAT">
								<xsl:attribute name="UnitCost"><xsl:value-of select="UnitValueExclVAT"/></xsl:attribute>
							</xsl:if>
							<xsl:for-each select="Breakages/Breakage">
								<Breakage>
									<xsl:attribute name="Quantity"><xsl:value-of select="BreakageQuantity"/></xsl:attribute>
									<xsl:attribute name="BaseUnit"><xsl:value-of select="BaseUnit"/></xsl:attribute>
									<xsl:attribute name="BaseAmount"><xsl:value-of select="BaseAmount"/></xsl:attribute>
								</Breakage>
							</xsl:for-each>
						</Line>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</DeliveryNote>
	</xsl:template>
</xsl:stylesheet>
