<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Purchase Order Acknowledgement translation following CSV 
flat file mapping for BUNZL on HOSP.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         | Date       | Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Lee Boyton   | 22/09/2006 | Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Nigel Emsen  | 22/04/2007 | Amended for Bunzl
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*******************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>
	
	<xsl:template match="/">
	
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<!-- Batch -->
				<!-- BatchDocuments-->
					<xsl:apply-templates select="@*|node()"/>
				<!--/BatchDocuments-->
			<!--/Batch-->
		</BatchRoot>
		
	</xsl:template>
	
	<!-- add the DocumentTypeNo attribute to each BatchDocument element -->
	<xsl:template match="BatchDocument">
		<xsl:copy>
			<xsl:attribute name="DocumentTypeNo">
				<xsl:text>84</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- translate the date from [yyyymmdd] format to [yyyy-mm-dd] -->
	<xsl:template match="PurchaseOrderDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,7,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,5,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,1,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<PurchaseOrderDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</PurchaseOrderDate>
	</xsl:template>
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- For Bunzl they use PL Accounts which need the PL Account mapping into SBR. but we need to detect
			if it is a PL Account customer. Therefore we will use the following protocol.
			<bunzl unit code>+<bunzl PL account code>. Splitting on the "+"
	-->
	<!-- xsl:template match="TradeSimpleHeader"-->
	
		<!--TradeSimpleHeader-->
		
			<!-- Split out values -->
			<!--xsl:variable name="sSCFR" select="translate(SendersCodeForRecipient,' ','')"/-->

			<!-- SendersCodeForRecipient -->
			<!--SendersCodeForRecipient>
			
				<xsl:choose>
				
					<xsl:when test="string($sSCFR) != '' ">
						<xsl:value-of select="$sSCFR"/>
					</xsl:when-->
					
					<!-- cover off no "+" in the value -->
					<!--xsl:otherwise>
						<xsl:value-of select="SendersCodeForRecipient"/>
					</xsl:otherwise>
					
				</xsl:choose>
				
			</SendersCodeForRecipient-->
			
			<!-- SendersBranchReference -->
			<!--xsl:if test="string(SendersBranchReference) != '' ">
				<SendersBranchReference>
					<xsl:value-of select="SendersBranchReference"/>
				</SendersBranchReference>
			</xsl:if>
			
		</TradeSimpleHeader>
	
	</xsl:template-->
	
	<!-- For Bunzl they use PL Accounts which need the PL Account mapping into SBR. but we need to detect
			if it is a PL Account customer. Therefore we will use the following protocol.
			<bunzl unit code>+<bunzl PL account code>. Splitting on the "+"
	-->
	<xsl:template match="//PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/SuppliersCode">
	
		<!-- Split out values on the "+" flag. -->
		<xsl:variable name="sSupCode" select="translate(substring-before(.,'+'),' ','')"/>
		
		<SuppliersCode>
				
			<xsl:choose>
				
				<xsl:when test="string($sSupCode) != '' ">
					<xsl:value-of select="$sSupCode"/>
				</xsl:when>
					
				<!-- cover off no "+" in the value -->
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
					
				</xsl:choose>
					
		</SuppliersCode>
	
	</xsl:template>
	
</xsl:stylesheet>
