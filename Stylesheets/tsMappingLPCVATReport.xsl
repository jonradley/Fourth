<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Laurel VAT Report into an HTML page

 © Alternative Business Solutions Ltd., 2003.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name     		| Description of modification
******************************************************************************************
 03/06/2003 | L Beattie 		| Created module.
******************************************************************************************
 06/11/2003 | L Boyton  		| H72. Minor changes for GENTRAN Batches.
******************************************************************************************
 19/06/2006 | A Sheppard 	| H604. Added debits
******************************************************************************************
 22/01/2007 | L Boyton 	| 705. Debit notes no longer required.
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
		      
<xsl:output method="html"/>
<xsl:template match="LaurelVATReport ">
<html>
<style>
	TABLE
	{
	    BORDER-BOTTOM: black thin solid;
	    BORDER-LEFT: black thin solid;
	    BORDER-RIGHT: black thin solid;
	    BORDER-TOP: black thin solid;    
	    BACKGROUND-COLOR: #f7f7e5;
	    FONT-SIZE: 10pt;
	    FONT-FAMILY: Arial; 
	    COLOR: BLACK;   
	    WIDTH: 100%;
	}
	TABLE.Header
	{
	    FONT-SIZE: 14pt;
	    BACKGROUND-COLOR: #003063;
	    COLOR: white;    
	    FONT-WEIGHT: Bold;
	}	
	TABLE.Address
	{
	    BACKGROUND-COLOR: Lemonchiffon;
	}
	TABLE.Address TH
	{
	    BACKGROUND-COLOR: #003063;
	    COLOR: white;  
	}
	TABLE.Products
	{
	    BACKGROUND-COLOR: Lemonchiffon;
	    COLOR: black;  
	    BORDER-BOTTOM: none;
	    BORDER-LEFT: none;
	    BORDER-RIGHT: none;
	    BORDER-TOP: none; 
	}
	TABLE.Products TH
	{
	    BACKGROUND-COLOR: #003063;
	    COLOR: white;  
	    BORDER-BOTTOM: black thin solid;
	    BORDER-LEFT: black thin solid;
	    BORDER-RIGHT: none;
	    BORDER-TOP: none; 
	}
	TABLE.Products TD
	{
	    BORDER-BOTTOM: black thin solid;
	    BORDER-LEFT: black thin solid;
	    BORDER-RIGHT: none;
	    BORDER-TOP: none; 
	    BACKGROUND-COLOR: Lemonchiffon;
	}
	TABLE.Products TD.Spacer
	{
	    BORDER-TOP: none;
	    BORDER-LEFT: none;
	    BORDER-RIGHT: none;
	    BORDER-BOTTOM: none;
	    BACKGROUND-COLOR: Lemonchiffon;
	}
	TABLE.Products TD.Supplier
	{
	    BORDER-BOTTOM: none;
	    BORDER-LEFT: none;
	    BORDER-RIGHT: none;
	    BORDER-TOP: none; 
	}
	TABLE.Summary
	{
	    BACKGROUND-COLOR: Lemonchiffon;
	    COLOR: black;  
	    BORDER-BOTTOM: none;
	    BORDER-LEFT: none;
	    BORDER-RIGHT: none;
	    BORDER-TOP: none; 
	}
	TABLE.Summary TH
	{
	    BACKGROUND-COLOR: #003063;
	    COLOR: white;  
	    BORDER-BOTTOM: black thin solid;
	    BORDER-LEFT: black thin solid;
	    BORDER-RIGHT: none;
	    BORDER-TOP: none; 
	}
	TABLE.Summary TD
	{
	    BORDER-BOTTOM: none;
	    BORDER-LEFT: black thin solid;
	    BORDER-RIGHT: black thin solid;
	    BORDER-TOP: none; 
	    BACKGROUND-COLOR: Lemonchiffon;
	}
	
	TABLE.Totals
	{
	    BACKGROUND-COLOR: Lemonchiffon;
	    COLOR: black;  
	    BORDER-BOTTOM: none;
	    BORDER-LEFT: none;
	    BORDER-RIGHT: none;
	    BORDER-TOP: none; 
	}
	TABLE.Totals TH
	{
	   BACKGROUND-COLOR: #003063;
	    COLOR: white;    
	    BORDER-BOTTOM: black thin solid;
	    BORDER-LEFT: black thin solid;
	    BORDER-RIGHT: black thin solid;
	    BORDER-TOP: black thin solid; 
	}
	TABLE.Totals TD
	{ 
	    BORDER-BOTTOM: black thin solid;
	    BORDER-LEFT: none;
	    BORDER-RIGHT: black thin solid;
	    BORDER-TOP: none; 
	}
