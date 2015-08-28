<?xml version="1.0" encoding="UTF-8"?>
<!--****************************************************************************************************************************************
Maps Entertainment Alliance CSV Delivery Notes Batch into internal XML.
********************************************************************************************************************************************
Name			| Date			| Change
********************************************************************************************************************************************
M Dimant		| 26/03/2015	| FB 10201: Created.
********************************************************************************************************************************************
					|					|
*****************************************************************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output encoding="utf-8"/>
	
	<xsl:template match="/">
		<BatchRoot>	
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
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
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	 
	
	<xsl:template match="BatchDocuments">
		<xsl:copy>		
			<!-- Check if first SCR contains any letters. -->						
			<xsl:variable name="alpha" select="'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>    
			<xsl:variable name="firstInBatch" select="BatchDocument[1]/DeliveryNote/TradeSimpleHeader/SendersCodeForRecipient"/>
			<xsl:choose>						
				<xsl:when test="string-length(translate($firstInBatch, translate($firstInBatch, $alpha, ''), '')) &gt; 0">
					<!-- If so then it must be a header and we remove first document in the batch -->
					<xsl:for-each select="BatchDocument[position()!=1]">
						<xsl:copy>
							<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:copy>			
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="BatchDocument">
						<xsl:copy>
							<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
							<xsl:apply-templates/>
						</xsl:copy>			
					</xsl:for-each>
				</xsl:otherwise>			
			</xsl:choose>				
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="DeliveryNoteHeader">
		<xsl:copy>			
			<ShipTo>
				<ShipToLocationID>
					<xsl:element name="SuppliersCode">
						<xsl:call-template name="stripQuotes">
							<xsl:with-param name="sInput">
								<xsl:value-of select="ShipTo/ShipToLocationID/SuppliersCode"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</ShipToLocationID>
			</ShipTo>
			<xsl:variable name="deldate" select="DeliveryNoteReferences/DeliveryNoteDate"/>	
			<PurchaseOrderReferences>
					<xsl:element name="PurchaseOrderReference">
						<xsl:call-template name="stripQuotes">
							<xsl:with-param name="sInput">
								<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:element>			
				<PurchaseOrderDate><xsl:value-of select="concat(substring($deldate, 2, 4), '-', substring($deldate, 7, 2), '-', substring($deldate, 10, 2))"/></PurchaseOrderDate>
			</PurchaseOrderReferences>
			<DeliveryNoteReferences>
				<xsl:element name="DeliveryNoteReference">
						<xsl:call-template name="stripQuotes">
							<xsl:with-param name="sInput">
								<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:element>	
					<DeliveryNoteDate><xsl:value-of select="concat(substring($deldate, 2, 4), '-', substring($deldate, 7, 2), '-', substring($deldate, 10, 2))"/></DeliveryNoteDate>
			</DeliveryNoteReferences>
		</xsl:copy>		
	</xsl:template>		
	

	<!-- Remove quotation marks from the nodes -->
	<xsl:template match="SendersCodeForRecipient | SuppliersCode | DeliveryNoteReference | SuppliersProductCode | ProductDescription | OrderedQuantity | DespatchedQuantity">
		<xsl:element name="{name()}">
			<xsl:call-template name="stripQuotes">
				<xsl:with-param name="sInput">
					<xsl:value-of select="."/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>	
	</xsl:template>

	
	<!-- Format dates correctly -->
	<xsl:template match="PurchaseOrderDate | DeliveryNoteDate | DespatchDate | DeliveryDate | ExpiryDate | SellByDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(., 2, 4), '-', substring(., 7, 2), '-', substring(., 10, 2))"/>
		</xsl:element>
	</xsl:template>

		<xsl:template name="stripQuotes">
		<xsl:param name="sInput"/>
		<xsl:variable name="sLF"><xsl:text>&#10;</xsl:text></xsl:variable>
		<xsl:variable name="sWorking">
			<xsl:choose>
				<xsl:when test="substring($sInput,string-length($sInput),1) = $sLF">
					<xsl:value-of select="substring($sInput,1,string-length($sInput)-1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$sInput"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="starts-with($sWorking,'&quot;') and substring($sWorking,string-length($sWorking),1) = '&quot;'">
				<xsl:value-of select="substring($sWorking,2,string-length($sWorking)-2)"/>
			</xsl:when>
			<xsl:when test="substring($sWorking,string-length($sWorking),1) = '&quot;'">
				<xsl:value-of select="substring($sWorking,1,string-length($sWorking)-1)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sWorking"/>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	
</xsl:stylesheet>
