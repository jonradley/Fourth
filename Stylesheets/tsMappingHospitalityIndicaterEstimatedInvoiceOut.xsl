
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
K Oshaughnessy| 2011-03-209		| 1332 Created Modele
**********************************************************************
				|						|				
*******************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="xml" encoding="UTF-8"/>
<xsl:template match="/">

	<indepedi>
			<xsl:attribute name="editype">
				<xsl:text>Estimate</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="created">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
			</xsl:attribute>
			<xsl:attribute name="reference">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			</xsl:attribute>
			<xsl:attribute name="taxpoint">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
			</xsl:attribute>
			<xsl:attribute name="currency">
				<xsl:text>GBP</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="notes">
				<xsl:text>.</xsl:text>
			</xsl:attribute>
			
		<supplierdata>
			<xsl:attribute name="name">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"/>
			</xsl:attribute>
			<xsl:attribute name="code">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
			</xsl:attribute>
			<xsl:attribute name="address1">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1"/>
			</xsl:attribute>
			<xsl:attribute name="address2">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2"/>
			</xsl:attribute>
			<xsl:attribute name="address3">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3"/>
			</xsl:attribute>
			<xsl:attribute name="town">
				<!--town name-->
			</xsl:attribute>
			<xsl:attribute name="county">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4"/>
			</xsl:attribute>
			<xsl:attribute name="country">
				<xsl:text>United Kingdom</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="postcode">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode"/>
			</xsl:attribute>
		</supplierdata>
		
		<clientdata>
			<xsl:attribute name="name">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName"/>
			</xsl:attribute>
			<xsl:attribute name="outletreference">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
			</xsl:attribute>
			<xsl:attribute name="outletname">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName"/>
			</xsl:attribute>
			<xsl:attribute name="outletaddress1">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
			</xsl:attribute>
			<xsl:attribute name="outletaddress2">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
			</xsl:attribute>
			<xsl:attribute name="outletaddress3">
				<!-- -->
			</xsl:attribute>
			<xsl:attribute name="outlettown">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
			</xsl:attribute>
			<xsl:attribute name="outletcounty">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
			</xsl:attribute>
			<xsl:attribute name="outletpostcode">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
			</xsl:attribute>		
			<xsl:attribute name="outletcountry">
				<xsl:text>United Kingdom</xsl:text>
			</xsl:attribute>		
		</clientdata>
		
		<deliverydata>
			<xsl:attribute name="name">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName"/>
			</xsl:attribute>	
			<xsl:attribute name="address1">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
			</xsl:attribute>	
			<xsl:attribute name="address2">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
			</xsl:attribute>	
			<xsl:attribute name="address3">
				<!-- -->
			</xsl:attribute>	
			<xsl:attribute name="town">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
			</xsl:attribute>	
			<xsl:attribute name="county">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
			</xsl:attribute>		
			<xsl:attribute name="postcode">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
			</xsl:attribute>		
			<xsl:attribute name="country">
				<xsl:text>United Kingdom</xsl:text>
			</xsl:attribute>				
		</deliverydata>
		
		<summarydata>
			<xsl:attribute name="discountamount">
				<xsl:text>0.00</xsl:text>
			</xsl:attribute>		
			<xsl:attribute name="netamount">
				<xsl:value-of select="PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT"/>
			</xsl:attribute>	
			<xsl:attribute name="vatamount">
				<xsl:text>0.00</xsl:text>
			</xsl:attribute>					
			<xsl:attribute name="grossamount">
				<xsl:text>0.00</xsl:text>
			</xsl:attribute>			
		</summarydata>
		
		<productitems>
			<xsl:for-each select="PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
			
				<productitem>
					<xsl:attribute name="description">
						<xsl:value-of select="ProductDescription"/>
					</xsl:attribute>	
					<xsl:attribute name="itemcode">
						<xsl:value-of select="ProductID/SuppliersProductCode"/>
					</xsl:attribute>	
					<xsl:attribute name="nominalcode">
						<!-- -->
					</xsl:attribute>	
					<xsl:attribute name="quantity">
						<xsl:value-of select="OrderedQuantity"/>
					</xsl:attribute>	
					<xsl:attribute name="unitprice">
						<xsl:value-of select="UnitValueExclVAT"/>
					</xsl:attribute>	
					<xsl:attribute name="vatrate">
						<xsl:text>0.00</xsl:text>
					</xsl:attribute>	
					<xsl:attribute name="discountamount">
						<xsl:text>0.00</xsl:text>
					</xsl:attribute>	
					<xsl:attribute name="itemprice">
						<xsl:value-of select="LineValueExclVAT"/>
					</xsl:attribute>	
					<xsl:attribute name="vatamount">
						<xsl:text>0.00</xsl:text>
					</xsl:attribute>										
				</productitem>
				
			</xsl:for-each>	
		</productitems> 
		
	</indepedi>
</xsl:template>	
</xsl:stylesheet>




















