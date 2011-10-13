<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2010-10-12		| 3943 Created Module, based on XML defined in 
													http://bakery.adsgrp.com/client/BreadFactoryServices/StandingOrder.asmx?op=AmendOrder
**********************************************************************
R Cambridge	| 2010-11-02		| 3943 Replace account id and key with Cnumber
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:order="urn:ean.ucc:order:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:template match="/PurchaseOrder">
		
		<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
			
			<soap12:Body>
				
				<AmendOrder xmlns="http://www.breadltd.co.uk/standingorder/">
					
					<StandingOrderAmendRequest>
						
						<Cnumber><xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/></Cnumber>
						
						<DeliveryDate><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/></DeliveryDate>
						<!-- Trip element not required -->
						<!--
			        <Trip><xsl:value-of select="M or A or E"/></Trip>
			        -->
						
						<RefNo><xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/></RefNo>
						
						
						<OrderItems>
						
							<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
							
								<OrderItem>
									<ProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></ProductCode>
									<Quantity><xsl:value-of select="format-number(OrderedQuantity,'0')"/></Quantity>
								</OrderItem>
								
							</xsl:for-each>
								
						</OrderItems>

						
					</StandingOrderAmendRequest>
					
				</AmendOrder>
				
			</soap12:Body>
			
		</soap12:Envelope>
		
	</xsl:template>
	
</xsl:stylesheet>
