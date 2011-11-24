<?xml version="1.0" encoding="UTF-8"?>
<!--
Dairy Farmers of Britain - Invoice mapper

V1.0 	2nd October 2004 		Andy Trafford 		Created
	
{Information below supplied by DFOB}

Daily Information within Weekly EDI Invoices
National Contracts provide most of its EDI-capable customers with weekly EDI invoices.  In some cases, the trading partner needs daily delivery note references and/or product quantities to facilitate automatic processing of the EDI documents.  In the past, National Contracts split weekly invoices received by the department into daily ones before transmitting them to the customer.  (This procedure is still followed in exceptional circumstances.)
Splitting an invoice into daily documents generates approximately six times as many transactions and creates additional overheads, especially when entering manual remittance advice information.
However, there is a mechanism where National Contracts can provide daily delivery references and/or daily quantities/weights within weekly invoices in TRADACOMS EDI files.  This allows National Contracts to enjoy the benefits of keeping the invoices as weekly ones but gives the customer the information it needs.
This facility is only available for EDI invoices – daily information cannot be provided within EDI credit note files without splitting the weekly credit notes (and invoices for the same account) into one document per day.
In the information overleaf, day 7 relates to the week-ending date of the invoice.
 
Daily Delivery Note References

Daily delivery note references are contained within the DNA segment of the INVOIC message.  There will be up to 7 references held in the GNAR sub-elements.  There will be only one DNA segment per invoice (therefore, should there be more than one delivery per day, only the first reference for that day will be provided).

Data					Data Picture		Stored in
Day 1 Delivery Note Reference	X(20)			First 20 characters of GNAR:1
Day 2 Delivery Note Reference	X(20)			Last 20 characters of GNAR:1
Day 3 Delivery Note Reference	X(20)			First 20 characters of GNAR:2
Day 4 Delivery Note Reference	X(20)			Last 20 characters of GNAR:2
Day 5 Delivery Note Reference	X(20)			First 20 characters of GNAR:3
Day 6 Delivery Note Reference	X(20)			Last 20 characters of GNAR:3
Day 7 Delivery Note Reference	X(20)			First 20 characters of GNAR:4

(The first delivery note reference encountered for the invoice is also provided in the DELN:1 sub-element of the ODD segment.)

Daily Quantities/Weights

Daily quantities/weights are contained within the DNC segment of the INVOIC message.  There will be up to 7 daily quantities/weights held in the GNAR sub-elements.  (A GNAR sub-element will be zero-filled if there are no deliveries on the 2 days to which it relates.)  There will be one instance of a DNC segment per invoice line.  Each DNC segment will relate to the ILD segment immediately before it.

Data					Data Picture		Stored in
Day 1 Quantity/Weight		9(10)V9(10)		First 20 characters of GNAR:1
Day 2 Quantity/Weight		9(10)V9(10)		Last 20 characters of GNAR:1
Day 3 Quantity/Weight		9(10)V9(10)		First 20 characters of GNAR:2
Day 4 Quantity/Weight		9(10)V9(10)		Last 20 characters of GNAR:2
Day 5 Quantity/Weight		9(10)V9(10)		First 20 characters of GNAR:3
Day 6 Quantity/Weight		9(10)V9(10)		Last 20 characters of GNAR:3
Day 7 Quantity/Weight		9(10)V9(10)		First 20 characters of GNAR:4
Quantity/Weight Identifier		X(1)			21st character of GNAR:4

