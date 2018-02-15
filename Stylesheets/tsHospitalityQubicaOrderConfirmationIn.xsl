<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order Confirmation mapper (BUNZL)
'  Hospitality post flat file mapping to iXML format.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 13/09/2005  | Calum Scott  | Created
'******************************************************************************************
' 14/10/2005  | Lee Boyton   | H515. Added BatchRoot element required by inbound xsl
'                            | transform processor. Translate the LineStatus to internal values.
'******************************************************************************************
' 08/05/2007  | Nigel Emsen  | Copied for Bunzl. FB: 791.
'******************************************************************************************
' 21/07/2009  | Lee Boyton   | FB3016 - Do not map the ShipTo Buyers Code for
'                                            | non-Hilton confirmations, let the in-filler do it.
'******************************************************************************************
' 30/10/2010  | Graham Neicho  | FB3436 Added BackOrderQuantity
'******************************************************************************************
-->
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:vbscript="http://abs-Ltd.com">

	<xsl:template match="/PurchaseOrderConfirmation">

		<BatchRoot>
		
		<Batch><BatchDocuments><BatchDocument>
		
			<PurchaseOrderConfirmation>
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient>
						<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
					</SendersCodeForRecipient>
					
					<TestFlag>
							<xsl:text>false</xsl:text>
					</TestFlag>

				</TradeSimpleHeader>
				
				<PurchaseOrderConfirmationHeader>
					<DocumentStatus>
						<xsl:text>Original</xsl:text>
					</DocumentStatus>	
					<Buyer>
						<BuyersLocationID>
							<GLN>
								<xsl:text>5555555555555</xsl:text>
							</GLN>
						</BuyersLocationID>
					</Buyer>	
					<Supplier>
						<SuppliersLocationID>
							<GLN>
								<xsl:text>5555555555555</xsl:text>
							</GLN>
						</SuppliersLocationID>	
					</Supplier>
					<ShipTo>
						<ShipToLocationID>
							<GLN>
								<xsl:text>5555555555555</xsl:text>
							</GLN>
							<SuppliersCode>
								<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
							</SuppliersCode>
						</ShipToLocationID>
					</ShipTo>
			
					<PurchaseOrderReferences>
					
						<PurchaseOrderReference>
							<xsl:value-of select="substring-before(substring-after(PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference,'SP/'),'/')"/>
						</PurchaseOrderReference>
	
						<xsl:variable name="dtPODate" select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
						<PurchaseOrderDate>
							<xsl:value-of select="concat(substring($dtPODate,7,4),'-', substring($dtPODate,4,2),'-',substring($dtPODate,1,2))"/>
						</PurchaseOrderDate>

					</PurchaseOrderReferences>
					
					<PurchaseOrderConfirmationReferences>
					
						<PurchaseOrderConfirmationReference>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
						</PurchaseOrderConfirmationReference>
						
						<PurchaseOrderConfirmationDate>
							<xsl:value-of select="vbscript:sGetTodaysDate()"/>
						</PurchaseOrderConfirmationDate>	
					
					</PurchaseOrderConfirmationReferences>
					
					<OrderedDeliveryDetails>
					
						<xsl:variable name="dtOrdDelDate" select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
						
						<DeliveryType>
							<xsl:text>Delivery</xsl:text>
						</DeliveryType>
						
						<DeliveryDate>
								<xsl:value-of select="concat(substring($dtOrdDelDate,7,4),'-',substring($dtOrdDelDate,4,2),'-',substring($dtOrdDelDate,1,2))"/>
						</DeliveryDate>
						
					</OrderedDeliveryDetails>
					
					<xsl:variable name="dtConfDelDate" select="//PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/ConfirmedDeliveryDetailsLineLevel/DeliveryDate"/>	

					<ConfirmedDeliveryDetails>
					
						<DeliveryType>
							<xsl:text>Delivery</xsl:text>
						</DeliveryType>
						
						<DeliveryDate>
							<xsl:value-of select="concat(substring($dtConfDelDate,7,4),'-',substring($dtConfDelDate,4,2),'-',substring($dtConfDelDate,1,2))"/>
						</DeliveryDate>
							
					</ConfirmedDeliveryDetails>
					
				</PurchaseOrderConfirmationHeader>
				
				<PurchaseOrderConfirmationDetail>
				
					<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
					
						<PurchaseOrderConfirmationLine>
							
						<!--
							<xsl:attribute name="LineStatus">
								<xsl:text>Accepted</xsl:text>
							</xsl:attribute>
							
							-->
							
							<LineNumber>
								<xsl:value-of select="position()"/>
							</LineNumber>
												
							<ProductID>
								<GTIN>
									<xsl:text>55555555555555</xsl:text>
								</GTIN>
								<SuppliersProductCode>
									<xsl:value-of select="ProductID/SuppliersProductCode"/>
								</SuppliersProductCode>
							</ProductID>
							
							<xsl:if test="ProductDescription != ''">
								<ProductDescription>
									<xsl:value-of select="ProductDescription"/>
								</ProductDescription>
							</xsl:if>
							
							<xsl:if test="OrderedQuantity != ''">
								<OrderedQuantity UnitOfMeasure="EA">
									<xsl:value-of select="OrderedQuantity"/>
								</OrderedQuantity>
							</xsl:if>
							
							<!--
							<xsl:if test="ConfirmedQuantity != ''">
								<ConfirmedQuantity UnitOfMeasure="EA">
									<xsl:value-of select="ConfirmedQuantity"/>
								</ConfirmedQuantity>
							</xsl:if>
							-->
							
							<ConfirmedQuantity>
								<xsl:attribute name="UnitOfMeasure">
									<xsl:call-template name="decodeUoM">
										<xsl:with-param name="sInput">
											<xsl:value-of select="PackSize"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:value-of select="format-number(ConfirmedQuantity, '0.000')"/>
							</ConfirmedQuantity>
							
							<xsl:if test="PackSize != ''">
								<PackSize>
									<xsl:value-of select="PackSize"/>
								</PackSize>
							</xsl:if>
							
							<xsl:if test="UnitValueExclVAT != ''">
								<UnitValueExclVAT>
									<xsl:value-of select="UnitValueExclVAT"/>
								</UnitValueExclVAT>
							</xsl:if>
							
							<xsl:if test="LineValueExclVAT !=''">
								<LineValueExclVAT>
									<xsl:value-of select="LineValueExclVAT"/>
								</LineValueExclVAT>
							</xsl:if>
							
							<xsl:if test="Narrative != ''">
								<Narrative>
									<xsl:value-of select="Narrative"/>
								</Narrative>
							</xsl:if>
						
						</PurchaseOrderConfirmationLine>
					
					</xsl:for-each>
				</PurchaseOrderConfirmationDetail>
				
				<PurchaseOrderConfirmationTrailer>
						
					<NumberOfLines>
						<xsl:choose>
							<xsl:when test="NumberOfLines !='0'">
								<xsl:value-of select="NumberOfLines"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="count(//PurchaseOrderConfirmationLine)"/>
							</xsl:otherwise>
						</xsl:choose>
					</NumberOfLines>

				</PurchaseOrderConfirmationTrailer>
			
			</PurchaseOrderConfirmation>
			
			</BatchDocument></BatchDocuments></Batch>
			
		</BatchRoot>	

	</xsl:template>
	
	<xsl:template name="decodeUoM">
		<xsl:param name="sInput"/>
		<xsl:choose>
			<xsl:when test="$sInput = 'BG'">EA</xsl:when>
			<xsl:when test="$sInput = 'BX'">CS</xsl:when>
			<xsl:when test="$sInput = 'CS'">CS</xsl:when>
			<xsl:when test="$sInput = 'DZ'">DZN</xsl:when>
			<xsl:when test="$sInput = 'FT'">EA</xsl:when>
			<xsl:when test="$sInput = 'GA'">EA</xsl:when>
			<xsl:when test="$sInput = 'LB'">PND</xsl:when>
			<xsl:when test="$sInput = 'LF'">EA</xsl:when>
			<xsl:when test="$sInput = 'LG'">EA</xsl:when>
			<xsl:when test="$sInput = 'MT'">EA</xsl:when>
			<xsl:when test="$sInput = 'PD'">EA</xsl:when>
			<xsl:when test="$sInput = 'PK'">EA</xsl:when>
			<xsl:when test="$sInput = 'PR'">PR</xsl:when>
			<xsl:when test="$sInput = 'PT'">PTI</xsl:when>
			<xsl:when test="$sInput = 'QT'">EA</xsl:when>
			<xsl:when test="$sInput = 'RL'">EA</xsl:when>
			<xsl:when test="$sInput = 'SH'">EA</xsl:when>
			<xsl:when test="$sInput = 'ST'">EA</xsl:when>
			<xsl:when test="$sInput = 'TB'">EA</xsl:when>
			<xsl:otherwise>
				<xsl:text>EA</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 

		'	------------------------------------------------------------------
		' FUNCTION:	To return the SystemDate in Internal XML format.
		'					Nigel Emsen, May 2007
		'	------------------------------------------------------------------
		Function sGetTodaysDate()
		
			Dim dToday
			Dim sDay, sMonth, sYear
			
			dToday=date
			
			sDay=Day(dToday)
			if CInt(sDay)<10 then sDay="0" & sDay
			
			sMonth=Month(dToday)
			if CInt(sMonth)<10 then sMonth="0" & sMonth
			
			sYear=Year(dToday)
			
			sGetTodaysDate=sYear & "-" & sMonth & "-" & sDay

		End Function

	]]></msxsl:script>

</xsl:stylesheet>


