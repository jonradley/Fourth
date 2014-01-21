<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a Saffron csv format for ISS Facility Services Food & Hospiltality.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
30/01/2009	| Rave Tech		| Created Module
******************************************************************************************
30/03/2009	| Lee Boyton	| 2817. If the RCS contains a # character then take the string after the #.
******************************************************************************************
24/06/2009	| Lee Boyton	| 2957. Strip newline characters from packsize field,
                                | as these cause an additional blank line to appear in final output
******************************************************************************************
24/09/2009 | Steve Hewitt | 3137. Branch for Mitie and change reference location.
******************************************************************************************
03/10/2009	| Lee Boyton	| 3215. Use credit note reference if delivery note reference is missing.
******************************************************************************************
21/12/2009	| Sandeep Sehgal| 3286. Changed to handle VAT rate reverting back to 17.5% wef 1-Jan-2010. Retuns S17.5 or S15 instead of S as at present
******************************************************************************************
26/02/2010	| Graham Neicho | 3383. Removed hard coded X suffix to product code for when invoice price is more than 50% different from catalogue price.
******************************************************************************************
27/09/2010 | Andrew Barber | 3900 Always pass credit note reference as delivery note reference for credit. Pass valid DN ref on invoice if present.
******************************************************************************************
17/01/2011 | Andrew Barber | 4069 Copied Outbound Map for Saffron format from MITIE.
******************************************************************************************
17/01/2011 | Andrew Barber | 4365 Drop '/n' component of supplier account code.
******************************************************************************************
10/10/2013 | Andrew Barber | 7215 Drop '/n' component of site code.
******************************************************************************************
21/11/2014 | Andrew Barber | 7661 Application of msCSV template to PO reference.
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:variable name="CurrentDate" select="script:msGetTodaysDate()"/>
	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.-->
	<xsl:key name="keyLinesByVATCode" match="InvoiceTrailer/VATSubTotals/VATSubTotal | CreditNoteTrailer/VATSubTotals/VATSubTotal" use="concat(@VATCode,number(@VATRate),generate-id(../../..))"/>

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

      <xsl:when test="$vs=''"/>
      <!-- base case-->

      <xsl:when test="substring($vs,1,1)='&quot;'">
        <!-- " found -->
        <xsl:value-of select="substring($vs,1,1)"/>
        <xsl:value-of select="'&quot;'"/>
        <xsl:call-template name="msQuotes">
          <xsl:with-param name="vs" select="substring($vs,2)"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <!-- other character -->
        <xsl:value-of select="substring($vs,1,1)"/>
        <xsl:call-template name="msQuotes">
          <xsl:with-param name="vs" select="substring($vs,2)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
	<xsl:template match="/Invoice | /CreditNote">

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!--### HEADER LINE ###-->
		<xsl:text>INVHEAD,</xsl:text>
		
		<!-- Invoice Number -->
		<xsl:value-of select="substring(InvoiceHeader/InvoiceReferences/InvoiceReference | CreditNoteHeader/CreditNoteReferences/CreditNoteReference,1,20)"/>
		<xsl:text>,</xsl:text>

		<!-- Invoice Date -->
		<xsl:choose>
			<xsl:when test="/CreditNote">
				<xsl:value-of select="script:msFormatDate(CreditNoteHeader/CreditNoteReferences/CreditNoteDate)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="script:msFormatDate(InvoiceHeader/InvoiceReferences/InvoiceDate)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		
		<!-- Supplier Code -->
		<xsl:choose>
			<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'/')">
				<xsl:value-of select="substring(substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/'),1,10)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,10)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		
		<!-- Unit Code -->
		<xsl:choose>
			<xsl:when test="contains(TradeSimpleHeader/RecipientsBranchReference,'/')">
				<xsl:value-of select="substring(substring-before(TradeSimpleHeader/RecipientsBranchReference,'/'),1,10)"/>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(TradeSimpleHeader/RecipientsBranchReference,1,10)"/>	
			</xsl:otherwise>
		</xsl:choose>

		<!-- Number of Deliveries -->
		<xsl:value-of select="InvoiceTrailer/NumberOfDeliveries | CreditNoteTrailer/NumberOfDeliveries"/>
		<xsl:text>,</xsl:text>

		<!-- Lines Total Ex VAT -->
		<xsl:choose>
			<xsl:when test="/Invoice">
				<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalExclVAT,'0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(-1 * CreditNoteTrailer/DocumentTotalExclVAT,'0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		
		<!-- Tax Amount Total -->
		<xsl:choose>
			<xsl:when test="/Invoice">
				<xsl:value-of select="format-number(InvoiceTrailer/VATAmount,'0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(-1 * CreditNoteTrailer/VATAmount,'0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>

		<!-- Total Payable -->
		<xsl:choose>
			<xsl:when test="/Invoice">
				<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(-1 * CreditNoteTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>

		<!-- Original Invoice Number -->
		<xsl:value-of select="substring(CreditNoteHeader/InvoiceReferences/InvoiceReference,1,20)"/>

		<!--### VAT LINES ###-->
		<!-- use the keys for grouping Lines by VAT Code -->
		<xsl:for-each select="(InvoiceTrailer/VATSubTotals/VATSubTotal | CreditNoteTrailer/VATSubTotals/VATSubTotal)">
			<xsl:sort select="@VATCode" data-type="text"/>
			<xsl:variable name="VATCode" select="@VATCode"/>
			<xsl:variable name="VATRate" select="@VATRate"/>
			<xsl:if test="generate-id() = generate-id(key('keyLinesByVATCode', concat($VATCode,number($VATRate),generate-id(../../..))))">					
				<xsl:value-of select="$NewLine"/>
				<xsl:text>INVTAX,</xsl:text>
	
				<xsl:value-of select="substring(../../../InvoiceHeader/InvoiceReferences/InvoiceReference | 	../../../CreditNoteHeader/CreditNoteReferences/CreditNoteReference,1,20)"/>
				<xsl:text>,</xsl:text>
				
				<xsl:choose>
					<xsl:when test="substring($VATCode,1,1) = 'L'">
						<xsl:choose>
						<xsl:when test="../../../InvoiceHeader/InvoiceReferences/TaxPointDate!='' or ../../../CreditNoteHeader/InvoiceReferences/TaxPointDate!='' ">
							<xsl:choose>
								<xsl:when test="translate(substring(../../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt; translate('2011-01-03','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
								<xsl:when test="translate(substring(../../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt;= translate('2010-01-01','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
								<xsl:otherwise>S15</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="../../../InvoiceHeader/InvoiceReferences/InvoiceDate!='' or ../../../CreditNoteHeader/InvoiceReferences/InvoiceDate!=''">
							<xsl:choose>
								<xsl:when test="translate(substring(../../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt; translate('2011-01-03','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
								<xsl:when test="translate(substring(../../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt;= translate('2010-01-01','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
								<xsl:otherwise>S15</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="translate($CurrentDate,'-','')  &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
								<xsl:when test="translate($CurrentDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($CurrentDate,'-','')  &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
								<xsl:otherwise>S15</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>												
					</xsl:choose>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="substring($VATCode,1,1) = 'S'">
								<xsl:choose>
									<xsl:when test="../../../InvoiceHeader/InvoiceReferences/TaxPointDate!='' or ../../../CreditNoteHeader/InvoiceReferences/TaxPointDate!='' ">
										<xsl:choose>
											<xsl:when test="translate(substring(../../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt; translate('2011-01-03','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
											<xsl:when test="translate(substring(../../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt;= translate('2010-01-01','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
											<xsl:otherwise>S15</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="../../../InvoiceHeader/InvoiceReferences/InvoiceDate!='' or ../../../CreditNoteHeader/InvoiceReferences/InvoiceDate!=''">
										<xsl:choose>
											<xsl:when test="translate(substring(../../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt; translate('2011-01-03','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
											<xsl:when test="translate(substring(../../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt;= translate('2010-01-01','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
											<xsl:otherwise>S15</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="translate($CurrentDate,'-','')  &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
											<xsl:when test="translate($CurrentDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($CurrentDate,'-','')  &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
											<xsl:otherwise>S15</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>												
								</xsl:choose>	
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring($VATCode,1,1)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,</xsl:text>
	
				<xsl:choose>
					<xsl:when test="/Invoice">
						<xsl:value-of select="format-number(sum(../../../InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode and number(@VATRate) = number($VATRate)]/DocumentTotalExclVATAtRate),'0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(-1 * sum(../../../CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode and number(@VATRate) = number($VATRate)]/DocumentTotalExclVATAtRate),'0.00')"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,</xsl:text>
			
				<xsl:choose>
					<xsl:when test="/Invoice">
						<xsl:value-of select="format-number(sum(../../../InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode and number(@VATRate) = number($VATRate)]/VATAmountAtRate),'0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(-1 * sum(../../../CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode and number(@VATRate) = number($VATRate)]/VATAmountAtRate),'0.00')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>

		<!--### ITEM LINES ###-->
		<xsl:for-each select="(InvoiceDetail/InvoiceLine | CreditNoteDetail/CreditNoteLine)">

			<xsl:value-of select="$NewLine"/>
			<xsl:text>INVITEM,</xsl:text>

			<xsl:value-of select="substring(../../InvoiceHeader/InvoiceReferences/InvoiceReference | ../../CreditNoteHeader/CreditNoteReferences/CreditNoteReference,1,20)"/>
			<xsl:text>,</xsl:text>
			
			<xsl:call-template name="msCSV">
				<xsl:with-param name="vs" select="substring(PurchaseOrderReferences/PurchaseOrderReference,1,13)"/>
			</xsl:call-template>
			<!--xsl:value-of select="substring(PurchaseOrderReferences/PurchaseOrderReference,1,13)"/-->
			<xsl:text>,</xsl:text>

			<!-- The delivery note reference is mandatory in Saffron. It is optional in our internal schema. If it is missing then send the document reference -->
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteReference != ''">
					<xsl:value-of select="substring(DeliveryNoteReferences/DeliveryNoteReference,1,20)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(../../InvoiceHeader/InvoiceReferences/InvoiceReference | ../../CreditNoteHeader/CreditNoteReferences/CreditNoteReference,1,20)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(ProductID/SuppliersProductCode,1,20)"/>
			<xsl:text>,</xsl:text>

			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:value-of select="format-number(InvoicedQuantity,'0.000')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(-1 * CreditedQuantity,'0.000')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
			<xsl:text>,</xsl:text>

			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(-1 * LineValueExclVAT,'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>

			<xsl:choose>
				<xsl:when test="substring(VATCode,1,1) = 'L'">
					<xsl:choose>
						<xsl:when test="../../InvoiceHeader/InvoiceReferences/TaxPointDate!='' or ../../CreditNoteHeader/InvoiceReferences/TaxPointDate!=''">
							<xsl:choose>
								<xsl:when test="translate(substring(../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt; translate('2011-01-03','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
								<xsl:when test="translate(substring(../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt;= translate('2010-01-01','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
								<xsl:otherwise>S15</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="../../InvoiceHeader/InvoiceReferences/InvoiceDate!='' or ../../CreditNoteHeader/InvoiceReferences/InvoiceDate!=''">
							<xsl:choose>
								<xsl:when test="translate(substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt; translate('2011-01-03','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
								<xsl:when test="translate(substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt;= translate('2010-01-01','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
								<xsl:otherwise>S15</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="translate($CurrentDate,'-','')  &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
								<xsl:when test="translate($CurrentDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($CurrentDate,'-','')  &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
								<xsl:otherwise>S15</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>												
					</xsl:choose>		
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="substring(VATCode,1,1) = 'S'">
							<xsl:choose>
								<xsl:when test="../../InvoiceHeader/InvoiceReferences/TaxPointDate!='' or ../../CreditNoteHeader/InvoiceReferences/TaxPointDate!=''">
									<xsl:choose>
										<xsl:when test="translate(substring(../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt; translate('2011-01-03','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
										<xsl:when test="translate(substring(../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../InvoiceHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt;= translate('2010-01-01','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/TaxPointDate,1,10),'-','') &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
										<xsl:otherwise>S15</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="../../InvoiceHeader/InvoiceReferences/InvoiceDate!='' or ../../CreditNoteHeader/InvoiceReferences/InvoiceDate!=''">
									<xsl:choose>
										<xsl:when test="translate(substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt; translate('2011-01-03','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
										<xsl:when test="translate(substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt;= translate('2010-01-01','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &lt;= translate('2008-11-30','-','') or translate(substring(../../CreditNoteHeader/InvoiceReferences/InvoiceDate,1,10),'-','') &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
										<xsl:otherwise>S15</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="translate($CurrentDate,'-','')  &gt; translate('2011-01-03','-','')">S20.0</xsl:when>
										<xsl:when test="translate($CurrentDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($CurrentDate,'-','')  &gt;= translate('2010-01-01','-','')">S17.5</xsl:when>
										<xsl:otherwise>S15</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>												
							</xsl:choose>	
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(VATCode,1,1)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>

      <xsl:call-template name="msCSV">
        <xsl:with-param name="vs" select="substring(ProductDescription,1,50)"/>
      </xsl:call-template>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(normalize-space(PackSize),1,20)"/>
			
		</xsl:for-each>
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
				return vsDate.substr(0,4) + "" +vsDate.substr(5,2) + "" + vsDate.substr(8,2);
			}
			else
			{
				return '';
			}
		}
		
		/*=========================================================================================
		' Routine       	 : msGetTodaysDate
		' Description 	 : Gets todays date, formatted to yyyy-mm-dd
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : Rave Tech, 26/11/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msGetTodaysDate()
		{
			var dtDate = new Date();
			
			var sDate = dtDate.getDate();
			if(sDate<10)
			{
				sDate = '0' + sDate;
			}
			
			var sMonth = dtDate.getMonth() + 1;
			if(sMonth<10)
			{
				sMonth = '0' + sMonth;
			}
						
			var sYear  = dtDate.getYear() ;
			
		
			return sYear + '-'+ sMonth +'-'+ sDate;
		}


	]]></msxsl:script>
</xsl:stylesheet>
