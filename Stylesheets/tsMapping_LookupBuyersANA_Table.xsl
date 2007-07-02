<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl msxsl" xmlns:vbscript="http://abs-Ltd.com">
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
			<record>
				<ANA>5013546085276</ANA>
				<ReturnValue>1</ReturnValue>
				<Description>Compass's GLN number.</Description>
			</record>
		</table>
	</xsl:variable>
	
	<!--
==========================================================================================================

											Functions to extract data from the lookup table.

==========================================================================================================
-->
	<xsl:template name="msDetectBuyersANA" >
		<xsl:param name="sANA" select="sANA"/>
		<xsl:for-each select="msxsl:node-set($LookupTable)/table/record">
			<xsl:variable name="sCurValue" select="ANA"/>
				<xsl:if test="contains($sANA,$sCurValue)">
					<xsl:value-of select="ReturnValue"/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
