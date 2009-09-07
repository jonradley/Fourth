<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal Good received note  into a Saffron csv format for Mitie Catering.
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 28/08/2009	| Rave Tech		| 3093 Created Module
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>	
	
	<xsl:template match="/GoodsReceivedNote">

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!--### HEADER LINE ###-->
		<xsl:text>GRNHEAD</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- GRN Reference -->
		<xsl:value-of select="substring(GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference,1,20)"/>
		<xsl:text>,</xsl:text>
		
		<!-- Order Reference -->
		<xsl:value-of select="substring(GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference,1,13)"/>
		<xsl:text>,</xsl:text>
		
		<!-- Supplier Code -->
		<xsl:choose>
			<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'#')">
				<xsl:value-of select="substring(substring-after(TradeSimpleHeader/RecipientsCodeForSender,'#'),1,10)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,10)"/>
			</xsl:otherwise>
		</xsl:choose>		
		<xsl:text>,</xsl:text>		

		<!-- Delivery Date -->
		<xsl:value-of select="script:msFormatDate(GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliveryDate)"/>
		<xsl:text>,</xsl:text>		
		
		<!-- Unit Code -->
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsBranchReference,1,10)"/>			

		<!--### ITEM LINES ###-->
		<xsl:for-each select="(GoodsReceivedNoteDetail/GoodsReceivedNoteLine)">

			<xsl:value-of select="$NewLine"/>
			<xsl:text>INVITEM,</xsl:text>
			
			<!-- GRN Reference -->			
			<xsl:value-of select="substring(/GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference,1,20)"/>
			<xsl:text>,</xsl:text>	
					
			<!-- Product Reference -->
			<xsl:value-of select="substring(ProductID/SuppliersProductCode,1,20)"/>
			<xsl:text>,</xsl:text>
			
			<!-- Product Description -->			
			<xsl:value-of select="substring(ProductDescription,1,50)"/>
			<xsl:text>,</xsl:text>
			
			<!-- Product Pack Size -->
			<xsl:value-of select="substring(normalize-space(PackSize),1,20)"/>
			<xsl:text>,</xsl:text>
			
			<!-- Quantity -->
			<xsl:value-of select="format-number(AcceptedQuantity,'0.000')"/>
			<xsl:text>,</xsl:text>
			
			<!-- Unit price ex VAT -->
			<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
			<xsl:text>,</xsl:text>
			
			<!-- LineValueExclVAT -->
			<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
						
		</xsl:for-each>	
		<xsl:value-of select="$NewLine"/>	
	</xsl:template>
		
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 

		/*=========================================================================================
		' Routine       	 : msFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in yyyymmdd format
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatDate(vsDate)
		{
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return vsDate.substr(0,4) + "" +vsDate.substr(5,2) + "" + vsDate.substr(8,2);
			}
			else
			{
				return '';
			}
		}

	]]></msxsl:script>
</xsl:stylesheet>
