<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************
Date		|	owner				|	details
************************************************************************
15/08/2012| KOshaughnessy	| Created FB 5607
************************************************************************
			|						|
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">

	<xsl:output method="text"/>
	
	<xsl:template match="/GoodsReceivedNote">
	
	<xsl:text>STX=ANA:1+</xsl:text>
		<xsl:choose>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
				<xsl:text>5013546145710</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>5013546164209</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:FOURTH HOSPITALITY</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>5011295000016</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersName"/>
		<xsl:text>++</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/FileGenerationNumber"/>
		<xsl:text>++</xsl:text>
		<xsl:text>DLCTES+B</xsl:text>
	<xsl:text>'&#13;&#10;</xsl:text>
	
	<xsl:text>MHD=</xsl:text>
		<xsl:value-of select="count(GoodsReceivedNote)"/>
		<xsl:text>+DLCHDR:4</xsl:text>
	<xsl:text>'&#13;&#10;</xsl:text>
	
	<xsl:text>TYP=</xsl:text>
		<xsl:text>0670</xsl:text>
	<xsl:text>'&#13;&#10;</xsl:text>
	
	<xsl:text>SDT=</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersName"/>
		<xsl:text>+</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine1">
			<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine2">
			<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine3">
			<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine4">
			<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine4"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/PostCode"/>
	<xsl:text>'&#13;&#10;</xsl:text>
	
	<xsl:text>CDT=</xsl:text>	
		<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersName"/>
		<xsl:text>+</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine1">
			<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine2">
			<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine3">
			<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine4">
			<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine4"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/PostCode"/>
	<xsl:text>'&#13;&#10;</xsl:text>
	
	<xsl:text>FIL=</xsl:text>
		<!--xsl:value-of select="$FGN"/>
		<xsl:text>+</xsl:text>
		<xsl:text>1+</xsl:text>
		<xsl:value-of select="$sFileGenerationDate"/-->
	<xsl:text>'&#13;&#10;</xsl:text>	
	
	
	<xsl:text>MHD=</xsl:text>	
		<xsl:value-of select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
		<xsl:text>+DLCDET:4</xsl:text>
	<xsl:text>'&#13;&#10;</xsl:text>
	
	<xsl:text>CLO=</xsl:text>	
		<xsl:text>:</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToName"/>
		<xsl:text>+</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine1">
			<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2">
			<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine3">
			<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine4">
			<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine4"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/PostCode"/>
	<xsl:text>'&#13;&#10;</xsl:text>
	
	<xsl:text>ODD=</xsl:text>
		<xsl:text>1+</xsl:text>
		<xsl:value-of select="GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>+</xsl:text>
		<xsl:if test="GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference">
			<xsl:value-of select="GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
		</xsl:if>
		<xsl:text>++++++++</xsl:text>
	<xsl:text>'&#13;&#10;</xsl:text>	
	
	<xsl:text>DST=</xsl:text>
		<xsl:text>M</xsl:text>
	<xsl:text>'&#13;&#10;</xsl:text>	
	
	
	<xsl:for-each select="GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
	
		<xsl:text>DCD=</xsl:text>	
			<xsl:value-of select="LineNumber"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>++++</xsl:text>
			<xsl:value-of select="AcceptedQuantity/@UnitOfMeasure"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="DeliveredQuantity"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>++</xsl:text>
			<xsl:value-of select="ConfirmedQuantity"/>
		<xsl:text>'&#13;&#10;</xsl:text>	
			
	</xsl:for-each>	
	
	<xsl:text>DCT=</xsl:text>	
		<xsl:value-of select="count(GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineNumber)"/>
	<xsl:text>'&#13;&#10;</xsl:text>	
	
	<xsl:text>MTR=</xsl:text>
		<xsl:value-of select="6 + count(GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineNumber)"/>
	<xsl:text>'&#13;&#10;</xsl:text>	
	
	<xsl:text>MHD=</xsl:text>
		<xsl:value-of select="format-number(count(/GoodsReceivedNote) + 2,'0')"/>
		<xsl:text>+DLCTLR:4</xsl:text>
	<xsl:text>'&#13;&#10;</xsl:text>	
	
	<xsl:text>COT=</xsl:text>
		<xsl:value-of select="count(/GoodsReceivedNote)"/>
	<xsl:text>'&#13;&#10;</xsl:text>	
	
	<xsl:text>MTR=</xsl:text>	
		<xsl:value-of select="format-number(count(/GoodsReceivedNote) + 2,'0')"/>
	<xsl:text>'&#13;&#10;</xsl:text>	
	
	<xsl:text>END=</xsl:text>
		<xsl:value-of select="format-number(count(/GoodsReceivedNote) + 2,'0')"/>
	<xsl:text>'&#13;&#10;</xsl:text>
	
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="vb"><![CDATA[

'==========================================================================================
' Routine        : msFileGenerationDate()
' Description    : 
' Inputs         :  
' Outputs        : 
' Returns        : A string
' Author         :KO
' Version        : 1.0
' Alterations    : (none)
'==========================================================================================

Function msFileGenerationDate()

Dim sNow

	sNow = CStr(Date)

	msFileGenerationDate = Right(sNow,2) & Mid(sNow,4,2) & Left(sNow,2)
		
End Function

]]></msxsl:script>

</xsl:stylesheet>
