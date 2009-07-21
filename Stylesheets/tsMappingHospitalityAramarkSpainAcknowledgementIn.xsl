<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2009-07-08		| 2991 Created Module
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
		

		<PurchaseOrderAcknowledgement>
			<TradeSimpleHeader>
				<SendersCodeForRecipient><xsl:value-of select="ReturnReceipt/@RecID"/></SendersCodeForRecipient>
				<SendersBranchReference><xsl:value-of select="ReturnReceipt/@SenderID"/></SendersBranchReference>					
			</TradeSimpleHeader>
			<PurchaseOrderAcknowledgementHeader>

				<ShipTo>
					<ShipToLocationID>
						<SuppliersCode><xsl:value-of select="ReturnReceipt/@RecID"/></SuppliersCode>
					
						<!-- Secondary codes? -->
					
					</ShipToLocationID>
				</ShipTo>					
				
				<PurchaseOrderReferences>
					<PurchaseOrderReference><xsl:value-of select="ReturnReceipt/@DocRef"/></PurchaseOrderReference>
					<PurchaseOrderDate><xsl:value-of select="ReturnReceipt/@DeliveryDate"/></PurchaseOrderDate>
				</PurchaseOrderReferences>					
				
				<PurchaseOrderAcknowledgementReferences>
					<PurchaseOrderAcknowledgementReference><xsl:value-of select="ReturnReceipt/@DocRef"/></PurchaseOrderAcknowledgementReference>
					<PurchaseOrderAcknowledgementDate><xsl:value-of select="ReturnReceipt/@DeliveryDate"/></PurchaseOrderAcknowledgementDate>

				</PurchaseOrderAcknowledgementReferences>
			
			</PurchaseOrderAcknowledgementHeader>				
			
		</PurchaseOrderAcknowledgement>


	
	</xsl:template>



</xsl:stylesheet>