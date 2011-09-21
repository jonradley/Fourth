xml version=1.0 encoding=UTF-8
!--
Alterations

Name			 Date			 Change

M Dimant		 06092011    Created. Derived from tsMappingHospitalityInvoiceTradacomsBatch.xsl
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
M Dimant		 07092011   Added creation of a Delivery Notes for Aramark. Hides the invoice.	
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				             	

--
xslstylesheet version=1.0 xmlnsxsl=httpwww.w3.org1999XSLTransform xmlnsfo=httpwww.w3.org1999XSLFormat xmlnsmsxsl=urnschemas-microsoft-comxslt xmlnsjscript=httpabs-Ltd.com
	xsloutput method=xml encoding=UTF-8
	!-- NOTE that these string literals are not only enclosed with double quotes, but have single quotes within also--
	xslvariable name=FileHeaderSegment select='INVFIL'
	xslvariable name=DocumentSegment select='INVOIC'
	xslvariable name=FileTrailerSegment select='INVTLR'
	xslvariable name=VATTrailerSegment select='VATTLR'
	
	!-- Start point - ensure required outer BatchRoot tag is applied --
	xsltemplate match=
BatchRoot
		xslvariable name=suppliersCodeForBuyer select=translate(BatchBatchDocumentsBatchDocumentInvoiceInvoiceHeaderBuyerBuyersLocationIDSuppliersCode,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')
		
		
			xslif test=$suppliersCodeForBuyer != '5027615900013'
				!-- Don't create invoices for Aramark --
				Document
					xslattribute name=TypePrefixINVxslattribute
					!-- Create invoice --		
					xslapply-templates
				Document
			xslif
			
			xslif test=$suppliersCodeForBuyer = '5027615900013'
				!-- Create delivery notes for Aramark --
				Document
					xslattribute name=TypePrefixDNBxslattribute				
					!-- 2722 --
					xslcall-template name=createDeliveryNotes
				Document
			xslif
BatchRoot
	xsltemplate
	
	!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below --
	xsltemplate match=
		!-- Copy the node unchanged --
		xslcopy
			!--Then let attributes be copiednot copiedmodified by other more specific templates --
			xslapply-templates select=@
			!-- Then within this node, continue processing children --
			xslapply-templates
		xslcopy
	xsltemplate
	!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below--
	xsltemplate match=@
		!--Copy the attribute unchanged--
		xslcopy
	xsltemplate
	!-- END of GENERIC HANDLERS --
	
	!-- Create Sender Branch Reference if buyer is Aramark, otherwise don't.  -- 
	xsltemplate match=TradeSimpleHeader
		TradeSimpleHeader		
		xslchoose
			xslwhen test=.InvoiceInvoiceHeaderBuyerBuyersLocationIDSuppliersCode='5027615900013'
				SendersCodeForRecipientxslvalue-of select=substring-before(....SendersCodeForRecipient,'-')SendersCodeForRecipient
				SendersBranchReferencexslvalue-of select=substring-after(....SendersCodeForRecipient,'-')SendersBranchReference
			xslwhen
			xslotherwise
				SendersCodeForRecipientxslvalue-of select=SendersCodeForRecipientSendersCodeForRecipient
			xslotherwise
		xslchoose	
		TradeSimpleHeader
	xsltemplate

	!-- InvoiceLineProductIDBuyersProductCode is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over --
	xsltemplate match=BuyersProductCode
	
	!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) --
	xsltemplate match=InvoiceLineLineNumber  MeasureUnitsInPack
		xslcopy
			xslvalue-of select=format-number(., '#0.##')
		xslcopy
	xsltemplate
	
	!-- INVOIC-ILD-QTYI (InvoiceLineInvoicedQuantity) needs to be multiplied by -1 if (InvoiceLineProductIDBuyersProductCode) is NOT blank --
	!-- 941 read catchweight values if present --
	!--xsltemplate match=InvoiceLineInvoicedQuantity
	
		xslvariable name=sQuantity
			xslchoose
				xslwhen test=string(..[MeasureTotalMeasureIndicator]MeasureTotalMeasure) != ''
					xslfor-each select=..MeasureTotalMeasure[1]
						xslcall-template name=copyCurrentNodeExplicit3DP
					xslfor-each
				xslwhen
				xslotherwisexslvalue-of select=.xslotherwise
			xslchoose		
		xslvariable
		
		xslvariable name=sUoM
			xslchoose
				xslwhen test=string(MeasureTotalMeasureIndicator) = 'KG'KGMxslwhen
				xslotherwisexslvalue-of select=@UoMxslotherwise
			xslchoose		
		xslvariable
	
	
		InvoicedQuantity
			xslif test=string-length(..ProductIDBuyersProductCode) &gt; 0-xslif
			xslvalue-of select=$sQuantity
			xslif test=string(sUoM) != 0
				xslattribute name=UnitOfMeasure
					xslvalue-of select=$sUoM
				xslattribute
			xslif
		InvoicedQuantity
	
	xsltemplate--
	
	
	xsltemplate match=InvoiceLine
	
		InvoiceLine
	
			xslapply-templates select=LineNumber
			xslapply-templates select=PurchaseOrderReferences
			xslapply-templates select=PurchaseOrderConfirmationReferences
			xslapply-templates select=DeliveryNoteReferences
			xslapply-templates select=GoodsReceivedNoteReferences
			xslapply-templates select=ProductID
			xslapply-templates select=ProductDescription
			xslapply-templates select=OrderedQuantity
			xslapply-templates select=ConfirmedQuantity
			xslapply-templates select=DeliveredQuantity
			
			xslvariable name=sQuantity
				xslchoose
					xslwhen test=string(.[TotalMeasureIndicator]TotalMeasure) != ''
						xslfor-each select=.MeasureTotalMeasure[1]
							xslcall-template name=copyCurrentNodeExplicit3DP
						xslfor-each
					xslwhen
					xslotherwisexslvalue-of select=InvoicedQuantityxslotherwise
				xslchoose		
			xslvariable
			
			xslvariable name=sUoM
				xslchoose
					xslwhen test=string(.MeasureTotalMeasureIndicator) = 'KG' or string(.MeasureTotalMeasureIndicator) = 'KGM' KGMxslwhen
					xslotherwisexslvalue-of select=@UoMxslotherwise
				xslchoose		
			xslvariable
	
			
			InvoicedQuantity
				xslif test=string-length($sUoM) &gt; 0
					xslattribute name=UnitOfMeasure
						xslvalue-of select=$sUoM
					xslattribute
				xslif
				xslif test=string-length(.ProductIDBuyersProductCode) &gt; 0-xslif
				xslvalue-of select=$sQuantity			
			InvoicedQuantity
			
			xslapply-templates select=PackSize
			xslapply-templates select=UnitValueExclVAT
			xslapply-templates select=LineValueExclVAT
			xslapply-templates select=LineDiscountRate
			xslapply-templates select=LineDiscountValue
			xslapply-templates select=VATCode
			xslapply-templates select=VATRate
			xslapply-templates select=NetPriceFlag
			xslapply-templates select=Measure
			xslapply-templates select=LineExtraData
			
		InvoiceLine
		
	xsltemplate
	
	
	!-- INVOIC-ILD-LEXC(InvoiceLineLineValueExclVAT) need to be multiplied by -1 if (InvoiceLineProductIDBuyersProductCode) is NOT blank --
	xsltemplate match=InvoiceLineLineValueExclVAT
		!-- Implicit 4DP conversion required regardless of BuyersProductCode --
		xslchoose
			!--Parent of LineValueExclVAT is InvoiceLine --
			xslwhen test=string-length(..ProductIDBuyersProductCode) &gt; 0 
				!--INVOIC-ILD-CRLI is not blank, multiply by -1--
				xslcall-template name=copyCurrentNodeExplicit4DP
					xslwith-param name=lMultiplier select=-1.0
				xslcall-template
			xslwhen
			xslotherwise
				xslcall-template name=copyCurrentNodeExplicit4DP
			xslotherwise
		xslchoose
	xsltemplate
	
	!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 2 D.P --
	!-- Add any XPath whose text node needs to be converted from implicit to explicit 2 D.P. --
	xsltemplate match=BatchHeaderDocumentTotalExclVAT 
						BatchHeaderSettlementTotalExclVAT 
						BatchHeaderVATAmount 
						BatchHeaderDocumentTotalInclVAT 
						BatchHeaderSettlementTotalInclVAT 
						VATSubTotal 
						InvoiceTrailerDocumentTotalExclVAT 
						InvoiceTrailerSettlementDiscount 
						InvoiceTrailerSettlementTotalExclVAT 
						InvoiceTrailerVATAmount 
						InvoiceTrailerDocumentTotalInclVAT 
						InvoiceTrailerSettlementTotalInclVAT
		xslcall-template name=copyCurrentNodeExplicit2DP
	xsltemplate	
	!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 3 D.P --
	!-- Add any XPath whose text node needs to be converted from implicit to explicit 3 D.P. --
	xsltemplate match=OrderingMeasure  
						TotalMeasure  
						InvoiceLineVATRate
		xslcall-template name=copyCurrentNodeExplicit3DP
	xsltemplate
	!--Add any attribute XPath whose value needs to be converted from implicit 3 D.P to explicit 2 D.P. --
	xsltemplate match=VATSubTotal@VATRate
		xslattribute name={name()}
			xslvalue-of select=format-number(. div 1000.0, '0.00')
		xslattribute
	xsltemplate
	!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 4 D.P --
	!-- Add any XPath whose text node needs to be converted from implicit to explicit 4 D.P. --
	xsltemplate match=InvoiceLineUnitValueExclVAT
		xslcall-template name=copyCurrentNodeExplicit4DP
	xsltemplate
	!-- END of SIMPLE CONVERSIONS--
	
	!-- DATE CONVERSION YYMMDD to xsddate --
	xsltemplate match=PurchaseOrderReferencesPurchaseOrderDate  
						DeliveryNoteReferencesDeliveryNoteDate 
						DeliveryNoteReferencesDespatchDate 
						BatchInformationFileCreationDate 
						InvoiceReferencesInvoiceDate 
						InvoiceReferencesTaxPointDate
		xslcopy
			xslvalue-of select=concat('20', substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2))
		xslcopy
	xsltemplate
	!-- DATE CONVERSION YYMMDD[HHMMSS] to xsddateTime CCYY-MM-DDTHHMMSS+0000 --
	xsltemplate match=BatchInformationSendersTransmissionDate
		xslcopy
			xslchoose
				xslwhen test=string-length(.) &lt; 13
					!-- Convert YYMMDD to CCYY-MM-DDTHHMMSS form (xsddateTime) --
					xslvalue-of select=concat('20', substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2), 'T000000')
				xslwhen
				xslotherwise
					!-- Convert YYMMDDHHMMSS to CCYY-MM-DDTHHMMSS form (xsddateTime) --
					xslvalue-of select=concat('20', substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2), 'T', substring(.,8,2), '', substring(.,10,2), '', substring(.,12,2))
				xslotherwise
			xslchoose
		xslcopy
	xsltemplate
	!--END of DATE CONVERSIONS --
	
	!-- CURRENT NODE HELPERS --
	xsltemplate name=copyCurrentNodeDPUnchanged
		xslparam name=lMultiplier select=1.0
		xslcopy
			xslif test=string(number(.)) != 'NaN'
				xslvalue-of select=.  $lMultiplier
			xslif
		xslcopy
	xsltemplate
	!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 2 D.P. --
	xsltemplate name=copyCurrentNodeExplicit2DP
		xslparam name=lMultiplier select=1.0
		xslcopy
			xslif test=string(number(.)) != 'NaN'
				xslvalue-of select=format-number((.  $lMultiplier) div 100.0, '0.00')
			xslif
		xslcopy
	xsltemplate
	!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 3 D.P. --
	xsltemplate name=copyCurrentNodeExplicit3DP
		xslparam name=lMultiplier select=1.0
		xslcopy
			xslif test=string(number(.)) != 'NaN'
				xslvalue-of select=format-number((.  $lMultiplier) div 1000.0, '0.00#')
			xslif
		xslcopy
	xsltemplate
	!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 4 D.P. --
	xsltemplate name=copyCurrentNodeExplicit4DP
		xslparam name=lMultiplier select=1.0
		xslcopy
			xslif test=string(number(.)) != 'NaN'
				xslvalue-of select=format-number((.  $lMultiplier) div 10000.0, '0.00##')
			xslif
		xslcopy
	xsltemplate
	!-- END of CURRENT NODE HELPERS --
	
	!--
	MHDSegment HANDLER
	This handler works with the MHDSegment tags which should be at the start of the BatchHeader, but are actually at start and end. Furthermore, This collection of MHDSegments includes unwanted
	INVOIC segments, which are only required at document level, under InvoiceHeader, so the following template does not copy those.
	--
	xsltemplate match=BatchHeaderMHDSegment
		xslif test=contains(jscripttoUpperCase(string(.MHDHeader)), $FileHeaderSegment)
			!--
			Only action when this template match occurs on the first useful MHDSegment (which is probably the first MHDSegment to be found). 
			Once this tag is found, all other useful MHDSegment tags should follow as immediate siblings in the output, 
			even though they don't in the input - they are siblings, but the rest of the BatchHeader siblings are interspersed with them in the input.
			
			Make a copy of this first useful MHDSegment tree...
			--
			xslcopy-of select=.
			!-- ... and ensure all the other useful MHDSegments follow on immediatley --
			xslfor-each select=..MHDSegment
				xslchoose
					xslwhen test=contains(jscripttoUpperCase(string(.MHDHeader)), $FileTrailerSegment)
						xslcopy-of select=.
					xslwhen
					xslwhen test=contains(jscripttoUpperCase(string(.MHDHeader)), $VATTrailerSegment)
						xslcopy-of select=.
					xslwhen
				xslchoose
			xslfor-each
		xslif
	xsltemplate	
	xsltemplate match=BatchDocumentInvoiceInvoiceHeader
		!-- Get a count of all the preceding instances of BatchDocumentInvoiceInvoiceHeader --
		xslvariable name=BatchDocumentIndex select=1 + count(....preceding-sibling)
		!-- Get a node list of all the MHDSegment nodes under the BatchHeader tag--
		xslvariable name=MHDSegmentNodeList select=BatchBatchHeaderMHDSegment
		!-- Filter this node list to exclude any which do not have MHDHeader tag set to INVOIC --
		xslvariable name=DocumentSegmentNodeList select=$MHDSegmentNodeList[contains(jscripttoUpperCase(string(MHDHeader)), $DocumentSegment)]
		xslcopy
			!-- Copy the Nth instance of an INVOIC MHDSegment tag to this, the Nth Invoice header tag--
			xslcopy-of select=$DocumentSegmentNodeList[$BatchDocumentIndex]
			xslapply-templates
		xslcopy
	xsltemplate
	!-- END of MHDSegment HANDLER --
	
	!-- Check for pairing of Purchase Order Date & Purchase Order Reference --
	xsltemplate match=PurchaseOrderReferences
		xslvariable name=sPORefDate select=translate(PurchaseOrderDate,' ','')
		xslvariable name=sPORefReference select=translate(PurchaseOrderReference,' ','')
		xslif test=string($sPORefDate) !='' and string($sPORefReference) != '' 
			PurchaseOrderReferences
				PurchaseOrderReference
					xslvalue-of select=$sPORefReference
				PurchaseOrderReference
				PurchaseOrderDate
					xslvalue-of select=concat('20',substring($sPORefDate,1,2),'-',substring($sPORefDate,3,2),'-',substring($sPORefDate,5,2))
				PurchaseOrderDate
			PurchaseOrderReferences
		xslif
	xsltemplate	
	
	xsltemplate name=createDeliveryNotes
	
		Batch
			BatchDocuments
				xslfor-each select=BatchBatchDocumentsBatchDocumentInvoice
					BatchDocument
						xslattribute name=DocumentTypeNo7xslattribute
						DeliveryNote					
							TradeSimpleHeader		
								xslchoose
									xslwhen test=InvoiceHeaderBuyerBuyersLocationIDSuppliersCode='5027615900013'
										SendersCodeForRecipientxslvalue-of select=substring-before(....TradeSimpleHeaderSendersCodeForRecipient,'-')SendersCodeForRecipient
										SendersBranchReferencexslvalue-of select=substring-after(....TradeSimpleHeaderSendersCodeForRecipient,'-')SendersBranchReference
									xslwhen
									xslotherwise
										SendersCodeForRecipientxslvalue-of select=....TradeSimpleHeaderSendersCodeForRecipientSendersCodeForRecipient
									xslotherwise
								xslchoose	
							TradeSimpleHeader
							DeliveryNoteHeader
								DocumentStatusOriginalDocumentStatus
								!--xslcopy-of select=InvoiceHeaderBuyer--
								xslcopy-of select=InvoiceHeaderSupplier
								xslcopy-of select=InvoiceHeaderShipTo
								xslif test=InvoiceDetailInvoiceLine[1]PurchaseOrderReferencesPurchaseOrderReference != '' and InvoiceDetailInvoiceLine[1]PurchaseOrderReferencesPurchaseOrderDate != ''
									PurchaseOrderReferences
										xslif test=InvoiceDetailInvoiceLine[1]PurchaseOrderReferencesPurchaseOrderReference != ''
											PurchaseOrderReference
												xslvalue-of select=InvoiceDetailInvoiceLine[1]PurchaseOrderReferencesPurchaseOrderReference
											PurchaseOrderReference
										xslif
										xslif test=InvoiceDetailInvoiceLine[1]PurchaseOrderReferencesPurchaseOrderDate != ''
											xslvariable name=sDPODate
												xslvalue-of select=InvoiceDetailInvoiceLine[1]PurchaseOrderReferencesPurchaseOrderDate
											xslvariable
											PurchaseOrderDate
												xslvalue-of select=concat('20',substring($sDPODate,1,2),'-',substring($sDPODate,3,2),'-',substring($sDPODate,5,2))
											PurchaseOrderDate
										xslif
									PurchaseOrderReferences
								xslif
								DeliveryNoteReferences
									DeliveryNoteReference
										xslvalue-of select=InvoiceDetailInvoiceLine[1]DeliveryNoteReferencesDeliveryNoteReference
									DeliveryNoteReference
									xslvariable name=dDDelNoteDate
										xslvalue-of select=InvoiceDetailInvoiceLine[1]DeliveryNoteReferencesDeliveryNoteDate
									xslvariable
									DeliveryNoteDate
										xslvalue-of select=concat('20',substring($dDDelNoteDate,1,2),'-',substring($dDDelNoteDate,3,2),'-',substring($dDDelNoteDate,5,2))
									DeliveryNoteDate
								DeliveryNoteReferences
							DeliveryNoteHeader
							DeliveryNoteDetail
								xslfor-each select=InvoiceDetailInvoiceLine[not(ProductIDBuyersProductCode = '1')]
									DeliveryNoteLine
										xslcopy-of select=ProductID
										xslcopy-of select=ProductDescription
										
										
										
										xslvariable name=sQuantity
											xslchoose
												xslwhen test=string(.[TotalMeasureIndicator]TotalMeasure) != ''
													xslfor-each select=.MeasureTotalMeasure[1]
														xslcall-template name=copyCurrentNodeExplicit3DP
													xslfor-each
												xslwhen
												xslotherwisexslvalue-of select=InvoicedQuantityxslotherwise
											xslchoose		
										xslvariable
										
										xslvariable name=sUoM
											xslcall-template name=translateUoM
												xslwith-param name=givenUoM select=.MeasureTotalMeasureIndicator
											xslcall-template		
										xslvariable
								
										
										DespatchedQuantity
											xslif test=string-length($sUoM) &gt; 0
												xslattribute name=UnitOfMeasure
													xslvalue-of select=$sUoM
												xslattribute
											xslif
											xslvalue-of select=$sQuantity			
										DespatchedQuantity
										
										

										xslcopy-of select=PackSize
									DeliveryNoteLine
								xslfor-each
							DeliveryNoteDetail
							xslif test=InvoiceTrailerNumberOfLines != ''
								DeliveryNoteTrailer
									xslcopy-of select=InvoiceTrailerNumberOfLines
								DeliveryNoteTrailer
							xslif
						DeliveryNote
					BatchDocument
				xslfor-each
			BatchDocuments
		Batch

	
	xsltemplate
	
		
	!-- Templates shared by both doc types --
	xsltemplate name=translateUoM
		xslparam name=givenUoM
		
		xslchoose
			xslwhen test=$givenUoM = 'KG'KGMxslwhen
			xslwhen test=$givenUoM = 'EACH'EAxslwhen
			xslotherwisexslvalue-of select=$givenUoMxslotherwise
		xslchoose
	
	xsltemplate
	
	msxslscript language=JScript implements-prefix=jscript![CDATA[ 
		function toUpperCase(vs) {
			return vs.toUpperCase();
			return vs;
		}
	]]msxslscript
	
xslstylesheet
