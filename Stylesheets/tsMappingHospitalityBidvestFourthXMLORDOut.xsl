<?xml version="1.0" encoding="UTF-8"?>
<!--*******************************************************************************************************************************************************************
 Overview

 Outbound Bidvest orders in Fourth XML format
 
*******************************************************************************************************************************************************************
 Module History
*******************************************************************************************************************************************************************
 Date        		 | Name         	| Description of modification
*******************************************************************************************************************************************************************
  17/08/2016 		| M Dimant		| FB11257 - Created from Fourth XML Mapper for Orders only. Added logic around how we apply UOMs
*******************************************************************************************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">
<xsl:import href="tsMappingHospitalityFourthXmlInOut.xsl"/>
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>


	<!-- Apply a UOM of EA if there is an S on the end of the product code. Otherwise set UOM to CS -->
	<xsl:template match="OrderedQuantity">
			<OrderedQuantity>
				<xsl:variable name="IsSplitLine" select="substring(../ProductID/SuppliersProductCode,string-length(../ProductID/SuppliersProductCode),1) = 'S'"/>
				<xsl:attribute name="UnitOfMeasure">
							<xsl:choose>
								<xsl:when test="$IsSplitLine">
									<xsl:text>EA</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>CS</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					<xsl:apply-templates/>
				</OrderedQuantity>
	</xsl:template>


</xsl:stylesheet>