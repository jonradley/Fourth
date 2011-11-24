<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2011-10-19		| 4958 Created Module
H Robson	| 2011-11-24		| 4958 fixed createAddressNodes to handle blank input lines
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<!-- =============================================================================================
	jacksonsUoMLookup
	INPUT: Jackons 'PER' element
	OUTPUT: Trade|simple UoM attribute
	============================================================================================== -->
	<xsl:template name="jacksonsUoMLookup">
		<xsl:param name="PER" />
		
		<xsl:choose>
			<xsl:when test="number(format-number($PER,'#')) = 1"><xsl:attribute name="UnitOfMeasure">EA</xsl:attribute></xsl:when>
			<xsl:otherwise><xsl:attribute name="UnitOfMeasure">CS</xsl:attribute></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- =============================================================================================
	jacksonsDateToInternal
	INPUT: DD/MM/YY, D/M/YY, D/MM/YY, DD/M/YY 
	OUTPUT: YYYY-MM-DD
	============================================================================================== -->
	<xsl:template name="jacksonsDateToInternal">
		<xsl:param name="inputDate" />
		<xsl:param name="day" />
		<xsl:param name="month" />
		<xsl:param name="year" />
		<!-- the first iteration is always 1 -->
		<xsl:param name="iteration" select="number(1)" />
		
		<!-- there are 4 steps (iterations) to this process -->
		<xsl:if test="$iteration &lt;= 4">
			<xsl:choose>
				<!-- the first iteration reads the first segment (the day) and stores it -->
				<xsl:when test="$iteration = 1">
					<xsl:call-template name="jacksonsDateToInternal">
						<xsl:with-param name="inputDate" select="substring-after($inputDate,'/')"/>
						<xsl:with-param name="day" select="format-number(substring-before($inputDate,'/'),'00')"/>
						<xsl:with-param name="iteration" select="2"/>
					</xsl:call-template>
				</xsl:when>
				<!-- the second iteration reads the second segment (the month) and stores it -->
				<xsl:when test="$iteration = 2">
					<xsl:call-template name="jacksonsDateToInternal">
						<xsl:with-param name="inputDate" select="substring-after($inputDate,'/')"/>
						<xsl:with-param name="day" select="$day"/>
						<xsl:with-param name="month" select="format-number(substring-before($inputDate,'/'),'00')"/>
						<xsl:with-param name="iteration" select="3"/>
					</xsl:call-template>
				</xsl:when>
				<!-- the third iteration reads the third segment (the year) and stores it -->
				<xsl:when test="$iteration = 3">
					<xsl:call-template name="jacksonsDateToInternal">
						<xsl:with-param name="day" select="$day"/>
						<xsl:with-param name="month" select="$month"/>
						<xsl:with-param name="year" select="format-number($inputDate,'00')"/>
						<xsl:with-param name="iteration" select="4"/>
					</xsl:call-template>
				</xsl:when>
				<!-- the fourth iteration outputs the correctly formatted date -->
				<xsl:when test="$iteration = 4">
					<xsl:text>20</xsl:text>
					<xsl:value-of select="$year"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="$month"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="$day"/>
				</xsl:when>				
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- =============================================================================================
	jacksonsVatCodeLookup
	INPUT: Jacksons VAT code
	OUTPUT: Trade|simple VAT code
	============================================================================================== -->
	<xsl:template name="jacksonsVatCodeLookup">
		<xsl:param name="vatCode" />
		
		<xsl:choose>
			<xsl:when test="$vatCode = '2'">S</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- =============================================================================================
	countLinesInText
	INPUT: multi-line text string, [break character]
	OUTPUT: The number of lines of text
	============================================================================================== -->
	<xsl:template name="countLinesInText">
		<xsl:param name="text" />
		<!-- the default breakChar is a line feed -->
		<xsl:param name="breakChar" select="'&#xA;'" />
		<!-- the first iteration is always 1 -->
		<xsl:param name="iteration" select="number(1)" />
		
		<!-- if the text is empty, return 0 -->
		<xsl:if test="$text = ''">0</xsl:if>
		
		<xsl:choose>
			<xsl:when test="contains($text,$breakChar) = true()">
				<xsl:call-template name="countLinesInText">
					<xsl:with-param name="text" select="substring-after($text,$breakChar)" />
					<xsl:with-param name="breakChar" select="$breakChar" />
					<xsl:with-param name="iteration" select="$iteration + 1" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- return the line count -->
				<xsl:value-of select="$iteration"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- =============================================================================================
	outputLineFromText
	INPUT: multi-line text string, [break character], [line number]
	OUTPUT: The requested line of text, extracted from the multi-line string
	============================================================================================== -->
	<xsl:template name="outputLineFromText">
		<xsl:param name="text" />
		<!-- the default breakChar is a line feed -->
		<xsl:param name="breakChar" select="'&#xA;'" />
		<!-- the defailt line to return is line 1 -->
		<xsl:param name="requestedLine" select="number(1)" />
		<!-- the first iteration is always 1 -->
		<xsl:param name="iteration" select="number(1)" />
		
		<!--  check that the text string is not empty, and that the requested line number is greater than 0, otherwise the template will do nothing -->
		<xsl:if test="($text != '') and (number($requestedLine) &gt; 0)">
			<xsl:choose>
				<!-- if the requested line is line 1 we can return the substring before the first instance of the break character, if there is one-->
				<xsl:when test="($requestedLine = 1) and (contains($text,$breakChar) = true())"><xsl:value-of select="substring-before($text,$breakChar)"/></xsl:when>
				<!-- or if there is no break character we return all of the text as it is considered 1 line -->
				<xsl:when test="($requestedLine = 1) and (contains($text,$breakChar) = false())"><xsl:value-of select="$text"/></xsl:when>
				<!-- if the requested line number is equal to the current iteration we can return the substring before the first remaining break character -->
				<xsl:when test="($requestedLine = $iteration) and (contains($text,$breakChar) = true())"><xsl:value-of select="substring-before($text,$breakChar)"/></xsl:when>
				<!-- or all of the reaming text if there is no remaing break character (if the requested line is the last line)-->
				<xsl:when test="($requestedLine = $iteration) and (contains($text,$breakChar) = false())"><xsl:value-of select="$text"/></xsl:when>
				<!-- otherwise we have to remove the first line and send the remaing text round again -->
				<xsl:otherwise>
					<xsl:call-template name="outputLineFromText">
						<xsl:with-param name="text" select="substring-after($text,$breakChar)" />
						<xsl:with-param name="breakChar" select="$breakChar" />
						<xsl:with-param name="requestedLine" select="$requestedLine"  />
						<xsl:with-param name="iteration" select="$iteration + 1" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- =============================================================================================
	createAddressNodes
	INPUT: multi-line text string, number of lines in that string
	OUTPUT: some or all of the nodes: <AddressLine1/>,<AddressLine2/>,<AddressLine3/>,<AddressLine4/>,<PostCode/>
	============================================================================================== -->
	<xsl:template name="createAddressNodes">
		<xsl:param name="text" select="INVOICE_TO_ADDRESS" />
		<xsl:param name="numberOfLines" />
		<xsl:param name="suppressPostCode" select="false()"/>
		<!-- the number of blank/empty input lines that have been skipped -->
		<xsl:param name="blanklines" select="number(0)" />
		<!-- the first iteration is always 1 -->
		<xsl:param name="iteration" select="number(1)" />

		<xsl:if test="$numberOfLines &gt;= 2">
			<xsl:choose>
				<!-- the last line of input is assumed to be the post code. This test case must come first so that the post code will not appear in an AddressLine node -->
				<xsl:when test="($numberOfLines = $iteration) and ($suppressPostCode = false())">
					<PostCode>
						<xsl:call-template name="outputLineFromText">
							<xsl:with-param name="text" select="$text" />
							<xsl:with-param name="requestedLine" select="$iteration" />
						</xsl:call-template>
					</PostCode>
				</xsl:when>
				
				<!-- if the iteration (the current input line being processed) is between 2 and 5 inclusive (the start and end of the address in the jacksons input) -->
				<xsl:when test="($iteration &gt;= 2) and ($iteration &lt;= 5 + $blanklines)">

					<!-- a variable to store the line being processed so we can test that its not blank -->
					<xsl:variable name="line">
						<xsl:call-template name="outputLineFromText">
							<xsl:with-param name="text" select="$text" />
							<xsl:with-param name="requestedLine" select="$iteration" />
						</xsl:call-template>
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="$line != ''">
							<xsl:element name="{concat('AddressLine',$iteration - (1 + $blanklines))}">
							<!-- we subtract 1 because the 1st addressline is the actually the 2nd input line -->
							<!-- and if there have been blank lines that we skipped, we subtract 1 for each of those to keep the addresslines sequential -->
								 <xsl:value-of select="$line"/>
							</xsl:element>
							
							<!-- if there are more lines in the input than we have had iterations, run the template again for the next iteration -->
							<xsl:if test="$numberOfLines &gt; $iteration">
								<xsl:call-template name="createAddressNodes">
									<xsl:with-param name="text" select="$text" />
									<xsl:with-param name="numberOfLines" select="$numberOfLines"  />
									<xsl:with-param name="suppressPostCode" select="$suppressPostCode"  />
									<xsl:with-param name="blanklines" select="$blanklines" />
									<xsl:with-param name="iteration" select="$iteration + 1" />
								</xsl:call-template>
							</xsl:if>
						</xsl:when>
						
						<!-- if the line being processed IS blank -->
						<xsl:otherwise>
							<!-- if there are more lines in the input than we have had iterations, run the template again for the next iteration, and increment $blanklines -->
							<xsl:if test="$numberOfLines &gt; $iteration">
								<xsl:call-template name="createAddressNodes">
									<xsl:with-param name="text" select="$text" />
									<xsl:with-param name="numberOfLines" select="$numberOfLines"  />
									<xsl:with-param name="suppressPostCode" select="$suppressPostCode"  />
									<xsl:with-param name="blanklines" select="$blanklines + 1" />
									<xsl:with-param name="iteration" select="$iteration + 1" />
								</xsl:call-template>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- if there are more lines in the input than we have had iterations, run the template again for the next iteration -->
					<xsl:if test="$numberOfLines &gt; $iteration">
						<xsl:call-template name="createAddressNodes">
							<xsl:with-param name="text" select="$text" />
							<xsl:with-param name="numberOfLines" select="$numberOfLines"  />
							<xsl:with-param name="suppressPostCode" select="$suppressPostCode"  />
							<xsl:with-param name="blanklines" select="$blanklines" />
							<xsl:with-param name="iteration" select="$iteration + 1" />
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>	
</xsl:stylesheet>
