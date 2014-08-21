<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Fourth hospitality, 2011
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 						|	Description of modification
==========================================================================================
 15/01/2011| K Oshaughnessy			|	Created module 4403
==========================================================================================
				|							|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output method="xml" encoding="UTF-8"/>
<xsl:variable name="CurrentDate" select="script:msGetTodaysDate()"/>
<xsl:variable name="UOM" select="translateUMO"/>
<xsl:variable name="date" select="translatedate"/>
<xsl:template match="/CustomerOrders">

<BatchRoot>
	<Batch>
		<BatchDocuments>
			<BatchDocument>
			<xsl:attribute name="DocumentTypeNo">2</xsl:attribute>
			
				<xsl:for-each select="CustomerOrder">
					<PurchaseOrder>
					
						<TradeSimpleHeader>
							<SendersCodeForRecipient>
								<xsl:text>FAIRFAX MEADOW</xsl:text>
							</SendersCodeForRecipient>
							<TestFlag>1</TestFlag>
						</TradeSimpleHeader>
						
						<PurchaseOrderHeader>
							<DocumentStatus><xsl:text>Original</xsl:text></DocumentStatus>
							
						<Buyer>
							<BuyersLocationID>
								<BuyersCode>
									<xsl:text>BRAKES</xsl:text>
								</BuyersCode>
								<SuppliersCode>
									<xsl:text>FAIRFAX MEADOW</xsl:text>
								</SuppliersCode>
							</BuyersLocationID>
							<BuyersName>xx</BuyersName>
						</Buyer>
						<Supplier>
							<SuppliersLocationID>
								<BuyersCode>
									<xsl:value-of select="customerNumber"/>
								</BuyersCode>
							</SuppliersLocationID>
							<SuppliersName>Fairfax Meadow</SuppliersName>
						</Supplier>
						
							<ShipTo>
								<ShipToLocationID>
									<SuppliersCode>
										<xsl:value-of select="customerNumber"/>
									</SuppliersCode>
								</ShipToLocationID>
								<ShipToName>
									<xsl:value-of select="vendorName"/>
								</ShipToName>
								<ShipToAddress>
									<AddressLine1>
										<xsl:choose>
											<xsl:when test="vendorStreet != '' ">
												<xsl:value-of select="vendorStreet"/>
											</xsl:when>
											<xsl:otherwise>.</xsl:otherwise>
										</xsl:choose>
									</AddressLine1>
									<PostCode>
										<xsl:value-of select="vendorPostcode"/>
									</PostCode>
								</ShipToAddress>
							</ShipTo>
							<PurchaseOrderReferences>
								<PurchaseOrderReference>
									<xsl:value-of select="orderNumber"/>
								</PurchaseOrderReference>
								<PurchaseOrderDate>
									<xsl:choose>
										<xsl:when test="orderDate != '' ">
											<xsl:value-of select="orderDate"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$CurrentDate"/>
										</xsl:otherwise>
									</xsl:choose>
								</PurchaseOrderDate>
							</PurchaseOrderReferences>
							<OrderedDeliveryDetails>
								<DeliveryType>Delivery</DeliveryType>
								<DeliveryDate>
									<xsl:call-template name="translatedate"/>
								</DeliveryDate>
							</OrderedDeliveryDetails>
						</PurchaseOrderHeader>
						
						<xsl:for-each select="items/Material">
							<PurchaseOrderDetail>
								<PurchaseOrderLine>
									<LineNumber>
										<xsl:value-of select="count(preceding-sibling::*)+1"/>
									</LineNumber>
									<ProductID>
										<SuppliersProductCode>
											<xsl:value-of select="code"/>
										</SuppliersProductCode>
									</ProductID>
									<ProductDescription>
										<xsl:value-of select="description"/>
									</ProductDescription>
									<OrderedQuantity>
										<xsl:attribute name="UnitOfMeasure">
											<xsl:call-template name="translateUMO"/>
										</xsl:attribute>
										<xsl:value-of select="quantity"/>
									</OrderedQuantity>
									<PackSize>
										<xsl:value-of select="quantityUOMAndCases"/>
									</PackSize>
									<UnitValueExclVAT ValidationResult="2">0</UnitValueExclVAT>
									<LineValueExclVAT>0</LineValueExclVAT>
								</PurchaseOrderLine>
							</PurchaseOrderDetail>
						</xsl:for-each>
						
						<PurchaseOrderTrailer>
							<NumberOfLines>
								<xsl:value-of select="count(items/Material)"/>
							</NumberOfLines>
						</PurchaseOrderTrailer>
						
					</PurchaseOrder>
				</xsl:for-each>	
			</BatchDocument>	
		</BatchDocuments>
	</Batch>
</BatchRoot>

</xsl:template>

<xsl:template name="translateUMO">
	<xsl:param name="UOM"/>
		<xsl:choose>
			<xsl:when test="substring(/CustomerOrders/CustomerOrder/items/Material/quantityUOMAndCases,string-length(/CustomerOrders/CustomerOrder/items/Material/quantityUOMAndCases)-2) = 'CAS'">
				<xsl:text>CS</xsl:text>
			</xsl:when>
			<xsl:otherwise>EA</xsl:otherwise>
		</xsl:choose>
</xsl:template>

<xsl:template name="translatedate">
	<xsl:param name="date"/>
	<xsl:value-of select="concat(substring(/CustomerOrders/CustomerOrder/deliveryDateFormatted, 7,4),'-',substring(/CustomerOrders/CustomerOrder/deliveryDateFormatted, 4, 2),'-',substring(/CustomerOrders/CustomerOrder/deliveryDateFormatted,1,2))"/>
</xsl:template>

<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : msGetTodaysDate
		' Description 	 : Gets todays date, formatted to yyyy-mm-dd
		' Inputs           : None
		' Outputs        : None
		' Returns       	 : Class of row
		' Author       	 : KO, 15/04/2011
		' Alterations    : 
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
