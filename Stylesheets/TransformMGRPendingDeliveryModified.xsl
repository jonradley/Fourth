<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 This XSL file is used to transform the XML of an MGR Pending Delivery Modified document
 that has been through Subs DB Extract using a reference document from the Document Repository

 © Fourth 2016
******************************************************************************************
 Module History
******************************************************************************************
 Date				| Name				| Description of modification
******************************************************************************************
 30/06/2016		|	Graham Neicho	| US13167. Created module.
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8"/>
	<xsl:param name="ReferenceFilepath"/>
	<xsl:variable name="ReferenceDocument" select="document($ReferenceFilepath)"/>
	
	<xsl:template match="@*|node()" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="SubscriptionDetails" priority="2">
		<SubscriptionDetails>
			<xsl:apply-templates />
			<xsl:call-template name="WriteLines"/>
		</SubscriptionDetails>
	</xsl:template>
	
	<xsl:template name="WriteLines">
		<xsl:if test="$ReferenceDocument/*/*[substring(local-name(), string-length(local-name()) - string-length('Detail') + 1) = 'Detail']/*[substring(local-name(), string-length(local-name()) - string-length('Line') + 1) = 'Line']">
			<Lines>
				<xsl:for-each select="$ReferenceDocument/*/*[substring(local-name(), string-length(local-name()) - string-length('Detail') + 1) = 'Detail']/*[substring(local-name(), string-length(local-name()) - string-length('Line') + 1) = 'Line']">
					<Item>
						<LineId><xsl:value-of select="LineNumber"/></LineId>
						<ProductNumber><xsl:value-of select="ProductID/SuppliersProductCode"/></ProductNumber>
						<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>
						<OrderUnit><xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/></OrderUnit>
						<ReceivedUnit><xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/></ReceivedUnit>
						<OrderedQuantity><xsl:value-of select="OrderedQuantity"/></OrderedQuantity>
						<ReceivedQuantity><xsl:value-of select="AcceptedQuantity"/></ReceivedQuantity>
						<OrderedUnitPrice><xsl:value-of select="UnitValueExclVAT[local-name(..) = 'PurchaseOrderLine' or local-name(..) = 'PurchaseOrderConfirmationLine']"/></OrderedUnitPrice>
						<ReceivedUnitPrice><xsl:value-of select="UnitValueExclVAT[local-name(..) = 'DeliveryNoteLine' or local-name(..) = 'ProofOfDeliveryLine' or local-name(..) = 'InvoiceLine']"/></ReceivedUnitPrice>
						<OrderedCurrencyCode/>
						<ReceivedCurrencyCode/>
						<IsPriceEditable/>
						<IsCatchweight>
							<xsl:choose>
								<xsl:when test="LineExtraData/IsCatchweightProduct"><xsl:value-of select="LineExtraData/IsCatchweightProduct"/></xsl:when>
								<xsl:when test="OrderedQuantity/@UnitOfMeasure and DespatchedQuantity/@UnitOfMeasure">
									<xsl:choose>
										<xsl:when test="OrderedQuantity/@UnitOfMeasure = DespatchedQuantity/@UnitOfMeasure">FALSE</xsl:when>
										<xsl:otherwise>TRUE</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</IsCatchweight>
						<Status>
							<xsl:choose>
								<xsl:when test="/GoodsReceivedNote">SUBMITTED</xsl:when>
								<xsl:otherwise>MODIFIED</xsl:otherwise>
							</xsl:choose>
						</Status>
					</Item>
				</xsl:for-each>
			</Lines>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>