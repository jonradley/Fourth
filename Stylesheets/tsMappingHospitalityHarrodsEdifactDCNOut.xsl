<!-- *******************************************************
Date		|Name				| Information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
25/10/2011| KOshaughnessy|FB4970 Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
19/12/2012	|M Emanuel	| FB 5840 renamed correctly to Harrods DCN out mapper
************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:userfuncs="http://mycompany.com/mynamespace">
	<xsl:output method="text"/>
	<xsl:template match="/DeliveryNote">
	
		<xsl:variable name="sClockTime" select="userfuncs:getClockTime()"/>
	
		<!-- UNA Batch Header -->

		<xsl:text>UNA:</xsl:text>
		
		<xsl:text>+.? '</xsl:text>
		
		<xsl:text>&#13;&#10;</xsl:text>

			<xsl:text>UNB+</xsl:text>

			<!-- S001/0001, Syntax Identifier -->
			<xsl:text>UNOC:</xsl:text>
		
			<!-- S001/0002, Syntax Version Number -->
			<xsl:text>3+</xsl:text>
		
			<!-- S002/0004, Sender Identification -->
			<!--Our mailbox reference-->
			<xsl:choose>
				<xsl:when test="TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
					<xsl:text>5013546145710</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>5013546164209</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>+</xsl:text>
		
			<!-- S003/0010, Interchange recipient -->
			<xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>+</xsl:text>
		
			<!-- S004/0017, Date -->
			<xsl:value-of select="userfuncs:getDate()"/>
			<xsl:text>:</xsl:text>
		
			<!-- S004/0019, Time -->
			<xsl:value-of select="$sClockTime"/>
			<xsl:text>+</xsl:text>
		
			<!-- 0020, control reference -->
			<xsl:value-of select="DeliveryNoteHeader/BatchInformation/FileGenerationNo"/>
			<!--
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>ORDERS</xsl:text>
			-->
			<xsl:text>'</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
			
		<!-- HR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

		<!--This segment is used to head, identify and specify a message-->
		<xsl:text>UNH+</xsl:text>
			<!--Message Reference-->
			<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			<xsl:text>+DESADV:D:96A:UN:EAN005</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
	
		<!--This segment is used to indicate the type and function of a message-->
		<xsl:text>BGM+</xsl:text>
			<xsl:text>351+</xsl:text>
			<!--Message reference-->
			<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
			<xsl:text>+9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify the date of the Despatch Advice-->
		<xsl:text>DTM+</xsl:text>
			<xsl:text>137:</xsl:text>
			<!--Dispatch date-->
			<xsl:call-template name="msFormatDate">
				<xsl:with-param name="vsUTCDate" select="DeliveryNoteHeader/DeliveryNoteReferences/DespatchDate"/>
			</xsl:call-template>
			<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to specify the date of delivery-->
		<xsl:text>DTM+</xsl:text>
			<xsl:text>2:</xsl:text>
			<!--Delivery date-->
			<xsl:call-template name="msFormatDate">
				<xsl:with-param name="vsUTCDate" select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
			</xsl:call-template>
			<xsl:text>:102</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<!--This segment is used to identify the trading partners involved in the Despatch Advice message (Buyer)-->
		<xsl:text>NAD+</xsl:text>
			<xsl:text>BY+</xsl:text>
			<!--Buyers GLN-->
			<xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<!--This segment is used to identify the trading partners involved in the Despatch Advice message (Supplier)-->
		<xsl:text>NAD+</xsl:text>
			<xsl:text>SE+</xsl:text>
			<!--Supplier's GLN-->
			<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--This segment is used to refer Harrods internal supplier number-->
		<xsl:text>RFF+</xsl:text>
			<xsl:text>IA:</xsl:text>
			<!--Buyers code for supplier-->
			<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!--Unit details-->
		<xsl:text>NAD+</xsl:text>
			<xsl:text>DP+</xsl:text>
			<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/GLN"/>
			<xsl:text>::9</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<xsl:text>CPS+1</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<xsl:text>PAC+</xsl:text>
			<!--Number of packages-->
			<xsl:value-of select="sum(DeliveryNoteDetail/DeliveryNoteLine/DespatchedQuantity)"/>
			<xsl:text>++201</xsl:text>
		<xsl:text>'&#13;&#10;</xsl:text>

		<!--Line detail-->
		<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">
	
			<!--This segment is used to identify the line item being despatched-->
			<xsl:text>LIN+</xsl:text>
				<!--Line number-->
				<xsl:value-of select="position()"/>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="ProductID/GTIN"/>
				<xsl:text>:EN</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
			
			<!--Buyers product information-->
			<xsl:text>PIA+</xsl:text>
				<xsl:text>1+</xsl:text>
				<xsl:value-of select="ProductID/BuyersProductCode"/>
				<xsl:text>:IN</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
	
			<!--Suppliers product information-->
			<xsl:text>PIA+</xsl:text>
				<xsl:text>1+</xsl:text>
				<xsl:value-of select="ProductID/SuppliersProductCode"/>
				<xsl:text>:SA</xsl:text>
			<xsl:text>'&#13;&#10;</xsl:text>
	
			<xsl:text>QTY+</xsl:text>
				<xsl:text>12:</xsl:text>
				<xsl:value-of select="DespatchedQuantity"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/>
			<xsl:text>'&#13;&#10;</xsl:text>
	
			<xsl:text>RFF+</xsl:text>
				<xsl:text>ON:</xsl:text>
				<xsl:value-of select="../../DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="LineNumber"/>
			<xsl:text>'&#13;&#10;</xsl:text>
			
		</xsl:for-each>

		<!--Segment count-->
		<xsl:text>UNT+</xsl:text>
		
			<xsl:variable name="TotalLines" select="count(//DeliveryNoteLine)"/>		
			
			<xsl:choose>
				<xsl:when test="$TotalLines = 1">
					<xsl:text>16</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="($TotalLines) * 5 + 11"/>
				</xsl:otherwise>
			</xsl:choose>
		
			<xsl:text>+</xsl:text>
			<xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:text>'&#13;&#10;</xsl:text>
		
		<!-- HR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		
		<!-- UNZ, Batch Trailer -->
		<xsl:text>UNZ+</xsl:text>
			
			<!-- 0036, Interchange Control Count -->
			
			<xsl:text>1+</xsl:text>
			
			<!--	 0020, Interchange Control Reference -->
			<xsl:value-of select="DeliveryNoteHeader/BatchInformation/FileGenerationNo"/>
			<xsl:text>'</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>


	</xsl:template>
	
