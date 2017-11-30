<?xml version="1.0" encoding="UTF-8"?>
<!--
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name		: tsValidateHospitalityProofOfDelivery.xsl
Description	: Validates hospitality proof of Delivery.
Author		: A Sheppard
Date		: 29/09/2011 Ported from tsValidateHospitalityDeliveryNote.xsl
Alterations	: 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->
<xsl:stylesheet version="1.0" 
			     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			     xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output encoding="UTF-8"/>
	<xsl:template match="/">
		<xsl:element name="ValidationErrors">
			<xsl:call-template name="tempNumberOfLines"/>
		</xsl:element>	
	</xsl:template>

	<!--This template will check that the number of lines in the document matches the value found at the trailer level-->
	<xsl:template name="tempNumberOfLines">
		<xsl:if test="not(format-number(count(//ProofOfDeliveryLine), '#') = format-number(//NumberOfLines, '#'))">
			<xsl:element name="Error">
				<xsl:text>DocTotalCheck¬Number Of Lines</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>