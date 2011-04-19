<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 itsu mapper for delivery notes to Caterwide.

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 25/09/2008	| R Cambridge		| 2841 Created module 
==========================================================================================
 21/10/2008	| R Cambridge     	| 2524 temporary fix to ignore split pack info for some suppliers
==========================================================================================
 09/03/2009	| Rave Tech  		| 2719 Consolidate twice appearing product code into one line using non-supersession price.
==========================================================================================
 13/05/2009	| Rave Tech  		| 2878 Removed MaxSplits logic and implemented CaseSize logic.
==========================================================================================
15/01/2010	| Rave Tech  		| 3329 Populate the description field with a <Supplier Name> - <Supplier PO Number>.
==========================================================================================
27/09/2010 	| Andrew Barber      	| 3898 Fix delivery date timestamps to 23:59:59.
==========================================================================================
12/11/2011 	| Andrew Barber      	| 4388 Copied TRG delivery note map for itsu.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:template match="/DeliveryNote">
		<Order>

			<xsl:attribute name="Type">
				<xsl:value-of select="'Shipping Note'"/>
			</xsl:attribute>
			
			<xsl:attribute name="OrderID">
				<xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			</xsl:attribute>
			
			<!-- Despite what it says in Torex's own spec this field isn't necessary -->
			<!--xsl:attribute name="DeliveryID">
				<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			</xsl:attribute-->
			
			<xsl:attribute name="UserReference">
				<xsl:value-of select="DeliveryNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
			</xsl:attribute>
			<xsl:attribute name="Description">
				<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersName"/> - <xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			</xsl:attribute>
			
			<xsl:attribute name="Total">
				<xsl:value-of select="format-number(sum(DeliveryNoteDetail/DeliveryNoteLine/UnitValueExclVAT),'0.00')"/>
			</xsl:attribute>
			
			<xsl:attribute name="DateEntered">
				<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DateChanged">
				<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="TargetDeliveryDate">
				<xsl:value-of select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
				<xsl:text>T23:59:59</xsl:text>
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
				<xsl:value-of select="concat('ITSU',TradeSimpleHeader/RecipientsBranchReference,'/4')"/>
			</xsl:attribute>
			
			<xsl:attribute name="DeliveryDateTime">
				<xsl:value-of select="concat(/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate,'T23:59:59')"/>
			</xsl:attribute>
			
			<xsl:attribute name="LocationGuid">
				<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
			</xsl:attribute>
			
			<xsl:attribute name="SupplierGuid">
				<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
			</xsl:attribute>
			
			<xsl:attribute name="OrderDateTime">
				<xsl:choose>
					<xsl:when test="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderTime != ''">
						<xsl:value-of select="concat(DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate,'T',DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderTime)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate,'T00:00:00')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine[not(ProductID/SuppliersProductCode = following::DeliveryNoteLine/ProductID/SuppliersProductCode)]">
				<!-- write the details of this line -->
				
				<!-- Spec from Torex said these elements should be called DeliveryItem but it wasn't the case -->	
				
				<xsl:variable name="sProductCode" select="ProductID/SuppliersProductCode"/>
							
				<OrderItem>
					
					<xsl:attribute name="SupplierProductCode">
						<xsl:value-of select="ProductID/SuppliersProductCode"/>
					</xsl:attribute>
					
					<xsl:variable name="nQuantity" select="sum(//DeliveryNoteDetail/DeliveryNoteLine[ProductID/SuppliersProductCode=$sProductCode]/DespatchedQuantity )"/>

					<xsl:choose>
						<!--When CaseSize is obtained then devide Qty and multiply Price by it-->
						<xsl:when test="number(LineExtraData/CaseSize) &gt; 1">
							<xsl:attribute name="Quantity">
								<xsl:value-of select="format-number($nQuantity div LineExtraData/CaseSize,'0.00000000000000')"/>
							</xsl:attribute>
							<xsl:attribute name="UOM">
								<xsl:text>CS</xsl:text> 
							</xsl:attribute>
							<xsl:attribute name="MajorUnitPrice">
								<xsl:choose>
									<xsl:when test="UnitValueExclVAT">
										<xsl:value-of select="format-number(UnitValueExclVAT * LineExtraData/CaseSize,'0.00')"/>
									</xsl:when>
									<xsl:otherwise>0.00</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</xsl:when>
						<!--Else keep line unchanged-->
						<xsl:otherwise>
							<xsl:attribute name="Quantity">
								<xsl:value-of select="format-number($nQuantity,'0.00000000000000')"/>
							</xsl:attribute>
							<xsl:attribute name="UOM">
								<xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:attribute name="MajorUnitPrice">
								<xsl:choose>
									<xsl:when test="UnitValueExclVAT">
										<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
									</xsl:when>
									<xsl:otherwise>0.00</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:attribute name="SupplierPackageGuid">
						<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
					</xsl:attribute>
					
				</OrderItem>	
				
			</xsl:for-each>
			
		</Order>
		
	</xsl:template>
	
</xsl:stylesheet>
