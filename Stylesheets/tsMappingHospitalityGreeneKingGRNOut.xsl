<?xml version="1.0" encoding="UTF-8"?>
<!--
================================================================================================================
Maps internal GRNs into outbound Greene King EANUCC format

================================================================================================================
***********************************************************************************************************************************************************************************
Date       	 	| Name         | Description of modification
***********************************************************************************************************************************************************************************
10/02/2016	| M Dimant   | FB10792: Created.
***********************************************************************************************************************************************************************************
15/03/2016	| M Dimant   | FB10875: Corrected logic around how we pass the suppliers code and strip out sequence number for Aurora.  
**********************************************************************************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:gdsn="urn:ean.ucc:2" xmlns:despatch_advice="urn:ean.ucc:despatch_advice:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com" >
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  	
<xsl:template match="/GoodsReceivedNote">
<despatch_advice:despatchAdviceMessage>	 
<sh:StandardBusinessDocumentHeader>
    <sh:HeaderVersion>1.0</sh:HeaderVersion>
    <sh:Sender>
      <sh:Identifier Authority="GS1" />
      <sh:ContactInformation>
        <sh:Contact>
			<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersName"/></sh:Contact>
        <sh:ContactTypeIdentifier>Buyer</sh:ContactTypeIdentifier>
      </sh:ContactInformation>
    </sh:Sender>
    <sh:Receiver>
      <sh:Identifier Authority="GS1" />
      <sh:ContactInformation>
        <sh:Contact><xsl:value-of select="TradeSimpleHeader/RecipientsName"/></sh:Contact>
        <sh:ContactTypeIdentifier>Seller</sh:ContactTypeIdentifier>
      </sh:ContactInformation>
    </sh:Receiver>
    <sh:DocumentIdentification>
      <sh:Standard>GS1</sh:Standard>
      <sh:TypeVersion>3.1</sh:TypeVersion>
      <sh:InstanceIdentifier><xsl:value-of select="GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/></sh:InstanceIdentifier>
      <sh:Type>Despatch Advice Message</sh:Type>
      <sh:CreationDateAndTime><xsl:value-of select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/></sh:CreationDateAndTime>
    </sh:DocumentIdentification>
  </sh:StandardBusinessDocumentHeader>
  <despatchAdvice>
    <creationDateTime><xsl:value-of select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/></creationDateTime>
    <documentStatusCode>ORIGINAL</documentStatusCode>
    <despatchAdviceIdentification>
      <entityIdentification><xsl:value-of select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/></entityIdentification>
      <contentOwner>
        <gln><xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersLocationID/GLN"/></gln>
      </contentOwner>
    </despatchAdviceIdentification>
    <receiver>
      <gln><xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersLocationID/GLN"/></gln>
    </receiver>
    <shipper>
      <gln>><xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/GLN"/></gln>
    </shipper>
    <buyer>
      <gln><xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersLocationID/GLN"/></gln>
      <additionalPartyIdentification additionalPartyIdentificationTypeCode="BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY" codeListVersion="1">
		  <xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
      </additionalPartyIdentification>
    </buyer>
    <seller>
      <gln><xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/GLN"/></gln>
      <additionalPartyIdentification additionalPartyIdentificationTypeCode="BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY" codeListVersion="1">
      <!-- Map Spirit's code for supplier to Aurora code -->
      <xsl:choose>
		  	<xsl:when test="contains(GoodsReceivedNoteHeader/Supplier/SuppliersName, 'Greene King')">
				<xsl:text>10645349</xsl:text>
			</xsl:when>
			<xsl:when test="contains(GoodsReceivedNoteHeader/Supplier/SuppliersName, 'Kuehne')">
				<xsl:text>10286266</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>No Aurora code found in mapping</xsl:text>
			</xsl:otherwise>						
		</xsl:choose>
      </additionalPartyIdentification>
    </seller>
    <shipTo>
      <gln><xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/GLN"/></gln>
      <additionalPartyIdentification additionalPartyIdentificationTypeCode="BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY" codeListVersion="1">
		  <!-- Remove sequence number (001) from supplier's code as this cannot be accepted in Aurora -->
		  <xsl:variable name="SuppCode" select="GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		  <xsl:choose>
					  <!-- Check if last 3 digits are 001 --> 
					<xsl:when test="substring($SuppCode,string-length($SuppCode) - 6,string-length($SuppCode)) = '    001'">
						<xsl:value-of select="substring-before(GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode,'    001')"/>
					</xsl:when>
					<!-- If not, then just pass whole code across -->
					<xsl:otherwise>					
						<xsl:value-of select="($SuppCode) "/>
					</xsl:otherwise>
			</xsl:choose>
      </additionalPartyIdentification>
      <additionalPartyIdentification additionalPartyIdentificationTypeCode="SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY" codeListVersion="1">
		     <!-- Remove sequence number (001) from supplier's code as this cannot be accepted in Aurora -->
		  <xsl:variable name="SuppCode" select="GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		  <xsl:choose>
					  <!-- Check if last 3 digits are 001 --> 
					<xsl:when test="substring($SuppCode,string-length($SuppCode) - 6,string-length($SuppCode)) = '    001'">
						<xsl:value-of select="substring-before(GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode,'    001')"/>
					</xsl:when>
					<!-- If not, then just pass whole code across -->
					<xsl:otherwise>					
						<xsl:value-of select="($SuppCode) "/>
					</xsl:otherwise>
			</xsl:choose>
      </additionalPartyIdentification>
    </shipTo>
    <despatchInformation>
      <actualShipDateTime><xsl:value-of select="GoodsReceivedNoteHeader/DeliveryNoteReferences/DespatchDate"/></actualShipDateTime>
    </despatchInformation>
    <purchaseOrder>
      <entityIdentification><xsl:value-of select="GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/></entityIdentification>
      <contentOwner>
        <gln><xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersLocationID/GLN"/></gln>
      </contentOwner>
      <creationDateTime><xsl:value-of select="GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/></creationDateTime>
    </purchaseOrder>
    <despatchAdviceLogisticUnit>
		<xsl:for-each select="GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
		  <despatchAdviceLineItem>
			<lineItemNumber><xsl:value-of select="LineNumber"/></lineItemNumber>
			<despatchedQuantity><xsl:value-of select="DeliveredQuantity"/></despatchedQuantity>
			<extension>
			  <gdsn:attributeValuePairExtension>
				<gdsn:value name="transactionalItemPrice"><xsl:value-of select="UnitValueExclVAT"/></gdsn:value>
			  </gdsn:attributeValuePairExtension>
			  <gdsn:attributeValuePairExtension>
				<gdsn:value name="transactionalItemUnitOfMeasure"><xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/></gdsn:value>
			  </gdsn:attributeValuePairExtension>
			  <gdsn:attributeValuePairExtension>
				<gdsn:value name="transactionalItemCategory"><xsl:value-of select="ProductDescription"/></gdsn:value>
			  </gdsn:attributeValuePairExtension>
			</extension>
			<requestedQuantity><xsl:value-of select="OrderedQuantity"/></requestedQuantity>
			<transactionalTradeItem>
			  <gtin><xsl:value-of select="GTIN"/></gtin>
			  <additionalTradeItemIdentification additionalTradeItemIdentificationTypeCode="SUPPLIER_ASSIGNED">
				  <xsl:value-of select="ProductID/SuppliersProductCode"/>
			  </additionalTradeItemIdentification>
			  <additionalTradeItemIdentification additionalTradeItemIdentificationTypeCode="BUYER_ASSIGNED">
				  <xsl:value-of select="ProductID/SuppliersProductCode"/>
			  </additionalTradeItemIdentification>
			  <tradeItemQuantity>
			   <xsl:attribute name="measurementUnitCode"><xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/></xsl:attribute> 
			   <xsl:attribute name="codeListVersion">1</xsl:attribute>
				   <xsl:value-of select="DeliveredQuantity"/>
			   </tradeItemQuantity>
			  <tradeItemDescription languageCode="en" codeListVersion="ISO 639-1"><xsl:value-of select="ProductDescription"/></tradeItemDescription>			 
			</transactionalTradeItem>
		  </despatchAdviceLineItem>
		</xsl:for-each>    
    </despatchAdviceLogisticUnit>
  </despatchAdvice>
</despatch_advice:despatchAdviceMessage>	  
</xsl:template>		  
	
</xsl:stylesheet>
