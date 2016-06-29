<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2009-07-08		| 2991 Created Module
**********************************************************************
R Cambridge	| 2009-07-08		| 2991 Meaning of @SenderID and @RecID has swapped around
**********************************************************************
R Cambridge	| 2010-06-01		| 3551 Handle non-pl customers by using ReturnReceipt/@RecID as BuyersLocationID/SuppliersCode
													(this is infact the customer's code for the supplier - the wrong direction - 
													but it fits with what's set up and simplifies the set up of Voxel related relationships)
**********************************************************************
R Cambridge	| 2010-10-14		| 3951 Created generic Bavel version from Aramark Spain version
**********************************************************************
R Cambridge	| 2011-04-10		| 4361 Add Batch tags to facilitate migration to applying mapping before formatcheck sets senderid (currently it's done after)
												 Create minimal XML for GRN acks (formatcheck would previsouly have sent these to completion before mapping)
**********************************************************************
R Cambridge	| 2011-10-13		| 4946 Ensure XMl produced for GRN acks doesn't inadvertently match PO ack format check rules
**********************************************************************
				|						|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method="xml" encoding="UTF-8" />
	
	<xsl:include href="./tsMappingHospitalityBavelCommon.xsl"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/Transaction[ReturnReceipt/@RecDoc != 'Pedido']">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="84">
	
						<PurchaseOrderAcknowledgement>
							
							<PurchaseOrderAcknowledgementHeader>
								
								<Supplier>
									<SuppliersLocationID>
										<xsl:comment>Goods Received Note Acknowledgement for <xsl:value-of select="ReturnReceipt/@RecID"/> - Format check will send this to completion</xsl:comment>
										<!-- 4946 R Cambridge set buyer's code to something that will never match a real supplier's code -->
										<BuyersCode>GRN_ACK___NO_MATCH</BuyersCode>						
									</SuppliersLocationID>
								</Supplier>
								
							</PurchaseOrderAcknowledgementHeader>
			
						</PurchaseOrderAcknowledgement>
						
					</BatchDocument>						
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	
	
	<xsl:template match="/Transaction[ReturnReceipt/@RecDoc = 'Pedido']">

		
		<BatchRoot>
	
			<xsl:variable name="supplierCodeForUnit">
				<xsl:call-template name="getTSSiteID">
					<xsl:with-param name="bavelUnitCode" select="string(ReturnReceipt/@SenderID)"/>
					<xsl:with-param name="bavelTopLevelSysID" select="string(ReturnReceipt/@SysTopLevelClientID)"/>					
					<!-- Note: if the recipient unit has a secondary code, it will already included in ReturnReceipt/@SenderID -->					
				</xsl:call-template>			
			</xsl:variable>
	
			<Batch>				
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="84">
	
						<PurchaseOrderAcknowledgement>
							<TradeSimpleHeader>
							
								<SendersCodeForRecipient>
									<xsl:value-of select="$supplierCodeForUnit"/>
								</SendersCodeForRecipient>
								
								<SendersBranchReference>
								
									<xsl:if test="ReturnReceipt/@SysTopLevelClientID != ''">
										<xsl:value-of select="ReturnReceipt/@SysTopLevelClientID"/>						
										<xsl:text>/</xsl:text>
									</xsl:if>
									
									<xsl:value-of select="ReturnReceipt/@RecID"/>
									
								</SendersBranchReference>				
									
							</TradeSimpleHeader>
							
							<PurchaseOrderAcknowledgementHeader>
				
								<Buyer>
									<BuyersLocationID>							
										<SuppliersCode>
										
											<xsl:choose>
												<!-- Standard baVel TR set up -->
												<xsl:when test="ReturnReceipt/@SysTopLevelClientID != ''">
													<xsl:value-of select="ReturnReceipt/@SysTopLevelClientID"/>
												</xsl:when>
												
												<!-- Aramark Spain legacy codes -->
												<xsl:otherwise>
													<xsl:value-of select="ReturnReceipt/@RecID"/>
												</xsl:otherwise>
											</xsl:choose>
											
										</SuppliersCode>
									</BuyersLocationID>
								</Buyer>
								
								<Supplier>
									<SuppliersLocationID>
										<BuyersCode><xsl:value-of select="ReturnReceipt[@RecDoc='Pedido']/@RecID"/></BuyersCode>						
									</SuppliersLocationID>
								</Supplier>
				
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode><xsl:value-of select="$supplierCodeForUnit"/></SuppliersCode>					
									</ShipToLocationID>
								</ShipTo>					
								
								<PurchaseOrderReferences>
									<PurchaseOrderReference><xsl:value-of select="ReturnReceipt/@DocRef"/></PurchaseOrderReference>
									<PurchaseOrderDate><xsl:value-of select="ReturnReceipt/@DeliveryDate"/></PurchaseOrderDate>
								</PurchaseOrderReferences>					
								
								<PurchaseOrderAcknowledgementReferences>
									<PurchaseOrderAcknowledgementReference><xsl:value-of select="ReturnReceipt/@DocRef"/></PurchaseOrderAcknowledgementReference>
									<PurchaseOrderAcknowledgementDate><xsl:value-of select="ReturnReceipt/@DeliveryDate"/></PurchaseOrderAcknowledgementDate>	
								</PurchaseOrderAcknowledgementReferences>
							
							</PurchaseOrderAcknowledgementHeader>				
							
						</PurchaseOrderAcknowledgement>
			
					</BatchDocument>
				</BatchDocuments>
			</Batch>

		</BatchRoot>
	
	</xsl:template>



</xsl:stylesheet>
