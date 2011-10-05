<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2008-03-20		| 2805 Created Modele
**********************************************************************
				|						|
**********************************************************************
				|						|
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8"/>
	
	
	<xsl:variable name="fieldSeperator" select="','"/>
	<xsl:variable name="recordSeperator" select="'&#13;&#10;'"/>
	
	
	
	<xsl:template match="/PurchaseOrder">

		<xsl:call-template name="writeHeaderColumnHeaders"/>

		<xsl:call-template name="writeHeader"/>

		<xsl:call-template name="writeDetailColumnHeaders"/>
		
		
		<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
			<xsl:call-template name="writeDetail"/>
		
		</xsl:for-each>		

	</xsl:template>
	
	
	
	<xsl:template name="writeHeaderColumnHeaders">
	
		<xsl:text>SAP Customer No.</xsl:text>
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:text>Delivery Date</xsl:text>
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:text>Purchase No.</xsl:text>		
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:text>Unloading Point</xsl:text>
		
		<xsl:value-of select="$recordSeperator"/>
	
	</xsl:template>
	
	

	<xsl:template name="writeHeader">
	
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:variable name="DeliveryDate" select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		<xsl:value-of select="concat(substring($DeliveryDate,9,2),'.',substring($DeliveryDate,6,2),'.',substring($DeliveryDate,1,4))"/>
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>		
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
				
		<!-- last field is always blank -->
		
		<xsl:value-of select="$recordSeperator"/>
	
	</xsl:template>



	<xsl:template name="writeDetailColumnHeaders">
	
		<xsl:text>Vendor Item No.</xsl:text>
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:text>Quantity</xsl:text>
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:text>Unit of Measure</xsl:text>
		
		<xsl:value-of select="$recordSeperator"/>
	
	</xsl:template>
	


	<xsl:template name="writeDetail">
	
		<xsl:value-of select="ProductID/SuppliersProductCode"/>
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:value-of select="format-number(OrderedQuantity,'0')"/>
		<xsl:value-of select="$fieldSeperator"/>
		
		<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>	
		
		<xsl:value-of select="$recordSeperator"/>
	
	</xsl:template>
	

	
	
	
</xsl:stylesheet>
