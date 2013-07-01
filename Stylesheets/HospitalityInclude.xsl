<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
S Hussain		|	2013-05-14	| FB6588: Added more functionality common across customers.
**********************************************************************
S Hussain		|	2013-06-24	| FB6690: Added msGetCurrentTime(), msEscapeQuotes() Functions.
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<!--Generic Data Formatting Templates-->
	<!--Format YYYYMMDD as YYYY-MM-DD -->
	<xsl:template name="fixDate">
		<xsl:param name="sDate"/>
		<xsl:value-of select="concat(substring($sDate,1,4),'-',substring($sDate,5,2),'-',substring($sDate,7,2))"/>
	</xsl:template>
	
	<!--Format YYMMDD as YYYY-MM-DD -->
	<xsl:template name="fixDateYY">
		<xsl:param name="sDate"/>
		<xsl:value-of select="concat('20',substring($sDate,1,2),'-',substring($sDate,3,2),'-',substring($sDate,5,2))"/>
	</xsl:template>
	
	<!--Format DDMMYYYY as YYYY-MM-DD -->
	<xsl:template name="fixDateDMY">
		<xsl:param name="sDate"/>
		<xsl:value-of select="concat(substring($sDate,7,4),'-',substring($sDate,4,2),'-',substring($sDate,1,2))"/>
	</xsl:template>
	
	<!--Format HHMM to HH:MM -->
	<xsl:template name="fixTime">
		<xsl:param name="sTime"/>
		<xsl:value-of select="concat(substring($sTime,1,2), ':', substring($sTime,3, 2))"/>
	</xsl:template>
	
	<xsl:template name="TranslateAccentedCharacters">
		<xsl:param name="InputString"/>
		<xsl:value-of select="translate($InputString,'áàâäéèêëíìîïóòôöúùûüÁÀÂÄÉÈÊËÍÌÎÏÓÒÔÖÚÙÛÜ','aaaaeeeeiiiioooouuuuAAAAEEEEIIIIOOOOUUUU')"></xsl:value-of>
	</xsl:template>
	
