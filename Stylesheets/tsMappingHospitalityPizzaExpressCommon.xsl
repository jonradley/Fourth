<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview

Pizza Express UK inbound mapper to split the report by currency to prepare it for export
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date				| Name				| Description of modification
==========================================================================================
 14/04/2016	| Jose Miguel	| FB10911 - Refactor
==========================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
	// While we do not have the CompanyCode implemented in R9 any new sites will be translated from the SiteCode
	var mapSiteCodeToCompanyCode =
	{
		'5010':'00020',
		'5020':'00020',
		'5210':'00012',
		'5212':'00012',
		'5215':'00012',
		'6001':'00018',
		'6536':'00011'
	};

	// This translates the site code to the company code which will be used in column VNKCO.
	// If the value is not translated the original value unmapped is returned so we know which one caused it.
	function getSiteCodeToCompanyCode (strSiteCode)
	{
		var strCompanyCode = mapSiteCodeToCompanyCode[strSiteCode];
		
		if (strCompanyCode == null)
		{
			strCompanyCode = '00010';
		}
		return strCompanyCode;
	}
	]]></msxsl:script>	
</xsl:stylesheet>
