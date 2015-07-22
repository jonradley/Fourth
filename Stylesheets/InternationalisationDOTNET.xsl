<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 $Header: /trunk/Stylesheets/Internationalisation.xsl   
 Overview

 This XSL file provides come common routines for translating and formatting the report contents 

 © Fourth Hospitality., 2012.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name          | Description of modification
 ******************************************************************************************
 13/08/2012 | S Sehgal      | FB 5618Escape double quotes within a column
******************************************************************************************
 24/10/2014 | Graham Neicho | FB10061. Added version of msFormatForCSV to optionally force qualifiers
******************************************************************************************
 10/07/2015 | Jose Miguel | FB10304 - HOTUSA - add translations for reports
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">

<xsl:variable name="TranslationsXML" select="document(concat($RootFolderPath,'/',$LocaleID,'/',$TranslationFile))/listoftext"/>

<xsl:template name="TranslateString">
    <xsl:param name="ID"/>
    <xsl:variable name="InternalID"><xsl:value-of select="concat('msg',format-number($ID,'0000'))"/></xsl:variable>
    <xsl:variable name="TranslatedString"><xsl:value-of select="$TranslationsXML/text[@id = $InternalID]/translation"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="$TranslatedString"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$InternalID"/><xsl:text> is missing</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="TranslateStringWith1Parameter">
    <xsl:param name="ID"/>
    <xsl:param name="Parameter"/>
    <xsl:variable name="InternalID"><xsl:value-of select="concat('msg',format-number($ID,'0000'))"/></xsl:variable>
    <xsl:variable name="TranslatedString"><xsl:value-of select="$TranslationsXML/text[@id = $InternalID]/translation"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{0}')"/><xsl:value-of select="$Parameter"/><xsl:value-of select="substring-after($TranslatedString, '{0}')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$InternalID"/><xsl:text> is missing</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="TranslateStringWith2Parameters">
    <xsl:param name="ID"/>
    <xsl:param name="Parameter0"/>
    <xsl:param name="Parameter1"/>
    <xsl:variable name="InternalID"><xsl:value-of select="concat('msg',format-number($ID,'0000'))"/></xsl:variable>
    <xsl:variable name="TranslatedString"><xsl:value-of select="$TranslationsXML/text[@id = $InternalID]/translation"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{1}')"/><xsl:value-of select="$Parameter1"/><xsl:value-of select="substring-after($TranslatedString, '{1}')"/></xsl:when>
      <xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{0}')"/><xsl:value-of select="$Parameter0"/><xsl:value-of select="substring-after($TranslatedString, '{0}')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$InternalID"/><xsl:text> is missing</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="TranslateStringWith3Parameters">
    <xsl:param name="ID"/>
    <xsl:param name="Parameter0"/>
    <xsl:param name="Parameter1"/>
    <xsl:param name="Parameter2"/>		
    <xsl:variable name="InternalID"><xsl:value-of select="concat('msg',format-number($ID,'0000'))"/></xsl:variable>
    <xsl:variable name="TranslatedString"><xsl:value-of select="$TranslationsXML/text[@id = $InternalID]/translation"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{2}')"/><xsl:value-of select="$Parameter2"/><xsl:value-of select="substring-after($TranslatedString, '{2}')"/></xsl:when>
      <xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{1}')"/><xsl:value-of select="$Parameter1"/><xsl:value-of select="substring-after($TranslatedString, '{1}')"/></xsl:when>			
      <xsl:when test="string-length($TranslatedString) > 0"><xsl:value-of select="substring-before($TranslatedString, '{0}')"/><xsl:value-of select="$Parameter0"/><xsl:value-of select="substring-after($TranslatedString, '{0}')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$InternalID"/><xsl:text> is missing</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
<msxsl:script xmlns:msxsl="urn:schemas-microsoft-com:xslt" language="C#"  implements-prefix="user">

