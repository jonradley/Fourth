<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a HospitalityLynx Goods Received Note into the customer defined XML

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 17/11/2004 | S Hewitt       | Created
******************************************************************************************
 06/11/2008 | Lee Boyton     | 2551. Pull unit number from Buyers code for Ship To field.
******************************************************************************************
 07/11/2008 | Lee Boyton     | 2551. Hot fix for King UK receipts, pull unit number from
                             | Recipients Branch Reference if Buyers code for Ship To field is blank.
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		       exclude-result-prefixes="xsl msxsl user"
		       xmlns="nexus_xml_version_1">
	<xsl:output method="xml"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	<xsl:template match="/">
	
		<xsl:element name="Nexus">	
			<xsl:element name="Header">
				
				<!-- Document Type -->
				<xsl:element name="Document">
					<xsl:attribute name="DocType">DN</xsl:attribute>
					<xsl:element name="DocTypeDesc">Delivery Note</xsl:element>
				</xsl:element>
				
				<!-- Currency -->		
				<xsl:element name="Currency">
					<xsl:attribute name="CurrCode">GBP</xsl:attribute>					
					<xsl:element name="CurrCodeDesc">Pound Stirling</xsl:element>
				</xsl:element>
				
				<!-- Unit number -->
				<xsl:element name="Reference">
					<xsl:attribute name="RefType">UNO</xsl:attribute>
					
					<xsl:element name="RefDesc">Unit Number</xsl:element>
					
					<xsl:element name="RefCode">
						<xsl:choose>
							<xsl:when test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode != ''">
								<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/RecipientsBranchReference"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:element>

				<!-- Delivery note number -->
				<xsl:element name="Reference">
					<xsl:attribute name="RefType">NAM</xsl:attribute>
					
					<xsl:element name="RefDesc">Document Name</xsl:element>
					
					<xsl:element name="RefCode">
						<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
					</xsl:element>
				</xsl:element>
			
				<!-- PO number -->
				<xsl:element name="Reference">
					<xsl:attribute name="RefType">ORD</xsl:attribute>
					
					<xsl:element name="RefDesc">Order Reference number</xsl:element>
					
					<xsl:element name="RefCode">
						<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
					</xsl:element>
				</xsl:element>			

				<!-- GRN date -->
				<xsl:element name="DateInfo">
					<xsl:attribute name="DateType">DDA</xsl:attribute>
					
					<xsl:element name="DateDesc">Document Date</xsl:element>
					
					<xsl:element name="Date">
						<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
					</xsl:element>
				</xsl:element>		
			
				<!-- Supplier Scan Ref -->
				<xsl:element name="Supplier">
					<xsl:element name="PartyCode">
						<xsl:attribute name="IdType">SSR</xsl:attribute>

						<xsl:element name="IdDesc">Suppliers Scan Ref</xsl:element>
						
						<xsl:element name="IdCode">
							<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>		
				
				<!-- Narrative -->
				<xsl:element name="Narrative"/>
			</xsl:element>
				
			<!-- Body -->
			<xsl:element name="Body">
				
				<!-- Now we can do each line -->
				<xsl:for-each select="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
					
					<xsl:element name="Line">
						<xsl:attribute name="LineType">GDS</xsl:attribute>
						<xsl:attribute name="LineAction">1</xsl:attribute>
						
						<xsl:element name="LineTypeDesc">Goods</xsl:element>
						
						<xsl:element name="LineActionDesc">Added Line</xsl:element>
						
						<!-- Line number -->
						<xsl:element name="LineNo">
							<xsl:value-of select="LineNumber"/>
						</xsl:element>
						
						<!-- Line value excl VAT -->
						<xsl:element name="LineTotal">
							<xsl:value-of select="LineValueExclVAT"/>
						</xsl:element>
						
						<!-- Product code and description -->
						<xsl:element name="Product">
							<xsl:attribute name="ProdCodeType">SPC</xsl:attribute>
							
							<xsl:element name="ProdCodeDesc">Suppliers product Code</xsl:element>
							
							<xsl:element name="ProdNum">
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</xsl:element>

							<xsl:element name="Description">
								<xsl:value-of select="ProductDescription"/>
							</xsl:element>
						</xsl:element>
						
						<!-- Accepted quantity -->
						<xsl:element name="Quantity">
							<xsl:attribute name="QtyCode">DEL</xsl:attribute>
							
							<xsl:element name="QtyCodeDesc">Delivered Quantity</xsl:element>
							
							<xsl:element name="QuantityAmount">
								<xsl:value-of select="AcceptedQuantity"/>
							</xsl:element>
						</xsl:element>
						
						<!-- Unit Price excl VAT -->
						<xsl:element name="Price">
							<xsl:attribute name="PriceType">COS</xsl:attribute>
							
							<xsl:element name="PriceTypeDesc">Cost Price</xsl:element>
							
							<xsl:element name="PriceAmount">
								<xsl:value-of select="UnitValueExclVAT"/>
							</xsl:element>
						</xsl:element>
						
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>