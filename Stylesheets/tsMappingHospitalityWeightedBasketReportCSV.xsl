<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Report into an CSV file

 © Alternative Business Solutions Ltd., 2009.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 23/10/2009 | RaveTech    | 3195. Created module.
******************************************************************************************
19/02/2010  | Steve Hewitt | 3195  Bug fix - display the header details as well
******************************************************************************************

******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:script="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:template match="/">

		<xsl:value-of select="script:msFormatForCSV(/Report/ReportName)"/><xsl:text> - </xsl:text><xsl:value-of select="script:msFormatDate(/Report/ReportDate)"/>
		<xsl:text>&#xD;</xsl:text>
		<xsl:text>&#xD;</xsl:text>
		
		<xsl:for-each select="/Report/HeaderDetails/HeaderDetail">		
			<xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(Value)"/>
			<xsl:text>&#xD;</xsl:text>
		</xsl:for-each>
		<xsl:text>&#xD;</xsl:text>
		
		<!--Header Details-->
		<xsl:text>Suppliers Product Code,Description,Pack Size,Now,Old,Change +/-,% Change,4 Week Volume,Old Spend,Weighted Change,</xsl:text>
			
		<!--Line Details-->
		<xsl:for-each select="/Report/LineDetails/LineDetail">			
			<xsl:text>&#xD;</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[1])"/>	<!--Suppliers Product Code-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[2])"/>	<!--Description-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[3])"/>	<!--Pack Size-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[4])"/>	<!--Now-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[5])"/>	<!--Old-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[6])"/>	<!--Change +/- -->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[7])"/>	<!--% Change-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[8])"/>	<!--4 Week Volume-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[9])"/>	<!--,Old Spend-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(Columns/Column[10])"/>	<!--Weighted Change-->
			<xsl:text>,</xsl:text>		
		</xsl:for-each>
			
		<xsl:text>&#xD;</xsl:text>
		<xsl:text>&#xD;</xsl:text>
		
		<xsl:for-each select="/Report/LineDetails/LineDetail">
			<!-- Lost spend on deletions -->
			<xsl:if test="Columns/Column[4] ='-'">				
				<xsl:value-of select="script:msadd(string(Columns/Column[8] * Columns/Column[5]),1)"></xsl:value-of>				
			</xsl:if>
			<!-- Changed spend on ongoing products -->
			<xsl:if test="Columns/Column[5] !='-' and Columns/Column[4] !='-'">				
				<xsl:value-of select="script:msadd(string(Columns/Column[8] * (Columns/Column[4] - Columns/Column[5])),2)"></xsl:value-of>				
			</xsl:if>
			<!-- % change on ongoing products -->
			<xsl:if test="Columns/Column[5] !='-' and Columns/Column[4] !='-'">				
				<xsl:value-of select="script:msadd(string(Columns/Column[8] * Columns/Column[5]),3)"></xsl:value-of>				
			</xsl:if>
		</xsl:for-each>
		
		<xsl:text>Lost spend on deletions,</xsl:text><xsl:value-of select="script:msGetTotal(1)"/>
		<xsl:text>&#xD;</xsl:text>
		<xsl:text>New products,</xsl:text><xsl:value-of select="0.00"/>
		<xsl:text>&#xD;</xsl:text>
		<xsl:text>Changed spend on ongoing products,</xsl:text><xsl:value-of select="script:msGetTotal(2)"/>
		<xsl:text>&#xD;</xsl:text>
		<xsl:text>% change on ongoing products,</xsl:text><xsl:value-of select="script:msGetTotal(3)"/>		
	</xsl:template>

	
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		var nTotal1= 0;
		var nTotal2= 0;
		var nTotal3= 0;
		function msadd(vsNumber,vlCase)	
		{
			switch(vlCase)
			{
				case 1:
				  	nTotal1 = parseFloat(nTotal1) + parseFloat(vsNumber);
				  	break;
				case 2:
				 	nTotal2 = parseFloat(nTotal2) + parseFloat(vsNumber);
				 	 break;
			 	 case 3:
			   		nTotal3 = parseFloat(nTotal3) + parseFloat(vsNumber);
			  		break;
				default:			 
			}
			
			return '' ;
		}

		function msGetTotal(vlCase)	
		{
			switch(vlCase)
				{
					case 1:
					  	return  Math.round(nTotal1 * 100)/100 ;
					  	break;
					case 2:
					 	return  Math.round(nTotal2 * 100)/100 ;
					 	 break;
				 	 case 3:
				 	 	if(nTotal3 == 0)
				 	 	{
				 	 		return  0 ;
				 	 	}
				 	 	else
				 	 	{
				   			return  Math.round((nTotal2 / nTotal3 * 100) * 100)/100 ;
				   		}
				  		break;
					default:			 
				}			
		}
		
		/*=========================================================================================
		' Routine       	 : msFormatForCSV
		' Description 	 : Formats the string for a csv file
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatForCSV(vsString)
		{
			if(vsString.length > 0)
			{
				vsString = vsString(0).text;
			}
			
			while(vsString.indexOf('"') != -1)
			{
				vsString = vsString.replace('"','¬');
			}
			while(vsString.indexOf('¬') != -1)
			{
				vsString = vsString.replace('¬','""');
			}
			
			if(vsString.indexOf('"') != -1 || vsString.indexOf(',') != -1)
			{
				vsString = '"' + vsString + '"';
			}
			
			return vsString;
				
		}
		/*=========================================================================================
		' Routine       	 : msFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in mm/dd/yyyy format
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatDate(vsDate)
		{
		
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(0,4);
			}
			else
			{
				return '';
			}
				
		}
		
	]]></msxsl:script>
</xsl:stylesheet>