<?xml version="1.0" encoding="UTF-8"?>
<!--==========================================================================================================================================================================
Summary
==============================================================================================================================================================================

Map Birchstreet cXML orders into TS XML.

==============================================================================================================================================================================
Alterations
==============================================================================================================================================================================
Name		| Date			| Change
==============================================================================================================================================================================
C Scott		| ??			| ??
==============================================================================================================================================================================
M Dimant	| 13/04/2017	| FB 11683: Map 'KG' into KGM. Map Suppliers Code for ShipTo
==============================================================================================================================================================================
M Dimant	| 20/04/2017	| FB 11687: Change where we map SendersCodeForRecipient from
===========================================================================================================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="fo msxsl">

	<xsl:template match="cXML">
	
		<BatchRoot>
		
			<xsl:for-each select="Request/OrderRequest">
			
				<PurchaseOrder>
					<TradeSimpleHeader>
						<SendersCodeForRecipient>
							<xsl:value-of select="../../Header/From/Credential/Identity"/>
						</SendersCodeForRecipient>						
					</TradeSimpleHeader>
					
					<PurchaseOrderHeader>
					

						<ShipTo>
							<ShipToLocationID>
								<GLN>5555555555555</GLN>
								<BuyersCode>
									<xsl:value-of select="OrderRequestHeader/BillTo/Address/@addressID"/>
								</BuyersCode>
								<SuppliersCode>
									<xsl:value-of select="/cXML/Header/To/Credential/Identity"/>
								</SuppliersCode>
							</ShipToLocationID>
							<ShipToName>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/Name"/>
							</ShipToName>
							<ShipToAddress>
								<xsl:variable name="addlines">
									<addline>
										<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/Street"/>
									</addline>
									<addline>
										<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/City"/>
									</addline>
									<addline>
										<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/State"/>
									</addline>
									<addline>
										<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/Country"/>
									</addline>
									<addline>
										<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/PostalCode"/>
									</addline>
								</xsl:variable>
								
								<AddressLine1>
									<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][1]"/>
								</AddressLine1>
								<xsl:if test="count(msxsl:node-set($addlines)/addline[. != '']) &gt; 1">
									<AddressLine2>
										<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][2]"/>
									</AddressLine2>
								</xsl:if>
								<xsl:if test="count(msxsl:node-set($addlines)/addline[. != '']) &gt; 2">
									<AddressLine3>
										<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][3]"/>
									</AddressLine3>
								</xsl:if>
								<xsl:if test="count(msxsl:node-set($addlines)/addline[. != '']) &gt; 3">
									<AddressLine4>
										<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][4]"/>
									</AddressLine4>
								</xsl:if>
								<xsl:if test="count(msxsl:node-set($addlines)/addline[. != '']) &gt; 4">
									<PostCode>
										<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][5]"/>
									</PostCode>
								</xsl:if>
							</ShipToAddress>
							<ContactName>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/DeliverTo"/>
							</ContactName>
						</ShipTo>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="OrderRequestHeader/@orderID"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="substring-before(OrderRequestHeader/@orderDate,'T')"/>
							</PurchaseOrderDate>
						</PurchaseOrderReferences>
						<OrderedDeliveryDetails>
							<DeliveryDate>
								<xsl:value-of select="substring-before(ItemOut[1]/@requestedDeliveryDate,'T')"/>
							</DeliveryDate>
							<xsl:if test="OrderRequestHeader/Extrinsic[@name='DeliveryInstruction'] != ''">
								<SpecialDeliveryInstructions>
									<xsl:value-of select="OrderRequestHeader/Extrinsic[@name='DeliveryInstruction']"/>
								</SpecialDeliveryInstructions>
							</xsl:if>
						</OrderedDeliveryDetails>
						<HeaderExtraData>
							<CustomersMiscInformation>
								<xsl:attribute name="type">Cookie</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/Extrinsic[@name = 'Cookie']"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyername</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/Name"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyerdelto</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/DeliverTo"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyerstreet</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/Street"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyercity</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/City"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyerstate</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/State"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyerpostcode</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/PostalCode"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyercountrycode</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/Country/@isoCountryCode"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyercountry</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/Country"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyeremail</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/Email"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyerphonecountry</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/Phone/TelephoneNumber/CountryCode"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyerphonecountrycode</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/Phone/TelephoneNumber/CountryCode/@isoCountryCode"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyerphonestd</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/Phone/TelephoneNumber/AreaOrCityCode"/>
							</CustomersMiscInformation>
							<CustomersMiscInformation>
								<xsl:attribute name="type">buyerphoneno</xsl:attribute>
								<xsl:value-of select="OrderRequestHeader/ShipTo/Address/Phone/TelephoneNumber/Number"/>
							</CustomersMiscInformation>
							
						</HeaderExtraData>
					</PurchaseOrderHeader>
					
					<PurchaseOrderDetail>
					
						<xsl:for-each select="ItemOut">
						
							<PurchaseOrderLine>
							
								<LineNumber>
									<xsl:value-of select="@lineNumber"/>
								</LineNumber>
								<ProductID>
									<SuppliersProductCode>
										<xsl:value-of select="ItemID/SupplierPartID"/>
									</SuppliersProductCode>
								</ProductID>
								<ProductDescription>
									<xsl:value-of select="ItemDetail/Description"/>
								</ProductDescription>
								<OrderedQuantity>
									<xsl:attribute name="UnitOfMeasure">
										<xsl:choose>
											<xsl:when test="ItemDetail/UnitOfMeasure = 'KG'">KGM</xsl:when>
											<xsl:otherwise><xsl:value-of select="ItemDetail/UnitOfMeasure"/></xsl:otherwise>
										</xsl:choose>				
									</xsl:attribute>								
									<xsl:value-of select="@quantity"/>
								</OrderedQuantity>
								<UnitValueExclVAT>
									<xsl:value-of select="format-number(ItemDetail/UnitPrice/Money,'0.00')"/>
								</UnitValueExclVAT>
								<LineValueExclVAT>
									<xsl:value-of select="format-number(@quantity * ItemDetail/UnitPrice/Money,'0.00')"/>
								</LineValueExclVAT>

							
							</PurchaseOrderLine>
						
						</xsl:for-each>
					
					</PurchaseOrderDetail>

					<PurchaseOrderTrailer>
						<NumberOfLines>
							<xsl:value-of select="count(ItemOut)"/>
						</NumberOfLines>
						<TotalExclVAT>
							<xsl:value-of select="format-number(OrderRequestHeader/Total/Money,'0.00')"/>
						</TotalExclVAT>
					</PurchaseOrderTrailer>


				</PurchaseOrder>
			
			</xsl:for-each>
		
		</BatchRoot>
	
	</xsl:template>

</xsl:stylesheet>
