<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

	Acknowledgement to internal XML tsmapinghospitalitybusinesswearACKIn
	

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
			| 				| 
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="PurchaseOrderAcknowledgement">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="84">
						<PurchaseOrderAcknowledgement>
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="SendersCodeforUnit"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							<PurchaseOrderAcknowledgementHeader>
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="PurchaseOrderReference"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="PurchaseOrderDate"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
							</PurchaseOrderAcknowledgementHeader>
						</PurchaseOrderAcknowledgement>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
