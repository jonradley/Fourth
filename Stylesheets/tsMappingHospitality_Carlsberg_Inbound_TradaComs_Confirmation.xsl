<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order Confirmation Batch mapper (Carlsberg)
'  Hospitality post Tradacoms flat file mapping to iXML format.
'
' © ABS Ltd., 2007.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 18/06/2007  | Nigel Emsen		| Created. FB: 1214.
'******************************************************************************************
' 28/07/2011  | Andrew Barber	| FB4657: Set confirmed qty = 0 where line status = 'Rejected'
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">


	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>

	<!-- apply detection logic -->
	<xsl:template match="BatchDocument">
 
			<xsl:variable name="sDNA" select="translate(PurchaseOrderConfirmation/TradeSimpleHeader/TestFlag,' ','')"/>

			<xsl:choose>
			
				<xsl:when test="$sDNA='ZOR' or $sDNA='EOR' ">
					<BatchDocument>
						<xsl:attribute name="DocumentTypeNo">
							<xsl:text>3</xsl:text>
						</xsl:attribute>
						
							<xsl:apply-templates/>
						
					</BatchDocument>
				</xsl:when>	

				<xsl:otherwise>
				
					<BatchDocument>
					
						<xsl:attribute name="DocumentTypeNo">
							<xsl:text>10000</xsl:text>
						</xsl:attribute>
						
						<xsl:apply-templates/>
						
					</BatchDocument>	
				
				</xsl:otherwise>
				
			</xsl:choose>
		
	</xsl:template>

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
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	
	<!-- reformat TradeSimple Header to remove DNA segment -->
	<xsl:template match="PurchaseOrderConfirmation/TradeSimpleHeader">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:choose >
					<xsl:when test="string(SendersBranchReference)!='5060166761066'">
						<xsl:value-of select="SendersCodeForRecipient"/>		
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</xsl:otherwise>
				</xsl:choose>
			</SendersCodeForRecipient>
	
			<!--SendersCodeForRecipient>
				<xsl:value-of select="SendersCodeForRecipient"/>
			</SendersCodeForRecipient-->
			<!-- detect for Orchid, Bay and Punch account with the ANA >
			<xsl:if test="string(SendersBranchReference) !='5999998145710' and string(SendersBranchReference) !='5999999145710'  and string(SendersBranchReference) !='5999996145710' and string(SendersBranchReference) !='5999995145710' and string(SendersBranchReference) !='5060166760243' and string(SendersBranchReference) !='5060166761066'">
				<SendersBranchReference>
					<xsl:value-of select="SendersBranchReference"/>
				</SendersBranchReference>
			</xsl:if-->
			
			<SendersBranchReference>
				<xsl:value-of select="SendersBranchReference"/>
			</SendersBranchReference>
			
		</TradeSimpleHeader>
	</xsl:template>

	<!-- date reformating -->
	<xsl:template match="PurchaseOrderDate | DeliveryDate | GoodsRecieveNoteDate | PurchaseOrderConfirmationDate">
		<xsl:variable name="sDate" select="translate(.,' ','')"/>
		
			<xsl:copy>
				<xsl:value-of select="concat('20',substring($sDate,1,2),'-',substring($sDate,3,2),'-',substring($sDate,5,2))"/>
			</xsl:copy>
			
	</xsl:template>
	
	<!-- Line mapping to detect line changes -->
	<xsl:template match="PurchaseOrderConfirmationLine">
	
		<!-- PurchaseOrderConfirmationLine -->
		<PurchaseOrderConfirmationLine>
		
			<!-- LineStatus -->
			
			<!-- As Carlsberg only provide rejected line numbers we need to test for the presence of element
					first otherwise we will get a NOT A NUMBER error in the stylesheet processing.
			-->		
			<xsl:if test="LineStatus">
				<xsl:if test="number(LineStatus) &gt; 5 and number(LineStatus) &lt; 100">
					<LineStatus>
						<xsl:text>Rejected</xsl:text>
					</LineStatus>
				</xsl:if>
			</xsl:if>
			
			<!-- reject code if provided from PackSize -->
			<xsl:variable name="nRejectCode" select="number(../PurchaseOrderConfirmationLine[UnitValueExclVAT=current()/LineNumber]/PackSize)"/>
			
			<!-- Get Narative from Narrative. This is bunched up by the Flat File Mapper and we need to sort out to the right line -->
			<xsl:variable name="sRejectText" select="../PurchaseOrderConfirmationLine[UnitValueExclVAT=current()/LineNumber]/Narrative"/>
			
			<!-- test if it is in the range of 6-99. -->
			<xsl:if test="$nRejectCode &gt; 5 and $nRejectCode &lt; 100">
				<xsl:attribute name="LineStatus">
					<xsl:text>Rejected</xsl:text>
				</xsl:attribute>
			</xsl:if>
		
			<!-- Line Number -->
			<xsl:copy-of select="LineNumber"/>

			<!-- ProductID -->
			<xsl:copy-of select="ProductID"/>

			<!-- ProductDescription -->
			<xsl:copy-of select="ProductDescription"/>

			<!-- ConfirmedQuantity -->
			<!--xsl:copy-of select="ConfirmedQuantity"/-->
			
			<!-- Set ConfirmedQuantity = 0 where line status = 'Rejected' -->
			<ConfirmedQuantity>
				<xsl:choose>
					<xsl:when test="$nRejectCode &gt; 5 and $nRejectCode &lt; 100">
						<xsl:text>0</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ConfirmedQuantity"/>
					</xsl:otherwise>
				</xsl:choose>
			</ConfirmedQuantity>
			
			<!-- Narrative -->
			<!-- test if it is in the range of 6-99. -->
			<xsl:if test="$nRejectCode &gt; 5 and $nRejectCode &lt; 100">
				<Narrative>
					<xsl:value-of select="$sRejectText"/>
				</Narrative>
			</xsl:if>
		
		</PurchaseOrderConfirmationLine>
	
	</xsl:template>

	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 

		'	------------------------------------------------------------------
		' FUNCTION:	To return the SystemDate in Internal XML format.
		'					Nigel Emsen, May 2007
		'	------------------------------------------------------------------
		Function sGetTodaysDate()
		
			Dim dToday
			Dim sDay, sMonth, sYear
			
			dToday=date
			
			sDay=Day(dToday)
			if CInt(sDay)<10 then sDay="0" & sDay
			
			sMonth=Month(dToday)
			if CInt(sMonth)<10 then sMonth="0" & sMonth
			
			sYear=Year(dToday)
			
			sGetTodaysDate=sYear & "-" & sMonth & "-" & sDay

		End Function
		
		'	------------------------------------------------------------------
		' FUNCTION:	To rreturn the confirmed qty by calculating from the 
		'					ALD:OQTY and the ALD:OUBA.
		'					Nigel Emsen, June 2007
		'	------------------------------------------------------------------
		Function sGetConfirmedQty(vsOQTY,vsOUBA)
		
			Dim sResult
			Dim lOQTY
			Dim lOUBA
			Dim lResult
			
			if vsOQTY="" Then vsOQTY="0"
			lOQTY=CLng(vsOQTY)

			if vsOUBA="" then vsOUBA="0"
			lOUBA=CLng(vsOUBA)

			lResult=lOQTY-lOUBA
			sResult=CStr(lResult)

			sGetConfirmedQty=sResult
			
		End Function
		
		

	]]></msxsl:script>
</xsl:stylesheet>
