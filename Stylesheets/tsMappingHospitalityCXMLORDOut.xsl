<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date			| Change
**********************************************************************
J Miguel	| 14/10/2014	| 10051 - Staples - Setup and Mappers
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://www.fourth.com/dummynamespaces/javascript" exclude-result-prefixes="msxsl xsl user">
	<xsl:output method="xml" encoding="ISO-8859-1" indent="yes" doctype-system="http://xml.cxml.org/schemas/cXML/1.2.019/cXML.dtd"/>
	<xsl:template match="/">
		<cXML version="1.2.019" xml:lang="en-US">
			<!-- payLoadID - Must be a unique id for the whole life of the transmission history -->
			<xsl:attribute name="payloadID"><xsl:value-of select="user:getPayLoadId()"/></xsl:attribute>
			<!-- timestamp - YYYY-MM-DDTHH:MM:SSGMT -->
			<xsl:attribute name="timestamp"><xsl:value-of select="user:formatNowAsTimestamp()"/></xsl:attribute>
			<xsl:apply-templates select="PurchaseOrder"/>
		</cXML>
	</xsl:template>

	<!-- PurchaseOrder template deals with the PO level -->
	<xsl:template match="PurchaseOrder">
		<Header>
			<From>
				<Credential domain="NetworkId">
					<Identity>
						<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</Identity>
				</Credential>
			</From>
			<To>
				<Credential domain="NetworkId">
					<Identity>
						<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</Identity>
				</Credential>
			</To>
			<Sender>
				<Credential domain="NetworkId">
					<Identity>
						<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
					</Identity>
					<SharedSecret>
						<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</SharedSecret>
				</Credential>
				<UserAgent/>
			</Sender>
		</Header>
		<Request deploymentMode="production">
			<OrderRequest>
				<OrderRequestHeader orderType="regular" orderVersion="1" type="new">
					<!-- orderDate YYYY-MM-DDTHH:MM:SSGMT" -->
					<xsl:attribute name="orderDate"><xsl:value-of select="concat(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate, 'T', PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime)"/></xsl:attribute>
					<!-- orderID - JM? is this equivalent to our OrderID ? -->
					<xsl:attribute name="orderID"><xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:attribute>
					<!-- Total - The total of the Purchase Order excluding taxes. Always in GBP -->
					<Total>
						<Money alternateAmount="" alternateCurrency="" currency="GBP">
							<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>
						</Money>
					</Total>
					<ShipTo>
						<xsl:apply-templates select="PurchaseOrderHeader/ShipTo"/>
					</ShipTo>
					<BillTo>
						<xsl:apply-templates select="PurchaseOrderHeader/ShipTo"/>
					</BillTo>
					<!-- JM? By the time being. we will not generate these -->
					<!--					<Comments>
						<Attachment>/
							<URL/>
						</Attachment>
					</Comments>
