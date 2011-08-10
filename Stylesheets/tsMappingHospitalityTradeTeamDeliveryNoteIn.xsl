<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 	Input:	the intermidate XML produced by tsProcessorLPCSFIDeliveryMapIn
 	Output: 	a delivery note batch 

 © Alternative Business Solutions Ltd, 2005.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date			| Name 			| Description of modification
==========================================================================================
 28/10/2005		| R Cambridge	| H522 Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 02/12/2005 	| Lee Boyton  	| H522. Map Supplier's ANA to SuppliersCode for
                          					| consistency with invoices and credit note documents.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 25/11/2005		| R Cambridge	| H522 Changed input can be output of FF2XML
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 30/11/2005		| A Sheppard	| H522. Removed unallocated line
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 28/06/2011		| R Cambridge	| FB4571 Set UnitValueExclVAT to 0.00 if it would be blank
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 10/08/2011  		| K Oshaughnessy| FB4700 Delivery date hack 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          		| 					| 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="msxsl" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/">

		<BatchRoot>
	
			<Batch>
				<TradeSimpleHeader>
					<SendersCodeForRecipient><xsl:value-of select="/Batch/BatchDocuments/BatchDocument/DeliveryNote/SendersCodeForRecipient"/></SendersCodeForRecipient>
				</TradeSimpleHeader>
				<BatchDocuments>
				
				
					<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/DeliveryNote">
				
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
							<DeliveryNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
								</TradeSimpleHeader>
								<DeliveryNoteHeader>
								
									<Buyer>
										<BuyersLocationID>
											<GLN><xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/></GLN>
										</BuyersLocationID>
									</Buyer>
									
									<Supplier>
										<SuppliersLocationID>
											<GLN><xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/></GLN>
											<SuppliersCode><xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/></SuppliersCode>
										</SuppliersLocationID>
									</Supplier>
									
									<ShipTo>
										<ShipToLocationID>
											<GLN>5555555555555</GLN>
											<SuppliersCode><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SuppliersCode>
										</ShipToLocationID>
										<ShipToName><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToName"/></ShipToName>
										<ShipToAddress>
											<xsl:for-each select="DeliveryNoteHeader/ShipTo/ShipToAddress/*[. != '']">
												<xsl:element name="{concat('AddressLine',string(position()))}">
													<xsl:value-of select="."/>
												</xsl:element>										
											</xsl:for-each>									
										</ShipToAddress>
									</ShipTo>
									
									<xsl:variable name="sDocumentDate">
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:variable name="sDeliveryDate">
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
										</xsl:call-template>
									</xsl:variable>
									
									<PurchaseOrderReferences>
										<PurchaseOrderReference>
											<xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
										</PurchaseOrderReference>
										<PurchaseOrderDate>
											<xsl:choose>
												<xsl:when test="/DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate != '' ">
													<xsl:call-template name="msFormatDate">
														<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
													</xsl:call-template>
												</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$sDocumentDate"/>
											</xsl:otherwise>	
											</xsl:choose>
										</PurchaseOrderDate>
									</PurchaseOrderReferences>
															
									<DeliveryNoteReferences>
										<DeliveryNoteReference>
											<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
										</DeliveryNoteReference>
										<DeliveryNoteDate>
											<xsl:value-of select="script:msDeliveryDayFridayManipulation(string($sDeliveryDate))"/>
										</DeliveryNoteDate>
										<DespatchDate>
											<xsl:choose>
												<xsl:when test="DeliveryNoteHeader/DeliveryNoteReferences/DespatchDate != '' ">
													<xsl:call-template name="msFormatDate">
														<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveryNoteReferences/DespatchDate"/>
													</xsl:call-template>
												</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$sDeliveryDate"/>
											</xsl:otherwise>	
											</xsl:choose>
										</DespatchDate>
									</DeliveryNoteReferences>
									
									<DeliveredDeliveryDetails>
										<DeliveryDate>
											<xsl:value-of select="script:msDeliveryDayFridayManipulation(string($sDeliveryDate))"/>
										</DeliveryDate>
									</DeliveredDeliveryDetails>
									
								</DeliveryNoteHeader>
								
								<DeliveryNoteDetail>
															
									<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">								
									
										<DeliveryNoteLine>
										
											<ProductID>
												<GTIN>5555555555555</GTIN>
												<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
											</ProductID>
											
											<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>
											
											<xsl:variable name="sQuantity">
												<xsl:if test="string(OrderedQuantity) = 'C'">-</xsl:if>
												<xsl:value-of select="DespatchedQuantity"/>
											</xsl:variable>
											
											<OrderedQuantity UnitOfMeasure="EA"><xsl:value-of select="$sQuantity"/></OrderedQuantity>
											<ConfirmedQuantity UnitOfMeasure="EA"><xsl:value-of select="$sQuantity"/></ConfirmedQuantity>
											<DespatchedQuantity UnitOfMeasure="EA"><xsl:value-of select="$sQuantity"/></DespatchedQuantity>
											
											<!-- 4571 Don't create UnitValueExclVAT if it would be blank 
													(corrected name of source element too)
											-->
											<UnitValueExclVAT>
												<xsl:choose>
													<xsl:when test="UnitValueExclVAT != ''">
														<xsl:value-of select="."/>
													</xsl:when>
													<xsl:otherwise>0.00</xsl:otherwise>
												</xsl:choose>
											</UnitValueExclVAT>											
			
											<LineExtraData>
												<IsStockProduct>1</IsStockProduct>
											</LineExtraData>																					
											
										</DeliveryNoteLine>
			
									</xsl:for-each>
									
								</DeliveryNoteDetail>
								<DeliveryNoteTrailer>
									<NumberOfLines><xsl:value-of select="count(DeliveryNoteDetail/DeliveryNoteLine)"/></NumberOfLines>
								</DeliveryNoteTrailer>
							</DeliveryNote>
						</BatchDocument>
												
					</xsl:for-each>
						
				</BatchDocuments>
			</Batch>
			
		</BatchRoot>
	
	</xsl:template>
	
