<!--********************************************************************
Date		|	owner				|	details
************************************************************************
21/06/2012| KOshaughnessy	| Created FB5542
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
								
								<!--This is looking for all lines which have product codes (see templates below) -->
								<InvoiceDetail>
									<xsl:apply-templates select="InvoiceLine[Product/SuppliersProductCode !=''][NetLineTotal !=0]"/>
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
												<xsl:otherwise>Z</xsl:otherwise>
											</xsl:choose>	
										</xsl:variable>
									
										<xsl:variable name="TotalRate">
											<xsl:choose>
												<xsl:when test="TaxRate = ''">
													<xsl:text>0.00</xsl:text>
												</xsl:when>
												<xsl:when test="TaxRate = ''">
													<xsl:text>0.00</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="TaxRate"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										
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
	<xsl:template match="/Batch/Invoice/InvoiceLine[Extensions/egs:Extension/egs:Extrinsic/@name = 'CreditLineIndicator']">
	
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
		
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:choose>
						<xsl:when test="../InvoiceReferences/BuyersOrderNumber !='' ">
							<xsl:value-of select="../InvoiceReferences/BuyersOrderNumber"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="InvoiceLineReferences/BuyersOrderNumber"/>
						</xsl:otherwise>
					</xsl:choose>
				</PurchaseOrderReference>	
				<PurchaseOrderDate>
					<xsl:choose>
						<xsl:when test="../InvoiceLineReferenes/OriginaOrderDate !='' ">
							<xsl:value-of select="../InvoiceLineReferenes/OriginaOrderDate"/>
						</xsl:when>
						<xsl:when test="../Delivery/ActualDeliveryDate !=''">
							<xsl:value-of select="../Delivery/ActualDeliveryDate"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(../InvoiceDate,'T')"/>
						</xsl:otherwise>
					</xsl:choose>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
			
			<DeliveryNoteReferences>
				<DeliveryNoteReference>
					<xsl:choose>
						<xsl:when test="//InvoiceReferences/DeliveryNoteNumber !='' ">
							<xsl:value-of select="//InvoiceReferences/DeliveryNoteNumber"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="//InvoiceReferences/SuppliersInvoiceNumber"/>
						</xsl:otherwise>
					</xsl:choose>
				</DeliveryNoteReference>
				<DeliveryNoteDate>
					<xsl:choose>
						<xsl:when test="../Delivery/ActualDeliveryDate !=''">
							<xsl:value-of select="../Delivery/ActualDeliveryDate"/>
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
	<xsl:template match="InvoiceLine[Extensions/egs:Extension/egs:Extrinsic/@name != 'CreditLineIndicator']">
	
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
		
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:choose>
						<xsl:when test="../InvoiceReferences/BuyersOrderNumber !='' ">
							<xsl:value-of select="../InvoiceReferences/BuyersOrderNumber"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="InvoiceLineReferences/BuyersOrderNumber"/>
						</xsl:otherwise>
					</xsl:choose>
				</PurchaseOrderReference>	
				<PurchaseOrderDate>
					<xsl:choose>
						<xsl:when test="../InvoiceLineReferenes/OriginaOrderDate !='' ">
							<xsl:value-of select="../InvoiceLineReferenes/OriginaOrderDate"/>
						</xsl:when>
						<xsl:when test="../Delivery/ActualDeliveryDate !=''">
							<xsl:value-of select="../Delivery/ActualDeliveryDate"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(../InvoiceDate,'T')"/>
						</xsl:otherwise>
					</xsl:choose>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
			
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
							<xsl:value-of select="../Delivery/ActualDeliveryDate"/>
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
</xsl:stylesheet>
