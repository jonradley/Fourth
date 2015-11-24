<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date			| Change
**********************************************************************
J Miguel	| 14/10/2014	| 10051 - Staples - Setup and Mappers
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="ISO-8859-1" indent="yes"/>
	<xsl:template match="cXML">
		<xsl:apply-templates select="Request/ConfirmationRequest"/>
	</xsl:template>
	<xsl:template match="ConfirmationRequest">
		<BatchRoot>
			<Batch>
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="ConfirmationHeader/Contact[@role='shipTo']/@addressID"/>
					</SendersCodeForRecipient>
				</TradeSimpleHeader>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="84">
						<PurchaseOrderAcknowledgement>
							<xsl:call-template name="insertTradeSimpleHeaderData"/>
							<PurchaseOrderAcknowledgementHeader>
								<xsl:call-template name="insertHeaderData"/>
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="OrderReference/@orderID"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="substring-before(OrderReference/@orderDate,'T')"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
							</PurchaseOrderAcknowledgementHeader>
						</PurchaseOrderAcknowledgement>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	<!-- helper templates - common to both types of docs-->
	<xsl:template name="insertTradeSimpleHeaderData">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:value-of select="ConfirmationHeader/Contact[@role='shipTo']/@addressID"/>
			</SendersCodeForRecipient>
			<TestFlag>
				<xsl:choose>
					<xsl:when test="@deploymentMode='production'">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</TestFlag>
		</TradeSimpleHeader>
	</xsl:template>
	<xsl:template name="insertHeaderData">
		<Buyer>
			<BuyersLocationID>
				<SuppliersCode>
					<xsl:value-of select="../../Header/To/Credential/Identity"/>
				</SuppliersCode>
			</BuyersLocationID>
		</Buyer>
		<Supplier>
			<SuppliersLocationID>
				<BuyersCode>
					<xsl:value-of select="../../Header/From/Credential/Identity"/>
				</BuyersCode>
			</SuppliersLocationID>
		</Supplier>
		<ShipTo>
			<ShipToLocationID>
				<SuppliersCode>
					<xsl:value-of select="ConfirmationHeader/Contact[@role='shipTo']/@addressID"/>
				</SuppliersCode>
			</ShipToLocationID>
		</ShipTo>
	</xsl:template>
</xsl:stylesheet>
