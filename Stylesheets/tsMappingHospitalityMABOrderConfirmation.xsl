<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                              xmlns:order="urn:ean.ucc:order:2"
                              xmlns:eanucc="urn:ean.ucc:2"
                              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                              exclude-result-prefixes="fo">
	<xsl:template match="PurchaseOrderConfirmation">
	
		<sh:StandardBusinessDocument>
			<xsl:attribute name="xsi:schemaLocation">http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader ../Schemas/sbdh/StandardBusinessDocumentHeader.xsd urn:ean.ucc:2 ../Schemas/OrderResponseProxy.xsd</xsl:attribute>
			<sh:StandardBusinessDocumentHeader>
				<sh:HeaderVersion>2.2</sh:HeaderVersion>
				<sh:Sender>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
					</sh:Identifier>
				</sh:Sender>
				<sh:Receiver>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/GLN"/>
					</sh:Identifier>
				</sh:Receiver>
				<sh:DocumentIdentification>
					<sh:Standard>EAN.UCC</sh:Standard>
					<sh:TypeVersion>2.0.2</sh:TypeVersion>
					<sh:InstanceIdentifier>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
					</sh:InstanceIdentifier>
					<sh:Type>OrderResponse</sh:Type>
					<sh:MultipleType>false</sh:MultipleType>
					<sh:CreationDateAndTime>
						<xsl:value-of select="concat(PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate,'T00:00:00')"/>
					</sh:CreationDateAndTime>
				</sh:DocumentIdentification>
			</sh:StandardBusinessDocumentHeader>
			<eanucc:message>
				<entityIdentification>
					<uniqueCreatorIdentification>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
					</uniqueCreatorIdentification>
					<contentOwner>
						<gln>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
						</gln>
					</contentOwner>
				</entityIdentification>
				<order:orderResponse>
					<xsl:attribute name="creationDateTime">
						<xsl:value-of select="concat(PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate,'T00:00:00')"/>
					</xsl:attribute>
					<xsl:variable name="sStatusType">
						<xsl:choose>
							<xsl:when test="count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus = 'Accepted']) = PurchaseOrderConfirmationTrailer/NumberOfLines">ACCEPTED</xsl:when>
							<xsl:when test="count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus = 'Rejected']) = PurchaseOrderConfirmationTrailer/NumberOfLines">REJECTED</xsl:when>
							<xsl:otherwise>MODIFIED</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="responseStatusType">
						<xsl:value-of select="$sStatusType"/>
					</xsl:attribute>
					<xsl:attribute name="xsi:schemaLocation">urn:ean.ucc:2 ../Schemas/OrderResponseProxy.xsd</xsl:attribute>
					<responseIdentification>
						<uniqueCreatorIdentification>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
						</uniqueCreatorIdentification>
						<contentOwner>
							<gln>
								<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
							</gln>
						</contentOwner>
					</responseIdentification>
					<responseToOriginalDocument>
						<xsl:attribute name="referenceDateTime">
							<xsl:value-of select="concat(PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate,'T00:00:00')"/>
						</xsl:attribute>
						<xsl:attribute name="referenceDocumentType">3</xsl:attribute>
						<xsl:attribute name="referenceIdentification">
							<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
						</xsl:attribute>
					</responseToOriginalDocument>
					<buyer>
						<gln>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/GLN"/>
						</gln>
					</buyer>
					<seller>
						<gln>
							<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
						</gln>
					</seller>
					<xsl:if test="$sStatusType = 'MODIFIED'">
						<orderModification>
							<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[not(contains('Accepted^Rejected',@LineStatus))]">
								<orderModificationLineItemLevel>
									<substituteItemIdentification>
										<gtin>
											<xsl:choose>
												<xsl:when test="SubstitutedProductID/GTIN">
													<xsl:value-of select="SubstitutedProductID/GTIN"/>
												</xsl:when>
												<xsl:otherwise>00000000000000</xsl:otherwise>
											</xsl:choose>
										</gtin>
									</substituteItemIdentification>
									<modifiedOrderInformation number="1" unitOfMeasure="B">
										<xsl:attribute name="number">
											<xsl:value-of select="LineNumber"/>
										</xsl:attribute>
										<xsl:attribute name="unitOfMeasure">
											<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
										</xsl:attribute>
										<requestedQuantity>
											<xsl:value-of select="ConfirmedQuantity"/>
										</requestedQuantity>
										<tradeItemIdentification>
											<gtin>
												<xsl:choose>
													<xsl:when test="ProductID/GTIN != ''">
														<xsl:value-of select="ProductID/GTIN"/>
													</xsl:when>
													<xsl:otherwise>00000000000000</xsl:otherwise>
												</xsl:choose>
											</gtin>
											<additionalTradeItemIdentification>
												<additionalTradeItemIdentificationValue>
													<xsl:value-of select="ProductID/SuppliersProductCode"/>
												</additionalTradeItemIdentificationValue>
												<additionalTradeItemIdentificationType>SUPPLIER_ASSIGNED</additionalTradeItemIdentificationType>
											</additionalTradeItemIdentification>
											<xsl:if test="ProductID/BuyersProductCode != ''">
												<additionalTradeItemIdentification>
													<additionalTradeItemIdentificationValue>
														<xsl:value-of select="ProductID/BuyersProductCode"/>
													</additionalTradeItemIdentificationValue>
													<additionalTradeItemIdentificationType>BUYER_ASSIGNED</additionalTradeItemIdentificationType>
												</additionalTradeItemIdentification>
											</xsl:if>
										</tradeItemIdentification>
									</modifiedOrderInformation>
								</orderModificationLineItemLevel>
							</xsl:for-each>
						</orderModification>
					</xsl:if>
				</order:orderResponse>
			</eanucc:message>
		</sh:StandardBusinessDocument>
	</xsl:template>
</xsl:stylesheet>
