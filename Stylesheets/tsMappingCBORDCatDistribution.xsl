<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Purchase Order translation following tradacoms flat file mapping for Prezzo.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         	| Date       	| Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
K Oshaughnessy| 01/01/2012	| 5008: Created. 
A Barber	| 28/02/2013		| 6188 Set RecipientsCodeForSender to identify supplier in header, fixed effective date against each detail record.
J Miguel	| 24/10/2014		| 10062 - Aramark UK - Catalogue Description length constraint from 40 to 255
J Miguel	| 11/06/2015		| 10307 - Aramark UK - Add Not For Order Flag
**********************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output method="text"/>

<xsl:variable name="FIELD_PADDING" select="' '"/>
<xsl:template match="PriceCatalog">

	<!--Header-->
	<xsl:text>FMSVEND</xsl:text>
	<xsl:text>0001</xsl:text>
	<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
	<xsl:value-of select="script:msDeliveryDayTranslateDateToString"/>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<!--Line details-->
	<xsl:for-each select="ListOfPriceCatAction/PriceCatAction/PriceCatDetail">
	
		<!--Vendor product code-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="PartNum/PartID"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template>
		
		<!--Line Number-->
		<xsl:text xml:space="preserve">     </xsl:text>
		<!--Customer Item Number-->
		<xsl:text xml:space="preserve">                    </xsl:text>
		<!--Substitute Item Number-->
		<xsl:text xml:space="preserve">                    </xsl:text>
		<!--Brand-->
		<xsl:text xml:space="preserve">                         </xsl:text>
		
		<!--Product description-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="ListOfDescription/Description"/>
			<xsl:with-param name="fieldSize" select="255"/>
		</xsl:call-template>
		
		<!--Pack Size description-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="ListOfKeyVal/KeyVal[@Keyword='PackSize']"/>
			<xsl:with-param name="fieldSize" select="12"/>
		</xsl:call-template>
		
		<!--Price-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="ListOfPrice/Price/UnitPrice"/>
			<xsl:with-param name="fieldSize" select="9"/>
		</xsl:call-template>
		
		<!--Catch weight priced-->
		<xsl:choose>
			<xsl:when test="ListOfKeyVal/KeyVal[@Keyword='InvoicePrice'] != ''">
				<xsl:call-template name="padRight">
					<xsl:with-param name="inputText" select="ListOfKeyVal/KeyVal[@Keyword='InvoicePrice']"/>
					<xsl:with-param name="fieldSize" select="9"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text xml:space="preserve">         </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<!--effective date-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="concat(substring(//PriceCatHeader/ValidStartDate,4,2),substring(//PriceCatHeader/ValidStartDate,1,2),substring(//PriceCatHeader/ValidStartDate,7,4))"/>
			<xsl:with-param name="fieldSize" select="8"/>
		</xsl:call-template>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		
		<!--product group-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="ListOfKeyVal/KeyVal[@Keyword='Group']"/>
			<xsl:with-param name="fieldSize" select="8"/>
		</xsl:call-template>
		
		<!--Manufacturer Name-->
		<xsl:text xml:space="preserve">                         </xsl:text>
		<!--Manufacturer Item Number-->
		<xsl:text xml:space="preserve">                         </xsl:text>
		<!--Net weight-->
		<xsl:text xml:space="preserve">        </xsl:text>
		<!--Shipping Weight-->
		<xsl:text xml:space="preserve">        </xsl:text>
		
		<!--Weight Unit of Measure-->
		<xsl:choose>
			<xsl:when test="ListOfKeyVal/KeyVal[@Keyword='InvoicePriceUOM'] = 'KGM'">
				<xsl:text>K</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text xml:space="preserve"> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<!--Volume-->
		<xsl:text xml:space="preserve">        </xsl:text>
		<!--Volume Unit of Measure-->
		<xsl:text xml:space="preserve"> </xsl:text>
		<!--Discontinued Date-->
		<xsl:text xml:space="preserve">        </xsl:text>
		<!--Split Flag-->
		<xsl:text xml:space="preserve">  </xsl:text>
		
		<!--Catchweight Flag-->
		<xsl:choose>
			<xsl:when test="ListOfKeyVal/KeyVal[@Keyword='InvoicePriceUOM']">
				<xsl:text>Y</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>N</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<!--Kosher Flag-->
		<xsl:text xml:space="preserve"> </xsl:text>
		<!--Taxable Flag-->
		<xsl:text xml:space="preserve"> </xsl:text>
		<!--Medicaid Flag-->
		<xsl:text xml:space="preserve"> </xsl:text>
		<!--Book Flag-->
		<xsl:text xml:space="preserve"> </xsl:text>
		<!--Bid Flag-->
		<xsl:text xml:space="preserve"> </xsl:text>
		<!--Perishability Code-->
		<xsl:text xml:space="preserve">  </xsl:text>
		<!--Purchase Group Code-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="ListOfKeyVal/KeyVal[@Keyword='SubGroup']"/>
			<xsl:with-param name="fieldSize" select="8"/>
		</xsl:call-template>
		<!--UPC-->
		<xsl:text xml:space="preserve">               </xsl:text>
		<!--General Item Key Name-->
		<xsl:text xml:space="preserve">                </xsl:text>
		<!--Metric Flag-->
		<xsl:text xml:space="preserve"> </xsl:text>
		<!--Preferred Flag-->
		<xsl:text xml:space="preserve"> </xsl:text>
		<!--Replaced Vendor Item Number-->
		<xsl:text xml:space="preserve">                    </xsl:text>
	  	<!--Replaced Item Discontinued Date-->
		<xsl:text xml:space="preserve">        </xsl:text>
	  	<!--Not for Order Flag-->
	  	<xsl:choose>
			<xsl:when test="ListOfKeyVal/KeyVal[@Keyword='NotForOrder']='1'">Y</xsl:when>
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
		
	<xsl:text>&#13;&#10;</xsl:text>	
	</xsl:for-each>

