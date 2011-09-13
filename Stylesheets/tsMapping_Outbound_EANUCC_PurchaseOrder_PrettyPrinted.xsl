<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

	Internal XML to EANUCC (OFSCI) PO - with CrLfs and indenting
	

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 12/04/2005	| Steven Hewitt		| Created module
==========================================================================================
 23/03/2006	| R Cambridge			| H578 Pretty printing
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="xsl msxsl">
	
	<xsl:output method="xml" encoding="utf-8"/>
	
	
	
	
<!--=======================================================================================
  Routine        : {default template}
  Description    : Creates OFSCI xml in a variable and pretty-prints thats into the results tree 
  Author         : Robert Cambridge
  Alterations    : 
 =======================================================================================-->
	<xsl:template match="/">
		
		<!-- get the OFSCI XML -->
		<xsl:variable name="sOFSCI_on1line">
			<xsl:call-template name="msABStoOFSCI">
				<xsl:with-param name="vobjRoot" select="/PurchaseOrder"/>				
			</xsl:call-template>		
		</xsl:variable>
		
		<!-- Pretty-print the XML -->
		<xsl:call-template name="msPrettyPrint">
			<xsl:with-param name="vobNode" select="msxsl:node-set($sOFSCI_on1line)"/>
			<xsl:with-param name="vsPadding" select="'&#13;&#10;'"/>	
							<xsl:with-param name="depth" select="0"/>	
		</xsl:call-template>
	
	</xsl:template>
	
	
	
		

<!--=======================================================================================
  Routine        : msABStoOFSCI()
  Description    : converts internal PO XML into OFSCI PO XML
  Inputs         : vobjRoot, the root of the internal XML
  Outputs        : 
  Returns        : XML on the results tree (ie in $sOFSCI_on1line of the default template)
  Author         : Robert Cambridge
  Alterations    : 
 =======================================================================================-->	
	<xsl:template name="msABStoOFSCI" >
		<xsl:param name="vobjRoot"/>
	
		<Order>
		
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			      ORDER DOCUMENT DETAILS 
			      ~~~~~~~~~~~~~~~~~~~~~~~ -->
			<OrderDocumentDetails>
				<PurchaseOrderDate format="YYYY-MM-DDThh:mm:ss:TZD">
					<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
					<xsl:text>T00:00:00</xsl:text>
				</PurchaseOrderDate>
				
				<PurchaseOrderNumber scheme="OTHER">
					<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
				</PurchaseOrderNumber>
				
				<xsl:if test="$vobjRoot/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
					<CustomerReference scheme="OTHER">
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
					</CustomerReference>
				</xsl:if>
				
				<!-- Document Status is always going to be 7 - original -->
				<DocumentStatus codeList="EANCOM">
					<xsl:text>7</xsl:text>
				</DocumentStatus>
			</OrderDocumentDetails>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    MOVEMENT DATE TIME
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<MovementDateTime format="YYYY-MM-DDThh:mm:ss:TZD">
				<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</MovementDateTime>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SLOT TIME
			      ~~~~~~~~~~~~~~~~~~~~~~~-->			
			<xsl:if test="$vobjRoot/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot">
				<SlotTime>
					<SlotStartTime format="YYYY-MM-DDThh:mm:ss:TZD">
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						<xsl:text>T</xsl:text>
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
					</SlotStartTime>
					
					<SlotEndTime format="YYYY-MM-DDThh:mm:ss:TZD">
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						<xsl:text>T</xsl:text>
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/>
					</SlotEndTime>
				</SlotTime>
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    MOVEMENT TYPE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<MovementType codeList="EANCOM">
				<xsl:choose>
					<!-- 'Collect' maps to '200' and the only other option is 'Delivery' which maps to 'X14' -->
					<xsl:when test="$vobjRoot/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryType = 'Collect'">
						<xsl:text>200</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>X14</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</MovementType>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    BUYER
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<Buyer>
				<BuyerGLN scheme="GLN">
					<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
				</BuyerGLN>
			
				<!--xsl:if test="$vobjRoot/PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode"-->
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/Buyer/BuyersLocationID/BuyersCode"/>
					</BuyerAssigned>
				<!--/xsl:if-->
	
				<!--xsl:if test="$vobjRoot/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"-->
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</SellerAssigned>
				<!--/xsl:if-->
			</Buyer>
		
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SELLER
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<Seller>
				<SellerGLN scheme="GLN">
					<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
				</SellerGLN>
			
				<xsl:if test="$vobjRoot/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
					</SellerAssigned>
				</xsl:if>
	
				<xsl:if test="$vobjRoot/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>
			</Seller>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SHIP TO
			      ~~~~~~~~~~~~~~~~~~~~~~~-->			
			<ShipTo>
				<ShipToGLN scheme="GLN">
					<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
				</ShipToGLN>
			
				<xsl:if test="$vobjRoot/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode">			
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>	


					<SellerAssigned scheme="OTHER">
						<xsl:choose>
							<xsl:when test="$vobjRoot/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode">
								<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$vobjRoot/TradeSimpleHeader/RecipientsCodeForSender"/>
							</xsl:otherwise>
						</xsl:choose>
					</SellerAssigned>			

				
				
			</ShipTo>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    TRADE AGREEMENT REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->		
			<!-- if TradeAgreement exists then TradeAgreement/ContractReference must also exist -->
			<xsl:if test="$vobjRoot/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement">	
				<TradeAgreementReference>
				
					<xsl:if test="$vobjRoot/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate">	
						<ContractReferenceDate format="YYYY-MM-DDThh:mm:ss:TZD">
							<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractDate"/>
							<xsl:text>T00:00:00</xsl:text>
						</ContractReferenceDate>
					</xsl:if>
					
					<ContractReferenceNumber scheme="OTHER">
						<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
					</ContractReferenceNumber>
				</TradeAgreementReference>
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    ORDER DETAILS
			      ~~~~~~~~~~~~~~~~~~~~~~~-->					
			<xsl:for-each select="$vobjRoot/PurchaseOrderDetail/PurchaseOrderLine">
				<xsl:sort data-type="number" select="LineNumber"/>
				
				<OrderDetails>
				
					<RequestedQuantity>
						<xsl:attribute name="unitCode">
							<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
						</xsl:attribute>
						
						<xsl:value-of select="format-number(OrderedQuantity,'0.000')"></xsl:value-of>
					</RequestedQuantity>
				
					<LineItemNumber scheme="OTHER">
						<xsl:value-of select="LineNumber"/>
					</LineItemNumber>
				
					<ItemIdentification>
						<GTIN scheme="GTIN">
							<xsl:value-of select="ProductID/GTIN"/>
						</GTIN>
						
						<!-- alternate code is sourced from the Suppliers code -->
						<xsl:if test="ProductID/SuppliersProductCode"> 
							<AlternateCode scheme="OTHER">
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</AlternateCode>
						</xsl:if>
					</ItemIdentification>
				</OrderDetails>			
			</xsl:for-each>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    DOCUMENT LINE ITEM COUNT
			      ~~~~~~~~~~~~~~~~~~~~~~~-->					
			<DocumentLineItemCount scheme="OTHER">
				<xsl:value-of select="count(//PurchaseOrderLine)"/>
			</DocumentLineItemCount>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SPECIAL DELIVERY REQUIREMENTS
			      ~~~~~~~~~~~~~~~~~~~~~~~-->			
			<xsl:if test="$vobjRoot/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">		
				<SpecialDeliveryRequirements>
					<xsl:value-of select="$vobjRoot/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
				</SpecialDeliveryRequirements>
			</xsl:if>
		</Order>
	</xsl:template>
	
	
	
