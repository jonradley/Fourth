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
==========================================================================================
 06/04/2016	| Jose Miguel	| FB10899 - Adding GRNI support
 ==========================================================================================
 14/04/2016	| Jose Miguel	| FB10911 - Refactor
 ==========================================================================================
 07/06/2016	| Jose Miguel	| FB11038 - Julian Day algorithm adjustment for leap years
==========================================================================================
 24/08/2016	| Jose Miguel	| FB11269 - CR: Adding logic to trim fields as required.
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:include href="tsMappingHospitalityPizzaExpressCommon.xsl"/>
	<xsl:output method="text" encoding="iso-8859-1"/>
	<xsl:variable name="TotalLines" select="count(//ReceiptLine) + count(//ReturnLine)"/>
	<xsl:variable name="Total" select="sum(//TotalExclVAT)"/>
	<xsl:template match="/">
		<xsl:for-each select="//ReceiptLine | //ReturnLine">
			<xsl:variable name="Q4QTY">
				<xsl:choose>
					<!-- Logic for Receipts -->
					<xsl:when test="AcceptedQuantity">
						<xsl:value-of select="number(js:calculateQ4QTY(number(AcceptedQuantity)))"/>
					</xsl:when>
					<!-- Logic for Returns -->
					<xsl:otherwise>
						<xsl:value-of select="-1 * number(js:calculateQ4QTY(number(ReturnedQuantity)))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="Q4PRRC" select="number(UnitValueExclVAT) * 10000"/>
			<xsl:variable name="Q4UORG">
				<xsl:choose>
					<!-- Logic for Receipts -->
					<xsl:when test="AcceptedQuantity">
						<xsl:value-of select="number(js:calculateQ4UORG(number($Q4QTY), number(AcceptedQuantity)))"/>
					</xsl:when>
					<!-- Logic for Returns -->
					<xsl:otherwise>
						<xsl:value-of select="number(js:calculateQ4UORG(number($Q4QTY), -number(ReturnedQuantity)))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:value-of select="js:calculateTotalByQ4QTY_Q4PRRC_Q4UORG(number($Q4QTY), number($Q4PRRC), number($Q4UORG))"/>
		</xsl:for-each>
		<xsl:choose>
			<xsl:when test="contains(//Receipt/ReceiptHeader/BuyersCodeForSupplier[1] | //Return/ReturnHeader/BuyersCodeForSupplier[1], 'EDI') or contains(//Receipt/ReceiptHeader/BuyersCodeForSupplier[1] | //Return/ReturnHeader/BuyersCodeForSupplier[1] , 'REYCAT')">
				<xsl:text>55RP Batch No,55RP Batch Value,55RP Batch Row Count,Location,Q455RPRN,Company,CustomerCode,Supplier,Q455RPSN,JDESuppCode,PurNum,DelNote,DelNum,DelDate,ManuCode,SupplierProdRef,Descript,Quantity,DelSize,DelUnit,Price,Vat able,JDECatCode,catName,ExtAmount,CRCD,CommentsDetail,CommentsHeader,SystemTimeStamp</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>
				<xsl:value-of select="js:resetLineNumber()"/>
				<xsl:apply-templates select="//ReceiptLine | //ReturnLine" mode="GRNI">
					<xsl:sort select="number(LineNumber)" order="ascending"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Q455RICU,Q455RPBV,Q455RPBRC,Q4KCOO,Q455RPDOC,Q4DCTO,Q4LNID,Q4AN8,Q455RPRN,Q4TRQJ,Q4TRDJ,Q4DGL,Q4AN8V,Q455RPSN,Q4LITM,DSC1,Q4QTY,Q4UOM,Q4PRRC,Q4UORG,Q4CRRD,Q4GLC,Q455RPSC,Q4PRFL,Q4TX,Q4DL01,Q4TORG,Q4USER,Q4PID,Q4JOBN,Q4UPMJ,Q4UPMT,Q455RPDELN,Q455RPSP,Q455RPSM,CRCD,CommentsDetail,CommentsHeader,SystemTimeStamp</xsl:text>
				<xsl:text>&#13;&#10;</xsl:text>
				<xsl:value-of select="js:resetLineNumber()"/>
				<xsl:apply-templates select="//ReceiptLine | //ReturnLine" mode="ReceiptsAndReturns">
					<xsl:sort select="number(LineNumber)" order="ascending"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Process receipt and return lines lines -->
	<xsl:template match="ReceiptLine | ReturnLine" mode="ReceiptsAndReturns">
		<xsl:variable name="Header" select="../../ReceiptHeader | ../../ReturnHeader"/>
		<!--Q455RICU - 55RP Batch No - (Numeric 10) ¦ Field added by a processor hopefully  -->
		<xsl:value-of select="/Batch/BatchHeader/FileGenerationNumber"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPBV - 55RPBatchValue - (Numeric 10) -->
		<xsl:value-of select="format-number(js:getTotalBatchQ455RPBV(), '#')"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPBRC - 55RPBatchRowCount - (Numeric 10) -->
		<xsl:value-of select="$TotalLines"/>
		<xsl:text>,</xsl:text>
		<!--Q4KCOO - CompanyKeyOrderNo - (String 5)  -->
		<xsl:value-of select="js:getSiteCodeToCompanyCode(string($Header/BuyersUnitCode))"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPDOC - 55RP Document No - (String 25) -->
		<xsl:variable name="Q455RPDOC">
			<xsl:choose>
				<xsl:when test="$Header/PurchaseOrderReference">
					<xsl:value-of select="$Header/PurchaseOrderReference"/>
				</xsl:when>
				<xsl:when test="$Header/DeliveryNoteReference">
					<xsl:value-of select="$Header/DeliveryNoteReference"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$Header/SupplierReturnsNoteReference"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="substring(js:cleanString(string($Q455RPDOC)), 1, 25)"/>
		<xsl:text>,</xsl:text>
		<!--Q4DCTO - Order Type - (String 2) -->
		<xsl:text>OF</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Q4LNID - Line Number - (Numeric 6) -->
		<xsl:value-of select="concat(string(js:getNextLineNumber()), '000')"/>
		<xsl:text>,</xsl:text>
		<!--Q4AN8 - Address Number - (String 8) -->
		<xsl:value-of select="substring($Header/BuyersUnitCode, 1, 8)"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPRN - 55RP Restaurant Name - (String 50) -->
		<xsl:value-of select="substring(js:cleanString(string($Header/BuyersSiteName)), 1, 50)"/>
		<xsl:text>,</xsl:text>
		<!--Q4TRQJ - Date - Requested - (Date 6) -->
		<xsl:choose>
			<xsl:when test="$Header/DeliveryNoteDate">
				<xsl:value-of select="js:convertToJulianYYYY_MM_DD(string($Header/DeliveryNoteDate))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="js:convertToJulianFromYYYYMMDD(string($Header/SupplierReturnsNoteDate))"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!--Q4TRDJ - Date - Order/Transaction - (Date 6) -->
		<xsl:choose>
			<xsl:when test="$Header/DeliveryNoteDate">
				<xsl:value-of select="js:convertToJulianYYYY_MM_DD(string($Header/DeliveryNoteDate))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="js:convertToJulianFromYYYYMMDD(string($Header/SupplierReturnsNoteDate))"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!--Q4DGL - Date - For G/L (and Voucher) - (Date 6) -->
		<xsl:choose>
			<xsl:when test="$Header/DeliveryNoteDate">
				<xsl:value-of select="js:convertToJulianYYYY_MM_DD(string($Header/DeliveryNoteDate))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="js:convertToJulianFromYYYYMMDD(string($Header/SupplierReturnsNoteDate))"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!--Q4AN8V - Address Number - Supplier - (String 8) -->
		<xsl:value-of select="js:toUpper(substring(js:cleanString(string($Header/BuyersCodeForSupplier)), 1, 8))"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPSN - 55RP Supplier Name - (String 100) -->
		<xsl:value-of select="substring(js:cleanString(string($Header/SuppliersName)), 1, 100)"/>
		<xsl:text>,</xsl:text>
		<!--Q4LITM - 2nd Item Number - (String 25) -->
		<xsl:value-of select="substring(SuppliersProductCode, 1, 25)"/>
		<xsl:text>,</xsl:text>
		<!--DSC1 - Description - (String 25) -->
		<xsl:value-of select="js:cleanString(string(ProductDescription))"/>
		<xsl:text>,</xsl:text>
		<!--Q4QTY - Quantity - (Numeric 7) -->
		<xsl:variable name="Q4QTY">
			<xsl:choose>
				<!-- Logic for Receipts -->
				<xsl:when test="AcceptedQuantity">
					<xsl:value-of select="number(js:calculateQ4QTY(number(AcceptedQuantity)))"/>
				</xsl:when>
				<!-- Logic for Returns -->
				<xsl:otherwise>
					<xsl:value-of select="-1 * number(js:calculateQ4QTY(number(ReturnedQuantity)))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$Q4QTY"/>
		<xsl:text>,</xsl:text>
		<!--Q4UOM - Unit of Measure as Input - (String 2) -->
		<xsl:text>EA</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Q4PRRC - Amount - Unit Cost - (Numeric 15[4]) -->
		<xsl:variable name="Q4PRRC" select="number(UnitValueExclVAT) * 10000"/>
		<xsl:value-of select="$Q4PRRC"/>
		<xsl:text>,</xsl:text>
		<!--Q4UORG - Units - Order/Transaction Quantity - (Numeric 15) -->
		<xsl:variable name="Q4UORG">
			<xsl:choose>
				<!-- Logic for Receipts -->
				<xsl:when test="AcceptedQuantity">
					<xsl:value-of select="number(js:calculateQ4UORG(number($Q4QTY), number(AcceptedQuantity)))"/>
				</xsl:when>
				<!-- Logic for Returns -->
				<xsl:otherwise>
					<xsl:value-of select="number(js:calculateQ4UORG(number($Q4QTY), -number(ReturnedQuantity)))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$Q4UORG"/>
		<xsl:text>,</xsl:text>
		<!--Q4CRRD - Currency Conversion Rate - Divisor - (Numeric 15[7])  - BLANK -->
		<xsl:text>,</xsl:text>
		<!--Q4GLC - G/L Offset - (String 8) -->
		<xsl:value-of select="js:toUpper(string(substring(js:cleanString(string(CategoryName)), 1, 8)))"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPSC - 55RP Stock Category Name - (String 50) -->
		<xsl:value-of select="substring(js:cleanString(string(CategoryName)), 1, 50)"/>
		<xsl:text>,</xsl:text>
		<!--Q4PRFL - Flag - Processed - (Character 1) - BLANK -->
		<xsl:text>,</xsl:text>
		<!--Q4TX - Purchasing Taxable (Y/N) - (Character 1) -->
		<xsl:choose>
			<xsl:when test="CustomerVATCode='S'">
				<xsl:text>Y</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>N</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!--Q4DL01 - Description - (String 10) -->
		<xsl:value-of select="substring(PackSize, 1, 10)"/>
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
		<xsl:value-of select="js:convertToJulianYYYY_MM_DD(string(/Batch/BatchHeader/ExportRunDate))"/>
		<xsl:text>,</xsl:text>
		<!--Q4UPMT - Time - Last Updated - (Numeric 6) -->
		<xsl:value-of select="translate(/Batch/BatchHeader/ExportRunTime, ':', '')"/>
		<xsl:text>,</xsl:text>
		<!--Q455RPDELN - 55RP Delivery Note No - (String 25) -->
		<xsl:value-of select="substring(js:cleanString(string($Header/DeliveryNoteReference)), 1, 25)"/>
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
		<xsl:value-of select="normalize-space(js:cleanString(string(Narrative)))"/>
		<xsl:text>,</xsl:text>
		<!--CommentsHeader - Comments - Header - (String 26) -->
		<xsl:value-of select="normalize-space(js:cleanString(string($Header/Narrative)))"/>
		<xsl:text>,</xsl:text>
		<!--SystemTimeStamp - System Time Stamp - () -->
		<xsl:value-of select="concat(translate(/Batch/BatchHeader/ExportRunDate, '-',''), translate(/Batch/BatchHeader/ExportRunTime, ':', ''))"/>
		<xsl:text>&#13;&#10;</xsl:text>
	</xsl:template>
	<!-- GRNi entries are generated by this template -->
	<xsl:template match="ReceiptLine | ReturnLine" mode="GRNI">
		<xsl:variable name="Header" select="../../ReceiptHeader | ../../ReturnHeader"/>
		<!-- 55RP Batch No - A - Batch Number (String 10). Unique identifier that represents the entire batch (file) downloaded.  Start at 1F. -->
		<xsl:value-of select="/Batch/BatchHeader/FileGenerationNumber"/>
		<xsl:text>F</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- 55RP Batch Value - B - Batch Value (Numeric 10). Total value of all receipts and stock returns in the batch in the relevant currency (e.g. £25,700.95 to be reported as 25700.95)-->
		<xsl:value-of select="format-number(js:getTotalBatch55RPBatchValue(number($Total)), '#.00')"/>
		<xsl:text>,</xsl:text>
		<!-- 55RP Batch Row Count - C - Batch Row Count (Numeric 10). Total number of records exported (i.e. the number of lines in the file excluding the header). As above there should be a separate file for each currency, receipts and stock returns to be reported in the same file.-->
		<xsl:value-of select="$TotalLines"/>
		<xsl:text>,</xsl:text>
		<!-- Location - D - Address Number (String 8). PizzaExpress reference number for the restaurant.  Should not include leading zeros.  I.e. Wardour Street = 111.-->
		<xsl:value-of select="substring($Header/BuyersUnitCode, 1, 8)"/>
		<xsl:text>,</xsl:text>
		<!-- Q455RPRN - E - 55RP Restaurant Name (String 50). Fourth name for restaurant.-->
		<xsl:value-of select="substring(js:cleanString(string($Header/BuyersSiteName)), 1, 50)"/>
		<xsl:text>,</xsl:text>
		<!-- Company - F - CompanyKeyOrderNo (String 5). The number of the company that the restaurant belongs to.  For example PizzaExpress Restaurants = 00010 and Jersey = 00020.-->
		<xsl:value-of select="js:getSiteCodeToCompanyCode(string($Header/BuyersUnitCode))"/>
		<xsl:text>,</xsl:text>
		<!-- CustomerCode - G - Customer Code (Numeric 1). Set to 0 (zero)-->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Supplier - H - Supplier Code (String 8). UPPER CASE. Fourth to supply Fourth reference for the supplier. A mapping table at PizzaExpress will convert to the JDE Address Book No.-->
		<xsl:value-of select="substring(js:toUpper(js:cleanString(string($Header/BuyersCodeForSupplier))), 1, 8)"/>
		<xsl:text>,</xsl:text>
		<!-- Q455RPSN - I - Supplier Name (String 100). Fourth name of supplier.-->
		<xsl:value-of select="substring(js:cleanString(string($Header/SuppliersName)), 1, 100)"/>
		<xsl:text>,</xsl:text>
		<!-- JDESuppCode - J - JDE Supplier Code (Numeric 1). Set to 0 (zero). The mappings are to be completed outside of Fourth Inventory-->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- PurNum - K - Purchase Order Number (Numeric 1). Set to 0 (zero)-->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- DelNote - L - Receipt/Stock Return Flag (Character 1). Y - if transaction is receipt,-->
		<xsl:choose>
			<xsl:when test="name(.)='ReceiptLine'">
				<xsl:text>Y</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>N</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!-- DelNum - M - Receipt/Stock Return Number (String 25). Delivery note / stock return number -->
		<xsl:variable name="DelNum">
			<xsl:choose>
				<xsl:when test="$Header/DeliveryNoteReference">
					<xsl:value-of select="$Header/DeliveryNoteReference"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$Header/SupplierReturnsNoteReference"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="substring(js:cleanString(string($DelNum)), 1, 25)"/>
		<xsl:text>,</xsl:text>
		<!-- DelDate - N - Delivery/Stock Return Date (). DD/MM/YYY hh:mm:ss-->
		<xsl:choose>
			<xsl:when test="$Header/DeliveryNoteDate">
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date">
						<xsl:value-of select="$Header/DeliveryNoteDate"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="formatDateWithNoSep">
					<xsl:with-param name="date">
						<xsl:value-of select="$Header/SupplierReturnsNoteDate"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> 00:00:00</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- ManuCode - O - Fourth Product Code (String 25). Item number for the product being receipted (eg. Fourth product code).-->
		<xsl:value-of select="substring(SuppliersProductCode, 1, 25)"/>
		<xsl:text>,</xsl:text>
		<!-- SupplierProdRef - P - Supplier Product Code (String 25). Item number for the product being receipted (eg. Supplier product code).-->
		<xsl:value-of select="substring(SuppliersProductCode, 1, 25)"/>
		<xsl:text>,</xsl:text>
		<!-- Descript - Q - Product Description (String 25). Item description. Do not trim to the JDE field size - this will be performed through the PizzaExpress mapping tables. No commas-->
		<xsl:value-of select="js:cleanString(string(ProductDescription))"/>
		<xsl:text>,</xsl:text>
		<!-- Quantity - R - Quantity (Numeric 7). Quantity Received including decimals (e.g. 5 cases). JDE will convert to decimals i.e. 1.5 should = 150 for JDE to convert to 1.50. Note - this field is to 2 decimal places only anymore places must be excluded.-->
		<xsl:value-of select="AcceptedQuantity | ReturnedQuantity"/>
		<xsl:text>,</xsl:text>
		<!-- DelSize - S - Units - Order/Transaction Quantity (Numeric 15). Package size (e.g. 24 bottles of Peroni per case).-->
		<xsl:value-of select="PackSize"/>
		<xsl:text>,</xsl:text>
		<!-- DelUnit - T - Delivery Units of Measure (). Delivery Units of Measure. If cannot be distinguished, set to EA-->
		<xsl:text>EA</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Price - U - Amount - Unit Cost (Numeric 15). Purchasing Cost from Restaurant system per unit. Price should be exported with decimal points. The unit cost exported should be the actual receipt unit cost.-->
		<xsl:value-of select="UnitValueExclVAT"/>
		<xsl:text>,</xsl:text>
		<!-- Vat able - V - Purchasing Taxable  (Character 1). Set to 'N' irrespectively whether item is vatable or not.-->
		<xsl:text>N</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- JDECatCode - W - Stock Category Code (String 8). UPPER CASE. Left Justify the field. Fourth Stock Category Code for item that needs to be mapped to JDE codes. This will be subject to change - if new categories are introduced they should automatically appear in the extract.-->
		<xsl:value-of select="substring(js:toUpper(js:cleanString(string(CategoryName))), 1, 8)"/>
		<xsl:text>,</xsl:text>
		<!-- catName - X - Stock Category Name (String 50). Fourth Stock Category Name.  Exported to help users when resolving issues.-->
		<xsl:value-of select="substring(js:cleanString(string(CategoryName)), 1, 50)"/>
		<xsl:text>,</xsl:text>
		<!-- ExtAmount - Y - Extended Line Amount (Numeric 15). Line value (Quantity * Price).-->
		<xsl:value-of select="LineValueExclVAT"/>
		<xsl:text>,</xsl:text>
		<!-- CRCD - Z - Currency Code (String 3). Currency Code.  £ = GBP, € = EUR-->
		<xsl:value-of select="$Header/CurrencyCode"/>
		<xsl:text>,</xsl:text>
		<!-- CommentsDetail - AA - Comments - Detail (String 25). Comments entered by the restaurant against the line item.  Do not trim to field size the PizzaExpress upload program will perform this task. No commas-->
		<xsl:value-of select="normalize-space(translate(Narrative, ',', ''))"/>
		<xsl:text>,</xsl:text>
		<!-- CommentsHeader - AB - Comments - Header (String 26). Comments entered by the restaurant against the delivery header.  Do not trim to field size the PizzaExpress upload program will perform this task. No commas-->
		<xsl:value-of select="normalize-space(translate($Header/Narrative, ',', ''))"/>
		<xsl:text>,</xsl:text>
		<!-- SystemTimeStamp - AC - System Time Stamp (). Date & time that the file was generated.-->
		<xsl:value-of select="concat(translate(/Batch/BatchHeader/ExportRunDate, '-',''), translate(/Batch/BatchHeader/ExportRunTime, ':', ''))"/>
		<xsl:text>&#13;&#10;</xsl:text>
	</xsl:template>
	<!-- format date from YYYY-MM-DD to DD/MM/YYYY -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat( substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4))"/>
	</xsl:template>
	<!-- format date from YYYYMMDD to DD/MM/YYYY -->
	<xsl:template name="formatDateWithNoSep">
		<xsl:param name="date"/>
		<xsl:value-of select="concat( substring($date, 7, 2), '/', substring($date, 5, 2), '/', substring($date, 1, 4))"/>
	</xsl:template>
	<!-- Removes ' " and , from the string -->
	<xsl:variable name="apos">'</xsl:variable>

    <xsl:template name="cleanString">
		<xsl:param name="str"/>
		<xsl:value-of select="translate($str, concat(',&quot;', $apos), '')"/>
    </xsl:template>
    
	<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
	var numTotalBatch = 0;
	var intCurrentLineNumber = 0;
	
	function calculateQ4QTY (numAcceptedQuantityOrReturned)
	{
		var intAcceptedQuantityOrReturned = parseInt(numAcceptedQuantityOrReturned, 10);

		if (intAcceptedQuantityOrReturned == numAcceptedQuantityOrReturned)
		{
			return 0;
		}
		else
		{
			return Math.round(numAcceptedQuantityOrReturned*100, 2);
		}
	}

    function calculateQ4UORG(numQ4QTY, numAcceptedQuantityOrReturned)
    {
		return ( numQ4QTY==0 )? numAcceptedQuantityOrReturned : 1;
    }
    	
	function calculateLineByQ4QTY_Q4PRRC_Q4UORG (numQ4QTY, numQ4PRRC, numQ4UORG)
	{
		var result = (numQ4QTY == 0)? numQ4PRRC * numQ4UORG : numQ4QTY * numQ4PRRC / numQ4UORG / 100;
		return result / 100;
	}
	function calculateTotalByQ4QTY_Q4PRRC_Q4UORG (numQ4QTY, numQ4PRRC, numQ4UORG)
	{
		numTotalBatch += calculateLineByQ4QTY_Q4PRRC_Q4UORG (numQ4QTY, numQ4PRRC, numQ4UORG) / 100;
		return '';
	}

	function getTotalBatch55RPBatchValue (numTotalBatch)
	{
	    var maxAllowedValue = 9999999.99;
	    var total = numTotalBatch*100;
		return total > maxAllowedValue ? maxAllowedValue : total;
	}
	
	function getTotalBatchQ455RPBV ()
	{
	    var maxAllowedValue = 9999999999;
	    var total = numTotalBatch*100;
		return total > maxAllowedValue ? maxAllowedValue : total;
	}
		
	function resetLineNumber ()
	{
		intCurrentLineNumber = 0;
		return '';
	}
	
	function getNextLineNumber ()
	{
		return ++intCurrentLineNumber;
	}

	function convertToJulianFromYYYYMMDD (string_date)
	{
	    try
	    { 
			var year = parseInt(string_date.substring(0, 4), 10);
			var month = parseInt(string_date.substring(5, 6), 10);
			var day = parseInt(string_date.substring(7, 8), 10);
	
			var theDate = new Date(year, month - 1, day);
			return convertToJulian(theDate);
		} 
		catch (e)
		{
			return 'ERROR:Julian date calculation failed for date: ' + string_date;
		}			
	}
	
	function convertToJulianYYYY_MM_DD (string_date)
	{
	    try
	    { 
			var parts = string_date.split("-")
			if (parts.length != 3) return 'Error in date :' + string_date;
			
			var year = parseInt(parts[0], 10);
			var month = parseInt(parts[1], 10);
			var day = parseInt(parts[2], 10);
	
			var theDate = new Date(year, month - 1, day);
			return convertToJulian(theDate);
		} 
		catch (e)
		{
			return 'ERROR:Julian date calculation failed for date: ' + string_date;
		}		
	}
	
	function convertToJulian (theDate)
	{
		var year = theDate.getFullYear();
		var lastDayOfPreviousYear = new Date(year, 0, 0);
		return 1000 * (year - 2000) + Math.floor((theDate - lastDayOfPreviousYear)/86300000) + 100000;
	}

  function toUpper (str)
 {
	 return str.toUpperCase();
 }  
  
  function cleanString (str)
  {
	  return str.replace("'", '').replace('"', '').replace(',', '');
  }
]]></msxsl:script>
</xsl:stylesheet>
