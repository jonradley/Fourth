<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a confirmation into Moto csv format

 © Alternative Business Solutions Ltd., 2007.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           	| Description of modification
******************************************************************************************
 12/07/2007	| A Sheppard	| Created module for 1290
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:script="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:template match="/">
			<xsl:text>"H"</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsCodeForSender)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msGetCurrentDate()"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatDate(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatDate(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSVAndTruncate(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/ContactName, 30)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatForCSV(/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsBranchReference)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="script:msFormatDate(/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate)"/>
			<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
				<xsl:text>&#xD;</xsl:text>
				<xsl:text>"D"</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(ProductID/BuyersProductCode)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(ProductID/SuppliersProductCode)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSVAndTruncate(ProductDescription, 50)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(LineNumber)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(ConfirmedQuantity)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(PackSize)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msGetLineAction(@LineStatus)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(SubstitutedProductID/SuppliersProductCode)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSVAndTruncate(Narrative, 100)"/>
			</xsl:for-each>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : msFormatForCSVAndTruncate
		' Description 	 : Formats the string for a csv file and truncates
		' Inputs          	 : String, Length of truncation
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatForCSVAndTruncate(vsString, vlLength)
		{
			return msFormatForCSV(vsString).substr(0, vlLength);
				
		}
		/*=========================================================================================
		' Routine       	 : msFormatForCSV
		' Description 	 : Formats the string for a csv file
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatForCSV(vsString)
		{
			if(vsString.length > 0)
			{
				vsString = vsString(0).text;
			}
			else
			{
				return '';
			}
			
			while(vsString.indexOf('"') != -1)
			{
				vsString = vsString.replace('"','¬');
			}
			while(vsString.indexOf('¬') != -1)
			{
				vsString = vsString.replace('¬','""');
			}
					
			return '"' + vsString + '"';
				
		}
		
		/*=========================================================================================
		' Routine       	 : msGetLineAction
		' Description 	 : Converts tradesimple line actions into Moto ones
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msGetLineAction(vsAction)
		{
			if(vsAction.length > 0)
			{
				vsAction = vsAction(0).text;
			}
			else
			{
				return '';
			}
			
			switch(vsAction)
			{
				case 'Accepted':
					vsAction = 'A';
					break;
				case 'Rejected':
					vsAction = 'R';
					break;
				case 'Added':
					vsAction = 'D';
					break;
				default:
					vsAction = 'C';
					break;
			}
					
			return '"' + vsAction + '"';
				
		}

		/*=========================================================================================
		' Routine       	 : msFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in "dd/mm/yyyy" format
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatDate(vsDate)
		{
		
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return '"' + vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(0,4) + '"';
			}
			else
			{
				return '';
			}
				
		}
		/*=========================================================================================
		' Routine       	 : msGetCurrentDate
		' Description 	 : Gets the current date in the format "dd/mm/yyyy hh:nn:ss"
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 12/07/2007
		' Alterations   	 : 
		'========================================================================================*/
		function msGetCurrentDate()
		{
			var dtDate = new Date();
			var sReturn = '"';
			
			if(dtDate.getDate() < 10)
			{
				sReturn += '0';
			}
			sReturn += dtDate.getDate() + '/';
	
			if(dtDate.getMonth() < 9)
			{
				sReturn += '0';
			}
			sReturn += (dtDate.getMonth() + 1) + '/';
			sReturn += dtDate.getYear() + ' ';
			
			if(dtDate.getHours() < 10)
			{
				sReturn += '0';
			}
			sReturn += dtDate.getHours() + ':';
			
			if(dtDate.getMinutes() < 10)
			{
				sReturn += '0';
			}
			sReturn += dtDate.getMinutes() + ':';
			
			if(dtDate.getSeconds() < 10)
			{
				sReturn += '0';
			}
			sReturn += dtDate.getSeconds() + '"';

			return sReturn;
		}
	]]></msxsl:script>
</xsl:stylesheet>