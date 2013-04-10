<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl msxsl" xmlns:vbscript="http://abs-Ltd.com" xmlns:data="blah">
	<!--
==========================================================================================================

																	The lookup table.

==========================================================================================================
-->
	<!--
===========================================================================================================
USE: 
		This document aviods changes to the mapper if more delivery locations are added by Buyer.
		
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
 Date      	| Name 					| Description of modification
==========================================================================================================
 14/03/2013	| H Robson				| 6261 Remove SSP staging and Live IDs (deactivate bespoke functionality that was previously coded) 
-->
	<data:table>
		<data:record>
			<data:ANA>5013546085276</data:ANA>
			<data:ReturnValue>1</data:ReturnValue>
			<data:Description>Compass's GLN number.</data:Description>
		</data:record>
	</data:table>	

<!-- ========== Function to check for presence in data:table of a given ANA passed ======================== -->
	<xsl:template name="msDetectBuyersANA" match="/" >
		<xsl:param name="sANA"/>
		<xsl:value-of select="document('')/*/data:table/data:record[normalize-space(data:ANA)=normalize-space($sANA)]/data:ReturnValue"/>
	</xsl:template>
	
</xsl:stylesheet>
