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
		<xsl:apply-templates select="Request/ShipNoticeRequest"/>
	</xsl:template>
	<xsl:template match="Request/ShipNoticeRequest">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="7">
						<DeliveryNote>
							<xsl:call-template name="insertTradeSimpleHeaderData"/>
							<DeliveryNoteHeader>
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
								<xsl:call-template name="insertHeaderData"/>
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="ShipNoticePortion/OrderReference/@orderID"/>
									</PurchaseOrderReference>
								</PurchaseOrderReferences>
								<DeliveryNoteReferences>
									<DeliveryNoteReference>
										<xsl:value-of select="ShipNoticeHeader/@shipmentID"/>
									</DeliveryNoteReference>
									<DeliveryNoteDate>
										<xsl:value-of select="substring-before(ShipNoticeHeader/@noticeDate, 'T')"/>
									</DeliveryNoteDate>
								</DeliveryNoteReferences>
							</DeliveryNoteHeader>
							<DeliveryNoteDetail>
								<xsl:apply-templates select="ShipNoticePortion/ShipNoticeItem"/>
							</DeliveryNoteDetail>
							<DeliveryNoteTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(ShipNoticePortion/ShipNoticeItem)"/>
								</NumberOfLines>
							</DeliveryNoteTrailer>
						</DeliveryNote>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	<!-- ShipNoticeItem creates a DeliveryNoteLine -->
	<xsl:template match="ShipNoticeItem">
		<DeliveryNoteLine>
			<LineNumber>
				<xsl:value-of select="@lineNumber"/>
			</LineNumber>
			<ProductID>
				<SuppliersProductCode>
					<xsl:value-of select="ItemID/SupplierPartID"/>
				</SuppliersProductCode>
			</ProductID>
			<ConfirmedQuantity>
				<xsl:attribute name="UnitOfMeasure"><xsl:text>EA</xsl:text></xsl:attribute>
				<xsl:value-of select="@quantity"/>
			</ConfirmedQuantity>
			<DespatchedQuantity>
				<xsl:attribute name="UnitOfMeasure"><xsl:text>EA</xsl:text></xsl:attribute>
				<xsl:value-of select="@quantity"/>
			</DespatchedQuantity>			
		</DeliveryNoteLine>
	</xsl:template>
	<!-- helper templates - common to both types of docs-->
	<xsl:template name="insertTradeSimpleHeaderData">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:value-of select="ShipNoticeHeader/Contact[@role='shipTo']/@addressID"/>
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
					<xsl:value-of select="ShipNoticeHeader/Contact[@role='shipTo']/@addressID"/>
				</SuppliersCode>
			</ShipToLocationID>
		</ShipTo>
	</xsl:template>	
</xsl:stylesheet>
