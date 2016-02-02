<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Hospitality Invoice/Credit note/ Debit note into the Oracle file for Aramark UK

 © Fourth Hospitality
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 06/10/2014      | J Miguel		  | 10038 - Created
******************************************************************************************
 24/03/2015      | J Miguel		  | 10202 - Update codes in mapper
******************************************************************************************
 09/04/2015      | J Miguel		  | 10224 - Update codes in mapper (2nd round)
******************************************************************************************
 22/04/2015      | J Miguel		  | 10233 - Add new changes to the feed
******************************************************************************************
 29/06/2015      | J Miguel		  | 10330 - Update codes for UAT
******************************************************************************************
 09/07/2015      | J Miguel		  | 10371 - More changes for UAT
******************************************************************************************
 11/11/2015      | J Miguel		  | 10595 - New set of mapping ids
******************************************************************************************
 10/12/2015      | J Miguel		  | 10666 - Add PORef and change in translation method
******************************************************************************************
 08/01/2016      | J Miguel		  | 10740 - Remove mappings
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="separator" select="'|'"/>
	<xsl:param name="line-separator" select="'&#13;&#10;'"/>
	<xsl:param name="SITE_CODE_SEPARATOR" select="' '"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//Invoice | //CreditNote | //DebitNote"/>
		<!-- Footer section -->
		<!-- Record Type -->
		<xsl:text>FT</xsl:text>
		<xsl:value-of select="$separator"/>
		<!-- Record Count -->
		<xsl:value-of select="count(//Invoice | //CreditNote | //DebitNote | //InvoiceDetail/InvoiceLine | //CreditNoteDetail/CreditNoteLine | //DebitNoteDetail/DebitNoteLine)"/>
		<xsl:value-of select="$separator"/>
		<!-- Batch Name -->
		<xsl:text>INTRANET </xsl:text>
		<xsl:value-of select="script:getCurrentDate()"/>
		<xsl:text> ARATRADE</xsl:text>
		<xsl:value-of select="$separator"/>
	</xsl:template>
	<xsl:template match="//Invoice | //CreditNote | //DebitNote">
		<xsl:variable name="primaryCodeForSite" select="string(substring-before(concat(InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode | CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode | DebitNoteHeader/ShipTo/ShipToLocationID/BuyersCode, $SITE_CODE_SEPARATOR), $SITE_CODE_SEPARATOR))"/>
		<xsl:variable name="vendorChildCode" select="string(TradeSimpleHeader/RecipientsCodeForSender)"/>
		<xsl:variable name="vendorChildCodeAlt" select="string(InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode | CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode | DebitNoteHeader/Supplier/SuppliersLocationID/BuyersCode)"/>
		
		<xsl:variable name="primaryCodePrefix" select="substring($primaryCodeForSite, 1, 4)"/>

		<!-- Record Type -->
		<xsl:text>IH</xsl:text>
		<xsl:value-of select="$separator"/>
		<!-- Operating Unit -->
		<xsl:text>ARAMARK UNITED KINGDOM (OU)</xsl:text>
		<xsl:value-of select="$separator"/>
		<!-- Source Name -->
		<xsl:text>19_ARATRADE</xsl:text>
		<xsl:value-of select="$separator"/>
		<!-- Invoice Ref -->
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference | CreditNoteHeader/CreditNoteReferences/CreditNoteReference | DebitNoteHeader/DebitNoteReferences/DebitNoteReference"/>
		<xsl:value-of select="$separator"/>
		<!-- Invoice Date -->
		<xsl:value-of select="translate(InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/InvoiceReferences/InvoiceDate | DebitNoteHeader/InvoiceReferences/InvoiceDate,'-','')"/>
		<xsl:value-of select="$separator"/>
		
		<!-- Supplier # -->
		<xsl:value-of select="script:getOracleVendorCodeFromChildValue($vendorChildCode, $vendorChildCodeAlt)"/>
		<xsl:value-of select="$separator"/>
		
		<!-- Supplier Tax # BLANK -->
		<xsl:value-of select="$separator"/>
		
		<!-- Supplier Site -->
		<xsl:value-of select="script:getOraclePLAccountCodeFromChildValue($vendorChildCode, $vendorChildCodeAlt)"/>
		<xsl:value-of select="$separator"/>
		
		<!-- Invoice Amt -->
		<xsl:choose>
			<xsl:when test="name()='Invoice'">
				<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:when>
			<xsl:when test="name()='CreditNote'">
				<xsl:value-of select="format-number(number(CreditNoteTrailer/DocumentTotalInclVAT)*-1,'0.00')"/>
			</xsl:when>
			<xsl:when test="name()='DebitNote'">
				<xsl:value-of select="format-number(number(DebitNoteTrailer/DocumentTotalInclVAT)*-1,'0.00')"/>
			</xsl:when>
		</xsl:choose>
		<xsl:value-of select="$separator"/>		
		<!-- Currency Code -->
		<xsl:text>GBP</xsl:text>
		<xsl:value-of select="$separator"/>		
		<!-- Currency Rate BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Rate Type -->
		<xsl:text>ARA GB Corp</xsl:text>
		<xsl:value-of select="$separator"/>
		<!-- Terms BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Description BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute Category - XARAUK_INV_HEADER -->
		<xsl:text>XARAUK_INV_HEADER</xsl:text>
		<xsl:value-of select="$separator"/>
		<!-- Old Supplier Ref - Purchase Reference -->
		<xsl:value-of select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference[1] | CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference[1] | DebitNoteDetail/DebitNoteLine/PurchaseOrderReferences/PurchaseOrderReference[1]"/>
		<xsl:value-of select="$separator"/>
		<!-- Attribute2 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute3 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute4 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute5 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute6 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute7 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute8 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute9 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute10 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute11 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute12 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute13 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute14 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Attribute15 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att Cat BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att1 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att2 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att3 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att4 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att5 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att6 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att7 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att8 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att9 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att10 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att11 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att12 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att13 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att14 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att15 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att16 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att17 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att18 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att19 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Global Att20 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Pay Group BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- GL Date BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Document Category BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Document Number . JM? is this really BLANK it looks like that by the specs clarifications. check pending. -->
		<xsl:value-of select="$separator"/>
		<!-- Country/LE BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Profit center BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Account BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Sub Account BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Service Type BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Bill Code BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Concept BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Sales Tax BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Future BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Intercompany BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Legacy 1 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Legacy 2 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Legacy 3 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Legacy 4 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Legacy 5 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Legacy 6 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Legacy 7 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Legacy 8 BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Taxation Country BLANK -->
		<xsl:value-of select="$separator"/>		
		<!-- Sub-Type -->
		<xsl:value-of select="$separator"/>
		<!-- Calculate Tax During Import -->
		<xsl:text>Y</xsl:text>
		<xsl:value-of select="$separator"/>
		<!-- Add Tax to Inv Amt BLANK -->
		<xsl:value-of select="$separator"/>
		<!-- Legal Entity Name -->
		<xsl:text>Aramark UK Ltd</xsl:text>
		<xsl:value-of select="$separator"/>		
		<!-- Withholding Tax Group BLANK -->
		<xsl:value-of select="$separator"/>	
		<!-- Payment Withholding Tax Group . JM? NULL (BLANK) -->
		<xsl:value-of select="$separator"/>			
		<xsl:for-each select="InvoiceDetail/InvoiceLine | CreditNoteDetail/CreditNoteLine | DebitNoteDetail/DebitNoteLine">
			<xsl:sort select="VATCode"/>
			<xsl:sort select="VATRate"/>
			<xsl:sort select="$AccountCode"/>
			<xsl:variable name="AccountCode" select="script:getOracleAccountCodeFromJDEValue(string(LineExtraData/AccountCode))"/>
			<xsl:value-of select="$line-separator"/>
			<!-- Record Type -->
			<xsl:text>IL</xsl:text>
			<xsl:value-of select="$separator"/>
			<!-- Line # -->
			<xsl:value-of select="LineNumber"/>
			<xsl:value-of select="$separator"/>
			<!-- Line Type -->
			<xsl:text>ITEM</xsl:text>
			<xsl:value-of select="$separator"/>
			<!-- Line Amt -->
			<xsl:choose>
				<xsl:when test="name()!='InvoiceLine'">
					<xsl:value-of select="format-number(LineValueExclVAT*-1,'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>			
			<xsl:value-of select="$separator"/>
			<!-- Line Description -->
			<xsl:value-of select="ProductDescription"/>
			<xsl:value-of select="$separator"/>
			<!-- Country/LE this was $primaryCodePrefix -->
			<xsl:text>1906</xsl:text>
			<xsl:value-of select="$separator"/>
			<!-- Profit center this was only $primaryCodeForSite -->
			<xsl:if test="string-length($primaryCodeForSite) = 4"><xsl:text>190</xsl:text></xsl:if>
			<xsl:value-of select="$primaryCodeForSite"/>
			<xsl:value-of select="$separator"/>
			<!-- Account - this was BLANK -->
			<xsl:value-of select="substring-before($AccountCode, '.')"/>			
			<xsl:value-of select="$separator"/>
			<!-- Sub Account - this was BLANK -->
			<xsl:value-of select="substring-after($AccountCode, '.')"/>
			<xsl:value-of select="$separator"/>
			<!-- Service Type - this was BLANK -->
			<xsl:text>000</xsl:text>
			<xsl:value-of select="$separator"/>
			<!-- Bill Code -->
			<xsl:text>0</xsl:text>
			<xsl:value-of select="$separator"/>
			<!-- Concept -->
			<xsl:text>0000</xsl:text>
			<xsl:value-of select="$separator"/>
			<!-- Sales Tax -->
			<xsl:text>00</xsl:text>
			<xsl:value-of select="$separator"/>
			<!-- Future -->
			<xsl:text>00000</xsl:text>			
			<xsl:value-of select="$separator"/>
			<!-- Intercompany -->
			<xsl:text>0000</xsl:text>
			<xsl:value-of select="$separator"/>
			<!-- Legacy 1 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Legacy 2 WAS the account.subaccount -->
			<xsl:value-of select="$separator"/>
			<!-- Legacy 3 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Legacy 4 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Legacy 5 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Legacy 6 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Legacy 7 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Legacy 8 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute Category BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute1 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute2 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute3 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute4 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute5 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute6 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute7 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute8 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute9 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute10 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute11 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute12 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute13 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute14 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Attribute15 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att Cat BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att1 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att2 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att3 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att4 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att5 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att6 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att7 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att8 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att9 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att10 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att11 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att12 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att13 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att14 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att15 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att16 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att17 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att18 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att19 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Global Att20 BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Tax Code -->
			<xsl:choose>
				<xsl:when test="VATCode = 'S'">GB-STANDARD</xsl:when>
				<xsl:when test="VATCode = 'R'">GB-REDUCED</xsl:when>
				<xsl:when test="VATCode = 'E'">GB-EXEMPT</xsl:when>
				<xsl:when test="VATCode = 'Z'">GB-ZERO RATED</xsl:when>
				<xsl:when test="VATCode = 'L'">GB-REDUCED</xsl:when>
			</xsl:choose>
			<xsl:value-of select="$separator"/>
			<!-- Business Category BLANK -->
			<xsl:value-of select="$separator"/>
			<!-- Fiscal Classification -->
			<xsl:value-of select="$separator"/>
		</xsl:for-each>
		<xsl:value-of select="$line-separator"/>
	</xsl:template>
	<msxsl:script language="Javascript" implements-prefix="script"><![CDATA[
// Check if the childvalue (in both alternitive locations) is an oracle code.
// If there is no match, then try the JDE conversion table for child values.
function getOracleVendorCodeFromChildValue (keyOracleChildValue, keyOracleChildValueAlt)
{
	var keyOracleValue = mapOraclePLAccountToVendorCode[keyOracleChildValue];
	if (keyOracleValue == null)
	{
		keyOracleValue =  mapOraclePLAccountToVendorCode[keyOracleChildValueAlt];
		
		// If null this has to be a JDE code.
		if (keyOracleValue == null)
		{
			keyOracleValue =  getOracleVendorCodeFromJDEValue(keyOracleChildValue, keyOracleChildValueAlt)
		}
	}

	return keyOracleValue;	
}

function getOracleVendorCodeFromJDEValue (keyJDEValue, keyJDEValueAlt)
{
	var keyORACLEValue = mapVendorCodes[keyJDEValue];
	if (keyORACLEValue == null)
	{
		keyORACLEValue =  mapVendorCodes[keyJDEValueAlt];
		if (keyORACLEValue == null)
		{
			keyORACLEValue =  keyJDEValue;
		}
	}

	return keyORACLEValue;	
}

// Check if the child values (in any location) are oracle ones. and if so, just return the one that matches.
// If not, try with the JDE tables
function getOraclePLAccountCodeFromChildValue (keyOracleChildValue, keyOracleChildValueAlt)
{
	var keyOracleValue = mapOraclePLAccountToVendorCode[keyOracleChildValue];
	if (keyOracleValue != null)
	{
		return keyOracleChildValue;
	}
	
	keyOracleValue = mapOraclePLAccountToVendorCode[keyOracleChildValueAlt];
	if (keyOracleValue != null)
	{
		return keyOracleChildValue;
	}

	// on failure, this has to be an JDE Code.
	return getOraclePLAccountCodeFromJDEValue (keyOracleChildValue, keyOracleChildValueAlt)
}

function getOraclePLAccountCodeFromJDEValue (keyJDEValue, keyJDEValueAlt)
{
	var keyORACLEValue = mapJDEPLAccountsToOracle[keyJDEValue];
	if (keyORACLEValue == null)
	{
		keyORACLEValue = mapJDEPLAccountsToOracle[keyJDEValueAlt];
	}
	
	if (keyORACLEValue == null)
	{
		keyORACLEValue = keyJDEValue;
	}

	return keyORACLEValue;	
}

function right (str, count)
{
	return str.substring(str.length - count, str.length);
}

function pad2 (str)
{
	return right('0' + str, 2);
}

function getCurrentDate ()
{
	try
	{
		var date = new Date();
		return  '' + date.getFullYear() + pad2(date.getMonth() +1) + pad2(date.getDay());
	}
	catch (ex)
	{
		return ex.message;
	}
}

function getOracleAccountCodeFromJDEValue (keyJDEValue)
{
	var keyORACLEValue = mapAccountCodes[keyJDEValue];
	if (keyORACLEValue == null)
	{
		keyORACLEValue = keyJDEValue;
	}
	
	return keyORACLEValue;
}


var mapAccountCodes = 
{
	'6111.02':'2000.001101',
	'6111.04':'2300.190224',
	'6111.06':'2000.191407',
	'6111.08':'2000.001602',
	'6111.12':'2000.001112',
	'6111.14':'2300.190177',
	'6111.16':'2000.190137',
	'6111.82':'2300.190052',
	'6118.02':'2000.190348',
	'6118.04':'2300.191268',
	'6118.06':'2000.191408',
	'6118.08':'2300.190018',
	'6118.10':'2300.191208',
	'6118.11':'2000.191118',
	'6118.12':'2000.190398',
	'6118.15':'2000.191098',
	'6118.18':'2300.191278',
	'6118.20':'2300.190368',
	'6121.02':'2000.001102',
	'6128.02':'2000.190258',
	'6131.02':'2000.190010',
	'6131.04':'2000.001011',
	'6131.06':'2000.001012',
	'6131.08':'2000.001204',
	'6138.02':'2000.190068',
	'6139.02':'2300.191288',
	'6141.02':'2000.001001',
	'6141.04':'2000.001009',
	'6148.02':'2000.190098',
	'6191.01':'2300.001201',
	'6211.01':'2000.001003',
	'6218.01':'2000.190358',
	'6258.01':'2300.190638',
	'6271.01':'2000.001213',
	'6278.01':'2000.191088',
	'6311.01':'2300.190201',
	'6318.01':'2300.191238',
	'6321.02':'2300.001211',
	'6321.12':'2300.190117',
	'6331.02':'2500.001318',
	'6331.06':'2500.001307',
	'6331.08':'2500.003811',
	'6331.10':'2500.001315',
	'6331.14':'2500.190140',
	'6331.18':'2500.190121',
	'6331.20':'2500.190109',
	'6331.22':'2300.001215',
	'6331.24':'2300.001219',
	'6331.26':'2300.190094',
	'6331.28':'2300.001216',
	'6331.36':'2500.001317',
	'6331.38':'2500.190032',
	'6331.40':'2500.190015',
	'6331.44':'2300.190024',
	'6331.46':'2300.190045',
	'6331.48':'2300.190123',
	'6338.14':'2500.191138',
	'6418.01':'2300.190218',
	'6421.07':'2300.190003',
	'6422.17':'2300.190141',
	'6428.03':'2300.190768',
	'6428.05':'2300.190288',
	'6428.07':'2300.190028',
	'6428.11':'2300.190688',
	'6431.17':'2300.001007',
	'6431.23':'2300.190041',
	'6441.41':'2300.190095',
	'6451.10':'2300.190071',
	'6511.01':'2000.001210',
	'6511.05':'2000.190020',
	'6511.20':'2300.190016',
	'6511.90':'2300.003812',
	'6518.03':'2000.190948',
	'6518.05':'2000.191248',
	'6518.07':'2000.190718',
	'6518.20':'2300.190168',
	'6518.60':'2300.190128',
	'6518.61':'2300.190118',
	'6518.90':'2300.191038',
	'6521.40':'2300.003205',
	'6531.01':'2300.001203',
	'6531.19':'2300.190210',
	'6538.01':'2300.190978',
	'6538.02':'2000.190908',
	'6541.03':'2300.190179',
	'6548.03':'2300.191218',
	'6591.01':'2300.190180',
	'6591.02':'2300.191357',
	'6591.20':'2300.190107',
	'6592.10':'2300.190181',
	'6598.02':'2300.191358',
	'6907.01':'2600.190169',
	'6908.01':'2600.190378',
	'6908.02':'2600.190318',
	'6908.03':'2600.190308',
	'6908.05':'2600.190818',
	'6908.06':'2600.190808',
	'6908.07':'2600.190088',
	'6908.08':'2600.190418',
	'6908.09':'2600.190188',
	'6908.11':'2600.190388',
	'6908.12':'2600.190038',
	'6908.14':'2600.190338',
	'6908.15':'2600.190428',
	'6908.16':'2600.190568',
	'6908.17':'2600.190668',
	'6908.20':'2600.190868',
	'7018.00':'3100.190878',
	'7018.05':'3100.190658',
	'7018.06':'3100.190078',
	'7018.07':'3100.191338',
	'7018.08':'3100.190238',
	'7018.09':'3100.190698',
	'7018.10':'3100.191348',
	'7018.12':'3100.190578',
	'7018.13':'3100.191058',
	'7018.14':'3100.190708',
	'7018.15':'3100.191298',
	'7018.32':'3100.190898',
	'7018.33':'3100.190858',
	'7018.35':'3100.190888',
	'7018.40':'3100.191128',
	'7018.45':'3100.190298',
	'7018.50':'3100.191388',
	'7018.51':'3100.190998',
	'7018.60':'3100.190558',
	'7018.70':'3100.001318',
	'7018.80':'3100.191108',
	'7020.02':'3101.190698',
	'7020.04':'3100.190120',
	'7020.06':'3100.190085',
	'7020.08':'3100.190083',
	'7021.52':'3100.001307',
	'7021.60':'3100.190133',
	'7021.61':'3295.002007',
	'7021.70':'3100.190004',
	'7028.00':'3110.191008',
	'7028.02':'3100.191458',
	'7028.52':'3190.190838',
	'7028.53':'3190.190848',
	'7038.40':'3795.190173',
	'7038.41':'3795.191048',
	'7038.42':'3250.190438',
	'7038.43':'3790.190618',
	'7038.44':'3299.190678',
	'7038.45':'3299.190158',
	'7038.46':'3100.190165',
	'7038.50':'3250.190738',
	'7038.51':'3250.190162',
	'7038.52':'3250.190728',
	'7038.53':'3250.190172',
	'7038.54':'3250.191308',
	'7038.55':'3250.190528',
	'7038.58':'3250.190648',
	'7038.60':'3100.190738',
	'7038.61':'3250.191318',
	'7038.80':'3125.190448',
	'7038.82':'3240.190928',
	'7038.92':'3295.190008',
	'7041.65':'3299.190079',
	'7041.85':'3299.190126',
	'7041.86':'3299.190127',
	'7041.90':'3299.190091',
	'7041.91':'3299.190092',
	'7041.92':'3299.190061',
	'7041.93':'3299.190062',
	'7041.94':'3299.003853',
	'7041.95':'3299.190037',
	'7100.10':'3110.190067',
	'7102.01':'3110.190195',
	'7108.10':'3110.191198',
	'7591.02':'3100.191367',
	'7592.10':'3100.190182',
	'7598.02':'3100.191368',
	'8051.01':'3460.003827',
	'8058.01':'3460.190248',
	'8058.03':'3460.191468',
	'8101.02':'3680.190101',
	'8101.03':'3680.190111',
	'8101.04':'3680.190034',
	'8101.08':'3680.003801',
	'8101.10':'3680.190035',
	'8101.16':'3680.190049',
	'8101.20':'3700.001120',
	'8101.22':'3680.003901',
	'8101.24':'3672.003900',
	'8101.30':'3375.003802',
	'8108.02':'3599.190828',
	'8108.08':'3680.190988',
	'8151.02':'3702.000000',
	'8151.04':'3360.001307',
	'8151.06':'3658.001317',
	'8151.08':'3672.190011',
	'8151.10':'3680.190072',
	'8151.14':'3696.003814',
	'8151.16':'3696.190154',
	'8151.22':'3680.190222',
	'8151.24':'3680.190223',
	'8201.02':'3659.003844',
	'8201.04':'3659.190134',
	'8201.06':'3659.003845',
	'8201.08':'3659.190135',
	'8201.10':'3659.190136',
	'8201.12':'3830.000000',
	'8208.14':'3659.191078',
	'8208.16':'3659.191068',
	'8208.18':'3659.190458',
	'8251.04':'3692.190119',
	'8251.06':'3692.003551',
	'8251.10':'3692.190130',
	'8251.12':'3692.002102',
	'8257.02':'3692.003507',
	'8257.04':'3692.003504',
	'8257.06':'3692.003505',
	'8257.08':'3692.003506',
	'8257.10':'3692.003508',
	'8257.12':'3692.003509',
	'8257.14':'3692.190129',
	'8257.16':'3692.003503',
	'8257.18':'3692.003502',
	'8257.20':'3692.190131',
	'8257.22':'3692.190226',
	'8258.14':'3692.191028',
	'8259.10':'3692.191228',
	'8301.02':'3670.003005',
	'8308.02':'3670.190138',
	'8308.04':'3607.190798',
	'8311.06':'3684.000000',
	'8311.08':'3684.190076',
	'8311.10':'3684.003012',
	'8311.12':'3405.190006',
	'8321.10':'3654.001305',
	'8321.12':'3698.003002',
	'8331.02':'3656.190043',
	'8331.14':'3656.003801',
	'8331.16':'3654.003212',
	'8331.18':'3700.003601',
	'8331.19':'3700.190210',
	'8331.20':'3365.003208',
	'8331.24':'3365.190030',
	'8338.22':'3656.190758',
	'8338.24':'3656.190748',
	'8338.30':'3315.190328',
	'8351.02':'3654.190042',
	'8351.04':'3650.003206',
	'8351.06':'3654.190029',
	'8351.08':'3654.190013',
	'8351.10':'3650.190106',
	'8351.12':'3654.001213',
	'8351.14':'3654.190060',
	'8351.16':'3654.003505',
	'8351.18':'3654.190040',
	'8361.10':'3599.003901',
	'8361.12':'3670.190053',
	'8361.14':'3670.001310',
	'8361.16':'3654.003010',
	'8361.18':'3650.190225',
	'8371.20':'3805.000000',
	'8371.21':'3805.190216',
	'8371.22':'3805.190027',
	'8371.24':'3805.005303',
	'8371.26':'3805.190205',
	'8371.28':'3805.190202',
	'8371.30':'3805.190211',
	'8371.32':'3805.190212',
	'8371.34':'3805.190203',
	'8371.36':'3805.190227',
	'8411.02':'3662.003310',
	'8421.04':'3662.190063',
	'8421.06':'3305.000000',
	'8421.08':'3664.001216',
	'8431.08':'3340.003302',
	'8431.10':'3662.000000',
	'8431.12':'3662.003301',
	'8431.13':'3662.003308',
	'8441.14':'3425.000000',
	'8448.16':'3625.190058',
	'8448.18':'3640.191158',
	'8448.20':'3440.190788',
	'8448.21':'3440.191478',
	'8448.22':'3625.191258',
	'8451.02':'3345.000000',
	'8451.06':'3345.190002',
	'8451.08':'3345.190183',
	'8451.14':'3345.190099',
	'8451.16':'3345.190110',
	'8451.18':'3345.190116',
	'8461.16':'3674.003407',
	'8471.18':'3674.003401',
	'8501.02':'3200.002104',
	'8506.04':'3620.000000',
	'8506.06':'3620.003861',
	'8506.08':'3620.003871',
	'8511.08':'3696.190089',
	'8516.06':'3696.003811',
	'8521.10':'3760.000000',
	'8521.12':'3760.190019',
	'8521.14':'3760.190036',
	'8521.16':'3765.000000',
	'8528.06':'3750.191328',
	'8531.18':'3750.190073',
	'8531.22':'3755.190103',
	'8531.24':'3755.190102',
	'8537.20':'3755.003402',
	'8548.28':'3647.190268',
	'8558.02':'3980.190198',
	'8558.04':'3610.190048',
	'8558.06':'3610.190608',
	'8558.10':'3980.190278',
	'8591.02':'3405.191377',
	'8592.10':'3992.190184',
	'8598.02':'3405.191378',
	'8851.02':'3980.190087',
	'8851.06':'3980.190077',
	'8851.08':'3405.190113',
	'8858.02':'3700.190638',
	'8871.04':'3599.190101',
	'8881.01':'3805.190217',
	'8881.06':'3805.003701',
	'8881.07':'3805.190080',
	'8881.08':'4600.000000',
	'8881.18':'4900.000000',
	'8888.88':'3692.191018',
	'8891.12':'3850.190025',
	'8891.14':'3755.190214',
	'8951.03':'3405.190215',
	'8951.05':'3405.190064',
	'8951.06':'3405.190055',
	'8951.07':'3405.190065',
	'8951.08':'3405.190059',
	'8951.09':'3599.190229',
	'8951.10':'3405.190033',
	'8951.11':'3405.190054',
	'8951.13':'3599.190230',
	'8951.22':'3405.190051',
	'8951.23':'3405.190050',
	'8951.26':'3450.003111',
	'8951.28':'3405.190213',
	'8952.02':'3405.190100',
	'8969.02':'3405.190508',
	'8971.01':'3405.005306',
	'8971.02':'3405.003212',
	'8971.03':'3405.190185',
	'8971.04':'3406.190064',
	'8971.05':'3405.003211',
	'8971.06':'3405.190186',
	'8971.07':'3405.190204',
	'8980.00':'3450.000000',
	'8988.02':'3450.190498',
	'8988.04':'3450.190488',
	'8988.06':'3450.190478',
	'8988.08':'3450.190468',
	'8998.01':'3662.191488'
	};

var mapOraclePLAccountToVendorCode = 
{
'SM-00210105' : '29850',
'CORE-00207667' : '29851',
'CORE-00213225' : '29852',
'CORE-00213251' : '29852',
'CORE-00211667' : '29853',
'CORE-00214415' : '29854',
'EMG-00209584' : '29855',
'EMG-00209808' : '29856',
'EMG-00210326' : '29857',
'EMG-00210793' : '29858',
'EMG-00210635' : '29859',
'EMG-00211519' : '29860',
'EMG-00210759' : '29861',
'EMG-00206227' : '29862',
'EMG-00210798' : '29865',
'EMG-00206231' : '29866',
'EMG-00210444' : '29867',
'EMG-00210763' : '29869',
'EMG-00210743' : '29870',
'EMG-00214066' : '29871',
'EMG-00214337' : '29872',
'CORE-00213156' : '18011592',
'SM-00210105' : '29850',
'CORE-00207667' : '29851',
'CORE-00213225' : '29852',
'CORE-00213251' : '29852',
'CORE-00211667' : '29853',
'CORE-00214415' : '29854',
'EMG-00209584' : '29855',
'EMG-00209808' : '29856',
'EMG-00210326' : '29857',
'EMG-00210793' : '29858',
'EMG-00210635' : '29859',
'EMG-00211519' : '29860',
'EMG-00210759' : '29861',
'EMG-00206227' : '29862',
'EMG-00210798' : '29865',
'EMG-00206231' : '29866',
'EMG-00210444' : '29867',
'EMG-00210763' : '29869',
'EMG-00210743' : '29870',
'EMG-00214066' : '29871',
'EMG-00214337' : '29872',
'CORE-00213156' : '18011592'
}

var mapVendorCodes = 
{
'210105' : '29850',
'207667' : '29851',
'213225' : '29852',
'213251' : '29852',
'211667' : '29853',
'214415' : '29854',
'209584' : '29855',
'209808' : '29856',
'210326' : '29857',
'210793' : '29858',
'210635' : '29859',
'211519' : '29860',
'210759' : '29861',
'206227' : '29862',
'210798' : '29865',
'206231' : '29866',
'210444' : '29867',
'210763' : '29869',
'210743' : '29870',
'214066' : '29871',
'214337' : '29872',
'213156' : '18011592'
};

var mapJDEPLAccountsToOracle =
	{
'210105' : 'SM-00210105',
'207667' : 'CORE-00207667',
'213225' : 'CORE-00213225',
'213251' : 'CORE-00213251',
'211667' : 'CORE-00211667',
'214415' : 'CORE-00214415',
'209584' : 'EMG-00209584',
'209808' : 'EMG-00209808',
'210326' : 'EMG-00210326',
'210793' : 'EMG-00210793',
'210635' : 'EMG-00210635',
'211519' : 'EMG-00211519',
'210759' : 'EMG-00210759',
'206227' : 'EMG-00206227',
'210798' : 'EMG-00210798',
'206231' : 'EMG-00206231',
'210444' : 'EMG-00210444',
'210763' : 'EMG-00210763',
'210743' : 'EMG-00210743',
'214066' : 'EMG-00214066',
'214337' : 'EMG-00214337',
'213156' : 'CORE-00213156'
}
]]></msxsl:script>
</xsl:stylesheet>
