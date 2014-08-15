<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview  
==========================================================================================
 01/07/2014	| J Miguel		|	FB: 7872 Created
========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:template match="TimeAndAttendance">
		<Root>
			<xsl:apply-templates select="TimeAndAttendanceHeader"/>
			<xsl:apply-templates select="TimeAndAttendanceDetails/TimeAndAttendanceDetail"/>
		</Root>
	</xsl:template>
	<xsl:template match="TimeAndAttendanceHeader">
		<xsl:attribute name="GroupGUID"><xsl:value-of select="GroupGUID"/></xsl:attribute>
		<xsl:attribute name="DateTime"><xsl:value-of select="DateTime"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="TimeAndAttendanceDetail">
		<xsl:if test="CheckIn">
			<Record>
				<!-- Check in record -->
				<EmpNo>
					<xsl:value-of select="EmpNo"/>
				</EmpNo>
				<Location>
					<xsl:value-of select="Location"/>
				</Location>
				<ClockStatus>1</ClockStatus>
				<CheckIn>
					<xsl:value-of select="CheckIn"/>
				</CheckIn>
				<CheckOut/>
				<ActualMinutes>0</ActualMinutes>
				<Notes>--Generated by TradeSimple--</Notes>
			</Record>
		</xsl:if>
		<!-- Check out record -->
		<xsl:if test="CheckOut">
			<Record>
				<EmpNo>
					<xsl:value-of select="EmpNo"/>
				</EmpNo>
				<Location>
					<xsl:value-of select="Location"/>
				</Location>
				<ClockStatus>0</ClockStatus>
				<CheckIn/>
				<CheckOut>
					<xsl:value-of select="CheckOut"/>
				</CheckOut>
				<ActualMinutes>0</ActualMinutes>
				<Notes>--Generated by TradeSimple--</Notes>
			</Record>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>