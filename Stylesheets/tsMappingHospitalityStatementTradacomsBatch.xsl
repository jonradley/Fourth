<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
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

	<!-- StatementLine/DocumentType needs to be mapped: 05 -> Invoice, 06 -> Credit -->
	<xsl:template match="StatementLine/DocumentType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test=". = '05'">
					<xsl:value-of select="'Invoice'"/>
				</xsl:when>
				<xsl:when test=". = '06'">
					<xsl:value-of select="'Credit'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- StatementLine/ShiptoLocationID/GLN is used to hold the statement line sequence, whilst StatementLine/ShipToLocationID/BuyersCode is used to hold DNB sequence -->
	<!--StatementLine/Narrative should not be copied over directly as it could be matched with the wrong statement line, Narrative will be copied from CORRECT place by template below this -->
	<xsl:template match="StatementLine/Narrative"/>
	<xsl:template match="ShipToLocationID/GLN"/>
	<xsl:template match="ShipToLocationID/BuyersCode"/>
	
	<!--StatementLine, this template ensures that the entire statement line is processed, followed by the code to get the narrative from the correct place-->
	<xsl:template match="StatementLine">
		<!-- The opposite of (count(node()) = 2) and (Narrative) and (count(ShipToLocationID) = 1) and (ShipToLocationID/BuyersCode)-->
		<xsl:if test="(count(node()) != 2) or (not(Narrative)) or (count(ShipToLocationID) != 1) or (not(ShipToLocationID/BuyersCode))">
			<xsl:copy>
				<xsl:apply-templates/>
				<!-- Get the sequence number of this statement line -->
				<xsl:variable name="lLineSequence" select="ShipToLocationID/GLN"/>
				<!--Now get a nodeset of all statement lines whose buyer code matches THIS line's GLN. This means we have located the statement lines containing THIS line's Narrative-->
				<xsl:variable name="StatementLinesHoldingThisStatementLinesNarrative" select="$StatementLineNodeList[./ShipToLocationID/BuyersCode = $lLineSequence]"/>
				<!--Copy the correct Narrative elements-->
				<xsl:element name="Narrative">
					<xsl:for-each select="$StatementLinesHoldingThisStatementLinesNarrative">
						<xsl:sort select="Narrative/@Code"/>
						<xsl:value-of select="Narrative"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<!-- Now apply DocumentTypeNo -->
	<xsl:template match="BatchDocument">
		<xsl:copy>
			<xsl:attribute name="DocumentTypeNo">111</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<!-- SRMINF-SRD-LIDT(StatementLine/LineValueExclVAT) and SRMINF-SRD-LIDV(StatementLine/LineVATAmount) need to be multiplied by -1 if SRMINF-SRD-LINE (StatementLine/DocumentType) is 06 -->
	<xsl:template match="StatementLine/LineValueExclVAT |
						StatementLine/LineVATAmount">
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
	<xsl:template match="StatementTrailer/TotalExclVAT |
						StatementTrailer/VATAmount">
		<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
	</xsl:template>
	
	<!-- SIMPLE CONVERSION REMOVE IMPLICIT 2 D.P -->
	<!-- Add any XPath whose text node needs to have implicit 2 D.P. removed-->
	<xsl:template match="StatementTrailer/NumberOfLines">
		<xsl:call-template name="copyCurrentNodeDPUnchanged"/>
	</xsl:template>	
	<!-- END of SIMPLE CONVERSIONS-->
	
	<!-- DATE CONVERSION YYMMDD to xsd:date -->
	<xsl:template match="StatementLine/DocumentDate |
						BatchInformation/FileCreationDate">
		<xsl:copy>
			<xsl:value-of select="concat('20', substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2))"/>
		</xsl:copy>
	</xsl:template>
	<!-- DATE CONVERSION YYMMDD:[HHMMSS] to xsd:dateTime CCYY-MM-DDTHH:MM:SS+00:00 -->
	<xsl:template match="BatchInformation/SendersTransmissionDate">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string-length(.) &lt; 13">
					<!-- Convert YYMMDD: to CCYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat('20', substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2), 'T00:00:00')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Convert YYMMDD:HHMMSS to CCYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat('20', substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2), 'T', substring(.,8,2), ':', substring(.,10,2), ':', substring(.,12,2))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<!--END of DATE CONVERSIONS -->
	
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
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 2 D.P. -->
	<xsl:template name="copyCurrentNodeRemoveImplicit2DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 100.0, '0')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 3 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit3DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 1000.0, '0.00#')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 4 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit4DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 10000.0, '0.00##')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- END of CURRENT NODE HELPERS -->	
</xsl:stylesheet>
