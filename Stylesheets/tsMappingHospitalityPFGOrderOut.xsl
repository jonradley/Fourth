<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2009-09-11		| 3119 Created Module
**********************************************************************
				|						|
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:type="USED TO CONTROL HOW A FIELD IS FORMATED"  xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="utf-8"/>

	<!--=======================================================================================
	 Routine        : 
	 Description    : Writes out header and detail lines
	 Author         : Robert Cambridge
	 Alterations    : 
	========================================================================================-->
	<xsl:template match="/PurchaseOrder">
	
		<xsl:call-template name="writeRecord">
			<xsl:with-param name="xmlData">
				<Header>
					<!-- Must be ‘01’ -->			
					<RecordType type:ALPHA="" Length="2">01</RecordType>
					
					<!-- Right justify, zero fill -->
					<FoodStarCustomerNumber type:ZONED="" Length="9"><xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/></FoodStarCustomerNumber>
					
					<!-- Unique identifier for each order transmitted -->
					<CustomersPONumber type:ALPHA="" Length="15"><xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/></CustomersPONumber>
					
					<!-- Format MM/DD/YY, with slashes (or dashes).  If the delivery date is blank the next available delivery date for this customer will be used. -->
					<!--DeliveryDate type:ALPHA="" Length="8"><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/></DeliveryDate-->
					<DeliveryDate type:ALPHA="" Length="8">
						<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,6,2)"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,9,2)"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,3,2)"/>
					</DeliveryDate>
					
					<!-- Special shipping instructions that will appear on the invoice. -->
					<SpecialInstructions1 type:ALPHA="" Length="50"><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/></SpecialInstructions1>
				</Header>
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">		
			<xsl:call-template name="writeRecord">
				<xsl:with-param name="xmlData">
					<Detail>
					
						<!-- Must be ‘02’ -->
						<RecordType type:ALPHA="" Length="2">02</RecordType>
						
						<!-- Recipient’s code for sender from trading relationship (PFG’s Account number) -->
						<FOODSTARCustomerNumber type:ZONED="" Length="9"><xsl:value-of select="/*/TradeSimpleHeader/RecipientsCodeForSender"/></FOODSTARCustomerNumber>
						
						<!-- Unique identifier for each order transmitted.  Must match the header record field -->
						<CustomersPONumber type:ALPHA="" Length="15"><xsl:value-of select="/*/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/></CustomersPONumber>
						
						<!-- Right justify, zero fill -->
						<!-- ?Strip Ss? -->
						<FOODSTARItemNumber type:ZONED="" Length="6"><xsl:value-of select="ProductID/SuppliersProductCode"/></FOODSTARItemNumber>
						
						<!-- Number of whole cases being ordered. 
													
							If RIGHT(Product Code,1) <> “s” or “S” then
							= Ordered Quantity*
							Else
							= “000”					
						-->
						<CaseQuantityOrdered type:ZONED="" Length="3">
							<xsl:choose>
								<xsl:when test="translate(substring(ProductID/SuppliersProductCode,string-length(ProductID/SuppliersProductCode)),'S','s') != 's'">
									<xsl:value-of select="OrderedQuantity"/>
								</xsl:when>
								<xsl:otherwise>000</xsl:otherwise>
							</xsl:choose>
						</CaseQuantityOrdered>
						
						<!-- If broken cases are being ordered the number of individual units being ordered. 						
						
							If RIGHT(Product Code,1) <> “s” or “S” then
							= Ordered Quantity*
							Else
							= “000”							
						-->
						<EachQuantity type:ZONED="" Length="3">
							<xsl:choose>
								<xsl:when test="translate(substring(ProductID/SuppliersProductCode,string-length(ProductID/SuppliersProductCode)),'S','s') = 's'">
									<xsl:value-of select="OrderedQuantity"/>
								</xsl:when>
								<xsl:otherwise>000</xsl:otherwise>
							</xsl:choose>
						</EachQuantity>
						
						<!-- Messages will appear on the invoice. -->
						<SpecialMessage type:ALPHA="" Length="25"></SpecialMessage>
						
					</Detail>
				</xsl:with-param>
			</xsl:call-template>		
		</xsl:for-each>		
	
	</xsl:template>
	
	
	<!--=======================================================================================
	 Routine        : writeRecord
	 Description    : Turns a series of XML elements into a series of fixed width fields
	 Inputs         : 
	 Returns        : 
	 Author         : Robert Cambridge
	 Alterations    : 
	========================================================================================-->
	<xsl:template name="writeRecord">
		<xsl:param name="xmlData"/>
		
		<!-- Write out each field according to it's type and length -->
		<xsl:for-each select="msxsl:node-set($xmlData)/*/*">
		
			<!-- Get the right template for field type and pass it the datum and field length   -->
			<xsl:apply-templates select="./@type:*">
				<xsl:with-param name="data" select="."/>
				<xsl:with-param name="length" select="@Length"/>
			</xsl:apply-templates>
			
		</xsl:for-each>
	
		<xsl:text>&#13;&#10;</xsl:text>
	
	</xsl:template>
	
	<!--=======================================================================================
	 Routine        : 
	 Description    : Left justifys text fields	
	 Author         : Robert Cambridge
	 Alterations    : 
	========================================================================================-->
	<xsl:template match="@type:ALPHA">
		<xsl:param name="data"/>
		<xsl:param name="length"/>
		
		<xsl:value-of select="substring($data,1,$length)"/>
		
		<!-- Pad the field if necessary -->
		<xsl:call-template name="fillText">
			<xsl:with-param name="char" select="' '"/>
			<xsl:with-param name="width" select="$length - string-length($data)"/>
		</xsl:call-template>		
				
	</xsl:template>
	
	<!--=======================================================================================
	 Routine        : 
	 Description    : Right justifies numeric, padded with 0s	
	 Author         : Robert Cambridge
	 Alterations    : 
	========================================================================================-->
	<xsl:template match="@type:ZONED">
		<xsl:param name="data"/>
		<xsl:param name="length"/>		
		
		<!-- Pad the field if necessary -->
		<xsl:call-template name="fillText">
			<xsl:with-param name="char" select="'0'"/>
			<xsl:with-param name="width" select="$length - string-length($data)"/>			
		</xsl:call-template>	
		
		<xsl:choose>
			<xsl:when test="string-length($data) &gt; $length">
				<xsl:value-of select="substring($data,string-length($data) - $length + 1,$length)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($data,1,$length)"/>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	<!--=======================================================================================
	 Routine        : fillText
	 Description    : Recusively builds up a string of characters to the required length	
	 Author         : Robert Cambridge
	 Alterations    : 
	========================================================================================-->
	<xsl:template name="fillText">
		<xsl:param name="char"/>
		<xsl:param name="width"/>
		
		<xsl:choose>
			<xsl:when test="$width &lt; 1 "/>
			<xsl:otherwise>
				<xsl:value-of select="$char"/>
				<xsl:call-template name="fillText">
					<xsl:with-param name="char" select="$char"/>
					<xsl:with-param name="width" select="$width - 1"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>

</xsl:stylesheet>
