<?xml version="1.0" encoding="UTF-8"?>
<!--
************************************************************************************************
Date				|	Name						|	Desc
************************************************************************************************
21/02/2013		| M Emanuel					| 5943 Order Mapper for West Country Milk, added BatchID counter
************************************************************************************************
************************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- The Batch Processor assigns the Batch ID -->
	<xsl:param name="nBatchID">NotProvided</xsl:param>
	
	<xsl:template match="/BatchRoot[PurchaseOrder]">
	
		<order_batch>
			<xsl:attribute name="batch_id">
				<xsl:value-of select="$nBatchID"/>
			</xsl:attribute>
		
			<order_header>
				<doc_format_ver>1.0</doc_format_ver>
				<originating_software>
					<software_name><xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName"/></software_name>
					<software_ver>1.0</software_ver>
				</originating_software>
			</order_header>
			
			<supplier>
				<cp_supplier_id>
					<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				</cp_supplier_id>
				
				<xsl:if test="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName != '' ">
					<name>
						<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"/>
					</name>
				</xsl:if>
				<xsl:if test="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1 != '' ">
				<address_line_1>
					<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1"/>
				</address_line_1>
				</xsl:if>
				<xsl:if test="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2 != '' ">
				<address_line_2>
					<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2"/>
				</address_line_2>
				</xsl:if>
				<xsl:if test="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3 != '' ">
				<address_line_3>
					<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3"/>
				</address_line_3>
				</xsl:if>
				<xsl:if test="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4 != '' ">
				<address_line_4>
					<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4"/>
				</address_line_4>
				</xsl:if>
				<xsl:if test="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode != '' ">
					<postcode>
						<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode"/>
					</postcode>
				</xsl:if>
			</supplier>
			
			<orders>
				<xsl:for-each select="PurchaseOrder">
					<order>
							<xsl:attribute name="o_count"><xsl:value-of select="position()"/></xsl:attribute>
						<customer>
							<cust_id>
								<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
							</cust_id>
							<name>
								<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
							</name>
							<address_line_1>
								<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
							</address_line_1>
							<address_line_2> 
								<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
							</address_line_2>
							<address_line_3>
								<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
							</address_line_3>
							<address_line_4>
								<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
							</address_line_4>
							<postcode>
								<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
							</postcode>
						</customer>
						
						<order_details>
							<date_created>
								<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
							</date_created>
							<time_created>
								<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime"/>
							</time_created>
							<order_ref>
								<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
							</order_ref>
							<delivery_date>
								<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
							</delivery_date>
							<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions != '' ">
							<special_instructions>
								<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
							</special_instructions>
							</xsl:if>
						</order_details>
						
						<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
							<product_lines>
								<product>
									<xsl:attribute name="p_count">
										<xsl:value-of select="LineNumber"/>
									</xsl:attribute>
									<supplier_prod_num>
										<xsl:value-of select="ProductID/SuppliersProductCode"/>
									</supplier_prod_num>
									<qty_type>
										<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
									</qty_type>
									<qty_ordered>
										<xsl:value-of select="format-number(OrderedQuantity,'0.000')"/>
									</qty_ordered>
									<item_desc>
										<xsl:value-of select="ProductDescription"/>
									</item_desc>
									<item_variety></item_variety>
									<item_size>
										<xsl:value-of select="PackSize"/>
									</item_size>
									<item_price>
										<xsl:value-of select="UnitValueExclVAT"/>
									</item_price>
									<item_value>
										<xsl:value-of select="LineValueExclVAT"/>
									</item_value>
								</product>
							</product_lines>
						</xsl:for-each>
					</order>
					
				</xsl:for-each>
			</orders>
		</order_batch>
	</xsl:template>
</xsl:stylesheet>
