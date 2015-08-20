<?xml version="1.0" encoding="UTF-8"?>
<!--*************************************************************************
Date			|	Name					|	Description of modification
****************************************************************************
02/10/2012	|	K OShaughnessy	| Created Module
***************************************************************************
07/12/2012	|	K Oshaughnessy	| FB 5906 changes requested by yates
***************************************************************************
13/08/2014	|	A Barber				| FB 7924 Import HospitalityInclude.xsl, apply templates to encapsulate address data correctly
***************************************************************************
13/08/2014	|	A Barber				| FB 7925 Format ship to name
****************************************************************************				
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://mycompany.com/mynamespace">
	<xsl:import href="HospitalityInclude.xsl"/>

	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:template match="PurchaseOrder">
		
		<xsl:variable name="FormatORDDate" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		<xsl:variable name="FormatTime" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime"/>
		<xsl:variable name="FormatDLDate" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
		
		<!--Header record-->
		<xsl:text>HDR</xsl:text>	
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Suppliers code for Buyer-->
		<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Customer Name-->
		<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/>
		<xsl:text>,</xsl:text>
		<!--Supplier ANA-->
		<xsl:if test="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN != '5555555555555' ">
			<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<!--Customers Code for Supplier-->
		<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		<!--Supplier Name-->
		<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersName"/>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Supplier Code For Delivery Location-->
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="contains(PurchaseOrderHeader/ShipTo/ShipToName,'>')">
				<xsl:value-of select="substring(PurchaseOrderHeader/ShipTo/ShipToName,1,string-length(substring-before(PurchaseOrderHeader/ShipTo/ShipToName,'>'))-1)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!--Delivery Address-->
		<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 != '' ">
			<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 != '' ">
			<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 != '' ">
			<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 != '' ">
			<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode != '' ">
			<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		<!--Customer Order Number-->
		<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<!--File Generation Date-->
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:text>,</xsl:text>
		<!--File Generation Date-->
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:text>,</xsl:text>
		<!--Time Order Transmitted by Customer-->
		<xsl:value-of select="concat(substring($FormatTime,4,2),substring($FormatTime,1,2))"/>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Requested Delivery Date-->
		<xsl:value-of select="concat(substring($FormatDLDate,9,2),substring($FormatDLDate,6,2),substring($FormatDLDate,3,2))"/>
		<xsl:text>,</xsl:text>	
		<xsl:text>,</xsl:text>	
		<xsl:text>,</xsl:text>	
		<xsl:text>,</xsl:text>	
		<xsl:text>,</xsl:text>	
		<xsl:text>,</xsl:text>	
		<xsl:text>,</xsl:text>	
		<xsl:text>,</xsl:text>	
		<!--File Generation Number-->
		<xsl:text>,</xsl:text>
		<!--File Generation Date-->
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<!--Order line Record-->
			<xsl:text>OLD</xsl:text>
			<xsl:text>,</xsl:text>
			<!--Item EAN/ANA (Bar Code)-->
			<xsl:if test="ProductID/GTIN != '55555555555555' ">
				<xsl:value-of select="ProductID/GTIN"/>
			</xsl:if>
			<xsl:text>,</xsl:text>
			<!--Supplier Item Code-->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			<!--Customer Item Code-->
			<xsl:if test="ProductID/BuyersProductCode != '' ">
				<xsl:value-of select="ProductID/BuyersProductCode"/>
			</xsl:if>
			<xsl:text>,</xsl:text>
			<!--Qty Ordered-->
			<xsl:value-of select="format-number(OrderedQuantity,'0')"/>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<!--Measure Indicator-->
			<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:text>,</xsl:text>
			<!--Price-->
			<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template match="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode">
									 
		<xsl:variable name="formatindex">
			<xsl:choose>
				<xsl:when test="contains(name(),'PostCode')">9</xsl:when>
				<xsl:otherwise>40</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="formattedstring" select="user:msEscapeQuotes(substring(.,1,$formatindex))" />
		
		<xsl:if test="contains($formattedstring,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$formattedstring"/>
		<xsl:if test="contains($formattedstring,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
	</xsl:template>

	<msxsl:script language="VBScript" implements-prefix="vb"><![CDATA[	
'==========================================================================================
' Routine        : msFileGenerationDate()
' Description    : 
' Inputs         :  
' Outputs        : 
' Returns        : A string
' Author         : K Oshaughnessy
' Version        : 1.0
' Alterations    : (none)
'==========================================================================================

Function msFileGenerationDate()

Dim sNow

	sNow = CStr(Date)

	msFileGenerationDate =  Left(sNow,2) & Mid(sNow,4,2) & Right(sNow,2)
		
End Function	]]></msxsl:script>

</xsl:stylesheet>
