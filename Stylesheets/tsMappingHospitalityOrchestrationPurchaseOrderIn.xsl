<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
	Converts MGR PendingDeliverySubmitted XML into initial version of TS GRN internal XML

==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 2017-11-16	| J Miguel		| US13171 FB11284 Created
==========================================================================================
						|							| 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl script msxsl">
	<xsl:output method="xml" />

	<xsl:param name="BuyersCodeForSupplier" select="'BuyersCodeForSupplier'"/>
	<xsl:param name="SendersBranchReference" select="'SendersBranchReference'"/>
	<xsl:param name="SitesCodeForSupplier" select="'SitesCodeForSupplier'"/>
	
	<xsl:template match="/PurchaseOrder">
		<Batch>
			<TradeSimpleHeader>
				<SendersCodeForRecipient>
					<xsl:value-of select="$BuyersCodeForSupplier"/>
				</SendersCodeForRecipient>
			</TradeSimpleHeader>
			<BatchDocuments>
				<BatchDocument DocumentTypeNo="2">
					<PurchaseOrder>
						<TradeSimpleHeader>
							<SendersCodeForRecipient>
								<xsl:value-of select="$SitesCodeForSupplier"/>
							</SendersCodeForRecipient>
							<SendersBranchReference>
								<xsl:value-of select="$SendersBranchReference"/>
							</SendersBranchReference>
						</TradeSimpleHeader>
							<PurchaseOrderHeader>
								<Buyer>
									<BuyersLocationID>
										<xsl:value-of select="$SitesCodeForSupplier"/>
									</BuyersLocationID>
								</Buyer>
								<Supplier>
									<SupplierName>
										<xsl:value-of select="SupplierName"/>
									</SupplierName>
									<SuppliersLocationID>
										<SuppliersCode>
											<xsl:value-of select="SupplierCode"/>
										</SuppliersCode>
									</SuppliersLocationID>
								</Supplier>
								<ShipTo>
									<ShipToName>
										<xsl:value-of select="LocationName"/>
									</ShipToName>
									<ShipToLocationId>
										<BuyersCode>
											<xsl:value-of select="LocationCode"/>
										</BuyersCode>
									</ShipToLocationId>
								</ShipTo>
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="OrderReference"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="script:convertUnixToDate(string(OrderDate))"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
								<OrderedDeliveryDetails>
									<DeliveryDate>
										<xsl:value-of select="script:convertUnixToDate(string(DeliveryDate))"/>
									</DeliveryDate>
								</OrderedDeliveryDetails>
							</PurchaseOrderHeader>
							<PurchaseOrderDetail>
								<xsl:apply-templates select="Lines"/>
							</PurchaseOrderDetail>
							<PurchaseOrderTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(Lines)"/>
								</NumberOfLines>
							</PurchaseOrderTrailer>
					</PurchaseOrder>
				</BatchDocument>
			</BatchDocuments>
		</Batch>
	</xsl:template>
	<xsl:template match="Lines">
		<PurchaseOrderLine>
			<ProductID>
				<SuppliersProductCode>
					<xsl:value-of select="SupplierProductCode"/>
				</SuppliersProductCode>
				<BuyersProductCode>
					<xsl:value-of select="SupplierProductCode"/>
				</BuyersProductCode>
			</ProductID>
			<ProductDescription>
				<xsl:value-of select="ProductDescription"/>
			</ProductDescription>
			<OrderedQuantity>
				<xsl:value-of select="script:convertDecimalToNumber(number(OrderedQuantity/Lo), number(OrderedQuantity/Mid), number(OrderedQuantity/Hi), number(OrderedQuantity/SignScale))"/>
			</OrderedQuantity>
			<PackSize>
				<xsl:value-of select="OrderUnitDescription"/>
			</PackSize>
			<UnitValueExclVAT>
				<xsl:value-of select="script:convertDecimalToNumber(number(UnitPriceExcludingVAT/Lo), number(UnitPriceExcludingVAT/Mid), number(UnitPriceExcludingVAT/Hi), number(UnitPriceExcludingVAT/SignScale))"/>
			</UnitValueExclVAT>
		</PurchaseOrderLine>
	</xsl:template>
	<msxsl:script language="C#" implements-prefix="script">
	<![CDATA[ 

DateTime unixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
string format = "yyyy-MM-dd";

public string convertUnixToDate (string date)
{
	long unixDateTime = Convert.ToInt64(date);
	DateTime dateTime = unixEpoch.AddTicks(unixDateTime);
	return dateTime.ToString(format);
}

public string convertDecimalToNumber (double lo, double mid, double hi, double signScale)
{
 return new decimal((int)lo, (int)mid, (int)hi, false, (byte)signScale).ToString();
}

	]]></msxsl:script>
</xsl:stylesheet>
