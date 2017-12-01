<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
Stylesheet to map in Receipts and Returns standard exports from R9/FnB

******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         | Description of modification
******************************************************************************************
 25/11/2015  | R Cambridge	| FB10629 (US13056) Created
******************************************************************************************

***************************************************************************************-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:output method="xml" encoding="utf-8"/>
	
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!--Then let attributes be copied/not copied/modified by other more specific templates -->
			<xsl:apply-templates select="@*"/>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
  
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!-- Copy the attribute unchanged -->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
  
  <!-- Enclose the target output with a BatchRoot tag required by the XSL transform processor -->
	<xsl:template match="/">
    
		<BatchRoot>      
			<xsl:apply-templates/>      
		</BatchRoot>
    
	</xsl:template>
  
  
  <!-- Create a receipt by removing the DocumentType element-->
	<xsl:template match="Receipt[ReceiptHeader/DocumentType='GRN']">
    
		<Receipt>
      
			<ReceiptHeader>
				<xsl:apply-templates select="ReceiptHeader/*[name() != 'DocumentType']"/>
			</ReceiptHeader>
      
      
			<ReceiptDetail>
        
				<xsl:for-each select="ReceiptDetail/ReceiptLine">
          
					<ReceiptLine>
						<xsl:apply-templates select="*"/>
					</ReceiptLine>
          
				</xsl:for-each>
        
			</ReceiptDetail>
      
      
		</Receipt>    
    
	</xsl:template>
  
  
  <!-- Create a Return by converting the Receipt and...
  
       - ... changing references to delivery notes to reference to supplier returns notes
       - ... changing references to accepted quantities  
  -->
	<xsl:template match="Receipt[ReceiptHeader/DocumentType='SR']">
    
		<Return>
      
			<ReturnHeader>
        
				<xsl:apply-templates select="ReceiptHeader/BuyersUnitCode | ReceiptHeader/BuyersSiteCode | ReceiptHeader/BuyersSiteName | ReceiptHeader/SiteNominalCode"/>
				<SupplierReturnsNoteReference>
					<xsl:value-of select="ReceiptHeader/DeliveryNoteReference"/>
				</SupplierReturnsNoteReference>
				<SupplierReturnsNoteDate>
					<xsl:value-of select="ReceiptHeader/DeliveryNoteDate"/>
				</SupplierReturnsNoteDate>
				<xsl:apply-templates select="ReceiptHeader/CallReference | ReceiptHeader/TransactionDescription | ReceiptHeader/BuyersCodeForSupplier | ReceiptHeader/SuppliersName | ReceiptHeader/SupplierNominalCode | ReceiptHeader/PurchaseOrderReference | ReceiptHeader/PurchaseOrderDate | ReceiptHeader/TotalExclVAT | ReceiptHeader/VATAmount | ReceiptHeader/TotalInclVAT | ReceiptHeader/NumberOfLines | ReceiptHeader/Narrative | ReceiptHeader/VoucherNumber | ReceiptHeader/ApprovedBy | ReceiptHeader/ApprovedDate | ReceiptHeader/CurrencyCode | ReceiptHeader/StockFinancialYear | ReceiptHeader/StockFinancialPeriod | ReceiptHeader/CompanyCode | ReceiptHeader/DocumentID"/>
			
      </ReturnHeader>
      
      
			<ReturnDetail>
        
				<xsl:for-each select="ReceiptDetail/ReceiptLine">
					
          <ReturnLine>
						<xsl:apply-templates select="LineNumber | SuppliersProductCode | ProductDescription | PackSize | OrderedQuantity"/>
						
						<ReturnedQuantity>
							<xsl:value-of select="AcceptedQuantity"/>
						</ReturnedQuantity>
						
						<xsl:apply-templates select="UnitValueExclVAT | CustomerVATCode | VATRate | LineValueExclVAT | LineVAT | LineValueInclVAT | CategoryNominal | CategoryName | Narrative | Reason"/>
					</ReturnLine>
          
				</xsl:for-each>
        
			</ReturnDetail>
      
      
		</Return>    
    
	</xsl:template>
  
  
  <!-- Convert dates from YYYYMMDD to YYYY-MM-DD -->
	<xsl:template match="ApprovedDate | DeliveryNoteDate | ExportRunDate | PurchaseOrderDate">
    
		<xsl:if test=". != ''">
      
			<xsl:element name="{name()}">
        
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
        
			</xsl:element>
      
		</xsl:if>
    
	</xsl:template>
  
  
</xsl:stylesheet>
