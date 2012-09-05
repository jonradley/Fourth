<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

	Internal XML to tsmaapinghospitalitybusinesswearORDOut
	

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 4/7/2012	| Stephen Bowers		| Created module
==========================================================================================
05/09/2012| KOshaughnessy		| BugFix 5676
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="xsl msxsl">
	
	<xsl:output method="xml" encoding="utf-8"/>
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
			<xsl:template match="*">
				<!-- Copy the node unchanged -->
				<xsl:copy>
					<!--Then let attributes be copied/not copied/modified by other more specific templates -->
					<xsl:apply-templates select="@*"/>
					<!-- Then within this node, continue processing children -->
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:template>
			<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
			<xsl:template match="@*">
				<!-- Copy the attribute unchanged -->
				<xsl:copy/>
			</xsl:template>
			<!-- END of GENERIC HANDLERS -->
			<xsl:template match="OrderedDeliveryDetails">
				<OrderedDeliveryDetails>
					<xsl:apply-templates/>
					<xsl:if test="not(SpecialDeliveryInstructions)">
						<SpecialDeliveryInstructions/>
					</xsl:if>
				</OrderedDeliveryDetails>
			</xsl:template>
			
			<!-- Do not pass header extra data in outbound XML -->
			<xsl:template match="HeaderExtraData"/>

	<!--=======================================================================================
  Routine        : msPrettyPrint()
  Description    : Writes whitespace between XML elements, recursively.
							(There's probably an easier way of doing this)
  Inputs         : vobjNode, the element of the XML to be transformed
						  vsPadding, the whitespace required at this level of recursion
  Outputs        : 
  Returns        : (Pretty printed XML on the results tree)
  Author         : Robert Cambridge
  Alterations    : 
 =======================================================================================-->
	<xsl:template match="/">
		<xsl:variable name="DocINV">
			<xsl:apply-templates select="/*"	/>
		</xsl:variable>
		
		<!-- Pretty-print the XML -->
		<xsl:call-template name="msPrettyPrint">
			<xsl:with-param name="vobNode" select="msxsl:node-set($DocINV)"/>
			<xsl:with-param name="vsPadding" select="'&#13;&#10;'"/>
			<xsl:with-param name="depth" select="0"/>
		</xsl:call-template>

		
	</xsl:template>
	<xsl:template name="msPrettyPrint">
		<xsl:param name="vobNode"/>
		<xsl:param name="vsPadding"/>
		<xsl:param name="depth"/>
		<xsl:choose>
			<!-- Skip the document root but not the root element! -->
			<xsl:when test="count(ancestor::*)=0 and name()=''">
				<xsl:for-each select="$vobNode/node()">
					<xsl:call-template name="msPrettyPrint">
						<xsl:with-param name="vobNode" select="."/>
						<xsl:with-param name="vsPadding" select="$vsPadding"/>
						<xsl:with-param name="depth" select="$depth + 1"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- Pad this element -->
				<xsl:value-of select="$vsPadding"/>
				<!-- Copy this element... -->
				<xsl:copy>
					<!-- ...copy its attributes... -->
					<xsl:for-each select="attribute::*">
						<xsl:copy>
							<xsl:value-of select="."/>
						</xsl:copy>
					</xsl:for-each>
					<!-- ...copy all other nodes... -->
					<xsl:for-each select="$vobNode/node()">
						<xsl:choose>
							<!-- ...if it's a text node just copy the value... -->
							<xsl:when test="name()=''">
								<xsl:value-of select="."/>
							</xsl:when>
							<!-- ...if it's an element copy its children -->
							<xsl:otherwise>
								<xsl:call-template name="msPrettyPrint">
									<xsl:with-param name="vobNode" select="."/>
									<xsl:with-param name="vsPadding" select="concat($vsPadding,'&#9;')"/>
									<xsl:with-param name="depth" select="$depth + 1"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<!-- if this is the last non-text child, pad the closing tag too. -->
					<xsl:if test="last() and count(*) !=0">
						<xsl:value-of select="$vsPadding"/>
					</xsl:if>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