<![CDATA[  
    /*'=========================================================================================
    ' Routine       	  : gsFormatDateByLocale
    ' Description 	    : Formats the date
    ' Inputs          	: Date node in yyyy-mm-dd format
    '	                    LocaleIID
    ' Outputs       	  : None
    ' Returns       	  : Date in correct format
    ' Author       		  : A Sheppard, 09/06/2003
    ' Alterations   	  : S Sehgal, 13/04/2011. 4272 Converted to c#
    '==========================================================================================*/
    public string gsFormatDateByLocale(string vobjDateNode, int vsLocaleID)
    {
      if (vobjDateNode != "")
      {
        DateTime dt = new DateTime(int.Parse(vobjDateNode.Substring(0, 4)), int.Parse(vobjDateNode.Substring(5, 2)), int.Parse(vobjDateNode.Substring(8, 2)));
        global::System.Globalization.CultureInfo ci = null;
        ci = new global::System.Globalization.CultureInfo(vsLocaleID);
        global::System.Threading.Thread.CurrentThread.CurrentCulture = ci;

        return dt.ToString("d");
      }
      else 
      {
        return "";
      }
    }
    
    /*'=========================================================================================
    ' Routine       	  : msFormatForCSV
    ' Description 	    : Formats the string for a csv file
    ' Inputs          	: String
    ' Outputs       	  : None
    ' Returns       	  : String
    ' Author            : 
    ' Alterations   	  : S Sehgal, 13/04/2011. 4272 Converted to c#
    ' Alterations   	  : S Sehgal, 13/04/2011. 5618 Escape Double Quotes(")
    ' Alterations   	  : J Miguel, 10/07/2015. 10304 When there are commas, only add double-quotes if not already there
   '========================================================================================*/
    public string msFormatForCSV(string vsString)
    {
         
       if(vsString.IndexOf("\"")>0)
      {
        vsString= "\""  +  vsString.Replace("\"", "\"\"") +  "\"";
      }
	  else
      if(vsString.IndexOf(",")>0)
      {
        vsString= "\""  +  vsString +  "\"";
      }


      return vsString;

    }

    /*'=========================================================================================
    ' Routine     : msFormatForCSVWithQualifiers
    ' Description : Formats the string for a csv file allowing an insurance that it is qualified by double quotes
    '						Would be so much easier (but not possible) to pass an optional parameter into the original method
    ' Inputs      : String
    ' Outputs     : None
    ' Returns     : String
    ' Author      : Graham Neicho, 24/10/2014. FB10061. Copy of the (fixed) method above, plus optional force of qualifiers
    '========================================================================================*/
    public string msFormatForCSVWithQualifiers(string vsString, bool vbForceQualifiers)
    {
      if (vsString.Contains("\""))
      {
        vsString = vsString.Replace("\"", "\"\"");
        vbForceQualifiers = true;
      }

      if (vbForceQualifiers || vsString.Contains(","))
      {
        vsString = "\"" + vsString + "\"";
      }

      return vsString;
    }
 
    /*'=========================================================================================
    ' Routine       	 : mbNeedHeader
    ' Description 	 : Determines whether a new header row is required
    ' Inputs          	 : None
    ' Outputs       	 : None
    ' Returns       	 : Class of row
    ' Author       	 : A Sheppard, 23/08/2004
    ' Alterations   	 :  S Sehgal, 24/04/2010. FB 3536 Converted to VB script
    ' Alterations   	 :  S Sehgal, 13/04/2011. FB 4272 Converted to c#t
    '========================================================================================*/
    
 
    public string msPreviousGroupingValues= "-"  ;
    
    public  bool mbNeedHeader(string vcolGroupingValues)
    {
      string sCurrentGroupingValues ;
      sCurrentGroupingValues = "";

      sCurrentGroupingValues = sCurrentGroupingValues + vcolGroupingValues + "¬";

      if (sCurrentGroupingValues != msPreviousGroupingValues)
      {
        msPreviousGroupingValues = sCurrentGroupingValues;
        return  true;            
      }
      else
      {
        return false;
      }
    }
    /*'=========================================================================================
    ' Routine           : gsFormatNumberByLocale
    ' Description       : Formats a number to a maximum number of decimal places, but does not
    '                     add additional zeros if not required.
    '                     E.g. 4.5 is left as 4.5 rather than 4.5000, but 4.56789 becomes 4.5679.
    ' Inputs            : Number node
    '                     Maximum number of decimal places
    '                     Locale ID
    '			                vbkeepTrailingZeros - do you want to keep trailing zeros (looks nicer on prices for example) but only keeps the max from vlMaxDPS
    ' Outputs       	  : None
    ' Returns       	  : Formatted Number
    ' Author       	    : 
    ' Alterations   	  : S Sehgal, 13/04/2011. 4272 Converted to c#
    '=========================================================================================*/

    public string gsFormatNumberByLocale(string strNumber,int vlMaxDPs,  int vLocaleID, bool vbkeepTrailingZeros)
    {

      global::System.Globalization.CultureInfo ciOrig = null;
      ciOrig = new global::System.Globalization.CultureInfo(2057);
      global::System.Threading.Thread.CurrentThread.CurrentCulture = ciOrig;

      string sOut = strNumber;          
      double dPrice = Convert.ToDouble(strNumber);
      string sCurrentCulture = "";
      string currentDecimalSeparator="";

      global::System.Globalization.CultureInfo ci = null;
      sCurrentCulture = vLocaleID.ToString();
      
      ci = new global::System.Globalization.CultureInfo(vLocaleID);

      string sFormat="#.";
      string sTrailingDecimalCharacters = "";

      for(int i=1;i<=vlMaxDPs;i++)
      {
        sFormat = sFormat + "#";
        sTrailingDecimalCharacters = sTrailingDecimalCharacters + "0";
      }

      global::System.Threading.Thread.CurrentThread.CurrentCulture = ci;
      sOut = dPrice.ToString(sFormat);
      currentDecimalSeparator = ci.NumberFormat.CurrencyDecimalSeparator;

      if (sOut == "")
      {
        sOut = "0" + currentDecimalSeparator  + sTrailingDecimalCharacters;
      }
      else
      {
        if(sOut.IndexOf(currentDecimalSeparator) == -1)
        {
          sOut = sOut + currentDecimalSeparator + sTrailingDecimalCharacters;
        }
        else 
        {
          if (sOut.Substring(0,sOut.IndexOf(currentDecimalSeparator)).Length < 1)
          {
            sOut = "0" + sOut;
          }
        }
      }

      return sOut;

    }

    /*'=========================================================================================
    ' Routine       	  : gsFormatCurrencyByLocale
    ' Description 	    : Formats the number into a 2dp number in the correct format
    ' Inputs          	: Number node in ####.## format
    '				              Number of decimal places
    '				              Locale ID
    ' Outputs       	 : None
    ' Returns       	 : Number in #,###.00 format
    ' Author       		 : 
    ' Alterations   	 : S Sehgal, 13/04/2011. 4272 Converted to c#
    '=========================================================================================*/
    public string gsFormatCurrencyByLocale(string strNumber,int vlMaxDPs,  int vLocaleID)
    {

      global::System.Globalization.CultureInfo ciOrig = null;
      ciOrig = new global::System.Globalization.CultureInfo(2057);
      global::System.Threading.Thread.CurrentThread.CurrentCulture = ciOrig;
          
      string sOut = strNumber;
      double dPrice = Convert.ToDouble(strNumber);
      string sCurrentCulture = "";
      string currentDecimalSeparator="";

      global::System.Globalization.CultureInfo ci = null;
      sCurrentCulture = vLocaleID.ToString();

      ci = new global::System.Globalization.CultureInfo(vLocaleID);

      string sFormat="#.";
      string sTrailingDecimalCharacters = "";

      for(int i=1;i<=vlMaxDPs;i++)
      {
        sFormat = sFormat + "#";
        sTrailingDecimalCharacters = sTrailingDecimalCharacters + "0";
      }

      sOut = dPrice.ToString(sFormat);
      currentDecimalSeparator = ci.NumberFormat.CurrencyDecimalSeparator;

      if (sOut == "")
      {
        sOut = "0" + currentDecimalSeparator  + sTrailingDecimalCharacters;
      }
      else
      {
        if(sOut.IndexOf(currentDecimalSeparator) == -1)
        {
          sOut = sOut + currentDecimalSeparator + sTrailingDecimalCharacters;
        }
        else 
        {
          if (sOut.Substring(0,sOut.IndexOf(currentDecimalSeparator)).Length < 1)
          {
            sOut = "0" + sOut;
          }
        }
      }
  
      global::System.Globalization.RegionInfo ri = null;
      ri = new global::System.Globalization.RegionInfo(vLocaleID);
      sOut = ri.CurrencySymbol + sOut;
      return sOut;
    }

    /*=========================================================================================
    ' Routine       	  : gsGetTodaysDateByLocale
    ' Description 	    : Gets todays date, correctly formatted
    ' Inputs            : Locale ID
    ' Outputs       	  : None
    ' Returns       	  : Class of row
    ' Author       		  : 
    ' Alterations   	  : S Sehgal, 13/04/2011. 4272 Converted to c#
    '=========================================================================================*/
    public string gsGetTodaysDateByLocale(int vsLocaleID)	  
    {
      DateTime dt  =DateTime.Now;
      global::System.Globalization.CultureInfo ci = null;
      ci = new global::System.Globalization.CultureInfo(vsLocaleID);
      global::System.Threading.Thread.CurrentThread.CurrentCulture = ci;

      return dt.ToString("d");       
    }


]]>
</msxsl:script>


  

</xsl:stylesheet>
