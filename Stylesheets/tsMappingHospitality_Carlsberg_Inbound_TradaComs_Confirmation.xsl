<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order Confirmation Batch mapper (Carlsberg)
'  Hospitality post Tradacoms flat file mapping to iXML format.
'
' © ABS Ltd., 2007.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 18/06/2007  | Nigel Emsen  | Created. FB: 1214.
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:template match="Document">
		<!--BatchRoot-->
		<BatchRoot>
			<!--Batch-->
			<Batch>
				<!--BatchDocuments-->
				<BatchDocuments>
					<!--BatchDocument-->
					<BatchDocument>
						<!--PurchaseOrderConfirmation-->
						<PurchaseOrderConfirmation>
							<!-- We need to check the DNA Segment for the following two codes. ZOR and EOR. Any other codes are to nbe
						ignored and the document is completed early. We will do this setting the confirmation to have a document
						type of 10000 and amend the routing to complete early.
				-->
							<xsl:variable name="sDocumentOrderType" select="DNA=/L2[4]/L[4]"/>
							<xsl:choose>
								<xsl:when test="string($sDocumentOrderType) !='EOR' and string($sDocumentOrderType) !='EOR' ">
									<xsl:attribute name="DocType">10000</xsl:attribute>
								</xsl:when>
							</xsl:choose>
							<!--TradeSimpleHeader-->
							<TradeSimpleHeader>
								<!--SendersCodeForRecipient-->
								<SendersCodeForRecipient>
									<xsl:value-of select="CLO=/L2[1]/L3[2]"/>
								</SendersCodeForRecipient>
								<!--SendersBranchReference-->
								<xsl:if test="string(CDT=/L2[1]/L3[2]) !='' ">
									<SendersBranchReference>
										<xsl:value-of select="CDT=/L2[2]"/>
									</SendersBranchReference>
								</xsl:if>
							</TradeSimpleHeader>
							<!--PurchaseOrderConfirmationHeader-->
							<PurchaseOrderConfirmationHeader>
								<!--ShipTo-->
								<ShipTo>
									<!--ShipToLocationID-->
									<ShipToLocationID>
										<!--SuppliersCode-->
										<SuppliersCode>
											<xsl:value-of select="CLO=/L2[1]/L3[2]"/>
										</SuppliersCode>
									</ShipToLocationID>
									<!--ShipToName-->
									<ShipToName>
										<xsl:value-of select="CLO=/L2[1]/L3[1]"/>
									</ShipToName>
									<!--ShipToAddress-->
									<ShipToAddress>
										<!--AddressLine1-->
										<AddressLine1>
											<xsl:value-of select="CLO=/L2[2]/L3[1]"/>
										</AddressLine1>
										<!--AddressLine2-->
										<xsl:if test="CLO=/L2[2]/L3[2] != ''">
											<AddressLine2>
												<xsl:value-of select="CLO=/L2[2]/L3[2]"/>
											</AddressLine2>
										</xsl:if>
										<!--AddressLine3-->
										<xsl:if test="CLO=/L2[2]/L3[3] != ''">
											<AddressLine3>
												<xsl:value-of select="CLO=/L2[2]/L3[3]"/>
											</AddressLine3>
										</xsl:if>
										<!--AddressLine4-->
										<xsl:if test="CLO=/L2[2]/L3[4] != ''">
											<AddressLine4>
												<xsl:value-of select="CLO=/L2[2]/L3[4]"/>
											</AddressLine4>
										</xsl:if>
										<!--PostCode-->
										<xsl:if test="CLO=/L2[2]/L3[5] != ''">
											<PostCode>
												<xsl:value-of select="CLO=/L2[2]/L3[5]"/>
											</PostCode>
										</xsl:if>
									</ShipToAddress>
								</ShipTo>
								<!--PurchaseOrderReferences-->
								<PurchaseOrderReferences>
									<!--PurchaseOrderReference-->
									<PurchaseOrderReference>
										<xsl:value-of select="AOR=/L2[1]/L3[1]"/>
									</PurchaseOrderReference>
									<!--PurchaseOrderDate-->
									<xsl:variable name="dtPODate" select="AOR=/L2[1]/L3[3]"/>
									<PurchaseOrderDate>
										<xsl:value-of select="concat('20', substring($dtPODate,1,2),'-', substring($dtPODate,3,2),'-',substring($dtPODate,5,2))"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
								<!--PurchaseOrderConfirmationReferences-->
								<PurchaseOrderConfirmationReferences>
									<!--PurchaseOrderConfirmationReference-->
									<!--We will use the Carlsberg UK PO Reference -->
									<PurchaseOrderConfirmationReference>
										<xsl:value-of select="AOR=/L2[1]/L3[2]"/>
									</PurchaseOrderConfirmationReference>
									<!--PurchaseOrderConfirmationDate-->
									<PurchaseOrderConfirmationDate>
										<xsl:value-of select="vbscript:sGetTodaysDate()"/>
									</PurchaseOrderConfirmationDate>
								</PurchaseOrderConfirmationReferences>
								<!--OrderedDeliveryDetails-->
								<!--DeliveryDate AQD:XDAT-->
								<xsl:variable name="dtOrdDelDate" select="AQD=/L2[5]/L3[1]"/>
								<xsl:if test="string($dtOrdDelDate) != '' ">
									<OrderedDeliveryDetails>
										<DeliveryDate>
											<xsl:value-of select="concat('20',substring($dtOrdDelDate,1,2),'-',substring($dtOrdDelDate,3,2),'-',substring($dtOrdDelDate,5,2))"/>
										</DeliveryDate>
									</OrderedDeliveryDetails>
								</xsl:if>
								<!--ConfirmedDeliveryDetails-->
								<xsl:variable name="sConDelDate" select="$dtOrdDelDate"/>
								<xsl:if test="string(sConDelDate) != '' ">
									<ConfirmedDeliveryDetails>
										<!--DeliveryDate-->
										<DeliveryDate>
											<xsl:value-of select="concat('20',substring($sConDelDate,1,2),'-',substring($sConDelDate,3,2),'-',substring($sConDelDate,5,2))"/>
										</DeliveryDate>
									</ConfirmedDeliveryDetails>
								</xsl:if>
							</PurchaseOrderConfirmationHeader>
							<!--PurchaseOrderConfirmationDetail-->
							<PurchaseOrderConfirmationDetail>
								<!--PurchaseOrderConfirmationLine-->
								<xsl:for-each select="ALD=">
									<!-- Current Confirmation Detail line -->
									<xsl:variable name="lCurALDLine" select="position()"/>
									<PurchaseOrderConfirmationLine>
										<!-- Carlsberg produces a number of reject codes. These are presented in a DNB following the line affected. Also
										they provide a line number so matching is reliable. We will detect for this code and apply as appriopiate.
										If no DNB is provided therefore the line is assumed to be accepted.
										-->
										<xsl:attribute name="LineStatus">
											<xsl:for-each select="//DNB=">
												<!-- Current Rejection line -->
												<xsl:variable name="lCurDNBLine" select="position()"/>
												<!-- Match to current ALD Line -->
												<xsl:if test="$lCurDNBLine = $lCurALDLine">
													<xsl:choose>
														<!-- Current REJECT code -->
														<xsl:variable name="lCurDNBRejectCode" select="L2[4]/L3[1]"/>
														<!-- Current REJECT narrative -->
														<xsl:variable name="lCurDNBNarative" select="L2[4]/L3[2]"/>
														<!-- Map -->
														<xsl:when test="string($lCurDNBRejectCode) !='' ">
															<xsl:text>Rejected</xsl:text>
														</xsl:when>
														<!-- No code therefore mark as accepted -->
														<xsl:otherwise>
															<xsl:text>Accepted</xsl:text>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:for-each>
										</xsl:attribute>
										<!--ProductID-->
										<ProductID>
											<xsl:variable name="sCurGTIN" select="L2[2]/L3[1]"/>
											<xsl:variable name="sCurSupCode" select="L2[2]/L3[2]"/>
											<!--GTIN-->
											<GTIN>
												<xsl:value-of select="$sCurGTI"/>
											</GTIN>
											<!--SuppliersProductCode-->
											<xsl:if test="string($sCurSupCode) !='' ">
												<SuppliersProductCode>
													<xsl:value-of select="$sCurSupCode"/>
												</SuppliersProductCode>
											</xsl:if>
										</ProductID>
										<!--xsl:if test="L2[4] != ''">
								<SubstitutedProductID>
									<SuppliersProductCode>
										<xsl:value-of select="L2[4]"/>
									</SuppliersProductCode>
								</SubstitutedProductID>
							</xsl:if-->
										<!--ProductDescription-->
										<ProductDescription>
											<xsl:value-of select="L2[7]/L3[1]"/>
										</ProductDescription>
										<!--OrderedQuantity-->
										<OrderedQuantity>
											<xsl:value-of select="L2[6]/L3[1]"/>
										</OrderedQuantity>
										<!--ConfirmedQuantity-->
										<ConfirmedQuantity>
											<xsl:value-of select="vbscript:sGetConfirmedQty(L2[6]/L3[1],L2[6]/L3[2])"/>
										</ConfirmedQuantity>
										<!--PackSize-->
										<xsl:if test="L2[5]/L3[1] != ''">
											<PackSize>
												<xsl:value-of select="L2[5]/L3[1]"/>
											</PackSize>
										</xsl:if>
										<!--UnitValueExclVAT-->
										<!--NOTE: Carlsberg do not provide pricing on confirmations -->
										<!--xsl:if test="L2[6]/L3[2] != ''">
											<UnitValueExclVAT>
												<xsl:value-of select="format-number(L2[6]/L3[1] div 10000,'#.0000')"/>
											</UnitValueExclVAT>
										</xsl:if-->
										<!--LineValueExclVAT-->
										<!--NOTE: Carlsberg do not provide pricing on confirmations -->
										<!--xsl:if test="L2[10] !=''">
											<LineValueExclVAT>
												<xsl:value-of select="format-number(L2[10],'0.00')"/>
											</LineValueExclVAT>
										</xsl:if-->
										<!--Narrative-->
										<xsl:for-each select="//DNB=">
											<!-- Current Rejection line -->
											<xsl:variable name="lCurDNBLine" select="position()"/>
											<!-- Match to current ALD Line -->
											<xsl:if test="$lCurDNBLine = $lCurALDLine">
												<!-- Current REJECT code -->
												<xsl:variable name="lCurDNBRejectCode" select="L2[4]/L3[1]"/>
												<!-- Current REJECT narrative -->
												<xsl:variable name="lCurDNBNarative" select="concat('Carlsberg Code: ',$lCurDNBRejectCode,' ',L2[4]/L3[2])"/>
												<!-- Map -->
												<xsl:if test="string($lCurDNBRejectCode) !='' ">
													<Narrative>
														<xsl:value-of select="$lCurDNBNarative"/>
													</Narrative>
												</xsl:if>
											</xsl:if>
										</xsl:for-each>
									</PurchaseOrderConfirmationLine>
								</xsl:for-each>
							</PurchaseOrderConfirmationDetail>
							<!--PurchaseOrderConfirmationTrailer-->
							<PurchaseOrderConfirmationTrailer>
								<!--NumberOfLines-->
								<NumberOfLines>
									<xsl:choose>
										<xsl:when test="string(KTR=/L2[1]) !=''">
											<xsl:value-of select="KTR=/L2[1]"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="count(ALD=)"/>
										</xsl:otherwise>
									</xsl:choose>
								</NumberOfLines>
								<!--TotalExclVAT-->
								<!--NOTE: Carlsberg do not provide pricing on confirmations -->
								<!--xsl:if test="string(KTR=/L2[2]) !=''">
									<TotalExclVAT>
										<xsl:value-of select="KTR=/L2[2]"/>
									</TotalExclVAT>
								</xsl:if-->
							</PurchaseOrderConfirmationTrailer>
						</PurchaseOrderConfirmation>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
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
		
		'	------------------------------------------------------------------
		' FUNCTION:	To rreturn the confirmed qty by calculating from the 
		'					ALD:OQTY and the ALD:OUBA.
		'					Nigel Emsen, June 2007
		'	------------------------------------------------------------------
		Function sGetConfirmedQty(vsOQTY,vsOUBA)
		
			Dim sResult
			Dim lOQTY
			Dim lOUBA
			Dim lResult
			
			if vsOQTY="" Then vsOQTY="0"
			lOQTY=CLng(vsOQTY)

			if vsOUBA="" then vsOUBA="0"
			lOUBA=CLng(vsOUBA)

			lResult=lOQTY-lOUBA
			sResult=CStr(lResult)

			sGetConfirmedQty=sResult
			
		End Function
		
		

	]]></msxsl:script>
</xsl:stylesheet>
