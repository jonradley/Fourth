<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 Maps a single iXML purchase order into Chuanglee's Sage CSV format
 
 © Alternative Business Solutions Ltd, 2006
==========================================================================================
 Module History
==========================================================================================
 Date			| Name 					| Description of modification
==========================================================================================
 28/11/2006	| Lee Boyton        | Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 03/09/2007	| R Cambridge			| 1422 remove column headers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 							|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-ltd.com/blah">
	<xsl:output method="text" encoding="iso-8859-1"/>
	
	<xsl:template match="/PurchaseOrder">
	
		<!-- Chuanglee require the column header to be added in the first line of a file. -->
		<!-- AccountCodeForDeliveryLocation,PurchaseOrderDate(DD/MM/YYYY),											PurchaseOrderRef,SupplierProductCode,ProductDescription,PackSize,
				QtyRequired,NetUnitValue,RequestedDeliveryDate(DD/MM/YYYY)
		-->
		
		<!-- Client Code - Chuanglee's code for Ship To -->
		<xsl:variable name="sClientCode">
			<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		</xsl:variable>
		
		<!-- Due Date - delivery date in format dd/mm/yyyy -->
		<xsl:variable name="sDueDate">
			<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,9,2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,6,2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,1,4)"/>
		</xsl:variable>
		
		<!-- Order Ref -->
		<xsl:variable name="sOrderReference">
			<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		</xsl:variable>
		
		<!-- end of record flag -->	
		<xsl:variable name="sEOR">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>		
			
		<!-- Purchase Order Date -->
		<xsl:variable name="sOrderDate">
			<xsl:variable name="sDay" select="substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,9,2)"/>
			<xsl:variable name="sMonth" select="substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,6,2)"/>
			<xsl:variable name="sYear" select="substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,1,4)"/>
			<xsl:value-of select="concat($sDay,'/',$sMonth,'/',$sYear)"/>
		</xsl:variable>
		
		<!-- write out header line >
		<xsl:text>AccountCodeForDeliveryLocation,PurchaseOrderDate(DD/MM/YYYY),PurchaseOrderRef,SupplierProductCode,ProductDescription,PackSize,QtyRequired,NetUnitValue,RequestedDeliveryDate(DD/MM/YYYY)</xsl:text>

		< end of record flag >	
		<xsl:value-of select="$sEOR"/-->

		<!-- write out each order line -->
		<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
			<!-- AccRefForDeliveryLocation, -->
			<xsl:value-of select="$sClientCode"/>
			<xsl:text>,</xsl:text>
			
			<!-- PurchaseOrderDate, -->
			<xsl:value-of select="$sOrderDate"/>
			<xsl:text>,</xsl:text>

			<!-- PurchaseOrderRef, -->
			<xsl:value-of select="$sOrderReference"/>
			<xsl:text>,</xsl:text>
			
			<!-- SupplierProductCode, -->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			
			<!-- ProductDescription, -->
			<xsl:text>"</xsl:text><xsl:value-of select="ProductDescription"/><xsl:text>"</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!-- PackSize, -->
			<xsl:value-of select="PackSize"/>
			<xsl:text>,</xsl:text>
			
			<!-- QtyRequired, -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			
			<!-- NetUnitValue, -->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>

			<!-- RequestedDeliveryDate -->
			<xsl:value-of select="$sDueDate"/>

			<!-- end of record flag -->			
			<xsl:value-of select="$sEOR"/>
			
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>
