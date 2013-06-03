<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date			| Change
**********************************************************************
21/05/2013  | S Hussain       | Case 6589: Supplier Product Code Formatting + Optimization
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:import href="MatthewClarkInclude.xsl"/>
	<xsl:output method="xml" encoding="utf-8" indent="no"/>
	
	<xsl:template match="/">
		<BatchRoot>	
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!--Then let attributes be copied/not copied/modified by other more specific templates -->
			<xsl:apply-templates select="@*"/>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	
	<xsl:template match="BatchDocument">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!-- Fix what documenttype this is -->
			<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- CONVERT TestFlag from Y / N to 1 / 0 -->
	<xsl:template match="TradeSimpleHeader/TestFlag">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string(.) = 'N'">
					<!-- Is NOT TEST: found an N char, map to '0' -->
					<xsl:value-of select="'0'"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Is TEST: map anything else to '1' -->
					<xsl:value-of select="'1'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDate | DeliveryNoteDate | DespatchDate | DeliveryDate | ExpiryDate | SellByDate">
		<xsl:element name="{name()}">
			<xsl:call-template name="fixDate">
				<xsl:with-param name="sDate" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
		<xsl:template match="SlotStart | SlotEnd">
		<xsl:element name="{name()}">
			<xsl:call-template name="fixTime">
				<xsl:with-param name="sTime" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	<!--Format Product Code-->
	<xsl:template match="ProductID/SuppliersProductCode">
		<xsl:element name="{name()}">
			<xsl:call-template name="FormatCustomerProductCode">
				<xsl:with-param name="sProductCode" select="."/>
				<xsl:with-param name="sUOM" select="../../DespatchedQuantity/@UnitOfMeasure"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