<!--=======================================================================================
  Routine        : msPrettyPrint()
  Description    : Writes whitespace between XML elements, recursively.
							(There's probably an easier way of doing this)
  Inputs         : vobjNode, the element of the XML to be transformed
						  vsPadding, the whitespace required at this level of recursion
  Outputs        : 
  Returns        : (Pretty printed XML on the results tree)
  Author         : Robert Cambridge
  Alterations    : 
 =======================================================================================-->
	<xsl:template name="msPrettyPrint">
		<xsl:param name="vobNode"/>
		<xsl:param name="vsPadding"/>
		<xsl:param name="depth"/>		
		
		<xsl:choose>
		
			<!-- Skip the document root but not the root element! -->
			<xsl:when test="count(ancestor::*)=0 and name()=''">
			
				<xsl:for-each select="$vobNode/node()">
				
					<xsl:call-template name="msPrettyPrint">
						<xsl:with-param name="vobNode" select="."/>
						<xsl:with-param name="vsPadding" select="$vsPadding"/>
						<xsl:with-param name="depth" select="$depth + 1"/>		
					</xsl:call-template>				
				</xsl:for-each>
				
			</xsl:when>
			
			<xsl:otherwise>
			
				<!-- Pad this element -->				
				<xsl:value-of select="$vsPadding"/>
				
				<!-- Copy this element... -->
				<xsl:copy>
		
					<!-- ...copy its attributes... -->
					<xsl:for-each select="attribute::*">
						<xsl:copy>
							<xsl:value-of select="."/>				
						</xsl:copy>			
					</xsl:for-each>
				
					<!-- ...copy all other nodes... -->
					<xsl:for-each select="$vobNode/node()">
					
						<xsl:choose>
						
							<!-- ...if it's a text node just copy the value... -->
							<xsl:when test="name()=''"><xsl:value-of select="."/></xsl:when>
							
							<!-- ...if it's an element copy its children -->
							<xsl:otherwise>
		
								<xsl:call-template name="msPrettyPrint">
									<xsl:with-param name="vobNode" select="."/>
									<xsl:with-param name="vsPadding" select="concat($vsPadding,'&#9;')"/>
									<xsl:with-param name="depth" select="$depth + 1"/>		
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					
					</xsl:for-each>
					
					<!-- if this is the last non-text child, pad the closing tag too. -->
					<xsl:if test="last() and count(*) !=0">
						<xsl:value-of select="$vsPadding"/>
					</xsl:if>		
							
				</xsl:copy>
			
			</xsl:otherwise>
			
		</xsl:choose>
		
				
	</xsl:template>
	
</xsl:stylesheet>