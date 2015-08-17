<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************



******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         | Description of modification
******************************************************************************************
 09/04/2010  | R Cambridge  | 3455 Inbound csv order translator
*****************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" encoding="utf-8"/>
	
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!--Then let attributes be copied/not copied/modified by other more specific templates -->
			<xsl:apply-templates select="@*"/>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!-- Copy the attribute unchanged -->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
		
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
	<!-- Ignore column headers -->
	<xsl:template match="BatchDocument[1]"/>
	
	<xsl:template match="BatchDocument">
		<xsl:copy>
			<xsl:attribute name="DocumentTypeNo">2</xsl:attribute>	
			<xsl:apply-templates/>	
		</xsl:copy>
	</xsl:template>

	<xsl:template match="SendersCodeForRecipient">		
		<xsl:copy>
			<!-- Oh dear -->
			<xsl:text>FAIRFAX</xsl:text>
		</xsl:copy>		
	</xsl:template>
	
	<!--xsl:template match="SendersBranchReference">		
		<xsl:copy>		
			<xsl:value-of select="../SendersCodeForRecipient"/>
			<xsl:value-of select="."/>	
		</xsl:copy>
	</xsl:template-->
	

	
	
	<xsl:template match="PurchaseOrderHeader">		
		<xsl:copy>		
			<xsl:apply-templates/>	
			<HeaderExtraData>				
				
				<!-- (cu-ord-no) -->
				<CustomerOrderNumber>
					<xsl:value-of select="PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
				</CustomerOrderNumber>
				
				<!-- (loc-no) -->
				<DistributionDepotCode>XH0100</DistributionDepotCode>
				
				<!-- 3663 field (del_date) -->
				<CustomerDeliveryDate>
					<xsl:call-template name="dateToUTCFormat">
						<xsl:with-param name="input" select="OrderedDeliveryDetails/DeliveryCutOffDate"/>
					</xsl:call-template>
				</CustomerDeliveryDate> 
								
				<!-- 3663 field (route-no) -->
				<RouteNumber>
					<xsl:value-of select="OrderedDeliveryDetails/DeliveryCutOffTime"/>
				</RouteNumber> 		
						
				<!-- 3663 field (drop-seq) -->
				<DropNumber>
					<xsl:value-of select="OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
				</DropNumber> 			
					
			</HeaderExtraData>	
		</xsl:copy>
	</xsl:template>
	
	<!-- These elements aren't needed now their contents has been stored in HeaderExtraData -->
	<xsl:template match="CustomerPurchaseOrderReference | DeliveryCutOffDate | DeliveryCutOffTime | SpecialDeliveryInstructions | LineNumber"/>

	
	<xsl:template match="ShipToLocationID/SuppliersCode">		
		<xsl:copy>
			<xsl:text>GK</xsl:text>
			<xsl:value-of select="."/>
		</xsl:copy>		
	</xsl:template>
	
	<xsl:template match="PurchaseOrderReferences/PurchaseOrderReference">		
		<xsl:copy>
			<xsl:text>GK</xsl:text>
			<xsl:value-of select="../../ShipTo/ShipToLocationID/SuppliersCode"/>
			<xsl:text>_</xsl:text>
			<xsl:value-of select="."/>
		</xsl:copy>		
	</xsl:template>
		
	
	<xsl:template match="DeliveryDate">
		<xsl:copy>
			<xsl:call-template name="dateToUTCFormat">
				<xsl:with-param name="input" select="."/>
			</xsl:call-template>		
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="OrderedQuantity">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="'NaN' = string(number(.))">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(.,'0')"/>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:copy>
	</xsl:template>

	<xsl:template match="PackSize">
		<xsl:copy>EA</xsl:copy>
	</xsl:template>
	
	<xsl:template name="dateToUTCFormat">
		<xsl:param name="input"/>
		
		<xsl:value-of select="concat(substring($input,7,4),'-',substring($input,4,2),'-',substring($input,1,2))"/>
		
	</xsl:template>
	

	
</xsl:stylesheet>
