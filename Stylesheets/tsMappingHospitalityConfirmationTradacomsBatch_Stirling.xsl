<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations

	Bibendum confirmations

**********************************************************************
Name			| Date				| Change
**********************************************************************
     ?     	|       ?    		| Created Module
**********************************************************************
H Mahbub	|	2010-05-17		| Created file
**********************************************************************
 			|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output encoding="utf-8"/>
		
	<!-- The structure of the interal XML varries depending on who the customer is -->
	
	<!-- All documents in the batch will be for the same customer/agreement -->	
	<xsl:variable name="COMPASS" select="'COMPASS'"/>
	<xsl:variable name="TESCO" select="'TESCO'"/>
	<xsl:variable name="ARAMARK" select="'ARAMARK'"/>
	<xsl:variable name="BEACON_PURCHASING" select="'BEACON_PURCHASING'"/>
	<xsl:variable name="SSP" select="'SSP'"/>
	<xsl:variable name="GIRAFFE" select="'GIRAFFE'"/>
	<xsl:variable name="WAHACA" select="'WAHACA'"/>
	<xsl:variable name="FOODANDFUEL" select="'FOODANDFUEL'"/>
	<xsl:variable name="RISINGSTAR" select="'RISINGSTAR'"/>
	<xsl:variable name="SPAGHETTI" select="'SPAGHETTI'"/>
	<xsl:variable name="LONDONCLUBS" select="'LONDONCLUBS'"/>
	<xsl:variable name="ZERODEGREES" select="'ZERODEGREES'"/>
	<xsl:variable name="SCLONDON" select="'SCLONDON'"/>
	<xsl:variable name="SEARCYS" select="'SEARCYS'"/>
	<xsl:variable name="DANDD" select="'DANDD'"/>
	<xsl:variable name="DEVERE" select="'DEVERE'"/>
	<xsl:variable name="MALMAISON" select="MALMAISON"/>
	
	
	
	<xsl:variable name="CustomerFlag">
		<xsl:variable name="accountCode" select="string(//PurchaseOrderConfirmation/TradeSimpleHeader/SendersBranchReference)"/>
	
		<xsl:choose>
			<xsl:when test="$accountCode = 'MIL14T'"><xsl:value-of select="$COMPASS"/></xsl:when>
			<xsl:when test="$accountCode = 'FMC01T'"><xsl:value-of select="$COMPASS"/></xsl:when>
			
			<xsl:when test="$accountCode = 'TES01T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES08T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES12T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES15T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES25T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'ARA02T'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'BEACON'"><xsl:value-of select="$BEACON_PURCHASING"/></xsl:when>
			<xsl:when test="$accountCode = 'SSP25T'"><xsl:value-of select="$SSP"/></xsl:when>
			<xsl:when test="$accountCode = 'GIR01T'"><xsl:value-of select="$GIRAFFE"/></xsl:when>
			<xsl:when test="$accountCode = 'WAH01D'"><xsl:value-of select="$WAHACA"/></xsl:when>
			<xsl:when test="$accountCode = 'FOO01D'"><xsl:value-of select="$FOODANDFUEL"/></xsl:when>
			<xsl:when test="$accountCode = 'RIS01D'"><xsl:value-of select="$RISINGSTAR"/></xsl:when>
			<xsl:when test="$accountCode = 'SPA01D'"><xsl:value-of select="$SPAGHETTI"/></xsl:when>
			<xsl:when test="$accountCode = 'LSQ01D'"><xsl:value-of select="$LONDONCLUBS"/></xsl:when>
			<xsl:when test="$accountCode = 'ZER01D'"><xsl:value-of select="$ZERODEGREES"/></xsl:when>
			<xsl:when test="$accountCode = 'MOR01T'"><xsl:value-of select="$SCLONDON"/></xsl:when>
			<xsl:when test="$accountCode = 'SEA01D'"><xsl:value-of select="$SEARCYS"/></xsl:when>
			<xsl:when test="$accountCode = 'DAD01T'"><xsl:value-of select="$DANDD"/></xsl:when>
			<xsl:when test="$accountCode = 'DEV01T'"><xsl:value-of select="$DEVERE"/></xsl:when>
			<xsl:when test="$accountCode = 'MAL01D'"><xsl:value-of select="$MALMAISON"/></xsl:when>
			
			

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
							<!--xsl:when test="SendersBranchReference = 'MIL14T'">MIL14T</xsl:when>
							<xsl:when test="SendersBranchReference = 'FMC01T'">FMC01T</xsl:when>
							<xsl:when test="SendersBranchReference = 'TES01T'">TES01T</xsl:when>					
							<xsl:when test="SendersBranchReference = 'TES08T'">TES08T</xsl:when>					
							<xsl:when test="SendersBranchReference = 'TES12T'">TES12T</xsl:when>					
							<xsl:when test="SendersBranchReference = 'TES15T'">TES15T</xsl:when>					
							<xsl:when test="SendersBranchReference = 'TES25T'">TES25T</xsl:when-->	
					
						<xsl:when test="$CustomerFlag = $COMPASS or $CustomerFlag = $TESCO or $CustomerFlag = $BEACON_PURCHASING ">
						<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/SendersBranchReference"/>
						</xsl:when>			
									
						<xsl:otherwise>
							<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/SendersCodeForRecipient"/>
						</xsl:otherwise>
					
					</xsl:choose>
				</SendersCodeForRecipient>
			
				<!--xsl:if test="SendersBranchReference = 'MIL14T' or SendersBranchReference = 'FMC01T' or SendersBranchReference = 'TES01T'"-->
				<!--xsl:if test="SendersBranchReference">
					<xsl:if test="contains('MIL14T~FMC01T~TES01T~TES08T~TES12T~TES15T~TES25T',SendersBranchReference)"-->
				<xsl:if test="$CustomerFlag = $COMPASS or $CustomerFlag = $TESCO or $CustomerFlag = $ARAMARK">
					<SendersBranchReference>
						<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/SendersBranchReference"/>
					</SendersBranchReference>
				</xsl:if>
				<!--/xsl:if>
				</xsl:if-->
			</TradeSimpleHeader>		
				<!--<TradeSimpleHeader>
					<xsl:copy-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/SendersCodeForRecipient"/>
					<xsl:copy-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/SendersBranchReference"/>
				</TradeSimpleHeader-->
				<PurchaseOrderConfirmationHeader>
					<DocumentStatus>Original</DocumentStatus>
					<Buyer>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/*"/>				
						<!--BuyersLocationID>
							<GLN/>
						</BuyersLocationID-->
					</Buyer>
					<Supplier>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/*"/>
						<!--SuppliersLocationID>
							<GLN/>
						</SuppliersLocationID-->
					</Supplier>
					<ShipTo>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/*"/>
						<!--ShipToLocationID>
							<GLN/>
						</ShipToLocationID>
						<ShipToAddress>
							<AddressLine1/>
						</ShipToAddress-->
					</ShipTo>
					<PurchaseOrderReferences>
						<!--PurchaseOrderReference>
							<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
						</PurchaseOrderReference>
						<PurchaseOrderDate>
							<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
						</PurchaseOrderDate-->
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/*"/>
					</PurchaseOrderReferences>
					
					<PurchaseOrderConfirmationReferences>
						<!--PurchaseOrderConfirmationReference>
							<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
						</PurchaseOrderConfirmationReference>
						<PurchaseOrderConfirmationDate>
							<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
						</PurchaseOrderConfirmationDate-->
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/*"/>
					</PurchaseOrderConfirmationReferences>
					
					<OrderedDeliveryDetails>
						<!--DeliveryType></DeliveryType-->
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate"/>
						<!--DeliveryDate><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate"/></DeliveryDate-->
					</OrderedDeliveryDetails>
					<ConfirmedDeliveryDetails>
						<!--DeliveryType/-->
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
						
						<!--DeliveryDate><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/></DeliveryDate-->
					</ConfirmedDeliveryDetails>
				</PurchaseOrderConfirmationHeader>
				<PurchaseOrderConfirmationDetail>
					<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
						<PurchaseOrderConfirmationLine>
							<LineNumber>
								<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
							</LineNumber>
							<ProductID>
								<!--GTIN>55555555555555</GTIN>
								<SuppliersProductCode>
									<xsl:value-of select="SuppliersProductCode"/>
								</SuppliersProductCode>
								<xsl:if test="string(BuyersProductCode) != ''">
									<BuyersProductCode>
										<xsl:value-of select="BuyersProductCode"/>
									</BuyersProductCode>
								</xsl:if-->
								<!--xsl:apply-templates select="ProductID/*"/-->
								
								<SuppliersProductCode>
									<xsl:value-of select="ProductID/SuppliersProductCode"/>
									<xsl:if test="$CustomerFlag = $SSP or $CustomerFlag = $GIRAFFE or $CustomerFlag = $WAHACA or $CustomerFlag = $FOODANDFUEL or $CustomerFlag = $RISINGSTAR or $CustomerFlag = $SPAGHETTI or $CustomerFlag = $LONDONCLUBS or $CustomerFlag = $ZERODEGREES or $CustomerFlag = $SCLONDON or $CustomerFlag = $SEARCYS or $CustomerFlag = $DANDD or $CustomerFlag = $DEVERE or $CustomerFlag = $MALMAISON">
										<!--xsl:choose>
											<xsl:when test="translate(PackSize,' ','') ='1x1kg'">-EA</xsl:when>
											<xsl:when test="contains(PackSize,'x')">-CS</xsl:when>
											<xsl:otherwise>-EA</xsl:otherwise>
										</xsl:choose-->		
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
							<!--OrderedQuantity>
								<xsl:copy-of select="ConfirmedQuantity/@UnitOfMeasure"/>
								<xsl:value-of select="format-number(OrderedQuantity div 1000,'0.00')"/>
							</OrderedQuantity-->
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
		<!--xsl:with-param name="vobjAddressElements"/-->
				
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
