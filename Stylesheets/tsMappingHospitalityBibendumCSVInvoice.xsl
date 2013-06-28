<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations

	Bibendum inbound invoice translator

**********************************************************************
Name			| Date				| Change
**********************************************************************
     ?     		|       ?    			| Created Module
**********************************************************************
R Cambridge 	|	2008-10-15	| PO ref mod	
**********************************************************************
Lee Boyton  	| 2009-04-28 		| 2867. Translate product codes for SSP
                    |                     	| to ensure they are unique (product code plus UOM on the end).				
**********************************************************************
H Robson		|	2012-02-01	| 5226 change Aramark onto the default way of handling the Product Code
*********************************************************************		
KOshaughnessy| 2012-05-24	| 5490 Change for new Olympic vendor agreement (Compass)	
*********************************************************************
K Oshaughnessy|2012-08-29| Additional customer added (Mitie) FB 5664	
*********************************************************************
A Barber		|	2012-08-29		| 5709 Added no UOM append product code handling for PBR.	
*********************************************************************
H Robson		|	2013-03-26		| 6285 Added Creative Events	
*********************************************************************
H Robson		|	2013-05-07		| 6496 PBR append UoM to product code	
*********************************************************************
S Hussain		|	2013-05-14		| 6496 Optimization
*********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:import href="BibendumInclude.xsl"/>	
	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<!-- The structure of the interal XML varries depending on who the customer is -->
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
		<xsl:for-each select="Invoice">
			<!-- Each time we find an invoice element, first (repeat) copy the BatchDocument element -->
			<xsl:element name="BatchDocument">
				<!-- Now process the invoice -->
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			<!-- And before looking for another invoice, (repeat) close the BatchDocument element -->
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="TradeSimpleHeader | BuyersAddress | SuppliersAddress | ShipToAddress">
		<xsl:apply-imports/>
	</xsl:template>
	
	<xsl:template match="ShipTo">
		<ShipTo>
			<xsl:if test="ShipToLocationID or $CustomerFlag = $TESCO">
				<ShipToLocationID>
					<xsl:if test="$CustomerFlag = $TESCO">
						<GLN>
							<xsl:value-of select="ShipToAddress/AddressLine1"/>
						</GLN>
					</xsl:if>
					<xsl:copy-of select="ShipToLocationID/SuppliersCode"/>
					<xsl:if test="$CustomerFlag = $COMPASS or $CustomerFlag = $BEACON_PURCHASING">
						<BuyersCode>
							<xsl:value-of select="ShipToLocationID/SuppliersCode"/>
						</BuyersCode>
					</xsl:if>
				</ShipToLocationID>
			</xsl:if>
			<xsl:copy-of select="ShipToName"/>
			<xsl:copy-of select="ShipToAddress"/>
		</ShipTo>
	</xsl:template>
	
	<xsl:template match="InvoiceHeader/Supplier">
		<Supplier>
			<xsl:if test="$CustomerFlag = $COMPASS">
				<SuppliersLocationID>
					<SuppliersCode><xsl:value-of select="$BIBENDUM"/></SuppliersCode>
				</SuppliersLocationID>
			</xsl:if>
			<xsl:copy-of select="SuppliersName"/>
			<xsl:copy-of select="SuppliersAddress"/>
		</Supplier>
	</xsl:template>
	
	<!-- Sort all the dates in the file -->
	<xsl:template match="InvoiceHeader/BatchInformation/FileCreationDate |
									 InvoiceHeader/InvoiceReferences/InvoiceDate |
									 InvoiceHeader/InvoiceReferences/TaxPointDate |
									 InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate">
		<xsl:if test=". != ''">
			<xsl:element name="{name()}" >
				<xsl:call-template name="fixDateYY">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<!-- Sort out some numbers -->
	<xsl:template match="VATRate">
		<xsl:element name="{name()}">
			<xsl:value-of select="format-number((. div 1000),'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATRate">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="format-number((. div 1000),'0.00')"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="DocumentTotalExclVATAtRate |
									SettlementTotalExclVATAtRate |
									VATAmountAtRate |
									DocumentTotalInclVATAtRate |
									SettlementTotalInclVATAtRate |
									DocumentTotalExclVAT |
									SettlementTotalExclVAT |
									VATAmount |
									SettlementTotalInclVAT |
									DocumentTotalExclVATAtRate |
									SettlementDiscountAtRate |
									SettlementTotalExclVATAtRate |
									SettlementDiscount |
									DocumentTotalInclVAT">
		<xsl:element name="{name()}">
			<xsl:value-of select="format-number(. div 100,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="LineValueExclVAT">
		<xsl:element name="{name()}">
			<xsl:value-of select="format-number(. div 10000,'0.0000')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="NumberOfLinesAtRate">
		<xsl:element name="NumberOfLinesAtRate">
			<xsl:value-of select="format-number(.,'0')"/>
		</xsl:element>
	</xsl:template>

	<!-- SSP specific change to append the unit of measure onto the product code -->
	<xsl:template match="ProductID/SuppliersProductCode">
		<xsl:copy>
			<xsl:call-template name="FormatSupplierProductCode">
				<xsl:with-param name="sUOM" select="../../Measure/UnitsInPack"/>
				<xsl:with-param name="sProductCode" select="."/>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>
	
	<!-- Decode Bibendum's PackSizes -->
	<xsl:template match="InvoicedQuantity">
		<InvoicedQuantity>
			<xsl:attribute name="UnitOfMeasure">
				<xsl:variable name="UoM">
					<xsl:call-template name="decodePacks">
						<xsl:with-param name="sBibPack" select="following-sibling::Measure/UnitsInPack"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$UoM = 1">EA</xsl:when>
					<xsl:otherwise>CS</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="format-number(.,'0')"/>
		</InvoicedQuantity>
	</xsl:template>

	<xsl:template match="UnitValueExclVAT">
		<xsl:element name="UnitValueExclVAT">
			<xsl:variable name="UnitsInOrderedPack">
				<xsl:call-template name="decodePacks">
					<xsl:with-param name="sBibPack" select="following-sibling::Measure/UnitsInPack"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="UnitsInPricedPack">
				<xsl:value-of select="preceding-sibling::LineNumber"/>
			</xsl:variable>
			<xsl:variable name="QtyInvoiced">
				<xsl:value-of select="preceding-sibling::InvoicedQuantity"/>
			</xsl:variable>
			<xsl:variable name="UnitValue">
				<xsl:value-of select="format-number(. div 10000,'0.0000')"/>
			</xsl:variable>
			<!-- Leave the price blank to fail validation if there is no order basis -->
			<xsl:if test="$UnitsInOrderedPack != 	''">
				<!-- Round to 3dp for Compass or 2 for everyone else -->
				<xsl:choose>
					<xsl:when test="$CustomerFlag = $COMPASS">
						<xsl:value-of select="format-number($UnitValue div ($UnitsInPricedPack div $UnitsInOrderedPack),'0.000')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number($UnitValue div ($UnitsInPricedPack div $UnitsInOrderedPack),'0.00')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:element>
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

	<xsl:template match="PurchaseOrderReferences">
		<PurchaseOrderReferences>
			<PurchaseOrderReference>
				<xsl:choose>
					<xsl:when test="$CustomerFlag = $TESCO">
					
						<!-- PO ref and date are stored in PO ref field format = nnn-nnnnn yymmdd or nnnnnnnn yymmdd -->
						<xsl:variable name="allNumericPORef" select="translate(substring-before(PurchaseOrderReference,' '),'-','')"/>
						
						<xsl:value-of select="$allNumericPORef"/>
					
					</xsl:when>
					
					<xsl:otherwise>
					
						<xsl:choose>
							<xsl:when test="PurchaseOrderReference != ''">
								<xsl:value-of select="PurchaseOrderReference"/>
							</xsl:when>
							<xsl:otherwise>Not Provided</xsl:otherwise>
						</xsl:choose>
					
					</xsl:otherwise>
					
				</xsl:choose>

			</PurchaseOrderReference>
			
			<xsl:if test="$CustomerFlag = $TESCO">
			
				<PurchaseOrderDate>
			
					<xsl:call-template name="fixDateYY">
						<xsl:with-param name="sDate" select="substring-after(PurchaseOrderReference,' ')"/>
					</xsl:call-template>
				
				</PurchaseOrderDate>
						
			</xsl:if>
				
			<xsl:if test="not(normalize-space(TradeAgreement/ContractReference) = 'TRADE' or normalize-space(TradeAgreement/ContractReference) = '')">
				<TradeAgreement>
					<ContractReference>
						<xsl:value-of select="normalize-space(TradeAgreement/ContractReference)"/>
					</ContractReference>
				</TradeAgreement>
			</xsl:if>
			
		</PurchaseOrderReferences>
		
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
		<xsl:attribute name="{name()}">
			<xsl:call-template name="decodeVATCodes">
				<xsl:with-param name="sVATCode" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="LineNumber" />
	
</xsl:stylesheet>