<!--=======================================================================================
  Routine        : msFormateDate()
  Description    :  
  Inputs         : vsUTCDate
  Outputs        : 
  Returns        : A string
  Author         : K Oshaughnessy
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msFormatDate">
		<xsl:param name="vsUTCDate"/>
	
		<xsl:value-of select="translate($vsUTCDate,'-','')"/>
	
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="userfuncs">
	<![CDATA[
		//Get a properly formatted version of todays date
		function getDate() {
			var now;
			var day, month, year;
			now = new Date();
			curYear = now.getFullYear();
			curYear = curYear.toString().slice(2);
			month = now.getMonth()+1;
			day = now.getDate();
			
			if (day.toString().length < 2 )
				day = '0' + day;

			if (month.toString().length < 2)
				month = '0' + month;
	
			return (curYear + month + day);
		}
		

      function getClockTime() {
  
	     var currentTime = new Date()
	     var hours = currentTime.getHours()     
	     hours = hours.toString();
	     var minutes = currentTime.getMinutes()
	     minutes = minutes.toString();
	     
	     if (hours.toString().length < 2 )
	     hours = '0' + hours;     
	   
	     if (minutes.toString().length < 2 )
	     minutes = '0' + minutes;
	      
	     return (hours + minutes);
	}
	]]>
 </msxsl:script>

	
</xsl:stylesheet>
