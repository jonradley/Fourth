
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl msxsl"  xmlns:vbscript="http://abs-Ltd.com">
<!--
==========================================================================================================

																	The lookup table.

==========================================================================================================
-->


<!--
===========================================================================================================
USE:
		cross reference table for MJ Seafoods PL Accounts. Stores string constants that appear in CDT(2), that
		denotes NOT a PL Account user. 
		This document avoids changes to the mapper if more delivery locations are added by Nippon.
		
STRUCTURE:

	<table>							'	"Recordset" table
		<record> 					' 	Table row
			<value/>				'	Stores the value found in CDT(2)
			<Description/>		'	A plain text to describe the record entry.
			<boolean/>			'	Store the return value of 'TRUE'
		</record>
	</table>
	
AUTHOR:

	Nigel Emsen, 3rd October 2006.
	
	recomit 06/10/2006 - Case: 434
		
==========================================================================================================
-->

<xsl:variable name="LookupTable">
	<!-- root element -->
	<table>
		<!-- Rows/Records -->
		<record>
			<value>NOVUS LEISURE</value>
			<Description>Novus Leisure.</Description>
			<boolean>NOT</boolean>
		</record>
		<record>
			<value>HARRSC</value>
			<Description>HARRISON CATERING SCHOOLS.</Description>
			<boolean>NOT</boolean>
		</record>
		
	</table>
	<!-- end of table -->
</xsl:variable>

<!--
==========================================================================================================

											Functions to extract data from the lookup table.

==========================================================================================================
-->

	<!-- 
		=======================================================
		
		Template to interpet lookup file.
		
		Returns boolean field of record by matching <value/>
		
		=======================================================
	-->
	<xsl:template name="msIsPLAccount">
		<xsl:param name="sValue" select="sValue"/>
		<xsl:value-of select="msxsl:node-set($LookupTable)/table/record[value=$sValue]/boolean"/>
	</xsl:template>
	
<!-- end of stylesheet -->
</xsl:stylesheet>
