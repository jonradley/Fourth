<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 Rail Gourmet map for invoices and credits batches to JDE.

 © Fourth, 2013
==========================================================================================
 Module History
==========================================================================================
 Date			| Name					| Description of modification
==========================================================================================
 20/08/2013	| Andrew Barber		| FB6908 Created module 
=======================================================================================-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:script="http://mycompany.com/mynamespace"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	exclude-result-prefixes="#default xsl msxsl script">
	
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:param name="nBatchID">Not Provided</xsl:param>
	
	<xsl:template match="/BatchRoot">
	
		<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
		
		<!-- Batch Header -->
		<xsl:text>F</xsl:text>
		<xsl:text>PURINVOIC</xsl:text>
		<xsl:value-of select="script:msPad(substring(Invoice/TradeSimpleHeader/RecipientsCodeForSender,4,5),5)"/>
		<xsl:value-of select="script:msPad(concat('20',$sFileGenerationDate),8)"/>
		<xsl:value-of select="$nBatchID"/>
		<xsl:value-of select="script:msPad('',48)"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="Invoice">
		
			<!-- Invoice Header -->
			<xsl:text>H</xsl:text>
			<xsl:value-of select="script:msPad(InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference,10)"/>
			<xsl:text>OP</xsl:text>
			<xsl:value-of select="script:msPad(InvoiceHeader/InvoiceReferences/InvoiceReference,25)"/>
			<xsl:call-template name="formatDate">
				<xsl:with-param name="yyyymmddFormat" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			</xsl:call-template>
			<xsl:value-of select="script:msPadNumber(InvoiceTrailer/NumberOfItems,6,0)"/>
			<xsl:value-of select="script:msPadNumber(InvoiceTrailer/SettlementTotalExclVAT,8,2)"/>
			<xsl:value-of select="script:msPadNumber(InvoiceTrailer/VATAmount,8,2)"/>
			<xsl:value-of select="script:msPadNumber(InvoiceTrailer/SettlementTotalInclVAT,8,2)"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
			<!-- Invoice Detail -->
			<xsl:for-each select="InvoiceDetail/InvoiceLine">
				<xsl:text>D</xsl:text>
				<xsl:value-of select="script:msPad(PurchaseOrderReferences/PurchaseOrderReference,10)"/>
				<xsl:value-of select="script:msPad(LineNumber,3)"/>
				<xsl:value-of select="script:msPad(ProductID/SuppliersProductCode,20)"/>
				<xsl:value-of select="script:msPad(format-number(InvoicedQuantity,0),5)"/>
				<xsl:value-of select="script:msPadNumber(LineValueExclVAT,8,2)"/>
				<xsl:value-of select="script:msPad(VATCode,1)"/>
				<xsl:value-of select="script:msPadNumber(VATRate,5,2)"/>
				<xsl:value-of select="script:msPadNumber(LineValueExclVAT * (VATRate div 100),8,2)"/>
				<xsl:value-of select="script:msPadNumber(LineValueExclVAT+ (LineValueExclVAT * (VATRate div 100)),8,2)"/>
				<xsl:value-of select="script:msPad('',22)"/>
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			
			<!-- VAT Summaries -->
			<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
				<xsl:text>V</xsl:text>
				<xsl:value-of select="script:msPad(../../../InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference,10)"/>
				<xsl:text>OP</xsl:text>
				<xsl:value-of select="script:msPad(../../../InvoiceHeader/InvoiceReferences/InvoiceReference,25)"/>
				<xsl:value-of select="script:msPad(@VATCode,1)"/>
				<xsl:value-of select="script:msPadNumber(@VATRate,5,2)"/>
				<xsl:value-of select="script:msPad(NumberOfLinesAtRate,5)"/>
				<xsl:value-of select="script:msPadNumber(SettlementTotalExclVATAtRate,8,2)"/>
				<xsl:value-of select="script:msPadNumber(VATAmountAtRate,8,2)"/>
				<xsl:value-of select="script:msPadNumber(SettlementTotalInclVATAtRate,8,2)"/>
				<xsl:value-of select="script:msPad('',3)"/>
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			
		</xsl:for-each>
		
		<xsl:for-each select="CreditNote">
		
			<!-- Invoice Header -->
			<xsl:text>H</xsl:text>
			<xsl:value-of select="script:msPad(CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderReference,10)"/>
			<xsl:text>OP</xsl:text>
			<xsl:value-of select="script:msPad(CreditNoteHeader/CreditNoteReferences/CreditNoteReference,25)"/>
			<xsl:call-template name="formatDate">
				<xsl:with-param name="yyyymmddFormat" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</xsl:call-template>
			<xsl:value-of select="script:msPadNumber(CreditNoteTrailer/NumberOfItems,6,0)"/>
			<xsl:value-of select="script:msPadNumber(CreditNoteTrailer/SettlementTotalExclVAT,8,2)"/>
			<xsl:value-of select="script:msPadNumber(CreditNoteTrailer/VATAmount,8,2)"/>
			<xsl:value-of select="script:msPadNumber(CreditNoteTrailer/SettlementTotalInclVAT,8,2)"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
			<!-- Invoice Detail -->
			<xsl:for-each select="CreditNoteDetail/CreditNoteLine">
				<xsl:text>D</xsl:text>
				<xsl:value-of select="script:msPad(PurchaseOrderReferences/PurchaseOrderReference,10)"/>
				<xsl:value-of select="script:msPad(LineNumber,3)"/>
				<xsl:value-of select="script:msPad(ProductID/SuppliersProductCode,20)"/>
				<xsl:value-of select="script:msPad(format-number(InvoicedQuantity,0),5)"/>
				<xsl:value-of select="script:msPadNumber(LineValueExclVAT,8,2)"/>
				<xsl:value-of select="script:msPad(VATCode,1)"/>
				<xsl:value-of select="script:msPadNumber(VATRate,5,2)"/>
				<xsl:value-of select="script:msPadNumber(LineValueExclVAT * (VATRate div 100),8,2)"/>
				<xsl:value-of select="script:msPadNumber(LineValueExclVAT+ (LineValueExclVAT * (VATRate div 100)),8,2)"/>
				<xsl:value-of select="script:msPad('',22)"/>
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			
			<!-- VAT Summaries -->
			<xsl:for-each select="CreditNoteTrailer/VATSubTotals/VATSubTotal">
				<xsl:text>V</xsl:text>
				<xsl:value-of select="script:msPad(../../../CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderReference,10)"/>
				<xsl:text>OP</xsl:text>
				<xsl:value-of select="script:msPad(../../../CreditNoteHeader/CreditNoteReferences/CreditNoteReference,25)"/>
				<xsl:value-of select="script:msPad(@VATCode,1)"/>
				<xsl:value-of select="script:msPadNumber(@VATRate,5,2)"/>
				<xsl:value-of select="script:msPad(NumberOfLinesAtRate,5)"/>
				<xsl:value-of select="script:msPadNumber(SettlementTotalExclVATAtRate,8,2)"/>
				<xsl:value-of select="script:msPadNumber(VATAmountAtRate,8,2)"/>
				<xsl:value-of select="script:msPadNumber(SettlementTotalInclVATAtRate,8,2)"/>
				<xsl:value-of select="script:msPad('',3)"/>
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			
		</xsl:for-each>
		
		<!-- Batch Trailer -->
		<xsl:text>T</xsl:text>
		<xsl:value-of select="$nBatchID"/>
		<xsl:value-of select="script:msPadNumber(format-number(count(/BatchRoot/Invoice),'000000'),6,0)"/>
		<xsl:value-of select="script:msPad('',64)"/>
		
	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="yyyymmddFormat"/>
		<xsl:value-of select="concat(substring($yyyymmddFormat,1,4),substring($yyyymmddFormat,6,2),substring($yyyymmddFormat,9,2))"/>
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

		function msAddPaddingPrefix(vsString, vlLength, vsPrefix)
		{
			try
			{
				vsString = vsString(0).text;
			}
			catch(e){}
			while(vsString.length<vlLength)
			{
				vsString = vsPrefix + vsString;
			}
			return vsString.substring(vsString.length - vlLength)
		}
		
		/*=========================================================================================
		' Routine       	 : msPadNumber
		' Description 	 : Pads the number to the appropriate length with appropriate number of implied dps
		' Inputs          	 : A string, the desired length
		' Outputs       	 : None
		' Returns       	 : The string padded/truncated as necessary
		' Author       		 : A Sheppard, 07/05/2008
		' Alterations   	 : Rave Tech,   18/08/2009 FB3047 Handle negative value totals.
		'						 : R Cambridge, 10/01/2013   5159 For negatives, put minus sign immediately before numeric characters, not at left hand end of the padding
		'========================================================================================*/
		function msPadNumber(vvNumber, vlLength, vlDPs)
		{
			var sNumber = '';
						
			try
			{
				sNumber = vvNumber(0).text;
			}
			catch(e)
			{
				sNumber = vvNumber.toString();
			}
			
			if(sNumber.indexOf('.') != -1)
			{
				var lDPs;
		 
				lDPs = sNumber.length - sNumber.indexOf('.') - 1;
				
				if(lDPs > vlDPs)
				{
					sNumber = sNumber.substr(0, sNumber.length + vlDPs - lDPs);
					vlDPs = 0;
				}
				else
				{
					vlDPs -= lDPs;
				} 
			}
			
			for(var i=0; i<vlDPs; i++)
			{
				sNumber += '0';
			}
			
			sNumber = sNumber.replace('.','');
			
			
			while(sNumber.length < vlLength)
			{
				sNumber = ' ' + sNumber;
			}
			
			
			return sNumber.substr(0, vlLength);
				
		}

	]]></msxsl:script>
	
	<msxsl:script language="VBScript" implements-prefix="vb"><![CDATA[
	
	'==========================================================================================
	' Routine        : msFileGenerationDate()
	' Description    : 
	' Inputs         :  
	' Outputs        : 
	' Returns        : A string
	' Author         : Robert Cambridge
	' Version        : 1.0
	' Alterations    : (none)
	'==========================================================================================
	
	Function msFileGenerationDate()
	
	Dim sNow
	
		sNow = CStr(Date)
	
		msFileGenerationDate = Right(sNow,2) & Mid(sNow,4,2) & Left(sNow,2)
			
	End Function
	
	'==========================================================================================
	' Routine        : msFileGenerationTime()
	' Description    : 
	' Inputs         :  
	' Outputs        : 
	' Returns        : A string
	' Author         : Robert Cambridge
	' Version        : 1.0
	' Alterations    : (none)
	'==========================================================================================
	
	Function msFileGenerationTime()
	
	Dim sNow
	
		sNow = CStr(Time)
	
		msFileGenerationTime = Replace(sNow,":","")
				
	End Function
	
	]]></msxsl:script>
</xsl:stylesheet>
