<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview

Pizza Express UK mapper for Restaurants Receipts Export format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date				| Name				| Description of modification
==========================================================================================
 25/11/2015	| Jose Miguel	| FB10643 - Receipts and Returns Journal Export mappers
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" exclude-result-prefixes="#default xsl msxsl js">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="TotalLines" select="count(//ReceiptLine) + count(//ReturnLine)"/>
	<xsl:variable name="TotalBatchValue" select="100 * sum(//LineValueExclVAT)"/>
	
	<xsl:template match="/">
		<xsl:text>Q455RICU, Q455RPBV, Q455RPBRC, Q4KCOO, Q455RPDOC, Q4DCTO, Q4LNID, Q4AN8, Q455RPRN, Q4TRQJ, Q4TRDJ, Q4DGL, Q4AN8V, Q455RPSN, Q4LITM, DSC1, Q4QTY, Q4UOM, Q4PRRC, Q4UORG, Q4CRRD, Q4GLC, Q455RPSC, Q4PRFL, Q4TX, Q4DL01, Q4TORG, Q4USER, Q4PID, Q4JOBN, Q4UPMJ, Q4UPMT, Q455RPDELN, Q455RPSP, Q455RPSM, CRCD, CommentsDetail, CommentsHeader, SystemTimeStamp</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>
	
	<xsl:template match="BatchDocument">
		<xsl:apply-templates select="Receipt | Return"/>
	</xsl:template>

	<xsl:template match="Receipt">
		<xsl:apply-templates select="ReceiptDetail/ReceiptLine"/>
	</xsl:template>

	<xsl:template match="Return">
		<xsl:apply-templates select="ReturnDetail/ReturnLine"/>
	</xsl:template>
	
	<!-- format date from YYYY-MM-DD to DD/MM/YYYY -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat( substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4))"/>
	</xsl:template>

	<!-- Process receipt lines PENDING return lines -->
	<xsl:template match="ReceiptLine | ReturnLine">
		<xsl:variable name="Header" select="../../ReceiptHeader | ../../ReturnHeader"/>

		<!--Q455RICU - 55RP Batch No - (Numeric 10) ¦ Field added by a processor hopefully  -->
		<xsl:value-of select="/Batch/BatchHeader/FileGenerationNumber"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPBV - 55RPBatchValue - (Numeric 10) -->
		<xsl:value-of select="$TotalBatchValue"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPBRC - 55RPBatchRowCount - (Numeric 10) -->
		<xsl:value-of select="$TotalLines"/>
		<xsl:text>,</xsl:text>
		<!--Q4KCOO - CompanyKeyOrderNo - (String 5)  - PENDING Mapping pending -->
		<xsl:value-of select="$Header/BuyersSiteCode"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPDOC - 55RP Document No - (String 25) -->
		<xsl:choose>
			<xsl:when test="$Header/PurchaseOrderReference"><xsl:value-of select="$Header/PurchaseOrderReference"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$Header/DeliveryNoteReference"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!--Q4DCTO - Order Type - (String 2) -->
		<xsl:text>OF</xsl:text>		
		<xsl:text>,</xsl:text>
		<!--Q4LNID - Line Number - (Numeric 6) -->
		<xsl:value-of select="concat(LineNumber, '000')"/>
		<xsl:text>,</xsl:text>
		<!--Q4AN8 - Address Number - (String 8) -->
		<xsl:value-of select="$Header/BuyersSiteCode"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPRN - 55RP Restaurant Name - (String 50) -->
		<xsl:value-of select="$Header/BuyersSiteName"/>
		<xsl:text>,</xsl:text>
		<!--Q4DRQJ - Date - Requested - (Date 6) -->
		<xsl:value-of select="js:convertToJulian(string($Header/PurchaseOrderDate))"/>
		<xsl:text>,</xsl:text>
		<!--Q4TRDJ - Date - Order/Transaction - (Date 6) -->
		<xsl:value-of select="js:convertToJulian(string($Header/PurchaseOrderDate))"/>
		<xsl:text>,</xsl:text>
		<!--Q4DGL - Date - For G/L (and Voucher) - (Date 6) -->
		<xsl:value-of select="js:convertToJulian(string($Header/DeliveryNoteDate))"/>
		<xsl:text>,</xsl:text>
		<!--Q4AN8V - Address Number - Supplier - (Numeric 8) -->
		<xsl:value-of select="$Header/BuyersCodeForSupplier"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPSN - 55RP Supplier Name - (String 100) -->
		<xsl:value-of select="$Header/BuyersSiteName"/>
		<xsl:text>,</xsl:text>
		<!--Q4LITM - 2nd Item Number - (String 25) -->
		<xsl:value-of select="SuppliersProductCode"/>
		<xsl:text>,</xsl:text>
		<!--DSC1 - Description - (String 25) -->
		<xsl:value-of select="ProductDescription"/>
		<xsl:text>,</xsl:text>
		<!--Q4QTY - Quantity - (Numeric 7) -->
		<xsl:value-of select="number(AcceptedQuantity) * 100"/>
		<xsl:text>,</xsl:text>
		<!--Q4UOM - Unit of Measure as Input - (String 2) -->
		<xsl:text>EA</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Q4PRRC - Amount - Unit Cost - (Numeric 15[4]) -->
		<xsl:value-of select="number(UnitValueExclVAT) * 10000"/>
		<xsl:text>,</xsl:text>
		<!--Q4UORG - Units - Order/Transaction Quantity - (Numeric 15) -->
		<xsl:value-of select="round(number(OrderedQuantity))"/>
		<xsl:text>,</xsl:text>
		<!--Q4CRRD - Currency Conversion Rate - Divisor - (Numeric 15[7])  - BLANK -->
		<xsl:text>,</xsl:text>
		<!--Q4GLC - G/L Offset - (String 8) -->
		<xsl:value-of select="$Header/CategoryNominal"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPSC - 55RP Stock Category Name - (String 50) -->
		<xsl:value-of select="$Header/CategoryName"/>
		<xsl:text>,</xsl:text>
		<!--Q4PRFL - Flag - Processed - (Character 1) - BLANK -->
		<xsl:text>,</xsl:text>
		<!--Q4TX - Purchasing Taxable (Y/N) - (Character 1) -->
		<xsl:choose>
			<xsl:when test="CustomerVATCode='S'"><xsl:text>Y</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>N</xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!--Q4DL01 - Description - (String 10) -->
		<xsl:value-of select="PackSize"/>
		<xsl:text>,</xsl:text>
		<!--Q4TORG - Transaction Originator - (String 50) -->
		<xsl:text>FOURTH</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Q4USER - User ID - (String 10) -->
		<xsl:text>INTERFACE</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Q4PID - Program ID - (String 10) -->
		<xsl:text>FRTHIMPORT</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Q4JOBN - Work Station ID - (String 10) -->
		<xsl:text>PC1</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Q4UPMJ - Date - Updated - (Date 6) -->
		<xsl:value-of select="js:convertToJulian(string(/Batch/BatchHeader/ExportRunDate))"/>
		<xsl:text>,</xsl:text>
		<!--Q4UPMT - Time - Last Updated - (Numeric 6) -->
		<xsl:value-of select="translate(ExportRunTime, '-', '')"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPDELN - 55RP Delivery Note No - (String 25) -->
		<xsl:value-of select="$Header/DeliveryNoteReference"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPSP - 55RP Stock Period ID - (Numeric 10) -->
		<xsl:value-of select="concat($Header/StockFinancialYear, format-number($Header/StockFinancialPeriod, '00'))"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPSM - 55RP Stock Movement ID - (Numeric 10) -->
		<xsl:value-of select="$Header/DocumentID"/>
		<xsl:text>,</xsl:text>
		<!--CRCD - Currency Code - From - (String 3) -->
		<xsl:value-of select="$Header/CurrencyCode"/>
		<xsl:text>,</xsl:text>
		<!--CommentsDetail - Comments - Detail - (String 25) -->
		<xsl:value-of select="normalize-space(translate(Narrative, ',', ''))"/>
		<xsl:text>,</xsl:text>
		<!--CommentsHeader - Comments - Header - (String 26) -->
		<xsl:value-of select="normalize-space(translate($Header/Narrative, ',', ''))"/>
		<xsl:text>,</xsl:text>
		<!--SystemTimeStamp - System Time Stamp - () -->
		<xsl:value-of select="concat(translate(/Batch/BatchHeader/ExportRunDate, '-',''), translate( /Batch/BatchHeader/ExportRunTime, ':', ''))"/>
		<xsl:text>&#13;&#10;</xsl:text>
    </xsl:template>
    
	<msxsl:script implements-prefix="js"><![CDATA[ 
	function convertToJulian (string_date)
	{
	    try
	    {
			var parts = string_date.split("-")
			if (parts.length != 3) return 'Error in date :' + string_date;
			
			var year = parseInt(parts[0], 10);
			var month = parseInt(parts[1], 10);
			var day = parseInt(parts[2], 10);
			
			var newdate = new Date(year, month-1, day);
			return Math.floor((newdate / 86400000) - (newdate.getTimezoneOffset()/1440) + 2440587.5);
		} 
		catch (e)
		{
			return 'ERROR:Julian date calculation failed for date: ' + string_date;
		}
	}
]]></msxsl:script>
</xsl:stylesheet>
