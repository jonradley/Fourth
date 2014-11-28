<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Alternative GRN out for Aramark OpX.
*******************************************************************
Name         	| Date       	| Change
*******************************************************************
K Oshaughnessy| 11/11/2011	| 5008: Created. 
*******************************************************************
A Barber	| 14/03/2012	 | 6260: Added GL code to IT1 line output.
*******************************************************************
A Barber	| 17/10/2013	 | 7227: Appended decription with GL code to IT1 line output.
*******************************************************************
A Barber	| 24/10/2013	 | 7227: Altered reference to use DN ref.
*******************************************************************
A Barber	| 10/01/2014	 | 7620: Updated ship to location code to use senders branch reference.
**********************************************************************************************************
J Miguel	| 26/02/2014	 | 7724: Amend the DTM segment date: using Delivered Delivery Date
**********************************************************************************************************
A Barber	| 16/04/2014	 | 7798: Logic to replace '*' with '_' in the PO and DN references.
**********************************************************************************************************
-->
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	
	<xsl:output method="text"/>
	
	<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
	<xsl:template match="/GoodsReceivedNote">
	
	<!--Interchange Control Header-->
	<xsl:text>ISA*</xsl:text>
	<xsl:text>00*</xsl:text>
	<xsl:text>          </xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>00*</xsl:text>
	<xsl:text>          </xsl:text>
	<xsl:text>*</xsl:text>	
	<xsl:text>ZZ*</xsl:text>
	<xsl:text>3663*</xsl:text>
	<xsl:text>ZZ*</xsl:text>
	<xsl:call-template name="DateFormat">
		<xsl:with-param name="sDateFormat" select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
	</xsl:call-template>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>U</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>00400</xsl:text>
	<xsl:text>*</xsl:text>
	<!--FGN number-->
	<xsl:text>*</xsl:text>
	<xsl:text>0</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>P</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Functional Group Header-->
	<xsl:text>GS</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>IN</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>3663</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:call-template name="DateFormat">
		<xsl:with-param name="sDateFormat" select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
	</xsl:call-template>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<!--FGN-->
	<xsl:text>*</xsl:text>
	<xsl:text>X</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>004010</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Transaction Set Header-->
	<xsl:text>ST*</xsl:text>
	<xsl:text>810*</xsl:text>
	<xsl:value-of select="format-number(//FileGenerationNumber,'0000')"/>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Beginning Segment for Invoice-->
	<xsl:text>BIG*</xsl:text>
	<xsl:call-template name="DateFormat">
		<xsl:with-param name="sDateFormat" select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
	</xsl:call-template>
	<xsl:text>*</xsl:text>
	<xsl:value-of select="translate(GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference,'*','_')"/>
	<xsl:text>*</xsl:text>
	<xsl:value-of select="$sFileGenerationDate"/>
	<xsl:text>*</xsl:text>
	<xsl:value-of select="translate(GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference,'*','_')"/>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
	<xsl:text>*</xsl:text>
	<xsl:text>DI</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>	
	
	<!--Reference Identification-->
	<xsl:text>REF*</xsl:text>
	<xsl:text>OI*</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Name - Seller-->
	<xsl:text>N1*</xsl:text>
	<xsl:text>ST*</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersName"/>
	<xsl:text>*</xsl:text>
	<xsl:text>91</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Address Information - Buyer-->
	<xsl:text>N3*</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
	<xsl:text>*</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Geographic  Information - Buyer-->
	<xsl:text>N4*</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersAddress/PostCode"/>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Terms of Sale	-->
	<xsl:text>ITD*</xsl:text>
	<xsl:text>01*</xsl:text>
	<xsl:call-template name="DateFormat">
		<xsl:with-param name="sDateFormat" select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
	</xsl:call-template>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Date  Information -->
	<xsl:text>DTM*</xsl:text>
	<xsl:text>011*</xsl:text>
	<xsl:call-template name="DateFormat">
		<xsl:with-param name="sDateFormat" select="GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
	</xsl:call-template>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>*</xsl:text>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<xsl:for-each select="GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
		<!--Baseline Item Data-->
		<xsl:text>IT1*</xsl:text>
		<xsl:text>N</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="AcceptedQuantity"/>
		<xsl:text>*</xsl:text>
		<xsl:call-template name="UOM">
			<xsl:with-param name="UOMdecode" select="AcceptedQuantity/@UnitOfMeasure"/>
		</xsl:call-template>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="UnitValueExclVAT"/>
		<xsl:text>*</xsl:text>
		<xsl:text>CT*</xsl:text>
		<xsl:text>VC*</xsl:text>
		<xsl:value-of select="ProductID/SuppliersProductCode"/>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="concat(LineExtraData/PurchaseCategoryCode,'-',LineExtraData/GLCategoryDescription)"/>
		<xsl:text>*</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Quantity-->
		<xsl:text>QTY*</xsl:text>
		<xsl:text>39*</xsl:text>
		<xsl:value-of select="AcceptedQuantity"/>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="AcceptedQuantity/@UnitOfMeasure"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Tax Information-->
		<xsl:text>TXI*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Pricing information-->
		<xsl:text>CPT*</xsl:text>
		<xsl:text>DI*</xsl:text>
		<xsl:text>INV*</xsl:text>
		<xsl:value-of select="UnitValueExclVAT"/>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="AcceptedQuantity"/>
		<xsl:text>*</xsl:text>
		<xsl:text>SEL*</xsl:text>
		<xsl:text>1*</xsl:text>
		<xsl:value-of select="LineValueExclVAT"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Product/Item Description-->
		<xsl:text>PID*</xsl:text>
		<xsl:value-of select="ProductDescription"/>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="ProductDescription"/>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
	
		<!--Reference Identification-->
		<xsl:text>REF*</xsl:text>
		<xsl:text>11*</xsl:text>
		<xsl:value-of select="ProductID/SuppliersProductCode"/>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
	
	</xsl:for-each>
	
	<!--Total Monetary Value Summary-->
	<xsl:text>TDS*</xsl:text>
	<xsl:value-of select="translate(format-number(sum(GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT),'0.00'),'.','')"/>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Transaction Totals-->
	<xsl:text>CTT*</xsl:text>
	<xsl:value-of select="count(GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineNumber)"/>
	<xsl:text>&#13;&#10;</xsl:text>
	
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
