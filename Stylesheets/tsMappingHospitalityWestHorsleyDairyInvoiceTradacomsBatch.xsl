<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:blah="http://blah.blah.blah" 
										 xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://blah.blah.blah"
										 exclude-result-prefixes="blah msxsl vbscript">

	<blah:Days>
		<blah:Day>0</blah:Day>
		<blah:Day>1</blah:Day>
		<blah:Day>2</blah:Day>
		<blah:Day>3</blah:Day>
		<blah:Day>4</blah:Day>
		<blah:Day>5</blah:Day>
		<blah:Day>6</blah:Day>
	</blah:Days>
	
	<xsl:variable name="msProductType_Discrete" select="'Discrete'"/>
	<xsl:variable name="msProductType_Catchweight" select="'Catchweight'"/>

	<xsl:template match="/">
	
		<BatchRoot>
	
			<Batch>
			
				<!--BatchHeader>
					<DocumentTotalExclVAT><xsl:value-of select="format-number(number(/Batch/BatchHeader/DocumentTotalExclVAT) div 100, '0.00')"/></DocumentTotalExclVAT>
					<SettlementTotalExclVAT><xsl:value-of select="format-number(number(/Batch/BatchHeader/SettlementTotalExclVAT) div 100, '0.00')"/></SettlementTotalExclVAT>
					<VATAmount><xsl:value-of select="format-number(number(/Batch/BatchHeader/VATAmount) div 100, '0.00')"/></VATAmount>
					<DocumentTotalInclVAT><xsl:value-of select="format-number(number(/Batch/BatchHeader/DocumentTotalInclVAT) div 100, '0.00')"/></DocumentTotalInclVAT>
					<SettlementTotalInclVAT><xsl:value-of select="format-number(number(/Batch/BatchHeader/SettlementTotalInclVAT) div 100, '0.00')"/></SettlementTotalInclVAT>
				</BatchHeader-->
				
				<BatchDocuments>
				
					<xsl:for-each select="/Batch/BatchDocuments/BatchDocument">
				
						<BatchDocument>
							<Invoice>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="Invoice/TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
								</TradeSimpleHeader>
								<InvoiceHeader>
									<BatchInformation>
										<FileCreationDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="Invoice/InvoiceHeader/BatchInformation/FileCreationDate"/>
											</xsl:call-template>
										</FileCreationDate>
										<SendersTransmissionReference><xsl:value-of select="Invoice/InvoiceHeader/BatchInformation/SendersTransmissionReference"/></SendersTransmissionReference>
										<SendersTransmissionDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="Invoice/InvoiceHeader/BatchInformation/SendersTransmissionDate"/>
											</xsl:call-template>
											<xsl:text>T00:00:00</xsl:text>
										</SendersTransmissionDate>
									</BatchInformation>
									<Buyer>
										<BuyersLocationID>
											<SuppliersCode><xsl:value-of select="Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/></SuppliersCode>
										</BuyersLocationID>
									</Buyer>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode><xsl:value-of select="Invoice/InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SuppliersCode>
										</ShipToLocationID>
									</ShipTo>
									<InvoiceReferences>
										<InvoiceReference><xsl:value-of select="Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/></InvoiceReference>
										<InvoiceDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
											</xsl:call-template>
										</InvoiceDate>
										<TaxPointDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate"/>
											</xsl:call-template>
										</TaxPointDate>
									</InvoiceReferences>
								</InvoiceHeader>
								
								<InvoiceDetail>
								
									<!-- For each product listed... -->
									<xsl:for-each select="Invoice/InvoiceDetail/InvoiceLine[position()=1 or (ProductID/SuppliersProductCode != preceding-sibling::*[1]/ProductID/SuppliersProductCode)]">
									
											<xsl:call-template name="createAgregateLine">
												<xsl:with-param name="vobjLine" select="."/>
												<xsl:with-param name="vobjFollowingLine" select="following-sibling::*[1]"/>
											</xsl:call-template>											
											
											<!--xsl:call-template name="createLinesPerDelivery">
												<xsl:with-param name="vobjLine" select="."/>
												<xsl:with-param name="vobjFollowingLine" select="following-sibling::*[1]"/>
											</xsl:call-template-->			
										
									</xsl:for-each>
																		
								</InvoiceDetail>
								
								<InvoiceTrailer>
									<VATSubTotals>
									
										<xsl:for-each select="Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal">
									
											<VATSubTotal>
												<xsl:attribute name="VATCode"><xsl:value-of select="@VATCode"/></xsl:attribute>
												<xsl:attribute name="VATRate"><xsl:value-of select="format-number(number(@VATRate) div 100,'0.#')"/></xsl:attribute>
												<DocumentTotalExclVATAtRate><xsl:value-of select="format-number(number(DocumentTotalExclVATAtRate) div 100,'0.00')"/></DocumentTotalExclVATAtRate>
												<!--SettlementDiscountAtRate><xsl:value-of select="format-number(number(SettlementDiscountAtRate) div 100,'0.00')"/></SettlementDiscountAtRate>
												<SettlementTotalExclVATAtRate><xsl:value-of select="format-number(number(SettlementTotalExclVATAtRate) div 100,'0.00')"/></SettlementTotalExclVATAtRate-->
												<VATAmountAtRate><xsl:value-of select="format-number(number(VATAmountAtRate) div 100,'0.00')"/></VATAmountAtRate>
											</VATSubTotal>
	
										</xsl:for-each>
										
									</VATSubTotals>
									
									<DocumentTotalExclVAT><xsl:value-of select="format-number(number(Invoice/InvoiceTrailer/DocumentTotalExclVAT) div 100,'0.00')"/></DocumentTotalExclVAT>
									<!--SettlementTotalExclVAT><xsl:value-of select="format-number(number(Invoice/InvoiceTrailer/SettlementTotalExclVAT) div 100,'0.00')"/></SettlementTotalExclVAT-->
									<VATAmount><xsl:value-of select="format-number(number(Invoice/InvoiceTrailer/VATAmount) div 100,'0.00')"/></VATAmount>
									<DocumentTotalInclVAT><xsl:value-of select="format-number(number(Invoice/InvoiceTrailer/DocumentTotalInclVAT) div 100,'0.00')"/></DocumentTotalInclVAT>
									<!--SettlementTotalInclVAT><xsl:value-of select="format-number(number(Invoice/InvoiceTrailer/SettlementTotalInclVAT) div 100,'0.00')"/></SettlementTotalInclVAT-->
								</InvoiceTrailer>
							</Invoice>
							
						</BatchDocument>
	
					</xsl:for-each>
	
				</BatchDocuments>
				
			</Batch>
			
		</BatchRoot>
	
	</xsl:template>
	
	
	<xsl:template name="createAgregateLine">
		<xsl:param name="vobjLine"/>
		<xsl:param name="vobjFollowingLine"/>
	
			
		<InvoiceLine>	
		
			<!-- Declarations -->
			<!-- ============ -->			
		
			<!-- ...work out if this is a catchweight (represented as two lines in inbound file and XML)... -->
			<xsl:variable name="sProductType">
				<xsl:choose>
					<!--xsl:when test=" ($vobjLine/ProductID/SuppliersProductCode != $vobjFollowingLine/ProductID/SuppliersProductCode) or count($vobjLine/following-sibling::*)=0"-->
					<xsl:when test=" ($vobjLine/ProductID/SuppliersProductCode != $vobjFollowingLine/ProductID/SuppliersProductCode) or count($vobjFollowingLine/*)=0">
						<xsl:value-of select="$msProductType_Discrete"/>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:value-of select="$msProductType_Catchweight"/>
					</xsl:otherwise>
					
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="sCatchweightData">
				<xsl:choose>
					<xsl:when test="$sProductType = $msProductType_Discrete"/>												
					<!-- Catchweight quantities are on the subsequent line -->
					<xsl:otherwise>
						<xsl:value-of select="$vobjFollowingLine/ProductID/BuyersProductCode"/>
					</xsl:otherwise>												
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="sLineValue">
			
				<xsl:choose>
					<xsl:when test="$sProductType = $msProductType_Discrete">
						<xsl:value-of select="format-number(LineValueExclVAT div 10000, '0.00')"/>	
					</xsl:when>		
															
					<xsl:otherwise>
						<xsl:value-of select="format-number(substring($sCatchweightData,122,9) div 10000, '0.00')"/>					
					</xsl:otherwise>												
				</xsl:choose>
				
			</xsl:variable>

																
			<xsl:variable name="sQuantity">
				<xsl:choose>
					<xsl:when test="$sProductType = $msProductType_Discrete">
						<xsl:value-of select="number($vobjLine/InvoicedQuantity)"/>							
					</xsl:when>										
							
					<xsl:otherwise>
						<xsl:value-of select="format-number(substring($sCatchweightData,92,13) div 1000, '0.0000')"/>						
					</xsl:otherwise>												
					
				</xsl:choose>													
			</xsl:variable>
			
			<xsl:variable name="sUoM">
				<xsl:choose>
					<xsl:when test="$sProductType = $msProductType_Discrete">CS</xsl:when>												
					<xsl:otherwise>KGM</xsl:otherwise>												
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="sUnitPrice">
				<xsl:choose>
					<xsl:when test="$sProductType = $msProductType_Discrete">
						<xsl:value-of select="format-number(number($vobjLine/UnitValueExclVAT) div 1000000, '0.0000')"/>
					</xsl:when>												
					<xsl:otherwise>
						<xsl:value-of select="format-number(substring($sCatchweightData,115,7) div 1000, '0.0000')"/>
					</xsl:otherwise>												
				</xsl:choose>													
			</xsl:variable>			

			<!-- ============ -->
			<!--              -->
		
			<!-- Output -->
			<!-- ====== -->
			
			<ProductID>
				<SuppliersProductCode><xsl:value-of select="$vobjLine/ProductID/SuppliersProductCode"/></SuppliersProductCode>
			</ProductID>
			
			
			<ProductDescription><xsl:value-of select="$vobjLine/ProductDescription"/></ProductDescription>												
			
			<InvoicedQuantity>			
				<xsl:attribute name="UnitOfMeasure">
					<xsl:value-of select="$sUoM"/>
				</xsl:attribute>
				
				<xsl:value-of select="$sQuantity"/>				
			</InvoicedQuantity>			
			
			<UnitValueExclVAT>
				<xsl:value-of select="$sUnitPrice"/>														
			</UnitValueExclVAT>			
			
			<LineValueExclVAT>
				<xsl:value-of select="$sLineValue"/>				
			</LineValueExclVAT>			
			
			<VATCode>
				<xsl:choose>
					<xsl:when test="$sProductType = $msProductType_Discrete">
						<xsl:value-of select="$vobjLine/VATCode"/>
					</xsl:when>												
					<xsl:otherwise>
						<xsl:value-of select="substring($sCatchweightData,131,1)"/>
					</xsl:otherwise>												
				</xsl:choose>
			</VATCode>			
			
			<Measure>
				<TotalMeasureIndicator><xsl:value-of select="$sUoM"/></TotalMeasureIndicator>
			</Measure>
			
			
		</InvoiceLine>
	
	</xsl:template>
	
	
	
	
	
	<xsl:template name="createLinesPerDelivery">
		<xsl:param name="vobjLine"/>
		<xsl:param name="vobjFollowingLine"/>
	
	
		<xsl:variable name="objLine" select="."/>

		<xsl:variable name="sDeliveryReferences" select="Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:variable name="sDeliveryDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="sDate" select="Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
			</xsl:call-template>
		</xsl:variable>
									
		<!-- ...work out if this is a catchweight (represented as two lines in inbound file and XML)... -->
		<xsl:variable name="sProductType">
			<xsl:choose>
				<xsl:when test=" ($vobjLine/ProductID/SuppliersProductCode != $vobjFollowingLine/ProductID/SuppliersProductCode) or count($vobjFollowingLine/*)=0">
					<xsl:value-of select="$msProductType_Discrete"/>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:value-of select="$msProductType_Catchweight"/>
				</xsl:otherwise>
				
			</xsl:choose>
		</xsl:variable>
		
		<!-- ...get the strings of delivery/quantity information from the appropraite place... -->
		
		<xsl:variable name="sQuantities">
			<xsl:choose>
				<xsl:when test="$sProductType = $msProductType_Discrete">
					<xsl:value-of select="$vobjLine/InvoicedQuantity"/>
				</xsl:when>												
				<!-- Catchweight quantities are on the subsequent line -->
				<xsl:otherwise>
					<xsl:value-of select="concat($vobjFollowingLine/ProductDescription, $vobjFollowingLine/InvoicedQuantity)"/>
				</xsl:otherwise>												
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="nQuantityFieldSize">
			<xsl:choose>
				<xsl:when test="$sProductType = $msProductType_Discrete">6</xsl:when>
				<!-- Catchweight fields are wider -->												
				<xsl:otherwise>13</xsl:otherwise>												
			</xsl:choose>										
		</xsl:variable>
		
	
		<xsl:for-each select="document('')/*/blah:Days/blah:Day">
			
			<xsl:variable name="nDayOfWeek" select="number(.)"></xsl:variable>
			
			<xsl:variable name="sDeliveryRef">
				<xsl:call-template name="getTextField">
					<xsl:with-param name="sString" select="$sDeliveryReferences"/>
					<xsl:with-param name="nFieldWidth" select="17"/>
					<xsl:with-param name="nFieldNo" select="$nDayOfWeek"/>
					<xsl:with-param name="nOffset" select="8"/>
				</xsl:call-template>								
			</xsl:variable>
			
			<xsl:variable name="nQuantity">
				<xsl:call-template name="getTextField">
					<xsl:with-param name="sString" select="$sQuantities"/>
					<xsl:with-param name="nFieldWidth" select="$nQuantityFieldSize"/>
					<xsl:with-param name="nFieldNo" select="$nDayOfWeek"/>
				</xsl:call-template>
			</xsl:variable>
			
			
										
			<!-- Construct a line for each day of the week that the product was delivered -->
			<xsl:if test="$sDeliveryRef != '' and number($nQuantity) &gt; 0">
			
				<InvoiceLine>		
									
																		
					<!-- Declarations -->
					<xsl:variable name="sQuantity">
						<xsl:choose>
							<xsl:when test="$sProductType = $msProductType_Discrete">
								<xsl:value-of select="number($nQuantity)"/>
							</xsl:when>												
							<xsl:otherwise>
								<xsl:value-of select="format-number($nQuantity div 10000, '0.0000')"/>
							</xsl:otherwise>												
						</xsl:choose>													
					</xsl:variable>
					
					<xsl:variable name="sUoM">
						<xsl:choose>
							<xsl:when test="$sProductType = $msProductType_Discrete">CS</xsl:when>												
							<xsl:otherwise>KGM</xsl:otherwise>												
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="sUnitPrice">
						<xsl:choose>
							<xsl:when test="$sProductType = $msProductType_Discrete">
								<xsl:value-of select="format-number(number($vobjLine/UnitValueExclVAT) div 1000000, '0.0000')"/>
							</xsl:when>												
							<xsl:otherwise>
								<xsl:value-of select="format-number(substring($sQuantities,115,7) div 100, '0.0000')"/>
							</xsl:otherwise>												
						</xsl:choose>													
					</xsl:variable>
				
					<!-- Output -->
					<DeliveryNoteReferences>
						<DeliveryNoteReference><xsl:value-of select="$sDeliveryRef"/></DeliveryNoteReference>
						<DeliveryNoteDate><xsl:value-of select="vbscript:addDays(string($sDeliveryDate), $nDayOfWeek)"/></DeliveryNoteDate>													
					</DeliveryNoteReferences>
					
					
					<ProductID>
						<SuppliersProductCode><xsl:value-of select="$vobjLine/ProductID/SuppliersProductCode"/></SuppliersProductCode>
					</ProductID>
					
					
					<ProductDescription><xsl:value-of select="$vobjLine/ProductDescription"/></ProductDescription>												
					
					<InvoicedQuantity>
					
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="$sUoM"/>
						</xsl:attribute>
						
						<xsl:value-of select="$sQuantity"/>
						
					</InvoicedQuantity>
					
					
					<UnitValueExclVAT>
						<xsl:value-of select="$sUnitPrice"/>														
					</UnitValueExclVAT>
					
					
					<LineValueExclVAT>
						<xsl:value-of select="format-number($sQuantity * $sUnitPrice, '0.00')"/>
					</LineValueExclVAT>
					
					
					<VATCode>
						<xsl:choose>
							<xsl:when test="$sProductType = $msProductType_Discrete">
								<xsl:value-of select="$vobjLine/VATCode"/>
							</xsl:when>												
							<xsl:otherwise>
								<xsl:value-of select="substring($sQuantities,131,1)"/>
							</xsl:otherwise>												
						</xsl:choose>
					</VATCode>
					
					
					<Measure>
						<TotalMeasureIndicator><xsl:value-of select="$sUoM"/></TotalMeasureIndicator>
					</Measure>
					
					
				</InvoiceLine>
													
			</xsl:if>
							
			
		</xsl:for-each>
	
	
	</xsl:template>


	
	
	
	<xsl:template name="formatDate">
		<xsl:param name="sDate"/>
	
		<xsl:value-of select="concat('20',substring($sDate,1,2), '-', substring($sDate,3,2), '-', substring($sDate,5,2))"/>
	
	</xsl:template>
	
	
	
	<xsl:template name="getTextField">
		<xsl:param name="sString"/>
		<xsl:param name="nFieldWidth"/>
		<xsl:param name="nFieldNo"/>
		<xsl:param name="nOffset" select="0"/>
	
		<xsl:value-of select="translate(substring($sString, $nOffset + ($nFieldWidth * $nFieldNo) + 1, $nFieldWidth),' ','')"/>
	
	</xsl:template>

	<!-- Alas..... -->
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 
		Function addDays(sDate, nDaysToAdd)
		
			addDays = DateAdd("d", nDaysToAdd, sDate)
			addDays = Right(addDays , 4) & "-" & Mid(addDays , 4, 2) & "-" & Left(addDays , 2)
		
		End Function		
	]]></msxsl:script>

</xsl:stylesheet>
