<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2012-01-04		| 5150 Created Module
**********************************************************************
H Robson	| 2012-01-12		| 5150 Client changed date format
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="3">
						<xsl:copy>
							<xsl:apply-templates select="@*|node()"/>
						</xsl:copy>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>

	<xsl:template match="TradeSimpleHeaderSent">
		<TradeSimpleHeader>
			<xsl:apply-templates select="*"/>
		</TradeSimpleHeader>
	</xsl:template>
	
	<xsl:template match="ConfirmedQuantity">
		<OrderedQuantity UnitOfMeasure="EA"><xsl:value-of select="."/></OrderedQuantity>
		<ConfirmedQuantity UnitOfMeasure="EA"><xsl:value-of select="."/></ConfirmedQuantity>
	</xsl:template>
	
	<!-- map date formats -->
	<xsl:template match="PurchaseOrderDate">
		<PurchaseOrderDate>
			<xsl:call-template name="dateToInternal">
				<xsl:with-param name="inputDate" select="."/>
			</xsl:call-template>
		</PurchaseOrderDate>
	</xsl:template>
	<xsl:template match="DeliveryDate">
		<DeliveryDate>
			<xsl:call-template name="dateToInternal">
				<xsl:with-param name="inputDate" select="."/>
			</xsl:call-template>
		</DeliveryDate>
	</xsl:template>

	
<!-- =============================================================================================
	dateToInternal
	INPUT: DD/MM/YYYY 
	OUTPUT: YYYY-MM-DD
	============================================================================================== -->
	<xsl:template name="dateToInternal">
		<xsl:param name="inputDate" />
		<xsl:param name="day" />
		<xsl:param name="month" />
		<xsl:param name="year" />
		<xsl:param name="step" select="number(1)" />
		
		<!-- there are 4 steps to this process -->
		<xsl:if test="$step &lt;= 4">
			<xsl:choose>
				<!-- first step reads the first segment (the day) and stores it -->
				<xsl:when test="$step = 1">
					<xsl:call-template name="dateToInternal">
						<xsl:with-param name="inputDate" select="substring-after($inputDate,'/')"/>
						<xsl:with-param name="day" select="format-number(substring-before($inputDate,'/'),'00')"/>
						<xsl:with-param name="step" select="2"/>
					</xsl:call-template>
				</xsl:when>
				<!-- second step reads the second segment (the month) and stores it -->
				<xsl:when test="$step = 2">
					<xsl:call-template name="dateToInternal">
						<xsl:with-param name="inputDate" select="substring-after($inputDate,'/')"/>
						<xsl:with-param name="day" select="$day"/>
						<xsl:with-param name="month" select="format-number(substring-before($inputDate,'/'),'00')"/>
						<xsl:with-param name="step" select="3"/>
					</xsl:call-template>
				</xsl:when>
				<!-- third step reads the third segment (the year) and stores it -->
				<xsl:when test="$step = 3">
					<xsl:call-template name="dateToInternal">
						<xsl:with-param name="day" select="$day"/>
						<xsl:with-param name="month" select="$month"/>
						<xsl:with-param name="year" select="$inputDate"/>
						<xsl:with-param name="step" select="4"/>
					</xsl:call-template>
				</xsl:when>
				<!-- fourth step outputs the correctly formatted date -->
				<xsl:when test="$step = 4">
					<xsl:value-of select="$year"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="$month"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="$day"/>
				</xsl:when>				
			</xsl:choose>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>