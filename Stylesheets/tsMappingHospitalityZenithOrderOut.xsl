<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name					| Date				| Change
**********************************************************************
K O'Shaughnessy	| 2009-05-18		| 2889 Created Modele
**********************************************************************
				|						|
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	
	
	<xsl:template match="/PurchaseOrder">
	
		<PurchaseOrder>
			<xsl:attribute name="OrderDate">
				<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
			</xsl:attribute>
			
			<PurchaseOrderHeader>
				<xsl:attribute name="OrderID">
					<xsl:value-of select="PurchaseOrderHeader/FileGenerationNumber"/>
				</xsl:attribute>
			
				<CustomerCode>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</CustomerCode>
				
				<SendersName>
					<xsl:value-of select ="PurchaseOrderHeader/ShipTo/ContactName"/>
				</SendersName>
				
				<AddressLine1>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
				</AddressLine1>
				
				<AddressLine2>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
				</AddressLine2>
				
				<AddressLine3>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
				</AddressLine3>
				
				<AddressLine4>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
				</AddressLine4>
				
				<PostCode>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
				</PostCode>
				
				<SendersEmail></SendersEmail>
				
				<PurchaseOrderReference>
					<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
				</PurchaseOrderReference>
				
				<RequiredDate>
					<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
				</RequiredDate>
			
			</PurchaseOrderHeader>
			<Items>
				<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
					
					<Item>
						<xsl:attribute name="OrderID2">
							<xsl:value-of select="../../PurchaseOrderHeader/FileGenerationNumber"/>
						</xsl:attribute>
					
						<LineNumber>
							<xsl:value-of select="LineNumber"/>
						</LineNumber>
						
						<SuppliersProductCode>
							<xsl:value-of select="ProductID/SuppliersProductCode"/>
						</SuppliersProductCode>
						
						<OrderedQuantity>
							<xsl:value-of select="OrderedQuantity"/>
						</OrderedQuantity>
												
					</Item>
				</xsl:for-each>
			</Items>
		</PurchaseOrder>
	</xsl:template>
</xsl:stylesheet>
