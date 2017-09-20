<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
 Overview 
  XSL Goods Received Note mapper
  Hospitality iXML to Zonal XML format.

 © ABS Ltd., 2005.
******************************************************************************************
 Module History
******************************************************************************************
 Date        	| Name         | Description of modification
******************************************************************************************
 ??/??/????	| ?            		| Created        
******************************************************************************************
 02/09/2005	| Lee Boyton   	| H488. Cater for the SiteRef for Urbium messages being in the
                            			| recipient's branch reference field.
******************************************************************************************
 20/08/2007	| Lee Boyton   	| 1390. Cater for extended characters.
******************************************************************************************
 14/03/2008	| A Sheppard	| 2071. Cater for Ullage credits
 ******************************************************************************************
 19/06/2009	| Rave Tech		| 2950. Set OrderNo as PO Ref rather than DN ref for 2 Brakes suppliers.
 ******************************************************************************************
 24/11/2009	| Lee Boyton	| 3261. Truncate the OrderNo field to the maximum length of 15 characters.
******************************************************************************************
 05/04/2012	| Sandeep Sehgal	| FB5348 Translate accented characters 
******************************************************************************************
09/05/2012	| Mark Emanuel	| FB 5462 Set OrderNo as DN ref for all suppliers. (reverting the changes made in FB2950)
******************************************************************************************
-->
<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="ISO-8859-1"/>
<xsl:include href="HospitalityInclude.xsl"/>
	<!-- store the Aztec Compressed Output product code in a local variable
	     this is an optional field and if non-blank will result in only a single product line being output -->
	<xsl:variable name="CompressedOutput">
		<xsl:value-of select="//HeaderExtraData/CompressedAztecOutput"/>
	</xsl:variable>
	<xsl:template match="/">	
		<DeliveryNote>
			<xsl:attribute name="SiteCode"><xsl:value-of select="//AztecSiteID"/></xsl:attribute>
			<!-- The location of the SiteRef depends on the buyer.
			     H&H have an additional element (HardysSiteID) added by the zonal pre mapper, where as
			     Urbium use the value in the branch reference (proxy relationship) -->
			<xsl:attribute name="SiteRef">
				<xsl:choose>
					<xsl:when test="//HardysSiteID != ''">
						<xsl:value-of select="//HardysSiteID"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- Note that you would expect the branch reference to be the SendersBranchReference, as
						     the sender of a goods received note is the buyer, however this has been cc-ed back to the
						     buyer and so the branch reference ends up in the recipient section -->
						<xsl:value-of select="//TradeSimpleHeader/RecipientsBranchReference"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="Supplier"><xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient | /CreditNote/TradeSimpleHeader/RecipientsCodeForSender"/></xsl:attribute>
		
		
			<!-- Setting OrderNo as DN Ref for all Suppliers and moving away from supplier specific change delivered as per FB no 2950 -->
			
			<xsl:attribute name="OrderNo"><xsl:value-of select="substring(//GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference | //CreditNoteReference,1,15)"/></xsl:attribute>

			<!-- If the compressed Aztec output product code exists then there will only be a single line -->
			<xsl:attribute name="Lines">
				<xsl:choose>
					<xsl:when test="$CompressedOutput != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(//GoodsReceivedNoteLine | //CreditNoteLine)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="/GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT">
					<xsl:attribute name="Value"><xsl:value-of select="format-number((sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT) - sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue)) * (100 - /GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate) div 100, '0.00')"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="/CreditNote">
					<xsl:attribute name="Value">-<xsl:value-of select="format-number((sum(/CreditNote/CreditNoteDetail/CreditNoteLine/LineValueExclVAT) - sum(/CreditNote/CreditNoteDetail/CreditNoteLine/LineDiscountValue)) * (100 - /CreditNote/CreditNoteTrailer/DocumentDiscountRate) div 100, '0.00')"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
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
					<xsl:for-each select="//GoodsReceivedNoteLine | //CreditNoteLine">
						<Line>
							<xsl:attribute name="LineNo"><xsl:value-of select="LineNumber"/></xsl:attribute>
							<xsl:attribute name="ImpExpRef"><xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="ProductID/SuppliersProductCode"/></xsl:call-template></xsl:attribute>
							<xsl:if test="ProductDescription">
								<xsl:attribute name="Description"><xsl:call-template name="TranslateAccentedCharacters"><xsl:with-param name="InputString" select="ProductDescription"/></xsl:call-template></xsl:attribute>
							</xsl:if>
							<xsl:attribute name="Quantity">
								<xsl:choose>
									<xsl:when test="AcceptedQuantity">
										<xsl:value-of select="AcceptedQuantity"/>
									</xsl:when>
									<xsl:when test="CreditedQuantity and substring(ProductID/SuppliersProductCode,string-length(ProductID/SuppliersProductCode)) = 'L'">
										<xsl:value-of select="format-number(CreditedQuantity * -0.219969157,'0.000')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="CreditedQuantity * -1"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:if test="UnitValueExclVAT">
								<xsl:attribute name="UnitCost">
									<xsl:choose>
										<xsl:when test="CreditedQuantity and substring(ProductID/SuppliersProductCode,string-length(ProductID/SuppliersProductCode)) = 'L'">
											<xsl:value-of select="format-number(UnitValueExclVAT div 0.219969157,'0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="UnitValueExclVAT"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
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
