
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl msxsl"  xmlns:vbscript="http://abs-Ltd.com">
<!--
==========================================================================================================

																	The lookup table.

==========================================================================================================
-->


<!--
===========================================================================================================
USE:
		cross reference table for Nippon DE as they are only able to return the ILN of the delivery
		location. 
		This document aviods changes to the mapper if more delivery locations are added by Nippon.
		
STRUCTURE:

	<table>							'	"Recordset" table
		<record> 					' 	Table row
			<ANA/>					'	ILN/ANA delivery location code being used to detect buyer.
			<Flag/>					'	This is used to set '1' as true/found. A return from the lookup function below of 
										'	'0' means not found.
			<Description/>		'	A plain text to describe the record entry.
		</record>
	</table>
	
AUTHOR:

	Nigel Emsen, 2nd July 2007.
		
==========================================================================================================
-->

<xsl:variable name="LookupTable">

	<table>
	
		<!-- SSP -->
		<record>
			<ANA>5013546085276</ANA>
			<Flag>1</Flag>
			<Description>SSP</Description>
		</record>

	</table>

</xsl:variable>


<!--
==========================================================================================================

											Functions to extract data from the lookup table.

==========================================================================================================
-->

	<xsl:template name="msDetectBuyersANA">
		<xsl:param name="sANA" select="sANA"/>
		<xsl:variable name="sFlag" select="msxsl:node-set($LookupTable)/table/record[ANA=$sANA]/Flag"/>
		<xsl:choose>
			<!-- True, found passed GLN. -->
			<xsl:when test="$sFlag ='1' ">
				<xsl:value-of select="$sRef"/>
			</xsl:when>
			<!-- False, not found passed GLN. -->
			<xsl:otherwise>
				<xsl:text>0</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



</xsl:stylesheet>
