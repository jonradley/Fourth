<!--********************************************************************
Date		|	owner				|	details
************************************************************************
21/06/2012| KOshaughnessy	| Created FB5542
************************************************************************
05/06/2012|KOshaughnessy	| FB 5562 - bugfix to PO reference
************************************************************************
			|						|			
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:egs="urn:eGS:marketplace:eBIS:Extension:1.0">
	<xsl:output method="xml"/>
	<xsl:template match="/Batch">

		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<xsl:for-each select="Invoice">
							<Invoice>
							
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="Delivery/DeliverTo/Location"/>
									</SendersCodeForRecipient>
								</TradeSimpleHeader>
								
								<InvoiceHeader>
									<!--Always Original-->
									<DocumentStatus>
										<xsl:text>Original</xsl:text>
									</DocumentStatus>
									
									<Buyer>
										<BuyersLocationID>
											<SuppliersCode>
												<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
											</SuppliersCode>
										</BuyersLocationID>
										<xsl:if test="Buyer/Party != ''">
											<BuyersName>
												<xsl:value-of select="Buyer/Party"/>
											</BuyersName>
										</xsl:if>
										<xsl:if test="Buyer/Address/AddressLine[1] !=''">
											<BuyersAddress>
												<xsl:if test="Buyer/Address/AddressLine[1] !='' ">
													<AddressLine1>
														<xsl:value-of select="Buyer/Address/AddressLine[1]"/>
													</AddressLine1>
												</xsl:if>
												<xsl:if test="Buyer/Address/AddressLine[2] !='' ">
													<AddressLine2>
														<xsl:value-of select="Buyer/Address/AddressLine[2]"/>
													</AddressLine2>
												</xsl:if>
												<xsl:if test="Buyer/Address/AddressLine[3] !='' ">
													<AddressLine3>
														<xsl:value-of select="Buyer/Address/AddressLine[3]"/>
													</AddressLine3>
												</xsl:if>
												<xsl:if test="Buyer/Address/AddressLine[4] !='' ">
													<AddressLine4>
														<xsl:value-of select="Buyer/Address/AddressLine[4]"/>
													</AddressLine4>
												</xsl:if>
												<xsl:if test="Buyer/Address/PostCode !='' ">
													<PostCode>
														<xsl:value-of select="Buyer/Address/PostCode"/>
													</PostCode>
												</xsl:if>
											</BuyersAddress>
										</xsl:if>
									</Buyer>
									
									<Supplier>
										<SuppliersLocationID>
											<SuppliersCode>
												<xsl:value-of select="Supplier/SupplierReferences/BuyersCodeForSupplier"/>
											</SuppliersCode>
										</SuppliersLocationID>
										<xsl:if test="Supplier/Party !=''">
											<SuppliersName>
												<xsl:value-of select="Supplier/Party"/>
											</SuppliersName>
										</xsl:if>
										<SuppliersAddress>
											<AddressLine1>
												<xsl:value-of select="Supplier/Address/AddressLine[1]"/>
											</AddressLine1>
											<xsl:if test="Supplier/Address/AddressLine[2]">
												<AddressLine2>
													<xsl:value-of select="Supplier/Address/AddressLine[2]"/>
												</AddressLine2>
											</xsl:if>
											<xsl:if test="Supplier/Address/AddressLine[3]">
												<AddressLine3>
													<xsl:value-of select="Supplier/Address/AddressLine[3]"/>
												</AddressLine3>
											</xsl:if>
											<xsl:if test="Supplier/Address/AddressLine[4]">
												<AddressLine4>
													<xsl:value-of select="Supplier/Address/AddressLine[4]"/>
												</AddressLine4>
											</xsl:if>
											<PostCode>
												<xsl:value-of select="Supplier/Address/PostCode"/>
											</PostCode>
										</SuppliersAddress>
									</Supplier>
									
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode>
												<xsl:value-of select="Delivery/DeliverTo/Location"/>
											</SuppliersCode>
										</ShipToLocationID>
										<xsl:if test="Delivery/DeliverTo/Party">
											<ShipToName>
												<xsl:value-of select="Delivery/DeliverTo/Party"/>
											</ShipToName>
										</xsl:if>
										<xsl:if test="Delivery/DeliverTo/Address/AddressLine[1] !='' ">
											<ShipToAddress>
												<AddressLine1>
													<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[1]"/>
												</AddressLine1>
												<xsl:if test="Delivery/DeliverTo/Address/AddressLine[2] !='' ">
													<AddressLine2>
														<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[2]"/>
													</AddressLine2>
												</xsl:if>
												<xsl:if test="Delivery/DeliverTo/Address/AddressLine[3] !='' ">
													<AddressLine3>
														<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[3]"/>
													</AddressLine3>
												</xsl:if>
												<xsl:if test="Delivery/DeliverTo/Address/AddressLine[4] !='' ">
													<AddressLine4>
														<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[4]"/>
													</AddressLine4>
												</xsl:if>
												<xsl:if test="Delivery/DeliverTo/Address/PostCode !='' ">
													<PostCode>
														<xsl:value-of select="Delivery/DeliverTo/Address/PostCode"/>
													</PostCode>
												</xsl:if>
											</ShipToAddress>
										</xsl:if>
									</ShipTo>
									
									<InvoiceReferences>
										<InvoiceReference>
											<xsl:value-of select="InvoiceReferences/SuppliersInvoiceNumber"/>
										</InvoiceReference>
										<InvoiceDate>
											<xsl:value-of select="substring-before(InvoiceDate,'T')"/>
										</InvoiceDate>
										<TaxPointDate>
											<xsl:value-of select="substring-before(TaxPointDate,'T')"/>
										</TaxPointDate>
										<xsl:if test="Supplier/SupplierReferences/TaxNumber">
											<VATRegNo>
												<xsl:value-of select="Supplier/SupplierReferences/TaxNumber"/>
											</VATRegNo>
										</xsl:if>
										<xsl:if test="InvoiceHead/InvoiceCurrency/CurrencyCode">
											<Currency>
												<xsl:value-of select="InvoiceHead/InvoiceCurrency/CurrencyCode"/>
											</Currency>
										</xsl:if>
									</InvoiceReferences>
								</InvoiceHeader>
								
								<InvoiceDetail>
									<!-- If there are no line details create a node and fill with zero values -->
									<xsl:if test="not(InvoiceLine)">
										<InvoiceLine>
											<ProductID>
												<SuppliersProductCode>No lines on Invoice</SuppliersProductCode>
											</ProductID>
											<ProductDescription>No lines on Invoice</ProductDescription>
											<InvoicedQuantity>0</InvoicedQuantity>
											<UnitValueExclVAT>0</UnitValueExclVAT>
											<LineValueExclVAT>0</LineValueExclVAT>
											<VATCode>No lines on Invoice</VATCode>
											<VATRate>0</VATRate>
										</InvoiceLine>		
									</xsl:if>
									
									<!-- For every line that has a total and valid product code, create the nodes as usual -->
									<xsl:for-each select="InvoiceLine">
										<xsl:if test="not(NetLineTotal = 0 and Product/SuppliersProductCode ='')">								
												<xsl:choose>
													<xsl:when test="contains(Price/UnitPrice,'-') or Extensions/egs:Extension/egs:Extrinsic[@name ='CreditLineIndicator'] != '' ">
														<xsl:call-template name="CreditNoteLine"/>
													</xsl:when>
													<xsl:when test="Extensions/egs:Extension/egs:Extrinsic[@name = 'CreditLineIndicator'] = ''">
														<xsl:call-template name="InvoiceLine"/>
													</xsl:when>
													
												</xsl:choose>
											</xsl:if>																	
									</xsl:for-each>
																				
								</InvoiceDetail>
								
								<InvoiceTrailer>
								
									<xsl:if test="TaxSubTotal">
										<VATSubTotals>
											<xsl:for-each select="TaxSubTotal">
											
												<xsl:variable name="TotalCode">
													<xsl:choose>
														<xsl:when test="TaxRate/@Code = 'S'">
															<xsl:value-of select="TaxRate/@Code"/>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = 'Z'">
															<xsl:value-of select="TaxRate/@Code"/>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = 'P'">
															<xsl:value-of select="TaxRate/@Code"/>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = 'E'">
															<xsl:value-of select="TaxRate/@Code"/>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = ''">
															<xsl:text>Z</xsl:text>
														</xsl:when>
														<xsl:otherwise>Unrecognised VAT code:<xsl:value-of select="TaxRate/@Code"/></xsl:otherwise>
													</xsl:choose>	
												</xsl:variable>
											
												<xsl:variable name="TotalRate">
													<xsl:choose>
														<xsl:when test="TaxRate = ''">
															<xsl:text>0.00</xsl:text>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = ''">
															<xsl:text>0.00</xsl:text>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="TaxRate"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												
												<!--This is to remove VAT subtrailors that contain VAT codes that do not match mapped line VAT codes-->
												<xsl:if test="../InvoiceLine[LineTax/TaxRate/@Code=$TotalCode and LineTax/TaxRate=$TotalRate][Product/SuppliersProductCode !='' and NetLineTotal = 0]">
											
													<VATSubTotal>
													
														<xsl:attribute name="VATCode"><xsl:value-of select="$TotalCode"/></xsl:attribute>
														<xsl:attribute name="VATRate"><xsl:value-of select="$TotalRate"/></xsl:attribute>
														
														<xsl:for-each select="TaxablTotalAtRate[. != ''][1]">
															<DiscountedLinesTotalExclVATAtRate>
																<xsl:value-of select="format-number(.,'0.00')"/>
															</DiscountedLinesTotalExclVATAtRate>
														</xsl:for-each>
														
														<xsl:for-each select="AmountDiscount/Amount[. != ''][1]">
															<DocumentDiscountAtRate>
																<xsl:value-of select="format-number(.,'0.00')"/>
															</DocumentDiscountAtRate>
														</xsl:for-each>
														
														<DocumentTotalExclVATAtRate>
															<xsl:value-of select="TaxableValueAtRate"/>
														</DocumentTotalExclVATAtRate>
														
														<VATAmountAtRate>
															<xsl:value-of select="TaxAtRate"/>
														</VATAmountAtRate>
														
														<DocumentTotalInclVATAtRate>
															<xsl:value-of select="GrossPaymentAtRate"/>
														</DocumentTotalInclVATAtRate>
														
													</VATSubTotal>
													
												</xsl:if>
												
											</xsl:for-each>
										</VATSubTotals>
									</xsl:if>
									
									<xsl:for-each select="InvoiceTotal/TaxableTotal[. != ''][1]">
										<DiscountedLinesTotalExclVAT>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</DiscountedLinesTotalExclVAT>
									</xsl:for-each>
										
									<xsl:for-each select="AmountDiscount/Amount[. != ''][1]">
										<DocumentDiscount>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</DocumentDiscount>
									</xsl:for-each>
									
									<xsl:for-each select="InvoiceTotal/NetPaymentTotal[. != ''][1]">
										<DocumentTotalExclVAT>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</DocumentTotalExclVAT>
									</xsl:for-each>
									
									<xsl:for-each select="InvoiceTotal/TaxTotal[. != ''][1]">
										<VATAmount>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</VATAmount>
									</xsl:for-each>
									 
									<xsl:for-each select="InvoiceTotal/GrossPaymentTotal[. != ''][1]">	
										<DocumentTotalInclVAT>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</DocumentTotalInclVAT>
									</xsl:for-each>	
									
								</InvoiceTrailer>
							</Invoice>
						</xsl:for-each>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	
	<!--This is looking for credit note lines-->
	<xsl:template name="CreditNoteLine">

		<xsl:variable name="VATCode">
			<xsl:choose>
				<xsl:when test="LineTax/TaxRate/@Code = 'S'">
					<xsl:value-of select="LineTax/TaxRate/@Code"/>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = 'Z'">
					<xsl:value-of select="LineTax/TaxRate/@Code"/>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = 'P'">
					<xsl:value-of select="LineTax/TaxRate/@Code"/>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = 'E'">
					<xsl:value-of select="LineTax/TaxRate/@Code"/>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = ''">
					<xsl:text>Z</xsl:text>
				</xsl:when>
			</xsl:choose>	
		</xsl:variable>
		
		<xsl:variable name="VATRate">
			<xsl:choose>
				<xsl:when test="LineTax/TaxRate = ''">
					<xsl:text>0.00</xsl:text>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = ''">
					<xsl:text>0.00</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="LineTax/TaxRate"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<InvoiceLine>
		
		<xsl:if test="../InvoiceReferences/BuyersOrderNumber !=''">
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:value-of select="../InvoiceReferences/BuyersOrderNumber"/>
				</PurchaseOrderReference>	
				<PurchaseOrderDate>
					<xsl:choose>
						<xsl:when test="InvoiceLineReferences/OriginalOrderDate !=''">
							<xsl:value-of select="substring-before(InvoiceLineReferences/OriginalOrderDate,'T')"/>
						</xsl:when>
						<xsl:when test="not(InvoiceLineReferences/OriginalOrderDate) and //InvoiceLineReferences/OriginalOrderDate !=''">
							<xsl:value-of select="substring-before(//InvoiceLineReferences/OriginalOrderDate,'T')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(/Batch/Invoice/InvoiceDate,'T')"/>
						</xsl:otherwise>
					</xsl:choose>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
		</xsl:if>	
		
			<DeliveryNoteReferences>
				<DeliveryNoteReference>
					<xsl:choose>
						<xsl:when test="../InvoiceReferences/DeliveryNoteNumber !='' ">
							<xsl:value-of select="../InvoiceReferences/DeliveryNoteNumber"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../InvoiceReferences/SuppliersInvoiceNumber"/>
						</xsl:otherwise>
					</xsl:choose>
				</DeliveryNoteReference>
				<DeliveryNoteDate>
					<xsl:choose>
						<xsl:when test="../Delivery/ActualDeliveryDate !=''">
							<xsl:value-of select="substring-before(../Delivery/ActualDeliveryDate,'T')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(../InvoiceDate,'T')"/>
						</xsl:otherwise>
					</xsl:choose>
				</DeliveryNoteDate>
			</DeliveryNoteReferences>
			
			<ProductID>
				<SuppliersProductCode>
					<xsl:value-of select="Product/SuppliersProductCode"/>
				</SuppliersProductCode>
			</ProductID>
			<ProductDescription>
				<xsl:value-of select="Product/Description"/>
			</ProductDescription>
			<!--If the credit note indicator is present but the invoiced quantity is greater than zero we put a '-' in front of the value to indicate it is a credited line-->
			<xsl:element name="InvoicedQuantity">
				<xsl:choose>
					<xsl:when test="Quantity/Amount &lt; 0 ">
						<xsl:value-of select="Quantity/Amount"/>
						<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="Quantity/@UOMCode"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text><xsl:value-of select="Quantity/Amount"/>
						<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="Quantity/@UOMCode"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<UnitValueExclVAT>
				<xsl:value-of select="Price/UnitPrice"/>
			</UnitValueExclVAT>
			<LineValueExclVAT>
				<xsl:value-of select="NetLineTotal"/>
			</LineValueExclVAT>

			<!--VATCode-->
			<VATCode>
				<xsl:value-of select="$VATCode"/>
			</VATCode>

			<!--VATRate-->
			<VATRate>
				<xsl:value-of select="$VATRate"/>
			</VATRate>
			
		</InvoiceLine>
	</xsl:template>
	
	<!--This is looking at true invoice lines-->
	<xsl:template name="InvoiceLine">
	
		<xsl:variable name="VATCode">
			<xsl:choose>
				<xsl:when test="LineTax/TaxRate/@Code = 'S'">
					<xsl:value-of select="LineTax/TaxRate/@Code"/>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = 'Z'">
					<xsl:value-of select="LineTax/TaxRate/@Code"/>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = 'P'">
					<xsl:value-of select="LineTax/TaxRate/@Code"/>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = 'E'">
					<xsl:value-of select="LineTax/TaxRate/@Code"/>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = ''">
					<xsl:text>Z</xsl:text>
				</xsl:when>
			</xsl:choose>	
		</xsl:variable>
		
		<xsl:variable name="VATRate">
			<xsl:choose>
				<xsl:when test="LineTax/TaxRate = ''">
					<xsl:text>0.00</xsl:text>
				</xsl:when>
				<xsl:when test="LineTax/TaxRate/@Code = ''">
					<xsl:text>0.00</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="LineTax/TaxRate"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<InvoiceLine>
		
		<xsl:if test="../InvoiceReferences/BuyersOrderNumber !=''">
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:value-of select="../InvoiceReferences/BuyersOrderNumber"/>
				</PurchaseOrderReference>	
				<PurchaseOrderDate>
					<xsl:choose>
						<xsl:when test="InvoiceLineReferences/OriginalOrderDate !=''">
							<xsl:value-of select="substring-before(InvoiceLineReferences/OriginalOrderDate,'T')"/>
						</xsl:when>
						<xsl:when test="not(InvoiceLineReferences/OriginalOrderDate) and //InvoiceLineReferences/OriginalOrderDate !='' ">
							<xsl:value-of select="substring-before(//InvoiceLineReferences/OriginalOrderDate,'T')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(/Batch/Invoice/InvoiceDate,'T')"/>
						</xsl:otherwise>
					</xsl:choose>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
		</xsl:if>	
			
			<DeliveryNoteReferences>
				<DeliveryNoteReference>
					<xsl:choose>
						<xsl:when test="../InvoiceReferences/DeliveryNoteNumber !='' ">
							<xsl:value-of select="../InvoiceReferences/DeliveryNoteNumber"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../InvoiceReferences/SuppliersInvoiceNumber"/>
						</xsl:otherwise>
					</xsl:choose>
				</DeliveryNoteReference>
				<DeliveryNoteDate>
					<xsl:choose>
						<xsl:when test="../Delivery/ActualDeliveryDate !=''">
							<xsl:value-of select="substring-before(../Delivery/ActualDeliveryDate,'T')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(../InvoiceDate,'T')"/>
						</xsl:otherwise>
					</xsl:choose>
				</DeliveryNoteDate>
			</DeliveryNoteReferences>
			
			<ProductID>
				<SuppliersProductCode>
					<xsl:value-of select="Product/SuppliersProductCode"/>
				</SuppliersProductCode>
			</ProductID>
			
			<ProductDescription>
				<xsl:value-of select="Product/Description"/>
			</ProductDescription>
			
			<InvoicedQuantity>
				<xsl:value-of select="Quantity/Amount"/>
			</InvoicedQuantity>
			<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="Quantity/@UOMCode"/></xsl:attribute>
			
			<UnitValueExclVAT>
				<xsl:value-of select="Price/UnitPrice"/>
			</UnitValueExclVAT>
			
			<LineValueExclVAT>
				<xsl:value-of select="NetLineTotal"/>
			</LineValueExclVAT>
			
			<!--VATCode-->
			<VATCode>
				<xsl:value-of select="$VATCode"/>
			</VATCode>

			<!--VATRate-->
			<VATRate>
				<xsl:value-of select="$VATRate"/>
			</VATRate>

		</InvoiceLine>
		
	</xsl:template>
	
	<xsl:template match="Invoice[not(InvoiceLine)]">
		<InvoiceLine>
			<ProductID>
				<SuppliersProductCode>No lines on Invoice</SuppliersProductCode>
			</ProductID>
			<ProductDescription>No lines on Invoice</ProductDescription>
			<InvoicedQuantity>0</InvoicedQuantity>
			<UnitValueExclVAT>0</UnitValueExclVAT>
			<LineValueExclVAT>0</LineValueExclVAT>
			<VATCode>No lines on Invoice</VATCode>
			<VATRate>0</VATRate>
		</InvoiceLine>
	</xsl:template>
	
</xsl:stylesheet>
