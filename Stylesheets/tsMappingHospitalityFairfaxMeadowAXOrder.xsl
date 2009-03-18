<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview


 © Fourth Hospitality 2009
******************************************************************************************
 Module History
******************************************************************************************
 Date         | Name       		| Description of modification
******************************************************************************************
     ?       	|       ?       	| Created
******************************************************************************************
 27/01/2009  	| R Cambridge   	| 2666 Extra fields for 3663 orders
******************************************************************************************
	          	|              	|	                                                            
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:template match="PurchaseOrder">
		<!-- Row Type -->
		<xsl:text>H</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Recipient’s Code for Unit -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- test flag -->
		<xsl:choose>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'false'">N</xsl:when>
			<xsl:otherwise>Y</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!-- Purchase Order Reference -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Purchase Order Date YYYYMMDD -->
		<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
		<xsl:text>,</xsl:text>
		<!-- Requested Delivery Date YYYYMMDD -->
		<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>
		<xsl:text>,</xsl:text>
		<!--Delivery Slot Start Time HHMM -->
		<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
		<xsl:text>,</xsl:text>
		<!-- Delivery Slot End Time HHMM -->
		<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<!-- Don't supply address details for customers that don't have trade simple branches -->
				<xsl:when test="TradeSimpleHeader/RecipientsCodeForSender = 'MC'">
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!-- Delivery Location Contact -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ContactName != '.'">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ContactName"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Name -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToName != '.'">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address Line 1 -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 != '.'">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address Line 2 -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2 != '.'">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address Line 3 -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3 != '.'">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address Line 4 -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4 != '.'">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address PostCode -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode != '.'">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!-- Number of Lines -->
		<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:text>,</xsl:text>
		<!-- Number of Items -->
		<xsl:value-of select="sum(PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/>
		<xsl:text>,</xsl:text>
		<!-- Order Total Ex VAT -->
		<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>
		<xsl:text>,</xsl:text>
		<!-- Recipient’s Branch Reference -->
		<xsl:text>&quot;</xsl:text>
		<!-- Normally this field contains FM's code the price file / contract / agreement / purchase ledger -->
		<xsl:choose>
			<xsl:when test="'36' = PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
				<!-- If this order is from 3663 add the price file code (there's only no agreement so no PL account TR to store this in) -->
				<xsl:text>BAR</xsl:text>
			</xsl:when>
			<xsl:when test="'PM' = PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
				<!-- If this order is from 3663 add the price file code (there's only no agreement so no PL account TR to store this in) -->
				<xsl:text>TPM</xsl:text>
			</xsl:when>
			<xsl:when test="'BS' = PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
				<!-- If this order is from 3663 add the price file code (there's only no agreement so no PL account TR to store this in) -->
				<xsl:text>RBS</xsl:text>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>


		<!-- CustomerOrderNumber -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/HeaderExtraData/CustomerOrderNumber"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>	
		<!-- DistributionDepotCode -->
		<!--xsl:value-of select="PurchaseOrderHeader/HeaderExtraData/DistributionDepotCode"/-->	
		<xsl:choose>
			<xsl:when test="'PM' = PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
				<!-- get the 'TH' bit -->
				<xsl:value-of select="PurchaseOrderHeader/HeaderExtraData/DistDepotCode"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/SendersBranchReference"/>		
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>	
		<!-- CustomerDeliveryDate -->
		<xsl:value-of select="translate(PurchaseOrderHeader/HeaderExtraData/CustomerDeliveryDate,'-','')"/>	
		<xsl:text>,</xsl:text>					
		<!-- RouteNumber -->
		<xsl:value-of select="PurchaseOrderHeader/HeaderExtraData/RouteNumber"/>		
		<xsl:text>,</xsl:text>		
		<!-- DropNumber -->
		<xsl:value-of select="PurchaseOrderHeader/HeaderExtraData/DropNumber"/>
	

		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<!-- Row Type -->
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Supplier’s Product Code -->
			<xsl:choose>
				<xsl:when test="ProductID/SuppliersProductCode !=''">
					<xsl:text>"</xsl:text>
					<xsl:value-of select="ProductID/SuppliersProductCode"/>
					<xsl:text>"</xsl:text>
					<xsl:text>,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>"</xsl:text>
					<xsl:value-of select="ProductID/BuyersProductCode"/>
					<xsl:text>"</xsl:text>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Product Description -->
			<xsl:if test="'not provided' != translate(ProductDescription,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')">
				<xsl:text>&quot;</xsl:text>
				<xsl:value-of select="ProductDescription"/>
				<xsl:text>&quot;</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>
			<!-- Pack Size -->
			<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:text>,</xsl:text>
			<!-- Quantity -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			<!-- Unit Price Ex VAT -->
			<xsl:choose>
				<xsl:when test="string(UnitValueExclVAT) != ''">
					<xsl:value-of select="UnitValueExclVAT"/>
				</xsl:when>
				<xsl:otherwise>0.00</xsl:otherwise>
			</xsl:choose>			
			<xsl:text>,</xsl:text>
			<!-- Line Value Ex VAT -->
			<xsl:choose>
				<xsl:when test="string(LineValueExclVAT) != ''">
					<xsl:value-of select="LineValueExclVAT"/>
				</xsl:when>
				<xsl:otherwise>0.00</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<!-- Original Line from order on distributor -->
			<xsl:value-of select="LineExtraData/CustomerLineNumber"/>
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
