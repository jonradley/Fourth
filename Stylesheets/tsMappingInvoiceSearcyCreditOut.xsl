<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a (Sun) csv format for Searcy.
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name           | Description of modification
******************************************************************************************
 26/06/08 | G Lokhande | Created module.
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:user="http://mycompany.com/mynamespace"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">

       <xsl:output method="text"/>
       <xsl:include href="HospitalityInclude.xsl"/>
       
       <!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.
            note;  the '::' literal is simply used as a convenient separator for the 2 values that make up the second key. -->
       <xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="LineExtraData/AccountCode"/>
       <xsl:key name="keyLinesByAccountAndVAT" match="InvoiceLine | CreditNoteLine" use="concat(LineExtraData/AccountCode,'::',VATCode)"/>
       
       <xsl:template match="/Invoice | /CreditNote">
             <xsl:variable name="NewLine">
                    <xsl:text>&#13;&#10;</xsl:text>
             </xsl:variable>
             <xsl:variable name="RowTypeIndicator">
                    <xsl:text>2;</xsl:text>
             </xsl:variable>

             <xsl:variable name="InvoiceNo">
                    <xsl:choose>
                           <xsl:when test="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference">
                                 <xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
                           </xsl:when>
                           <xsl:otherwise>
                                 <xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
                           </xsl:otherwise>
                    </xsl:choose>
             </xsl:variable>  
             
             <xsl:variable name="InvoiceDate">
                    <xsl:choose>
                           <xsl:when test="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate">
					<xsl:value-of select="script:msFormatDate(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate)"/>
                           </xsl:when>
                           <xsl:otherwise>
					<xsl:value-of select="script:msFormatDate(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate)"/>
                           </xsl:otherwise>
                    </xsl:choose>
             </xsl:variable>
             
             <xsl:variable name="SuppliersName">
                    <xsl:choose>
                           <xsl:when test="/Invoice/InvoiceHeader/Supplier/SuppliersName">
                                 <xsl:value-of select="substring(translate(/Invoice/InvoiceHeader/Supplier/SuppliersName,',',''),1,50)"/>
                           </xsl:when>
                           <xsl:otherwise>
                                 <xsl:value-of select="substring(translate(/CreditNote/CreditNoteHeader/Supplier/SuppliersName,',',''),1,50)"/>
                           </xsl:otherwise>
                    </xsl:choose>
             </xsl:variable>
             
             <xsl:variable name="JournalType"><xsl:text>JournalType</xsl:text></xsl:variable>
             <xsl:variable name="Department"><xsl:text>Department</xsl:text></xsl:variable>
             <xsl:variable name="VAT"><xsl:value-of select="VATCode"/></xsl:variable >        
             <xsl:variable name="SupplierCode" select="TradeSimpleHeader/RecipientsCodeForSender"/>
             <xsl:variable name="UnitName">
                    <xsl:choose>
                           <xsl:when test="/Invoice/InvoiceHeader/Supplier/SuppliersName">
                                 <xsl:value-of select="substring(translate(/Invoice/TradeSimpleHeader/RecipientsName,',',''),1,50)"/>
                           </xsl:when>
                           <xsl:otherwise>
                                 <xsl:value-of select="substring(translate(/CreditNote/TradeSimpleHeader/RecipientsName,',',''),1,50)"/>
                           </xsl:otherwise>
                    </xsl:choose>
             </xsl:variable>

             <xsl:variable name="OperatorCode"> <xsl:text>tradesimple</xsl:text> </xsl:variable>
             
             <xsl:variable name="AccountingPeriod">                        
             <xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>
              <xsl:text>0</xsl:text>
             <xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
             </xsl:variable>
             
             <!-- Header Line-->
		<!--<xsl:text>1;,Invoice Number,Transaction date,Account Code,Suppliers detail,Amount,Department ,VAT,Supplier Code,Journal Type,Description,Operator code,Accounting Period</xsl:text>
             <xsl:value-of select="$NewLine"/>-->

             <!--Display Purchases-->          
             <!-- use the keys for grouping Lines by Account Code and then by VAT Code -->
             <!-- the first loop will match the first line in each set of lines grouped by Account Code -->
             <xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
                    <xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
                    <xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>
                    <!-- now, given we can find all lines for the current Account Code, loop through and match the first line for each unique VAT Code -->
                    <xsl:for-each select="key('keyLinesByAccount',$AccountCode)[generate-id() = generate-id(key('keyLinesByAccountAndVAT',concat($AccountCode,'::',VATCode))[1])]">
                           <xsl:sort select="VATCode" data-type="text"/>
                           <xsl:variable name="VATCode" select="VATCode"/>
                           
                           <!-- now output a summary line for the current Account Code and VAT Code combination -->
                           <xsl:value-of select="$RowTypeIndicator"/>
                           <xsl:text>,</xsl:text>                          
                           <xsl:value-of select="$InvoiceNo"/>
                           <xsl:text>,</xsl:text>                          
                           <xsl:value-of select="$InvoiceDate"/>
                           <xsl:text>,</xsl:text>
                           <xsl:value-of select="$AccountCode"/>
                           <xsl:text>,</xsl:text>
                           <xsl:text>Cost of Sale</xsl:text>   
                           <xsl:text>,</xsl:text>
                           <xsl:choose>
                                  <xsl:when test="/Invoice">
                                         <xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00')"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                         <xsl:value-of select="format-number(-1 * sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00')"/>
                                  </xsl:otherwise>
                           </xsl:choose>
                           <xsl:text>,</xsl:text>
                           <xsl:value-of select="$Department"/>
                           <xsl:text>,</xsl:text>      
                           <xsl:value-of select="VATCode"/>
                            <xsl:text>,</xsl:text>
                           <xsl:value-of select="$SupplierCode"/>
                           <xsl:text>,</xsl:text>                   
                           <xsl:value-of select="$JournalType"/>
                           <xsl:text>,Purchase Invoice - </xsl:text>                                 
                           <xsl:value-of select="$UnitName"/>
                           <xsl:text>,</xsl:text>
                           <xsl:value-of select="$OperatorCode"/>
                           <xsl:text>,</xsl:text>
                           <xsl:value-of select="$AccountingPeriod"/>                                                                                                                                                                
                           <xsl:value-of select="$NewLine"/>
                    </xsl:for-each>
             </xsl:for-each>
             
             <!--Display Taxes-->
             <xsl:for-each select="//VATSubTotal[@VATRate != 0.00]">
                    <xsl:value-of select="$RowTypeIndicator"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$InvoiceNo"/>
                    <xsl:text>,</xsl:text>                   
                    <xsl:value-of select="$InvoiceDate"/>
                    <xsl:text>,</xsl:text>
                    <xsl:text>700400</xsl:text>
                    <xsl:text>,</xsl:text>
                    <xsl:text>VAT INPUTS</xsl:text>
                    <xsl:text>,</xsl:text>
                    <xsl:choose>
                           <xsl:when test="/Invoice">
                                 <xsl:value-of select="format-number(VATAmountAtRate,'0.00')"/>
                           </xsl:when>
                           <xsl:otherwise>
                                 <xsl:value-of select="format-number(-1 * VATAmountAtRate,'0.00')"/>
                           </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$Department"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="VATCode"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$SupplierCode"/>
                    <xsl:text>,</xsl:text>                   
                    <xsl:value-of select="$JournalType"/>
                    <xsl:text>,Purchase Invoice - </xsl:text>
                    <xsl:value-of select="$UnitName"/>
                    <xsl:text>,</xsl:text>                          
                    <xsl:value-of select="$OperatorCode"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="VATTrailerExtraData/BuyersVATCode"/>                    
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$AccountingPeriod"/>                                        
                    <xsl:value-of select="$NewLine"/>
             </xsl:for-each>
             
             <!--Display Supplier-->
             <xsl:value-of select="$RowTypeIndicator"/>
             <xsl:text>,</xsl:text>
             <xsl:value-of select="$InvoiceNo"/>
             <xsl:text>,</xsl:text>             
             <xsl:value-of select="$InvoiceDate"/>
             <xsl:text>,</xsl:text>
             <xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
             <xsl:text>,</xsl:text>
             <xsl:value-of select="$SuppliersName"/>
             <xsl:text>,</xsl:text>
                    <xsl:choose>
                    <xsl:when test="/Invoice/InvoiceTrailer/SettlementTotalInclVAT">
                           <xsl:value-of select="format-number(-1 * /Invoice/InvoiceTrailer/SettlementTotalInclVAT,'0.00')"/>
                    </xsl:when>
                    <xsl:otherwise>
                           <xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementTotalInclVAT,'0.00')"/>
                    </xsl:otherwise>
             </xsl:choose>
             <xsl:text>,</xsl:text>
             <xsl:value-of select="$Department"/>
             <xsl:text>,</xsl:text>
             <xsl:value-of select="translate(VATCode, ',', ';')"/>           
             <xsl:text>,</xsl:text>      
             <xsl:value-of select="$SupplierCode"/>
             <xsl:text>,</xsl:text>      
             <xsl:value-of select="$JournalType"/>
             <xsl:text>,Purchase Invoice - </xsl:text>
             <xsl:value-of select="$UnitName"/>           
             <xsl:text>,</xsl:text>      
             <xsl:value-of select="$OperatorCode"/>
             <xsl:text>,</xsl:text>
             <xsl:value-of select="$AccountingPeriod"/>             
             <xsl:value-of select="$NewLine"/>
       </xsl:template>
             
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
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
				return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(2,2);
			}
			else
			{
				return '';
			}
		}
	]]></msxsl:script>
</xsl:stylesheet>


