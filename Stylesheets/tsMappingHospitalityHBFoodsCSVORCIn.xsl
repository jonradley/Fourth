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
' 03/07/2012  | H Robson  | FB4970 Created as copy of 'tsMappingHospitalityBunzlUrbiumInboundCSVConfirmation.xsl' with alterations
'******************************************************************************************
' 03/05/2013  | H Robson  | FB5841 Don't output GTIN tags if there's no GTIN
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
					
					<xsl:if test="string(TradeSimpleHeader/SendersBranchReference) != ''">
						<SendersBranchReference>
							<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
						</SendersBranchReference>
					</xsl:if>
					
					<!--Mapping Recipient's Branch Reference for Harrods Order Confirmations only -->
					<xsl:if test="string(TradeSimpleHeader/RecipientsBranchReference) != ''">
						<RecipientsBranchReference>
							<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
						</RecipientsBranchReference>
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
							<!-- Inserting a choose statement here to leave the existing code as it and also include the Harrod's Own location otherwise -->
							<xsl:choose>
								<xsl:when test="string(TradeSimpleHeader/SendersBranchReference) != '' and contains('HILTON',TradeSimpleHeader/SendersBranchReference)">
									<ShipToLocationID>
									<!--GLN/-->
										<BuyersCode>
											<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
										</BuyersCode>
										<SuppliersCode>
											<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
										</SuppliersCode>
									</ShipToLocationID>
								</xsl:when>
								<xsl:otherwise>
									<ShipToLocationID>
									<!--GLN/-->
										<BuyersCode>
											<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode"/>
										</BuyersCode>
									</ShipToLocationID>
								</xsl:otherwise>
							</xsl:choose>
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
						
							<LineNumber>
								<xsl:choose>
									<xsl:when test="LineNumber !=''">
										<xsl:value-of select="LineNumber"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="position()"/>
									</xsl:otherwise>
								</xsl:choose>
							</LineNumber>
						
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
								<!-- FB5841 -->
								<xsl:if test="ProductID/GTIN != ''">
									<GTIN>
										<xsl:value-of select="ProductID/GTIN"/>
									</GTIN>
								</xsl:if>
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
							
							<!-- We are storing Harrods Line Numbers in this element, without with Harrods Order Confirmation won't work. May need to reconsider if
							we need to use this element for storing actual Narrative information for another customer -->
							<xsl:if test="Narrative != ''">
								<Narrative>
									<xsl:value-of select="Narrative"/>
								</Narrative>
							</xsl:if>

							<xsl:if test="BackOrderQuantity != ''">
								<BackOrderQuantity>
									<xsl:value-of select="BackOrderQuantity"/>
								</BackOrderQuantity>
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
