<!-- *******************************************************
Date		|Name				| Information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
25/10/2011| KOshaughnessy|FB4970 Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
19/12/2012	|M Emanuel	| FB 5840 renamed correctly to Harrods DCN out mapper
************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text"/>
	<xsl:template match="/DeliveryNote">

		<!--This segment is used to head, identify and specify a message-->
		<xsl:text>UNH+</xsl:text>
			<!--Message Reference-->
			<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			<xsl:text>+DESADV:D:96A:UN:EAN005</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
	
		<!--This segment is used to indicate the type and function of a message-->
		<xsl:text>BGM+</xsl:text>
			<xsl:text>351+</xsl:text>
			<!--Message reference-->
			<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			<xsl:text>+9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify the date of the Despatch Advice-->
		<xsl:text>DTM+</xsl:text>
			<xsl:text>137:</xsl:text>
			<!--Dispatch date-->
			<xsl:call-template name="msFormatDate">
				<xsl:with-param name="vsUTCDate" select="DeliveryNoteHeader/DeliveryNoteReferences/DespatchDate"/>
			</xsl:call-template>
			<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify the date of delivery-->
		<xsl:text>DTM+</xsl:text>
			<xsl:text>2:</xsl:text>
			<!--Delivery date-->
			<xsl:call-template name="msFormatDate">
				<xsl:with-param name="vsUTCDate" select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
			</xsl:call-template>
			<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<!--This segment is used to identify the trading partners involved in the Despatch Advice message (Buyer)-->
		<xsl:text>NAD+</xsl:text>
			<xsl:text>BY+</xsl:text>
			<!--Buyers GLN-->
			<xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<!--This segment is used to identify the trading partners involved in the Despatch Advice message (Supplier)-->
		<xsl:text>NAD+</xsl:text>
			<xsl:text>SE+</xsl:text>
			<!--Supplier's GLN-->
			<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to refer Harrods internal supplier number-->
		<xsl:text>RFF+</xsl:text>
			<xsl:text>IA:</xsl:text>
			<!--Buyers code for supplier-->
			<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Unit details-->
		<xsl:text>NAD+</xsl:text>
			<xsl:text>DP+</xsl:text>
			<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/GLN"/>
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<xsl:text>CPS+1'</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<xsl:text>PAC+</xsl:text>
			<!--Number of packages-->
			<xsl:value-of select="sum(DeliveryNoteDetail/DeliveryNoteLine/DespatchedQuantity)"/>
			<xsl:text>++201’</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<!--Line detail-->
		<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">
	
			<!--This segment is used to identify the line item being despatched-->
			<xsl:text>LIN+</xsl:text>
				<!--Line number-->
				<xsl:value-of select="LineNumber"/>
				<xsl:text>++</xsl:text>
				<xsl:text>5412345123453:EN</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--Buyers product information-->
			<xsl:text>PIA+</xsl:text>
				<xsl:text>1+:IN</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
	
			<!--Suppliers product information-->
			<xsl:text>PIA+</xsl:text>
				<xsl:text>1+</xsl:text>
				<xsl:value-of select="SuppliersProductCode"/>
				<xsl:text>:SA</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
	
			<xsl:text>QTY+</xsl:text>
				<xsl:text>12:</xsl:text>
				<xsl:value-of select="DespatchedQuantity"/>
			<xsl:text>'&#13;&#10;</xsl:text>
	
			<xsl:text>RFF+</xsl:text>
				<xsl:text>ON:</xsl:text>
				<xsl:value-of select="..//DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
		</xsl:for-each>

		<!--Segment count-->
		<xsl:text>UNT+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:text>'&#13;&#10;</xsl:text>

	</xsl:template>
	
<!--=======================================================================================
  Routine        : msFormateDate()
  Description    :  
  Inputs         : vsUTCDate
  Outputs        : 
  Returns        : A string
  Author         : K Oshaughnessy
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msFormatDate">
		<xsl:param name="vsUTCDate"/>
	
		<xsl:value-of select="translate($vsUTCDate,'-','')"/>
	
	</xsl:template>
	
</xsl:stylesheet>
