<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations

	Bibendum confirmations

**********************************************************************
Name			| Date				| Change
**********************************************************************
     ?     	|       ?    		| Created Module
**********************************************************************
H Mahbub		|	2010-05-17		| Created file
**********************************************************************
R Cambridge	|	2011-08-24		| 4743 change product code manipulation to be default (hard code a list of customer that will no require it)
**********************************************************************
H Robson		|	2012-02-01		| 5226 change Aramark onto the default way of handling the Product Code
*********************************************************************
K Oshaughnessy|2012-08-29| Additional customer added (Mitie) FB 5664
*********************************************************************
A Barber		|	2012-08-29		| 5709 Added no UOM append product code handling for PBR.	
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output encoding="utf-8"/>
		
	<!-- The structure of the interal XML varries depending on who the customer is -->
	<!-- UoM may not be added to product codes for these customers -->
	
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
		<xsl:variable name="accountCode" select="string(//PurchaseOrderConfirmation/TradeSimpleHeader/SendersBranchReference)"/>
	
		<xsl:choose>
			
			<xsl:when test="$accountCode = '203909'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'ARA02T'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'ARANET'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'BEACON'"><xsl:value-of select="$BEACON_PURCHASING"/></xsl:when>
			<xsl:when test="$accountCode = 'MIL14T'"><xsl:value-of select="$COMPASS"/></xsl:when>
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
			<PurchaseOrderConfirmation>
			
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:choose>	
					
							<xsl:when test=" $CustomerFlag = $COMPASS or $CustomerFlag = $TESCO or $CustomerFlag = $BEACON_PURCHASING ">
								<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/SendersBranchReference"/>
							</xsl:when>			
										
							<xsl:otherwise>
								<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/SendersCodeForRecipient"/>
							</xsl:otherwise>
						
						</xsl:choose>
					</SendersCodeForRecipient>
			
					<xsl:if test="$CustomerFlag = $MITIE or $CustomerFlag = $COMPASS or $CustomerFlag = $TESCO or $CustomerFlag = $ARAMARK">
						<SendersBranchReference>
							<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/SendersBranchReference"/>
						</SendersBranchReference>
					</xsl:if>

				</TradeSimpleHeader>		

				<PurchaseOrderConfirmationHeader>
				
					<DocumentStatus>Original</DocumentStatus>
					<Buyer>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/*"/>
					</Buyer>
					<Supplier>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/*"/>
					</Supplier>
					<ShipTo>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/*"/>
					</ShipTo>
					<PurchaseOrderReferences>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/*"/>
					</PurchaseOrderReferences>
					
					<PurchaseOrderConfirmationReferences>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/*"/>
					</PurchaseOrderConfirmationReferences>
					
					<OrderedDeliveryDetails>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate"/>
					</OrderedDeliveryDetails>
					<ConfirmedDeliveryDetails>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
					</ConfirmedDeliveryDetails>
					
				</PurchaseOrderConfirmationHeader>
				
				<PurchaseOrderConfirmationDetail>
				
					<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
						<PurchaseOrderConfirmationLine>
							<LineNumber>
								<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
							</LineNumber>
							<ProductID>
								
								<SuppliersProductCode>
									
									<xsl:value-of select="ProductID/SuppliersProductCode"/>
									<!-- 2012-02-01 - removed ARAMARK from this list, UoM SHOULD be added to product codes for them -->
									<xsl:if test="not(
										$CustomerFlag = $COMPASS or
										$CustomerFlag = $COOP  or
										$CustomerFlag = $FISHWORKS or
										$CustomerFlag = $MCC  or
										$CustomerFlag = $ORCHID or
										$CustomerFlag = $PBR or
										$CustomerFlag = $SEARCYS or
										$CustomerFlag = $SODEXO_PRESTIGE)">	
										<xsl:choose>
											<xsl:when test="ConfirmedQuantity/@UnitOfMeasure = 'EA'">-EA</xsl:when>
											<xsl:when test="ConfirmedQuantity/@UnitOfMeasure = 'CS'">-CS</xsl:when>
										</xsl:choose>										
									</xsl:if>	
								</SuppliersProductCode>
								
							</ProductID>
							<ProductDescription>
								<xsl:value-of select="ProductDescription"/>
							</ProductDescription>


							<ConfirmedQuantity>
								<xsl:copy-of select="ConfirmedQuantity/@UnitOfMeasure"/>
								<xsl:value-of select="format-number(ConfirmedQuantity div 1000,'0.00')"/>
							</ConfirmedQuantity>
							
							<xsl:for-each select="PackSize[1]">
								<PackSize><xsl:value-of select="."/></PackSize>
							</xsl:for-each>
							
						</PurchaseOrderConfirmationLine>
					</xsl:for-each>
					
				</PurchaseOrderConfirmationDetail>
				
			</PurchaseOrderConfirmation>
			
		</BatchRoot>	
		
	</xsl:template>
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="BuyersAddress | SuppliersAddress | ShipToAddress">
				
		<xsl:copy>
			<xsl:for-each select="*[contains(name(),'Address')][string(.) != '']">
				<xsl:element name="{concat('AddressLine', position())}"><xsl:value-of select="."/></xsl:element>		
			</xsl:for-each>
			<PostCode><xsl:value-of select="PostCode"/></PostCode>
		</xsl:copy>
	
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDate | PurchaseOrderConfirmationDate | DeliveryDate">
		<xsl:copy>
			<xsl:value-of select="concat('20',substring(.,1,2),'-',substring(.,3,2),'-',substring(.,5,2))"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
