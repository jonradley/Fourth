<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations

	Bibendum inbound invoice translator

**********************************************************************
Name			| Date				| Change
**********************************************************************
     ?     		|       ?    			| Created Module
**********************************************************************
R Cambridge 	|	2008-10-15	| PO ref mod	
**********************************************************************
Lee Boyton  	| 2009-04-28 		| 2867. Translate product codes for SSP
                    |                     	| to ensure they are unique (product code plus UOM on the end).				
**********************************************************************
H Robson		|	2012-02-01	| 5226 change Aramark onto the default way of handling the Product Code
*********************************************************************		
KOshaughnessy| 2012-05-24	| 5490 Change for new Olympic vendor agreement (Compass)	
*********************************************************************
K Oshaughnessy|2012-08-29| Additional customer added (Mitie) FB 5664	
*********************************************************************
A Barber		|	2012-08-29		| 5709 Added no UOM append product code handling for PBR.	
*********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	
	<!-- The structure of the interal XML varries depending on who the customer is -->
	
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
	
	<xsl:variable name="CustomerFlag">
		<xsl:variable name="accountCode" select="string(//Invoice/TradeSimpleHeader/SendersBranchReference)"/>
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
		<xsl:for-each select="Invoice">
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
				
					<xsl:when test="$CustomerFlag = $COMPASS or $CustomerFlag = $TESCO or $CustomerFlag = $BEACON_PURCHASING">
						<xsl:value-of select="SendersBranchReference"/>
					</xsl:when>			
									
					<xsl:otherwise>
						<xsl:value-of select="SendersCodeForRecipient"/>
					</xsl:otherwise>
					
				</xsl:choose>
			</SendersCodeForRecipient>
			
			<xsl:if test="$CustomerFlag = $MITIE or $CustomerFlag = $COMPASS or $CustomerFlag = $TESCO or $CustomerFlag = $ARAMARK">
				<SendersBranchReference>
					<xsl:value-of select="SendersBranchReference"/>
				</SendersBranchReference>
			</xsl:if>
		</TradeSimpleHeader>
	</xsl:template>
	
	<xsl:template match="ShipTo">
		<ShipTo>
			<xsl:if test="ShipToLocationID or $CustomerFlag = $TESCO">
				<ShipToLocationID>
					<xsl:if test="$CustomerFlag = $TESCO">
						<GLN>
							<xsl:value-of select="ShipToAddress/AddressLine1"/>
						</GLN>
					</xsl:if>
					<xsl:copy-of select="ShipToLocationID/SuppliersCode"/>
					<xsl:if test="$CustomerFlag = $COMPASS or $CustomerFlag = $BEACON_PURCHASING">
						<BuyersCode>
							<xsl:value-of select="ShipToLocationID/SuppliersCode"/>
						</BuyersCode>
					</xsl:if>
				</ShipToLocationID>
			</xsl:if>
			<xsl:copy-of select="ShipToName"/>
			<xsl:copy-of select="ShipToAddress"/>
		</ShipTo>
	</xsl:template>
	
	<xsl:template match="InvoiceHeader/Supplier">
		<Supplier>
			<xsl:if test="$CustomerFlag = $COMPASS">
				<SuppliersLocationID>
					<SuppliersCode>Bibendum</SuppliersCode>
				</SuppliersLocationID>
			</xsl:if>
			<xsl:copy-of select="SuppliersName"/>
			<xsl:copy-of select="SuppliersAddress"/>
		</Supplier>
	</xsl:template>
	
	<!-- sort all the dates in the file -->
	<xsl:template match="InvoiceHeader/BatchInformation/FileCreationDate">
		<xsl:if test=". != ''">
			<xsl:element name="FileCreationDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="InvoiceHeader/InvoiceReferences/InvoiceDate">
		<xsl:if test=". != ''">
			<xsl:element name="InvoiceDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="InvoiceHeader/InvoiceReferences/TaxPointDate">
		<xsl:if test=". != ''">
			<xsl:element name="TaxPointDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate">
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
	
	<!-- Sort out some numbers -->
	<xsl:template match="VATRate">
		<xsl:element name="VATRate">
			<xsl:value-of select="format-number((. div 1000),'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATRate">
		<xsl:attribute name="VATRate">
			<xsl:value-of select="format-number((. div 1000),'0.00')"/>
		</xsl:attribute>
	</xsl:template>	
	<xsl:template match="DocumentTotalExclVATAtRate">
		<xsl:element name="DocumentTotalExclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalExclVATAtRate">
		<xsl:element name="SettlementTotalExclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="VATAmountAtRate">
		<xsl:element name="VATAmountAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="DocumentTotalInclVATAtRate">
		<xsl:element name="DocumentTotalInclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalInclVATAtRate">
		<xsl:element name="SettlementTotalInclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="DocumentTotalExclVAT">
		<xsl:element name="DocumentTotalExclVAT">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalExclVAT">
		<xsl:element name="SettlementTotalExclVAT">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="VATAmount">
		<xsl:element name="VATAmount">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalInclVAT">
		<xsl:element name="SettlementTotalInclVAT">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="LineValueExclVAT">
		<xsl:element name="LineValueExclVAT">
			<xsl:value-of select="format-number(. div 10000,'0.0000')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="NumberOfLinesAtRate">
		<xsl:element name="NumberOfLinesAtRate">
			<xsl:value-of select="format-number(.,'0')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="DocumentTotalExclVATAtRate">
		<xsl:element name="DocumentTotalExclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementDiscountAtRate">
		<xsl:element name="SettlementDiscountAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementTotalExclVATAtRate">
		<xsl:element name="SettlementTotalExclVATAtRate">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SettlementDiscount">
		<xsl:element name="SettlementDiscount">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="DocumentTotalInclVAT">
		<xsl:element name="DocumentTotalInclVAT">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>

	<!-- SSP specific change to append the unit of measure onto the product code -->
	<xsl:template match="ProductID/SuppliersProductCode">
		<xsl:copy>
			<xsl:choose>
				<!-- UoM may not be added to product codes for these customers -->
				<!-- 2012-02-01 - removed ARAMARK from this list, UoM SHOULD be added to product codes for them -->
				<xsl:when test="not($CustomerFlag = $COMPASS or $CustomerFlag = $COOP  or $CustomerFlag = $FISHWORKS or $CustomerFlag = $MCC  or $CustomerFlag = $ORCHID or $CustomerFlag = $PBR or $CustomerFlag = $SEARCYS or $CustomerFlag = $SODEXO_PRESTIGE)">

					<!-- translate the Units In Pack value and then append this to the product code -->
					<xsl:variable name="UOMRaw">
						<xsl:call-template name="decodePacks">
							<xsl:with-param name="sBibPack" select="../../Measure/UnitsInPack"/>
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="UOM">
						<xsl:choose>
							<xsl:when test="$UOMRaw = 1">EA</xsl:when>
							<xsl:otherwise>CS</xsl:otherwise>
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
	<xsl:template match="InvoicedQuantity">
		<xsl:element name="InvoicedQuantity">
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

	<xsl:template match="UnitValueExclVAT">
		<xsl:element name="UnitValueExclVAT">
			<xsl:variable name="UnitsInOrderedPack">
				<xsl:call-template name="decodePacks">
					<xsl:with-param name="sBibPack" select="following-sibling::Measure/UnitsInPack"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="UnitsInPricedPack">
				<xsl:value-of select="preceding-sibling::LineNumber"/>
			</xsl:variable>
			<xsl:variable name="QtyInvoiced">
				<xsl:value-of select="preceding-sibling::InvoicedQuantity"/>
			</xsl:variable>
			<xsl:variable name="UnitValue">
				<xsl:value-of select="format-number(. div 10000,'0.0000')"/>
			</xsl:variable>
			<!-- Leave the price blank to fail validation if there is no order basis -->
			<xsl:if test="$UnitsInOrderedPack != 	''">
				<!-- Round to 3dp for Compass or 2 for everyone else -->
				<xsl:choose>
					<xsl:when test="$CustomerFlag = $COMPASS">
						<xsl:value-of select="format-number($UnitValue div ($UnitsInPricedPack div $UnitsInOrderedPack),'0.000')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number($UnitValue div ($UnitsInPricedPack div $UnitsInOrderedPack),'0.00')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
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

	<xsl:template match="PurchaseOrderReferences">
		
		<PurchaseOrderReferences>
						
			<PurchaseOrderReference>
			
				<xsl:choose>
				
					<xsl:when test="$CustomerFlag = $TESCO">
					
						<!-- PO ref and date are stored in PO ref field format = nnn-nnnnn yymmdd or nnnnnnnn yymmdd -->
						<xsl:variable name="allNumericPORef" select="translate(substring-before(PurchaseOrderReference,' '),'-','')"/>
						
						<xsl:value-of select="$allNumericPORef"/>
					
					</xsl:when>
					
					<xsl:otherwise>
					
						<xsl:choose>
							<xsl:when test="PurchaseOrderReference != ''">
								<xsl:value-of select="PurchaseOrderReference"/>
							</xsl:when>
							<xsl:otherwise>Not Provided</xsl:otherwise>
						</xsl:choose>
					
					</xsl:otherwise>
					
				</xsl:choose>

			</PurchaseOrderReference>
			
			<xsl:if test="$CustomerFlag = $TESCO">
			
				<PurchaseOrderDate>
			
					<xsl:call-template name="fixDate">
						<xsl:with-param name="sDate" select="substring-after(PurchaseOrderReference,' ')"/>
					</xsl:call-template>
				
				</PurchaseOrderDate>
						
			</xsl:if>
				
			<xsl:if test="not(normalize-space(TradeAgreement/ContractReference) = 'TRADE' or normalize-space(TradeAgreement/ContractReference) = '')">
				<TradeAgreement>
					<ContractReference>
						<xsl:value-of select="normalize-space(TradeAgreement/ContractReference)"/>
					</ContractReference>
				</TradeAgreement>
			</xsl:if>
			
		</PurchaseOrderReferences>
		
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

	<xsl:template match="LineNumber">
	</xsl:template>
	
	<!--  Format a YYMMDD as YYYY-MM-DD -->
	<xsl:template name="fixDate">
		<xsl:param name="sDate"/>
		<xsl:value-of select="concat('20',substring($sDate,1,2),'-',substring($sDate,3,2),'-',substring($sDate,5,2))"/>
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
			<xsl:when test="normalize-space(substring($sBibPack,1,5)) = 'STRIP'">
					<xsl:value-of select="substring(normalize-space($sBibPack),6)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(normalize-space($sBibPack),5)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
