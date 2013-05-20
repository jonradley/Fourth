<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations

	Bibendum inbound credit note translator

**********************************************************************
Name			| Date		| Change
**********************************************************************
Lee Boyton        | 2009-04-28 | 2867. Translate product codes for SSP
                          |                     | to ensure they are unique (product code plus UOM on the end).				
**********************************************************************
H Robson		|	2012-02-01		| 5226 change Aramark onto the default way of handling the Product Code
*********************************************************************
K Oshaughnessy|2012-08-29| Additional customer added (Mitie) FB 5664	
*********************************************************************
A Barber		|	2012-08-29		| 5709 Added no UOM append product code handling for PBR.	
*******************************************************************
H Mahbub		|	2012-10-12		| Adding new Compass Vendor code FB 5780
*********************************************************************
H Robson		|	2013-03-26		| 6285 Added Creative Events	
*********************************************************************
H Robson		|	2013-05-07		| 6496 PBR append UoM to product code	
*********************************************************************
S Hussain		|	2013-05-15		| Optimization
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:import href="HospitalityInclude.xsl"/>	
	<xsl:import href="BibendumInclude.xsl"/>	
	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
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
	
	<!-- Bug fix where they incorrectly send multiple invoice structures within each BatchDocument -->
	<xsl:template match="BatchDocument">
		<!-- Now run the following for every invoice found within this BatchDocument element, even if there is only one -->
		<xsl:for-each select="CreditNote">
			<!-- Each time we find an invoice element, first (repeat) copy the BatchDocument element -->
			<BatchDocument>
				<!-- Now process the invoice -->
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			<!-- And before looking for another invoice, (repeat) close the BatchDocument element -->
			</BatchDocument>
		</xsl:for-each>
	</xsl:template>

	<!-- Handle the MIL14T and FMC01T Account -->
	<xsl:template match="TradeSimpleHeader">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:choose>
					<xsl:when test="SendersBranchReference != '' and contains('MIL14T~COM2012T~FMC01T~TES01T~TES08T~TES12T~TES15T~TES25T~NOB06T~CRE11T',SendersBranchReference)">
						<xsl:value-of select="SendersBranchReference"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="SendersCodeForRecipient"/>
					</xsl:otherwise>
				</xsl:choose>
			</SendersCodeForRecipient>
			
			<!--xsl:if test="SendersBranchReference = 'MIL14T' or SendersBranchReference = 'FMC01T' or SendersBranchReference = 'TES01T'"-->
			<xsl:if test="SendersBranchReference != '' and contains('MIL14T~COM2012T~FMC01T~TES01T~TES08T~TES12T~TES15T~TES25T~MIT16T~CRE11T',SendersBranchReference)">
				<SendersBranchReference>
					<xsl:value-of select="SendersBranchReference"/>
				</SendersBranchReference>
			</xsl:if>
		</TradeSimpleHeader>
	</xsl:template>

	<xsl:template match="BuyersAddress | SuppliersAddress | ShipToAddress">
		<xsl:apply-imports/>
	</xsl:template>
	
	<xsl:template match="ShipToLocationID">
		<ShipToLocationID>
			<SuppliersCode>
				<xsl:value-of select="SuppliersCode"/>
			</SuppliersCode>
			<xsl:if test="//TradeSimpleHeader/SendersBranchReference != '' and contains('MIL14T~COM2012T~FMC01T',//TradeSimpleHeader/SendersBranchReference)">
				<BuyersCode>
					<xsl:value-of select="SuppliersCode"/>
				</BuyersCode>
			</xsl:if>
		</ShipToLocationID>
	</xsl:template>
	
	<xsl:template match="CreditNoteHeader/Supplier">
		<Supplier>
			<xsl:if test="//TradeSimpleHeader/SendersBranchReference != '' and contains('MIL14T~COM2012T~FMC01T',//TradeSimpleHeader/SendersBranchReference)">
				<SuppliersLocationID>
					<SuppliersCode><xsl:value-of select="$BIBENDUM"/></SuppliersCode>
				</SuppliersLocationID>
			</xsl:if>
			<xsl:copy-of select="SuppliersName"/>
			<xsl:copy-of select="SuppliersAddress"/>
		</Supplier>
	</xsl:template>

	<xsl:template match="CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate |
									 CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate |
									 CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate |
									 CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderDate |
									 CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate">
		<xsl:if test=". != ''">
			<xsl:element name="{name()}" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
		
	<!-- Sort VATCodes -->
	<xsl:template match="VATCode">
		<xsl:element name="{name()}">
			<xsl:call-template name="decodeVATCodes">
				<xsl:with-param name="sVATCode" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATCode">
		<xsl:attribute  name="{name()}">
			<xsl:call-template name="decodeVATCodes">
				<xsl:with-param name="sVATCode" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<!-- SSP, GIRAFFE, WAHACA specific change to append the unit of measure onto the product code -->
	<xsl:template match="ProductID/SuppliersProductCode">
		<xsl:copy>
			<xsl:call-template name="FormatSupplierProductCode">
				<xsl:with-param name="sUOM" select="../../Measure/UnitsInPack"/>
				<xsl:with-param name="sProductCode" select="."/>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>

	<!-- Decode Bibendum's PackSizes -->
	<xsl:template match="CreditedQuantity">
		<CreditedQuantity>
			<xsl:attribute name="UnitOfMeasure">
				<xsl:variable name="UoM">
					<xsl:call-template name="decodePacks">
						<xsl:with-param name="sBibPack" select="following-sibling::Measure/UnitsInPack"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="decodeUOM">
					<xsl:with-param name="sUOM" select="$UoM"/>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="format-number(.,'0')"/>
		</CreditedQuantity>
	</xsl:template>
	
	<xsl:template match="InvoicedQuantity">
		<InvoicedQuantity>
			<xsl:attribute name="UnitOfMeasure">
				<xsl:variable name="UoM">
					<xsl:call-template name="decodePacks">
						<xsl:with-param name="sBibPack" select="following-sibling::Measure/TotalMeasure"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="decodeUOM">
					<xsl:with-param name="sUOM" select="$UoM"/>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="format-number(.,'0')"/>
		</InvoicedQuantity>
	</xsl:template>
	
	<xsl:template match="Measure">
		<Measure>
			<UnitsInPack>
				<xsl:call-template name="decodePacks">
					<xsl:with-param name="sBibPack" select="UnitsInPack"/>
				</xsl:call-template>
			</UnitsInPack>
		</Measure>
	</xsl:template>

	<xsl:template match="TotalMeasure" />
</xsl:stylesheet>
