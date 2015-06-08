<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Fourth Hospitality Ltd, 2014.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 		|	Description of modification
==========================================================================================
 12/02/2015	| Jose Miguel	|	FB10134 Created
==========================================================================================
 24/02/2015	| Jose Miguel	|	FB10149 Remove mapping to the UoM to use catalogue's
==========================================================================================
 27/02/2015	| Jose Miguel	|	FB10161 IHG-Generalise X12 confirmation mapper to be use with more suppliers
==========================================================================================
 08/06/2015	| Jose Miguel	|	FB10300 - IHG - Further Integration of more suppliers
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
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
	<!-- TestFlag is true if the value is 'T' -->
	<xsl:template match="//TestFlag">
		<TestFlag>
			<xsl:choose>
				<xsl:when test=".='T'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</TestFlag>
	</xsl:template>
	<!--Set DocumentStatus as 'Original'-->
	<xsl:template match="//DocumentStatus">
		<DocumentStatus>
			<xsl:text>Original</xsl:text>
		</DocumentStatus>
	</xsl:template>
	<!--Set ConfirmedDeliveryDetails/DeliveryDate-->
	<!-- the mapper could be linked 067 and 102. we only the 067-->
	<xsl:template match="//ConfirmedDeliveryDetails">
		<xsl:if test="DeliveryType = '067' and DeliveryDate">
			<ConfirmedDeliveryDetails>
				<DeliveryDate>
					<xsl:value-of select="jscript:sFormatDate(string(DeliveryDate))"/>
				</DeliveryDate>
			</ConfirmedDeliveryDetails>
		</xsl:if>	
	</xsl:template>
	<!--*********** LINE DETAILS **********-->
	<!--***************************************-->
	<xsl:template match="//PurchaseOrderConfirmationDetail">
		<xsl:element name="PurchaseOrderConfirmationDetail">
			<xsl:for-each select="PurchaseOrderConfirmationLine">
				<xsl:element name="PurchaseOrderConfirmationLine">
					<!--Amend line status-->
					<xsl:attribute name="LineStatus"><xsl:choose><xsl:when test="@LineStatus = 'AC'">Accepted</xsl:when><xsl:when test="@LineStatus = 'AR'">Accepted</xsl:when><xsl:when test="@LineStatus = 'IA'">Accepted</xsl:when><xsl:when test="@LineStatus = 'IE'">Accepted</xsl:when><xsl:when test="@LineStatus = 'SP'">Accepted</xsl:when><xsl:when test="@LineStatus = 'BP'">Changed</xsl:when><xsl:when test="@LineStatus = 'DR'">Changed</xsl:when><xsl:when test="@LineStatus = 'IB'">Changed</xsl:when><xsl:when test="@LineStatus = 'IC'">Changed</xsl:when><xsl:when test="@LineStatus = 'IP'">Changed</xsl:when><xsl:when test="@LineStatus = 'IQ'">Changed</xsl:when><xsl:when test="@LineStatus = 'ID'">Rejected</xsl:when><xsl:when test="@LineStatus = 'IF'">Rejected</xsl:when><xsl:when test="@LineStatus = 'IH'">Rejected</xsl:when><xsl:when test="@LineStatus = 'IR'">Rejected</xsl:when><xsl:when test="@LineStatus = 'IW'">Rejected</xsl:when><xsl:when test="@LineStatus = 'IS'">Added</xsl:when></xsl:choose></xsl:attribute>
					<!--Set new line number-->
					<LineNumber>
						<xsl:value-of select="jscript:nGetLineNumber()"/>
					</LineNumber>
					<!--Populate ProductID node-->
					<!--Choose the confirmed/substituted product id, if present... otherwise default to original product id-->
					<ProductID>
						<SuppliersProductCode>
							<xsl:choose>
								<xsl:when test="ProductID/SuppliersProductCode">
									<xsl:value-of select="ProductID/SuppliersProductCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="SubstitutedProductID/SuppliersProductCode"/>
								</xsl:otherwise>
							</xsl:choose>
						</SuppliersProductCode>
					</ProductID>
					<!--Copy ProductDescription node-->
					<xsl:apply-templates select="ProductDescription"/>
					<!--Populate OrderedQuantity-->
					<xsl:apply-templates select="OrderedQuantity"/>
					<ConfirmedQuantity>
						<xsl:choose>
							<xsl:when test="@LineStatus = 'IH' or @LineStatus = 'IR' or @LineStatus = 'ID' or @LineStatus = 'IF' or @LineStatus = 'IW'">
								<xsl:text>0</xsl:text>
							</xsl:when>
							<xsl:when test="ConfirmedQuantity">
								<xsl:value-of select="ConfirmedQuantity"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="OrderedQuantity"/>
							</xsl:otherwise>
						</xsl:choose>
					</ConfirmedQuantity>
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
						<xsl:if test="@LineStatus = 'IH' or @LineStatus = 'IR' or @LineStatus = 'ID' or @LineStatus = 'IF' or @LineStatus = 'IW'">
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
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
		<!--End tag of PurchaseOrderConfirmationDetail-->
	</xsl:template>
	<xsl:template match="@UnitOfMeasure">
		<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="jscript:sFormatUOM(string(.))"/></xsl:attribute>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[
		var mapUoMs = {"PK":"CS", "CA":"CS", "CS":"CS", "DZ":"DZN", "PN":"PND", "LB":"PND", "BX":"CS", "PT":"PTN", "RL":"EA", "PR":"CS"};
		var nLineNumber;
		nLineNumber = 0;
		
		function sFormatDate(vsString)
		{
			return vsString.substr(0,4) + '-' + vsString.substr(4,2) + '-' + vsString.substr(6,2);
		}

		function sFormatUOM(strSourceUoM)
		{
			var strTargetUoM = 'EA';
			if (strSourceUoM.toUpperCase() != 'EA') 
			{
				strTargetUoM = mapUoMs[strSourceUoM.toUpperCase()];
				if (strTargetUoM == null) strTargetUoM = 'EA';
			}
			return strTargetUoM;
		}
		
		function nGetLineNumber()
		{
			nLineNumber++
			return nLineNumber;
		}
		
	]]></msxsl:script>
</xsl:stylesheet>
