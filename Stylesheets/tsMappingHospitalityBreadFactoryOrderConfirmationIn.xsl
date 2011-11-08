<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2010-10-12		| 3943 Created Module
**********************************************************************
				|						|				
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:template match="/BatchRoot/ResponseDocument"/>
	
	<xsl:template match="/BatchRoot/RequestDocument/PurchaseOrder">

		<BatchRoot>

			<PurchaseOrderConfirmation>
			
				<TradeSimpleHeader>
					
					<SendersCodeForRecipient><xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/></SendersCodeForRecipient>
					<xsl:for-each select="TradeSimpleHeader/RecipientsBranchReference[1]">
						<SendersBranchReference>
							<xsl:value-of select="."/>
						</SendersBranchReference>
					</xsl:for-each>
					<SendersName><xsl:value-of select="TradeSimpleHeader/RecipientsName"/></SendersName>
					
					<SendersAddress>
						<xsl:copy-of select="TradeSimpleHeader/RecipientsAddress/*"/>
					</SendersAddress>
					
					<RecipientsCodeForSender><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></RecipientsCodeForSender>
					<xsl:for-each select="TradeSimpleHeader/RecipientsBranchReference[1]">
						<RecipientsBranchReference>
							<xsl:value-of select="."/>
						</RecipientsBranchReference>				
					</xsl:for-each>
					<RecipientsName><xsl:value-of select="TradeSimpleHeader/SendersName"/></RecipientsName>
					
					<RecipientsAddress>
						<xsl:copy-of select="TradeSimpleHeader/SendersAddress/*"/>
					</RecipientsAddress>
	
				</TradeSimpleHeader>
				
				<PurchaseOrderConfirmationHeader>				
					
					<xsl:copy-of select="PurchaseOrderHeader/Buyer"/>
					<xsl:copy-of select="PurchaseOrderHeader/Supplier"/>
					<xsl:copy-of select="PurchaseOrderHeader/ShipTo"/>				
					
					<xsl:copy-of select="PurchaseOrderHeader/PurchaseOrderReferences"/>
					
					<xsl:if test="/BatchRoot/ResponseDocument/soap:Envelope/soap:Body/*/*/*[local-name()='WebOrderNo'] !='0'">
						<PurchaseOrderConfirmationReferences>
							<PurchaseOrderConfirmationReference>
								<xsl:value-of select="/BatchRoot/ResponseDocument/soap:Envelope/soap:Body/*/*/*[local-name()='WebOrderNo']"/>
							</PurchaseOrderConfirmationReference>
							<PurchaseOrderConfirmationDate>
								<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
							</PurchaseOrderConfirmationDate>
						</PurchaseOrderConfirmationReferences>
					</xsl:if>
		
					<!--ConfirmedDeliveryDetails>
						<DeliveryDate>
							<xsl:value-of select=""/>
						</DeliveryDate>					
					</ConfirmedDeliveryDetails-->	
	
				</PurchaseOrderConfirmationHeader>
				
				<PurchaseOrderConfirmationDetail>
					
					<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
						
						<xsl:call-template name="writeConfLine">
							<xsl:with-param name="orderLine" select="."/>
						</xsl:call-template>
						
					</xsl:for-each>
					
				</PurchaseOrderConfirmationDetail>
				
			</PurchaseOrderConfirmation>
			
		</BatchRoot>

	</xsl:template>
	
	<xsl:template name="writeConfLine">
		<xsl:param name="orderLine"/>
		
		<!-- Determine line action, confirmed quantity and narrative -->
		<xsl:variable name="orderedProductCode" select="$orderLine/ProductID/SuppliersProductCode"/>
		<xsl:variable name="confirmationLine" select="/BatchRoot/ResponseDocument/soap:Envelope/soap:Body/*/*/*/*[local-name()='RequestedItem'][*[local-name()='ProductCode'][.=$orderedProductCode]]"/>
		<xsl:variable name="confirmedStatus" select="($confirmationLine/*[local-name()='Status'] | /BatchRoot/ResponseDocument/soap:Envelope/soap:Body/*/*[local-name()='StandingOrderAmendResponse']/*[local-name()='Status'])[last()]"/>
			
		<xsl:variable name="lineAction">
			<xsl:choose>
				<xsl:when test="$confirmedStatus = 'OK'">Accepted</xsl:when>
				<xsl:otherwise>Rejected</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="confirmedQuantity">
			<xsl:choose>
				<xsl:when test="$confirmedStatus = 'OK'">
					<xsl:value-of select="$orderLine/OrderedQuantity"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="narrative">
			<xsl:choose>
				<xsl:when test="$confirmedStatus = 'OK'"/>
				<xsl:otherwise>
					<xsl:value-of select="$confirmedStatus"/>				
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Create line -->
		<PurchaseOrderConfirmationLine>
			<xsl:attribute name="LineStatus">
				<xsl:value-of select="$lineAction"/>
			</xsl:attribute>
				
			<!--ProductID>
				<GTIN><xsl:value-of select="$orderLine/ProductID/GTIN"/></GTIN>
				<SuppliersProductCode><xsl:value-of select="$orderLine/ProductID/SuppliersProductCode"/></SuppliersProductCode>
				<xsl:for-each select="$orderLine/ProductID/BuyersProductCode">
					<BuyersProductCode><xsl:value-of select="."/></BuyersProductCode>
				</xsl:for-each>
			</ProductID-->			
								
			<xsl:copy-of select="$orderLine/ProductID"/>
			<xsl:copy-of select="$orderLine/ProductDescription"/>
			<xsl:copy-of select="$orderLine/OrderedQuantity"/>
			
			<ConfirmedQuantity>
			
				<xsl:attribute name="UnitOfMeasure">										
					<xsl:value-of select="$orderLine/OrderedQuantity/@UnitOfMeasure"/>
				</xsl:attribute>
				
				<xsl:value-of select="$confirmedQuantity"/>
				
			</ConfirmedQuantity>
			
			<xsl:copy-of select="($orderLine/PackSize | $orderLine/UnitValueExclVAT)"/>			
			
			<xsl:if test="$narrative != ''">
				<Narrative>
					<xsl:value-of select="$narrative"/>
				</Narrative>
			</xsl:if>
			
		</PurchaseOrderConfirmationLine>

		
	</xsl:template>
	
</xsl:stylesheet>
