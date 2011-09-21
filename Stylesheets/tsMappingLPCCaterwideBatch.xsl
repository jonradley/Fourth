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
=========================================================================================
 25/10/2005		| A Sheppard	| H522. Added delivery notes.
=========================================================================================
 08/02/2006		| A Sheppard	| H556. Change output for food suppliers
=========================================================================================
 16/06/2006		| A Sheppard	| H604. Cater for goods received notes and product code location change
=========================================================================================
 20/06/2006		| Lee Boyton	| H604. Cater for house code location change.
=========================================================================================
 26/06/2006		| A Sheppard	| H604. Added debit notes
=======================================================================================
 03/07/2006		| Lee Boyton	| H604. Cater for old documents without Buyer code fields.
=========================================================================================
 03/07/2006		| Lee Boyton	| H604. Fix the Food supplier Product code as WFOOD for Woodward.
            	|           	| This will change to a per supplier value once further development has been completed.
=========================================================================================
 03/07/2006		| Lee Boyton	| H613. Strip commas from text elements.
=========================================================================================
 07/07/2006		| Lee Boyton	| H618. GRNs do not contains a NumberOfItems element in the trailer.
=========================================================================================
 10/07/2006		| Lee Boyton	| H620. Cater for GRNs where the ANA number is in the GLN element.
=========================================================================================
 27/07/2006		| Lee Boyton	| 188. Food supplier lines should include the total value not quantity.
=========================================================================================
 10/07/2006		| Lee Boyton	| 192. Cater for Invoices where the ANA number is in the GLN element (H620 for invoices.)
=========================================================================================
 24/01/2007		| Lee Boyton	| 705. Food supplier lines should be negative for credit notes.
=========================================================================================
 08/05/2007   	| Lee Boyton  	| 1072. Cater for the Buyers code for Ship-to being blank.
=========================================================================================
 17/08/2007   	| Lee Boyton  	| 1383. Strip commas from reference fields as it is the field separator.
=========================================================================================
 05/11/2007 	| A Sheppard	| 1571. Use product group not hard-coded WFOOD
=========================================================================================
 13/11/2007		| A Sheppard	| Removed extra line for delivery notes
=========================================================================================
 02/12/2007		| Lee Boyton	| 995. Food stock flag now at line level.
=========================================================================================
 13/12/2007		| Lee Boyton	| 995. Spec change. No longer need the extra header for the food line.
=========================================================================================
 19/12/2007		| Lee Boyton	| 995. and back gain. Extra header for the food line required.
=========================================================================================
 17/01/2008		| Lee Boyton	| 1704. /FOOD is too long for Caterwide, needs to be just /FD.
=========================================================================================
 04/04/2008		| Lee Boyton	| 2146. Ensure the delivery note reference does not exceed the maximum of 9 characters.
                             |       Also cater for old Brakes DN references with a text prefix.
=========================================================================================
 29/04/2008		| Lee Boyton	| 2209. Use the received delivery date rather than the delivery note date in a receipt.
=========================================================================================
 30/03/2009		| Lee Boyton	| Hack Alert. Ignore Waverly GLN, and use ANA number instead.