<!--=======================================================================================
  Routine		:msFormateDate()
  Description	:
  Inputs		: vsUTCDate
  Outputs		:
  Returns		:A string
  Author		:Katherine OShaughnessy
  Version		:1.0
  Alterations	:(none)
 =======================================================================================-->	
	
	<xsl:template name="msFormatDate">
		<xsl:param name="vsYYMMDD"/>
		
		<xsl:value-of select="concat('20',substring($vsYYMMDD,1,2),'-',substring($vsYYMMDD,3,2),'-',substring($vsYYMMDD,5,2))"/>
		
	</xsl:template>
							
<!--=======================================================================================
  Routine		: CalculateDeliveryDate()
  Description	:  
  Inputs		: 
  Outputs		: 
  Returns		: A string
  Author		: Katherine OShaughnessy
  Version		: 1.0
  Alterations	: (none)
 =======================================================================================-->		
 
<msxsl:script language="VBScript" implements-prefix="script"><![CDATA[
	Function msDeliveryDayFridayManipulation(docDate)
	
		Dim dayOfWeek
		Dim dtDate 
		Dim sDate
		Dim sMonth
		Dim sYear
		
		dayOfWeek = Weekday(docDate)
		
		If  dayOfWeek = 6 Then 
					
			dtDate = DateAdd("d",3,docDate)
			sDate = Day(dtDate)
			If (sDate<10) Then 			
				sDate ="0" & sDate
			End If 
		
			sMonth = Month(dtDate)
			If (sMonth<10) Then 
				sMonth ="0" & sMonth
			End If 					
		
			sYear  = Year(dtDate)
		
			msDeliveryDayFridayManipulation = sYear & "-" & sMonth &"-"& sDate
		
		ElseIf	dayOfWeek = 7 Then
		
			dtDate = DateAdd("d",2,docDate)
			sDate = Day(dtDate)
			If (sDate<10) Then 			
				sDate ="0" & sDate
			End If 
		
			sMonth = Month(dtDate)
			If (sMonth<10) Then 
				sMonth ="0" & sMonth
			End If 					
		
			sYear  = Year(dtDate)
		
			msDeliveryDayFridayManipulation = sYear & "-" & sMonth &"-"& sDate
			
		Else
			msDeliveryDayFridayManipulation= docDate
		End If

	End Function

]]>		
</msxsl:script>						

</xsl:stylesheet>