</style>
<body>
	<table>	
		<tr>
			<td align="center" colspan="7">
				<table class="Header">
					<tr>	<td align="center">Laurel VAT Report</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right" colspan="4" width="50%">
				<table class="Address">
					<xsl:if test="LaurelVATReportHeader/BatchID != '0'">
						<tr>	<td>Batch ID: <xsl:value-of select="LaurelVATReportHeader/BatchID"></xsl:value-of></td></tr>
					</xsl:if>
					<tr>	<td>Transmission Date: <xsl:value-of select="msxsl:format-date(LaurelVATReportHeader/TransmissionDate,'dd/MM/yyyy')"></xsl:value-of></td>	</tr>
					<tr>	<td>Transmission Start Time: <xsl:value-of select="substring(LaurelVATReportHeader/TransmissionStartTime,1,5)"></xsl:value-of></td></tr>
				</table>
			</td>
			<td align="right" colspan="3" width="50%"><br/></td>
		</tr>

		<tr>
			<table class="summary" cellpadding="0" cellspacing="0" width="100%">
				<tr><td colspan="7" style="border-top:black thin solid">INVOICES</td></tr>
				<tr><td colspan="7">Total Number of Invoices: <xsl:value-of select="LaurelVATReportTrailer/NumberOfInvoices"></xsl:value-of></td></tr>
				<tr><td colspan="7" style="border-bottom:black thin solid">Total Number of Invoice Lines: <xsl:value-of select="LaurelVATReportTrailer/NumberOfInvoiceLines"></xsl:value-of></td></tr>
			</table>
		</tr>
	<xsl:if test="LaurelVATReportTrailer/NumberOfInvoices != '0'">
		<tr>
			<td align="center" colspan="7">
				<table class="products" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<th style="border-top:black thin solid" width="13%">From</th>		
						<th style="border-top:black thin solid" width="12%">Docs at Rate</th>		
						<th style="border-top:black thin solid" width="13%">
							<xsl:choose>
								<xsl:when test="LaurelVATReportHeader/BatchID = '0'">EDI VAT Code</xsl:when>
								<xsl:otherwise>Coda VAT Code</xsl:otherwise>
							</xsl:choose>
						</th>		
						<th style="border-top:black thin solid" width="12%">VAT Rate</th>		
						<th style="border-top:black thin solid" width="20%">Lines Total Excluding VAT</th>		
						<th style="border-top:black thin solid" width="10%">VAT Amount</th>		
						<th style="border-top:black thin solid;border-right:black thin solid" width="20%">
							<xsl:choose>
								<xsl:when test="LaurelVATReportHeader/BatchID = '0'">Payable Amount Incl. Settlement Discount</xsl:when>
								<xsl:otherwise>Payable Amount Excl. Settlement Discount</xsl:otherwise>
							</xsl:choose>
						</th>
					</tr>
					<xsl:for-each select="LaurelVATReportDetail/LaurelVATReportLine[DocumentType='Invoice']">
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid"><xsl:value-of select="SuppliersName"></xsl:value-of>&#xA0;</td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid"><xsl:value-of select="SuppliersAddress/AddressLine1"></xsl:value-of>&#xA0;</td></tr>
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid"><br/></td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid"><xsl:value-of select="SuppliersAddress/AddressLine2"></xsl:value-of>&#xA0;</td></tr>
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid"><br/></td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid"><xsl:value-of select="SuppliersAddress/AddressLine3"></xsl:value-of>&#xA0;</td></tr>
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid"><br/></td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid"><xsl:value-of select="SuppliersAddress/AddressLine4"></xsl:value-of>&#xA0;</td></tr>
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid;BORDER-BOTTOM: black thin solid"><br/></td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid;BORDER-BOTTOM: black thin solid"><xsl:value-of select="SuppliersAddress/PostCode"></xsl:value-of>&#xA0;</td></tr>
						<xsl:for-each select="VATSubtotals/VATSubtotal">
							<tr>
								<td width="13%"><br/></td>
								<td width="12%"><xsl:value-of select="NumberOfDocumentsAtRate"></xsl:value-of>&#xA0;</td>
								<td width="13%"><xsl:value-of select="CodaVATCode"></xsl:value-of>&#xA0;</td>
								<td width="12%" align="right"><xsl:value-of select="VATRate"></xsl:value-of>&#xA0;</td>
								<td width="20%" align="right"><xsl:value-of select="format-number(TotalExclVATAtRate,'0.00')"></xsl:value-of>&#xA0;</td>
								<td width="10%" align="right"><xsl:value-of select="format-number(VATAmountAtRate,'0.00')"></xsl:value-of>&#xA0;</td>
								<td width="20%" align="right" style="border-right:black thin solid"><xsl:value-of select="format-number(TotalInclVATExclDiscountAtRate,'0.00')"></xsl:value-of>&#xA0;</td>	
							</tr>
						</xsl:for-each>						
					</xsl:for-each>				
				</table>
			</td>
		</tr>
		<tr>
			<table class="summary" cellpadding="0" cellspacing="0" width="100%">
				<tr><td colspan="7" style="border-bottom:black thin solid">Batch Totals for Invoices</td></tr>
			</table>		
		</tr>
		<tr>
			<table class="products" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="LaurelVATReportTrailer/InvoiceVATSubtotals/VATSubtotal">
					<tr>
						<td width="13%"><br/></td>
						<td width="12%"><xsl:value-of select="NumberOfDocumentsAtRate"></xsl:value-of>&#xA0;</td>
						<td width="13%"><xsl:value-of select="CodaVATCode"></xsl:value-of>&#xA0;</td>
						<td width="12%" align="right"><xsl:value-of select="VATRate"></xsl:value-of>&#xA0;</td>
						<td width="20%" align="right"><xsl:value-of select="format-number(TotalExclVATAtRate,'0.00')"></xsl:value-of>&#xA0;</td>
						<td width="10%" align="right"><xsl:value-of select="format-number(VATAmountAtRate,'0.00')"></xsl:value-of>&#xA0;</td>
						<td width="20%" align="right" style="border-right:black thin solid"><xsl:value-of select="format-number(TotalInclVATExclDiscountAtRate,'0.00')"></xsl:value-of>&#xA0;</td>	
					</tr>
				</xsl:for-each>
			</table>
		</tr>
	</xsl:if>	
		
		<!-- CREDIT NOTES -->
		<tr>
			<table class="summary" cellpadding="0" cellspacing="0" width="100%">
				<tr><td colspan="7" style="border-top:black thin solid">CREDIT NOTES</td></tr>
				<tr><td colspan="7">Total Number of Credit Notes: <xsl:value-of select="LaurelVATReportTrailer/NumberOfCredits"></xsl:value-of></td></tr>
				<tr><td colspan="7" style="border-bottom:black thin solid">Total Number of Credit Note Lines: <xsl:value-of select="LaurelVATReportTrailer/NumberOfCreditLines"></xsl:value-of></td></tr>
			</table>
		</tr>
	<xsl:if test="LaurelVATReportTrailer/NumberOfCredits!= '0'">		
		<tr>
			<td align="center" colspan="7">
				<table class="products" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<th style="border-top:black thin solid" width="13%">From</th>		
						<th style="border-top:black thin solid" width="12%">Docs at Rate</th>		
						<th style="border-top:black thin solid" width="13%">
							<xsl:choose>
								<xsl:when test="LaurelVATReportHeader/BatchID = '0'">EDI VAT Code</xsl:when>
								<xsl:otherwise>Coda VAT Code</xsl:otherwise>
							</xsl:choose>
						</th>		
						<th style="border-top:black thin solid" width="12%">VAT Rate</th>		
						<th style="border-top:black thin solid" width="20%">Lines Total Excluding VAT</th>		
						<th style="border-top:black thin solid" width="10%">VAT Amount</th>		
						<th style="border-top:black thin solid;border-right:black thin solid" width="20%">Payable Amount Excl. Settlement Discount</th>
					</tr>
					<xsl:for-each select="LaurelVATReportDetail/LaurelVATReportLine[DocumentType='Credit']">
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid"><xsl:value-of select="SuppliersName"></xsl:value-of>&#xA0;</td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid"><xsl:value-of select="SuppliersAddress/AddressLine1"></xsl:value-of>&#xA0;</td></tr>
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid"><br/></td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid"><xsl:value-of select="SuppliersAddress/AddressLine2"></xsl:value-of>&#xA0;</td></tr>
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid"><br/></td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid"><xsl:value-of select="SuppliersAddress/AddressLine3"></xsl:value-of>&#xA0;</td></tr>
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid"><br/></td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid"><xsl:value-of select="SuppliersAddress/AddressLine4"></xsl:value-of>&#xA0;</td></tr>
							<tr><td width="13%" colspan="1" class="Supplier" style="border-left:black thin solid;BORDER-BOTTOM: black thin solid"><br/></td>
								<td width="25%" colspan="6" class="Supplier" style="border-right:black thin solid;BORDER-BOTTOM: black thin solid"><xsl:value-of select="SuppliersAddress/PostCode"></xsl:value-of>&#xA0;</td></tr>
						<xsl:for-each select="VATSubtotals/VATSubtotal">
							<tr>
								<td width="13%"><br/></td>
								<td width="12%"><xsl:value-of select="NumberOfDocumentsAtRate"></xsl:value-of>&#xA0;</td>
								<td width="13%"><xsl:value-of select="CodaVATCode"></xsl:value-of>&#xA0;</td>
								<td width="12%" align="right"><xsl:value-of select="VATRate"></xsl:value-of>&#xA0;</td>
								<td width="20%" align="right"><xsl:value-of select="format-number(TotalExclVATAtRate,'0.00')"></xsl:value-of>&#xA0;</td>
								<td width="10%" align="right"><xsl:value-of select="format-number(VATAmountAtRate,'0.00')"></xsl:value-of>&#xA0;</td>
								<td width="20%" align="right" style="border-right:black thin solid"><xsl:value-of select="format-number(TotalInclVATExclDiscountAtRate,'0.00')"></xsl:value-of>&#xA0;</td>								</tr>
						</xsl:for-each>						
					</xsl:for-each>				
				</table>
			</td>
		</tr>
		<tr>
			<table class="summary" cellpadding="0" cellspacing="0" width="100%">
				<tr><td colspan="7" style="border-bottom:black thin solid">Batch Totals for Credit Notes</td></tr>
			</table>		
		</tr>
		<tr>
			<table class="products" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="LaurelVATReportTrailer/CreditVATSubtotals/VATSubtotal">
					<tr>
						<td width="13%"><br/></td>
						<td width="12%"><xsl:value-of select="NumberOfDocumentsAtRate"></xsl:value-of>&#xA0;</td>
						<td width="13%"><xsl:value-of select="CodaVATCode"></xsl:value-of>&#xA0;</td>
						<td width="12%" align="right"><xsl:value-of select="VATRate"></xsl:value-of>&#xA0;</td>
						<td width="20%" align="right"><xsl:value-of select="format-number(TotalExclVATAtRate,'0.00')"></xsl:value-of>&#xA0;</td>
						<td width="10%" align="right"><xsl:value-of select="format-number(VATAmountAtRate,'0.00')"></xsl:value-of>&#xA0;</td>
						<td width="20%" align="right" style="border-right:black thin solid"><xsl:value-of select="format-number(TotalInclVATExclDiscountAtRate,'0.00')"></xsl:value-of>&#xA0;</td>		
					</tr>
				</xsl:for-each>
			</table>
		</tr>
	</xsl:if>
	
		<tr>
			<table class="Address"><tr><td>END OF VAT REPORT</td></tr></table>
		</tr>
	</table>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
