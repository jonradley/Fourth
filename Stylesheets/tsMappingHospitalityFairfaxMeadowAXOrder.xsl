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
           Loads of stuff it seems
******************************************************************************************
 19/08/2009   	| R Cambridge   	| 3021 Add delivery instructions                    
******************************************************************************************
 09/04/2010		| R Cambridge  	| 3455 Added Distribution depot code for 3663 Greene King
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
				<xsl:choose>
				
					<xsl:when test="TradeSimpleHeader/RecipientsCodeForSender = 'BS' and string(PurchaseOrderHeader/Buyer/BuyersName) != ''">
						<xsl:text>&quot;</xsl:text>
						<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/>
						<xsl:text>&quot;</xsl:text>
					</xsl:when>
					
					<xsl:when test="PurchaseOrderHeader/ShipTo/ContactName != '.'">
						<xsl:text>&quot;</xsl:text>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ContactName"/>
						<xsl:text>&quot;</xsl:text>
					</xsl:when>					
					
					<xsl:otherwise/>
					
				</xsl:choose>				
				
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Name -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToName != '.'">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address Line 1 -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 != '.' and string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1) != string		(PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1)">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address Line 2 -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2 != '.' and string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2) != string		(PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2)">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address Line 3 -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3 != '.'and string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3) != string		(PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3)">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address Line 4 -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4 != '.'and string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4) != string		(PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4)">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				<!-- Delivery Location Address PostCode -->
				<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode != '.'and string(PurchaseOrderHeader/ShipTo/ShipToAddress/Postcode) != string		(PurchaseOrderHeader/Buyer/BuyersAddress/Postcode)">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
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
			<xsl:when test="'GK' = PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
				<!-- If this order is from 3663 for Greene King add the price file code -->
				<xsl:text>HGK</xsl:text>
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
			<xsl:when test="'GK' = PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode">
				<xsl:value-of select="PurchaseOrderHeader/HeaderExtraData/DistributionDepotCode"/>
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
		<xsl:text>,</xsl:text>
		
		
		<!-- Invoice to details from BroadStripe orders (taken from the inbound file as they'll never be held on tradesimple) -->
		<xsl:choose>
			<!-- Don't supply address details for customers that don't have trade simple branches -->
			<xsl:when test="TradeSimpleHeader/RecipientsCodeForSender = 'BS'">
				
				<xsl:if test="PurchaseOrderHeader/Buyer/BuyersName != ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>				
				
				<xsl:if test="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1 != ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>				
				
				<xsl:if test="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2!= ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				
				
				<xsl:if test="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3 != ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				
				
				<xsl:if test="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4 != ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				
				
				<xsl:if test="PurchaseOrderHeader/Buyer/BuyersAddress/PostCode != ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersAddress/PostCode"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				
				
				
				<xsl:if test="PurchaseOrderHeader/HeaderExtraData/BuyerContactTelephoneNumber != ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="PurchaseOrderHeader/HeaderExtraData/BuyerContactTelephoneNumber"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				<xsl:text>,</xsl:text>
				
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>,</xsl:text>
			</xsl:otherwise>
			
		</xsl:choose>
		
		<xsl:text>,</xsl:text>
		<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">		
			<xsl:text>&quot;</xsl:text>
			<xsl:call-template name="msQuotes">
				<xsl:with-param name="vs" select="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
			</xsl:call-template>
			<xsl:text>&quot;</xsl:text>			
		</xsl:if>

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
			<xsl:choose>
				<xsl:when test="string(LineExtraData/InvalidUOM) != ''">
					<xsl:value-of select="LineExtraData/InvalidUOM"/>
				</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>		
			</xsl:otherwise>		
			</xsl:choose>
			
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

<!--=======================================================================================
  Routine        : msQuotes
  Description    : Recursively searches for " and replaces it with ""
  Inputs         : A string
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msQuotes">
		<xsl:param name="vs"/>
		
		<xsl:choose>
		
			<xsl:when test="$vs=''"/><!-- base case-->
			
			<xsl:when test="substring($vs,1,1)='&quot;'"><!-- " found -->
				<xsl:value-of select="substring($vs,1,1)"/>
				<xsl:value-of select="'&quot;'"/>				
				<xsl:call-template name="msQuotes">
					<xsl:with-param name="vs" select="substring($vs,2)"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:otherwise><!-- other character -->
				<xsl:value-of select="substring($vs,1,1)"/>
				<xsl:call-template name="msQuotes">
					<xsl:with-param name="vs" select="substring($vs,2)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
</xsl:stylesheet>
