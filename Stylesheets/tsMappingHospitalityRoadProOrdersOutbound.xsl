<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' $Header:  $ $NoKeywords: $
' Overview
'
' Maps Hospitality Purchase Orders to BASDA format.
' Adapted from tsMappingUKPA_UOR_to_BASDA30.xsl
'
' © Alternative Business Solutions Ltd., 2000,2001,2002.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date            	| Name             	| Description of modification
'******************************************************************************************
' 22/01/2009       	| M Dimant        	| Created 
'******************************************************************************************
'                 		|                  		| 
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:urn="xmlns:xsl=http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:ll="urn:www.basda.org/schema/eBIS-XML_order_v3.00.xml" exclude-result-prefixes="#default xsl msxsl">
	<xsl:output method="xml"/>
	<xsl:template match="/PurchaseOrder">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>type="text/xsl" href="eBIS_MAM.xsl"</xsl:text>
		 </xsl:processing-instruction>
		<xsl:text>&#10;</xsl:text>
		<xsl:element name="biztalk_1" namespace="urn:schemas-biztalk-org:biztalk:biztalk_1">
			<xsl:text>&#10;</xsl:text>
			<xsl:element name="header">
				<xsl:text>&#10;</xsl:text>
				<xsl:element name="manifest">
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="document">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="name">Order</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="description">Ebis_order</xsl:element>
						<xsl:text>&#10;</xsl:text>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
				</xsl:element>
				<xsl:text>&#10;</xsl:text>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
			<xsl:element name="body">
				<xsl:text>&#10;</xsl:text>
				<xsl:element name="Order" namespace="urn:www.basda.org/schema/eBIS-XML_order_v3.00.xml">
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="OrderHead">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Schema">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="Version">3.00</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Stylesheet">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="StylesheetName">eBIS_MAM.xsl</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="StylesheetType">xsl</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Parameters">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="Language">en_GB</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="DecimalSeparator">.</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="Precision">20.2</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="OrderType">
							<xsl:attribute name="Code">PUO</xsl:attribute>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Function">
							<xsl:attribute name="Code">FIO</xsl:attribute>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="OrderCurrency">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="Currency">
								<xsl:attribute name="Code">GBP</xsl:attribute>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Checksum"/>
						<xsl:text>&#10;</xsl:text>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="OrderReferences">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="BuyersOrderNumber">
							<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="OrderDate">
						<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>T12:00:00</xsl:element>
						<xsl:text>&#10;</xsl:text>
					<xsl:element name="Supplier">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Party">
							<xsl:value-of select="TradeSimpleHeader/RecipientsName"/>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Address">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine1"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine2"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine3"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine4"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine5"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/PostCode"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="Buyer">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="BuyerReferences">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="SuppliersCodeForBuyer">
								<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Party">
							<xsl:value-of select="TradeSimpleHeader/SendersName"/>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Address">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine1"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine2"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine3"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine4"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine5"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/PostCode"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="Delivery">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="DeliverTo">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="BuyersCodeForDelivery">
								<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="Party">
								<xsl:value-of select="TradeSimpleHeader/SendersName"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="Address">
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="AddressLine">
									<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine1"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="AddressLine">
									<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine2"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="AddressLine">
									<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine3"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="AddressLine">
									<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine4"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="AddressLine">
									<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine5"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="AddressLine">
									<xsl:value-of select="TradeSimpleHeader/SendersAddress/PostCode"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="InvoiceTo">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Party">
							<xsl:value-of select="TradeSimpleHeader/SendersName"/>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="Address">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine1"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine2"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine3"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine4"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine5"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="AddressLine">
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/PostCode"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
					<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
						<xsl:element name="OrderLine">
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="LineNumber">
								<xsl:value-of select="position()"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="Product">
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="BuyersProductCode">
									<xsl:value-of select="ProductID/SuppliersProductCode"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="Description">
									<xsl:value-of select="ProductDescription"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="Quantity">
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="Amount">
									<xsl:value-of select="OrderedQuantity"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="Price">
								<xsl:text>&#10;</xsl:text>
								<xsl:element name="UnitPrice">
									<xsl:value-of select="format-number(UnitValueExclVAT, '#.000')"/>
								</xsl:element>
								<xsl:text>&#10;</xsl:text>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="LineTotal">
								<xsl:value-of select="format-number(UnitValueExclVAT*OrderedQuantity,'#.000')"/>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
					</xsl:for-each>
					<xsl:element name="OrderTotal">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="GoodsValue">
							<xsl:value-of select="format-number(PurchaseOrderTrailer/TotalExclVAT, '#.000')"/>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="FreightCharges">0</xsl:element>
						<xsl:text>&#10;</xsl:text>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
				</xsl:element>
				<xsl:text>&#10;</xsl:text>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
		</xsl:element>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
