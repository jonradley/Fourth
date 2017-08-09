<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 Maps internal XML into GS1 XML 3.2
 
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date     	 	| Name 					| Description of modification
==========================================================================================
 14/12/2015	| M Dimant			| FB10556: Created module
==========================================================================================
 
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                              xmlns:order="urn:ean.ucc:order:2"
                              xmlns:eanucc="urn:ean.ucc:2"
                              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                              exclude-result-prefixes="fo">
	<xsl:template match="PurchaseOrderAcknowledgement">
	
		<sh:StandardBusinessDocument>
			<xsl:attribute name="xsi:schemaLocation">http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader ../Schemas/sbdh/StandardBusinessDocumentHeader.xsd urn:ean.ucc:2 ../Schemas/OrderResponseProxy.xsd</xsl:attribute>
			<sh:StandardBusinessDocumentHeader>
				<sh:HeaderVersion>2.2</sh:HeaderVersion>
				<sh:Sender>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
						<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/GLN"/>
					</sh:Identifier>
				</sh:Sender>
				<sh:Receiver>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
						<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/GLN"/>
					</sh:Identifier>
				</sh:Receiver>
				<sh:DocumentIdentification>
					<sh:Standard>EAN.UCC</sh:Standard>
					<sh:TypeVersion>2.3</sh:TypeVersion>
					<sh:InstanceIdentifier>
						<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementReference"/>
					</sh:InstanceIdentifier>
					<sh:Type>OrderResponse</sh:Type>
					<sh:MultipleType>false</sh:MultipleType>
					<sh:CreationDateAndTime>
						<xsl:value-of select="concat(PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementDate,'T00:00:00')"/>
					</sh:CreationDateAndTime>
				</sh:DocumentIdentification>
			</sh:StandardBusinessDocumentHeader>
			<eanucc:message>
				<entityIdentification>
					<uniqueCreatorIdentification>
						<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementReference"/>
					</uniqueCreatorIdentification>
					<contentOwner>
						<gln>
							<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/GLN"/>
						</gln>
					</contentOwner>
				</entityIdentification>
				<order:orderResponse>
					<xsl:attribute name="creationDateTime">
						<xsl:value-of select="concat(PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementDate,'T00:00:00')"/>
					</xsl:attribute>				
					<xsl:attribute name="documentStatus">ORIGINAL</xsl:attribute>
					<xsl:attribute name="responseStatusType">
						<xsl:text>ACCEPTED</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="xsi:schemaLocation">urn:ean.ucc:2 ../Schemas/OrderResponseProxy.xsd</xsl:attribute>
					<responseIdentification>
						<uniqueCreatorIdentification>
							<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementReference"/>
						</uniqueCreatorIdentification>
						<contentOwner>
							<gln>
								<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/GLN"/>
							</gln>
						</contentOwner>
					</responseIdentification>
					<responseToOriginalDocument>
						<xsl:attribute name="referenceDateTime">
							<xsl:value-of select="concat(PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementDate,'T00:00:00')"/>
						</xsl:attribute>
						<xsl:attribute name="referenceDocumentType">35</xsl:attribute>
						<xsl:attribute name="referenceIdentification">
							<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
						</xsl:attribute>
					</responseToOriginalDocument>
					<buyer>
						<gln>
							<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/GLN"/>
						</gln>
					</buyer>
					<seller>
						<gln>
							<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/GLN"/>
						</gln>
					</seller>
				</order:orderResponse>
			</eanucc:message>
		</sh:StandardBusinessDocument>
	</xsl:template>
</xsl:stylesheet>