As you can see, quantities/weights are presented identically as 10 complete units/units of measures followed by an implied decimal place followed by 10 decimal places  (the decimal places will contain zeroes for quantities).  Only the first 3 decimal places may contain actual data.  The remaining places are used to fill the fields to a size that allows the EDI files to be easily read.
The Quantity/Weight Identifier tells you what the contents of the preceding fields represent.  It will have a value of “Q” for quantities or “W” for weights.
The sum of the individual daily values will equal the content of the QTYI:1 (for quantities) or QTYI:2 (for weights) sub-element of the preceding ILD segment.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- NOTE that these string literals are not only enclosed with double quotes, but have single quotes within also-->
	<xsl:variable name="FileHeaderSegment" select="'INVFIL'"/>
	<xsl:variable name="DocumentSegment" select="'INVOIC'"/>
	<xsl:variable name="FileTrailerSegment" select="'INVTLR'"/>
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
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="Measure/UnitsInPack">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="Invoice">
		<!-- Init our line number counter -->
		<xsl:variable name="dummyVar" select="vbscript:resetLineNumber()"/>
   		<!--Get the custom string used to hold the week's delivery references for this invoice -->
		<xsl:variable name="DNReferencesOrig" select="InvoiceHeader/ShipTo/ShipToLocationID/GLN/text()"/>
		<!-- Check if we have any daily delivery data -->
		<xsl:choose>
			<xsl:when test="not($DNReferencesOrig)">
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<!-- Decode all the delivery note references pertaining to this invoice -->
		   		<xsl:variable name="DNReferences" select="concat($DNReferencesOrig, ':')"/>
		   		<!-- New version of string has a colon on the end to ensure we get the correct output from string functions -->
		   		<xsl:variable name="DNReference12" select="substring-before($DNReferences, ':')"/>
				<xsl:variable name="DNReference34567" select="substring-after($DNReferences, ':')"/>
				<xsl:variable name="DNReference34" select="substring-before($DNReference34567, ':')"/>
				<xsl:variable name="DNReference567" select="substring-after($DNReference34567, ':')"/>
				<xsl:variable name="DNReference56" select="substring-before($DNReference567, ':')"/>
				<!-- Extract each delivery note reference or null string -->
				<xsl:variable name="DNResultTreeFragment">
					<DN><xsl:value-of select="normalize-space(substring($DNReference12, 1, 20))"/></DN>
					<DN><xsl:value-of select="normalize-space(substring($DNReference12, 21, 20))"/></DN>
					<DN><xsl:value-of select="normalize-space(substring($DNReference34, 1, 20))"/></DN>
					<DN><xsl:value-of select="normalize-space(substring($DNReference34, 21, 20))"/></DN>
					<DN><xsl:value-of select="normalize-space(substring($DNReference56, 1, 20))"/></DN>
					<DN><xsl:value-of select="normalize-space(substring($DNReference56, 21, 20))"/></DN>
					<DN><xsl:value-of select="normalize-space(substring-before(substring-after($DNReference567, ':'), ':'))"/></DN>
				</xsl:variable>	   		
		   		<!-- Convert result tree fragment into a proper node set -->
		   		<xsl:variable name="DNReferencesNodeList" select="msxsl:node-set($DNResultTreeFragment)"/>
		   		<!-- Delivery date found in ODD segment pertaining to this invoice is day 8 -->
		   		<xsl:variable name="DNDate" select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate/text()"/>
		   		<xsl:variable name="DNYear" select="substring($DNDate, 1, 2)"/>
		   		<xsl:variable name="DNMonth" select="substring($DNDate, 3, 2)"/>
				<xsl:variable name="DNDay" select="substring($DNDate, 5, 2)"/>
		   		<!-- Now build a node list containing only days with deliveries, and an attribute containing the actual date of the delivery, which can be passed to templates -->
				<xsl:variable name="DNDataNodeList">
					<xsl:for-each select="$DNReferencesNodeList/DN">
						<!-- Current context is now our delivery note reference node set which has 7 elements, some empty -->
						<!--Only add an element to the data node list if there is a delivery on this day-->
						<xsl:if test="string(.)">
							<!-- First work out how many days into the week -->
							<xsl:variable name="DNDateOffset" select="position() - 7"/>
							<xsl:element name="Ref">
								<xsl:attribute name="Date">
									<!-- Only write the adjusted Date attribute value if the delivery date is valid, failing that copy the date garbage over unchanged to fail validation -->
									<xsl:choose>
										<xsl:when test="string(number($DNYear) + number($DNMonth) + number($DNDay)) != 'NaN'">
											<xsl:value-of select="vbscript:AddDayOffsetToDate($DNYear, $DNMonth, $DNDay, $DNDateOffset)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DNDate"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:attribute name="Day">
									<xsl:value-of select="position()"/>
								</xsl:attribute>
								<xsl:value-of select="."/>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<!-- Copy the invoice tag and then run all templates with the DN node list as a parameter-->
				<xsl:copy>
					<xsl:apply-templates>
						<xsl:with-param name="DNDataNodeList" select="msxsl:node-set($DNDataNodeList)"/>
					</xsl:apply-templates>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Accept non-standard tradacoms 9 document type -->
	<xsl:template match="BatchDocument/@DocumentTypeNo">
		<xsl:attribute name="DocumentTypeNo">
			<xsl:choose>
				<xsl:when test="string(.) = '0709'">
					<xsl:value-of select="'0700'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string(.)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	
	<!-- Placeholder template to ensure that parameters ripple down to where they are needed-->
	<xsl:template match="InvoiceDetail">
		<xsl:param name="DNDataNodeList"/>
		<xsl:copy>
			<xsl:apply-templates>
				<xsl:with-param name="DNDataNodeList" select="$DNDataNodeList"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="InvoiceLine">
		<!-- The following node list param contains a node for each distinct delivery reference. Each node has an attribute of the delivery date - 'Date' and the one-based day number it references - 'Day' -->
		<xsl:param name="DNDataNodeList"/>
		<xsl:choose>
			<xsl:when test="not($DNDataNodeList)">
				<!-- Invoice template did not find any multiple delivery note data for this invoice, so use default and just copy the invoice line once-->
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<!-- First gather the quantity data for this invoice line -->
				<xsl:variable name="ThisInvoiceLinesQuantityData" select="ProductID/BuyersProductCode/text()"/>
				<!-- Need to retain a pointer to the input context because the for each will run with our DN node list as default context -->
				<xsl:variable name="InputContext" select="."/>
				<!-- Now loop through the delivery note data creating a copy of the current invoice line for every delivery note found - this node list only contains nodes where a delivery reference was found -->
				<xsl:for-each select="$DNDataNodeList/Ref">
					<!-- string(.) is the delivery reference, @Date is the delivery date and @Day is the one based day number for using as offset into Quantity string -->
					<xsl:variable name="ZeroBasedDayIndex" select="@Day - 1"/>
					<xsl:variable name="ZeroIndexOverTwoRoundedDown" select="substring(string($ZeroBasedDayIndex div 2), 1, 1)"/>
					<xsl:variable name="TodaysQuantityDataOffset" select="($ZeroBasedDayIndex * 20) + 1 + $ZeroIndexOverTwoRoundedDown"/>
					<xsl:variable name="TodaysQuantityData" select="substring($ThisInvoiceLinesQuantityData, $TodaysQuantityDataOffset, 20)"/>
					<xsl:variable name="TodaysQuantityInteger" select="substring($TodaysQuantityData, 1, 10)"/>
					<xsl:variable name="TodaysQuantityFractional" select="substring($TodaysQuantityData, 11,10)"/>
					<xsl:variable name="TodaysDNDate" select="@Date"/>
					<xsl:variable name="TodaysDNRef" select="string(.)"/>
					<!-- BUG FIX Ensure that this day's quantity for this invoice line is not zero -->
					<xsl:if test="($TodaysQuantityFractional + $TodaysQuantityInteger) > 0">
						<!-- Now duplicate the invoice line with this day's delivery reference, date and quantity -->
						<xsl:element name="InvoiceLine">
							<!-- Must select the input document context, because the default context is our DN node list and we don't want to apply templates on that -->
							<xsl:choose>
								<xsl:when test="$TodaysQuantityFractional > 0">
									<xsl:apply-templates select="$InputContext/*">
										<xsl:with-param name="DNDate" select="$TodaysDNDate"/>
										<xsl:with-param name="DNRef" select="$TodaysDNRef"/>
										<xsl:with-param name="DNQuantity" select="number(concat($TodaysQuantityInteger, '.', $TodaysQuantityFractional))"/>
									</xsl:apply-templates>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="$InputContext/*">
										<xsl:with-param name="DNDate" select="$TodaysDNDate"/>
										<xsl:with-param name="DNRef" select="$TodaysDNRef"/>
										<xsl:with-param name="DNQuantity" select="number($TodaysQuantityInteger)"/>
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="InvoiceLine/LineNumber">
		<xsl:copy>
			<xsl:value-of select="vbscript:getLineNumber()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="DeliveryNoteReferences">
		<xsl:param name="DNDate"/>
		<xsl:param name="DNRef"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not($DNDate)">
					<!-- This invoice had only one delivery associated with it-->
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="DeliveryNoteReference"><xsl:value-of select="$DNRef"/></xsl:element>
					<xsl:element name="DeliveryNoteDate"><xsl:value-of select="$DNDate"/></xsl:element>
					<xsl:element name="DespatchDate"><xsl:value-of select="$DNDate"/></xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- INVOIC-ILD-QTYI (InvoiceLine/InvoicedQuantity) needs to be multiplied by -1 if (InvoiceLine/ProductID/GTIN) is NOT blank -->
	<xsl:template match="InvoiceLine/InvoicedQuantity">
		<xsl:param name="DNQuantity"/>
		<xsl:choose>
			<xsl:when test="not($DNQuantity) and (string($DNQuantity) != 'NaN')">
				<!-- Only a single delivery note for this invoice -->
				<xsl:choose>
					<!--Parent of InvoicedQuantity is InvoiceLine-->
					<xsl:when test="string-length(../ProductID/GTIN) &gt; 0" >
						<!--INVOIC-ILD-CRLI is not blank, multiply by -1-->
						<xsl:call-template name="copyCurrentNodeDPUnchanged">
							<xsl:with-param name="lMultiplier" select="-1.0"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="copyCurrentNodeDPUnchanged"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- This template is being invoked with the quantity as a parameter, do not copy quantity from source document -->
				<!-- (If required to remove all zero Q invoice lines when daily delivery active, test InvoicedQuantity for 0 if DNQuantity parameter is zero - if so copy the line, if not don't)-->
				<xsl:copy>
					<xsl:choose>
						<!--Parent of InvoicedQuantity is InvoiceLine-->
						<xsl:when test="(string-length(../ProductID/GTIN) &gt; 0) and ($DNQuantity > 0)" >
							<!--INVOIC-ILD-CRLI is not blank, multiply by -1-->
							<xsl:value-of select="$DNQuantity * -1"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$DNQuantity"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- InvoiceLine/ProductID/GTIN is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over -->
	<!-- ShipToLocationID/GLN used to store daily delivery references, these are not to be copied into output  -->
	<!-- ProductID/BuyersProductCode is used to store line level daily quantity information - don't copy -->
	<xsl:template match="GTIN | ShipToLocationID/GLN | ProductID/BuyersProductCode"/>
	
	<!-- INVOIC-ILD-LEXC(InvoiceLine/LineValueExclVAT) need to be multiplied by -1 if (InvoiceLine/ProductID/GTIN) is NOT blank -->
	<xsl:template match="InvoiceLine/LineValueExclVAT">
		<xsl:param name="DNRef"/>
		<xsl:if test="not($DNRef)">
			<!-- Implicit 4DP conversion required regardless of GTIN -->
			<xsl:choose>
				<!--Parent of LineValueExclVAT is InvoiceLine -->
				<xsl:when test="string-length(../ProductID/GTIN) &gt; 0" >
					<!--INVOIC-ILD-CRLI is not blank, multiply by -1-->
					<xsl:call-template name="copyCurrentNodeExplicit4DP">
						<xsl:with-param name="lMultiplier" select="-1.0"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="copyCurrentNodeExplicit4DP"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 2 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 2 D.P. -->
	<xsl:template match="BatchHeader/DocumentTotalExclVAT |
						BatchHeader/SettlementTotalExclVAT |
						BatchHeader/VATAmount |
						BatchHeader/DocumentTotalInclVAT |
						BatchHeader/SettlementTotalInclVAT |
						VATSubTotal/* |
						InvoiceTrailer/DocumentTotalExclVAT |
						InvoiceTrailer/SettlementDiscount |
						InvoiceTrailer/SettlementTotalExclVAT |
						InvoiceTrailer/VATAmount |
						InvoiceTrailer/DocumentTotalInclVAT |
						InvoiceTrailer/SettlementTotalInclVAT">
		<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
	</xsl:template>	
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 3 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 3 D.P. -->
	<xsl:template match="OrderingMeasure | 
						TotalMeasure | 
						InvoiceLine/VATRate">
		<xsl:call-template name="copyCurrentNodeExplicit3DP"/>
	</xsl:template>
	<!--Add any attribute XPath whose value needs to be converted from implicit 3 D.P to explicit 2 D.P. -->
	<xsl:template match="VATSubTotal/@VATRate">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="format-number(. div 1000.0, '0.00')"/>
		</xsl:attribute>
	</xsl:template>
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 4 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 4 D.P. -->
	<xsl:template match="InvoiceLine/UnitValueExclVAT">
		<xsl:call-template name="copyCurrentNodeExplicit4DP"/>
	</xsl:template>
	<!-- END of SIMPLE CONVERSIONS-->
	
	<!-- DATE CONVERSION YYMMDD to xsd:date -->
	<xsl:template match="PurchaseOrderReferences/PurchaseOrderDate | 
						BatchInformation/FileCreationDate |
						DeliveryNoteReferences/DeliveryNoteDate |
						DeliveryNoteReferences/DespatchDate |
						InvoiceReferences/InvoiceDate |
						InvoiceReferences/TaxPointDate">
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
	INVOIC segments, which are only required at document level, under InvoiceHeader, so the following template does not copy those.
	-->
	<xsl:template match="BatchHeader/MHDSegment">
		<xsl:if test="contains(vbscript:toUpperCase(string(./MHDHeader)), $FileHeaderSegment)">
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
					<xsl:when test="contains(vbscript:toUpperCase(string(./MHDHeader)), $FileTrailerSegment)">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="contains(vbscript:toUpperCase(string(./MHDHeader)), $VATTrailerSegment)">
						<xsl:copy-of select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>	
	<xsl:template match="BatchDocument/Invoice/InvoiceHeader">
		<!-- Get a count of all the preceding instances of BatchDocument/Invoice/InvoiceHeader -->
		<xsl:variable name="BatchDocumentIndex" select="1 + count(../../preceding-sibling::*)"/>
		<!-- Get a node list of all the MHDSegment nodes under the BatchHeader tag-->
		<xsl:variable name="MHDSegmentNodeList" select="/Batch/BatchHeader/MHDSegment"/>
		<!-- Filter this node list to exclude any which do not have MHDHeader tag set to INVOIC -->
		<xsl:variable name="DocumentSegmentNodeList" select="$MHDSegmentNodeList[contains(vbscript:toUpperCase(string(MHDHeader)), $DocumentSegment)]"/>
		<xsl:copy>
			<!-- Copy the Nth instance of an INVOIC MHDSegment tag to this, the Nth Invoice header tag-->
			<xsl:copy-of select="$DocumentSegmentNodeList[$BatchDocumentIndex]"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- END of MHDSegment HANDLER -->
	
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 
		Function toUpperCase(vs)
			toUpperCase = UCase(vs)
		End Function
		
		Function AddDayOffsetToDate(sYear, sMonth, sDate, lOffset)
			Dim dtAdjusted, lYearAdjusted, lMonthAdjusted, lDayAdjusted

			dtAdjusted = DateSerial("20" & sYear, sMonth, sDate + lOffset)
			lYearAdjusted = DatePart("yyyy", dtAdjusted)
			lMonthAdjusted = DatePart("m", dtAdjusted)
			lDayAdjusted = DatePart("d", dtAdjusted)
			AddDayOffsetToDate  = lYearAdjusted & "-" & Right("0" & lMonthAdjusted, 2) & "-" & Right("0" & lDayAdjusted, 2)
		End Function
		
		Dim lLineNumber
		
		Function resetLineNumber()
			lLineNumber = 1
			resetLineNumber = 1
		End Function
		
		Function getLineNumber()
			getLineNumber = lLineNumber
			lLineNumber = lLineNumber + 1
		End Function
]]></msxsl:script>
	
</xsl:stylesheet>
