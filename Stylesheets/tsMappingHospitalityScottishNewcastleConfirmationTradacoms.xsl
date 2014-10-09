<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************
Alterations
**********************************************************************
Date       | Name        | Change
**********************************************************************
17/03/2006 | Lee Boyton  | H574. Created.
**********************************************************************
           |				  |
**********************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml"/>

	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
				<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
		
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- START OF SN SPECIFIC HANDLERS -->
	
	<!-- PurchaseOrderConfirmationLine/ProductID/GTIN is used as a placeholder for ORDERS - DNB - SEQA and should not be copied over -->
	<xsl:template match="GTIN"/>

	<!-- PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/SpecialDeliveryInstructions is used as a placeholder for ORDHDR - DNA - GNAR
	     and is used to determine the overall status of the order confirmation. It should not be copied over -->
	<xsl:template match="ConfirmedDeliveryDetails/SpecialDeliveryInstructions"/>
	
	<!-- Handle the lines based on a code embedded in the narrative element -->
	<xsl:template match="PurchaseOrderConfirmationLine">

		<xsl:variable name="LineNarrative">
		
			<!-- We only need to check the line narrative code if the header narrative has not already rejected all the lines.
			     If the GetHeaderNarrative template returns some text then this implies reject all lines. -->
			
			<xsl:variable name="HeaderNarrative">
				<xsl:call-template name="GetHeaderNarrative">
					<xsl:with-param name="Narrative" select="//ConfirmedDeliveryDetails/SpecialDeliveryInstructions"/>
				</xsl:call-template>
			</xsl:variable>
						
			<xsl:choose>
				<xsl:when test="$HeaderNarrative = ''">

					<xsl:call-template name="GetLineNarrative">
						<xsl:with-param name="LineNumber">
							<xsl:value-of select="LineNumber"/>
						</xsl:with-param>
					</xsl:call-template>
				
				</xsl:when>
				<xsl:otherwise>
				
					<xsl:value-of select="$HeaderNarrative"/>
					
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:variable>
				
		<!-- Now output the line proper -->
		<PurchaseOrderConfirmationLine>
			
			<xsl:if test="$LineNarrative != ''">
				<xsl:attribute name="LineStatus">
					<xsl:text>Rejected</xsl:text>
				</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates select="LineNumber"/>
			<xsl:apply-templates select="ProductID"/>			
			<xsl:apply-templates select="ProductDescription"/>
			
			<!-- OrderedQuantity (+UOM) handled by in-filler -->
			
			<!-- If we have a line narrative then this implies the line id rejected so set the confirmed quantity to zero -->
			<xsl:choose>
				<xsl:when test="$LineNarrative != ''">
					<ConfirmedQuantity>
						<xsl:text>0</xsl:text>
					</ConfirmedQuantity>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="ConfirmedQuantity"/>			
				</xsl:otherwise>
			</xsl:choose>

			<!-- UnitPriceExclVat handled by in-filler -->
			<!-- LineValueExclVat handled by in-filler -->
			
			<xsl:if test="$LineNarrative != ''">
				<Narrative>
					<xsl:value-of select="$LineNarrative"/>
				</Narrative>
			</xsl:if>

		</PurchaseOrderConfirmationLine>
		
	</xsl:template>

	<!-- Helper template to return the header narrative based on the code embedded at position 13-15.
	     NOTE: All matching status codes below imply the order has been rejected. -->
	<xsl:template name="GetHeaderNarrative">
		<xsl:param name="Narrative"/>

		<xsl:variable name="HeaderCode" select="number(substring($Narrative,12,3))"/>
	
		<xsl:choose>
			<!-- 001 - Invalid Order Indicator -->
			<xsl:when test="$HeaderCode = 1">
				<xsl:text>Invalid Order Indicator.</xsl:text>
			</xsl:when>
			<!-- 002 - Invalid Ship-to customer -->
			<xsl:when test="$HeaderCode = 2">
				<xsl:text>Invalid Ship-to customer.</xsl:text>
			</xsl:when>
			<!-- 003 - Invalid Sold-to customer -->
			<xsl:when test="$HeaderCode = 3">
				<xsl:text>Invalid Sold-to customer.</xsl:text>
			</xsl:when>
			<!-- 004 - Invalid Order Type -->
			<xsl:when test="$HeaderCode = 4">
				<xsl:text>Invalid Order Type.</xsl:text>
			</xsl:when>
			<!-- 005 - Invalid Delivery Day / Factory calendar read fail -->
			<xsl:when test="$HeaderCode = 5">
				<xsl:text>Invalid Delivery Day</xsl:text>
			</xsl:when>
			<!-- 006 - Delivery Plant not found -->
			<xsl:when test="$HeaderCode = 6">
				<xsl:text>Delivery Plant not found.</xsl:text>
			</xsl:when>
			<!-- 007 - Invalid Delivery Block indicator -->
			<xsl:when test="$HeaderCode = 7">
				<xsl:text>Invalid Delivery Block indicator.</xsl:text>
			</xsl:when>			
			<!-- 010 - Invalid Delivery From Time -->
			<xsl:when test="$HeaderCode = 10">
				<xsl:text>Invalid Delivery From Time.</xsl:text>
			</xsl:when>			
			<!-- 012 - Invalid Item Line Count -->
			<xsl:when test="$HeaderCode = 12">
				<xsl:text>Invalid Item Line Count.</xsl:text>
			</xsl:when>			
			<!-- 014 - Delivery Created - Amend/Cancel not allowed -->
			<xsl:when test="$HeaderCode = 14">
				<xsl:text>Delivery Created - Amend/Cancel not allowed.</xsl:text>
			</xsl:when>			
			<!-- 015 - Partner Order Number already exists (New) -->
			<xsl:when test="$HeaderCode = 15">
				<xsl:text>Partner Order Number already exists (New).</xsl:text>
			</xsl:when>			
			<!-- 016 - Plant on amend different from original order -->
			<xsl:when test="$HeaderCode = 16">
				<xsl:text>Plant on amend different from original order.</xsl:text>
			</xsl:when>			
			<!-- 021 - Partner Order Number not found (Amend) -->
			<xsl:when test="$HeaderCode = 21">
				<xsl:text>Partner Order Number not found (Amend).</xsl:text>
			</xsl:when>
			<!-- 024 - VA01 Failure - See text on ZORDH -->
			<xsl:when test="$HeaderCode = 24">
				<xsl:text>VA01 Failure.</xsl:text>
			</xsl:when>			
			<!-- 026 - VA02 Failure - See text on ZORDH -->
			<xsl:when test="$HeaderCode = 26">
				<xsl:text>VA02 Failure.</xsl:text>
			</xsl:when>			
			<!-- 027 - Sold-to not linked to interface partner -->
			<xsl:when test="$HeaderCode = 27">
				<xsl:text>Sold-to not linked to interface partner.</xsl:text>
			</xsl:when>
			<!-- 028 - Sales org. record not found for customer -->
			<xsl:when test="$HeaderCode = 28">
				<xsl:text>Sales org. record not found for customer.</xsl:text>
			</xsl:when>			
			<!-- 029 - Sold-to sales org. blocked -->
			<xsl:when test="$HeaderCode = 29">
				<xsl:text>Account blocked</xsl:text>
			</xsl:when>			
			<!-- 030 - Delivery Date in the past -->
			<xsl:when test="$HeaderCode = 30">
				<xsl:text>Delivery Date in the past</xsl:text>
			</xsl:when>
			<!-- 031 - Delivery Date > 2 months in future -->
			<xsl:when test="$HeaderCode = 31">
				<xsl:text>Delivery Date > 2 months in future</xsl:text>
			</xsl:when>
			<!-- 032 - Invalid Ullage Return -->
			<xsl:when test="$HeaderCode = 32">
				<xsl:text>Invalid Ullage Return.</xsl:text>
			</xsl:when>
			<!-- 033 - Standard Order not on normal delivery day -->
			<xsl:when test="$HeaderCode = 33">
				<xsl:text>Standard Order not on normal delivery day</xsl:text>
			</xsl:when>
			<!-- 035 - Invalid Ullage - destroyed on site material -->
			<xsl:when test="$HeaderCode = 35">
				<xsl:text>Invalid Ullage - destroyed on site material.</xsl:text>
			</xsl:when>
			<!-- 036 - W&S emergency order received late -->
			<xsl:when test="$HeaderCode = 36">
				<xsl:text>W&amp;S emergency order received late.</xsl:text>
			</xsl:when>
			<!-- 037 - Cancellation of W&S not allowed -->
			<xsl:when test="$HeaderCode = 37">
				<xsl:text>Cancellation of W&amp;S not allowed.</xsl:text>
			</xsl:when>
			<!-- 038 - Order Block rejected - W&S sent -->
			<xsl:when test="$HeaderCode = 38">
				<xsl:text>Order Block rejected - W&amp;S sent.</xsl:text>
			</xsl:when>
			<!-- 039 - W&S emergency not for next day -->
			<xsl:when test="$HeaderCode = 39">
				<xsl:text>W&amp;S emergency not for next day.</xsl:text>
			</xsl:when>
			<!-- 040 - Invalid SSL reason code -->
			<xsl:when test="$HeaderCode = 40">
				<xsl:text>Invalid SSL reason code.</xsl:text>
			</xsl:when>
			<!-- 041 - Delivery Date not more than +2 -->
			<xsl:when test="$HeaderCode = 41">
				<xsl:text>Delivery Date not more than +2</xsl:text>
			</xsl:when>
			<!-- 042 - Emergency delivery not next day -->
			<xsl:when test="$HeaderCode = 42">
				<xsl:text>Emergency delivery not next day.</xsl:text>
			</xsl:when>
			<!-- 043 - Cellar Tank > 2 months in past -->
			<xsl:when test="$HeaderCode = 43">
				<xsl:text>Cellar Tank > 2 months in past.</xsl:text>
			</xsl:when>
			<!-- 044 - Cellar Tank > 2 weeks in future -->
			<xsl:when test="$HeaderCode = 44">
				<xsl:text>Cellar Tank > 2 weeks in future.</xsl:text>
			</xsl:when>
			<!-- 045 - WVL emergency unblock late - order deleted -->
			<xsl:when test="$HeaderCode = 45">
				<xsl:text>WVL emergency unblock late - order deleted.</xsl:text>
			</xsl:when>
			<!-- 099 - EDI Partner not known - ETS to issue alert -->
			<xsl:when test="$HeaderCode = 99">
				<xsl:text>EDI Partner not known - ETS to issue alert.</xsl:text>
			</xsl:when>			
			<!-- 666 - Delivery date before Monday 8th October -->
			<xsl:when test="$HeaderCode = 666">
				<xsl:text>Delivery date before Monday 8th October</xsl:text>
			</xsl:when>
			<!-- 888 - Line item out of stock - order raised (warning) [Possibly handled at the line level] -->
			<!-- 999 - Line item error - item removed from order [Possibly handled at the line level] -->
		</xsl:choose>
	
	</xsl:template>
	
	<!-- Helper template to return the line narrative based on the code embedded at position 19-21.
	     NOTE: All codes imply the line is rejected. -->
	<xsl:template name="GetLineNarrative"	>
		<xsl:param name="LineNumber"/>
				
		<!-- Use the line number to find a matching narrative.
		     Because the narrative is optional the value on this line may have been repeated from another line
		     by the flat file map process, so match to a line using the narrative sequence number we have stored in the GTIN -->

		<xsl:variable name="Narrative" select="//PurchaseOrderConfirmationLine[number(ProductID/GTIN) = number($LineNumber)]/Narrative"/>
		
		<!-- If there is no Narrative or the code is not one which identifies a
		     a specific action then we leave it to the in-filler to work out the line status
		     by comparing it against the original order. -->
		
		<xsl:if test="$Narrative != ''">
		
			<xsl:variable name="LineCode" select="number(substring($Narrative,19,3))"/>
		
			<xsl:choose>
				<!-- 101 - Invalid Order Line Type -->
				<xsl:when test="$LineCode = 101">
					<xsl:text>Invalid Order Line Type.</xsl:text>
				</xsl:when>
				<!-- 104 - Invalid Material Code -->
				<xsl:when test="$LineCode = 104">
					<xsl:text>Invalid Material Code</xsl:text>
				</xsl:when>
				<!-- 106 - Invalid FOC item category -->
				<xsl:when test="$LineCode = 106">
					<xsl:text>Invalid FOC item category.</xsl:text>
				</xsl:when>
				<!-- 109 - Invalid sales/return indicator -->
				<xsl:when test="$LineCode = 109">
					<xsl:text>Invalid sales/return indicator.</xsl:text>
				</xsl:when>
				<!-- 111 - Low/No Stock warning - leave for in-filler -->
				<!-- 112 - Invalid material code (sales org. / Dist Ch.) -->
				<xsl:when test="$LineCode = 112">
					<xsl:text>Invalid material code (sales org. / Dist Ch.)</xsl:text>
				</xsl:when>
				<!-- 113 - Material not on Product Listing -->
				<xsl:when test="$LineCode = 113">
					<xsl:text>Material not on Product Listing</xsl:text>
				</xsl:when>	
				<!-- 114 - Material not valid for Cellar Tank -->
				<xsl:when test="$LineCode = 114">
					<xsl:text>Material not valid for Cellar Tank.</xsl:text>
				</xsl:when>
				<!-- 115 - Invalid Sales of Container -->
				<xsl:when test="$LineCode = 115">
					<xsl:text>Invalid Sales of Container.</xsl:text>
				</xsl:when>
				<!-- 116 - Material not an empty for a returns order -->
				<xsl:when test="$LineCode = 116">
					<xsl:text>Material not an empty for a returns order.</xsl:text>
				</xsl:when>
				<!-- 117 - W&S item rejected - order received after cut-off -->
				<xsl:when test="$LineCode = 117">
					<xsl:text>W&amp;S item rejected - order received after cut-off.</xsl:text>
				</xsl:when>
				<!-- 118 - Non W&S on W&S emergency order -->
				<xsl:when test="$LineCode = 118">
					<xsl:text>Non W&amp;S on W&amp;S emergency order.</xsl:text>
				</xsl:when>
				<!-- 119 - W&S on non W&S order type -->
				<xsl:when test="$LineCode = 119">
					<xsl:text>W&amp;S on non W&amp;S order type.</xsl:text>
				</xsl:when>
				<!-- 120 - W&S Amend - Already Sent to Waverley -->
				<xsl:when test="$LineCode = 120">
					<xsl:text>W&amp;S Amend - Already Sent to Waverley.</xsl:text>
				</xsl:when>
				<!-- 121 - Unblock received after WVL cutoff, W&S item deleted -->
				<xsl:when test="$LineCode = 121">
					<xsl:text>Unblock received after WVL cutoff, W&amp;S item deleted.</xsl:text>
				</xsl:when>
				<!-- 125 - Material flagged for deletion -->
				<xsl:when test="$LineCode = 125">
					<xsl:text>Material flagged for deletion</xsl:text>
				</xsl:when>
				<!-- 126 - WVL account number not found on ship-to acct -->
				<xsl:when test="$LineCode = 126">
					<xsl:text>WVL account number not found on ship-to acct.</xsl:text>
				</xsl:when>
				<!-- 128 - Material not yet available -->
				<xsl:when test="$LineCode = 128">
					<xsl:text>Material not yet available</xsl:text>
				</xsl:when>
				<!-- 129 - Invalid customer material number -->
				<xsl:when test="$LineCode = 129">
					<xsl:text>Invalid customer material number.</xsl:text>
				</xsl:when>
				<!-- 130 - Item cannot be amended - Del.Note created -->
				<xsl:when test="$LineCode = 130">
					<xsl:text>Item cannot be amended - Del.Note created.</xsl:text>
				</xsl:when>
				<!-- 131 - W&S item rejected - No stock -->
				<xsl:when test="$LineCode = 131">
					<xsl:text>W&amp;S item rejected - No stock.</xsl:text>
				</xsl:when>
			</xsl:choose>
			
		</xsl:if>
	
	</xsl:template>
	
	<!-- END OF SN SPECIFIC HANDLERS -->

	<!-- DATE CONVERSION YYMMDD to xsd:date -->
	<xsl:template match="PurchaseOrderDate | PurchaseOrderConfirmationDate | DeliveryDate">
		<xsl:copy>
			<xsl:value-of select="concat('20',substring(.,1,2),'-',substring(.,3,2),'-',substring(.,5,2))"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- PARTY ADDRESS HANDLER -->
	<xsl:template match="BuyersAddress | SuppliersAddress | ShipToAddress">				
		<xsl:copy>
			<xsl:for-each select="*[contains(name(),'Address')][string(.) != '']">
				<xsl:element name="{concat('AddressLine', position())}"><xsl:value-of select="."/></xsl:element>		
			</xsl:for-each>
			<xsl:if test="PostCode != ''">
				<PostCode>
					<xsl:value-of select="PostCode"/>
				</PostCode>
			</xsl:if>
		</xsl:copy>	
	</xsl:template>
	
</xsl:stylesheet>
