<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

    Maps individual Caterwide goods received notes ready to be concatenated by the batch processor
        
    Extracts from spec taken from "Caterwide Integration Functional Specification v1.2"
    
 © Alternative Business Solutions Ltd, 2007.
==========================================================================================
 Module History
==========================================================================================
 Date         | Name        | Description of modification
==========================================================================================
 10/04/2007   | Lee Boyton  | Created module
==========================================================================================
 08/05/2007   | Lee Boyton  | 1072. Cater for the Buyers code for Ship-to being blank.
==========================================================================================
 17/08/2007   | Lee Boyton  | 1383. Strip commas from reference fields as it is the field separator.
=========================================================================================
 14/07/2008   | A Sheppard | 2283. Changed into TCG version
 ========================================================================================
 07/11/2012	| KOshaughnessy| FB 5836 change to limit product descriptions for 49 characters
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="utf-8"/>
	
	<!--
	4	Appendix A – Caterwide File Format.
	4.1.1.1	The file is an ASCII text file, with comma separated fields and cr-lf separated lines.
	4.1.1.2	Each line is padded with spaces to a length of 201 characters.
	-->
	<xsl:template match="/GoodsReceivedNote[GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineExtraData/IsStockProduct[.='true' or .='1'] or GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineExtraData/IsFoodStockProduct[.='true' or .='1']]">
	
		<xsl:variable name="sHeader">
		
		<!-- From section 4.1.1.3	 
		
		
		Record Type 1 – Document header record
		
		Caterwide Field	Type (Max Length)				EDI Invoice Service Field(s)		Mand or Opt	Notes
		~~~~~~~~~~~~~~~	~~~~~~~~~~~~~~~~~		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	~~~~~~~~~~~	~~~~~
		
		Record Type		A (1)						-								M		Fixed as ‘1’
		House Code			A (7)						Delivery Location (House) Code	M
		House Name		A (30)						Delivery Location (House) Name	O		Leave empty if not provided.
		Purchase Order 	A (??)						Purchase Order Number			O		Leave empty if not provided.
		  Reference	
		Purchase Order 	D							Purchase Order Date			O		DD/MM/YYYY
		  Date
		Delivery Note 		30							Delivery Note Number			O	
		  Number	
		Delivery/Credit 		D							Delivery/Credit Date				O		DD/MM/YYYY (credit note date for credit, delivery date for invoice)
		  Date
		Empty 1				
		Empty 2				
		Empty 3				
		Empty 4				

    	    	3.4.1.1    The ... Batch Processor will ... create a file that contains all document lines where 
                        Line.Stock Product = ‘Y’ and 
                        Document.Stock System Identifier = {blank} or ‘CL’. 
		-->
		
			<xsl:text>1,</xsl:text>
						
			<!-- Cater for old documents that do not have a Buyers code, by using the Suppliers code instead -->
			<xsl:choose>
				<xsl:when test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/RecipientsBranchReference"/>
				</xsl:otherwise>
			</xsl:choose>															
			<xsl:text>,</xsl:text>
			
			<xsl:value-of select="substring(translate(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToName,',',''), 1, 30)"/>
			<xsl:text>,</xsl:text>
			
			<xsl:value-of select="translate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference,',','')"/>
			<xsl:text>,</xsl:text>
			
			<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate">
				<xsl:call-template name="msFormatDate">
					<xsl:with-param name="vsDate" select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<xsl:value-of select="translate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference,',','')"/>
			<xsl:text>,</xsl:text>
			
			<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate">
				<xsl:call-template name="msFormatDate">
					<xsl:with-param name="vsDate" select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<!-- Take the buyers code for supplier -->
			<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient"/>
			<xsl:text>,</xsl:text>
			
			<xsl:text>,</xsl:text>
			
			<xsl:text>,</xsl:text>
			
		</xsl:variable>
	
		<xsl:call-template name="msPad">
			<xsl:with-param name="vsText" select="$sHeader"/>
		</xsl:call-template>

		<!-- From section 4.1.1.3
	
			Record Type 2 - Detail line record
			
			Caterwide Field		Type (Max Length)			EDI Invoice Service Field(s)		Mand or Opt	Notes
			~~~~~~~~~~~~~~~	~~~~~~~~~~~~~~~~~		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	~~~~~~~~~~~	~~~~~
			
			Record Type		A (1)						-							M		Fixed as ‘2’
			Order Number		A (??)						Order Number				O		
			Supplier’s 			A (??)						Supplier’s Product Code		M
			  Product Code		
			Description			A (??)						Product Description			M	
			Product Type																O		Leave empty
			Quantity Invoiced	??							Quantity Invoiced			M		Will be negative for credit notes and for credit lines on invoices.
		-->	

		<!-- consolidate all Food stock lines into a single Caterwide line -->
		<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine[LineExtraData/IsFoodStockProduct[.='true' or .='1']]">

			<xsl:variable name="sLine">
					
				<xsl:text>2,</xsl:text>
								
				<xsl:value-of select="translate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference,',','')"/>
				<xsl:text>,</xsl:text>
				
				<xsl:text>WFOOD</xsl:text>
				<xsl:text>,</xsl:text>
				
				<xsl:text>DRY RECIPE COSTING</xsl:text>
				<xsl:text>,</xsl:text>
				
				<xsl:text>,</xsl:text>
			
				<!-- just the food stock lines need to be summed -->
				<xsl:value-of select="round(sum(//LineValueExclVAT[../LineExtraData[IsFoodStockProduct[.='true' or .='1']]]))"/>
									
			</xsl:variable>
					
			<xsl:text>&#13;&#10;</xsl:text>
					
			<xsl:call-template name="msPad">
				<xsl:with-param name="vsText" select="$sLine"/>
			</xsl:call-template>
		
		</xsl:if>

		<!-- all stock lines which are not also food stock are output individually -->		
		<xsl:for-each select="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine[LineExtraData/IsStockProduct[.='true' or .='1'] and (not(LineExtraData/IsFoodStockProduct) or LineExtraData/IsFoodStockProduct[.='false' or .='0'])]">
		
			<xsl:variable name="sLine">
			
				<xsl:text>2,</xsl:text>
								
				<xsl:value-of select="translate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference,',','')"/>
				<xsl:text>,</xsl:text>
				
				<!-- Cater for old documents that do not have a Buyers code, by using the Suppliers code instead -->
				<xsl:choose>
					<xsl:when test="ProductID/BuyersProductCode">
						<xsl:value-of select="translate(ProductID/BuyersProductCode,',','')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="translate(ProductID/SuppliersProductCode,',','')"/>
					</xsl:otherwise>
				</xsl:choose>															
				<xsl:text>,</xsl:text>
				
				<xsl:value-of select="substring(translate(ProductDescription,',',''),1,49)"/>
				<xsl:text>,</xsl:text>
				
				<xsl:text>,</xsl:text>
				
				<xsl:value-of select="AcceptedQuantity"/>
				
			</xsl:variable>
			
			<xsl:text>&#13;&#10;</xsl:text>
			
			<xsl:call-template name="msPad">
				<xsl:with-param name="vsText" select="$sLine"/>
			</xsl:call-template>
		
		</xsl:for-each>
			
	</xsl:template>

	<xsl:template match="/*" priority="-9">
		<xsl:text>[[BLANK DOCUMENT]]</xsl:text>
	</xsl:template>


	<xsl:template name="msFormatDate">
		<xsl:param name="vsDate"/>
		
		<xsl:value-of select="substring($vsDate,9,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($vsDate,6,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($vsDate,1,4)"/>
	
	</xsl:template>

  	<xsl:template name="msPad">
     	<xsl:param name="vsText"/>

     	<xsl:choose>
     		<xsl:when test="string-length($vsText) &gt;= 201">
				<xsl:value-of select="substring($vsText,1,201)"/>
     		</xsl:when>
     		<xsl:otherwise>
        		<xsl:call-template name="msPad">
					<xsl:with-param name="vsText" select="concat($vsText,' ')"/>
        		</xsl:call-template>
     		</xsl:otherwise>
     	</xsl:choose>
     	
  	</xsl:template>

	<xsl:template name="msStripLeadingZeros">
		<xsl:param name="vsDNRef"/>
		
		<!--
		 convert the input value to a number to strip leading zeros.
		 if the input value is not a number then it will return the 'NaN' token, hence
		 the slightly bizarre test below because NaN != NaN.
		 -->
		<xsl:choose>
			<xsl:when test="number($vsDNRef) != number($vsDNRef)">
				<!-- i.e. not a number -->
				<xsl:value-of select="substring($vsDNRef, 1, 30)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(number($vsDNRef), 1, 30)"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>
