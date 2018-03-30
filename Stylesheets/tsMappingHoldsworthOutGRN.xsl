<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Goods Received Note into a readable text format

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 12/07/2004 | A Sheppard | Created module.
******************************************************************************************
-->

<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	<xsl:template match="/">Goods Received Note


Buyers Details:

GLN:					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/GLN"/>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/BuyersCode">
Buyers Code:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/SuppliersCode">
Suppliers Code:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersName">
Name:					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersName"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress">
Address:				<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine2">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine3">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine4">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/AddressLine4"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/PostCode">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Buyer/BuyersAddress/PostCode"/>
</xsl:if>


Suppliers Details:

GLN:					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/GLN"/>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode">
Buyers Code:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
Suppliers Code:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersName">
Name:					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersName"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress">
Address:				<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine2">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine3">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine4">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine4"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/PostCode">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersAddress/PostCode"/>
</xsl:if>


Ship To Details:

GLN:					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/GLN"/>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
Buyers Code:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
Suppliers Code:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToName">
Name:					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToName"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress">
Address:				<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine3">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine4">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine4"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/PostCode">.
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/PostCode"/>
</xsl:if>


Delivery Details:

Delivered Delivery Type:	<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliveryType"/>
Delivered Delivery Date:	<xsl:value-of select="script:msFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliveryDate)"/>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliverySlot">
Delivered Slot Start:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliverySlot/SlotStart"/>
Delivered Slot End:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/DeliverySlot/SlotEnd"/>
</xsl:if>
Despatch Date:			<xsl:value-of select="script:msFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DespatchDate)"/>
Received Delivery Type:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryType"/>
Received Delivery Date:		<xsl:value-of select="script:msFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryDate)"/>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliverySlot">
Received Slot Start:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliverySlot/SlotStart"/>
Received Slot End:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliverySlot/SlotEnd"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/SpecialDeliveryInstructions">
Specical Delivery Instr:	<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveredDeliveryDetails/SpecialDeliveryInstructions"/>
</xsl:if>


References:

GRN Reference:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
GRN Date:				<xsl:value-of select="script:msFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate)"/>
DCN Reference:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
DCN Date:				<xsl:value-of select="script:msFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteDate)"/>
ORC Reference:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
ORC Date:				<xsl:value-of select="script:msFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate)"/>
ORD Reference:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
ORD Date:				<xsl:value-of select="script:msFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate)"/>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference">
Customers ORD Ref:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference">


Trade Agreement:

Contract Reference:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
Contract Date:			<xsl:value-of select="script:msFormatDate(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/TradeAgreement/ContractDate)"/>
</xsl:if>


Totals:

Number Of Lines:			<xsl:value-of select="count(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine[@LineStatus != 'Accepted'])"/>
Doc Discount Rate:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate"/>
Lines Total Excl VAT:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer/DiscountedLinesTotalExclVAT"/>
Document Discount:		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscount"/>
Total Excl VAT:			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT"/>


GRN Lines:<xsl:for-each select="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine[@LineStatus != 'Accepted']">

Line Number:			<xsl:value-of select="LineNumber"/>
Line Status:			<xsl:value-of select="@LineStatus"/>
GTIN:					<xsl:value-of select="ProductID/GTIN"/>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/ProductID/SuppliersProductCode">
Suppliers Product Code:		<xsl:value-of select="ProductID/SuppliersProductCode"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/ProductID/BuyersProductCode">
Buyers Product Code:		<xsl:value-of select="ProductID/BuyersProductCode"/>
</xsl:if>
Description:			<xsl:value-of select="ProductDescription"/>
Delivered Quantity:		<xsl:value-of select="DeliveredQuantity"/>
Delivery UOM:			<xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/>
Accepted Quantity:		<xsl:value-of select="AcceptedQuantity"/>
Accepted UOM:			<xsl:value-of select="AcceptedQuantity/@UnitOfMeasure"/>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/PackSize">
Pack Size:				<xsl:value-of select="PackSize"/>
</xsl:if>
Unit Value:				<xsl:value-of select="UnitValueExclVAT"/>
Line Value:				<xsl:value-of select="LineValueExclVAT"/>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountRate">
Line Discount Rate		<xsl:value-of select="LineDiscountRate"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue">
Line Discount Value:		<xsl:value-of select="LineDiscountValue"/>
</xsl:if>
<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/SSCC">
SSCC:					<xsl:value-of select="SSCC"/>
</xsl:if>
<xsl:if test="Breakages">
Breakages:<xsl:for-each select="Breakages/Breakage">
Quantity: <xsl:value-of select="BreakageQuantity"/>; Base Unit: <xsl:value-of select="BaseUnit"/>; Base Amount: <xsl:value-of select="BaseAmount"/>; Sub Unit Desc: <xsl:value-of select="SubUnitDescription"/>
</xsl:for-each>
</xsl:if>
</xsl:for-each>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[
		/*=========================================================================================
		' Routine       	 : msFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in mm/dd/yyyy format
		' Author       		 : A Sheppard, 09/06/2003
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatDate(vsDate)
		{
		
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(0,4);
			}
			else
			{
				return '';
			}
				
		}
]]></msxsl:script>
</xsl:stylesheet>