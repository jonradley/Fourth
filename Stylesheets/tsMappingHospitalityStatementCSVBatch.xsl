<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- Get a node list of all the BuyersCode nodes under the Batch tag, used for matching DNB sequence number with correct line sequence number-->
	<xsl:variable name="StatementLineNodeList" select="/Batch/BatchDocuments/BatchDocument/Statement/StatementDetail/StatementLine"/>

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
	
	<!-- BUG FIX - Doc-level validation requires <StatementHeader/> tag just above <StatementDetail> otherwise infiller cannot populate it after batch split  -->
	<xsl:template match="StatementDetail">
		<xsl:if test="not(../StatementHeader)">
			<xsl:element name="StatementHeader">
				<xsl:element name="BatchInformation"/>
				<xsl:element name="StatementReferences"/>
			</xsl:element>
		</xsl:if>
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Do not copy the first StatementLine node, as it is created by the flat file mapper from the header row -->
	<xsl:template match="StatementLine[1]"/>
	
	<xsl:template match="Statement/TradeSimpleHeader/TestFlag">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test=". = 'Y'"><xsl:value-of select="'1'"/></xsl:when>
				<xsl:when test=". = 'N'"><xsl:value-of select="'0'"/></xsl:when>
				<xsl:when test=". = '1'"><xsl:value-of select="'1'"/></xsl:when>
				<xsl:when test=". = '0'"><xsl:value-of select="'0'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'1'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- DATE CONVERSION YYMMDD to xsd:date -->
	<xsl:template match="StatementReferences/StatementDate |
						BatchInformation/FileCreationDate |
						StatementLine/DocumentDate">
		<xsl:copy>
			<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
		</xsl:copy>
	</xsl:template>
	<!--END of DATE CONVERSIONS -->
	
	<!-- Convert StatementLine/DocumentType from I to Invoice, C to Credit -->
	<xsl:template match="StatementLine/DocumentType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test=". = 'I'">
					<xsl:value-of select="'Invoice'"/>
				</xsl:when>
				<xsl:when test=". = 'C'">
					<xsl:value-of select="'Credit'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- StatementLine/ShiptoLocationID/GLN is used to hold the statement line sequence, whilst StatementLine/ShipToLocationID/BuyersCode is used to hold DNB sequence -->
	<!--StatementLine/Narrative should not be copied over directly as it could be matched with the wrong statement line, Narrative will be copied from CORRECT place by template below this -->
	<xsl:template match="ZZZZStatementLine/Narrative"/>
	<xsl:template match="ZZZZShipToLocationID/GLN"/>
	<xsl:template match="ZZZZShipToLocationID/BuyersCode"/>
	
	<!--StatementLine, this template ensures that the entire statement line is processed, followed by the code to get the narrative from the correct place-->
	<xsl:template match="ZZZZStatementLine">
		<xsl:copy>
			<xsl:apply-templates/>
			<!-- Get the sequence number of this statement line -->
			<xsl:variable name="lLineSequence" select="ShipToLocationID/GLN"/>
			<!--Now position a variable to the BuyerCode within a statement line whose buyer code matches THIS line's GLN. This means we have located the statement line containing THIS line's Narrative-->
			<xsl:variable name="StatementLineHoldingThisStatementLinesNarrative" select="$StatementLineNodeList[./ShipToLocationID/BuyersCode = $lLineSequence]"/>
			<!--Copy the correct Narrative element-->
			<xsl:copy-of select="$StatementLineHoldingThisStatementLinesNarrative/Narrative"/>
		</xsl:copy>
	</xsl:template>

	<!-- SRMINF-SRD-LIDT(StatementLine/LineValueExclVAT) and SRMINF-SRD-LIDV(StatementLine/LineVATAmount) need to be multiplied by -1 if SRMINF-SRD-LINE (StatementLine/DocumentType) is 06 -->
	<xsl:template match="ZZZStatementLine/LineValueExclVAT |
						ZZZStatementLine/LineVATAmount">
		<xsl:choose>
			<!--Parent of these is StatementLine -->
			<xsl:when test="../DocumentType = '06'" >
				<!--SRMINF-SRD-LINE is 06, multiply by -1-->
				<xsl:call-template name="copyCurrentNodeExplicit2DP">
					<xsl:with-param name="lMultiplier" select="-1.0"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 2 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 2 D.P. -->
	<xsl:template match="ZZZStatementTrailer/NumberOfLines |
						ZZZStatementTrailer/TotalExclVAT |
						ZZZStatementTrailer/VATAmount">
		<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
	</xsl:template>	
	<!-- END of SIMPLE CONVERSIONS-->
	
	
	
	<!-- CURRENT NODE HELPERS -->
	<xsl:template name="copyCurrentNodeDPUnchanged">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select=". * $lMultiplier"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 2 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit2DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 100.0, '0.00')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 3 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit3DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 1000.0, '0.000')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 4 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit4DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 10000.0, '0.0000')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- END of CURRENT NODE HELPERS -->
</xsl:stylesheet>