<msxsl:script language="JScript" implements-prefix="user"><![CDATA[ 
/*=========================================================================================
' Routine       	 : gsGetRowClass
' Description 	 : Gets listrow 0,1,0 etc.
' Inputs          	 : None
' Outputs       	 : None
' Returns       	 : Class of row
' Author       		 : A Sheppard, 23/02/2004.
' Alterations   	 : 
'========================================================================================*/
var msPreviousRowClass = 'listrow0';
function gsGetRowClass()
{
	if(msPreviousRowClass == 'listrow1')
	{
		msPreviousRowClass = 'listrow0';
	}
	else
	{
		msPreviousRowClass = 'listrow1';
	}
	return msPreviousRowClass;
}

var msPreviousRef1 = '';
var msPreviousRef2 = '';
/*=========================================================================================
' Routine       	 : gbIsNewRefPair
' Description 	 : Returns true if this a new ref pair - false otherwise
' Inputs          	 : None
' Outputs       	 : None
' Returns       	 : True/False
' Author       		 : A Sheppard, 22/09/2004.
' Alterations   	 : 
'========================================================================================*/
function gbIsNewRefPair(vsRef1, vsRef2)
{
var sCurrentRef1 = '';
var sCurrentRef2 = '';
	
	if(vsRef1.length > 0)
	{
		sCurrentRef1 = vsRef1(0).text;
	}
	else
	{
		sCurrentRef1 = 'UNKNOWN';
	}
	
	if(vsRef2.length > 0)
	{
		sCurrentRef2 = vsRef2(0).text;
	}
	else
	{
		sCurrentRef2 = 'UNKNOWN';
	}
	
	if(sCurrentRef1 == msPreviousRef1 && sCurrentRef2 == msPreviousRef2)
	{
		return false;
	}
	else
	{
		msPreviousRef1 = sCurrentRef1;
		msPreviousRef2 = sCurrentRef2;
		return true;
	}
}

/*=========================================================================================
' Routine       	 : glGetRowNumber
' Description 	 : Gets next row number.
' Inputs          	 : None
' Outputs       	 : None
' Returns       	 : Row number
' Author       		 : A Sheppard, 23/02/2004.
' Alterations   	 : 
'========================================================================================*/
var mlPreviousRowNo = 0;
function glGetRowNumber()
{
	mlPreviousRowNo = mlPreviousRowNo + 1;
	return mlPreviousRowNo;
}

/*=========================================================================================
' Routine       	 : gStoreTotal and gdGetTotal
' Description 	 : Adds up the totals (only use if sum(LineValueExclVAT) or the like is insufficient)
' Inputs          	 : Line Value
' Outputs       	 : None
' Returns       	 : Total
' Author       		 : A Sheppard, 16/02/2005.
' Alterations   	 : 
'========================================================================================*/
var mdTotal = 0;
function gStoreTotal(vdTotal)
{
	mdTotal += parseFloat(vdTotal);
	return '';
}
function gdGetTotal()
{
	return mdTotal;
}

/*=========================================================================================
' Routine       	 : gsGetCurrencySymbol
' Description 	 : Gets the relevant currency symbol given a 3 digit code.
' Inputs          	 : 3 digit code representing the currency in the form of an xml node
' Outputs       	 : None
' Returns       	 : The currency symbol
' Author       		 : A Sheppard, 08/05/2002
' Alterations   	 : 
'========================================================================================*/
function gsGetCurrencySymbol(vsCurrencyCode)
{
	var sCurrencySymbol;
	if(vsCurrencyCode.length > 0)
	{
		switch (vsCurrencyCode(0).text)
		{
			case 'GBP':
				sCurrencySymbol='£';
				break;
			case 'EUR':
				sCurrencySymbol='€';
				break;
			default:
				sCurrencySymbol='£';
		}
	}
	else
	{
		sCurrencySymbol='£';
	}
	return sCurrencySymbol;
}

/*=========================================================================================
' Routine       	 : gsFormatCurrency (copied from SPEx code base)
' Description 	 : Formats the date
' Inputs          	 : Number in #,###.00 format
' Outputs       	 : None
' Returns       	 : Number in #,###.00 format
' Author       		 : A Sheppard, 09/06/2003
' Alterations   	 : 
'========================================================================================*/
function gsFormatCurrency(vsNumber, vlDPs, vbUseCommas)
{
	if(vsNumber.length > 0)
	{
		vsNumber = vsNumber(0).text;
		vsNumber = (Math.round(parseFloat(vsNumber) * Math.pow(10,vlDPs))/Math.pow(10,vlDPs)).toString();
		if(vlDPs > 0)
		{
			if(vsNumber.indexOf('.') == -1)
			{
				vsNumber += '.';
			}
			while(vsNumber.indexOf('.') > (vsNumber.length - vlDPs - 1))
			{
				vsNumber += '0';
			}
		}
		if(vbUseCommas)
		{
			var lPosition = vsNumber.indexOf('.');
			while(lPosition > 3)
			{
				lPosition -= 3;
				vsNumber = vsNumber.substr(0, lPosition) + ',' + vsNumber.substr(lPosition, vsNumber.length);
			}
		}
		return vsNumber;
	}
	else
	{
		return '';
	}
}

/*=========================================================================================
' Routine       	 : gsGetRowClass
' Description 	 : Gets listrow 0,1,0 etc.
' Inputs          	 : None
' Outputs       	 : None
' Returns       	 : Class of row
' Author       		 : A Sheppard, 23/02/2004.
' Alterations   	 : 
'========================================================================================*/
var msPreviousRowClass = 'listrow0';
function gsGetRowClass()
{
	if(msPreviousRowClass == 'listrow1')
	{
		msPreviousRowClass = 'listrow0';
	}
	else
	{
		msPreviousRowClass = 'listrow1';
	}
	return msPreviousRowClass;
}

/*=========================================================================================
' Routine       	 : glGetRowNumber
' Description 	 : Gets next row number.
' Inputs          	 : None
' Outputs       	 : None
' Returns       	 : Row number
' Author       		 : A Sheppard, 23/02/2004.
' Alterations   	 : 
'========================================================================================*/
var mlPreviousRowNo = 0;
function glGetRowNumber()
{
	mlPreviousRowNo = mlPreviousRowNo + 1;
	return mlPreviousRowNo;
}

/*=========================================================================================
' Routine       	 : gsFormatFixedWidth
' Description 	 : Formats the string to a fixed width
' Inputs          	 : String
' Outputs       	 : None
' Returns       	 : String of the correct length
' Author       		 : A Sheppard, 07/01/2008
' Alterations   	 : 
'========================================================================================*/
function gsFormatFixedWidth(vsString, vlLength)
{
	var vTest = vsString + ' ';
	if(vTest == null)
	{
		if(vsString.length > 0)
		{
			vsString = vsString(0).text;
		}
		else
		{
			vsString = ''
		}
	}
	if(vsString.length > vlLength)
	{
		vsString = vsString.substr(0,vlLength);
	}
	else
	{
		while(vsString.length < vlLength)
		{
			vsString = vsString + ' ';
		}
	}
	return vsString;
}

/*=========================================================================================
' Routine       	 : gsGetTodaysDate
' Description 	 : Gets todays date, correctly formatted
' Inputs          	 : None
' Outputs       	 : None
' Returns       	 : Class of row
' Author       		 : A Sheppard, 27/02/2004.
' Alterations   	 : 
'========================================================================================*/
function gsGetTodaysDate()
{
var dtDate = new Date();

	return dtDate.getDate() + '/' + (dtDate.getMonth() + 1) + '/' + dtDate.getYear();
}

/*=========================================================================================
' Routine       	 : gsFormatDate
' Description 	 : Formats the date and time
' Inputs          	 : Date in yyyy-mm-dd format, or a Date Time in yyyy-mm-ddThh:nn:ss
' Outputs       	 : None
' Returns       	 : Date in dd/mm/yyyy format, or Date Time in dd/mm/yyyy hh:nn:ss format
' Author       		 : A Sheppard, 09/06/2003
' Alterations   	 : Lee Boyton, 04/11/2004. Added ability to format the time if present too.
' Alterations   	 : 
'========================================================================================*/
function gsFormatDate(vsDate)
{
	if(vsDate.length > 0)
	{
		vsDate = vsDate(0).text;
		if(vsDate.indexOf('T') == -1)
			return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(0,4);
		else
			return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(0,4) + ' ' + vsDate.substr(11);
	}
	else
	{
		return '';
	}
}

/*=========================================================================================
' Routine       	 : msGetTodaysDate
' Description 	 : Gets todays date, formatted to yyyy-mm-dd
' Inputs          	 : None
' Outputs       	 : None
' Returns       	 : Class of row
' Author        : Rave Tech, 26/11/2008
' Alterations   	 : 
'========================================================================================*/
function msGetTodaysDate()
{
	var dtDate = new Date();
	var sDate = dtDate.getDate();
	if(sDate<10)
	{
		sDate = '0' + sDate;
	}
	var sMonth = dtDate.getMonth() + 1;
	if(sMonth<10)
	{
		sMonth = '0' + sMonth;
	}
	var sYear  = dtDate.getYear() ;
	return sYear + '-'+ sMonth +'-'+ sDate;
}

/*=========================================================================================
' Routine       	 : toUpperCase
' Description  : Converts Characters within the Input String to UpperCase
'========================================================================================*/
function toUpperCase(vs) {
	return vs.toUpperCase();
}

/*=========================================================================================
' Routine       	 : msGetCurrentTime
' Description 	 	 : Gets current time, formatted as HHMMSS
' Inputs          	 : None
' Outputs       	 : Current Time in HHMMSS Format
' Alterations   	 : 
'========================================================================================*/
function msGetCurrentTime()
{
	var dtDate = new Date();
	var sHours = dtDate.getHours();
	var sMins = dtDate.getMinutes();
	var sSecs = dtDate.getSeconds();
	
	return sHours +""+ sMins +""+ sSecs;
}

/*=========================================================================================
' Routine       	 : msEscapeQuotes
' Description 	 	 : Escapes Quotes within a String
'========================================================================================*/
function msEscapeQuotes(input) {
	return input.replace("\"\"", "\"\"\"\"");
}
	]]></msxsl:script>
</xsl:stylesheet>
