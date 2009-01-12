<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date			| Change
**********************************************************************
R Cambridge	| 04/12/2006	| 585 Created, based on tsMappingHospitalityInboundCSVorPSVDeliveryNote.xsl
**********************************************************************
				|					|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output encoding="utf-8"/>
	
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
	
	<!-- Ignore delivery notes with no lines -->
	<xsl:template match="/Batch/BatchDocuments/BatchDocument[not(DeliveryNote/DeliveryNoteDetail)]"/>
	
	<!-- Ignore delivery notes with a DN ref that has already appeared in the file -->
	<xsl:template match="/Batch/BatchDocuments/BatchDocument[DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference = preceding::BatchDocument/DeliveryNote[DeliveryNoteDetail]/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference]"/>
	
	<!-- Copy all lines against this PO ref -->
	<xsl:template match="DeliveryNoteDetail">
	
		<xsl:variable name="deliveryNoteRef" select="../DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
		
		<xsl:copy>
			<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/DeliveryNote[DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference = $deliveryNoteRef]/DeliveryNoteDetail/DeliveryNoteLine">
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>			
			</xsl:for-each>
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
	
	<xsl:template match="BatchDocument">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!-- Fix what documenttype this is -->
			<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDate | DeliveryNoteDate | DespatchDate | DeliveryDate | ExpiryDate | SellByDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="SlotEnd">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(., 1, 2), ':', substring(., 3, 2))"/>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
