<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2008-05-22		| 2245 Created Module
**********************************************************************
				|						|
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" />
	
	
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates select="@* | node()"/>
		</BatchRoot>
	</xsl:template>
	
	
	<xsl:template match="BatchDocument">
		<xsl:copy>
			<xsl:attribute name="DocumentTypeNo">3</xsl:attribute>			
			<xsl:apply-templates select="@* | node() |*"/>			
		</xsl:copy>	
	</xsl:template>
	
	
	<xsl:template match="PurchaseOrderConfirmationReferences">
		
		<!-- create confirmation references... -->
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>

		<!-- ...and then confirmed delivery details -->
		<ConfirmedDeliveryDetails>
			
			<!-- Use the earliest line level delivery date as confirmed delivery date -->
			<xsl:for-each select="../../PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/ConfirmedDeliveryDetailsLineLevel/DeliveryDate">
				<!-- The sort expresion below creates the same format as formatDateAsUTC()
					  A Lexical sort of UTC dates gives the earliest date first
				 -->
				<xsl:sort select="concat('20',substring(.,7,2),'-',substring(.,4,2),'-',substring(.,1,2))"/>
			
				<xsl:if test="position()=1">
					
					<xsl:call-template name="formatDateAsUTC"/>
									
				</xsl:if>
			
			</xsl:for-each>
						
		</ConfirmedDeliveryDetails>
	
	</xsl:template>
	
	
	<!-- Converts dd/mm/yy into tradesimple date format -->
	<xsl:template name="formatDateAsUTC" match="PurchaseOrderDate | PurchaseOrderConfirmationDate | DeliveryDate">
	
		<xsl:copy>
		
			<xsl:text>20</xsl:text>
			<xsl:value-of select="substring(.,7,2)"/>							
			<xsl:text>-</xsl:text>			
			<xsl:value-of select="substring(.,4,2)"/>			
			<xsl:text>-</xsl:text>							
			<xsl:value-of select="substring(.,1,2)"/>

		</xsl:copy>
	
	</xsl:template>
	
	
	<!-- These nodes were only needed to create //PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate 
		  so they need to be removed now
	-->
	<xsl:template match="ConfirmedDeliveryDetailsLineLevel"/>
	
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
		

</xsl:stylesheet>
