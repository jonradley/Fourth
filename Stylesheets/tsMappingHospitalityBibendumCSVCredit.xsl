<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations

	Bibendum inbound credit note translator

**********************************************************************
Name			| Date		| Change
**********************************************************************
Lee Boyton        | 2009-04-28 | 2867. Translate product codes for SSP
                          |                     | to ensure they are unique (product code plus UOM on the end).				
**********************************************************************
H Robson		|	2012-02-01		| 5226 change Aramark onto the default way of handling the Product Code
*********************************************************************
K Oshaughnessy|2012-08-29| Additional customer added (Mitie) FB 5664	
*********************************************************************
A Barber		|	2012-08-29		| 5709 Added no UOM append product code handling for PBR.	
*******************************************************************
H Mahbub		|	2012-10-12		| Adding new Compass Vendor code FB 5780
*********************************************************************
H Robson		|	2013-03-26		| 6285 Added Creative Events	
*********************************************************************
H Robson		|	2013-05-07		| 6496 PBR append UoM to product code	
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" encoding="UTF-8"/>
	
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
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
<BatchRoot>
		<xsl:apply-templates/>
</BatchRoot>
	</xsl:template>
	
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!--Then let attributes be copied/not copied/modified by other more specific templates -->
			<xsl:apply-templates select="@*"/>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	
	<!-- Bug fix where they incorrectly send multiple invoice structures within each BatchDocument -->
	<xsl:template match="BatchDocument">
		<!-- Now run the following for every invoice found within this BatchDocument element, even if there is only one -->
		<xsl:for-each select="CreditNote">
			<!-- Each time we find an invoice element, first (repeat) copy the BatchDocument element -->
			<xsl:element name="BatchDocument">
				<!-- Now process the invoice -->
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			<!-- And before looking for another invoice, (repeat) close the BatchDocument element -->
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<!-- Handle the MIL14T and FMC01T Account -->
	<xsl:template match="TradeSimpleHeader">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:choose>
					<xsl:when test="SendersBranchReference = 'MIL14T'">MIL14T</xsl:when>
					<xsl:when test="SendersBranchReference = 'COM2012T'">COM2012T</xsl:when>
					<xsl:when test="SendersBranchReference = 'FMC01T'">FMC01T</xsl:when>
					<xsl:when test="SendersBranchReference = 'TES01T'">TES01T</xsl:when>					
					<xsl:when test="SendersBranchReference = 'TES08T'">TES08T</xsl:when>					
					<xsl:when test="SendersBranchReference = 'TES12T'">TES12T</xsl:when>					
					<xsl:when test="SendersBranchReference = 'TES15T'">TES15T</xsl:when>					
					<xsl:when test="SendersBranchReference = 'TES25T'">TES25T</xsl:when>
					<xsl:when test="SendersBranchReference = 'NOB06T'">ORI05T</xsl:when>
					<xsl:when test="SendersBranchReference = 'CRE11T'">CRE11T</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="SendersCodeForRecipient"/>
					</xsl:otherwise>
				</xsl:choose>
			</SendersCodeForRecipient>
			
			<!--xsl:if test="SendersBranchReference = 'MIL14T' or SendersBranchReference = 'FMC01T' or SendersBranchReference = 'TES01T'"-->
			<xsl:if test="contains('MIL14T~COM2012T~FMC01T~TES01T~TES08T~TES12T~TES15T~TES25T~MIT16T~CRE11T',SendersBranchReference)">
				<SendersBranchReference>
					<xsl:value-of select="SendersBranchReference"/>
				</SendersBranchReference>
			</xsl:if>
		</TradeSimpleHeader>
	</xsl:template>
	
	<xsl:template match="ShipToLocationID">
		<ShipToLocationID>
			<SuppliersCode>
				<xsl:value-of select="SuppliersCode"/>
			</SuppliersCode>
			<xsl:if test="//TradeSimpleHeader/SendersBranchReference = 'MIL14T' or //TradeSimpleHeader/SendersBranchReference = 'COM2012T' or //TradeSimpleHeader/SendersBranchReference = 'FMC01T'">
				<BuyersCode>
					<xsl:value-of select="SuppliersCode"/>
				</BuyersCode>
			</xsl:if>
		</ShipToLocationID>
	</xsl:template>
	
	<xsl:template match="CreditNoteHeader/Supplier">
		<Supplier>
			<xsl:if test="//TradeSimpleHeader/SendersBranchReference = 'MIL14T' or //TradeSimpleHeader/SendersBranchReference = 'COM2012T' or //TradeSimpleHeader/SendersBranchReference = 'FMC01T'">
					<SuppliersLocationID>
					<SuppliersCode>Bibendum</SuppliersCode>
				</SuppliersLocationID>
			</xsl:if>
			<xsl:copy-of select="SuppliersName"/>
			<xsl:copy-of select="SuppliersAddress"/>
		</Supplier>
	</xsl:template>

	<xsl:template match="CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate">
		<xsl:if test=". != ''">
			<xsl:element name="InvoiceDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate">
		<xsl:if test=". != ''">
			<xsl:element name="CreditNoteDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate">
		<xsl:if test=". != ''">
			<xsl:element name="TaxPointDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderDate">
		<xsl:if test=". != ''">
			<xsl:element name="PurchaseOrderDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate">
		<xsl:if test=". != ''">
			<xsl:element name="DeliveryNoteDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	
	<!-- Sort out some Addresses -->
	<xsl:template match="BuyersAddress">
		<xsl:element name="BuyersAddress">
			<xsl:element name="AddressLine1">
				<xsl:value-of select="child::*[1]"/>
			</xsl:element>
			<xsl:element name="AddressLine2">
				<xsl:value-of select="child::*[2]"/>
			</xsl:element>
			<xsl:if test="child::*[3] != ''">
				<xsl:element name="AddressLine3">
					<xsl:value-of select="child::*[3]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[4] != ''">
				<xsl:element name="AddressLine4">
					<xsl:value-of select="child::*[4]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[5] != ''">
				<xsl:element name="PostCode">
					<xsl:value-of select="child::*[5]"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="SuppliersAddress">
		<xsl:element name="SuppliersAddress">
			<xsl:element name="AddressLine1">
				<xsl:value-of select="child::*[1]"/>
			</xsl:element>
			<xsl:element name="AddressLine2">
				<xsl:value-of select="child::*[2]"/>
			</xsl:element>
			<xsl:if test="child::*[3] != ''">
				<xsl:element name="AddressLine3">
					<xsl:value-of select="child::*[3]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[4] != ''">
				<xsl:element name="AddressLine4">
					<xsl:value-of select="child::*[4]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[5] != ''">
				<xsl:element name="PostCode">
					<xsl:value-of select="child::*[5]"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="ShipToAddress">
		<xsl:element name="ShipToAddress">
			<xsl:element name="AddressLine1">
				<xsl:value-of select="child::*[1]"/>
			</xsl:element>
			<xsl:element name="AddressLine2">
				<xsl:value-of select="child::*[2]"/>
			</xsl:element>
			<xsl:if test="child::*[3] != ''">
				<xsl:element name="AddressLine3">
					<xsl:value-of select="child::*[3]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[4] != ''">
				<xsl:element name="AddressLine4">
					<xsl:value-of select="child::*[4]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="child::*[5] != ''">
				<xsl:element name="PostCode">
					<xsl:value-of select="child::*[5]"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<!-- Sort VATCodes -->
	<xsl:template match="VATCode">
		<xsl:element name="VATCode">
			<xsl:call-template name="decodeVATCodes">
				<xsl:with-param name="sVATCode" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATCode">
		<xsl:attribute name="VATCode">
			<xsl:call-template name="decodeVATCodes">
				<xsl:with-param name="sVATCode" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<!-- SSP, GIRAFFE, WAHACA specific change to append the unit of measure onto the product code -->
	<xsl:template match="ProductID/SuppliersProductCode">
		<xsl:copy>
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
						<xsl:call-template name="decodePacks">
							<xsl:with-param name="sBibPack" select="../../Measure/UnitsInPack"/>
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="UOM">
						<xsl:choose>
							<xsl:when test="$UOMRaw = 1">
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
				
					<xsl:value-of select="concat(.,'-',$UOM)"/>
										
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<!-- Decode Bibendum's PackSizes -->
	<xsl:template match="CreditedQuantity">
		<xsl:element name="CreditedQuantity">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:variable name="UoM">
					<xsl:call-template name="decodePacks">
						<xsl:with-param name="sBibPack" select="following-sibling::Measure/UnitsInPack"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$UoM = 1">EA</xsl:when>
					<xsl:otherwise>CS</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="format-number(.,'0')"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="InvoicedQuantity">
		<xsl:element name="InvoicedQuantity">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:variable name="UoM">
					<xsl:call-template name="decodePacks">
						<xsl:with-param name="sBibPack" select="following-sibling::Measure/TotalMeasure"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$UoM = 1">EA</xsl:when>
					<xsl:otherwise>CS</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="format-number(.,'0')"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="Measure">
		<xsl:element name="Measure">
			<xsl:element name="UnitsInPack">
				<xsl:call-template name="decodePacks">
					<xsl:with-param name="sBibPack" select="UnitsInPack"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="TotalMeasure"></xsl:template>



	<!--  Format a YYMMDD as YYYY-MM-DD -->
	<xsl:template name="fixDate">
		<xsl:param name="sDate"/>
		<xsl:value-of select="concat(substring($sDate,1,4),'-',substring($sDate,5,2),'-',substring($sDate,7,2))"/>
	</xsl:template>

	<!-- Decode the VATCodes -->
	<xsl:template name="decodeVATCodes">
		<xsl:param name="sVATCode"/>
		<xsl:choose>
			<xsl:when test="$sVATCode = 'STD'">S</xsl:when>
			<xsl:when test="$sVATCode = 'EXEMPT'">E</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="decodePacks">
		<xsl:param name="sBibPack"/>
		<xsl:choose>
			<xsl:when test="normalize-space($sBibPack) = 'EACH' or normalize-space($sBibPack) = 'BOTTLE'">1</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(normalize-space($sBibPack),5)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
