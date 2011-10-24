<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2011-10-21		| 4966 Created Module
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="Invoice">
		<indepedi>
			<xsl:attribute name="editype">Invoice</xsl:attribute>
			<!-- check with client why there is a Z after dates and if it is needed -->
			<xsl:attribute name="created"><xsl:value-of select="concat(InvoiceHeader/InvoiceReferences/TaxPointDate,'Z')"/></xsl:attribute>
			<!-- clarify with client what their expected reference is -->
			<xsl:attribute name="reference"></xsl:attribute>
			<xsl:attribute name="taxpoint"><xsl:value-of select="concat(InvoiceHeader/InvoiceReferences/InvoiceDate,'Z')"/></xsl:attribute>
			<xsl:attribute name="currency"><xsl:value-of select="InvoiceHeader/Currency"/></xsl:attribute>
			
			<supplierdata>
				<xsl:attribute name="name"><xsl:value-of select="InvoiceHeader/Supplier/SuppliersName"/></xsl:attribute>
				<xsl:attribute name="code"></xsl:attribute>
				<xsl:if test="InvoiceReferences/VATRegNo != ''">
					<xsl:attribute name="vatnumber"><xsl:value-of select="InvoiceReferences/VATRegNo"/></xsl:attribute>
				</xsl:if>
			</supplierdata>
			
			<!-- Indicater client data -->
			<clientdata>
				<xsl:attribute name="name"></xsl:attribute>
				<xsl:attribute name="outletreference"></xsl:attribute>
				<xsl:attribute name="outletname"></xsl:attribute>
				<xsl:attribute name="outletaddress1"></xsl:attribute>
				<xsl:attribute name="outlettown"></xsl:attribute>
				<xsl:attribute name="outletcounty"></xsl:attribute>
				<xsl:attribute name="outletpostcode"></xsl:attribute>
				<xsl:attribute name="outletcountry"></xsl:attribute>
			</clientdata>
			
			<deliverydata>
				<xsl:attribute name="name"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/></xsl:attribute>
				<xsl:attribute name="address1"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/></xsl:attribute>
				<xsl:attribute name="town"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/></xsl:attribute>
				<xsl:attribute name="county"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/></xsl:attribute>
				<xsl:attribute name="postcode"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/PostCode"/></xsl:attribute>
				<xsl:attribute name="country"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/></xsl:attribute>
			</deliverydata>
			
			<summarydata>
				<xsl:attribute name="discountamount"><xsl:value-of select="InvoiceTrailer/DocumentDiscount"/></xsl:attribute>
				<xsl:attribute name="netamount"><xsl:value-of select="InvoiceTrailer/SettlementTotalExclVAT"/></xsl:attribute>
				<xsl:attribute name="vatamount"><xsl:value-of select="InvoiceTrailer/VATAmount"/></xsl:attribute>
				<xsl:attribute name="grossamount"><xsl:value-of select="InvoiceTrailer/SettlementTotalInclVAT"/></xsl:attribute>
			</summarydata>
			
			<productitems>
				<xsl:for-each select="InvoiceDetail/InvoiceLine">
					<productitem>
						<xsl:attribute name="description"><xsl:value-of select="ProductDescription"/></xsl:attribute>
						<xsl:attribute name="itemcode"><xsl:value-of select="ProductID/SuppliersProductCode"/></xsl:attribute>
						<!-- check with client -->
						<xsl:attribute name="nominalcode"></xsl:attribute>
						<xsl:attribute name="quantity"><xsl:value-of select="InvoicedQuantity"/></xsl:attribute>
						<xsl:attribute name="unitprice"><xsl:value-of select="UnitValueExclVAT"/></xsl:attribute>
						<xsl:attribute name="vatrate"><xsl:value-of select="format-number(VATRate,'#.00')"/></xsl:attribute>
						<xsl:attribute name="discountamount"><xsl:value-of select="LineDiscountValue"/></xsl:attribute>
						<xsl:attribute name="itemprice"><xsl:value-of select="LineValueExclVAT"/></xsl:attribute>
						<xsl:attribute name="vatamount"><xsl:value-of select="format-number(LineValueExclVAT * VATRate div 100,'#.00')"/></xsl:attribute>
					</productitem>
				</xsl:for-each>
			</productitems>
			
		</indepedi>
	</xsl:template>
	
</xsl:stylesheet>