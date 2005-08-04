<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview: tsMappingORDCreateFromORC.xsl
'
' Maps a Hospitality Order Confirmation into an Order
' 
' © Alternative Business Solutions Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name              | Description of modification
'******************************************************************************************
' 04/08/2005  | Steven Hewitt | Created for H480
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'			  |                         |
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:user="http://mycompany.com/mynamespace" 				
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	
	<xsl:template match="/">
		<PurchaseOrder>
		
				<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      TRADESIMPLEHEADER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
				<TradeSimpleHeader>
					<!-- fill in SCR, SBR and TestFlag - everything else in the ts header can be filled in by the tradesimple router -->
					<SendersCodeForRecipient>
						<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsCodeForSender"/>
					</SendersCodeForRecipient>
					
					<xsl:if test="/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsBranchReference">
						<SendersBranchReference>
							<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsBranchReference"/>
						</SendersBranchReference>
					</xsl:if>
					
					<xsl:copy-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/TestFlag"/>
				</TradeSimpleHeader>
			
				<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      PURCHASEORDERHEADER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->			
				<PurchaseOrderHeader>
					<xsl:copy-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/DocumentStatus"/>
					<xsl:copy-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer"/>
					<xsl:copy-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier"/>
					<xsl:copy-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo"/>
					<xsl:copy-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences"/>
					<xsl:copy-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails"/>
				</PurchaseOrderHeader>				 	

				<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      PURCHASEORDERDETAIL
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
				<PurchaseOrderDetail>	
					<xsl:for-each select="//PurchaseOrderConfirmationLine">
						<PurchaseOrderLine>
							<xsl:copy-of select="LineNumber"/>
							<xsl:copy-of select="ProductID"/>
							<xsl:copy-of select="ProductDescription"/>
							<xsl:copy-of select="OrderedQuantity"/>
							<xsl:copy-of select="PackSize"/>
							<xsl:copy-of select="UnitValueExclVAT"/>
							<xsl:copy-of select="LineValueExclVAT"/>
						</PurchaseOrderLine>
					</xsl:for-each>				
				</PurchaseOrderDetail>
				
				<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      PURCHASEORDERTRAILER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
				<PurchaseOrderTrailer>	
					<xsl:copy-of select="/PurchaseOrderConfirmation//PurchaseOrderConfirmationTrailer/NumberOfLines"/>
					<xsl:copy-of select="/PurchaseOrderConfirmation//PurchaseOrderConfirmationTrailer/TotalExclVAT"/>
				</PurchaseOrderTrailer>				  			
		</PurchaseOrder>
	</xsl:template>
</xsl:stylesheet>