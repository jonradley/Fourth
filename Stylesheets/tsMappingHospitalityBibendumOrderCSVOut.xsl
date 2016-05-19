<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2006
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date			| Name 					| Description of modification
==========================================================================================
 03/01/2006	| Robert Cambridge	| Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 							|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-ltd.com/blah">
	
	<xsl:output method="text" encoding="utf-8"/>

	<xsl:template match="/">
	
		<!-- 1. RECID -->
		<xsl:text>ORDERHEAD,</xsl:text>
		<!-- 2. DOCNUM -->
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<!-- 3. DOCDATE -->
		<xsl:value-of select="translate(/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
		<xsl:text>,</xsl:text>
		<!-- 4. DOCTIME -->
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime"/>
		<xsl:text>,</xsl:text>
		<!-- 5. TOTPID -->
		<xsl:text>,</xsl:text>
		<!-- 6. FROMTPID -->
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<!-- 7. ORDERTYPE -->
		<xsl:text>220,</xsl:text>
		<!-- 8. ORDERDESC -->
		<xsl:text>,</xsl:text>
		<!-- 9. FLGN -->
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/FileGenerationNumber"/>
		<xsl:text>,</xsl:text>
		<!-- 10. FLVN -->
		<xsl:text>1,</xsl:text>
		<!-- 11. FLDATE -->
		<xsl:value-of select="vbscript:msGetDate()"/>
		<xsl:text>,</xsl:text>	
		<!-- 12. FLTIME	-->
		<xsl:value-of select="vbscript:msGetTime()"/>
		<xsl:text>,</xsl:text>		
		<!-- 13.MSGN -->
		<xsl:text>,</xsl:text>
		<!-- 14. MSGFNDESC -->
		<xsl:text>SALES ORDER,</xsl:text>
		<!-- 15. REF1 -->
		<xsl:text>EDI,</xsl:text>
		<!-- 16. REF2 -->
		<xsl:text>,</xsl:text>
		<!-- 17. CURRENCY -->
		<xsl:text>,</xsl:text>
		<!-- 18. INTCHGREF -->
		<xsl:text>,</xsl:text>
		<!-- 19. AUDREF -->
		<xsl:text>,</xsl:text>
		<!-- 20. AUDSEQ -->
		<xsl:text>,</xsl:text>
		<!-- 21. INTDOCNUM -->
		<xsl:text>,</xsl:text>
		<!-- 22. USER1 -->
		<xsl:text>,</xsl:text>
		<!-- 23. USER2 -->
		<xsl:text>,</xsl:text>
		<!-- 24. USER3 -->
		<xsl:text>,</xsl:text>
		<!-- 25. USER4 -->
		<xsl:text>MPTEST,</xsl:text>
		<!-- 26. USER5 -->
		<xsl:text>,</xsl:text>
		<!-- 27. USER6 -->
		<xsl:text>,</xsl:text>
		<!-- 28. USER7 -->
		<xsl:text>,</xsl:text>
		<!-- 29. USER8 -->
		<xsl:text>&#13;&#10;</xsl:text>
		
		
		<xsl:text>SUPPLIER,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN != '5555555555555' and /PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN != '55555555555555'">
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4"/-->
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode"/-->
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
		<xsl:text>,</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		
		<xsl:text>BUYER,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN != '5555555555555' and /PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN != '55555555555555'">
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4"/-->
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/PostCode"/-->
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
		<xsl:text>,</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		
		<xsl:text>DELIVERY,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN != '5555555555555' and /PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN != '55555555555555'">
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/-->
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/-->
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<!--xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/-->
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ContactName"/>
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
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions != ''">
			<!-- 1 -->
			<xsl:text>NARRATIVE</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- 2 -->
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>,</xsl:text>
			<!-- 3 -->
			<xsl:text>DES</xsl:text>		
			<xsl:text>,</xsl:text>
			<!-- 4 -->
			<xsl:text>,</xsl:text>
			<!-- 5 -->
			<xsl:value-of select="substring(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,1,70)"/>
			<xsl:text>,</xsl:text>
			<!-- 6 -->
			<xsl:if test="string-length(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions) &gt; 70">
				<xsl:value-of select="substring(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,71,70)"/>
			</xsl:if>
			<xsl:text>,</xsl:text>
			<!-- 7 -->
			<xsl:text>,</xsl:text>
			<!-- 8  -->
			<xsl:text>,</xsl:text>
			<!-- 9 -->
			<xsl:text>,</xsl:text>
			<!-- 10 -->
			<xsl:text>,</xsl:text>
			<!-- 11 -->
			<xsl:text>,</xsl:text>
			<!-- 12 -->
			<xsl:text>,</xsl:text>
			<!-- 13 -->
			<xsl:text>,</xsl:text>
			<!-- 14 -->
			<xsl:text>,</xsl:text>
			<!-- 15 -->
			<xsl:text>,</xsl:text>
			<!-- 16 -->
			<xsl:text>,</xsl:text>
			<!-- 17 -->
			<xsl:text>,</xsl:text>
			<!-- 18 -->
			<xsl:text>,</xsl:text>
			<!-- 19 -->
			<xsl:text>,</xsl:text>
			<!-- 20 -->
			<xsl:text>&#13;&#10;</xsl:text>

		</xsl:if>
		

		
		<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
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
			<xsl:value-of select="ProductID/SuppliersProductCode"/><xsl:text>,</xsl:text>
			<xsl:value-of select="$sGTIN"/><xsl:text>,</xsl:text>
			<xsl:value-of select="ProductID/BuyersProductCode"/><xsl:text>,</xsl:text>
			
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!--xsl:value-of select="OrderedQuantity"/-->
			<xsl:call-template name="msIntegerise">
				<xsl:with-param name="vsNum" select="OrderedQuantity"/>
			</xsl:call-template>
			<xsl:text>,</xsl:text>
			
			<xsl:text>,</xsl:text>
			
			<xsl:choose>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'EA'">BOTTLE</xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CS' and number(PackSize) &gt; 0 "><xsl:value-of select="concat('CASE',PackSize)"/></xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CS' and number(PackSize) = 0"></xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			
			<!-- does rounding requirement apply to UnitValueExclVAT before this expression? -->
			<!--xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.0000'),'.','')"/-->
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			
			<xsl:variable name="sProductDesc" select="concat(ProductDescription, ' (', PackSize,')')"/>
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
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>
		
		
		<xsl:text>ORDERTLR,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/><xsl:text>,</xsl:text>
		
		<!--xsl:value-of select="sum(/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/-->
		<xsl:call-template name="msIntegerise">
			<xsl:with-param name="vsNum" select="sum(/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderTrailer/NumberOfLines"/><xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>	
		<xsl:text>&#13;&#10;</xsl:text>
	
	</xsl:template>
	
	<xsl:template name="msIntegerise">
		<xsl:param name="vsNum"/>
		
		<xsl:variable name="nNum" select="number($vsNum)"/>
		
		<xsl:choose>
			<xsl:when test="$nNum &lt;= 0">0</xsl:when>
			<xsl:when test="$nNum &lt; 1">1</xsl:when>
			<xsl:otherwise><xsl:value-of select="floor($nNum)"/></xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="vbscript">
	<![CDATA[    
		
		Function msGetDate()
			Dim sTemp 
			sTemp = CStr(FormatDateTime(now, 2))
			msGetDate = Right(sTemp,4) & Mid(sTemp,4,2) & Left(sTemp,2)
		End Function
		
		Function msGetTime()
			msGetTime = FormatDateTime(now,vbLongTime)
		End Function
				
  ]]> 
  </msxsl:script>



</xsl:stylesheet>
