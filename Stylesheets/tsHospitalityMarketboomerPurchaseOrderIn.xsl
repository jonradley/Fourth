<?xml version="1.0" encoding="UTF-8"?>

<!--******************************************************************
Alterations
**********************************************************************
Name					| Date				| Change
**********************************************************************
Andrew Barber			| 2009-11-05		| Created
*******************************************************************-->

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:script="http://mycompany.com/mynamespace"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
	<BatchRoot>
		<PurchaseOrder>
			<TradeSimpleHeader>
				<SendersCodeForRecipient>
					<xsl:text>FAIRFAX</xsl:text>
				</SendersCodeForRecipient>
			</TradeSimpleHeader>
			<PurchaseOrderHeader>
				<DocumentStatus>
					<xsl:text>Original</xsl:text>	
				</DocumentStatus>
				<Buyer>
					<BuyersLocationID>
						<BuyersCode>
							<!--Change to specify location_code as part of relationship code where location_code != '[DEFAULT]'-->
							<xsl:choose>
								<xsl:when test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/@location_name != '[DEFAULT]'">
									<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/@location_name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
								</xsl:otherwise>	
							</xsl:choose>
							<!--<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>-->
						</BuyersCode>
					</BuyersLocationID>
					<BuyersName>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
					</BuyersName>
				</Buyer>
				<Supplier>
					<SuppliersLocationID>
						<BuyersCode>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Name"/>
						</BuyersCode>
					</SuppliersLocationID>
					<SuppliersName>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Name"/>
					</SuppliersName>
					<SuppliersAddress>
						<AddressLine1>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine1"/>
						</AddressLine1>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine2 != ''">
							<AddressLine2>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine2"/>
							</AddressLine2>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/City != ''">
							<AddressLine3>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/City"/>
							</AddressLine3>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/@country-code != ''">
							<AddressLine4>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/@country-code"/>
							</AddressLine4>
						</xsl:if>
						<!--Postcode datatype in Marketboomer xsd = positiveInteger, therefore not consistent with UK postcodes, not mapped.
						<PostCode></PostCode>-->
					</SuppliersAddress>
				</Supplier>
				<ShipTo>
					<ShipToLocationID>
						<SuppliersCode>
							<!--Change to specify location_code as part of relationship code where location_code != '[DEFAULT]'-->
							<xsl:choose>
								<xsl:when test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/@location_name != '[DEFAULT]'">
									<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/@location_name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
								</xsl:otherwise>	
							</xsl:choose>
							<!--<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>-->
						</SuppliersCode>
					</ShipToLocationID>
					<!--Ship to name provided as "[DEFAULT]" in Marketboomer order file, mapped BillTo/Name-->
					<ShipToName>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
					</ShipToName>
					<ShipToAddress>
						<AddressLine1>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine1"/>
						</AddressLine1>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine2 != ''">
							<AddressLine2>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine2"/>
							</AddressLine2>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/City != ''">
							<AddressLine3>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/City"/>
							</AddressLine3>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/@country-code != ''">
							<AddressLine4>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/@country-code"/>
							</AddressLine4>
						</xsl:if>
						<!--Postcode datatype in Marketboomer xsd = positiveInteger, therefore not consistent with UK postcodes, not mapped.
						<PostCode></PostCode>-->
					</ShipToAddress>
					<ContactName>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Contacts/Contact[@role='Creator']/Name"/>
					</ContactName>
				</ShipTo>
				<PurchaseOrderReferences>
					<PurchaseOrderReference>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/DocIds/Identifier[@type='ORDER_NUMBER']/@value"/>
					</PurchaseOrderReference>
					<PurchaseOrderDate>
						<!--Get date component from datetime value-->
						<xsl:value-of select ="substring(/Supplier_Orders/SupplierOrder/Order/@date,1,10)"/>
					</PurchaseOrderDate>
					<PurchaseOrderTime>
						<!--Get time component from datetime value-->
						<xsl:value-of select ="substring(/Supplier_Orders/SupplierOrder/Order/@date,12,19)"/>
					</PurchaseOrderTime>
				</PurchaseOrderReferences>
				<OrderedDeliveryDetails>
					<DeliveryType>
						<xsl:text>Delivery</xsl:text>
					</DeliveryType>
					<DeliveryDate>
						<xsl:choose>
							<xsl:when test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/DeliveryDay='Next Delivery Run'">
								<xsl:value-of select="script:msNextDayDate()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/DeliveryDay"/>
							</xsl:otherwise>
						</xsl:choose>
					</DeliveryDate>
					<SpecialDeliveryInstructions>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/DeliveryInstructions"/>
						<xsl:text> : </xsl:text>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ConfirmInstructions"/>
						<xsl:text> : </xsl:text>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/Comment"/>
						<!--Add line comments to special delivery instructions at header level-->
						<xsl:for-each select="/Supplier_Orders/SupplierOrder/Order/Body/Line/Comment">
							<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Body/Line/Comment != ''">
								<xsl:text> : </xsl:text>
								<xsl:value-of select="translate(/Supplier_Orders/SupplierOrder/Order/Body/Line/Comment,'&#x000D;&#x000A;', '')" />
							</xsl:if>
						</xsl:for-each>
					</SpecialDeliveryInstructions>
				</OrderedDeliveryDetails>
			</PurchaseOrderHeader>
			<PurchaseOrderDetail>
				<xsl:for-each select="/Supplier_Orders/SupplierOrder/Order/Body/Line">
					<PurchaseOrderLine>
						<!--<LineNumber/>-->
						<ProductID>
							<xsl:if test="Product/Identifiers/Identifier[@type='Seller']/@value != ''">
								<SuppliersProductCode>
										<xsl:value-of select ="Product/Identifiers/Identifier[@type='Seller']/@value"/>
								</SuppliersProductCode>
							</xsl:if>
							<xsl:if test="Product/Identifiers/Identifier[@type='Buyer']/@value != ''">
								<BuyersProductCode>
										<xsl:value-of select ="Product/Identifiers/Identifier[@type='Buyer']/@value"/>
								</BuyersProductCode>
							</xsl:if>
						</ProductID>
						<ProductDescription>
							<xsl:value-of select ="Product/Description"/>
						</ProductDescription>
						<OrderedQuantity>
							<!--Only KG and EA received in Marketboomer PO's, if otherwas default to EA-->
							<xsl:attribute name="UnitOfMeasure">
								<xsl:choose>
									<xsl:when test="Product/Unit/@measure='kg'">KGM</xsl:when>
									<xsl:when test="Product/Unit/@measure='each'">EA</xsl:when>
									<xsl:otherwise>EA</xsl:otherwise>
								</xsl:choose>
 							</xsl:attribute>
							<xsl:value-of select ="Quantity"/>
						</OrderedQuantity>
						<PackSize>
							<xsl:value-of select ="Product/Package/@size"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select ="Product/Package/@name"/>
						</PackSize>
						<UnitValueExclVAT>
							<xsl:value-of select ="UnitPrice"/>
						</UnitValueExclVAT>
						<LineValueExclVAT>
							<xsl:value-of select ="LineTotal"/>
						</LineValueExclVAT>
					</PurchaseOrderLine>
				</xsl:for-each>
			</PurchaseOrderDetail>
			<PurchaseOrderTrailer>
				<NumberOfLines>
					<xsl:value-of select ="count(//Line)"/>
				</NumberOfLines>
				<TotalExclVAT>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Financials/OrderValue"/>
				</TotalExclVAT>
			</PurchaseOrderTrailer>
		</PurchaseOrder>
	</BatchRoot>
	</xsl:template>
	
	<msxsl:script language="vbscript" implements-prefix="script"><![CDATA[ 
	
		'=========================================================================================
		' Routine       	 : msNextDayDate
		' Description 	 : Gets the next day date in the format "yyyy-mm-dd"
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : Andrew Barber, 2009-11-24
		' Alterations   	 :
		'=========================================================================================
		
		Function msNextDayDate()
			
			'Get current date, add one day and convert to string.
			getNextDayDate=CStr(DateAdd("d",1,Date()))
			
			'Convert Date into yyyy-mm-dd format.
			msNextDayDate=Right(getNextDayDate,4) & "-" & Mid(getNextDayDate,4,2) & "-" & Left(getNextDayDate,2)
			
		End Function
	
	]]></msxsl:script>
	
</xsl:stylesheet>