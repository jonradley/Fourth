<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Goods Received Note translation following CSV 
flat file mapping for Moto.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         	| Date       	| Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Rave Tech	| 02/01/2008| Created Module
*******************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>
	<xsl:variable name="SCR">
		<xsl:value-of select="string(//TradeSimpleHeader/SendersCodeForRecipient)"/>
	</xsl:variable>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	<!--set value for Senders Code For Recipient -->
	<xsl:template match="SendersCodeForRecipient">
		<SendersCodeForRecipient>
			<xsl:choose>
				<xsl:when test="$SCR= '500806'">50000</xsl:when>
				<xsl:when test="$SCR= '254692'">50001</xsl:when>
				<xsl:when test="$SCR= '504356'">50001</xsl:when>
				<xsl:when test="$SCR= '504374'">50001</xsl:when>
				<xsl:when test="$SCR= '504375'">50001</xsl:when>
				<xsl:when test="$SCR= '504351'">50003</xsl:when>
				<xsl:when test="$SCR= '504352'">50003</xsl:when>
				<xsl:when test="$SCR= '504353'">50003</xsl:when>
				<xsl:when test="$SCR= '304637'">50004</xsl:when>
				<xsl:when test="$SCR= '506114'">50641</xsl:when>
				<xsl:when test="$SCR= '506214'">50810</xsl:when>
				<xsl:when test="$SCR= '050811'">50811</xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</SendersCodeForRecipient>
	</xsl:template>
	<xsl:template match="LineNumber">
		<LineNumber><xsl:value-of select="position()"/></LineNumber>
	</xsl:template>
	<!--set value of documentstatus -->
	<xsl:template match="DocumentStatus">
		<DocumentStatus>
			<xsl:text>Original</xsl:text>
		</DocumentStatus>
	</xsl:template>
	<!--Set dummy value to BuyersLocationID/GLN-->
	<xsl:template match="BuyersLocationID/GLN">
		<GLN>
			<xsl:text>9999999999</xsl:text>
		</GLN>
	</xsl:template>
	<xsl:template match="DeliveryType">
		<DeliveryType>Delivery</DeliveryType>
	</xsl:template>
	<!-- translate the date from [dd/mm/yyyy] format to [yyyy-mm-dd] -->
	<xsl:template match="GoodsReceivedNoteDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,1,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,4,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,7,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<GoodsReceivedNoteDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</GoodsReceivedNoteDate>
	</xsl:template>
	<xsl:template match="PurchaseOrderConfirmationDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,1,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,4,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,7,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<PurchaseOrderConfirmationDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</PurchaseOrderConfirmationDate>
	</xsl:template>
	<xsl:template match="DeliveryDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,1,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,4,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,7,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<DeliveryDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</DeliveryDate>
	</xsl:template>
	<xsl:template match="PurchaseOrderDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,1,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,4,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,7,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<PurchaseOrderDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</PurchaseOrderDate>
	</xsl:template>
	<xsl:template match="DeliveryNoteDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,1,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,4,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,7,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<DeliveryNoteDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</DeliveryNoteDate>
	</xsl:template>
	<xsl:template match="DespatchDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,1,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,4,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,7,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<DespatchDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</DespatchDate>
	</xsl:template>
	<xsl:template match="@UnitOfMeasure">
		<xsl:attribute name="{name()}">
			<xsl:text>EA</xsl:text>
		</xsl:attribute>
	</xsl:template>
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!--************** TRAILERS ***********-->
	<!--***************************************-->
	<xsl:template match="NumberOfLines">
		<NumberOfLines>
			<xsl:value-of select="count(../../GoodsReceivedNoteDetail/GoodsReceivedNoteLine)"/>
		</NumberOfLines>
	</xsl:template>
	<xsl:template match="DiscountedLinesTotalExclVAT">
		<DiscountedLinesTotalExclVAT>
			<xsl:value-of select="format-number(sum(../../GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT), '0.00')"/>
		</DiscountedLinesTotalExclVAT>
	</xsl:template>
	<xsl:template match="DocumentDiscount">
		<DocumentDiscount>
			<xsl:text>0.00</xsl:text>
		</DocumentDiscount>
	</xsl:template>
	<xsl:template match="TotalExclVAT">
		<TotalExclVAT>
			<xsl:value-of select="format-number(sum(../../GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT), '0.00')"/>
		</TotalExclVAT>
	</xsl:template>
</xsl:stylesheet>
