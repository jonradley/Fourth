<!--
'******************************************************************************************
' Overview
'
' Maps iXML invoices into OFSCI format.
' 
' © Alternative Business Solutions Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name            | Description of modification
'******************************************************************************************
'  05/01/2011  | KO   		    | Created 
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'			 |                        |
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="xml"/>
<xsl:template match="/">

<sh:StandardBusinessDocument 
			xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
			xmlns:eanucc="urn:ean.ucc:2" 
			xmlns:order="urn:ean.ucc:order:2" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<sh:StandardBusinessDocumentHeader>
		<!--Fixed value version of Standard Business Header - depends on final format agreed-->
		<sh:HeaderVersion>2.3</sh:HeaderVersion>
		
		<sh:Sender>
			<sh:Identifier Authority="EAN.UCC">
				<xsl:value-of select="PurchaseOrderConfirmation/TradeSimpleHeader/SendersName"/>
			</sh:Identifier>
		</sh:Sender>
		
		<sh:Receiver>
			<sh:Identifier Authority="EAN.UCC">
				<xsl:value-of select="PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsName"/>
			</sh:Identifier>
		</sh:Receiver>
		
		<sh:DocumentIdentification>
			<sh:Standard>EAN.UCC</sh:Standard>
			<!--GS1 - Order Response version reference - Fixed value-->
			<sh:TypeVersion>2.3</sh:TypeVersion>
			<!--Message Instance identifier set by Vendor-->
			<sh:InstanceIdentifier>1111</sh:InstanceIdentifier>
			<!--Fixed value-->
			<sh:Type>OrderResponse</sh:Type>
			
			<sh:CreationDateAndTime>
				<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
				<xsl:text>T</xsl:text>
				<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderTime"/>			
			</sh:CreationDateAndTime>
			
		</sh:DocumentIdentification>
	</sh:StandardBusinessDocumentHeader>
	
	<eanucc:message>
		<entityIdentification>
		
			<uniqueCreatorIdentification>2222</uniqueCreatorIdentification>
			
			<contentOwner>
				<gln>
					<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
				</gln>
			</contentOwner>
			
		</entityIdentification>
		
		<!--This is specific for ITN and Fairfax-->
		<order:orderResponse>
			<xsl:attribute name="creationDateTime">
				<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="documentStatus">
				<!--Always original-->
				<xsl:text>ORIGINAL</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="responseStatusType">
				<!--Always original for Fairfax-->
				<xsl:text>ACKNOWLEDGED</xsl:text>
			</xsl:attribute>
		
			<responseIdentification>
				<uniqueCreatorIdentification/>
				<contentOwner>
					<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
				</contentOwner>
			</responseIdentification>
			
			<responseToOriginalDocument>
				<xsl:attribute name="referenceDocumentType">
					<!--Always 35-->
					<xsl:text>35</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="referenceIdentification">
					<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
				</xsl:attribute>
				<xsl:attribute name="referenceDateTime">
					<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
					<xsl:text>T</xsl:text>
					<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderTime"/>	
				</xsl:attribute>
			</responseToOriginalDocument>
			
			<buyer>
				<gln>
					<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/GLN"/>
				</gln>
				<additionalPartyIdentification>
				
					<additionalPartyIdentificationValue>
						<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode"/>
					</additionalPartyIdentificationValue>
					
					<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
				</additionalPartyIdentification>
			</buyer>
			
			<seller>
				<gln>
					<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/SuppliersLocationID/GLN"/>
				</gln>
				<additionalPartyIdentification>
					<additionalPartyIdentificationValue>
						<xsl:value-of select="PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</additionalPartyIdentificationValue>
					<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
				</additionalPartyIdentification>
			</seller>
			
		</order:orderResponse>
	</eanucc:message>
	</sh:StandardBusinessDocument>
</xsl:template>	
</xsl:stylesheet>
