<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
S Hussain		|	2013-05-14	| Created a common stylesheets with generic functionalities by Bibendum
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<!--Generic Variables-->
	<xsl:variable name="ARAMARK" select="'ARAMARK'"/>
	<xsl:variable name="BEACON_PURCHASING" select="'BEACON_PURCHASING'"/>
	<xsl:variable name="COMPASS" select="'COMPASS'"/>
	<xsl:variable name="COOP" select="'COOP'"/>
	<xsl:variable name="FISHWORKS" select="'FISHWORKS'"/>
	<xsl:variable name="MCC" select="'MCC'"/>
	<xsl:variable name="ORCHID" select="'ORCHID'"/>
	<xsl:variable name="SEARCYS" select="'SEARCYS'"/>
	<xsl:variable name="SODEXO_PRESTIGE" select="'SODEXO_PRESTIGE'"/>
	<xsl:variable name="TESCO" select="'TESCO'"/>
	<xsl:variable name="MITIE" select="'MITIE'"/>
	<xsl:variable name="PBR" select="'PBR'"/>
	<xsl:variable name="CREATIVE_EVENTS" select="'CREATIVE_EVENTS'"/>
	<xsl:variable name="BIBENDUM" select="'Bibendum'"/>
	
	<xsl:variable name="CustomerFlag">
		<xsl:variable name="accountCode" select="string(//TradeSimpleHeader/SendersBranchReference)"/>
		<xsl:choose>
			<xsl:when test="$accountCode = '203909'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'ARA02T'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'ARANET'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'BEACON'"><xsl:value-of select="$BEACON_PURCHASING"/></xsl:when>
			<xsl:when test="$accountCode = 'MIL14T'"><xsl:value-of select="$COMPASS"/></xsl:when>
			<xsl:when test="$accountCode = 'COM2012T'"><xsl:value-of select="$COMPASS"/></xsl:when>			
			<xsl:when test="$accountCode = 'KIN04D'"><xsl:value-of select="$COOP"/></xsl:when>
			<xsl:when test="$accountCode = 'KIN04T'"><xsl:value-of select="$COOP"/></xsl:when>
			<xsl:when test="$accountCode = 'fishworks'"><xsl:value-of select="$FISHWORKS"/></xsl:when>
			<xsl:when test="$accountCode = 'MAR100T'"><xsl:value-of select="$MCC"/></xsl:when>
			<xsl:when test="$accountCode = 'BLA16T'"><xsl:value-of select="$ORCHID"/></xsl:when>
			<xsl:when test="$accountCode = 'OPL01T'"><xsl:value-of select="$ORCHID"/></xsl:when>
			<xsl:when test="$accountCode = 'ORCHID'"><xsl:value-of select="$ORCHID"/></xsl:when>
			<xsl:when test="$accountCode = 'PBR16T'"><xsl:value-of select="$ORCHID"/></xsl:when>
			<xsl:when test="$accountCode = 'SEA01T'"><xsl:value-of select="$SEARCYS"/></xsl:when>
			<xsl:when test="$accountCode = 'GAR06T'"><xsl:value-of select="$SODEXO_PRESTIGE"/></xsl:when>
			<xsl:when test="$accountCode = 'SOD99T'"><xsl:value-of select="$SODEXO_PRESTIGE"/></xsl:when>	
			<xsl:when test="$accountCode = 'MIT16T'"><xsl:value-of select="$MITIE"/></xsl:when>
			<xsl:when test="$accountCode = 'PBR01T'"><xsl:value-of select="$PBR"/></xsl:when>		
			<xsl:when test="$accountCode = 'CRE11T'"><xsl:value-of select="$CREATIVE_EVENTS"/></xsl:when>	
			<xsl:when test="$accountCode = 'TES01T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES08T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES12T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES15T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES25T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>		

	<!--TradeSimple Header-->
	<xsl:template match="TradeSimpleHeader">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:choose>
					<xsl:when test="$CustomerFlag!='' and contains(concat($COMPASS,'~',$TESCO,'~',$BEACON_PURCHASING),$CustomerFlag)">
						<xsl:value-of select="SendersBranchReference"/>
					</xsl:when>			
					<xsl:otherwise>
						<xsl:value-of select="SendersCodeForRecipient"/>
					</xsl:otherwise>
				</xsl:choose>
			</SendersCodeForRecipient>
			<xsl:if test="$CustomerFlag!='' and contains(concat($MITIE,'~',$COMPASS,'~',$TESCO,'~',$ARAMARK,'~',$CREATIVE_EVENTS),$CustomerFlag)">
				<SendersBranchReference>
					<xsl:value-of select="SendersBranchReference"/>
				</SendersBranchReference>
			</xsl:if>
		</TradeSimpleHeader>
	</xsl:template>
	
	<!-- Sort out some Addresses -->
	<xsl:template match="BuyersAddress | SuppliersAddress | ShipToAddress">
		<xsl:copy>
			<xsl:for-each select="*[contains(name(),'Address')][string(.) != '']">
				<xsl:element name="{concat('AddressLine', position())}"><xsl:value-of select="."/></xsl:element>		
			</xsl:for-each>
			<PostCode><xsl:value-of select="PostCode"/></PostCode>
		</xsl:copy>
	</xsl:template>
	
	<!-- Decode the VATCodes -->
	<xsl:template name="decodeVATCodes">
		<xsl:param name="sVATCode"/>
		<xsl:choose>
			<xsl:when test="contains('STD~EXEMPT',$sVATCode)">
					<xsl:value-of select="substring($sVATCode,1,1)" />
			</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--Decode Pack Size-->
	<xsl:template name="decodePacks">
		<xsl:param name="sBibPack"/>
		<xsl:variable name="normBibPack" select="normalize-space($sBibPack)"/>
		<xsl:choose>
			<xsl:when test="$normBibPack != '' and contains('EACH~BOTTLE',$normBibPack)">1</xsl:when>
			<xsl:when test="substring($normBibPack,1,5) = 'STRIP'">
					<xsl:value-of select="substring($normBibPack,6)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($normBibPack,5)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--Decode UOM-->
	<xsl:template  name="decodeUOM">
		<xsl:param name="sUOM"/>
		<xsl:choose>
			<xsl:when test="$sUOM = 1">EA</xsl:when>
			<xsl:otherwise>CS</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--Supplier Product Code Formatting-->
	<!-- SSP, GIRAFFE, WAHACA specific change to append the unit of measure onto the product code -->
	<xsl:template name="FormatSupplierProductCode">
		<xsl:param name="sUOM"/>
		<xsl:param name="sProductCode"/>
			<xsl:choose>
				<!-- 2012-02-01 - removed ARAMARK from this list, UoM SHOULD be added to product codes for them -->
				<!-- 2013-05-07 - removed PBR from this list, UoM SHOULD be added to product codes for them -->
				<xsl:when test="not(
					$CustomerFlag = $COMPASS or
					$CustomerFlag = $COOP  or
					$CustomerFlag = $FISHWORKS or
					$CustomerFlag = $MCC  or
					$CustomerFlag = $ORCHID or
					$CustomerFlag = $SEARCYS or
					$CustomerFlag = $SODEXO_PRESTIGE)">
					<!-- translate the Units In Pack value and then append this to the product code -->
					<xsl:variable name="UOMRaw">
						<xsl:choose>
							<xsl:when test="$sUOM = 'EA'">1</xsl:when>
							<xsl:when test="$sUOM = 'CS'">2</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="decodePacks">
									<xsl:with-param name="sBibPack" select="$sUOM"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="UOM">
						<xsl:choose>
							<xsl:when test="$UOMRaw = '1'">
								<xsl:choose>
									<xsl:when test="$CustomerFlag = $PBR">E</xsl:when>
									<xsl:otherwise>EA</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$CustomerFlag = $PBR">C</xsl:when>
									<xsl:otherwise>CS</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="concat($sProductCode,'-',$UOM)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$sProductCode"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
