<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Credit note mapper (Chuanglee)
'
' © ABS Ltd., 2007.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 28/07/2007  | Nigel Emsen  | Created. FB: 1310.
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">


	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>

	<!-- transposing detail lines -->
	<xsl:template match="CreditNoteLine">
	
		<CreditNoteLine>
		
				<PurchaseOrderReferences>
					<xsl:copy />
				</PurchaseOrderReferences>
				
				<ProductID>
					<xsl:copy/>
				</ProductID>
				
				<ProductDescription>
					<xsl:text>Not Provided</xsl:text>
				</ProductDescription>
				
				<CreditedQuantity>
					<xsl:copy />
				</CreditedQuantity>
				
				<UnitValueExclVAT>
					<xsl:copy />
				</UnitValueExclVAT>

				<LineValueExclVAT>
					<xsl:copy />
				</LineValueExclVAT>
				
				<VATCode>
					<xsl:copy />
				</VATCode>
				
				<!-- to be used to get the line vat amount for transposing in the stylesheet. -->
				<!--VATRate RecordPos="D" LPos="6"/-->
				
			</CreditNoteLine>
			
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
	
	<!-- date reformating -->
	<xsl:template match="PurchaseOrderDate | InvoiceDate">
		<xsl:variable name="sDate" select="translate(.,' ','')"/>
		
			<xsl:copy>
				<xsl:value-of select="concat('20',substring($sDate,1,2),'-',substring($sDate,3,2),'-',substring($sDate,5,2))"/>
			</xsl:copy>
			
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
