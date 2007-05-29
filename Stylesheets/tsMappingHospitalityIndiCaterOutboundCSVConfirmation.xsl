<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 Outbound confirmation csv mapper, based on inbound format outlined in section 2.4 of
 
 								O:\Hospitality Sector\Adoption\Documents\CSV specification v1-2.pdf


 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 08/06/2006	|R Cambridge	| Created module
==========================================================================================
 12/12/2006	| A Sheppard	| 605. Made it work
==========================================================================================
 23/05/2007	| R Cambridge	| 1123. Made it work some more
======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="utf-8"/>


	<xsl:template match="/">	
	
	
		<xsl:text>H,</xsl:text>
		<xsl:call-template name="msCSV">
			<xsl:with-param name="vs">
				<xsl:choose>
					<xsl:when test="contains(/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsCodeForSender,'#')">
						<xsl:value-of select="substring-before(/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsCodeForSender,'#')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsCodeForSender"/>
					</xsl:otherwise>
				</xsl:choose>				
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsBranchReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="translate(/PurchaseOrderConfirmation/TradeSimpleHeader/TestFlag,'TRUE','true') = 'true'">Y</xsl:when>
			<xsl:when test="/PurchaseOrderConfirmation/TradeSimpleHeader/TestFlag ='1'">Y</xsl:when>
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msReplace">
			<xsl:with-param name="string" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
			<xsl:with-param name="search-for" select="'-'"/>
			<xsl:with-param name="replace-with" select="''"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msReplace">
			<xsl:with-param name="string" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate"/>
			<xsl:with-param name="search-for" select="'-'"/>
			<xsl:with-param name="replace-with" select="''"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msReplace">
			<xsl:with-param name="string" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
			<xsl:with-param name="search-for" select="'-'"/>
			<xsl:with-param name="replace-with" select="''"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msReplace">
			<xsl:with-param name="string" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart"/>
			<xsl:with-param name="search-for" select="':'"/>
			<xsl:with-param name="replace-with" select="''"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msReplace">
			<xsl:with-param name="string" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotEnd"/>
			<xsl:with-param name="search-for" select="':'"/>
			<xsl:with-param name="replace-with" select="''"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ContactName"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToName"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine1"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine2"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine3"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/AddressLine4"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/PostCode"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationTrailer/NumberOfLines"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="sum(/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/ConfirmedQuantity)"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationTrailer/TotalExclVAT"/></xsl:call-template>
		<xsl:text>&#13;&#10;</xsl:text>
	
		
		<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
		
			<xsl:text>D,</xsl:text>
			<xsl:choose>
				<xsl:when test="@LineStatus = 'Accepted'">A</xsl:when>
				<xsl:when test="@LineStatus = 'Rejected'">R</xsl:when>
				<xsl:when test="@LineStatus = 'Changed'">C</xsl:when>
				<xsl:when test="@LineStatus = 'Added'">S</xsl:when>
				<xsl:when test="@LineStatus = 'Breakage'">C</xsl:when>
				<xsl:when test="@LineStatus = 'PriceChanged'">C</xsl:when>
				<xsl:when test="@LineStatus = 'QuantityChanged'">C</xsl:when>
				<xsl:otherwise>Unknown</xsl:otherwise>
			</xsl:choose>			
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="ProductID/SuppliersProductCode"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="SubstitutedProductID/SuppliersProductCode"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="ProductDescription"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="PackSize"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="OrderedQuantity"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="ConfirmedQuantity"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="UnitValueExclVAT"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="LineValueExclVAT"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="msCSV"><xsl:with-param name="vs" select="Narrative"/></xsl:call-template>
			<xsl:if test="position() != last()">
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:if>
		
		</xsl:for-each>
	
	
	</xsl:template>
	
<!--=======================================================================================
  Routine        : msCSV()
  Description    : Puts " around a string if it contains a comma and replaces " with ""
  Inputs         : A string
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msCSV">
		<xsl:param name="vs"/>
		<xsl:if test="contains($vs,',') or contains($vs,'&quot;')">
			<xsl:text>"</xsl:text>	
		</xsl:if>
		<xsl:call-template name="msQuotes">
			<xsl:with-param name="vs" select="$vs"/>
		</xsl:call-template>
		<xsl:if test="contains($vs,',') or contains($vs,'&quot;')">
			<xsl:text>"</xsl:text>	
		</xsl:if>
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
	
	<!--=======================================================================================
	  Routine       	: msReplace
	  Description 	: template for replacing all occurences of a certain char with a new char
	  Inputs          	: string - the string to edit
	  			   	  search-for - the string to be replaced
	  			   	  replace-with - the replacement string
	  Returns       	: The edited string
	  Author         	: A Sheppard
	  Alterations    	: 
	 =======================================================================================-->
	<xsl:template name="msReplace">
		<xsl:param name="string" />
		<xsl:param name="search-for" />
		<xsl:param name="replace-with" />
		<xsl:choose>
			<xsl:when test='contains($string,$search-for)'>
				<xsl:value-of select="substring-before($string,$search-for)"/>
				<xsl:value-of select="$replace-with"/>
				<xsl:call-template name="msReplace">
					<xsl:with-param name="string" select="substring-after($string,$search-for)" />
					<xsl:with-param name="search-for" select="$search-for" />
					<xsl:with-param name="replace-with" select="$replace-with" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



</xsl:stylesheet>
