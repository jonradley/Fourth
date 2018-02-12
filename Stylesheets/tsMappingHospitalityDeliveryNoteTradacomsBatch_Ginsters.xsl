<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations


**********************************************************************
Name			| Date			| Change
**********************************************************************
R Cambridge	| 29/10/2007	| 1556 Created module
**********************************************************************
R Cambridge	| 10/11/2008	| 2564 Only create SBR if a value is present
**********************************************************************
R Cambridge	| 11/11/2008	| 2564 Create dummy PO references to prevent all DN threading together
**********************************************************************
M Dimant		| 15/05/2009	| 2886 Add a time stamp to the end of the PO reference 
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/">

		<BatchRoot>
	
			<Batch>
				
				<BatchDocuments>
				
				
					<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/DeliveryNote">
				
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
							<DeliveryNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
									<xsl:for-each select="TradeSimpleHeader/SendersBranchReference[1]">
										<SendersBranchReference><xsl:value-of select="."/></SendersBranchReference>
									</xsl:for-each>									
								</TradeSimpleHeader>
								<DeliveryNoteHeader>
								
									<Buyer>
										<BuyersLocationID>
											<!--GLN><xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/></GLN-->
											<xsl:for-each select="DeliveryNoteHeader/Buyer/BuyersLocationID/SuppliersCode[1]">
												<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
											</xsl:for-each>											
										</BuyersLocationID>
									</Buyer>
									
									<!--Supplier>
										<SuppliersLocationID>
											<GLN><xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/></GLN>
											<SuppliersCode><xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/></SuppliersCode>
										</SuppliersLocationID>
									</Supplier-->
									
									<ShipTo>
										<ShipToLocationID>
											<GLN>5555555555555</GLN>
											<SuppliersCode><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SuppliersCode>
										</ShipToLocationID>
										<ShipToName><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToName"/></ShipToName>
										<ShipToAddress>
											<xsl:for-each select="DeliveryNoteHeader/ShipTo/ShipToAddress/*[. != '' and name() != 'PostCode']">
												<xsl:element name="{concat('AddressLine',string(position()))}">
													<xsl:value-of select="."/>
												</xsl:element>										
											</xsl:for-each>		
											<PostCode><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToAddress/PostCode"/></PostCode>							
										</ShipToAddress>
									</ShipTo>
									
									<xsl:variable name="sDocumentDate">
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:variable name="sDeliveryDate">
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:variable name="sDummyPORef" select="concat(DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode,'-',$sDeliveryDate,'T',vbscript:msTime(),'-',position())"/>
									
									<PurchaseOrderReferences>
										<PurchaseOrderReference><xsl:value-of select="$sDummyPORef"/></PurchaseOrderReference>
										<PurchaseOrderDate><xsl:value-of select="$sDocumentDate"/></PurchaseOrderDate>
									</PurchaseOrderReferences>
									
									<PurchaseOrderConfirmationReferences>
										<PurchaseOrderConfirmationReference><xsl:value-of select="$sDummyPORef"/></PurchaseOrderConfirmationReference>
										<PurchaseOrderConfirmationDate><xsl:value-of select="$sDocumentDate"/></PurchaseOrderConfirmationDate>
									</PurchaseOrderConfirmationReferences>
									
									<DeliveryNoteReferences>
										<DeliveryNoteReference><xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/></DeliveryNoteReference>
										<DeliveryNoteDate><xsl:value-of select="$sDocumentDate"/></DeliveryNoteDate>
										<DespatchDate><xsl:value-of select="$sDeliveryDate"/></DespatchDate>
									</DeliveryNoteReferences>
									
									<DeliveredDeliveryDetails>
										<!--DeliveryType/-->
										<DeliveryDate><xsl:value-of select="$sDeliveryDate"/></DeliveryDate>
									</DeliveredDeliveryDetails>
									
								</DeliveryNoteHeader>
								
								<DeliveryNoteDetail>
								
									<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">								
									
										<DeliveryNoteLine>
										
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
											</ProductID>
											
											<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>
																						
											<DespatchedQuantity UnitOfMeasure="EA">		
																				
												<xsl:if test="string(DespatchedQuantity/@UnitOfMeasure) != ''">
													<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/></xsl:attribute>
												</xsl:if>												
												
												<xsl:value-of select="DespatchedQuantity"/>
												
											</DespatchedQuantity>
											
											<PackSize><xsl:value-of select="PackSize"/></PackSize>
														
										</DeliveryNoteLine>
			
									</xsl:for-each>
									
								</DeliveryNoteDetail>
								
							</DeliveryNote>
							
						</BatchDocument>
						
					</xsl:for-each>
						
				</BatchDocuments>
			</Batch>
			
		</BatchRoot>
	
	</xsl:template>
	
	
	<xsl:template name="msFormatDate">
		<xsl:param name="vsYYMMDD"/>
		
		<xsl:value-of select="concat('20',substring($vsYYMMDD,1,2),'-',substring($vsYYMMDD,3,2),'-',substring($vsYYMMDD,5,2))"/>
		
	</xsl:template>
									
<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 

Function msTime

msTime= CStr(TimeValue(Now))

End Function
]]></msxsl:script>

</xsl:stylesheet>


