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
-->
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:vbscript="http://abs-Ltd.com">
	<xsl:template match="Document" >
		<BatchRoot>
		
		<Batch><BatchDocuments><BatchDocument>
		
			<PurchaseOrderConfirmation>
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient>
						<xsl:value-of select="H/L2[2]"/>
					</SendersCodeForRecipient>
					
					<!-- added for Bunzl as Aramark use PL Accounts, but not present for Orchid. -->
					<xsl:if test="string(H/L2[20]) !='' ">
						<SendersBranchReference>
							<xsl:value-of select="H/L2[20]"/>
						</SendersBranchReference>
					</xsl:if>
					
					<xsl:if test="TradeSimpleHeader/TestFlag != ''">
						<TestFlag>
							<xsl:choose>
								<xsl:when test="TradeSimpleHeader/TestFlag = 'false'">false</xsl:when>
								<xsl:when test="TradeSimpleHeader/TestFlag = 'False'">false</xsl:when>
								<xsl:when test="TradeSimpleHeader/TestFlag = 'FALSE'">false</xsl:when>
								<xsl:when test="TradeSimpleHeader/TestFlag = '0'">false</xsl:when>
								<xsl:when test="TradeSimpleHeader/TestFlag = 'N'">false</xsl:when>
								<xsl:when test="TradeSimpleHeader/TestFlag = 'n'">false</xsl:when>
								<xsl:otherwise>true</xsl:otherwise>
							</xsl:choose>
						</TestFlag>
					</xsl:if>
				</TradeSimpleHeader>
				
				<PurchaseOrderConfirmationHeader>
				
						<ShipTo>
	
								<ShipToName>
									<xsl:value-of select="H/L2[11]"/>
								</ShipToName>

								<ShipToAddress>

									<AddressLine1>
										<xsl:value-of select="H/L2[12]"/>
									</AddressLine1>

									<xsl:if test="H/L2[13] != ''">
										<AddressLine2>
											<xsl:value-of select="H/L2[13]"/>
										</AddressLine2>
									</xsl:if>
									
									<xsl:if test="H/L2[14] != ''">
										<AddressLine3>
											<xsl:value-of select="H/L2[14]"/>
										</AddressLine3>
									</xsl:if>
									
									<xsl:if test="H/L2[15] != ''">
										<AddressLine4>
											<xsl:value-of select="H/L2[15]"/>
										</AddressLine4>
									</xsl:if>
									
									<xsl:if test="H/L2[16] != ''">
										<PostCode>
											<xsl:value-of select="H/L2[16]"/>
										</PostCode>
									</xsl:if>
									
								</ShipToAddress>

							<xsl:if test="H/L2[10] != ''">
								<ContactName>
									<xsl:value-of select="H/L2[10]"/>
								</ContactName>
							</xsl:if>
						</ShipTo>
			
					<PurchaseOrderReferences>
					
						<PurchaseOrderReference>
							<xsl:value-of select="H/L2[4]"/>
						</PurchaseOrderReference>
	
						<xsl:variable name="dtPODate" select="H/L2[5]"/>
						<PurchaseOrderDate>
							<xsl:value-of select="concat('20', substring($dtPODate,1,2),'-', substring($dtPODate,3,2),'-',substring($dtPODate,5,2))"/>
						</PurchaseOrderDate>

					</PurchaseOrderReferences>
					
					<PurchaseOrderConfirmationReferences>
					
						<PurchaseOrderConfirmationReference>
							<xsl:value-of select="H/L2[4]"/>
						</PurchaseOrderConfirmationReference>
						
						<PurchaseOrderConfirmationDate>
							<xsl:value-of select="vbscript:sGetTodaysDate()"/>
						</PurchaseOrderConfirmationDate>	
					
					</PurchaseOrderConfirmationReferences>
					
					<OrderedDeliveryDetails>
					
						<xsl:variable name="dtOrdDelDate" select="H/L2[6]"/>
						<DeliveryDate>
								<xsl:value-of select="concat('20',substring($dtOrdDelDate,1,2),'-',substring($dtOrdDelDate,3,2),'-',substring($dtOrdDelDate,5,2))"/>
						</DeliveryDate>
						
					</OrderedDeliveryDetails>
					
					<xsl:variable name="sConDelDate" select="H/L2[7]"/>
					<xsl:variable name="sConSlotStart" select="H/L2[8]"/>
					<xsl:variable name="sConSlotEnd" select="H/L2[9]"/>	

					<ConfirmedDeliveryDetails>

								<DeliveryDate>
									<xsl:value-of select="concat('20',substring($sConDelDate,1,2),'-',substring($sConDelDate,3,2),'-',substring($sConDelDate,5,2))"/>
								</DeliveryDate>

							<xsl:if test="$sConSlotStart != '' and $sConSlotEnd != ''">
							
								<DeliverySlot>
								
									<xsl:if test="$sConSlotStart != ''">
										<xsl:variable name="tmSlotStart" select="$sConSlotStart"/>
										<SlotStart>
											<xsl:value-of select="concat(substring($tmSlotStart,1,2),':',substring($tmSlotStart,3,2))"/>
										</SlotStart>
									</xsl:if>
									
									<xsl:if test="$sConSlotEnd != '' ">
										<xsl:variable name="tmSlotEnd" select="$sConSlotEnd"/>
										<SlotEnd>
											<xsl:value-of select="concat(substring($tmSlotEnd,1,2),':',substring($tmSlotEnd,3,2))"/>
										</SlotEnd>
									</xsl:if>
									
								</DeliverySlot>
								
							</xsl:if>
							
						</ConfirmedDeliveryDetails>
					
				</PurchaseOrderConfirmationHeader>
				
				<PurchaseOrderConfirmationDetail>
					<xsl:for-each select="D">
					
						<PurchaseOrderConfirmationLine>
						
							<!-- translate the inbound line status -->
							<xsl:if test="D[position()]/L2[2] != ''">
								<xsl:attribute name="LineStatus">
									<xsl:choose>
										<xsl:when test="D[position()]/L2[2] = 'A'">
											<xsl:text>Accepted</xsl:text>
										</xsl:when>
										<xsl:when test="D[position()]/L2[2] = 'C'">
											<xsl:text>Changed</xsl:text>
										</xsl:when>
										<xsl:when test="D[position()]/L2[2] = 'R'">
											<xsl:text>Rejected</xsl:text>
										</xsl:when>
										<xsl:when test="D[position()]/L2[2] = 'S'">
											<xsl:text>Added</xsl:text>
										</xsl:when>
										<!-- if the line status is not recognised then pass through the inbound value
										     so the document fails at the xsd validation stage -->
										<xsl:otherwise>
											<xsl:value-of select="D[position()]/L2[2]"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</xsl:if>
							
							<ProductID>
								<SuppliersProductCode>
									<xsl:value-of select="L2[3]"/>
								</SuppliersProductCode>
							</ProductID>
	
							<xsl:if test="L2[4] != ''">
								<SubstitutedProductID>
									<SuppliersProductCode>
										<xsl:value-of select="L2[4]"/>
									</SuppliersProductCode>
								</SubstitutedProductID>
							</xsl:if>
							
							<xsl:if test="L2[5] != ''">
								<ProductDescription>
									<xsl:value-of select="L2[5]"/>
								</ProductDescription>
							</xsl:if>
							
							<xsl:if test="L2[7] != ''">
								<OrderedQuantity>
									<xsl:value-of select="L2[7]"/>
								</OrderedQuantity>
							</xsl:if>
							
							<xsl:if test="L2[8] != ''">
								<ConfirmedQuantity>
									<xsl:value-of select="L2[8]"/>
								</ConfirmedQuantity>
							</xsl:if>
	
							<xsl:if test="L2[6] != ''">
								<PackSize>
									<xsl:value-of select="L2[6]"/>
								</PackSize>
							</xsl:if>
							
							<xsl:if test="L2[9] != ''">
								<UnitValueExclVAT>
									<xsl:value-of select="L2[9]"/>
								</UnitValueExclVAT>
							</xsl:if>
							
							<xsl:if test="L2[10] !=''">
								<LineValueExclVAT>
									<xsl:value-of select="L2[10]"/>
								</LineValueExclVAT>
							</xsl:if>
							
							<xsl:if test="L2[11] != ''">
								<Narrative>
									<xsl:value-of select="L2[11]"/>
								</Narrative>
							</xsl:if>
						
						</PurchaseOrderConfirmationLine>
					
					</xsl:for-each>
				</PurchaseOrderConfirmationDetail>
				
				<PurchaseOrderConfirmationTrailer>
						
					<NumberOfLines>
						<xsl:value-of select="H/L2[17]"/>
					</NumberOfLines>	
						
					<TotalExclVAT>
						<xsl:value-of select="H/L2[19]"/>
					</TotalExclVAT>
				
				</PurchaseOrderConfirmationTrailer>
			
			</PurchaseOrderConfirmation>
			
			</BatchDocument></BatchDocuments></Batch>
			
		</BatchRoot>			
	</xsl:template>
	
	<!-- VBScript Functions -->
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
