<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 Maps individual Coda delivery notesready to be concatenated by tsProcessorLPCCodaDCNBatch

 © Alternative Business Solutions Ltd, 2005.
==========================================================================================
 Module History
==========================================================================================
 Date           	 	| Name             	| Description of modification
==========================================================================================
 25/10/2005        | A Sheppard    | Created module
==========================================================================================
 03/11/2005        | Lee Boyton    | H522. We now have the house code for 'CDC' lines.
=========================================================================================
 29/06/2006		     | Lee Boyton    | H604. Cater for house code location change.
=========================================================================================
 03/07/2006        | Lee Boyton    | H604. Cater for old documents without Buyer code fields.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:template match="*">
		<!--Get the document total for use later-->
		<xsl:for-each select="/DeliveryNote/DeliveryNoteDetail/DeliveryNoteLine">
			<xsl:value-of select="script:mStoreTotal(DespatchedQuantity * UnitValueExclVAT)"/>
		</xsl:for-each>
		
		<!--Put the Coda company code at the top of the file (will be used and then removed by the batch processor)-->
		<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/HeaderExtraData/CodaCompanyCode"/>
		
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Add the pub stock receipt line-->
		<!-- Cater for old documents that do not have a Buyers code, by using the Suppliers code instead -->
		<xsl:choose>
			<xsl:when test="/DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
				<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
			</xsl:otherwise>
		</xsl:choose>															
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msFormatDate">
			<xsl:with-param name="vsDate" select="/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="format-number(format-number(script:mdGetTotal(), '0.000'), '0.00')"/>
		<xsl:text>,</xsl:text>
		<xsl:text>D</xsl:text>
		
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Add the CDC stock reduction line-->
		<xsl:text>9000</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="msFormatDate">
			<xsl:with-param name="vsDate" select="/DeliveryNote/DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="format-number(format-number(script:mdGetTotal(), '0.000'), '0.00')"/>
		<xsl:text>,</xsl:text>
		<xsl:text>C</xsl:text>
	</xsl:template>

	<!--Formats the xml date as dd/mm/yyyy-->
	<xsl:template name="msFormatDate">
		<xsl:param name="vsDate"/>
		<xsl:value-of select="substring($vsDate,9,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($vsDate,6,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($vsDate,1,4)"/>
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 	
		/*=========================================================================================
		' Routine       	 : mStoreTotal and mdGetTotal
		' Description 	 : Adds up the totals
		' Inputs          	 : Line Value
		' Outputs       	 : None
		' Returns       	 : Total
		' Author       		 : A Sheppard, 25/10/2005.
		' Alterations   	 : 
		'========================================================================================*/
		var mdTotal = 0;
		function mStoreTotal(vdTotal)
		{
			mdTotal += parseFloat(vdTotal);
			return '';
		}
		function mdGetTotal()
		{
			return mdTotal;
		}
	]]></msxsl:script>

</xsl:stylesheet>
