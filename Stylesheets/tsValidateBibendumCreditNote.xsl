<?xml version="1.0" encoding="UTF-8"?>
<!--
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name		: tsValidateBibendumCreditNote.xsl
Description	: Validates Bibendum credit notes
Author		: A Sheppard
Date		: 04/03/2004
Alterations	: A Sheppard, 17/12/2004. Add tolerances
Alterations	: A Sheppard, 16/01/2005. H312. Bug fix
Alterations	: Lee Boyton, 27/04/2005. H408. Changed into Bibendum specific version to
                                     remove some of the restrictions.
Alterations	:                                      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output encoding="UTF-8"/>
	<xsl:template match="/">
		<xsl:element name="ValidationErrors">
			<xsl:call-template name="tempTradeAgreement"/>
			<xsl:call-template name="tempLines"/>
			<xsl:call-template name="tempVATSubtotals"/>
			<xsl:call-template name="tempTotals"/>
		</xsl:element>
	</xsl:template>

	<!--This template will check that at least one trade agreement reference has been included-->
	<xsl:template name="tempTradeAgreement">
		<!--Check LineDiscountValue-->
		<xsl:if test="not(/CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/TradeAgreement/ContractReference and /CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/TradeAgreement/ContractReference != '')">
			<xsl:element name="Error">
				<xsl:text>There must be at least one valid trade agreement</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!--This template will check various validation rules for all lines-->
	<xsl:template name="tempLines">
		<xsl:for-each select="//CreditNoteLine">
			<!--Check LineValueExclVAT-->
			<xsl:if test="format-number(number(CreditedQuantity) * number(UnitValueExclVAT), '#.00') != format-number(number(LineValueExclVAT), '#.00')">
				<xsl:element name="Error">
					<xsl:text>The total value on line </xsl:text>
					<xsl:value-of select="LineNumber"/>
					<xsl:text> does not match the unit value multiplied by the quantity.</xsl:text>
				</xsl:element>	
			</xsl:if>
			<!--Check LineDiscountValue-->
			<xsl:if test="LineDiscountRate">
				<xsl:if test="(format-number(number(LineValueExclVAT) * number(LineDiscountRate) div 100, '#.00') &gt; format-number(number(LineDiscountValue) + 0.01, '#.00')) or (format-number(number(LineValueExclVAT) * number(LineDiscountRate) div 100, '#.00') &lt; format-number(number(LineDiscountValue) - 0.01, '#.00'))">
					<xsl:element name="Error">
						<xsl:text>The discount value on line </xsl:text>
						<xsl:value-of select="LineNumber"/>
						<xsl:text> does not match the line value multiplied by the discount rate.</xsl:text>
					</xsl:element>	
				</xsl:if>
			</xsl:if>		
		</xsl:for-each>
	</xsl:template>

	<!--This template will check various validation rules for all vat sub totals-->
	<xsl:template name="tempVATSubtotals">
		<xsl:for-each select="//VATSubTotal">
			<xsl:variable name="VATCode">
				<xsl:value-of select="@VATCode"/>
			</xsl:variable>
			<xsl:variable name="VATRate">
				<xsl:value-of select="@VATRate"/>
			</xsl:variable>
			<xsl:variable name="Tolerance"><xsl:value-of select="0.01 * (count(//CreditNoteLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]) + count(//CreditNoteLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00') and LineDiscountValue and number(LineDiscountValue) != 0]))"/></xsl:variable>

			<!--Check NumberOfLinesAtRate-->
			<xsl:if test="not(format-number(count(//CreditNoteLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]), '#') = format-number(NumberOfLinesAtRate, '#'))">
				<xsl:element name="Error">
					<xsl:text>The line count at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the actual number of lines at the rate.</xsl:text>
				</xsl:element>
			</xsl:if>
			<!--Check NumberOfItemsAtRate-->
			<xsl:if test="not(format-number(sum(//CreditNoteLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]/CreditedQuantity), '#.0000') = format-number(NumberOfItemsAtRate, '#.0000'))">
				<xsl:element name="Error">
					<xsl:text>The item count at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the actual number of items at the rate.</xsl:text>
				</xsl:element>
			</xsl:if>
			
			
			<!--Check DiscountedLinesTotalExclVATAtRate-->
			<xsl:if test="(format-number(sum(//CreditNoteLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]/LineValueExclVAT) - sum(//CreditNoteLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]/LineDiscountValue), '#.00') &gt; format-number(number(DiscountedLinesTotalExclVATAtRate) + $Tolerance, '#.00')) or (format-number(sum(//CreditNoteLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]/LineValueExclVAT) - sum(//CreditNoteLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]/LineDiscountValue), '#.00') &lt; format-number(number(DiscountedLinesTotalExclVAT) - $Tolerance, '#.00'))">
				<xsl:element name="Error">
					<xsl:text>The discount lines total excl VAT at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the total of the line values at the rate - the total of the discount values at the rate.</xsl:text>
				</xsl:element>	
			</xsl:if>
			<!--Check DocumentDiscountAtRate-->
			<xsl:if test="//DocumentDiscountRate">
				<xsl:variable name="DiscountableTotalAtRate">
					<xsl:choose>
						<xsl:when test="//CreditNoteLine/NetPriceFlag">
							<xsl:value-of select="format-number(sum(//CreditNoteLine[(NetPriceFlag = '0' or NetPriceFlag = 'false' or not(NetPriceFlag)) and VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]/LineValueExclVAT) - sum(//CreditNoteLine[(NetPriceFlag = '0' or NetPriceFlag = 'false' or not(NetPriceFlag)) and VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]/LineDiscountValue), '#.00')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="DiscountedLinesTotalExclVATAtRate"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="(format-number(number($DiscountableTotalAtRate) * number(//DocumentDiscountRate) div 100, '#.00') &gt; format-number(number(DocumentDiscountAtRate) + ($Tolerance), '#.00')) or (format-number(number($DiscountableTotalAtRate) * number(//DocumentDiscountRate) div 100, '#.00') &lt; format-number(number(DocumentDiscountAtRate) - $Tolerance, '#.00'))">
					<xsl:element name="Error">
						<xsl:text>The document discount at rate for VAT code </xsl:text>
						<xsl:value-of select="$VATCode"/>
						<xsl:text> does not match the lines discount total excl VAT at the rate * the document discount rate.</xsl:text>
					</xsl:element>	
				</xsl:if>
			</xsl:if>
			<!--DocumentTotalExclVATAtRate-->
			<xsl:if test="(format-number(number(DiscountedLinesTotalExclVATAtRate) - number(DocumentDiscountAtRate), '#.00') &gt; format-number(number(DocumentTotalExclVATAtRate) + $Tolerance, '#.00')) or (format-number(number(DiscountedLinesTotalExclVATAtRate) - number(DocumentDiscountAtRate), '#.00') &lt; format-number(number(DocumentTotalExclVATAtRate) - $Tolerance, '#.00'))">
				<xsl:element name="Error">
					<xsl:text>The document total excl VAT at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the discounted lines value at the rate - the document discount at the rate.</xsl:text>
				</xsl:element>	
			</xsl:if>
			<!--Check SettlementDiscountAtRate-->
			<xsl:if test="//SettlementDiscountRate">
				<xsl:if test="(format-number(number(DocumentTotalExclVATAtRate) * number(//SettlementDiscountRate) div 100, '#.00') &gt; format-number(number(SettlementDiscountAtRate) + $Tolerance, '#.00')) or (format-number(number(DocumentTotalExclVATAtRate) * number(//SettlementDiscountRate) div 100, '#.00') &lt; format-number(number(SettlementDiscountAtRate) - $Tolerance, '#.00'))">
					<xsl:element name="Error">
						<xsl:text>The settlement discount at rate for VAT code </xsl:text>
						<xsl:value-of select="$VATCode"/>
						<xsl:text> does not match the document total excl VAT at the rate * the settlement discount rate.</xsl:text>
					</xsl:element>	
				</xsl:if>
			</xsl:if>
			<!--Check SettlementTotalExclVATAtRate-->
			<xsl:if test="(format-number(number(DocumentTotalExclVATAtRate) - number(SettlementDiscountAtRate), '#.00') &gt; format-number(number(SettlementTotalExclVATAtRate) + $Tolerance, '#.00')) or (format-number(number(DocumentTotalExclVATAtRate) - number(SettlementDiscountAtRate), '#.00') &lt; format-number(number(SettlementTotalExclVATAtRate) - $Tolerance, '#.00'))">
				<xsl:element name="Error">
					<xsl:text>The settlement total excl VAT at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the document total excl VAT at the rate - the settlement discount at the rate.</xsl:text>
				</xsl:element>	
			</xsl:if>
			<!--Check VATAmountAtRate-->
			<xsl:if test="(format-number(number(SettlementTotalExclVATAtRate) * number(@VATRate) div 100, '#.00') &gt; format-number(number(VATAmountAtRate) + $Tolerance, '#.00')) or (format-number(number(SettlementTotalExclVATAtRate) * number(@VATRate) div 100, '#.00') &lt; format-number(number(VATAmountAtRate) - $Tolerance, '#.00'))">
				<xsl:element name="Error">
					<xsl:text>The vat amount at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the settlement total excl VAT at the rate * the vat rate.</xsl:text>
				</xsl:element>	
			</xsl:if>
			<!--DocumentTotalInclVATAtRate-->
			<xsl:if test="(format-number(number(DocumentTotalExclVATAtRate) + number(VATAmountAtRate), '#.00') &gt; format-number(number(DocumentTotalInclVATAtRate) + $Tolerance, '#.00')) or (format-number(number(DocumentTotalExclVATAtRate) + number(VATAmountAtRate), '#.00') &lt; format-number(number(DocumentTotalInclVATAtRate) - $Tolerance, '#.00'))">
				<xsl:element name="Error">
					<xsl:text>The document total incl VAT at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the document total excl VAT at the rate + the VAT at the rate.</xsl:text>
				</xsl:element>	
			</xsl:if>
			<!--SettlementTotalInclVATAtRate-->
			<xsl:if test="(format-number(number(SettlementTotalExclVATAtRate) + number(VATAmountAtRate), '#.00') &gt; format-number(number(SettlementTotalInclVATAtRate) + $Tolerance, '#.00')) or (format-number(number(SettlementTotalExclVATAtRate) + number(VATAmountAtRate), '#.00') &lt; format-number(number(SettlementTotalInclVATAtRate) - $Tolerance, '#.00'))">
				<xsl:element name="Error">
					<xsl:text>The settlement total incl VAT at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the settlement total excl VAT at the rate + the VAT at the rate.</xsl:text>
				</xsl:element>	
			</xsl:if>
			
		</xsl:for-each>
	</xsl:template>
	<!--This template will check various validation rules for the totals-->
	<xsl:template name="tempTotals">
		<xsl:variable name="Tolerance"><xsl:value-of select="0.01 * (count(//CreditNoteLine) + count(//CreditNoteLine[LineDiscountValue and number(LineDiscountValue) != 0]))"/></xsl:variable>
		<!--Check NumberOfLines-->
		<xsl:if test="not(format-number(count(//CreditNoteLine), '#') = format-number(//NumberOfLines, '#'))">
			<xsl:element name="Error">
				<xsl:text>The line count given in this document does not match the number of lines present.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check NumberOfItems-->
		<xsl:if test="not(format-number(sum(//CreditedQuantity), '#.0000') = format-number(//NumberOfItems, '#.0000'))">
			<xsl:element name="Error">
				<xsl:text>The item count given in this document does not match the number of items present.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check DiscountedLinesTotalExclVAT-->
		<xsl:if test="format-number(sum(//DiscountedLinesTotalExclVATAtRate), '#.00') &lt; format-number(//DiscountedLinesTotalExclVAT, '#.00') - $Tolerance or format-number(sum(//DiscountedLinesTotalExclVATAtRate), '#.00') &gt; format-number(//DiscountedLinesTotalExclVAT, '#.00') + $Tolerance">
			<xsl:element name="Error">
				<xsl:text>The discounted lines total excl vat does not match the sum of the discounted lines totals at each vat rate.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check DocumentDiscount-->
		<xsl:if test="format-number(sum(//DocumentDiscountAtRate), '#.00') &lt; format-number(//DocumentDiscount, '#.00') - $Tolerance or format-number(sum(//DocumentDiscountAtRate), '#.00') &gt; format-number(//DocumentDiscount, '#.00') + $Tolerance">
			<xsl:element name="Error">
				<xsl:text>The document discount does not match the sum of the document discounts at each vat rate.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check DocumentTotalExclVAT-->
		<xsl:if test="format-number(sum(//DocumentTotalExclVATAtRate), '#.00') &lt; format-number(//DocumentTotalExclVAT, '#.00') - $Tolerance or format-number(sum(//DocumentTotalExclVATAtRate), '#.00') &gt; format-number(//DocumentTotalExclVAT, '#.00') + $Tolerance">
			<xsl:element name="Error">
				<xsl:text>The document total excl vat does not match the sum of the document total excl vat at each vat rate.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check SettlementDiscount-->
		<xsl:if test="format-number(sum(//SettlementDiscountAtRate), '#.00') &lt; format-number(//SettlementDiscount, '#.00') - $Tolerance or format-number(sum(//SettlementDiscountAtRate), '#.00') &gt; format-number(//SettlementDiscount, '#.00') + $Tolerance">
			<xsl:element name="Error">
				<xsl:text>The settlement discount does not match the sum of the settlement discounts at each vat rate.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check SettlementTotalExclVAT-->
		<xsl:if test="format-number(sum(//SettlementTotalExclVATAtRate), '#.00') &lt; format-number(//SettlementTotalExclVAT, '#.00') - $Tolerance or format-number(sum(//SettlementTotalExclVATAtRate), '#.00') &gt; format-number(//SettlementTotalExclVAT, '#.00') + $Tolerance">
			<xsl:element name="Error">
				<xsl:text>The settlement total excl vat does not match the sum of the settlement total excl vat at each vat rate.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check VATAmount-->
		<xsl:if test="format-number(sum(//VATAmountAtRate), '#.00') &lt; format-number(//VATAmount, '#.00') - $Tolerance or format-number(sum(//VATAmountAtRate), '#.00') &gt; format-number(//VATAmount, '#.00') + $Tolerance">
			<xsl:element name="Error">
				<xsl:text>The total vat amount does not match the sum of the vat amounts at each vat rate.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check DocumentTotalInclVAT-->
		<xsl:if test="format-number(sum(//DocumentTotalInclVATAtRate), '#.00') &lt; format-number(//DocumentTotalInclVAT, '#.00') - $Tolerance or format-number(sum(//DocumentTotalInclVATAtRate), '#.00') &gt; format-number(//DocumentTotalInclVAT, '#.00') + $Tolerance">
			<xsl:element name="Error">
				<xsl:text>The document total incl vat does not match the sum of the document total incl vat at each vat rate.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check SettlementTotalInclVAT-->
		<xsl:if test="format-number(sum(//SettlementTotalInclVATAtRate), '#.00') &lt; format-number(//SettlementTotalInclVAT, '#.00') - $Tolerance or format-number(sum(//SettlementTotalInclVATAtRate), '#.00') &gt; format-number(//SettlementTotalInclVAT, '#.00') + $Tolerance">
			<xsl:element name="Error">
				<xsl:text>The settlement total incl vat does not match the sum of the settlement total incl vat at each vat rate.</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
