<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 $Header: $
 Overview

This XSL file is used to pre-map the results of an Elior Estimate report
before it is run through the outbound processor (tsProcessorEliorEstimatesMapOut)

Each <CyBizXML> element will become a single output file after post-processing
by the above processor which will translate the account codes and assign
sequence numbers, which are stored in the database.

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name        | Description of modification
******************************************************************************************
 10/11/2004 | Lee Boyton  | Created module.
******************************************************************************************
 03/05/2005 | Lee Boyton  | H414. Delivery location enhancement. Cost Centre Codes are no
                          | longer unqiue for each unit so grouping needs to be by the code
                          | rather than the Unit MemberID.
******************************************************************************************
            |             |
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	<!-- this key creates an index to allow grouping of report lines by CompanyCode (column 2) -->
	<xsl:key name="keyByCompanyCode" match="LineDetails/LineDetail" use="Columns/Column[@ID='2']"/>
	<!-- this key creates an index to allow grouping of report lines by both CompanyCode and Unit Cost Centre Code (column 1) 
	note that the '::' literal is simply used as a convenient separator for the values that make up this 2 part compound key -->
	<xsl:key name="keyByCompanyCodeAndCostCentreCode" match="LineDetails/LineDetail" use="concat(Columns/Column[@ID='2'],'::',Columns/Column[@ID='1'])"/>
	<xsl:template match="/Report">
		<xsl:variable name="ReportDate" select="translate(ReportDate,'-','')"/>
		<xsl:variable name="EffectiveDate" select="HeaderDetails/HeaderDetail[Description='EffectiveDate']/Value"/>
		<xsl:variable name="ReversalDate" select="HeaderDetails/HeaderDetail[Description='ReversalDate']/Value"/>
		<!-- The Root tag is just a wrapper for all the CyBizXML elements, each of which will become a single output file following post processing -->
		<Root>
			<!-- we want an output batch file for each distinct company code and then within each batch a distinct journal (GL entry) for each Unit Cost Centre Code -->
			<!-- the first loop will match the first report detail line in each set of lines grouped by CompanyCode -->
			<xsl:for-each select="LineDetails/LineDetail[generate-id() = generate-id(key('keyByCompanyCode',Columns/Column[@ID='2'])[1])]">
				<xsl:sort select="Columns/Column[@ID='2']" data-type="text"/>
				<xsl:variable name="CompanyCode" select="Columns/Column[@ID='2']"/>
				<CyBizXML version="2.0">
					<Body>
						<BatchEntry>
							<!-- NB: BatchID will be populated during post-processing of the message -->
							<xsl:attribute name="BatchID"><xsl:value-of select="0"/></xsl:attribute>
							<xsl:attribute name="PostingDate"><xsl:value-of select="$EffectiveDate"/></xsl:attribute>
							<xsl:attribute name="CompanyID"><xsl:value-of select="$CompanyCode"/></xsl:attribute>
							<Comments/>
							<GeneralLedgers>
								<!-- now, given we can find all detail lines for the current Company Code, loop through and match the first line for each unique Unit Cost Centre Code -->
								<xsl:for-each select="key('keyByCompanyCode',$CompanyCode)[generate-id() = generate-id(key('keyByCompanyCodeAndCostCentreCode',concat($CompanyCode,'::',Columns/Column[@ID='1']))[1])]">
									<!-- sort by Unit Cost Centre Code and then by the IsEstimateControl flag -->
									<xsl:sort select="Columns/Column[@ID='1']" data-type="text"/>
									<xsl:sort select="Columns/Column[@ID='4']" data-type="text"/>
									<xsl:variable name="UnitCostCentreCode" select="Columns/Column[@ID='1']"/>
									<GeneralLedger>
										<xsl:attribute name="Currency"><xsl:text>GBP</xsl:text></xsl:attribute>
										<xsl:attribute name="DocumentNumber"><xsl:value-of select="concat($ReportDate,position())"/></xsl:attribute>
										<xsl:attribute name="TrxType"><xsl:value-of select="0"/></xsl:attribute>
										<xsl:attribute name="TrxDate"><xsl:value-of select="$EffectiveDate"/></xsl:attribute>
										<xsl:attribute name="ReverseDate"><xsl:value-of select="$ReversalDate"/></xsl:attribute>
										<xsl:attribute name="DocumentSource"><xsl:text>ABSACC</xsl:text></xsl:attribute>
										<!-- NB: VoucherNumber will be populated during post-processing of the message as it has to be unique FOREVER -->
										<xsl:attribute name="VoucherNumber"><xsl:value-of select="0"/></xsl:attribute>
										<!-- Write out the Unit Cost Centre Code (it is not part of the actual outbound format and will be removed during post processing)
										however it is required for translating the account codes and handling the estimate control account gl lines -->
										<CostCentreCode><xsl:value-of select="$UnitCostCentreCode"/></CostCentreCode>
										<!-- now that we have our distinct and sorted list of report lines for this unit we can output the required general ledger (journal) entry -->
										<xsl:for-each select="key('keyByCompanyCodeAndCostCentreCode',concat($CompanyCode,'::',$UnitCostCentreCode))">
											<GLLine>
											<xsl:choose>
												<xsl:when test="Columns/Column[@ID='4'] = 0">
													<!-- puchase GL line - there can be many of these lines -->
													<!-- NB: The account code will be translated to the required format during post processing -->
													<xsl:attribute name="AccountCode"><xsl:value-of select="Columns/Column[@ID='5']"/></xsl:attribute>
													<!-- use the document type to determine whether this is a debit (invoice) or a credit (credit) amount -->
													<xsl:choose>
														<xsl:when test="Columns/Column[@ID='3'] = 86">
															<xsl:attribute name="DebitAmount"><xsl:value-of select="Columns/Column[@ID='6']"/></xsl:attribute>
															<xsl:attribute name="CreditAmount"><xsl:value-of select="0"/></xsl:attribute>
														</xsl:when>
														<xsl:otherwise>
															<xsl:attribute name="DebitAmount"><xsl:value-of select="0"/></xsl:attribute>
															<xsl:attribute name="CreditAmount"><xsl:value-of select="Columns/Column[@ID='6']"/></xsl:attribute>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<!-- estimate control line - there will only be one of these -->
													<!-- The estimate control account code will be filled in during post processing - ESTIMATECONTROL is a convenient placeholder and used to identify this GLLine type-->
													<xsl:attribute name="AccountCode"><xsl:text>ESTIMATECONTROL</xsl:text></xsl:attribute>
													<xsl:choose>
														<xsl:when test="Columns/Column[@ID='6'] > 0">
															<xsl:attribute name="DebitAmount"><xsl:value-of select="0"/></xsl:attribute>
															<xsl:attribute name="CreditAmount"><xsl:value-of select="Columns/Column[@ID='6']"/></xsl:attribute>
														</xsl:when>
														<xsl:otherwise>
															<xsl:attribute name="DebitAmount"><xsl:value-of select="Columns/Column[@ID='6'] * -1"/></xsl:attribute>
															<xsl:attribute name="CreditAmount"><xsl:value-of select="0"/></xsl:attribute>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
											</GLLine>
										</xsl:for-each>
									</GeneralLedger>
								</xsl:for-each>
							</GeneralLedgers>
						</BatchEntry>
					</Body>
				</CyBizXML>
			</xsl:for-each>
		</Root>
	</xsl:template>
</xsl:stylesheet>
