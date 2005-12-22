<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-ltd.com/blah">

	<xsl:template match="/">
	
		<xsl:text>ORDERHEAD,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/><xsl:text>,</xsl:text>
		<xsl:value-of select="translate(/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/><xsl:text>,</xsl:text>		
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/><xsl:text>,</xsl:text>
		<xsl:text>220,</xsl:text>
		<xsl:text>,</xsl:text>
		Sequential number allocated by tradesimple for each buyer-Bibendum pair<xsl:text>,</xsl:text>
		<xsl:text>1,</xsl:text>
		<xsl:value-of select="vbscript:msGetDate()"/><xsl:text>,</xsl:text>		
		<xsl:value-of select="vbscript:msGetTime()"/><xsl:text>,</xsl:text>		
		<xsl:text>,</xsl:text>
		<xsl:text>SALES ORDER,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		
		
		<xsl:text>SUPPLIER,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/><xsl:text>,</xsl:text>
		<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN != '5555555555555' and /PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN != '55555555555555'">
			<xsl:value-of select="ProductID/GTIN"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		
		
		<xsl:text>BUYER,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/><xsl:text>,</xsl:text>
		<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN != '5555555555555' and /PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN != '55555555555555'">
			<xsl:value-of select="ProductID/GTIN"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/PostCode"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		
		
		<xsl:text>DELIVERY,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/><xsl:text>,</xsl:text>
		<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN != '5555555555555' and /PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN != '55555555555555'">
			<xsl:value-of select="ProductID/GTIN"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ContactName"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
			<xsl:text>ORDERLINE,</xsl:text>
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/><xsl:text>,</xsl:text>
			<xsl:value-of select="LineNumber"/><xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			
			<xsl:variable name="sGTIN">
				<xsl:if test="ProductID/GTIN != '5555555555555' and ProductID/GTIN != '55555555555555'">
					<xsl:value-of select="ProductID/GTIN"/>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of select="$sGTIN"/><xsl:text>,</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode (but see below)"/><xsl:text>,</xsl:text>
			<xsl:value-of select="$sGTIN"/><xsl:text>,</xsl:text>
			<xsl:value-of select="ProductID/BuyersProductCode"/><xsl:text>,</xsl:text>
			
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="OrderedQuantity"/><xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			See below
			<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.0000'),'.','')"/><xsl:text>,</xsl:text>
			(4 d.p. implied e.g. £10.50 = 105000)
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:variable name="sProductDesc" select="concat(ProductDescription, ' (', Packsize,')')"/>
			<xsl:value-of select="substring($sProductDesc,1,40)"/><xsl:text>,</xsl:text>
			<xsl:value-of select="substring($sProductDesc,41,40)"/><xsl:text>,</xsl:text>
			<xsl:value-of select="translate(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/><!-- (CCYYMMDD) --><xsl:text>,</xsl:text>
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/><!-- (HH:MM:SS) --><xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			
		</xsl:value-of>
		
		
		<xsl:text>ORDERTLR,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/><xsl:text>,</xsl:text>
		<xsl:value-of select="sum(/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/><xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderTrailer/NumberOfLines"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>	
	
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="vbscript">
<![CDATA[ 
   
		
		Function msGetDate()
			Dim sTemp 
			sTemp = CStr(FormatDateTime(now, 2))
			msGetDate = Right(sTemp,4) & Mid(sTemp,4,2) & Left(sTemp,2)
		End Function
		
		Function msGetTime()
			msGetDate = FormatDateTime(Date(),vbLongTime))
		End Function
				
  ]]> 
  </msxsl:script>



</xsl:stylesheet>
