<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Purchase Order translation following tradacoms flat file mapping for Prezzo.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         	| Date       	| Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
K Oshaughnessy| 11/11/2011	| 5008: Created. 
**********************************************************************************************************
-->
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	
	<xsl:output method="text"/>
	
	<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
	<xsl:template match="/GoodsReceivedNote">
	
	<!--Transaction Set Header-->
	<xsl:text>ST~</xsl:text>
	<xsl:text>810~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Beginning Segment for Invoice-->
	<xsl:text>BIG~</xsl:text>
	<xsl:call-template name="DateFormat">
		<xsl:with-param name="sDateFormat" select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
	</xsl:call-template>
	<xsl:text>~</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
	<xsl:text>~</xsl:text>
	<xsl:value-of select="$sFileGenerationDate"/>
	<xsl:text>~</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>DI~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>	
	
	<!--Reference Identification-->
	<xsl:text>REF~</xsl:text>
	<xsl:text>OI~</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Name - Seller-->
	<xsl:text>N1~</xsl:text>
	<xsl:text>SE~</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersName"/>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Name - Buyer-->
	<xsl:text>N1~</xsl:text>
	<xsl:text>BY~</xsl:text>	
	<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersName"/>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Address Information - Buyer-->
	<xsl:text>N3~</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
	<xsl:text>~</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Geographic  Information - Buyer-->
	<xsl:text>N4~</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/PostCode"/>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Terms of Sale	-->
	<xsl:text>ITD~</xsl:text>
	<xsl:text>01~</xsl:text>
	<xsl:call-template name="DateFormat">
		<xsl:with-param name="sDateFormat" select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
	</xsl:call-template>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Date  Information -->
	<xsl:text>DMT~</xsl:text>
	<xsl:text>011~</xsl:text>
	<xsl:call-template name="DateFormat">
		<xsl:with-param name="sDateFormat" select="GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
	</xsl:call-template>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>~</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<xsl:for-each select="GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
		<!--Baseline Item Data-->
		<xsl:text>IT1~</xsl:text>
		<xsl:value-of select="ProductID/SuppliersProductCode"/>
		<xsl:text>~</xsl:text>
		<xsl:value-of select="AcceptedQuantity"/>
		<xsl:text>~</xsl:text>
		<xsl:call-template name="UOM">
			<xsl:with-param name="UOMdecode" select="AcceptedQuantity/@UnitOfMeasure"/>
		</xsl:call-template>
		<xsl:text>~</xsl:text>
		<xsl:value-of select="UnitValueExclVAT"/>
		<xsl:text>~</xsl:text>
		<xsl:text>CT~</xsl:text>
		<xsl:text>VC~</xsl:text>
		<xsl:value-of select="ProductID/SuppliersProductCode"/>
		<xsl:text>~</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Quantity-->
		<xsl:text>QTY~</xsl:text>
		<xsl:text>39~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Tax Information-->
		<xsl:text>TXI~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Product/Item Description-->
		<xsl:text>PID~</xsl:text>
		<xsl:value-of select="ProductDescription"/>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:value-of select="ProductDescription"/>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
	
		<!--Reference Identification-->
		<xsl:text>REF~</xsl:text>
		<xsl:text>11~</xsl:text>
		<xsl:value-of select="ProductID/SuppliersProductCode"/>
		<xsl:text>~</xsl:text>
		<xsl:text>~</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
	
	</xsl:for-each>
		
	</xsl:template>
	
	<!--Formating Date-->
	<xsl:template name="DateFormat">
		<xsl:param name="sDateFormat"/>
		<xsl:value-of select="concat(substring($sDateFormat,1,4),substring($sDateFormat,6,2),substring($sDateFormat,9,2))"/>
	</xsl:template>
	
	<!--Unit of Measure-->
	<xsl:template name="UOM">
		<xsl:param name="UOMdecode"/>
		<xsl:choose>
			<xsl:when test="$UOMdecode = 'CS'">
				<xsl:text>CA</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$UOMdecode"/>
			</xsl:otherwise>
		</xsl:choose>
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

	msFileGenerationDate = Right(sNow,4) & Mid(sNow,4,2) & Left(sNow,2)
		
End Function

]]></msxsl:script>	
	
</xsl:stylesheet>
