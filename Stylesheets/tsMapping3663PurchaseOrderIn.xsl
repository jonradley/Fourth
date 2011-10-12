<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************



******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         | Description of modification
******************************************************************************************
 26/01/2009  | R Cambridge  | 2666 Inbound psv order translator
*****************************************************************************************
 23/02/2009  | R Cambridge  | 2758 Ensure ordered quantity of 0 is stored as 0 not blank
												 If pack size or quantity are not numeric then pass through whatever value is provided
*****************************************************************************************
 29/06/2008  | J Pollard | 2970 Ensure any quotes arround ship to details are removed. 
***************************************************************************************-->
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
	
	<xsl:template match="SendersBranchReference">		
		<xsl:copy>		
			<xsl:value-of select="../SendersCodeForRecipient"/>
			<xsl:value-of select="."/>	
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderHeader">		
		<xsl:copy>		
			<xsl:apply-templates/>	
			<HeaderExtraData>				
				
				<!-- (cu-ord-no) -->
				<CustomerOrderNumber>
					<xsl:value-of select="PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
				</CustomerOrderNumber>
				
				<!-- (loc-no) -->
				<DistributionDepotCode>
					<xsl:value-of select="../TradeSimpleHeader/SendersBranchReference"/>				
				</DistributionDepotCode>
				
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
	
	
	<xsl:template match="DeliveryDate">
		<xsl:copy>
			<xsl:call-template name="dateToUTCFormat">
				<xsl:with-param name="input" select="."/>
			</xsl:call-template>		
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderLine">
		<xsl:copy>
			<xsl:apply-templates/>
			<LineExtraData>
				<CustomerLineNumber>
					<xsl:value-of select="format-number(LineNumber,'#')"/>
				</CustomerLineNumber>
			</LineExtraData>
		</xsl:copy>	
	</xsl:template>
	
	
	<xsl:template match="ProductID">
		<xsl:copy>
			<SuppliersProductCode>
				<!-- User buyer's code if present otherwise supplier's code -->
				<xsl:value-of select="(SuppliersProductCode | BuyersProductCode)[. != ''][last()]"/>
			</SuppliersProductCode>
			<BuyersProductCode>
				<xsl:value-of select="BuyersProductCode"/>
			</BuyersProductCode>		
		</xsl:copy>
	</xsl:template>

	<xsl:template match="OrderedQuantity | PackSize">
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
	
	<xsl:template name="dateToUTCFormat">
		<xsl:param name="input"/>
		
		<xsl:value-of select="concat(substring($input,1,4),'-',substring($input,5,2),'-',substring($input,7,2))"/>
		
	</xsl:template>
	
	<!-- strip quotes from text fields -->
	<xsl:template match="ShipToName | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4 | Postcode">
	
		<xsl:copy>
			<xsl:call-template name="stripQuotes">
				<xsl:with-param name="sInput" select="."/>	
			</xsl:call-template>	
		</xsl:copy>		

	</xsl:template>

	<xsl:template name="stripQuotes">
		<xsl:param name="sInput"/>
	
		<xsl:choose>
			<xsl:when test="starts-with($sInput,'&quot;') and substring($sInput,string-length($sInput),1) = '&quot;'">
				<xsl:value-of select="substring($sInput,2,string-length($sInput)-2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sInput"/>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
</xsl:stylesheet>
