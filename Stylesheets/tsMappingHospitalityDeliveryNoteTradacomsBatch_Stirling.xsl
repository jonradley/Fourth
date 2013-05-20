<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations


**********************************************************************
Name			| Date			| Change
**********************************************************************
R Cambridge	| 29/10/2007	| 1556 Create module
**********************************************************************
H Robson		|	2012-02-01		| 5226 change Aramark onto the default way of handling the Product Code
*********************************************************************
K Oshaughnessy|2012-08-29		| Additional customer added (Mitie) FB 5665	
*********************************************************************
A Barber		|	2012-08-29		| 5709 Added no UOM append product code handling for PBR.	
*********************************************************************
H Robson		|	2013-03-26		| 6285 Added Creative Events	
*********************************************************************
H Robson		|	2013-05-07		| 6496 PBR append UoM to product code	
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:import href="BibendumInclude.xsl"/>
	<xsl:output method="xml" encoding="utf-8" indent="no"/>
	<!-- The structure of the interal XML varries depending on who the customer is -->
	<!-- All documents in the batch will be for the same customer/agreement -->	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>	
			<Batch>				
				<BatchDocuments>				
					<xsl:apply-templates/>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	
	<xsl:template match="/Batch/BatchDocuments/BatchDocument/DeliveryNote">
		<BatchDocument DocumentTypeNo="7">
			<DeliveryNote>
				<xsl:apply-templates select="TradeSimpleHeader"/>
				<xsl:apply-templates select="DeliveryNoteHeader"/>
				<DeliveryNoteDetail>
					<xsl:apply-templates select="DeliveryNoteDetail/DeliveryNoteLine"/>
				</DeliveryNoteDetail>
			</DeliveryNote>
		</BatchDocument>
	</xsl:template>
	
	<xsl:template match="TradeSimpleHeader | ShipToAddress">
		<xsl:apply-imports/>
	</xsl:template>
	
	<xsl:template match="DeliveryNoteHeader">
		<DeliveryNoteHeader>
			<Buyer>
				<BuyersLocationID>
					<xsl:apply-templates select="Buyer/BuyersLocationID/SuppliersCode[1]"/>
				</BuyersLocationID>
			</Buyer>
			<ShipTo>
				<ShipToLocationID>
					<GLN>5555555555555</GLN>
					<xsl:apply-templates select="ShipTo/ShipToLocationID/SuppliersCode[1]"/>
				</ShipToLocationID>
				<xsl:apply-templates select="ShipTo/ShipToName[1]"/>
				<xsl:apply-templates select="ShipTo/ShipToAddress"/>
			</ShipTo>
									
			<xsl:variable name="sDocumentDate">
				<xsl:call-template name="fixDateYY">
					<xsl:with-param name="sDate" select="DeliveryNoteReferences/DeliveryNoteDate"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="sPurchaseOrderDate">
				<xsl:call-template name="fixDateYY">
					<xsl:with-param name="sDate" select="PurchaseOrderReferences/PurchaseOrderDate"/>
				</xsl:call-template>
			</xsl:variable>									
			<xsl:variable name="sDeliveryDate">
				<xsl:call-template name="fixDateYY">
					<xsl:with-param name="sDate" select="DeliveredDeliveryDetails/DeliveryDate"/>
				</xsl:call-template>
			</xsl:variable>								
																		
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:choose>
						<xsl:when test="PurchaseOrderReferences/PurchaseOrderReference">
							<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(ShipTo/ShipToLocationID/SuppliersCode,'_',$sPurchaseOrderDate)"/>
						</xsl:otherwise>
					</xsl:choose>										
				</PurchaseOrderReference>
				<PurchaseOrderDate><xsl:value-of select="$sPurchaseOrderDate"/></PurchaseOrderDate>
			</PurchaseOrderReferences>										

			<DeliveryNoteReferences>
				<DeliveryNoteReference><xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/></DeliveryNoteReference>
				<DeliveryNoteDate><xsl:value-of select="$sDocumentDate"/></DeliveryNoteDate>
				<DespatchDate><xsl:value-of select="$sDeliveryDate"/></DespatchDate>
			</DeliveryNoteReferences>
									
			<DeliveredDeliveryDetails>
				<!--DeliveryType/-->
			    <DeliveryDate><xsl:value-of select="$sDeliveryDate"/></DeliveryDate>
			</DeliveredDeliveryDetails>
		</DeliveryNoteHeader>
	</xsl:template>

	<xsl:template match="Buyer/BuyersLocationID/SuppliersCode[1] |
									 ShipTo/ShipToLocationID/SuppliersCode[1] |
									 ShipTo/ShipToName[1]" >
		<xsl:element name="{name()}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="DeliveryNoteDetail/DeliveryNoteLine">
		<DeliveryNoteLine>
			<xsl:apply-templates select="ProductID/SuppliersProductCode"/>
			<xsl:copy-of select="ProductDescription[1]"/>								
			<xsl:copy-of select="OrderedQuantity[1]"/>																
			<DespatchedQuantity UnitOfMeasure="EA">		
				<xsl:if test="string(DespatchedQuantity/@UnitOfMeasure) != ''">
					<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/></xsl:attribute>
				</xsl:if>												
				<xsl:value-of select="DespatchedQuantity"/>
			</DespatchedQuantity>
			<xsl:copy-of select="PackSize[1]"/>												
		</DeliveryNoteLine>
	</xsl:template>
	
	<xsl:template match="ProductID/SuppliersProductCode">
		<ProductID>4
			<SuppliersProductCode>
			<xsl:call-template name="FormatSupplierProductCode">
				<xsl:with-param name="sUOM" select="../../DespatchedQuantity/@UnitOfMeasure"/>
				<xsl:with-param name="sProductCode" select="."/>
			</xsl:call-template>
			</SuppliersProductCode>
		</ProductID>
	</xsl:template>
</xsl:stylesheet>