</xsl:template>

<!--=======================================================================================
  Routine        : padRight
  Description    : right justify given text for given field width
  Author         : Robert Cambridge
  Alterations    : 
 =======================================================================================-->
<xsl:template name="padRight">
	<xsl:param name="inputText"/>
	<xsl:param name="fieldSize"/>
	
	<xsl:variable name="trimmedInput" select="substring($inputText,1,$fieldSize)"/>
	
	<xsl:value-of select="$trimmedInput"/>
	
	<xsl:call-template name="repeatText">
		<xsl:with-param name="requiredSize" select="$fieldSize - string-length($trimmedInput)"/>
	</xsl:call-template>

</xsl:template>

<!--=======================================================================================
  Routine        : repeatText
  Description    : Pad a string to the requested size 
  Author         : Robert Cambridge
  Alterations    : 
 =======================================================================================-->

<xsl:template name="repeatText">
	<xsl:param name="requiredSize"/>
	<xsl:param name="paddingChar" select="$FIELD_PADDING"/>
	
	<xsl:choose>
	
		<xsl:when test="$requiredSize &gt; 0">
			<xsl:value-of select="$paddingChar"/>
			<xsl:call-template name="repeatText">
				<xsl:with-param name="requiredSize" select="$requiredSize - 1"/>
				<xsl:with-param name="paddingChar" select="$paddingChar"/>
			</xsl:call-template>
		</xsl:when>
		
		<xsl:otherwise/>
		
	</xsl:choose>
	
</xsl:template>

<!--=======================================================================================
  Routine		: CalculateTodaysDate()
  Description	:  
  Inputs		: 
  Outputs		: 
  Returns		: A string
  Author		: Katherine OShaughnessy
  Version		: 1.0
  Alterations	: (none)
 =======================================================================================-->		
 
<msxsl:script language="VBScript" implements-prefix="script"><![CDATA[
	Function DocumentDate(docDate)
	
		Dim myDateString
		
		myDateString = Date()
		
		document.write(myDateString)	
				
	End Function
]]>	

	
</msxsl:script>	


</xsl:stylesheet>
