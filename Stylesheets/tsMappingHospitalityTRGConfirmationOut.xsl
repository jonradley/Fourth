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
 Date      	| Name 					| Description of modification
==========================================================================================
 23/08/2007	| R Cambridge			| FB1400 Created module 
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
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
				
			</xsl:for-each>
			
		</Order>
		
	</xsl:template>
	
	<xsl:template name="writeLine">
	
		<xsl:attribute name="SupplierProductCode">
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
		</xsl:attribute>	
		<xsl:attribute name="Quantity">
			<xsl:value-of select="format-number(ConfirmedQuantity div MaxSplits,'0.00000000000000')"/>
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
	
</xsl:stylesheet>
