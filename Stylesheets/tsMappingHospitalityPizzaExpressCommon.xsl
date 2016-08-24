<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview

Pizza Express UK common script, which holds the Company Code translation logic.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date				| Name				| Description of modification
==========================================================================================
 14/04/2016	| Jose Miguel	| FB10911 - Refactor
==========================================================================================
 24/08/2016	| Jose Miguel	| FB11269 - Adding new sites
==========================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
	// While we do not have the CompanyCode implemented in R9 any new sites will be translated from the SiteCode
	var mapSiteCodeToCompanyCode =
	{
	'4010':'00081',
	'4011':'00081',
	'4012':'00081',
	'4013':'00081',
	'4014':'00081',
	'4015':'00081',
	'4016':'00081',
	'4017':'00081',
	'4018':'00081',
	'4019':'00081',
	'4020':'00081',
	'4021':'00081',
	'4022':'00081',
	'4023':'00081',
	'4024':'00081',
	'4025':'00081',
	'4026':'00081',
	'4027':'00081',
	'4028':'00081',
	'4029':'00081',
	'4030':'00081',
	'4031':'00081',
	'4032':'00081',
	'4033':'00081',
	'4034':'00081',
	'4035':'00081',
	'5010':'00020',
	'5020':'00020',
	'5110':'00025',
	'5112':'00025',
	'5120':'00025',
	'5130':'00025',
	'5140':'00025',
	'5160':'00025',
	'5170':'00025',
	'5180':'00025',
	'5190':'00025',
	'5191':'00025',
	'5192':'00025',
	'5193':'00025',
	'5194':'00025',
	'5196':'00025',
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
