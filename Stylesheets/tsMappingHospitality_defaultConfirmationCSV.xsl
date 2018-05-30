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
' 26/06/2009| KO | Created
'******************************************************************************************

'******************************************************************************************
-->
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:vbscript="http://abs-Ltd.com">

	<xsl:template match="PurchaseOrderConfirmation">
	
		<BatchRoot><Batch><BatchDocuments><BatchDocument>
		
			<PurchaseOrderConfirmation>
			
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient>
						<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
					</SendersCodeForRecipient>
					
					<xsl:if test="string(TradeSimpleHeader/SendersBranchReference) !='' ">
						<SendersBranchReference>
							<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
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
				
					<xsl:if test="PurchaseOrderConfirmationHeader/ShipTo/ShipToName != '' or PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1 != '' or PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2 != '' or PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3 != '' or PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4 != '' or PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode != '' or PurchaseOrderConfirmationHeader/ShipTo/ContactName != ''">
						<ShipTo>
							<xsl:if test="PurchaseOrderConfirmationHeader/ShipTo/ShipToName != ''">
								<ShipToName>
									<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToName"/>
								</ShipToName>
							</xsl:if>
							<xsl:if test="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1 != '' or PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2 != '' or PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3 != '' or PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4 != '' or PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode != ''">
								<ShipToAddress>
									<xsl:if test="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1 != ''">
										<AddressLine1>
											<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1"/>
										</AddressLine1>
									</xsl:if>
									<xsl:if test="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2 != ''">
										<AddressLine2>
											<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2"/>
										</AddressLine2>
									</xsl:if>
									<xsl:if test="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3 != ''">
										<AddressLine3>
											<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3"/>
										</AddressLine3>
									</xsl:if>
									<xsl:if test="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4 != ''">
										<AddressLine4>
											<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4"/>
										</AddressLine4>
									</xsl:if>
									<xsl:if test="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode != ''">
										<PostCode>
											<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode"/>
										</PostCode>
									</xsl:if>
								</ShipToAddress>
							</xsl:if>
							<xsl:if test="PurchaseOrderConfirmationHeader/ShipTo/ContactName != ''">
								<ContactName>
									<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ContactName"/>
								</ContactName>
							</xsl:if>
						</ShipTo>
					</xsl:if>
				
					<PurchaseOrderReferences>
					
						<PurchaseOrderReference>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
						</PurchaseOrderReference>
	
						<xsl:if test="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate != ''">
							
							<xsl:variable name="dtPODate">
								<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
							</xsl:variable>
							
							<PurchaseOrderDate>							
								<xsl:choose>
									<xsl:when test="string-length($dtPODate) = 6">
										<xsl:value-of select="concat('20', substring($dtPODate,1,2),'-', substring($dtPODate,3,2),'-',substring($dtPODate,5,2))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat(substring($dtPODate,1,4),'-', substring($dtPODate,5,2),'-',substring($dtPODate,7,2))"/>
									</xsl:otherwise>
								</xsl:choose>
							</PurchaseOrderDate>
							
						</xsl:if>
					</PurchaseOrderReferences>
					
					<xsl:if test="PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate != ''">
						<OrderedDeliveryDetails>
							
							<xsl:variable name="dtOrdDelDate">
								<xsl:value-of select="PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate"/>
							</xsl:variable>
							
							<DeliveryDate>								
								<xsl:choose>
									<xsl:when test="string-length($dtOrdDelDate) = 6">
										<xsl:value-of select="concat('20',substring($dtOrdDelDate,1,2),'-',substring($dtOrdDelDate,3,2),'-',substring($dtOrdDelDate,5,2))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat(substring($dtOrdDelDate,1,4),'-',substring($dtOrdDelDate,5,2),'-',substring($dtOrdDelDate,7,2))"/>
									</xsl:otherwise>
								</xsl:choose>
							</DeliveryDate>
							
						</OrderedDeliveryDetails>
					</xsl:if>
					
					<xsl:if test="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate != '' or PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart != '' or PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotEnd != ''">
						<ConfirmedDeliveryDetails>
							
							<xsl:if test="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate">
								
								<xsl:variable name="sConfDelDate">
									<xsl:value-of select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
								</xsl:variable>
								
								<DeliveryDate>
									<xsl:choose>
										<xsl:when test="string-length($sConfDelDate) = 6">
											<xsl:value-of select="concat('20',substring($sConfDelDate,1,2),'-',substring($sConfDelDate,3,2),'-',substring($sConfDelDate,5,2))"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat(substring($sConfDelDate,1,4),'-',substring($sConfDelDate,5,2),'-',substring($sConfDelDate,7,2))"/>
										</xsl:otherwise>
									</xsl:choose>	
								</DeliveryDate>
								
							</xsl:if>
							
							<xsl:if test="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart != '' or PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotEnd != ''">
								<DeliverySlot>
									<xsl:if test="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart != ''">
										<xsl:variable name="tmSlotStart">
											<xsl:value-of select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart"/>
										</xsl:variable>
										<SlotStart>
											<xsl:value-of select="concat(substring($tmSlotStart,1,2),':',substring($tmSlotStart,3,2))"/>
										</SlotStart>
									</xsl:if>
									<xsl:if test="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotEnd">
										<xsl:variable name="tmSlotEnd">
											<xsl:value-of select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotEnd"/>
										</xsl:variable>
										<SlotEnd>
											<xsl:value-of select="concat(substring($tmSlotEnd,1,2),':',substring($tmSlotEnd,3,2))"/>
										</SlotEnd>
									</xsl:if>
								</DeliverySlot>
							</xsl:if>
						</ConfirmedDeliveryDetails>
					</xsl:if>
					
				</PurchaseOrderConfirmationHeader>
				
				<PurchaseOrderConfirmationDetail>
					<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
					
						<PurchaseOrderConfirmationLine>
						
							<!-- translate the inbound line status -->
							<xsl:if test="@LineStatus != ''">
								<xsl:attribute name="LineStatus">
									<xsl:choose>
										<xsl:when test="@LineStatus = 'A'">
											<xsl:text>Accepted</xsl:text>
										</xsl:when>
										<xsl:when test="@LineStatus = 'C'">
											<xsl:text>Changed</xsl:text>
										</xsl:when>
										<xsl:when test="@LineStatus = 'R'">
											<xsl:text>Rejected</xsl:text>
										</xsl:when>
										<xsl:when test="@LineStatus = 'S'">
											<xsl:text>Added</xsl:text>
										</xsl:when>
										<!-- if the line status is not recognised then pass through the inbound value
										     so the document fails at the xsd validation stage -->
										<xsl:otherwise>
											<xsl:value-of select="@LineStatus"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</xsl:if>
							
							<ProductID>
								<SuppliersProductCode>
									<xsl:value-of select="ProductID/SuppliersProductCode"/>
								</SuppliersProductCode>
							</ProductID>
	
							<xsl:if test="SubsitutedProductID/SuppliersProductCode != ''">
								<SubstitutedProductID>
									<SuppliersProductCode>
										<xsl:value-of select="SubsitutedProductID/SuppliersProductCode"/>
									</SuppliersProductCode>
								</SubstitutedProductID>
							</xsl:if>
							
							<xsl:if test="ProductDescription != ''">
								<ProductDescription>
									<xsl:value-of select="ProductDescription"/>
								</ProductDescription>
							</xsl:if>
							
							<xsl:if test="OrderedQuantity != ''">
								<OrderedQuantity>
									<xsl:value-of select="OrderedQuantity"/>
								</OrderedQuantity>
							</xsl:if>
							
							<ConfirmedQuantity>
								<xsl:value-of select="ConfirmedQuantity"/>
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
							
							<xsl:if test="LineValueExclVAT">
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
				
				<xsl:if test="PurchaseOrderConfirmationTrailer/NumberOfLines != '' or PurchaseOrderConfirmationTrailer/TotalExclVAT != ''">
					<PurchaseOrderConfirmationTrailer>
						
						<xsl:if test="PurchaseOrderConfirmationTrailer/NumberOfLines != ''">
							<NumberOfLines>
								<xsl:value-of select="PurchaseOrderConfirmationTrailer/NumberOfLines"/>
							</NumberOfLines>	
						</xsl:if>
						
						<xsl:if test="PurchaseOrderConfirmationTrailer/TotalExclVAT != ''">
							<TotalExclVAT>
								<xsl:value-of select="PurchaseOrderConfirmationTrailer/TotalExclVAT"/>
							</TotalExclVAT>
						</xsl:if>
				
					</PurchaseOrderConfirmationTrailer>
				</xsl:if>
			
			</PurchaseOrderConfirmation>
			
		</BatchDocument></BatchDocuments></Batch></BatchRoot>			
			
	</xsl:template>

	<!-- xsl:template match="Document">

		<BatchRoot>
		
		<Batch><BatchDocuments><BatchDocument>
		
			<PurchaseOrderConfirmation>
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient>
						<xsl:value-of select="H/L2[2]"/>
					</SendersCodeForRecipient>
					
					<xsl:if test="string(H/L2[20]) !='' ">
						<SendersBranchReference>
							<xsl:value-of select="H/L2[20]"/>
						</SendersBranchReference>
					</xsl:if>
					
					<TestFlag>
						<xsl:choose>
							<xsl:when test="H/L2[3] = 'false'">false</xsl:when>
							<xsl:when test="H/L2[3] = 'False'">false</xsl:when>
							<xsl:when test="H/L2[3] = 'FALSE'">false</xsl:when>
							<xsl:when test="H/L2[3] = '0'">false</xsl:when>
							<xsl:when test="H/L2[3] = 'N'">false</xsl:when>
							<xsl:when test="H/L2[3] = 'n'">false</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose>
					</TestFlag>

				</TradeSimpleHeader>
				
				<PurchaseOrderConfirmationHeader>
							
						<ShipTo>
						
								<ShipToLocationID>
									
									<SuppliersCode>
										<xsl:value-of select="H/L2[2]"/>
									</SuppliersCode>
								
								</ShipToLocationID>
	
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
						
							<xsl:if test="L2[2] != ''">
								<xsl:attribute name="LineStatus">
									<xsl:choose>
									
										<xsl:when test="L2[2] = 'A'">
											<xsl:text>Accepted</xsl:text>
										</xsl:when>
										
										<xsl:when test="L2[2] = 'C'">
											<xsl:text>Changed</xsl:text>
										</xsl:when>
										
										<xsl:when test="L2[2] = 'R'">
											<xsl:text>Rejected</xsl:text>
										</xsl:when>
										
										<xsl:when test="L2[2] = 'S'">
											<xsl:text>Added</xsl:text>
										</xsl:when>

										<xsl:otherwise>
											<xsl:value-of select="L2[2]"/>
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
						<xsl:choose>
							<xsl:when test="string(H/L2[17]) !='' and H/L2[17] !='0'">
								<xsl:value-of select="H/L2[17]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="count(D/L2)"/>
							</xsl:otherwise>
						</xsl:choose>
					</NumberOfLines>
						
					<xsl:if test="string(H/L2[19]) !=''">
						<TotalExclVAT>
							<xsl:value-of select="H/L2[19]"/>
						</TotalExclVAT>
					</xsl:if>
				
				</PurchaseOrderConfirmationTrailer>
			
			</PurchaseOrderConfirmation>
			
			</BatchDocument></BatchDocuments></Batch>
			
		</BatchRoot>	

	</xsl:template-->
	
	
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

