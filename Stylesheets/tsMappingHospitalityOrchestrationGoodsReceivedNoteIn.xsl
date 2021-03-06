<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
	Converts MGR PendingDeliverySubmitted XML into initial version of TS GRN internal XML

==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 2016-09-02	| R Cambridge		| US13171 FB11284 Created
==========================================================================================
 2016-09-21	| R Cambridge		| US13171 FB11284 Wrap GRN in batch tags to allow use of default GRN routing 
                                                  set document-level SCR with new sSitesCodeForSupplier parameter
                                                  don't create order quantity if UoM is not provided
==========================================================================================
 2016-10-04	| S Sehgal		| 		US21645 Populate the GRN Reference from the PendingDeliverySubmitted XML
==========================================================================================
 2018-02-02	| R Cambridge		| D20420 Ensure UoMs are valid, invalid values converted to EA
                                         Defensively limit product code and product description to 255 chars (a limit for succesful processing in tsProcessorXMLExtract)
==========================================================================================
 2018-04-03	| S Sehgal		| US48371 Set the received quantity as the Delivered quantity
==========================================================================================
           	|            		| 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl script msxsl">
	<xsl:output method="xml" />
	
	<xsl:param name="sSendersBranchReference" select="'0'"/>
	<xsl:param name="sBuyersCodeForSupplier" select="'0ho'"/>
	<xsl:param name="sSitesCodeForSupplier" select="'0s'"/>
	<xsl:param name="sPOReference" select="'0'"/>
	<xsl:param name="sPODate" select="'0'"/>
	<xsl:param name="sGRNReference" select="'0'"/>
	
	<xsl:variable name="CurrentDate" select="script:msGetTodaysDate()"/>
	
	<xsl:template match="/PendingDeliverySubmitted">
	
		<Batch>
			<TradeSimpleHeader>
				<SendersCodeForRecipient>
					<xsl:value-of select="$sBuyersCodeForSupplier"/>
				</SendersCodeForRecipient>
			</TradeSimpleHeader>
			<BatchDocuments>
				<BatchDocument DocumentTypeNo="85">			
			
					<GoodsReceivedNote>
					
						<TradeSimpleHeader>
							<SendersCodeForRecipient>
								<xsl:value-of select="$sSitesCodeForSupplier"/>
							</SendersCodeForRecipient>
							<SendersBranchReference>
								<xsl:value-of select="$sSendersBranchReference"/>
							</SendersBranchReference>
						</TradeSimpleHeader>
						
						<GoodsReceivedNoteHeader>
							<ShipTo>
								<ShipToName>
									<xsl:value-of select="Lines/Outlets/OutletName"/>
								</ShipToName>
							</ShipTo>
							<PurchaseOrderReferences>
								<PurchaseOrderReference><xsl:value-of select="$sPOReference"/></PurchaseOrderReference>
								<PurchaseOrderDate><xsl:value-of select="$sPODate"/></PurchaseOrderDate>
							</PurchaseOrderReferences>
							<DeliveryNoteReferences>
							<xsl:choose>
										<xsl:when test="Note/DeliveryNoteNumber">
											<xsl:choose>
												<xsl:when test="string-length(Note/DeliveryNoteNumber) > 0">
													<DeliveryNoteReference><xsl:value-of select="Note/DeliveryNoteNumber"/></DeliveryNoteReference>
													<DeliveryNoteDate><xsl:value-of select="$CurrentDate"/></DeliveryNoteDate>
												</xsl:when>
												<xsl:otherwise>								
													<DeliveryNoteReference><xsl:value-of select="$sPOReference"/></DeliveryNoteReference>
													<DeliveryNoteDate><xsl:value-of select="$sPODate"/></DeliveryNoteDate>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>								
											<DeliveryNoteReference><xsl:value-of select="$sPOReference"/></DeliveryNoteReference>
											<DeliveryNoteDate><xsl:value-of select="$sPODate"/></DeliveryNoteDate>
										</xsl:otherwise>
									</xsl:choose>
							</DeliveryNoteReferences>
							<GoodsReceivedNoteReferences>
								<GoodsReceivedNoteReference>
									<xsl:choose>
										<xsl:when test="Note/DeliveryNoteNumber">
											<xsl:choose>
												<xsl:when test="string-length(Note/DeliveryNoteNumber) > 0"><xsl:value-of select="Note/DeliveryNoteNumber"/></xsl:when>
												<xsl:otherwise><xsl:value-of select="$sPOReference"/></xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise><xsl:value-of select="$sPOReference"/></xsl:otherwise>
									</xsl:choose>
								</GoodsReceivedNoteReference>
								<GoodsReceivedNoteDate><xsl:value-of select="$CurrentDate"/></GoodsReceivedNoteDate>
							</GoodsReceivedNoteReferences>
							<DeliveredDeliveryDetails>
								<DeliveryDate>
									<xsl:value-of select="substring(PlannedDeliveryDate,1,10)"/>
								</DeliveryDate>
							</DeliveredDeliveryDetails>
							<ReceivedDeliveryDetails>
								<DeliveryDate>
									<xsl:value-of select="substring(ActualDeliveryDate,1,10)"/>
								</DeliveryDate>
							</ReceivedDeliveryDetails>
						</GoodsReceivedNoteHeader>
						
						<GoodsReceivedNoteDetail>
						
							<xsl:for-each select="Lines">
							
								<GoodsReceivedNoteLine>
								
									<ProductID>
										<SuppliersProductCode>
											<xsl:value-of select="substring(ProductNumber, 1, 255)"/>
										</SuppliersProductCode>
									</ProductID>
									
									<ProductDescription>
										<xsl:value-of select="substring(ProductDescription, 1, 255)"/>
									</ProductDescription>
									
									<xsl:if test="OrderUnit != '' and OrderedQuantity != ''">
										<OrderedQuantity>
											<xsl:attribute name="UnitOfMeasure">
												<xsl:call-template name="translateUoM">
													<xsl:with-param name="inputUoM" select="OrderUnit"/>
												</xsl:call-template>
											</xsl:attribute>
											<xsl:value-of select="OrderedQuantity"/>
										</OrderedQuantity>
									</xsl:if>		
									<DeliveredQuantity>
										<xsl:attribute name="UnitOfMeasure">
											<xsl:call-template name="translateUoM">
												<xsl:with-param name="inputUoM" select="ReceivedUnit"/>
											</xsl:call-template>
										</xsl:attribute>
										<xsl:value-of select="ReceivedQuantity"/>
									</DeliveredQuantity>
																
									<AcceptedQuantity>
										<xsl:attribute name="UnitOfMeasure">
											<xsl:call-template name="translateUoM">
												<xsl:with-param name="inputUoM" select="ReceivedUnit"/>
											</xsl:call-template>
										</xsl:attribute>
										<xsl:value-of select="ReceivedQuantity"/>
									</AcceptedQuantity>
									
									<!--PackSize>Pack</PackSize-->
									
									<UnitValueExclVAT>
										<xsl:value-of select="format-number(ReceivedUnitPrice, '0.##')"/>
									</UnitValueExclVAT>
									
								</GoodsReceivedNoteLine>
								
							</xsl:for-each>
							
						</GoodsReceivedNoteDetail>

						
						<GoodsReceivedNoteTrailer>
							<TotalExclVAT>
								<xsl:value-of select="Cost"/>
							</TotalExclVAT>
						</GoodsReceivedNoteTrailer>
						
					</GoodsReceivedNote>
					
		
				</BatchDocument>
			</BatchDocuments>
		</Batch>
			
	</xsl:template>
	
	<xsl:template name="translateUoM">
		<xsl:param name="inputUoM"/>
		
		<xsl:variable name="validUoMs" select="'|EA|CS|KGM|GRM|PND|ONZ|GLI|LTR|OZI|PTI|PTN|001|DZN|PF|PR|HUR|'"/>
		
		<xsl:variable name="inputUoM_UpperCase" select="translate($inputUoM, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
		
		<xsl:choose>
			<xsl:when test="contains($validUoMs, concat('|',$inputUoM_UpperCase,'|'))">
				<xsl:value-of select="$inputUoM_UpperCase"/>
			</xsl:when>
			<xsl:otherwise>EA</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : msGetTodaysDate
		' Description 	 : Gets todays date, formatted to yyyy-mm-dd
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : Rave Tech, 26/11/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msGetTodaysDate()
		{
			var dtDate = new Date();
			
			var sDate = dtDate.getDate();
			if(sDate<10)
			{
				sDate = '0' + sDate;
			}
			
			var sMonth = dtDate.getMonth() + 1;
			if(sMonth<10)
			{
				sMonth = '0' + sMonth;
			}
						
			var sYear  = dtDate.getYear() ;
			
		
			return sYear + '-'+ sMonth +'-'+ sDate;
		}
	]]></msxsl:script>
</xsl:stylesheet>
