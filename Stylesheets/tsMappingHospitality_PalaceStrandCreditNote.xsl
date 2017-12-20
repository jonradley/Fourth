<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="text" encoding="UTF-8"/>

	<xsl:template match="CreditNote">
	
		<xsl:text>&quot;</xsl:text>
		<xsl:text>CSV  DD/MM/YYYY hhmm    HEAD LINE VAT  TRAIL               NN</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>


		<xsl:text>&quot;</xsl:text>
		<xsl:text>HEAD</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:call-template name="formatDate">
			<xsl:with-param name="sInput">
				<xsl:value-of select="CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:call-template name="formatDate">
			<xsl:with-param name="sInput">
				<xsl:value-of select="CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:call-template name="formatDate">
			<xsl:with-param name="sInput">
				<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<!-- This should be payment due date -->
		<!--xsl:call-template name="formatDate">
			<xsl:with-param name="sInput">
				<xsl:value-of select="InvoiceHeader/HeaderExtraData/PaymentDueDate"/>
			</xsl:with-param>
		</xsl:call-template-->
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<!-- "Y"? -->		
		<xsl:text>&quot;</xsl:text>
		<xsl:text>Y</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>

		<xsl:text>&quot;</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>


		<xsl:for-each select="CreditNoteDetail/CreditNoteLine">
		
			<xsl:text>&quot;</xsl:text>
			<xsl:text>LINE</xsl:text>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:text>&quot;</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:if test="CreditedQuantity/@UnitOfMeasure != 'KGM'">
				<xsl:text>1</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:if test="CreditedQuantity/@UnitOfMeasure = 'KGM'">
				<xsl:text>1</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:if test="CreditedQuantity/@UnitOfMeasure = 'KGM'">
				<xsl:text>&quot;</xsl:text>
				<xsl:text>KG</xsl:text>
				<xsl:text>&quot;</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:if test="CreditedQuantity/@UnitOfMeasure != 'KGM'">
				<xsl:value-of select="CreditedQuantity"/>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:if test="CreditedQuantity/@UnitOfMeasure = 'KGM'">
				<xsl:value-of select="CreditedQuantity"/>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<xsl:if test="CreditedQuantity/@UnitOfMeasure = 'KGM'">
				<xsl:text>&quot;</xsl:text>
				<xsl:text>KG</xsl:text>
				<xsl:text>&quot;</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<!-- VAT Code /-->

			<xsl:text>&quot;</xsl:text>
				<xsl:choose>
					<xsl:when test="VATCode = 'Z'">0</xsl:when>
					<xsl:when test="VATCode = 'S'">1</xsl:when>
				</xsl:choose>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>&quot;</xsl:text>
			<xsl:text>N</xsl:text>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>&quot;</xsl:text>
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>

			<xsl:text>,</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
	
		</xsl:for-each>
		
		
		<!-- VAT Sub Totals -->
		
		<xsl:for-each select="CreditNoteTrailer/VATSubTotals/VATSubTotal">
			
			<!-- Header -->
			<xsl:text>&quot;</xsl:text>
			<xsl:text>VAT</xsl:text>	
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>
		
			<!-- VATCode -->
				<xsl:choose>
					<xsl:when test="@VATCode = 'Z'">0</xsl:when>
					<xsl:when test="@VATCode = 'S'">1</xsl:when>
				</xsl:choose>
			<xsl:text>,</xsl:text>

			<!-- Number of lines -->
			<xsl:value-of select="NumberOfLinesAtRate"/>
			<xsl:text>,</xsl:text>
			
			<!-- Value if VAT code is 0 -->
			<xsl:choose>
					<xsl:when test="@VATCode = 'Z'">
						<xsl:value-of select="DocumentTotalExclVATAtRate"/>
					</xsl:when>
					<xsl:when test="@VATCode = 'S'">
						<xsl:text>0</xsl:text>
					</xsl:when>
				</xsl:choose>
			<xsl:text>,</xsl:text>
			
			<!-- Value if VAT code is 1 -->
				<xsl:choose>
					<xsl:when test="@VATCode = 'Z'">
						<xsl:text>0</xsl:text>
					</xsl:when>
					<xsl:when test="@VATCode = 'S'">
						<xsl:value-of select="DocumentTotalExclVATAtRate"/>
					</xsl:when>
				</xsl:choose>
			<xsl:text>,</xsl:text>
			
			<!-- blank -->
			<xsl:text>&quot;</xsl:text>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!--Total amount of VAT of VAT code is 0 -->
			<xsl:choose>
					<xsl:when test="@VATCode = 'Z'">
						<xsl:value-of select="VATAmountAtRate"/>
					</xsl:when>
					<xsl:when test="@VATCode = 'S'">
						<xsl:text>0</xsl:text>
					</xsl:when>
				</xsl:choose>
			<xsl:text>,</xsl:text>

			<!--Total amount of VAT of VAT code is 1 -->
					<xsl:choose>
					<xsl:when test="@VATCode = 'Z'">
						<xsl:text>0</xsl:text>
					</xsl:when>
					<xsl:when test="@VATCode = 'S'">
						<xsl:value-of select="VATAmountAtRate"/>
					</xsl:when>
				</xsl:choose>
			<xsl:text>,</xsl:text>
			
			<!-- blank -->
			<xsl:text>&quot;</xsl:text>
			<xsl:text>&quot;</xsl:text>
			
			<xsl:text>&#13;&#10;</xsl:text>
		
		</xsl:for-each> 
		
		<!-- TRAILER -->
		
		<!-- Header -->
		<xsl:text>&quot;</xsl:text>
		<xsl:text>TRAIL</xsl:text>	
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- Total amount excl. VAT -->
		<xsl:value-of select="CreditNoteTrailer/DocumentTotalExclVAT"/>
		<xsl:text>,</xsl:text>
		
		<!-- blank -->
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- blank -->
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- blank -->
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- 0.00 -->
		<xsl:text>0.00</xsl:text>
		<xsl:text>,</xsl:text>								
		
		<!-- Total VAT amount-->
		<xsl:value-of select="CreditNoteTrailer/VATAmount"/>
		<xsl:text>,</xsl:text>
		
		<!-- blank -->
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- Total amount incl. VAT -->
		<xsl:value-of select="CreditNoteTrailer/DocumentTotalInclVAT"/>
		<xsl:text>,</xsl:text>
		
		<!-- blank -->
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
	
	</xsl:template>

	<xsl:template name="formatDate">
		<xsl:param name="sInput"/>
	
		<xsl:value-of select="concat(substring($sInput,9,2),'/',substring($sInput,6,2),'/',substring($sInput,1,4))"/>
	
	</xsl:template>


</xsl:stylesheet>


