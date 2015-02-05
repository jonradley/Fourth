<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Fourth Hospitality Ltd, 2014.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 						|	Description of modification
==========================================================================================
 10/12/2012	| Jose Miguel				|	FB10134 Created
==========================================================================================
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:variable name="DefaultVATRate" select="'15'"/>
	<xsl:variable name="AccountCode">
		 <xsl:value-of select="string(//TradeSimpleHeader/SendersBranchReference)"/>
	</xsl:variable>
	
	<xsl:variable name="CustomerFlag">
		<xsl:choose>
			<xsl:when test="$AccountCode = '765198'">BWI Commissary</xsl:when>
			<xsl:when test="$AccountCode = '716911'">BWI Commissary</xsl:when>
			<xsl:when test="$AccountCode = '858142'">BWI Bateman’s</xsl:when>
			<xsl:when test="$AccountCode = '716911'">BWI Bateman’s</xsl:when>
			<xsl:when test="$AccountCode = '050582'">JFK Upper Crust/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
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

	<xsl:template match="PurchaseOrderConfirmation">
		<!-- Copy the node and add BatchRoot elements -->
		<BatchRoot>
			<xsl:copy>
				<!-- Then within this node, continue processing children -->
				<xsl:apply-templates/>
			</xsl:copy>
		</BatchRoot>
	</xsl:template>

	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->

	<!-- DATE CONVERSION dd/mm/yyyy to xsd:date -->
	<xsl:template match="PurchaseOrderReferences/PurchaseOrderDate |
						PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate |
						ConfirmedDeliveryDetails/DeliveryDate |
						ConfirmedDeliveryDetailsLineLevel/DeliveryDate">
		<xsl:copy>
			<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(.,7, 2))"/>
		</xsl:copy>
	</xsl:template>

	<!--************** HEADERS ***********-->
	<!--***************************************-->
	
	<!-- TestFlag is false is it currently equals 'P' -->
	<xsl:template match="//TestFlag">
		<xsl:element name="TestFlag">
			<xsl:choose>
				<xsl:when test=".='P'">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:element>	
	</xsl:template>

	<!--Set DocumentStatus as 'Original'-->
	<xsl:template match="//DocumentStatus">
		<xsl:element name="DocumentStatus"><xsl:text>Original</xsl:text></xsl:element>
	</xsl:template>

	<!--Set ConfirmedDeliveryDetails/DeliveryDate-->
	<xsl:template match="//ConfirmedDeliveryDetails">
		<xsl:if test="DeliveryType = '067' and DeliveryDate">
			<xsl:element name="ConfirmedDeliveryDetails">
				<xsl:element name="DeliveryDate">
					<xsl:value-of select="jscript:sFormatDate(string(DeliveryDate))"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!--*********** LINE DETAILS **********-->
	<!--***************************************-->

	<xsl:template match="//PurchaseOrderConfirmationDetail">
		<xsl:element name="PurchaseOrderConfirmationDetail">
		
		       <xsl:for-each select="PurchaseOrderConfirmationLine">
				<xsl:element name="PurchaseOrderConfirmationLine">

					<!--Amend line status-->
					<xsl:attribute name="LineStatus">
						<xsl:choose>
							<xsl:when test="@LineStatus = 'AC'">Accepted</xsl:when>
							<xsl:when test="@LineStatus = 'AR'">Accepted</xsl:when>
							<xsl:when test="@LineStatus = 'IA'">Accepted</xsl:when>
							<xsl:when test="@LineStatus = 'SP'">Accepted</xsl:when>
							<xsl:when test="@LineStatus = 'IH'">Rejected</xsl:when>
							<xsl:when test="@LineStatus = 'IR'">Rejected</xsl:when>
							<xsl:when test="@LineStatus = 'IQ'">Changed</xsl:when>
							<xsl:when test="@LineStatus = 'IS'">Added</xsl:when>
						</xsl:choose>
					</xsl:attribute>

					<!--Set new line number-->
					<xsl:element name="LineNumber">
						<xsl:value-of select="jscript:nGetLineNumber()"/>
					</xsl:element>
			
					<!--Populate ProductID node-->
					<xsl:element name="ProductID">
						<xsl:element name="SuppliersProductCode">
							<xsl:choose>
								<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'EA'">
									<!-- Only add the 's' if it is not already present, and translate lower case 'S' to upper case -->
									<xsl:choose>
										<xsl:when test="translate(substring(ProductID/SuppliersProductCode,string-length(ProductID/SuppliersProductCode),1),'s','S') != 'S'">
											<xsl:value-of select="ProductID/SuppliersProductCode"/><xsl:text>S</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(ProductID/SuppliersProductCode,1,string-length(ProductID/SuppliersProductCode)-1)"/>
											<xsl:value-of select="translate(substring(ProductID/SuppliersProductCode,string-length(ProductID/SuppliersProductCode),1),'s','S')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="ProductID/SuppliersProductCode"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:element>

					<!--Populate SubstitutedProductID-->
					<xsl:if test="@LineStatus = 'IS'">
						<xsl:element name="SubstitutedProductID">
							<xsl:element name="SuppliersProductCode">
								<xsl:choose>
									<xsl:when test="@LineStatus = 'IS'">
										<xsl:value-of select="SubstitutedProductID/SuppliersProductCode"/>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
						</xsl:element>
					</xsl:if>
			
					<!--Copy ProductDescription node-->
					<xsl:apply-templates select="ProductDescription"/>

					<!--Populate OrderedQuantity-->
					<xsl:element name="OrderedQuantity">
						<xsl:choose>
							<xsl:when test="@LineStatus = 'IS'">
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="jscript:sFormatUOM(OrderedQuantity/@UnitOfMeasure)"/>
								</xsl:attribute>
								<xsl:text>0.00</xsl:text> 
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="jscript:sFormatUOM(OrderedQuantity/@UnitOfMeasure)"/>
								</xsl:attribute>
								<xsl:value-of select="format-number(OrderedQuantity, '0.00')"/>
							</xsl:otherwise> 
						</xsl:choose>
					</xsl:element>

					<!--Populate ConfirmedQuantity-->
					<xsl:element name="ConfirmedQuantity">
						<xsl:choose>
							<xsl:when test="ConfirmedQuantity">
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="jscript:sFormatUOM(ConfirmedQuantity/@UnitOfMeasure)"/>
								</xsl:attribute>
								<xsl:value-of select="format-number(ConfirmedQuantity, '0.00')"/>
							</xsl:when>
							<xsl:when test="@LineStatus = 'IH' or @LineStatus = 'IR'">
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="jscript:sFormatUOM(OrderedQuantity/@UnitOfMeasure)"/>
								</xsl:attribute>
								<xsl:text>0.00</xsl:text> 
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="jscript:sFormatUOM(OrderedQuantity/@UnitOfMeasure)"/>
								</xsl:attribute>
								<xsl:value-of select="format-number(OrderedQuantity, '0.00')"/>
							</xsl:otherwise> 
						</xsl:choose>
					</xsl:element>

					<!--Copy UnitValueExclVAT node-->
					<xsl:apply-templates select="UnitValueExclVAT"/>

					<!--Populate ConfirmedDeliveryDetailsLineLevel-->
					<xsl:if test="ConfirmedDeliveryDetailsLineLevel/DeliveryDate != ''">
						<xsl:element name="ConfirmedDeliveryDetailsLineLevel">
							<xsl:element name="DeliveryDate">
								<xsl:if test="ConfirmedDeliveryDetailsLineLevel/DeliveryDate">
									<xsl:value-of select="jscript:sFormatDate(string(ConfirmedDeliveryDetailsLineLevel/DeliveryDate))"/>
								</xsl:if>
							</xsl:element>
						</xsl:element>
					</xsl:if>
	
					<!--Populate Narrative when status is Rejected-->
					<xsl:element name="Narrative">
						<xsl:if test="@LineStatus = 'IH' or @LineStatus = 'IR'">
							<xsl:choose>
								<xsl:when test="Narrative = 'II'">An invalid SUPC</xsl:when>
								<xsl:when test="Narrative = 'IA'">An inactive or proprietary item</xsl:when>
								<xsl:when test="Narrative = 'NS'">Split on a non-split item</xsl:when>
								<xsl:when test="Narrative = 'OS'">Out of stock (if not subbed)</xsl:when>
								<xsl:when test="Narrative = 'MS'">Quantity below minimum split quantity</xsl:when>
								<xsl:when test="Narrative = 'IM'">Invalid multiple of minimum split </xsl:when>
								<xsl:when test="Narrative = 'CI'">Customer cannot purchase commodity items</xsl:when>
								<xsl:when test="Narrative = 'NQ'">Cannot allocate negative quantity</xsl:when>
							</xsl:choose>
						</xsl:if>
					</xsl:element>
						
				</xsl:element> <!--End tag of PurchaseOrderConfirmationLine-->
				
				<!--Add an extra rejected line when substituted product found and folliowing line status is not IQ or IR -->
                           <xsl:if test="(SubstitutedProductID/SuppliersProductCode != ProductID/SuppliersProductCode) and (@LineStatus = 'IS')">                           
					<xsl:if test="(position() = last()) or (following-sibling::PurchaseOrderConfirmationLine[1]/@LineStatus != 'IQ' and following-sibling::PurchaseOrderConfirmationLine[1]/@LineStatus != 'IS')">
	
						<xsl:element name="PurchaseOrderConfirmationLine">
							<xsl:attribute name="LineStatus">Rejected</xsl:attribute>
							<xsl:element name="LineNumber"><xsl:value-of select="jscript:nGetLineNumber()"/></xsl:element>
							<xsl:element name="ProductID">
								<xsl:element name="SuppliersProductCode"><xsl:value-of select="SubstitutedProductID/SuppliersProductCode"/></xsl:element>
							</xsl:element>
							<xsl:element name="ProductDescription"><xsl:value-of select="ProductDescription"/></xsl:element>
							<xsl:element name="OrderedQuantity">
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="jscript:sFormatUOM(OrderedQuantity/@UnitOfMeasure)"/>
								</xsl:attribute>
								<xsl:value-of select="format-number(OrderedQuantity, '0.00')"/>
							</xsl:element>
							<xsl:element name="ConfirmedQuantity">
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="jscript:sFormatUOM(ConfirmedQuantity/@UnitOfMeasure)"/>
								</xsl:attribute>
								<xsl:text>0.00</xsl:text> 
							</xsl:element>	
							<xsl:apply-templates select="UnitValueExclVAT"/>					
						</xsl:element>
						
					</xsl:if>
				</xsl:if>
		       </xsl:for-each>
	       </xsl:element> <!--End tag of PurchaseOrderConfirmationDetail-->
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[
		var nLineNumber;
		nLineNumber = 0;
		
		function sFormatDate(vsString)
		{
			return vsString.substr(0,4) + '-' + vsString.substr(4,2) + '-' + vsString.substr(6,2);
		}

		function sFormatUOM(vsString)
		{
			try
			{
				vsString = vsString(0).text;
			}
			catch(exception)
			{}
			
			if (vsString =='CA')
			{
				vsString = 'CS';
			}
			return vsString;
		}
		
		function nGetLineNumber()
		{
			nLineNumber++
			return nLineNumber;
		}
		
	]]></msxsl:script>

</xsl:stylesheet>
