<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview 


 © ABS Ltd., 2007.
******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         | Description of modification
******************************************************************************************
 16/01/2008  | R Cambridge  | Created
******************************************************************************************
04/06/2010   | M Dimant       | Insert MC's GLN becuase it is needed for Bay GRNs
******************************************************************************************
21/05/2013  | S Hussain       | Case 6589: Supplier Product Code Formatting + Optimization
***************************************************************************************-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="MatthewClarkInclude.xsl"/>
	<xsl:output method="xml" indent="no"/>

	<xsl:template match="/">
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<xsl:apply-templates select="@*|node()" />
		</BatchRoot>
	</xsl:template>

	<!-- copy the trade agreement reference to the Seller/SellerAssigned element if it exists
	     otherwise remove the Seller/SellerAssigned element if not -->
	<xsl:template match="Seller[not(SellerAssigned)]">
		<xsl:copy>
			<!-- GLN is hardcoded becuase the OFSCII processor does not automatically fill in the GLN if it is empty-->
				<SellerGLN scheme="GLN">5013546103352</SellerGLN>
			<xsl:if test="//TradeAgreementReference/ContractReferenceNumber != ''">
				<SellerAssigned scheme="OTHER">
					<xsl:value-of select="//TradeAgreementReference/ContractReferenceNumber"/>
				</SellerAssigned>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Seller/SellerAssigned">
		<xsl:if test="//TradeAgreementReference/ContractReferenceNumber != ''">
			<SellerAssigned scheme="OTHER">
				<xsl:value-of select="//TradeAgreementReference/ContractReferenceNumber"/>
			</SellerAssigned>
		</xsl:if>
	</xsl:template>	

	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	
	<!--Format Product Code-->
	<xsl:template match="OrderDetails/ItemIdentification/AlternateCode">
		<AlternateCode scheme="OTHER">
			<xsl:call-template name="FormatCustomerProductCode">
				<xsl:with-param name="sUOM" select="../../RequestedQuantity/@unitCode"/>
				<xsl:with-param name="sProductCode" select="."/>
			</xsl:call-template>
		</AlternateCode>
	</xsl:template>
</xsl:stylesheet>
