<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	
	<xsl:template match="/">
		<BatchRoot>		
		<xsl:element name="PurchaseOrder">
			<!--treadesimple Header-->
			<xsl:element name="TradeSimpleHeader">
				<xsl:element name="SendersCodeForRecipient">
					<xsl:value-of select="cXML/Request/OrderRequest/ItemOut/SupplierID"/>
				</xsl:element>					
			</xsl:element>
			<!--Purchase Order Header-->
			<xsl:element name="PurchaseOrderHeader">
				<!--Buyer-->		
				<xsl:element name="Buyer">
					<xsl:element name="BuyersLocationID">
						<xsl:element name="BuyersCode">
							<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/@addressID"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="BuyersName">
						<xsl:value-of select="/cXML/Header/From/Credential/Identity"/>
					</xsl:element>					
					<xsl:element name="BuyersAddress">
						<xsl:element name="AddressLine1">
							<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/PostalAddress/Street"/>
						</xsl:element>
						<xsl:if test="/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/PostalAddress/City != ''">
							<xsl:element name="AddressLine2">
								<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/PostalAddress/City"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/PostalAddress/State != ''">
							<xsl:element name="AddressLine3">
								<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/PostalAddress/State"/>
							</xsl:element>
						</xsl:if>
						<!--<xsl:element name="AddressLine4">
							<xsl:value-of select="/Request/OrderRequest/OrderRequestHeader/BillTo/Address/PostalAddress/Street"/>
						</xsl:element>-->
						<xsl:element name="PostCode">
							<xsl:value-of select="/Request/OrderRequest/OrderRequestHeader/BillTo/Address/PostalAddress/PostalCode"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<!--Supplier- Completed by InFiller?-->
				<!--<xsl:element name="Supplier">
					<xsl:text>X</xsl:text>
				</xsl:element>-->
				<!--Ship To-->
				<xsl:element name="ShipTo">
					<xsl:element name="ShipToLocationID">
						<xsl:element name="BuyersCode">
							<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID"/>
						</xsl:element>
						<xsl:element name="SuppliersCode">
							<xsl:value-of select="/cXML/Request/OrderRequest/ItemOut/ItemID/SupplierPartID"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="ShipToName">
						<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/Name"/>
					</xsl:element>
					<xsl:element name="ShipToAddress">
						<xsl:element name="AddressLine1">
							<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/Street"/>
						</xsl:element>
						<xsl:element name="AddressLine2">
							<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/City"/>
						</xsl:element>
						<xsl:element name="AddressLine3">
							<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/State"/>
						</xsl:element>
						<!--<xsl:element name="AddressLine4">
							<xsl:value-of select=""/>
						</xsl:element>-->
						<xsl:element name="PostCode">
							<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/PostalCode"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<!--Order References-->
				<xsl:element name="PurchaseOrderReferences">
					<xsl:element name="PurchaseOrderReference">
						<xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/@orderID"/>
					</xsl:element>
					<xsl:element name="PurchaseOrderDate">
						<xsl:value-of select="substring-before(/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate,'T')"/>
					</xsl:element>					
				</xsl:element>
			</xsl:element>
			
			<!--Order Detail-->
			<xsl:element name="PurchaseOrderDetail">
				<xsl:for-each select="/cXML/Request/OrderRequest/ItemOut">
					<xsl:element name="PurchaseOrderLine">
						<xsl:element name="LineNumber">
							<xsl:value-of select="@lineNumber"/>
						</xsl:element>
						<xsl:element name="ProductID">
							<xsl:element name="SuppliersProductCode">
								<xsl:value-of select="ItemID/SupplierPartID"/>
							</xsl:element>
						</xsl:element>
						<xsl:element name="ProductDescription">
							<xsl:value-of select="ItemDetail/Description"/>
						</xsl:element>
						<xsl:element name="OrderedQuantity">
							<xsl:value-of select="@quantity"/>
						</xsl:element>
						<xsl:element name="PackSize">
							<xsl:value-of select="ItemDetail/UnitOfMeasure"/>
						</xsl:element>
						<xsl:element name="UnitValueExclVAT">
							<xsl:value-of select="ItemDetail/UnitPrice/Money"/>
						</xsl:element>
						<xsl:element name="LineValueExclVAT">
							<xsl:value-of select="ItemDetail/UnitPrice/Money * @quantity"/>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
			
			<!--Order Trailer-->
			<xsl:element name="PurchaseOrderTrailer">
				<xsl:element name="NumberOfLines">
					<xsl:value-of select="count(//ItemOut/@lineNumber)"/>
				</xsl:element>
				<!--<xsl:element name="TotalExclVAT"></xsl:element>-->
			</xsl:element>
			
		</xsl:element>
	</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
