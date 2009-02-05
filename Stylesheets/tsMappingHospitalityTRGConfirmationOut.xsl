<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TRG mapper for confirmations to Alphameric 

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 23/08/2007	| R Cambridge		| FB1400 Created module 
==========================================================================================
 21/10/2008	| R Cambridge     	| 2524 temporary fix to ignore split pack info for some suppliers
==========================================================================================
 04/02/2009	| Rave Tech  		| 2719 Consolidate twice appearing product code into one line using non-supersession price.
==========================================================================================
			|					|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:include href="tsMappingHospitalityTRG_SupplierSplitPackLogic.xsl"/>
	
	<xsl:variable name="sProcessMaxSplits">
		<xsl:call-template name="sProcessMaxSplits">
			<xsl:with-param name="vsSupplierCode" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/BuyersCode"/>	
		</xsl:call-template>
	</xsl:variable>	
	
	<xsl:template match="/PurchaseOrderConfirmation">
	
		<Order>

			<xsl:attribute name="Type">
				<xsl:value-of select="'Confirmation'"/>
			</xsl:attribute>
			
			<xsl:attribute name="OrderID">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			</xsl:attribute>
			<xsl:attribute name="UserReference">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
			</xsl:attribute>
			<xsl:attribute name="Description">
				<xsl:value-of select="'tradesimple'"/>
			</xsl:attribute>
			
			<xsl:attribute name="Total">
				<xsl:value-of select="PurchaseOrderConfirmationTrailer/TotalExclVAT"/>
			</xsl:attribute>
			
			<xsl:attribute name="DateEntered">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DateChanged">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="TargetDeliveryDate">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</xsl:attribute>
			
			<xsl:attribute name="SupplierId">
				<xsl:value-of select="'0'"/>
			</xsl:attribute>
			<xsl:attribute name="SupplierCode">
				<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
			</xsl:attribute>
			
			<xsl:attribute name="LocationId">
				<xsl:value-of select="'0'"/>
			</xsl:attribute>
			<xsl:attribute name="LocationCode">
				<xsl:value-of select="concat('RG',TradeSimpleHeader/RecipientsBranchReference,'/4')"/>
			</xsl:attribute>
			
			<xsl:attribute name="OrderDateTime">
				<xsl:choose>
					<xsl:when test="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderTime != ''">
						<xsl:value-of select="concat(PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate,'T',PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderTime)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate,'T00:00:00')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:attribute name="LocationGuid">
				<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
			</xsl:attribute>
			
			<xsl:attribute name="SupplierGuid">
				<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
			</xsl:attribute>

			<!-- For any line that says it's not a substitution.... -->
			<!-- ... or any line that says it is but the line for the ordered item isn't present -->
			<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[not(SubstitutedProductID/SuppliersProductCode = /PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/ProductID/SuppliersProductCode)]">

				<xsl:variable name="sLineStatus">
					<xsl:value-of select="current()/@LineStatus"/>
				</xsl:variable>
				<xsl:variable name="nQuantity">
					<xsl:value-of select="current()/ConfirmedQuantity"/>
				</xsl:variable>
				<xsl:variable name="nUnitValue">
					<xsl:value-of select="current()/UnitValueExclVAT"/>
				</xsl:variable>
				
				<xsl:variable name="objCurrentLine" select="current()"/>
												
				<xsl:variable name="SkipLine">
					<xsl:for-each select="//PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[.!=$objCurrentLine and ProductID/SuppliersProductCode = $objCurrentLine/ProductID/SuppliersProductCode]">
						<xsl:choose>
							<xsl:when test="current()/@LineStatus='Accepted' and $sLineStatus='Added'" >
								<xsl:text>True</xsl:text> 
							</xsl:when>
							<xsl:when test="current()/@LineStatus='Added' and $sLineStatus='Accepted'">
								<xsl:text>XML to process</xsl:text>
								<OrderItem>
									<xsl:call-template name="WriteLine2">
										<xsl:with-param name="vQuantity"><xsl:value-of select="current()/ConfirmedQuantity + $nQuantity"/></xsl:with-param>
										<xsl:with-param name="vUnitValue"><xsl:value-of select="$nUnitValue"/></xsl:with-param>
									</xsl:call-template>
								</OrderItem>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				
				<!--Output variable value-->
				<xsl:if test="$SkipLine!='' and $SkipLine!='True'">
					<xsl:copy-of select="msxsl:node-set($SkipLine)/*"/>
				</xsl:if>

				<xsl:if test="$SkipLine = ''">
					<!-- write the details of this line -->
					<OrderItem>
						<xsl:call-template name="writeLine"/>
						<!-- write the details of the lines that say they are substitions for this line -->
						<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[SubstitutedProductID/SuppliersProductCode = current()/ProductID/SuppliersProductCode]">
							<OrderItem>
								<xsl:call-template name="writeLine"/>	
							</OrderItem>	
						</xsl:for-each>
					</OrderItem>	
				</xsl:if>
			</xsl:for-each>
		</Order>
		
	</xsl:template>
	
	<xsl:template name="writeLine">
		<xsl:attribute name="SupplierProductCode">
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
		</xsl:attribute>	
		<xsl:attribute name="Quantity">		
			<xsl:choose>
				<xsl:when test="$sProcessMaxSplits = $IGNORE_MAXSPLITS">
					<xsl:value-of select="format-number(ConfirmedQuantity,'0.00000000000000')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(ConfirmedQuantity div MaxSplits,'0.00000000000000')"/>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:attribute>
		<xsl:attribute name="MajorUnitPrice">
			<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
		</xsl:attribute>
		<xsl:attribute name="SupplierPackageGuid">
			<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
		</xsl:attribute>	
		<xsl:attribute name="MaxSplits">
			<xsl:value-of select="MaxSplits"/>
		</xsl:attribute>	
	</xsl:template>
	
	<xsl:template name="WriteLine2">
		<xsl:param name="vQuantity"/>
		<xsl:param name="vUnitValue"/>
	
		<xsl:attribute name="SupplierProductCode">
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
		</xsl:attribute>	
		<xsl:attribute name="Quantity">		
			<xsl:choose>
				<xsl:when test="$sProcessMaxSplits = $IGNORE_MAXSPLITS">
					<xsl:value-of select="format-number($vQuantity,'0.00000000000000')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number($vQuantity div MaxSplits,'0.00000000000000')"/>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:attribute>
		<xsl:attribute name="MajorUnitPrice">
			<xsl:value-of select="format-number($vUnitValue,'0.00')"/>
		</xsl:attribute>
		<xsl:attribute name="SupplierPackageGuid">
			<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
		</xsl:attribute>	
		<xsl:attribute name="MaxSplits">
			<xsl:value-of select="MaxSplits"/>
		</xsl:attribute>	
	</xsl:template>
	
</xsl:stylesheet>
