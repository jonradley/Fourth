<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com" exclude-result-prefixes="fo jscript msxsl">
	<xsl:template match="PurchaseOrderConfirmation">
	
		<cXML>
			<xsl:attribute name="payloadID">200706100551.1181479311609.-5526052089134691191@birchstreet.com</xsl:attribute>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="jscript:getTimeStamp()"/>
			</xsl:attribute>
			<xsl:attribute name="xml:lang">en-US</xsl:attribute>
			<Header>
				<From>
					<Credential>
						<xsl:attribute name="domain">NetworkId</xsl:attribute>
						<Identity>tradesimple</Identity>
					</Credential>
				</From>
				<To>
					<Credential>
						<xsl:attribute name="domain">birchstreet.com</xsl:attribute>
						<Identity>
							<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
						</Identity>
					</Credential>
				</To>
				<Sender>
					<Credential>
						<xsl:attribute name="domain">birchstreet.com</xsl:attribute>
						<Identity>tradesimple</Identity>
						<SharedSecret>b3i8r3c23hs45t8re2et</SharedSecret>
					</Credential>
					<UserAgent>V7</UserAgent>
				</Sender>
			</Header>
			<ConfirmationRequest>
				<ConfirmationHeader>
					<xsl:attribute name="confirmID">
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
					</xsl:attribute>
					<xsl:attribute name="invoiceID"/>
					<xsl:attribute name="noticeDate">
						<xsl:value-of select="concat(PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate,'T00:00:00')"/>
					</xsl:attribute>
					<xsl:attribute name="type">
						<xsl:choose>
							<xsl:when test="count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine) = count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus = 'Accepted'])">Accept</xsl:when>
							<xsl:when test="count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine) = count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus = 'Rejected'])">Reject</xsl:when>
							<xsl:otherwise>Except</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<Shipping>
						<Money/>
						<Description/>
					</Shipping>
					<Tax>
						<Money/>
						<Description/>
					</Tax>
					<Comments>
						<xsl:choose>
							<xsl:when test="count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine) = count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus = 'Accepted'])">Accepted</xsl:when>
							<xsl:when test="count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine) = count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus = 'Rejected'])">Rejected</xsl:when>
							<xsl:otherwise>Accepted With Changes</xsl:otherwise>
						</xsl:choose>
					</Comments>
					<Extrinsic name="Cookie">
						<xsl:attribute name="name">Cookie</xsl:attribute>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='Cookie']"/>
					</Extrinsic>
					<Contact>
						<Name>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyername']"/>
						</Name>
						<PostalAddress>
							<DeliverTo>
								<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyerdelto']"/>
							</DeliverTo>
							<Street>
								<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyerstreet']"/>
							</Street>
							<City>
								<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyercity']"/>
							</City>
							<State>
								<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyerstate']"/>
							</State>
							<PostalCode>
								<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyerpostcode']"/>
							</PostalCode>
							<Country>
								<xsl:attribute name="isoCountryCode">
									<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyercountrycode']"/>
								</xsl:attribute>
								<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyercountry']"/>
							</Country>
						</PostalAddress>
						<Email>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyeremail']"/>
						</Email>
						<Phone name="work">
							<TelephoneNumber>
								<CountryCode>
									<xsl:attribute name="isoCountryCode">
										<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyerphonecountrycode']"/>
									</xsl:attribute>
									<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyerphonecountry']"/>
								</CountryCode>
								<AreaOrCityCode>
									<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyerphonestd']"/>
								</AreaOrCityCode>
								<Number>
									<xsl:value-of select="PurchaseOrderConfirmationHeader/HeaderExtraData/CustomersMiscInformation[@type='buyerphoneno']"/>
								</Number>
							</TelephoneNumber>
						</Phone>
					</Contact>
				</ConfirmationHeader>
				<OrderReference orderID="LPLMS-000000372">
					<xsl:attribute name="orderID">
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
					</xsl:attribute>
					<DocumentReference/>
				</OrderReference>
				<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
					<ConfirmationItem>
						<xsl:attribute name="deliveryDate">
							<xsl:value-of select="concat(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate,'T00:00:00')"/>
						</xsl:attribute>
						<xsl:attribute name="lineNumber">
							<xsl:value-of select="LineNumber"/>
						</xsl:attribute>
						<xsl:attribute name="quantity">
							<xsl:value-of select="ConfirmedQuantity"/>
						</xsl:attribute>
						<ConfirmationStatus>
							<ItemIn>
								<xsl:attribute name="quantity">
									<xsl:value-of select="ConfirmedQuantity"/>
								</xsl:attribute>
								<ItemID>
									<SupplierPartID>
										<xsl:value-of select="ProductID/SuppliersProductCode"/>
									</SupplierPartID>
									<!--SupplierPartAuxiliaryID>C</SupplierPartAuxiliaryID-->
								</ItemID>
								<ItemDetail>
									<UnitPrice>
										<Money currency="GBP">
											<xsl:attribute name="currency">GBP</xsl:attribute>
											<xsl:value-of select="UnitValueExclVAT"/>
										</Money>
									</UnitPrice>
									<Description>
										<xsl:value-of select="ProductDescription"/>
									</Description>
									<UnitOfMeasure>
										<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
									</UnitOfMeasure>
									<Classification/>
								</ItemDetail>
							</ItemIn>
						</ConfirmationStatus>
					</ConfirmationItem>
				</xsl:for-each>
			</ConfirmationRequest>
		</cXML>
	</xsl:template>

	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[ 
		function getTimeStamp() {
			dtTimeStamp = new Date();
			sYear  = dtTimeStamp.getFullYear();
			sMonth = 'x0' + (dtTimeStamp.getMonth() + 1);
			sMonth = sMonth.substr(sMonth.length - 2,2);
			sDate  = 'x0' + dtTimeStamp.getDate();
			sDate  = sDate.substr(sDate.length - 2,2);
			sHour  = 'x0' + dtTimeStamp.getHours();
			sHour  = sHour.substr(sHour.length - 2,2);
			sMin   = 'x0' + dtTimeStamp.getMinutes();
			sMin   = sMin.substr(sMin.length - 2,2);
			sSec   = 'x0' + dtTimeStamp.getSeconds();
			sSec   = sSec.substr(sSec.length - 2,2);
			sTimeStamp = sYear + '-' + sMonth + '-' + sDate + 'T' + sHour + ':' + sMin + ':' + sSec;
			return sTimeStamp;
		}
	]]></msxsl:script>


</xsl:stylesheet>
