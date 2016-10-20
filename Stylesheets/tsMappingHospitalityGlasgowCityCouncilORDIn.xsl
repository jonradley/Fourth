<?xml version="1.0" encoding="UTF-8"?>
<!-- 
 Date       		| Name        	| Description of modification
=========================================================================================
26/07/2011	| M Dimant    | 4651: Created. Maps inbound cXML orders from Glasgow City Council.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
19/07/2012	| M Dimant	| 4651: Map GCC's UOMs into our internal UOMs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=========================================================================================
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="fo msxsl" xmlns:ns0="http://access/prototypes/PECOSCXML">
	<xsl:template match="ns0:cXML">	
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
							<xsl:if test="OrderRequestHeader/ShipTo/Address/PostalAddress/DeliverTo">
								<ContactName>
									<xsl:value-of select="OrderRequestHeader/ShipTo/Address/PostalAddress/DeliverTo"/>
								</ContactName>
							</xsl:if>
						</ShipTo>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="OrderRequestHeader/@orderID"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="substring-before(OrderRequestHeader/@orderDate,'T')"/>
							</PurchaseOrderDate>
						</PurchaseOrderReferences>
						<xsl:if test="ItemOut[1]/@requestedDeliveryDate!='' and ItemOut[1]/@requestedDeliveryDate!=' ' and  ItemOut[1]/@requestedDeliveryDate!='0000-00-00T00:00:00'">
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
						</xsl:if>
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
											<xsl:when test="ItemDetail/UnitOfMeasure='KG'">KGM</xsl:when>
											<xsl:when test="ItemDetail/UnitOfMeasure='CA'">CS</xsl:when>
											<xsl:when test="ItemDetail/UnitOfMeasure='PAK'">CS</xsl:when>
											<xsl:when test="ItemDetail/UnitOfMeasure='BAG'">CS</xsl:when>										
											<xsl:when test="ItemDetail/UnitOfMeasure='KAN'">CS</xsl:when>
											<xsl:when test="ItemDetail/UnitOfMeasure='DZ'">DZN</xsl:when>
											<xsl:when test="ItemDetail/UnitOfMeasure='G'">GRM</xsl:when>	
											<xsl:when test="ItemDetail/UnitOfMeasure='10'">001</xsl:when>	
											<xsl:when test="ItemDetail/UnitOfMeasure='L'">LTR</xsl:when>							
											<xsl:otherwise>EA</xsl:otherwise>
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
