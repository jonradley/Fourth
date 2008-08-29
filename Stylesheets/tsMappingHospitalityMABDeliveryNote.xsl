<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                              xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
                              xmlns:deliver="urn:ean.ucc:deliver:2" 
                              xmlns:eanucc="urn:ean.ucc:2"
                              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                              exclude-result-prefixes="fo xsl">
	<xsl:template match="DeliveryNote">
		<sh:StandardBusinessDocument>
			<xsl:attribute name="xsi:schemaLocation">http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader ../Schemas/sbdh/StandardBusinessDocumentHeader.xsd urn:ean.ucc:2 ../Schemas/DespatchAdviceProxy.xsd</xsl:attribute>
			<sh:StandardBusinessDocumentHeader>
				<sh:HeaderVersion>2.2</sh:HeaderVersion>
				<sh:Sender>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
						<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
					</sh:Identifier>
				</sh:Sender>
				<sh:Receiver>
					<sh:Identifier Authority="EAN.UCC">
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
						<xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>
					</sh:Identifier>
				</sh:Receiver>
				<sh:DocumentIdentification>
					<sh:Standard>EAN.UCC</sh:Standard>
					<sh:TypeVersion>2.0.2</sh:TypeVersion>
					<sh:InstanceIdentifier>
						<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
					</sh:InstanceIdentifier>
					<sh:Type>DispatchAdvice</sh:Type>
					<sh:MultipleType>false</sh:MultipleType>
					<sh:CreationDateAndTime>
						<xsl:value-of select="concat(DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate,'T00:00:00')"/>
					</sh:CreationDateAndTime>
				</sh:DocumentIdentification>
			</sh:StandardBusinessDocumentHeader>
			<eanucc:message>
				<entityIdentification>
					<uniqueCreatorIdentification>
						<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
					</uniqueCreatorIdentification>
					<contentOwner>
						<gln>
							<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
						</gln>
					</contentOwner>
				</entityIdentification>
				<eanucc:transaction>
					<entityIdentification>
						<uniqueCreatorIdentification>
							<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
						</uniqueCreatorIdentification>
						<contentOwner>
							<gln>
								<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
							</gln>
						</contentOwner>
					</entityIdentification>
					<command>
						<eanucc:documentCommand>
							<documentCommandHeader type="ADD">
								<entityIdentification>
									<uniqueCreatorIdentification>
										<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
									</uniqueCreatorIdentification>
									<contentOwner>
										<gln>
											<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
										</gln>
									</contentOwner>
								</entityIdentification>
							</documentCommandHeader>
							<documentCommandOperand>
								<deliver:despatchAdvice>
									<xsl:attribute name="creationDateTime">
										<xsl:value-of select="concat(DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate,'T00:00:00')"/>
									</xsl:attribute>
									<xsl:attribute name="documentStatus">ORIGINAL</xsl:attribute>
									<xsl:attribute name="xsi:schemaLocation">urn:ean.ucc:2 ../Schemas/DespatchAdviceProxy.xsd</xsl:attribute>
									<contentVersion>
										<versionIdentification>2.0.2</versionIdentification>
									</contentVersion>
									<documentStructureVersion>
										<versionIdentification>2.0.2</versionIdentification>
									</documentStructureVersion>
									<estimatedDelivery>
										<estimatedDeliveryDateTime>
											<xsl:value-of select="concat(DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate,'T00:00:00')"/>
										</estimatedDeliveryDateTime>
									</estimatedDelivery>
									<carrier>
										<gln>
											<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
										</gln>
									</carrier>
									<shipper>
										<gln>
											<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
										</gln>
									</shipper>
									<shipFrom>
										<gln>
											<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
										</gln>
									</shipFrom>
									<shipTo>
										<gln>0000000000000</gln>
										<xsl:if test="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode != ''">
											<additionalPartyIdentification>
												<additionalPartyIdentificationValue>
													<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
												</additionalPartyIdentificationValue>
												<additionalPartyIdentificationType>SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
											</additionalPartyIdentification>
										</xsl:if>
										<additionalPartyIdentification>
											<additionalPartyIdentificationValue>
											<xsl:choose>
												<xsl:when test="DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode != ''">
													<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
												</xsl:otherwise>
											</xsl:choose>
											</additionalPartyIdentificationValue>
											<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
										</additionalPartyIdentification>
									</shipTo>
									<receiver>
										<gln>0000000000000</gln>
										<xsl:if test="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode != ''">
											<additionalPartyIdentification>
												<additionalPartyIdentificationValue>
													<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
												</additionalPartyIdentificationValue>
												<additionalPartyIdentificationType>SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
											</additionalPartyIdentification>
										</xsl:if>
										<additionalPartyIdentification>
											<additionalPartyIdentificationValue>
											<xsl:choose>
												<xsl:when test="DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode != ''">
													<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
												</xsl:otherwise>
											</xsl:choose>
											</additionalPartyIdentificationValue>
											<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
										</additionalPartyIdentification>
									</receiver>
									<despatchAdviceIdentification>
										<uniqueCreatorIdentification>
											<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
										</uniqueCreatorIdentification>
										<contentOwner>
											<gln>
												<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
											</gln>
										</contentOwner>
									</despatchAdviceIdentification>
									<deliveryNote>
										<referenceDateTime>
											<xsl:value-of select="concat(DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate,'T00:00:00')"/>
										</referenceDateTime>
										<referenceIdentification>
											<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
										</referenceIdentification>
									</deliveryNote>
									<orderIdentification>
										<referenceDateTime>
											<xsl:value-of select="concat(DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate,'T00:00:00')"/>
										</referenceDateTime>
										<referenceIdentification>
											<xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
										</referenceIdentification>
									</orderIdentification>
									<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">
										<despatchItem>
											<xsl:attribute name="number">
												<xsl:value-of select="LineNumber"/>
											</xsl:attribute>
											<tradeItemUnit>
												<itemContained>
													<quantityContained>
														<measurementValue unitOfMeasure="1">
															<xsl:attribute name="unitOfMeasure">
																<xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/>
															</xsl:attribute>
															<value>
																<xsl:value-of select="DespatchedQuantity"/>
															</value>
														</measurementValue>
													</quantityContained>
													<containedItemIdentification>
														<gtin>
															<xsl:choose>
																<xsl:when test="ProductID/GTIN != '' and ProductID/GTIN != '55555555555555'">
																	<xsl:value-of select="ProductID/GTIN"/>
																</xsl:when>
																<xsl:otherwise>00000000000000</xsl:otherwise>
															</xsl:choose>
														</gtin>
														<xsl:if test="ProductID/SuppliersProductCode">
															<additionalTradeItemIdentification>
																<additionalTradeItemIdentificationValue>
																	<xsl:value-of select="ProductID/SuppliersProductCode"/>
																</additionalTradeItemIdentificationValue>
																<additionalTradeItemIdentificationType>SUPPLIER_ASSIGNED</additionalTradeItemIdentificationType>
															</additionalTradeItemIdentification>
														</xsl:if>
														<xsl:if test="ProductID/BuyersProductCode">
															<additionalTradeItemIdentification>
																<additionalTradeItemIdentificationValue>
																	<xsl:value-of select="ProductID/BuyersProductCode"/>
																</additionalTradeItemIdentificationValue>
																<additionalTradeItemIdentificationType>BUYER_ASSIGNED</additionalTradeItemIdentificationType>
															</additionalTradeItemIdentification>
														</xsl:if>
													</containedItemIdentification>
													<orderIdentification>
														<xsl:attribute name="number">
															<xsl:value-of select="LineNumber"/>
														</xsl:attribute>
														<reference>
															<referenceDateTime>
																<xsl:value-of select="concat(/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate,'T00:00:00')"/>
															</referenceDateTime>
															<referenceIdentification>
																<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
															</referenceIdentification>
														</reference>
													</orderIdentification>
													<deliveryNote number="1">
														<xsl:attribute name="number">
															<xsl:value-of select="LineNumber"/>
														</xsl:attribute>
														<reference>
															<referenceDateTime>
																<xsl:value-of select="concat(/DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate,'T00:00:00')"/>
															</referenceDateTime>
															<referenceIdentification>
																<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
															</referenceIdentification>
														</reference>
													</deliveryNote>
												</itemContained>
											</tradeItemUnit>
										</despatchItem>
									</xsl:for-each>
								</deliver:despatchAdvice>
							</documentCommandOperand>
						</eanucc:documentCommand>
					</command>
				</eanucc:transaction>
			</eanucc:message>
		</sh:StandardBusinessDocument>
	</xsl:template>
</xsl:stylesheet>
