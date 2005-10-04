<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview


    Maps individual Caterwide invoices and credits ready to be concatenated by tsProcessorBatchConcat
    
    
    Extracts from spec taken from "Caterwide Integration Functional Specification v1.2"



 © Alternative Business Solutions Ltd, 2005.
==========================================================================================
 Module History
==========================================================================================
 Version        | 
==========================================================================================
 Date            | Name             | Description of modification
==========================================================================================
 23/08/2005        | R Cambridge    | Created module
==========================================================================================
 30/08/2005        | A Sheppard    | Bug fix
=========================================================================================
 14/09/2005		| A Sheppard 	| Minor alteration for spec change
=========================================================================================
 23/09/2005		| Lee Boyton	| H510. Strip leading zeros from numeric delivery note references.
=========================================================================================
 04/10/2005		| A Sheppard	| H512. A couple of alterations in line with new spec version.
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="utf-8"/>
	
	<!--
	4	Appendix A – Caterwide File Format.
	4.1.1.1	The file is an ASCII text file, with comma separated fields and cr-lf separated lines.
	4.1.1.2	Each line is padded with spaces to a length of 201 characters.
	-->
	<xsl:template match="/*[*/HeaderExtraData[StockSystemIdentifier='CW']][*/*/LineExtraData[IsStockProduct[.='true' or .='1']]]">
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
						
			<xsl:value-of select="/*/*/ShipTo/ShipToLocationID/SuppliersCode"/>
			<xsl:text>,</xsl:text>
			
			<xsl:value-of select="substring(/*/*/ShipTo/ShipToName, 1, 30)"/>
			<xsl:text>,</xsl:text>
			
			<xsl:value-of select="(/*/*/InvoiceLine | /*/*/CreditNoteLine)/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>,</xsl:text>
			
			<xsl:if test="(/*/*/InvoiceLine | /*/*/CreditNoteLine)/PurchaseOrderReferences/PurchaseOrderDate">
				<xsl:call-template name="msFormatDate">
					<xsl:with-param name="vsDate" select="(/*/*/InvoiceLine | /*/*/CreditNoteLine)/PurchaseOrderReferences/PurchaseOrderDate"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<xsl:call-template name="msStripLeadingZeros">
				<xsl:with-param name="vsDNRef" select="(/*/*/InvoiceLine | /*/*/CreditNoteLine)/DeliveryNoteReferences/DeliveryNoteReference"/>
			</xsl:call-template>
			<xsl:text>,</xsl:text>
			
			<xsl:call-template name="msFormatDate">
				<xsl:with-param name="vsDate" select="(/Invoice/InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate | /CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate)"/>
			</xsl:call-template>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="/*/*/Supplier/SuppliersLocationID/SuppliersCode"/>
			<xsl:text>,</xsl:text>
			
			<xsl:text>,</xsl:text>
			
			<xsl:text>,</xsl:text>
			
		</xsl:variable>
	
		<xsl:call-template name="msPad">
			<xsl:with-param name="vsText" select="$sHeader"/>
		</xsl:call-template>

		<xsl:for-each select="(/Invoice/InvoiceDetail/InvoiceLine | /CreditNote/CreditNoteDetail/CreditNoteLine)[LineExtraData/IsStockProduct[.='true' or .='1']]">
			
					
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
			
			
			<xsl:variable name="sLine">
			
				<xsl:text>2,</xsl:text>
								
				<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
				<xsl:text>,</xsl:text>
				
				<xsl:value-of select="ProductID/SuppliersProductCode"/>
				<xsl:text>,</xsl:text>
				
				<xsl:value-of select="ProductDescription"/>
				<xsl:text>,</xsl:text>
				
				<xsl:text>,</xsl:text>
				
				<xsl:choose>
					<xsl:when test="self::InvoiceLine/InvoicedQuantity"><xsl:value-of select="InvoicedQuantity"/></xsl:when>
					<xsl:otherwise>-<xsl:value-of select="CreditedQuantity"/></xsl:otherwise>
				</xsl:choose>
							
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
