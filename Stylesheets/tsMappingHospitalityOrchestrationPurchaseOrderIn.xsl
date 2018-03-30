<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
	Converts MGR PendingDeliverySubmitted XML into initial version of TS GRN internal XML

==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 2017-11-16	| J Miguel   		| US13171 FB11284 Created
==========================================================================================
 2018-01-24 | Y Valkov          | US43516 Purchasing API > Handle UOM on Order for Products for Product Catalogue Customers (Remove "EA" Hard-coding)
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl script msxsl">
	<xsl:output method="xml" />

	<xsl:param name="BuyersCodeForSupplier" select="'BuyersCodeForSupplier'"/>
	<xsl:param name="SendersBranchReference" select="'SendersBranchReference'"/>
	<xsl:param name="SitesCodeForSupplier" select="'SitesCodeForSupplier'"/>
	<xsl:param name="LocationAddressLine1" select="'.'"/>
	<xsl:param name="LocationAddressLine2" select="''"/>
	<xsl:param name="LocationAddressLine3" select="''"/>
	<xsl:param name="LocationAddressLine4" select="''"/>
	<xsl:param name="LocationPostCode" select="'.'"/>
	
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
							<DocumentStatus>
								<xsl:text>Original</xsl:text>
							</DocumentStatus>

							<Buyer>
								<BuyersLocationID>
									<GLN>GLN</GLN>
									<BuyersCode>
										<xsl:value-of select="$SitesCodeForSupplier"/>
									</BuyersCode>
								</BuyersLocationID>
							</Buyer>
							<Supplier>
								<SuppliersLocationID>
									<GLN>GLN</GLN>
									<SuppliersCode>
										<xsl:value-of select="SupplierCode"/>
									</SuppliersCode>
								</SuppliersLocationID>
								<SuppliersName>
									<xsl:value-of select="SupplierName"/>
								</SuppliersName>
							</Supplier>
							<ShipTo>
								<ShipToLocationID>
									<GLN>GLN</GLN>
									<BuyersCode>
										<xsl:value-of select="LocationCode"/>
									</BuyersCode>
								</ShipToLocationID>
								<ShipToName>
									<xsl:value-of select="LocationName"/>
								</ShipToName>
								<ShipToAddress>
									<AddressLine1>
										<xsl:value-of select="$LocationAddressLine1"/>
									</AddressLine1>
									<xsl:if test="$LocationAddressLine2 != ''">
										<AddressLine2>
											<xsl:value-of select="$LocationAddressLine2"/>
										</AddressLine2>
									</xsl:if>
									<xsl:if test="$LocationAddressLine3 != ''">
										<AddressLine3>
											<xsl:value-of select="$LocationAddressLine3"/>
										</AddressLine3>
									</xsl:if>
									<xsl:if test="$LocationAddressLine4 != ''">
										<AddressLine4>
											<xsl:value-of select="$LocationAddressLine4"/>
										</AddressLine4>
									</xsl:if>
									<PostCode>
										<xsl:value-of select="$LocationPostCode"/>
									</PostCode>
								</ShipToAddress>
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
								<DeliveryType>Delivery</DeliveryType>
								<DeliveryDate>
									<xsl:value-of select="script:convertUnixToDate(string(DeliveryDate))"/>
								</DeliveryDate>								
								<xsl:if test="DeliveryInstructions != ''">
									<SpecialDeliveryInstructions>
										<xsl:value-of select="DeliveryInstructions"/>
									</SpecialDeliveryInstructions>
								</xsl:if>
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
			<LineNumber>
				<xsl:value-of select="LineNumber"/>
			</LineNumber>		
			<ProductID>
				<GTIN>GTIN</GTIN>
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
				<xsl:attribute name="UnitOfMeasure"><xsl:call-template name="decodeUoM"><xsl:with-param name="sInput"><xsl:value-of select="OrderUnitCode"/></xsl:with-param></xsl:call-template></xsl:attribute>
				<xsl:value-of select="script:convertOrderedQuantity(number(OrderedQuantity/Lo), number(OrderedQuantity/Mid), number(OrderedQuantity/Hi), number(OrderedQuantity/SignScale))"/>
			</OrderedQuantity>
			<xsl:if test="PackSize != ''">
				<PackSize>
					<xsl:value-of select="PackSize"/>
				</PackSize>
			</xsl:if>
			<UnitValueExclVAT>
				<xsl:value-of select="script:convertUnitValueExclVat(number(UnitPriceExcludingVAT/Lo), number(UnitPriceExcludingVAT/Mid), number(UnitPriceExcludingVAT/Hi), number(UnitPriceExcludingVAT/SignScale))"/>
			</UnitValueExclVAT>			
		</PurchaseOrderLine>
	</xsl:template>
	<xsl:template name="decodeUoM">
		<xsl:param name="sInput"/>
		<xsl:choose>
			<xsl:when test="script:toLower($sInput) = 'case'">CS</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'cs'">CS</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'grm'">GRM</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'kg'">KGM</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'kgm'">KGM</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'pnd'">PND</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'onz'">ONZ</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'gli'">GLI</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'l'">LTR</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'ltr'">LTR</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'ozi'">OZI</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'pti'">PTI</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'ptn'">PTN</xsl:when>
			<xsl:when test="script:toLower($sInput) = '001'">001</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'dzn'">DZN</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'pf'">PF</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'pr'">PR</xsl:when>
			<xsl:when test="script:toLower($sInput) = 'hur'">HUR</xsl:when>
			<xsl:otherwise>
				<xsl:text>EA</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
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

public string convertOrderedQuantity(int lo, int mid, int hi, int signScale)
{
    return convertToDecimal(lo, mid, hi, signScale).ToString("#");
}

public string convertUnitValueExclVat(int lo, int mid, int hi, int signScale)
{
    return convertToDecimal(lo, mid, hi, signScale).ToString();
}

public decimal convertToDecimal(int lo, int mid, int hi, int signScale)
{
    bool sign = (signScale & 0x80000000) != 0;
    byte scale = (byte)((signScale >> 16) & 0x7F);

    return new decimal(lo, mid, hi, sign, scale);
}

public string toLower(string @string)
{
	if (string.IsNullOrEmpty(@string))
	{
		return string.Empty;
	}
	
	return @string.ToLower();
}

	]]>
	</msxsl:script>
</xsl:stylesheet>
