<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge | 13/09/2007		| 1439 branched from tsMappingHospitalityBrakesFrozenGroceryInvoiceTradacomsBatch.xsl
**********************************************************************
Lee Boyton  | 21/09/2007 		| Cater for the UoM being unrecognised by defaulting to each.
**********************************************************************
Lee Boyton  | 02/10/2007     | Cater for zero credited quantity fields.
                             | Quantity is optional in a credit note and
                             | should be removed if zero so that the line
                             | total check succeeds.
**********************************************************************
            |           		| 
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- NOTE that these string literals are not only enclosed with double quotes, but have single quotes within also-->
	<xsl:variable name="FileHeaderSegment" select="'CREHDR'"/>
	<xsl:variable name="DocumentSegment" select="'CREDIT'"/>
	<xsl:variable name="FileTrailerSegment" select="'CRETLR'"/>
	<xsl:variable name="VATTrailerSegment" select="'VATTLR'"/>
	
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
	
	<!-- InvoiceLine/ProductID/BuyersProductCode is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over -->
	<xsl:template match="BuyersProductCode"/>
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="CreditNoteLine/LineNumber">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="CreditNoteReferences/VATRegNo">
		<xsl:copy>
			<!-- Convert all colons to spaces, then trim leading and trailing whitespace - trims leading and trailing colons, and converts mid string colons to spaces -->
			<xsl:value-of select="normalize-space(translate(., ':', ' '))"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- CLD-QTYC(2) (CreditNoteLine/Measure/TotalMeasure) needs to be used if (CreditNoteLine/Measure/TotalMeasureIndicator) is NOT blank - i.e. weighted item -->
	<!-- CLD-QTYC(1) (CreditNoteLine/CreditedQuantity) needs to be multiplied by -1 if (CreditNoteLine/ProductID/BuyersProductCode) is NOT blank -->
	<xsl:template match="CreditNoteLine/CreditedQuantity">
		<xsl:variable name="UoM">
			<xsl:call-template name="sConvertUOMForInternal">
				<xsl:with-param name="vsGivenValue" select="../Measure/TotalMeasureIndicator"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Only include a CreditedQuantity field if the value is non-zero -->
		<xsl:choose>
			<xsl:when test="$UoM = 'CS' or $UoM = 'EA'">				
				<xsl:if test="number(.) != 0">
					<CreditedQuantity>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="$UoM"/>
						</xsl:attribute>			
						<xsl:value-of select="."/>
					</CreditedQuantity>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="number(../Measure/TotalMeasure) != 0">
					<CreditedQuantity>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="$UoM"/>
						</xsl:attribute>			
						<xsl:value-of select="format-number(../Measure/TotalMeasure div 1000,'0.000')"/>
					</CreditedQuantity>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
				
	<!-- CLD-EXLV (CreditNoteLine/LineValueExclVAT) need to be multiplied by -1 if (CreditNoteLine/ProductID/BuyersProductCode) is NOT blank -->
	<xsl:template match="CreditNoteLine/LineValueExclVAT">
		<!-- Implicit 4DP conversion required regardless of BuyersProductCode -->
		<xsl:choose>
			<!--Parent of LineValueExclVAT is CreditNoteLine -->
			<xsl:when test="string-length(../ProductID/BuyersProductCode) &gt; 0" >
				<!--CLD-DRLI is not blank, multiply by -1-->
				<xsl:call-template name="copyCurrentNodeExplicit4DP">
					<xsl:with-param name="lMultiplier" select="-1.0"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="copyCurrentNodeExplicit4DP"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--Don't copy invoicereferences if no invoice reference is present-->
	<xsl:template match="InvoiceReferences[not(InvoiceReference)]">
		
	</xsl:template>
	
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 2 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 2 D.P. -->
	<xsl:template match="BatchHeader/DocumentTotalExclVAT |
						BatchHeader/SettlementTotalExclVAT |
						BatchHeader/VATAmount |
						BatchHeader/DocumentTotalInclVAT |
						BatchHeader/SettlementTotalInclVAT |
						VATSubTotal/* |
						CreditNoteTrailer/DocumentTotalExclVAT |
						CreditNoteTrailer/SettlementDiscount |
						CreditNoteTrailer/SettlementTotalExclVAT |
						CreditNoteTrailer/VATAmount |
						CreditNoteTrailer/DocumentTotalInclVAT |
						CreditNoteTrailer/SettlementTotalInclVAT">
		<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
	</xsl:template>
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 3 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 3 D.P. -->
	<xsl:template match="TotalMeasure">
		<xsl:call-template name="copyCurrentNodeExplicit3DP"/>
	</xsl:template>
	<!--Add any attribute XPath whose value needs to be converted from implicit 3 D.P to explicit 2 D.P. -->
	<xsl:template match="VATSubTotal/@VATRate">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="format-number(. div 1000.0, '0.00')"/>
		</xsl:attribute>
	</xsl:template>
	<!--Add any element XPath whose value needs to be converted from implicit 3 D.P to explicit 2 D.P. -->
	<xsl:template match="CreditNoteLine/VATRate">
		<xsl:copy>
			<xsl:value-of select="format-number(. div 1000.0, '0.00')"/>
		</xsl:copy>
	</xsl:template>
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 4 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 4 D.P. -->
	<xsl:template match="CreditNoteLine/UnitValueExclVAT">
		<xsl:call-template name="copyCurrentNodeExplicit4DP"/>
	</xsl:template>
	<!-- END of SIMPLE CONVERSIONS-->

	<!-- DATE CONVERSION YYMMDD to xsd:date -->
	<xsl:template match="PurchaseOrderReferences/PurchaseOrderDate | 
						CreditNoteReferences/CreditNoteDate |
						BatchInformation/FileCreationDate |
						InvoiceReferences/InvoiceDate |
						CreditNoteReferences/TaxPointDate">
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


	<!--
	MHDSegment HANDLER
	This handler works with the MHDSegment tags which should be at the start of the BatchHeader, but are actually at start and end. Furthermore, This collection of MHDSegments includes unwanted
	CREDIT segments, which are only required at document level, under CreditNoteHeader, so the following template does not copy those.
	-->
	<xsl:template match="BatchHeader/MHDSegment">
		<xsl:if test="contains(jscript:toUpperCase(string(./MHDHeader)), $FileHeaderSegment)">
			<!--
			Only action when this template match occurs on the first useful MHDSegment (which is *probably* the first MHDSegment to be found). 
			Once this tag is found, all other useful MHDSegment tags should follow as immediate siblings in the output, 
			even though they don't in the input - they are siblings, but the rest of the BatchHeader siblings are interspersed with them in the input.
			
			Make a copy of this first useful MHDSegment tree...
			-->
			<xsl:copy-of select="."/>
			<!-- ... and ensure all the other useful MHDSegments follow on immediatley -->
			<xsl:for-each select="../MHDSegment">
				<xsl:choose>
					<xsl:when test="contains(jscript:toUpperCase(string(./MHDHeader)), $FileTrailerSegment)">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="contains(jscript:toUpperCase(string(./MHDHeader)), $VATTrailerSegment)">
						<xsl:copy-of select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="BatchDocument/CreditNote/CreditNoteHeader">
		<!-- Get a count of all the preceding instances of BatchDocument/Invoice/InvoiceHeader -->
		<xsl:variable name="BatchDocumentIndex" select="1 + count(../../preceding-sibling::*)"/>
		<!-- Get a node list of all the MHDSegment nodes under the BatchHeader tag-->
		<xsl:variable name="MHDSegmentNodeList" select="/Batch/BatchHeader/MHDSegment"/>
		<!-- Filter this node list to exclude any which do not have MHDHeader tag set to INVOIC -->
		<xsl:variable name="DocumentSegmentNodeList" select="$MHDSegmentNodeList[contains(jscript:toUpperCase(string(MHDHeader)), $DocumentSegment)]"/>
		<xsl:copy>
			<!-- Copy the Nth instance of an INVOIC MHDSegment tag to this, the Nth Invoice header tag-->
			<xsl:copy-of select="$DocumentSegmentNodeList[$BatchDocumentIndex]"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- END of MHDSegment HANDLER -->
	
	<!--
	Delivery Location Code Converter
	If the delivery location code is 6 characters long, add a "1" in as the second character
	-->
	<xsl:template match="ShipTo/ShipToLocationID/SuppliersCode">
		<xsl:choose>
			<xsl:when test="string-length(.) = 6">
				<xsl:copy>
					<xsl:value-of select="substring(.,1,1)"/>1<xsl:value-of select="substring(.,2,5)"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- END of Delivery Location Code Converter-->
	
	<!-- Check for Purchase Order Date -->
	<xsl:template match="//PurchaseOrderReferences/PurchaseOrderDate">
		<xsl:variable name="sPORefDate" select="translate(.,' ','')"/>
		<xsl:if test="string($sPORefDate) !='' ">
				<PurchaseOrderDate>
					<xsl:value-of select="$sPORefDate"/>
				</PurchaseOrderDate>
		</xsl:if>
	</xsl:template>
	
	<!-- check for presence of Invoice date and reference -->
	<xsl:template match="InvoiceReferences">
	
		<xsl:variable name="sInvRef" select="translate(InvoiceReference ,' ','')"/>
		<xsl:variable name="sInvDate" select="translate(InvoiceDate ,' ','')"/>
		<xsl:variable name="sTaxDate" select="translate(InvoiceDate ,' ','')"/>
		<xsl:variable name="sVatReg" select="translate(VATRegNo ,' ','')"/>
		
		<xsl:if test="string($sInvRef) != '' and string($sInvDate) != '' and string($sTaxDate) != '' and string($sVatReg) != '' ">

			<InvoiceReferences>
				
				<InvoiceReference>
					<xsl:value-of select="$sInvRef"/>
				</InvoiceReference>
				
				<InvoiceDate>		
					<xsl:value-of select="concat('20', substring($sInvDate, 1, 2), '-', substring($sInvDate, 3, 2), '-', substring($sInvDate, 5, 2))"/>
				</InvoiceDate>
				
				<TaxPointDate>
					<xsl:value-of select="concat('20', substring($sTaxDate, 1, 2), '-', substring($sTaxDate, 3, 2), '-', substring($sTaxDate, 5, 2))"/>
				</TaxPointDate>
				
				<VATRegNo>
					<xsl:value-of select="$sVatReg"/>
				</VATRegNo>
			
			</InvoiceReferences>
		
		</xsl:if>
	
	</xsl:template>

	<!-- 
		Template to convert UOM's into internal values
		
		Values from Schema
		
			<xsd:enumeration value="CS"/>
			<xsd:enumeration value="GRM"/>
			<xsd:enumeration value="KGM"/>
			<xsd:enumeration value="PND"/>
			<xsd:enumeration value="ONZ"/>
			<xsd:enumeration value="GLI"/>
			<xsd:enumeration value="LTR"/>
			<xsd:enumeration value="OZI"/>
			<xsd:enumeration value="PTI"/>
			<xsd:enumeration value="PTN"/>
			<xsd:enumeration value="001"/>
			<xsd:enumeration value="DZN"/>
			<xsd:enumeration value="EA"/>
			<xsd:enumeration value="PF"/>
			<xsd:enumeration value="PR"/>
			<xsd:enumeration value="HUR"/>
	-->

	<xsl:template name="sConvertUOMForInternal">
		<xsl:param name="vsGivenValue"/>
		<xsl:variable name="vsLowerCaseGivenValue" select="translate($vsGivenValue,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:choose>
			<xsl:when test="contains($vsLowerCaseGivenValue,'case') "><xsl:text>CS</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'each') "><xsl:text>EA</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'kilos') "><xsl:text>KGM</xsl:text></xsl:when>
			
			<xsl:when test="contains($vsLowerCaseGivenValue,'kg') "><xsl:text>KGM</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'bx') "><xsl:text>CS</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'cs') "><xsl:text>CS</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'grm') "><xsl:text>GRM</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'pnd') "><xsl:text>PND</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'onz') "><xsl:text>ONZ</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'gli') "><xsl:text>GLI</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'ltr') "><xsl:text>LTR</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'ozi') "><xsl:text>OZI</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'pti') "><xsl:text>PTI</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'ptn') "><xsl:text>PTN</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'001') "><xsl:text>001</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'dzn') "><xsl:text>DZN</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'ea') "><xsl:text>EA</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'pf') "><xsl:text>PF</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'pr') "><xsl:text>PR</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'hur') "><xsl:text>HUR</xsl:text></xsl:when>
			<xsl:otherwise>
				<xsl:text>EA</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[ 
		function toUpperCase(vs) {
			return vs.toUpperCase();
			//return vs;
		}
	]]></msxsl:script>
	
</xsl:stylesheet>