=========================================================================================
 24/06/2009		| Lee Boyton	| 2959. /FD is too long for Caterwide now, needs to be just /F.
 =========================================================================================
 22/01/2010		| Rave Tech		| 3334.Added Caterwide Delivery Note Suffix logic.
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
    <xsl:output method="text" encoding="utf-8"/>
    <xsl:key name="keyLinesByDeliveryNoteSuffix" match="GoodsReceivedNoteLine[LineExtraData/IsStockProduct = 'true']" use="LineExtraData/DeliveryNoteSuffix"/>  

	<!--
	4	Appendix A – Caterwide File Format.
	4.1.1.1	The file is an ASCII text file, with comma separated fields and cr-lf separated lines.
	4.1.1.2	Each line is padded with spaces to a length of 201 characters.
	-->
	<xsl:template match="/GoodsReceivedNote[GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineExtraData/IsStockProduct[.='true' or .='1'] or GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineExtraData/IsFoodStockProduct[.='true' or .='1']] | /*[*/HeaderExtraData[StockSystemIdentifier='CW'] | */HeaderExtraData[StockSystemIdentifier='ZZ']][*/*/LineExtraData[IsStockProduct[.='true' or .='1'] or IsFoodStockProduct[.='true' or .='1']]]">

		<xsl:if test="/GoodsReceivedNote | /*/*/HeaderExtraData[StockSystemIdentifier='CW'] ">		
			
			<!-- consolidate all Food stock lines into a single Caterwide line -->			
			<!--xsl:for-each select="(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine[LineExtraData/IsStockProduct = 'true'] | /DeliveryNote/DeliveryNoteDetail/DeliveryNoteLine | /Invoice/InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByDeliveryNoteSuffix',LineExtraData/DeliveryNoteSuffix))] | /DeliveryNote/DeliveryNoteDetail/DeliveryNoteLine | /Invoice/InvoiceDetail/InvoiceLine"-->
			<xsl:for-each select="(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine[LineExtraData/IsStockProduct = 'true'])[generate-id() = generate-id(key('keyLinesByDeliveryNoteSuffix',LineExtraData/DeliveryNoteSuffix))] ">
				<xsl:sort select="LineExtraData/DeliveryNoteSuffix" data-type="text"/>
				<xsl:variable name="sDeliveryNoteSuffix" select="normalize-space(LineExtraData/DeliveryNoteSuffix)"/>						
				<xsl:variable name="sHeaderFood">
				
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
					<xsl:if test="position() != 1">
						<xsl:text>&#13;&#10;</xsl:text>
					</xsl:if>
					<xsl:text>1,</xsl:text>
								
					<!-- Cater for old documents that do not have a Buyers code, by using the Suppliers code instead -->
					<xsl:choose>
						<xsl:when test="/*/*/ShipTo/ShipToLocationID/BuyersCode">
							<xsl:value-of select="/*/*/ShipTo/ShipToLocationID/BuyersCode"/>
						</xsl:when>
						<xsl:when test="/GoodsReceivedNote/TradeSimpleHeader/RecipientsBranchReference">
							<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/RecipientsBranchReference"/>
						</xsl:when>					
						<xsl:otherwise>
							<xsl:value-of select="/*/*/ShipTo/ShipToLocationID/SuppliersCode"/>
						</xsl:otherwise>
					</xsl:choose>															
					<xsl:text>,</xsl:text>
					
					<xsl:value-of select="substring(translate(/*/*/ShipTo/ShipToName,',',''), 1, 30)"/>
					<xsl:text>,</xsl:text>
					
					<xsl:value-of select="translate((/*/*/InvoiceLine | /*/*/CreditNoteLine | /*/*/DebitNoteLine | /GoodsReceivedNote/GoodsReceivedNoteHeader)/PurchaseOrderReferences/PurchaseOrderReference,',','')"/>
					<xsl:text>,</xsl:text>
					
					<xsl:if test="(/*/*/InvoiceLine | /*/*/CreditNoteLine | /*/*/DebitNoteLine | /GoodsReceivedNote/GoodsReceivedNoteHeader)/PurchaseOrderReferences/PurchaseOrderDate">
						<xsl:call-template name="msFormatDate">
							<xsl:with-param name="vsDate" select="(/*/*/InvoiceLine | /*/*/CreditNoteLine | /*/*/DebitNoteLine | /GoodsReceivedNote/GoodsReceivedNoteHeader)/PurchaseOrderReferences/PurchaseOrderDate"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:text>,</xsl:text>

					<!-- the consolidated food line has the same header as the individual non-food stock lines except for the delivery note reference
					     which has /F appended to the end of it -->
					<xsl:variable name="DNRef">
						<xsl:call-template name="msStripLeadingZeros">
							<xsl:with-param name="vsDNRef" select="translate((/*/*/InvoiceLine | /*/*/CreditNoteLine | /*/*/DebitNoteLine | /DeliveryNote/DeliveryNoteHeader | /GoodsReceivedNote/GoodsReceivedNoteHeader)/DeliveryNoteReferences/DeliveryNoteReference,',','')"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- trim the delivery reference to a maximum of 7 characters so that adding /F does not exceed the maximum of 9 characters -->
					<xsl:choose>
						<xsl:when test="normalize-space(LineExtraData/DeliveryNoteSuffix) = ''">
							<xsl:value-of select="substring($DNRef,1,7)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(substring($DNRef,1,7),concat('/',LineExtraData/DeliveryNoteSuffix))"/>
						</xsl:otherwise>
					</xsl:choose>				
					
					<xsl:text>,</xsl:text>
					
					<xsl:call-template name="msFormatDate">
						<xsl:with-param name="vsDate" select="(/Invoice/InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate | /CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate | /DebitNote/DebitNoteHeader/DebitNoteReferences/DebitNoteDate | /DeliveryNote/DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate | /GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryDate)"/>
					</xsl:call-template>
					<xsl:text>,</xsl:text>
		
					<!-- Take the ANA number from the GLN if it is not the default 13 5's otherwise use the SuppliersCode for Supplier -->
					<xsl:choose>
						<xsl:when test="/*/*/Supplier/SuppliersLocationID/GLN and /*/*/Supplier/SuppliersLocationID/GLN != '5555555555555' and /*/*/Supplier/SuppliersLocationID/GLN != '5014748111116' and /*/*/Supplier/SuppliersLocationID/GLN != '5010118000026'">
							<xsl:value-of select="/*/*/Supplier/SuppliersLocationID/GLN"/>						
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/*/*/Supplier/SuppliersLocationID/SuppliersCode"/>
						</xsl:otherwise>
					</xsl:choose>	
					<xsl:text>,</xsl:text>
					
					<xsl:text>,</xsl:text>
					
					<xsl:text>,</xsl:text>
					
				</xsl:variable>


				<xsl:call-template name="msPad">
					<xsl:with-param name="vsText" select="$sHeaderFood"/>
				</xsl:call-template>

				
				<!-- Line Details -->				
				 <xsl:for-each select="(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine | /Invoice/InvoiceDetail/InvoiceLine | /CreditNote/CreditNoteDetail/CreditNoteLine | /DebitNote/DebitNoteDetail/DebitNoteLine | /DeliveryNote/DeliveryNoteDetail/DeliveryNoteLine)[LineExtraData/IsStockProduct[.='true' or .='1'] and normalize-space(LineExtraData/DeliveryNoteSuffix) = normalize-space($sDeliveryNoteSuffix) and  LineExtraData/IsFoodStockProduct[.='true' or .='1']]">
					<xsl:sort select="LineExtraData/ProductGroup" data-type="text"/>
					<xsl:variable name="sProductGroup" select="LineExtraData/ProductGroup"/>
					<xsl:variable name="ProductGroupChanged" select="js:mbProductGroupChanged(normalize-space(LineExtraData/ProductGroup))"/>		

					<xsl:if test="$ProductGroupChanged ='true'">

						<xsl:variable name="sLine">

							<xsl:text>2,</xsl:text>

							<xsl:value-of select="translate(//PurchaseOrderReferences[1]/PurchaseOrderReference,',','')"/>
							<xsl:text>,</xsl:text>
							<xsl:choose>
								<xsl:when test="//ProductGroup[../IsFoodStockProduct[.='true' or .='1']]"><xsl:value-of select="$sProductGroup"/></xsl:when>
								<xsl:otherwise><xsl:text>WFOOD</xsl:text></xsl:otherwise>
							</xsl:choose>

							<xsl:text>,</xsl:text>

							<xsl:text>DRY RECIPE COSTING</xsl:text>
							<xsl:text>,</xsl:text>

							<xsl:text>,</xsl:text>							

							<!-- just the food stock lines need to be summed -->
							<xsl:choose>
								<xsl:when test="/Invoice or /GoodsReceivedNote">										
									<xsl:value-of select="round(sum(//LineValueExclVAT[../LineExtraData[ProductGroup[.=$sProductGroup] and DeliveryNoteSuffix [.=$sDeliveryNoteSuffix] and IsFoodStockProduct[.='true' or .='1']]]))"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="-1 * round(sum(//LineValueExclVAT[../LineExtraData[ProductGroup[.=$sProductGroup] and DeliveryNoteSuffix [.=$sDeliveryNoteSuffix] and IsFoodStockProduct[.='true' or .='1']]]))"/>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:variable>

						<xsl:text>&#13;&#10;</xsl:text>

						<xsl:call-template name="msPad">
							<xsl:with-param name="vsText" select="$sLine"/>
						</xsl:call-template>

					</xsl:if>
				</xsl:for-each>

				<!--Dummy call to reset sLastProductGroup variable value to blank-->
				<xsl:variable name="DummyVariable" select="js:mbProductGroupChanged('')"/>
				
				<!-- all stock lines which are not also food stock lines are output individually -->				
				 <xsl:for-each select="(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine | /Invoice/InvoiceDetail/InvoiceLine | /CreditNote/CreditNoteDetail/CreditNoteLine | /DebitNote/DebitNoteDetail/DebitNoteLine | /DeliveryNote/DeliveryNoteDetail/DeliveryNoteLine)[LineExtraData/IsStockProduct[.='true' or .='1'] and normalize-space(LineExtraData/DeliveryNoteSuffix) = normalize-space($sDeliveryNoteSuffix) and (not(LineExtraData/IsFoodStockProduct) or LineExtraData/IsFoodStockProduct[.='false' or .='0'])]"> 
					<xsl:sort select="LineExtraData/ProductGroup" data-type="text"/>
					
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
										
						<xsl:value-of select="translate(PurchaseOrderReferences/PurchaseOrderReference,',','')"/>
						<xsl:text>,</xsl:text>
						
						<!-- Commented out the below and set only Suppliers Code to be inserted, with particular regard to Stonegate -->
						<xsl:value-of select="translate(ProductID/SuppliersProductCode,',','')"/>
						
						
						
						<!-- Cater for old documents that do not have a Buyers code, by using the Suppliers code instead -->
						<!--
						<xsl:choose>
							<xsl:when test="ProductID/BuyersProductCode">
								<xsl:value-of select="translate(ProductID/BuyersProductCode,',','')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="translate(ProductID/SuppliersProductCode,',','')"/>
							</xsl:otherwise>
						</xsl:choose>															
						-->
						<xsl:text>,</xsl:text>
						
						<xsl:value-of select="translate(ProductDescription,',','')"/>
						<xsl:text>,</xsl:text>
						
						<xsl:text>,</xsl:text>
						
						<xsl:choose>
							<xsl:when test="self::InvoiceLine/InvoicedQuantity"><xsl:value-of select="InvoicedQuantity"/></xsl:when>
							<xsl:when test="self::DebitNoteLine/DebitedQuantity">-<xsl:value-of select="DebitedQuantity"/></xsl:when>
							<xsl:when test="self::CreditNoteLine/CreditedQuantity">-<xsl:value-of select="CreditedQuantity"/></xsl:when>
							<xsl:when test="self::DeliveryNoteLine/DespatchedQuantity"><xsl:value-of select="DespatchedQuantity"/></xsl:when>
							<xsl:when test="self::GoodsReceivedNoteLine/AcceptedQuantity"><xsl:value-of select="AcceptedQuantity"/></xsl:when>
						</xsl:choose>
					</xsl:variable>							
					
					<xsl:text>&#13;&#10;</xsl:text>
					<xsl:call-template name="msPad">
						<xsl:with-param name="vsText" select="$sLine"/>
					</xsl:call-template>	
				
				</xsl:for-each>
			</xsl:for-each>			
				
		</xsl:if>
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
		
		<!-- check for old Brakes delivery note references which have a text prefix -->
		<xsl:variable name="sNewRef">
			<xsl:choose>
				<xsl:when test="substring($vsDNRef,1,3) = 'LAS' or substring($vsDNRef,1,3) = 'LTS'">
					<xsl:value-of select="substring($vsDNRef,4)"/>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$vsDNRef"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--
		 if the input value is not a number then it will return the 'NaN' token, hence
		 the slightly bizarre test below because NaN != NaN.
		 -->
		
		<xsl:choose>
			<xsl:when test="number($sNewRef) != number($sNewRef)">
				<!-- just return the original value trimmed to the maximum length of 9 characters -->
				<xsl:value-of select="substring($vsDNRef, 1, 9)"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- convert the input value to a number to strip leading zeros. -->
				<xsl:value-of select="substring(number($sNewRef), 1, 9)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
		var sLastProductGroup;

		function mbProductGroupChanged(sProductGroup)
		{
			if (sLastProductGroup != sProductGroup)
			{
				sLastProductGroup = sProductGroup;
				return true;
			}
			else
			{
				return false;
			}
		}
				
	]]></msxsl:script>
		
</xsl:stylesheet>