-->
					<!-- JM? By the time being. we will not generate these -->
					<!--<Extrinsic name="Company Name"/>-->
				</OrderRequestHeader>
				<xsl:apply-templates select="PurchaseOrderDetail/PurchaseOrderLine"/>
			</OrderRequest>
		</Request>
	</xsl:template>
	<!-- Address template -->
	<xsl:template match="ShipTo | Buyer">
		<Address>
			<!-- addressID - JM? hat is this? -->
			<xsl:attribute name="addressID"><xsl:value-of select="(ShipToLocationID | BuyersLocationID)/SuppliersCode"/></xsl:attribute>
			<!--  isoCountryCode - I guess this will be always Great Britain (GB) " -->
			<xsl:attribute name="isoCountryCode">GB</xsl:attribute>
			<!-- Name of the address -->
			<Name xml:lang="en">
				<xsl:value-of select="ShipToName | BuyersName"/>
			</Name>
			<!-- Postal Address details -->
			<PostalAddress name="default">
				<!-- DeliverTo information is only needed if the contact name is provided (typically only for ShipTo -->
				<xsl:if test="ContactName">
					<DeliverTo>
						<xsl:value-of select="ContactName"/>
					</DeliverTo>
				</xsl:if>
				<!-- JM? We do not have street perse how do we transfer this?-->
				<Street>
					<xsl:value-of select="concat((ShipToAddress | BuyersAddress)/AddressLine1, ' ', (ShipToAddress | BuyersAddress)/AddressLine2, ' ', (ShipToAddress | BuyersAddress)/AddressLine3)"/>
				</Street>
				<!-- JM? It is not garanteed that the city is in address line 4. is city mandatory? -->
				<City>
					<xsl:value-of select="(ShipToAddress | BuyersAddress)/AddressLine4"/>
				</City>
				<!-- PostalCode - PostCode -->
				<PostalCode>
					<xsl:value-of select="(ShipToAddress | BuyersAddress)/PostCode"/>
				</PostalCode>
				<!-- Country - JM? not available. Is this mandatory? -->
				<Country isoCountryCode="GB">United Kingdom</Country>
			</PostalAddress>
			<!--			<xsl:if test="name()='ShipTo'">
				-->
			<!-- Email - JM? not available. Is this mandatory? -->
			<!--
				<Email name="default" preferredLang="en-US">PENDING cannot provide it</Email>
				-->
			<!-- Phone - JM? not available. Is this mandatory? -->
			<!--
				<Phone name="work">
					<TelephoneNumber>
						<CountryCode isoCountryCode="GB">1</CountryCode>
						<AreaOrCityCode>PENDING</AreaOrCityCode>
						<Number>PENDING</Number>
					</TelephoneNumber>
				</Phone>
			</xsl:if>-->
		</Address>
	</xsl:template>
	<!-- Items -->
	<xsl:template match="PurchaseOrderLine">
		<!-- ItemOut - each of the order lines -->
		<ItemOut>
			<!-- lineNumber -->
			<xsl:attribute name="lineNumber"><xsl:value-of select="LineNumber"/></xsl:attribute>
			<!-- quantity -->
			<xsl:attribute name="quantity"><xsl:value-of select="OrderedQuantity"/></xsl:attribute>
			<ItemID>
				<SupplierPartID>
					<xsl:value-of select="ProductID/SuppliersProductCode"/>
				</SupplierPartID>
				<!-- SupplierPartAuxiliaryID JM? we do not have this. Let's try not generating it -->
			</ItemID>
			<ItemDetail>
				<!-- UnitPrice. JM? We only have the amount. Currency info is always GBP -->
				<UnitPrice>
					<Money alternateCurrency="" alternateAmount="" currency="GBP">
						<xsl:value-of select="UnitValueExclVAT"/>
					</Money>
				</UnitPrice>
				<!-- Description. IT is always in english -->
				<Description xml:lang="en">
					<xsl:value-of select="ProductDescription"/>
				</Description>
				<!-- UnitOfMeasure. JM? Do you have any specific encoding here? -->
				<UnitOfMeasure>
					<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
				</UnitOfMeasure>
				<!-- Classification - This is mandatory in the schema. Left blank! -->
				<Classification domain=""/>
				<!-- URL JM? WE do not have this. Lets try not generating it -->
				<!-- LeadTime JM? Let's use this but this may required analysis to determine if this is OK -->
				<LeadTime>0</LeadTime>
				<!-- JM? By the time being. we will not generate these -->
				<!--			<Extrinsic name="Requester"></Extrinsic>
				<Extrinsic name="PR No."></Extrinsic>
-->
			</ItemDetail>
			<!--	Distribution JM? I do not think we cna generate this section
			
			<Tax>
				<Money alternateCurrency="" alternateAmount="" currency="GBP"><xsl:value-of select="SuppliersProductCode"/></Money>
				<Description xml:lang="en">VAT</Description>
			</Tax>
-->
			<!--	Distribution JM? I do not think we cna generate this section
			<Distribution>
				<Accounting name="DistributionCharge">
					<Segment id="100" description="Percentage" type="Percentage"/>
					<Segment id="3070152:ENGINEERING DEVELOPMENT" description="Team/Department Name" type="Team/Department"/>
					<Segment id="8999999:Other General Expenses - Other" description="Account Name" type="Account"/>
				</Accounting>
				<Charge>
					<Money alternateCurrency="" alternateAmount="" currency="GBP">14.00</Money>
				</Charge>
			</Distribution>
-->
		</ItemOut>
	</xsl:template>
	<!-- Helper functions -->
	<msxsl:script language="Javascript" implements-prefix="user"><![CDATA[
	
	function right (str, count)
	{
		return str.substring(str.length - count, str.length);
	}
	
	function pad2 (str)
	{
		return right('0' + str, 2);
	}

	function formatDate(date)
	{
		try
		{
			return  '' + date.getFullYear() + '-' + pad2(date.getMonth() + 1) + '-' + pad2(date.getDate()) + 'T' +
					  pad2(date.getHours()) + ':' + pad2(date.getMinutes()) + ':' + pad2(date.getSeconds()) + '+00:00';
		}
		catch (ex)
		{
			return ex.message;
		}
	}
	
	function formatNowAsTimestamp ()
	{
		return formatDate(new Date());
	}
	
	function getPayLoadId ()
	{
		return Math.random()+'-'+new Date().valueOf();
	}
]]></msxsl:script>
</xsl:stylesheet>
