<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

	Converts internal order XML into internal acknowledgement

 © Alternative Business Solutions Ltd, 2007.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					|	Description of modification
==========================================================================================
 04/07/2007	| R Cambridge			|	1193 Created module for Daily Bread
==========================================================================================
           	|                 	|	                                      
==========================================================================================
           	|                 	|	                                      
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8"/>


	<xsl:template match="/PurchaseOrder">
	
		<BatchRoot>
		
			<Batch>
				<BatchDocuments>
					<BatchDocument>					
						<xsl:attribute name="DocumentTypeNo">84</xsl:attribute>

						<PurchaseOrderAcknowledgement>
						
							<xsl:for-each select="TradeSimpleHeader">
						
								<TradeSimpleHeader>
									
									<xsl:call-template  name="swapSRC-RCS">
										<xsl:with-param name="objNodeList" select="RecipientsCodeForSender | RecipientsBranchReference | RecipientsName | RecipientsAddress"/>
										<xsl:with-param name="sOldName" select="'Recipient'"/>
										<xsl:with-param name="sNewName" select="'Sender'"/>
									</xsl:call-template>
								
									<xsl:call-template  name="swapSRC-RCS">
										<xsl:with-param name="objNodeList" select="SendersCodeForRecipient | SendersBranchReference | SendersName | SendersAddress"/>
										<xsl:with-param name="sOldName" select="'Sender'"/>
										<xsl:with-param name="sNewName" select="'Recipient'"/>
									</xsl:call-template>
									
									<xsl:apply-templates select="TestFlag"/>
									
								</TradeSimpleHeader>
								
							</xsl:for-each>	
								
							<xsl:for-each select="PurchaseOrderHeader">
							
								<PurchaseOrderAcknowledgementHeader>
											
									<xsl:apply-templates select="DocumentStatus | Buyer | Supplier | ShipTo | PurchaseOrderReferences"/>
									
									<PurchaseOrderAcknowledgementReferences>
										<PurchaseOrderAcknowledgementReference>
											<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
										</PurchaseOrderAcknowledgementReference>
										<PurchaseOrderAcknowledgementDate>
											<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
										</PurchaseOrderAcknowledgementDate>
									</PurchaseOrderAcknowledgementReferences>
					
									<xsl:apply-templates select="OrderedDeliveryDetails"/>					
									
								</PurchaseOrderAcknowledgementHeader>
								
							</xsl:for-each>
							
							
							<xsl:for-each select="PurchaseOrderTrailer">
				
								<PurchaseOrderAcknowledgementTrailer>
									<xsl:apply-templates select="NumberOfLines | TotalExclVAT"/>
								</PurchaseOrderAcknowledgementTrailer>
								
							</xsl:for-each>
							
						</PurchaseOrderAcknowledgement>
						
					</BatchDocument>	
				</BatchDocuments>
			</Batch>
			
		</BatchRoot>
		
	</xsl:template>



	<xsl:template match="/ | @* | node() | text()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node() | text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="swapSRC-RCS">
		<xsl:param name="objNodeList"/>
		<xsl:param name="sOldName"/>
		<xsl:param name="sNewName"/>
		
		
		<xsl:for-each select="$objNodeList">
		
			<xsl:variable name="sElementNameStub" select="substring-after(name(),$sOldName)"/>
			<xsl:variable name="sElementName">
				<xsl:choose>
					<xsl:when test="string-length(substring-before($sElementNameStub,$sNewName)) !=0">
						<xsl:value-of select="concat($sNewName, substring-before($sElementNameStub,$sNewName), $sOldName)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($sNewName, substring-after(name(),$sOldName))"/>
					</xsl:otherwise>
				</xsl:choose>		
			</xsl:variable>

		
			<xsl:element name="{$sElementName}">
				<xsl:apply-templates/>		
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>

</xsl:stylesheet>
