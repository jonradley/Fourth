<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TRG mapper for delivery notes to Alphameric 

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 25/09/2008	| R Cambridge			| 2841 Created module 
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="/DeliveryNote">
		<Order>

			<xsl:attribute name="Type">
				<xsl:value-of select="'Shipping Note'"/>
			</xsl:attribute>
			
			<xsl:attribute name="OrderID">
				<xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			</xsl:attribute>
			
			<xsl:attribute name="DeliveryID">
				<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			</xsl:attribute>
			
			
			<xsl:attribute name="UserReference">
				<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			</xsl:attribute>
			<xsl:attribute name="Description">
				<xsl:value-of select="'tradesimple'"/>
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
			
			<xsl:attribute name="DeliveryDateTime">
				<xsl:value-of select="concat(/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate,'T00:00:00')"/>
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

			<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">

				<!-- write the details of this line -->
				<DeliveryItem>
					
					<xsl:attribute name="SupplierProductCode">
						<xsl:value-of select="ProductID/SuppliersProductCode"/>
					</xsl:attribute>
					
					<xsl:attribute name="Quantity">
						<xsl:value-of select="format-number(DespatchedQuantity div MaxSplits,'0.00000000000000')"/>
					</xsl:attribute>
					
					<xsl:attribute name="MajorUnitPrice">
						<xsl:choose>
							<xsl:when test="UnitValueExclVAT">
								<xsl:value-of select="UnitValueExclVAT"/>
							</xsl:when>
							<xsl:otherwise>0.00</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<xsl:attribute name="SupplierPackageGuid">
						<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
					</xsl:attribute>
					
				</DeliveryItem>	
				
			</xsl:for-each>
			
		</Order>
		
	</xsl:template>
	

	
</xsl:stylesheet>
