<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal GRNs into a Aramark fixed width format.
 The files will be concatenated by the outbound batch processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 07/05/2008	| A Sheppard	| Created Module
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>

	<xsl:template match="/">

		<xsl:for-each select="//GoodsReceivedNoteLine">
			<xsl:if test="script:mbIsNotFirstLine()">
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:if>
			<xsl:text>3</xsl:text>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersName, 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersName, 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode, 10)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToName, 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine1, 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2, 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine4, 30)"/>
			<xsl:value-of select="script:msPad('', 2)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/PostCode, 10)"/>
			<xsl:value-of select="script:msPad('', 30)"/>
			<xsl:value-of select="script:msPad('United Kingdom', 30)"/>
			<xsl:text>GRN-</xsl:text><xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference, 11)"/>
			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
			<xsl:value-of select="script:msPad(ProductID/SuppliersProductCode, 20)"/>
			<xsl:value-of select="script:msPad(AcceptedQuantity/@UnitOfMeasure, 10)"/>
			<xsl:value-of select="script:msPadNumber(0, 9, 0)"/>
			<xsl:value-of select="script:msPad(PackSize, 15)"/>
			<xsl:value-of select="script:msPadNumber(AcceptedQuantity, 7, 2)"/>
			<xsl:value-of select="script:msPadNumber(UnitValueExclVAT, 10, 4)"/>
			<xsl:value-of select="script:msPadNumber(LineValueExclVAT, 9, 2)"/>
			<xsl:value-of select="script:msPad(LineExtraData/Manufacturer, 40)"/>
			<xsl:value-of select="script:msPad(LineExtraData/Brand, 40)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
		  	<xsl:choose>
				<xsl:when test="ProductID/GTIN and ProductID/GTIN != '55555555555555' and Product/GTIN != '0000000000000'">
					<xsl:value-of select="script:msPad(ProductID/GTIN, 15)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="script:msPad('', 15)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPad(ProductDescription, 75)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('N', 1)"/>
			<xsl:choose>
				<xsl:when test="LineValueExclVAT &lt; 0">
					<xsl:value-of select="script:msPad('Y', 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="script:msPad('N', 1)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msGetCurrentDate()"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference, 22)"/>
			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
			<xsl:value-of select="script:msPadNumber(/GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT, 12, 2)"/>
			<xsl:value-of select="script:msPad('', 3)"/>
			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryDate"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode, 20)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode, 20)"/>
			<xsl:value-of select="script:msPad('', 30)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(LineNumber, 6, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad(LineExtraData/PurchaseCategoryCode, 10)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
		</xsl:for-each>

	</xsl:template>
		
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		var mbIsFirstLine = true;
		function mbIsNotFirstLine()
		{
			var bIsFirstLine = mbIsFirstLine;
			mbIsFirstLine = false;
			return (!bIsFirstLine);
		}
		
		/*=========================================================================================
		' Routine       	 : msPad
		' Description 	 : Pads the string to the appropriate length
		' Inputs          	 : A string, the desired length
		' Outputs       	 : None
		' Returns       	 : The string padded/truncated as necessary
		' Author       		 : A Sheppard, 07/05/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msPad(vsString, vlLength)
		{
			try
			{
				vsString = vsString(0).text;
			}
			catch(e){}
			
			try
			{
				vsString = vsString.substr(0, vlLength);
			}
			catch(e)
			{
				vsString = '';
			}
			
			while(vsString.length < vlLength)
			{
				vsString = vsString + ' ';
			}
			
			return vsString
				
		}
		
		/*=========================================================================================
		' Routine       	 : msPadNumber
		' Description 	 : Pads the number to the appropriate length with appropriate number of implied dps
		' Inputs          	 : A string, the desired length
		' Outputs       	 : None
		' Returns       	 : The string padded/truncated as necessary
		' Author       		 : A Sheppard, 07/05/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msPadNumber(vvNumber, vlLength, vlDPs)
		{
			try
			{
				vvNumber = parseFloat(vvNumber(0).text);
			}
			catch(e){}
			
			try
			{
				vvNumber = parseFloat(vvNumber);
			}
			catch(e)
			{
				vvNumber = '0';
			}
			
			vvNumber = vvNumber * Math.pow(10, vlDPs);
			
			vvNumber = '' + parseInt(vvNumber);
			
			while(vvNumber.length < vlLength)
			{
				vvNumber = '0' + vvNumber;
			}
			
			return vvNumber.substr(0, vlLength);
				
		}

		/*=========================================================================================
		' Routine       	 : msGetCurrentDate
		' Description 	 : Gets the current date in the format "yyyy-mm-dd"
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 07/05/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msGetCurrentDate()
		{
			var dtDate = new Date();
			var sReturn = '';
			
			sReturn = dtDate.getYear() + '-';
			
			if(dtDate.getMonth() < 9)
			{
				sReturn += '0';
			}
			
			sReturn += (dtDate.getMonth() + 1) + '-';
			
			if(dtDate.getDate() < 10)
			{
				sReturn += '0';
			}
			sReturn += dtDate.getDate();

			return sReturn;
		}

	]]></msxsl:script>
</xsl:stylesheet>