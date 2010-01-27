<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TRG mapper for confirmations to Alphameric 

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 23/08/2007	| R Cambridge		| FB1400 Created module 
==========================================================================================
 21/10/2008	| R Cambridge     	| 2524 temporary fix to ignore split pack info for some suppliers
==========================================================================================
 04/02/2009	| Rave Tech  		| 2719 Consolidate twice appearing product code into one line using non-supersession price.
==========================================================================================
 25/02/2009	| Rave Tech  		| 2719 Added condition for status = 'changed '.
==========================================================================================
 13/05/2009	| Rave Tech  		| 2878 Removed MaxSplits logic and implemented CaseSize logic.
==========================================================================================
 26/05/2009	| Rave Tech  		| 2719 Fixed nested substitution line inside the substituted line issue.
==========================================================================================
30/07/2009	| Rave Tech  		| 3024 Removed nesting of substituted products.
==========================================================================================
15/01/2010	| Rave Tech  		| 3329 Populate the description field with a <Supplier Name> - <Supplier PO Number>.
==========================================================================================
			|					|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:template match="/PurchaseOrderConfirmation">
	
		<Order>

			<xsl:attribute name="Type">
				<xsl:value-of select="'Confirmation'"/>
			</xsl:attribute>
			
			<xsl:attribute name="OrderID">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			</xsl:attribute>
			<xsl:attribute name="UserReference">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
			</xsl:attribute>
			<xsl:attribute name="Description">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/Supplier/SuppliersName"/> - <xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
			</xsl:attribute>
			
			<xsl:attribute name="Total">
				<xsl:value-of select="PurchaseOrderConfirmationTrailer/TotalExclVAT"/>
			</xsl:attribute>
			
			<xsl:attribute name="DateEntered">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DateChanged">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="TargetDeliveryDate">
				<xsl:value-of select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
				<xsl:text>T00:00:00</xsl:text>
			</xsl:attribute>
			
			<xsl:attribute name="SupplierId">
				<xsl:value-of select="'0'"/>
			</xsl:attribute>
			<xsl:attribute name="SupplierCode">
				<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
			</xsl:attribute>
			
			<xsl:attribute name="LocationId">
				<xsl:value-of select="'0'"/>
			</xsl:attribute>
			<xsl:attribute name="LocationCode">
				<xsl:value-of select="concat('RG',TradeSimpleHeader/RecipientsBranchReference,'/4')"/>
			</xsl:attribute>
			
			<xsl:attribute name="OrderDateTime">
				<xsl:choose>
					<xsl:when test="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderTime != ''">
						<xsl:value-of select="concat(PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate,'T',PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderTime)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate,'T00:00:00')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:attribute name="LocationGuid">
				<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
			</xsl:attribute>
			
			<xsl:attribute name="SupplierGuid">
				<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
			</xsl:attribute>

			<!-- For any line that says it's not a substitution.... -->
			<!-- ... or any line that says it is but the line for the ordered item isn't present -->
			<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[not(SubstitutedProductID/SuppliersProductCode = /PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/ProductID/SuppliersProductCode)]">

				<xsl:variable name="sLineStatus">
					<xsl:value-of select="current()/@LineStatus"/>
				</xsl:variable>
				<xsl:variable name="nQuantity">
					<xsl:value-of select="current()/ConfirmedQuantity"/>
				</xsl:variable>
				<xsl:variable name="nUnitValue">
					<xsl:value-of select="current()/UnitValueExclVAT"/>
				</xsl:variable>
				
				<xsl:variable name="objCurrentLine" select="current()"/>
												
				<xsl:variable name="SkipLine">
                                                       
                                 <xsl:choose>
                                        <xsl:when test="0 &lt; count(//PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[.!=$objCurrentLine and ProductID/SuppliersProductCode =	 $objCurrentLine/ProductID/SuppliersProductCode][$sLineStatus='Added' and (@LineStatus='Accepted' or @LineStatus='Changed' or @LineStatus='Rejected')])">

                                               <xsl:text>True</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                               <xsl:variable name="nSumQuantity" select="sum(//PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[.!=$objCurrentLine and ProductID/SuppliersProductCode = $objCurrentLine/ProductID/SuppliersProductCode][@LineStatus='Added' and ($sLineStatus='Accepted' or $sLineStatus='Changed' or $sLineStatus='Rejected')]/ConfirmedQuantity ) + $nQuantity"/>
                                               <xsl:text>XML to process</xsl:text>
                                               <OrderItem>
                                                      <xsl:call-template name="WriteLine2">
                                                             <xsl:with-param name="vQuantity"><xsl:value-of select="$nSumQuantity"/></xsl:with-param>
                                                             <xsl:with-param name="vUnitValue"><xsl:value-of select="$nUnitValue"/></xsl:with-param>
                                                      </xsl:call-template>				
                                               </OrderItem>
                                              	<!-- write the details of the lines that say they are substitions for this line -->
							<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[SubstitutedProductID/SuppliersProductCode = current()/ProductID/SuppliersProductCode]">
								<OrderItem>
									<xsl:call-template name="writeLine"/> 
								</OrderItem>
							</xsl:for-each>

                                        </xsl:otherwise>
                                 </xsl:choose>
          
                           </xsl:variable>
				
				<!--Output variable value-->
				<xsl:if test="$SkipLine!='' and $SkipLine!='True'">
					<xsl:copy-of select="msxsl:node-set($SkipLine)/*"/>
				</xsl:if>

				<xsl:if test="$SkipLine = ''">
					<!-- write the details of this line -->
					<OrderItem>
						<xsl:call-template name="writeLine"/>						
					</OrderItem>
					<!-- write the details of the lines that say they are substitions for this line -->
					<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[SubstitutedProductID/SuppliersProductCode = current()/ProductID/SuppliersProductCode]">
						<OrderItem>
							<xsl:call-template name="writeLine"/>	
						</OrderItem>	
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
		</Order>
		
	</xsl:template>
	
	<xsl:template name="writeLine">
		<xsl:attribute name="SupplierProductCode">
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
		</xsl:attribute>	
		<xsl:choose>
			<!--When CaseSize is obtained then devide Qty and multiply Price by it-->
			<xsl:when test="number(LineExtraData/CaseSize) &gt; 1">
				<xsl:attribute name="Quantity">
					<xsl:value-of select="format-number(ConfirmedQuantity div LineExtraData/CaseSize,'0.00000000000000')"/>
				</xsl:attribute>
				<xsl:attribute name="UOM">
					<xsl:text>CS</xsl:text> 
				</xsl:attribute>
				<xsl:attribute name="MajorUnitPrice">
					<xsl:value-of select="format-number(UnitValueExclVAT * LineExtraData/CaseSize,'0.00')"/>
				</xsl:attribute>
			</xsl:when>
			<!--Else keep line unchanged-->
			<xsl:otherwise>
				<xsl:attribute name="Quantity">
					<xsl:value-of select="format-number(ConfirmedQuantity,'0.00000000000000')"/>
				</xsl:attribute>
				<xsl:attribute name="UOM">
					<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
				</xsl:attribute>
				<xsl:attribute name="MajorUnitPrice">
					<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:attribute name="SupplierPackageGuid">
			<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
		</xsl:attribute>	
		<xsl:attribute name="MaxSplits">
			<xsl:value-of select="MaxSplits"/>
		</xsl:attribute>	
	</xsl:template>
	
	<xsl:template name="WriteLine2">
		<xsl:param name="vQuantity"/>
		<xsl:param name="vUnitValue"/>
	
		<xsl:attribute name="SupplierProductCode">
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
		</xsl:attribute>	
		<xsl:choose>
			<!--When CaseSize is obtained then devide Qty and multiply Price by it-->
			<xsl:when test="number(LineExtraData/CaseSize) &gt; 1">
				<xsl:attribute name="Quantity">
					<xsl:value-of select="format-number($vQuantity div LineExtraData/CaseSize,'0.00000000000000')"/>
				</xsl:attribute>
				<xsl:attribute name="UOM">
					<xsl:text>CS</xsl:text> 
				</xsl:attribute>
				<xsl:attribute name="MajorUnitPrice">
					<xsl:value-of select="format-number($vUnitValue * LineExtraData/CaseSize,'0.00')"/>
				</xsl:attribute>
			</xsl:when>
			<!--Else keep line unchanged-->
			<xsl:otherwise>
				<xsl:attribute name="Quantity">
					<xsl:value-of select="format-number($vQuantity,'0.00000000000000')"/>
				</xsl:attribute>
				<xsl:attribute name="UOM">
					<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
				</xsl:attribute>
				<xsl:attribute name="MajorUnitPrice">
					<xsl:value-of select="format-number($vUnitValue,'0.00')"/>
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:attribute name="SupplierPackageGuid">
			<xsl:value-of select="'{00000000-0000-0000-0000-000000000000}'"/>
		</xsl:attribute>	
		<xsl:attribute name="MaxSplits">
			<xsl:value-of select="MaxSplits"/>
		</xsl:attribute>	
	</xsl:template>
	
</xsl:stylesheet>
