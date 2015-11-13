<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
Overview 

   Woodwards CD OFSCI confirmation pre-mapper
   
   Indbound message will contain Seller/SellerAssigned to keep them in line with confs 
   from Woodwards Frozen and Ambient (this is the senders branch reference on tradesimple)
   
   Woodwards CD messages will be sent directly to/from the CD sub-member (at least 
   initially) so this field needs to be removed while that's the case
   
      
	

© ABS Ltd., 2007.
******************************************************************************************
  Module History
******************************************************************************************
  Date        | Name         | Description of modification
******************************************************************************************
  16/04/2007  | R Cambridge  | 1009 Created
******************************************************************************************
              |              | 
******************************************************************************************
              |              | 
***************************************************************************************-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/">
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<xsl:apply-templates select="@*|node()" />
		</BatchRoot>
	</xsl:template>
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	
	<!-- Remove what would have been the sender's branch reference -->
	<xsl:template match="OrderConfirmation/Seller/SellerAssigned"/>

	<xsl:template match="OrderConfirmation/ShipTo/SellerAssigned">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string(number(.)) = 'NaN'">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(.)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	
</xsl:stylesheet>
