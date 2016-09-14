<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
	Converts MGR PendingDeliverySubmitted XML into initial version of TS GRN internal XML

==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 2016-09-02	| R Cambridge		| US13171 FB11284 Created
==========================================================================================
           	|            		| 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:param name="sSendersBranchReference" select="'0'"/>
	<xsl:param name="sBuyersCodeForSupplier" select="'0'"/>
	<xsl:param name="sPOReference" select="'0'"/>
	<xsl:param name="sPODate" select="'0'"/>
	<xsl:param name="sGRNReference" select="'0'"/>
	<xsl:variable name="CurrentDate" select="script:msGetTodaysDate()"/>
	<xsl:template match="/PendingDeliverySubmitted">
		<GoodsReceivedNote>
			<TradeSimpleHeader>
				<SendersCodeForRecipient>
					<xsl:value-of select="$sBuyersCodeForSupplier"/>
				</SendersCodeForRecipient>
				<SendersBranchReference>
					<xsl:value-of select="$sSendersBranchReference"/>
				</SendersBranchReference>
			</TradeSimpleHeader>
			<GoodsReceivedNoteHeader>
				<ShipTo>
					<ShipToName>
						<xsl:value-of select="Lines/Outlets/OutletName"/>
					</ShipToName>
				</ShipTo>
				<PurchaseOrderReferences>
					<PurchaseOrderReference><xsl:value-of select="$sPOReference"/></PurchaseOrderReference>
					<PurchaseOrderDate><xsl:value-of select="$sPODate"/></PurchaseOrderDate>
				</PurchaseOrderReferences>
				<DeliveryNoteReferences>
					<DeliveryNoteReference><xsl:value-of select="$sPOReference"/></DeliveryNoteReference>
					<DeliveryNoteDate><xsl:value-of select="$sPODate"/></DeliveryNoteDate>
				</DeliveryNoteReferences>
				<GoodsReceivedNoteReferences>
					<GoodsReceivedNoteReference><xsl:value-of select="$sPOReference"/></GoodsReceivedNoteReference>
					<GoodsReceivedNoteDate><xsl:value-of select="$CurrentDate"/></GoodsReceivedNoteDate>
				</GoodsReceivedNoteReferences>
				<DeliveredDeliveryDetails>
					<DeliveryDate>
						<xsl:value-of select="PlannedDeliveryDate"/>
					</DeliveryDate>
				</DeliveredDeliveryDetails>
				<ReceivedDeliveryDetails>
					<DeliveryDate>
						<xsl:value-of select="ActualDeliveryDate"/>
					</DeliveryDate>
				</ReceivedDeliveryDetails>
			</GoodsReceivedNoteHeader>
			<GoodsReceivedNoteDetail>
				<xsl:for-each select="Lines">
					<GoodsReceivedNoteLine>
						<ProductID>
							<SuppliersProductCode>
								<xsl:value-of select="ProductNumber"/>
							</SuppliersProductCode>
						</ProductID>
						<ProductDescription>
							<xsl:value-of select="ProductDescription"/>
						</ProductDescription>
						<OrderedQuantity>
							<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="OrderUnit"/></xsl:attribute>
							<xsl:value-of select="OrderedQuantity"/>
						</OrderedQuantity>
						<AcceptedQuantity>
							<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="ReceivedUnit"/></xsl:attribute>
							<xsl:value-of select="ReceivedQuantity"/>
						</AcceptedQuantity>
						<PackSize>Pack</PackSize>
						<UnitValueExclVAT>
							<xsl:value-of select="format-number(ReceivedUnitPrice, '0.##')"/>
						</UnitValueExclVAT>
					</GoodsReceivedNoteLine>
				</xsl:for-each>
			</GoodsReceivedNoteDetail>
			<GoodsReceivedNoteTrailer>
				<TotalExclVAT>
					<xsl:value-of select="Cost"/>
				</TotalExclVAT>
			</GoodsReceivedNoteTrailer>
		</GoodsReceivedNote>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : msGetTodaysDate
		' Description 	 : Gets todays date, formatted to yyyy-mm-dd
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : Rave Tech, 26/11/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msGetTodaysDate()
		{
			var dtDate = new Date();
			
			var sDate = dtDate.getDate();
			if(sDate<10)
			{
				sDate = '0' + sDate;
			}
			
			var sMonth = dtDate.getMonth() + 1;
			if(sMonth<10)
			{
				sMonth = '0' + sMonth;
			}
						
			var sYear  = dtDate.getYear() ;
			
		
			return sYear + '-'+ sMonth +'-'+ sDate;
		}
	]]></msxsl:script>
</xsl:stylesheet>
