<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2009-07-08		| 2991 Created Module
**********************************************************************
R Cambridge	| 2010-06-01		| 3551 Handle non-pl customers by using Supplier/@CustomerSupplierID as BuyersLocationID/SuppliersCode
													(this is infact the customer's code for the supplier - the wrong direction - 
													but it fits with what's set up and simplifies the set up of Voxel related relationships)
**********************************************************************
				|						|				
**********************************************************************
				|						|
**********************************************************************
				|						|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method="xml" encoding="UTF-8" />
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/Transaction">
	
		<xsl:variable name="siteCode">
			<xsl:value-of select="Customers/Customer/@SupplierClientID"/>
			<xsl:if test="string(Customers/Customer/@CustomerSecondaryID) != ''">
				<xsl:text> </xsl:text>
				<xsl:value-of select="Customers/Customer/@CustomerSecondaryID"/>
			</xsl:if>
		</xsl:variable>
		
		<BatchRoot>		

			<DeliveryNote>
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="$siteCode"/>
					</SendersCodeForRecipient>
					<SendersBranchReference><xsl:value-of select="Supplier/@CustomerSupplierID"/></SendersBranchReference>						
				</TradeSimpleHeader>
				<DeliveryNoteHeader>
	
					<Buyer>
						<BuyersLocationID>
							<xsl:for-each select="Client/@ClientID[. != ''][1]">
								<BuyersCode><xsl:value-of select="."/></BuyersCode>
							</xsl:for-each>
							<xsl:for-each select="Supplier/@CustomerSupplierID[. != ''][1]">
								<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
							</xsl:for-each>
						</BuyersLocationID>
						<BuyersName><xsl:value-of select="Client/@Company"/></BuyersName>
						<BuyersAddress>
							<AddressLine1><xsl:value-of select="Client/@Address"/></AddressLine1>
							<AddressLine2><xsl:value-of select="Client/@City"/></AddressLine2>
							<AddressLine3><xsl:value-of select="Client/@Province"/></AddressLine3>
							<AddressLine4>ESP</AddressLine4>
							<PostCode><xsl:value-of select="Client/@PC"/></PostCode>
						</BuyersAddress>
					</Buyer>
					
					<!-- Registry? -->
					
					<Supplier>
						<SuppliersLocationID>
							<BuyersCode><xsl:value-of select="Supplier/@CustomerSupplierID"/></BuyersCode>
							<xsl:for-each select="Supplier/@SupplierID[. != ''][1]">
								<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
							</xsl:for-each>						
						</SuppliersLocationID>
						<SuppliersName><xsl:value-of select="Supplier/@Company"/></SuppliersName>
						<SuppliersAddress>
							<AddressLine1><xsl:value-of select="Supplier/@Address"/></AddressLine1>
							<AddressLine2><xsl:value-of select="Supplier/@City"/></AddressLine2>
							<AddressLine3><xsl:value-of select="Supplier/@Province"/></AddressLine3>
							<AddressLine4>ESP</AddressLine4>
							<PostCode><xsl:value-of select="Supplier/@PC"/></PostCode>
						</SuppliersAddress>
					</Supplier>
					
					<!-- Registry? -->
					
					<ShipTo>
						<ShipToLocationID>
							<BuyersCode><xsl:value-of select="$siteCode"/></BuyersCode>
							<SuppliersCode><xsl:value-of select="$siteCode"/></SuppliersCode>
						
							<!-- Secondary codes? -->
						
						</ShipToLocationID>
						<ShipToName><xsl:value-of select="Customers/Customer/@Customer"/></ShipToName>
						<ShipToAddress>
							<AddressLine1><xsl:value-of select="Customers/Customer/@Address"/></AddressLine1>
							<AddressLine2><xsl:value-of select="Customers/Customer/@City"/></AddressLine2>
							<AddressLine3><xsl:value-of select="Customers/Customer/@Province"/></AddressLine3>
							<AddressLine4>ESP</AddressLine4>
							<PostCode><xsl:value-of select="Customers/Customer/@PC"/></PostCode>
						</ShipToAddress>
						<!--ContactName/-->
					</ShipTo>				
					
					<PurchaseOrderReferences>
						<PurchaseOrderReference><xsl:value-of select="/Transaction/References/Reference/@PORef"/></PurchaseOrderReference>
						<xsl:for-each select="/Transaction/References/Reference/@PORefDate[. != ''][1]">
							<PurchaseOrderDate><xsl:value-of select="."/></PurchaseOrderDate>
						</xsl:for-each>
					</PurchaseOrderReferences>					
					
	
					<DeliveryNoteReferences>
						<DeliveryNoteReference><xsl:value-of select="GeneralData/@Ref"/></DeliveryNoteReference>
						<DeliveryNoteDate><xsl:value-of select="substring-before(concat(GeneralData/@Date,'T'), 'T')"/></DeliveryNoteDate>									
					</DeliveryNoteReferences>	
				
				</DeliveryNoteHeader>	
				
				
				<DeliveryNoteDetail>
							
					<xsl:for-each select="ProductList/Product">
				
						<DeliveryNoteLine>
											
							<ProductID>
								<SuppliersProductCode><xsl:value-of select="@SupplierSKU"/></SuppliersProductCode>
							</ProductID>
							
							<ProductDescription><xsl:value-of select="@Item"/></ProductDescription>
							
							<DespatchedQuantity>
								<xsl:attribute name="UnitOfMeasure">
										<xsl:call-template name="transUoM">
											<xsl:with-param name="voxelUoM" select="@MU"/>
										</xsl:call-template>										
								</xsl:attribute>
								<xsl:value-of select="@Qty"/>
							</DespatchedQuantity>
							
							<UnitValueExclVAT><xsl:value-of select="@UP"/></UnitValueExclVAT>
							<!--LineValueExclVAT><xsl:value-of select="@Total"/></LineValueExclVAT-->
							
							<!-- Fees -->
							
							<!-- live level doc refs same as header level references? -->
							
						</DeliveryNoteLine>
						
					</xsl:for-each>
						
				</DeliveryNoteDetail>
				
			</DeliveryNote>
	
		</BatchRoot>

	</xsl:template>

	<xsl:template name="transUoM">
		<xsl:param name="voxelUoM"/>
	
		<xsl:choose>
			<xsl:when test="translate($voxelUoM, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'unidades'">EA</xsl:when>
			<xsl:when test="translate($voxelUoM, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'cajas'">CS</xsl:when>
			<xsl:when test="translate($voxelUoM, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'kgs'">KGM</xsl:when>
		</xsl:choose>
	
	</xsl:template>


</xsl:stylesheet>
