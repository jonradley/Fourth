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
-->
	<data:table>
	<data:record>
			<data:ANA>5013546200266</data:ANA>
			<data:ReturnValue>1</data:ReturnValue>
			<data:Description>Compass's GLN number.</data:Description>
		</data:record>
		<data:record>
			<data:ANA>5013546085276</data:ANA>
			<data:ReturnValue>1</data:ReturnValue>
			<data:Description>Compass's GLN number.</data:Description>
		</data:record>
		<data:record>
			<data:ANA>5027615900022</data:ANA>
			<data:ReturnValue>1</data:ReturnValue>
			<data:Description>SSP and MOTO GLN number provided by Makella for staging testing.</data:Description>
		</data:record>
	</data:table>	

<!-- ========== Function to check for presence in data:table of a given ANA passed ======================== -->
	<xsl:template name="msDetectBuyersANA" match="/" >
		<xsl:param name="sANA"/>
		<xsl:value-of select="document('')/*/data:table/data:record[normalize-space(data:ANA)=normalize-space($sANA)]/data:ReturnValue"/>
	</xsl:template>
	
</xsl:stylesheet>
