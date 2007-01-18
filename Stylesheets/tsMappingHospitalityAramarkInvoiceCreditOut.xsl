<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a JDE pipe delimited format for Aramark.
 The pipe separated files will be concatenated into a batch by a subsequent processor.

 © Alternative Business Solutions Ltd., 2006.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 04/10/2006 | Lee Boyton | Created module.
******************************************************************************************
18/01/2007  | Natalie Dry  | Translate the PL account code to remove letters
******************************************************************************************
	|	| 
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl">
	<xsl:output method="text" encoding="ISO-8859-1"/>
	
	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.
	     note;  the '::' literal is simply used as a convenient separator for the 2 values that make up the second key. -->
	<xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="LineExtraData/AccountCode"/>
	<xsl:key name="keyLinesByAccountAndVAT" match="InvoiceLine | CreditNoteLine" use="concat(LineExtraData/AccountCode,'::',VATCode)"/>
	
	<xsl:template match="/Invoice | /CreditNote">

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!-- store header level values in local variables as they are repeated on multiple lines -->

		<xsl:variable name="DocumentType">
			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:text>PV</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>PD</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Remove any letters from the Aramark PL Account Code - these may be present for some suppliers who have more than one account relating to each PL account, 
			such as M&J with their depots or Bunzl with their Chemicals accounts -->
		<xsl:variable name="PLAccountCode">
			<xsl:value-of select="translate(TradeSimpleHeader/RecipientsCodeForSender, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', '')"/>
		</xsl:variable>

		<xsl:variable name="PLAccountName">
			<xsl:value-of select="TradeSimpleHeader/SendersName"/>
		</xsl:variable>
	
		<xsl:variable name="UnitCode">
			<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>			
		</xsl:variable>

		<!-- store the document date in Julian format cyyddd -->		
		<xsl:variable name="DocumentDate">
			<xsl:choose>
				<xsl:when test="InvoiceHeader/InvoiceReferences/InvoiceDate">
					<xsl:call-template name="formatDate">
						<xsl:with-param name="xmlDate" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="xmlDate" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="DocumentReference">
			<xsl:choose>
				<xsl:when test="InvoiceHeader/InvoiceReferences/InvoiceReference">
					<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="RFCTotalExclVAT">
			<xsl:choose>
				<xsl:when test="InvoiceTrailer/TrailerExtraData/CreditRequestTotalExclVAT">
					<xsl:value-of select="translate(format-number(InvoiceTrailer/TrailerExtraData/CreditRequestTotalExclVAT,'0.00'),'.','')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>0</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="TotalExclVAT">
			<xsl:choose>
				<xsl:when test="InvoiceTrailer/DocumentTotalExclVAT">
					<xsl:value-of select="translate(format-number(InvoiceTrailer/DocumentTotalExclVAT,'0.00'),'.','')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate(format-number(-1 * CreditNoteTrailer/DocumentTotalExclVAT,'0.00'),'.','')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- use the keys for grouping Lines by Account Code and then by VAT Code -->
		<!-- the first loop will match the first line in each set of lines grouped by Account Code -->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>
			<xsl:variable name="positionAccountCode" select="position()"/>
			
			<!-- now, given we can find all lines for the current Account Code, loop through and match the first line for each unique VAT Code -->
			<xsl:for-each select="key('keyLinesByAccount',$AccountCode)[generate-id() = generate-id(key('keyLinesByAccountAndVAT',concat($AccountCode,'::',VATCode))[1])]">
				<xsl:sort select="VATCode" data-type="text"/>
				<xsl:variable name="VATCode" select="VATCode"/>
				<xsl:variable name="VATRate" select="VATRate"/>

				<!-- calculate the NET and VAT amounts for this summary line (formatted to 2 implied decimal places) -->
				<xsl:variable name="LineTotalExclVAT">
					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:value-of select="translate(format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00'),'.','')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="translate(format-number(-1 * sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00'),'.','')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="LineVATAmount">
					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:value-of select="translate(format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT) * ($VATRate div 100),'0.00'),'.','')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="translate(format-number(-1 * sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT) * ($VATRate div 100),'0.00'),'.','')"/>
						</xsl:otherwise>
					</xsl:choose>					
				</xsl:variable>
				
				<!-- now output a summary line for the current Account Code and VAT Code combination -->					
				<xsl:value-of select="$DocumentType"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$PLAccountCode"/>
				<xsl:text>|</xsl:text>					
				<xsl:value-of select="$PLAccountName"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$UnitCode"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$DocumentReference"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="format-number($positionAccountCode + position() - 1,'000')"/>					
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$DocumentDate"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$LineTotalExclVAT + $LineVATAmount"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$LineTotalExclVAT"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$LineVATAmount"/>
				<xsl:text>|</xsl:text>
				<!-- translate the VAT code if it has not already been done -->
				<xsl:choose>
					<xsl:when test="(not(LineExtraData/BuyersVATCode) and $VATCode = 'S') or LineExtraData/BuyersVATCode = 'S' or LineExtraData/BuyersVATCode = 'SI'"><xsl:text>SI</xsl:text></xsl:when>
					<xsl:when test="(not(LineExtraData/BuyersVATCode) and $VATCode = 'Z') or LineExtraData/BuyersVATCode = 'Z' or LineExtraData/BuyersVATCode = 'ZI'"><xsl:text>ZI</xsl:text></xsl:when>
					<xsl:when test="(not(LineExtraData/BuyersVATCode) and $VATCode = 'E') or LineExtraData/BuyersVATCode = 'E' or LineExtraData/BuyersVATCode = 'EI'"><xsl:text>EI</xsl:text></xsl:when>
					<xsl:when test="(not(LineExtraData/BuyersVATCode) and $VATCode = 'L') or LineExtraData/BuyersVATCode = 'L' or LineExtraData/BuyersVATCode = 'I5'"><xsl:text>I5</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>SI</xsl:text></xsl:otherwise>
				</xsl:choose>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$AccountCode"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$TotalExclVAT"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="$RFCTotalExclVAT"/>
				<xsl:text>|</xsl:text>
				<!-- delivery note date in Julian format cyyddd -->
				<xsl:if test="DeliveryNoteReferences/DeliveryNoteDate">
					<xsl:call-template name="formatDate">
						<xsl:with-param name="xmlDate" select="DeliveryNoteReferences/DeliveryNoteDate"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
				<xsl:value-of select="$NewLine"/>
				
			</xsl:for-each>
		</xsl:for-each>
						
	</xsl:template>
		
	<!-- translates a date in yyyy-mm-dd format to a Julian date in cyyddd format -->
	<xsl:template name="formatDate">
		<xsl:param name="xmlDate"/>

   	<xsl:variable name="year" select="number(substring($xmlDate,1,4))"/>
   	<xsl:variable name="month" select="number(substring($xmlDate,6,2))"/>
   	<xsl:variable name="day" select="number(substring($xmlDate,9,2))"/>

		<xsl:variable name="julianDay">
			<xsl:call-template name="gregorian-to-julian">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="day" select="$day"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="first-jan-julianDay">
			<xsl:call-template name="gregorian-to-julian">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="1"/>
				<xsl:with-param name="day" select="1"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- 1 for all dates this century -->
		<xsl:text>1</xsl:text>
		<!-- last 2 digits of year -->
		<xsl:value-of select="substring($xmlDate,3,2)"/>
		<!-- number of days since 1 Jan (inclusive) -->
		<xsl:value-of select="format-number($julianDay - $first-jan-julianDay + 1,'000')"/>
		
	</xsl:template>

	<!-- converts a Gregorian to Julian Day value (don't ask me how this works - the Internet is a wonderful thing) -->
	<xsl:template name="gregorian-to-julian">
		<xsl:param name="year"/>
		<xsl:param name="month"/>
		<xsl:param name="day"/>

		<xsl:variable name="a" select="floor((14 - $month) div 12)"/>
		<xsl:variable name="y" select="$year + 4800 - $a"/>
		<xsl:variable name="m" select="$month + 12 * $a - 3"/>
   
		<xsl:value-of select="$day + floor((153 * $m + 2) div 5) + $y * 365 + 
		      floor($y div 4) - floor($y div 100) + floor($y div 400) - 
		      32045"/>		
	</xsl:template>
	
</xsl:stylesheet>