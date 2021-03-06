<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
S Jefford	| 22/08/2005		| GTIN field now sourced from CLD/SPRO(1).
				|						| CLD/DRLI now stored in BuyersProductCode
**********************************************************************
N Emsen		| 06/10/2006		| 	Case 434: recommit.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
N Emsen		|	02/11/2006	|	Case 454.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
N Emsen		|	06/11/2006	|	Case 527.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
N Emsen		|	02/02/2006	|	Case 777:   Changes to MJ mappers to cater 
				|						|	for Harrison spiecialised remapping. 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
N Emsen		|	06/02/2006	|	Case 781:   Mj Credit notes, changes to FFS
				|						|	for picking out the PL Account.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
N Emsen		|	10/05/2007	|	Case 1086: MJ / Aramark changes to SBR.				

**********************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- INCLUDE: PL account lookup table. As a NONE MJ Seafood PL Account user/memberid is adopted, add a record to the lookup
			table and re-deliver to live. -->
	<xsl:include href="tsMappingHospMJSeafoodsPLAccountLookupFunctions.xsl"/>
	
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
	
	<!-- CLD-QTYC(1) (CreditNoteLine/CreditedQuantity) needs to be multiplied by -1 if (CreditNoteLine/ProductID/BuyersProductCode) is NOT blank -->
	<xsl:template match="CreditNoteLine/CreditedQuantity">
		<xsl:choose>
			<!--Parent of CreditedQuantity is CreditNoteLine-->
			<xsl:when test="string-length(../ProductID/BuyersProductCode) &gt; 0" >
				<!--CLD-DRLI is not blank, multiply by -1-->
				<xsl:call-template name="copyCurrentNodeDPUnchanged">
					<xsl:with-param name="lMultiplier" select="-1.0"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="copyCurrentNodeDPUnchanged"/>
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
	<xsl:template match="//CreditNoteLine/UnitValueExclVAT">
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
	
	<!-- strips SendersBranchReference to first char. MJ Seafood depots are coded to the first character of the Suppliers Account Code. Therefore we can identify the depot from account code. -->
	<xsl:template match="//SendersBranchReference">
		<xsl:variable name="sSBRValue" select="translate(.,' ','')"/>
		<xsl:variable name="sPLAccountCode" select="//CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
		<xsl:variable name="sAramarkTestForValue" select="substring(translate(//Buyer/BuyersAddress/AddressLine1,' ',''),1,7)"/>
		<SendersBranchReference>
			<!-- check if not a PL account user -->
			<xsl:variable name="sPLAccountCodeReturn">
				<xsl:call-template name="msIsPLAccount">
					<xsl:with-param name="sValue" select="$sPLAccountCode"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- compare -->
<xsl:choose>
				<!-- IS not PL Account user -->
				<xsl:when test="string($sPLAccountCodeReturn) = 'NOT' ">
					<xsl:value-of select="substring($sSBRValue,1,1)"/>
				</xsl:when>
				<!-- Is a PL user and IS ARAMARK -->
				<xsl:when test="string($sAramarkTestForValue) = 'ARAMARK' ">
					<xsl:value-of select="$sPLAccountCode"/>
				</xsl:when>
				<!-- Is a PL user and not ARAMARK -->				
				<xsl:otherwise>
					<!-- we need to concat the together the Branch single code from MJ's account code and the PL account code to create a valid branch reference. -->
					<xsl:value-of select="concat(substring($sSBRValue,1,1),$sPLAccountCode)"/>			
				</xsl:otherwise>
			</xsl:choose>	
		</SendersBranchReference>
	</xsl:template>
		
	<!-- Check for full matching pair of purchase order references -->
	<xsl:template match="//PurchaseOrderReferences">
		<xsl:variable name="sPORefDate" select="translate(PurchaseOrderReference,' ','')"/>
		<xsl:variable name="sPOReference" select="translate(PurchaseOrderDate,' ','')"/>
		<xsl:if test="string($sPOReference) !='' and string($sPORefDate) !='' ">
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:value-of select="$sPOReference"/>
				</PurchaseOrderReference>
				<PurchaseOrderDate>
					<xsl:value-of select="$sPORefDate"/>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
		</xsl:if>
	</xsl:template>	

	<!-- CASE 777: Remap 'H0003' as 'H0002' for Harrison Catering Invoices and Credit Notes. -->
	<xsl:template match="//Buyer/BuyersLocationID/SuppliersCode">
		<!-- Current value given in the document -->
		<xsl:variable name="sCurValue" select="."/>
		<!-- Remap value if condition is found to be true. -->
		<xsl:variable name="sH0002"><xsl:text>H0002</xsl:text></xsl:variable>
		<!-- Element check value -->
		<xsl:variable name="sCheckValueH0003" ><xsl:text>H0003</xsl:text></xsl:variable>
		<!-- TEST for value = 'H0003' and company match. -->
		<xsl:choose>
			<xsl:when test="translate($sCurValue,' ','') = $sCheckValueH0003">
				<SuppliersCode>
					<xsl:value-of select="$sH0002"/>
				</SuppliersCode>
			</xsl:when>
			<!-- NOT: Leave as given -->
			<xsl:otherwise>
				<SuppliersCode>
					<xsl:value-of select="$sCurValue"/>
				</SuppliersCode>
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
