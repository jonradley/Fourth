<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2010-08-02		| 3796 Created Module
**********************************************************************
R Cambridge	| 2011-02-23		| 4260 added delivery instructions support
**********************************************************************
K Oshaughnessy|2011-08-18	|
**********************************************************************
M Emanuel		| 2012-10-17	| Mapped in Line number and Harrod Internal Site no
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="ascii"/>
	
	<xsl:variable name="FIELD_PADDING" select="' '"/>
	<xsl:variable name="FIELD_SEPERATOR" select="'|'"/>
	<xsl:variable name="RECORD_SEPERATOR" select="'&#13;&#10;'"/>
	<xsl:variable name="DELIVERY_TEXT_LENGTH" select="50"/>
	<xsl:variable name="TEXT_BREAK_CHARACTERS" select="' ,.'"/>
	
	

	<!--=======================================================================================
	  Routine        : (main)
	  Description    : Flow of control for mapping process
	  Author         : Robert Cambridge
	  Alterations    : 
	 =======================================================================================-->
	
	<xsl:template match="/PurchaseOrder">
	
		<xsl:call-template name="writePOHeader"/>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<xsl:call-template name="writePOLine"/>
		</xsl:for-each>
				
		<xsl:call-template name="writeDeliveryInstructions"/>
				
		<xsl:call-template name="writePOTrailer"/>	
	
	
	</xsl:template>
	
	
	<!--=======================================================================================
	  Routine        : writePOHeader
	  Description    : write the order details 
	  Author         : Robert Cambridge
	  Alterations    : 
	 =======================================================================================-->
	
	<xsl:template name="writePOHeader">
	
		<xsl:text xml:space="preserve">HDR</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">29</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		
		<!--xsl:text xml:space="preserve">895952         </xsl:text-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:with-param name="fieldSize" select="15"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<!--xsl:text xml:space="preserve">040220</xsl:text-->
		<xsl:call-template name="dateYYMMDD">
			<xsl:with-param name="dateUTC" select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<!-- Order type = new order -->
		<xsl:text xml:space="preserve">O</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:call-template name="dateYYMMDD">
			<xsl:with-param name="dateUTC" select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<!-- Stock location code (ie depot) would go here -->
		<xsl:text xml:space="preserve">               </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">          </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">               </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">               </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">             </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">TRADESIMPLE    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:with-param name="fieldSize" select="15"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">          </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="concat('ORD0',PurchaseOrderHeader/FileGenerationNumber)"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		
		<!-- Mapping Harrods internal site code -->	
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">          </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
				
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                         </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		
		
		<xsl:value-of select="$RECORD_SEPERATOR"/>

	
	</xsl:template>
	
	
	<!--=======================================================================================
	  Routine        : writePOLine
	  Description    : Write a PO line
	  Author         : Robert Cambridge
	  Alterations    : 
	 =======================================================================================-->
	
	<xsl:template name="writePOLine">
	
		<xsl:variable name="sUoM">
			<xsl:choose>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'EA'">E</xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CS'">E</xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'KGM'">K</xsl:when>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:text xml:space="preserve">OLD</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<!--xsl:text xml:space="preserve">DSCO044               </xsl:text-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="ProductID/SuppliersProductCode"/>
			<xsl:with-param name="fieldSize" select="22"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<!--xsl:text xml:space="preserve">              3.00</xsl:text-->
		<xsl:call-template name="padLeft">
			<xsl:with-param name="inputText" select="format-number(OrderedQuantity,'0.00')"/>
			<xsl:with-param name="fieldSize" select="18"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">               </xsl:text>
		<!--xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="$sUoM"/>
			<xsl:with-param name="fieldSize" select="15"/>
		</xsl:call-template-->
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<!--xsl:call-template name="padLeft">
			<xsl:with-param name="inputText" select="format-number(UnitValueExclVAT,'0.00')"/>
			<xsl:with-param name="fieldSize" select="18"/>
		</xsl:call-template-->
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:call-template name="dateYYMMDD">
			<xsl:with-param name="dateUTC" select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">          </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">               </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">TRADESIMPLE         </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<!--Map Line Number-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="LineNumber"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template>                   
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<!-- Stock location code (ie depot) would go here -->
		<xsl:text xml:space="preserve">     </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                                                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">       </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:call-template name="padLeft">
			<xsl:with-param name="inputText">
				<xsl:choose>
					<xsl:when test="$sUoM = 'K'"><xsl:value-of select="format-number(OrderedQuantity,'0.00')"/></xsl:when>
					<xsl:otherwise> </xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="fieldSize" select="18"/>
		</xsl:call-template>
		
		
		<xsl:value-of select="$RECORD_SEPERATOR"/>


	</xsl:template>
	
	
	<!--=======================================================================================
	  Routine        : writeDeliveryInstructions
	  Description    : If there any delivery instructions write them out in chunks of 50 characters
	  Author         : Robert Cambridge
	  Alterations    : 
	 =======================================================================================-->
	
	<xsl:template name="writeDeliveryInstructions">
	
		
		
		<xsl:variable name="xmlDeliveryInstructions">
			<xsl:call-template name="xmlSplitText">
				<xsl:with-param name="inputText" select="string(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions)"/>
				<xsl:with-param name="fieldSize" select="$DELIVERY_TEXT_LENGTH"/>	
				<xsl:with-param name="acceptableBreakChars" select="$TEXT_BREAK_CHARACTERS"/>		
			</xsl:call-template>		
		</xsl:variable>
		
		<!--xsl:copy-of select="msxsl:node-set($xmlDeliveryInstructions)/TextBlock"/>	-->	
		<xsl:for-each select="msxsl:node-set($xmlDeliveryInstructions)/TextBlock">
		
			<xsl:text xml:space="preserve">CLD</xsl:text>
			<xsl:value-of select="$FIELD_SEPERATOR"/>
			
			<xsl:text xml:space="preserve">H</xsl:text>
			<xsl:value-of select="$FIELD_SEPERATOR"/>
			
			<xsl:text xml:space="preserve">    </xsl:text>
			<xsl:value-of select="$FIELD_SEPERATOR"/>
			
			<xsl:call-template name="padRight">
				<xsl:with-param name="inputText" select="."/>
				<xsl:with-param name="fieldSize" select="$DELIVERY_TEXT_LENGTH"/>
			</xsl:call-template>
			
			<xsl:value-of select="$RECORD_SEPERATOR"/>
			
		</xsl:for-each>
		
	</xsl:template>
	
	
	<!--=======================================================================================
	  Routine        : writePOTrailer
	  Description    : Write a blank trailer
	  Author         : Robert Cambridge
	  Alterations    : 
	 =======================================================================================-->
	
	<xsl:template name="writePOTrailer">
		
		<xsl:text xml:space="preserve">TRL</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                  </xsl:text>		

		<xsl:value-of select="$RECORD_SEPERATOR"/>
			
	</xsl:template>


	<!--=======================================================================================
	  Routine        : padLeft
	  Description    : left justify given text for given field width
	  Author         : Robert Cambridge
	  Alterations    : 
	 =======================================================================================-->
	
	<xsl:template name="padLeft">
		<xsl:param name="inputText"/>
		<xsl:param name="fieldSize"/>
		
		<xsl:variable name="trimmedInput" select="substring($inputText,1,$fieldSize)"/>
		
		<xsl:call-template name="repeatText">
			<xsl:with-param name="requiredSize" select="$fieldSize - string-length($trimmedInput)"/>
		</xsl:call-template>
		
		<xsl:value-of select="$trimmedInput"/>
	
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
	  Routine        : dateYYMMDD
	  Description    : Converts UTC format date to YYMMDD
	  Author         : Robert Cambridge
	  Alterations    : 
	 =======================================================================================-->
	
	<xsl:template name="dateYYMMDD">
		<xsl:param name="dateUTC"/>
		
		<xsl:value-of select="translate(substring($dateUTC,3,8),'-','')"/>
	
	</xsl:template>
	
	
	<!--=======================================================================================
	  Routine        : xmlSplitText
	  Description    : Breaks some text into a series of blocks, of no more than $fieldSize characters, in <TextBlock/> tags
	  Author         : Robert Cambridge
	  Alterations    : 
	 =======================================================================================-->
	
	<xsl:template name="xmlSplitText">
		<xsl:param name="inputText"/>
		<xsl:param name="fieldSize"/>	
		<xsl:param name="acceptableBreakChars"/>
		
		<xsl:choose>
		
			<xsl:when test="$inputText = ''"/>
			
			<xsl:when test="string-length($inputText) &lt;= $fieldSize">
				<TextBlock>
					<xsl:value-of select="$inputText"/>
				</TextBlock>
			</xsl:when>
			
			<xsl:otherwise>
			
				<xsl:variable name="firstTextBlock">
					<xsl:call-template name="getTextBlock">
						<xsl:with-param name="inputText" select="$inputText"/>
						<xsl:with-param name="candidateEndPosition" select="$fieldSize"/>	
						<xsl:with-param name="maxEndPosition" select="$fieldSize"/>
						<xsl:with-param name="acceptableBreakChars" select="$acceptableBreakChars"/>				
					</xsl:call-template>
				</xsl:variable>
				
				<TextBlock>
					<xsl:value-of select="$firstTextBlock"/>
				</TextBlock>
				
				<xsl:call-template name="xmlSplitText">
					<xsl:with-param name="inputText" select="substring-after($inputText, $firstTextBlock)"/>
					<xsl:with-param name="fieldSize" select="$fieldSize"/>	
					<xsl:with-param name="acceptableBreakChars" select="$acceptableBreakChars"/>			
				</xsl:call-template>
			
			</xsl:otherwise>
			
		</xsl:choose>
				
	</xsl:template>
	

	<!--=======================================================================================
	  Routine        : getTextBlock
	  Description    : Tries to find an acceptable character at which to truncate a given bit of 
	  							text by moving backwards from the largest acceptable string length.
	  						  Returns all text if it a suitable break point is not found
	  Author         : Robert Cambridge
	  Alterations    : 
	 =======================================================================================-->
	
	<xsl:template name="getTextBlock">
		<xsl:param name="inputText"/>
		<xsl:param name="candidateEndPosition"/>
		<xsl:param name="maxEndPosition"/>	
		<xsl:param name="acceptableBreakChars"/>	
		
		<xsl:choose>
			<xsl:when test="$candidateEndPosition = 0">
				<!-- A suitable break point has not been found so return the max amount -->
				<xsl:value-of select="substring($inputText, 1, $maxEndPosition)"/>
			</xsl:when>
			<xsl:when test="translate(substring($inputText, $candidateEndPosition, 1), $acceptableBreakChars, '') = ''">
				<!-- A suitable break point has been found -->
				<xsl:value-of select="substring($inputText, 1, $candidateEndPosition)"/>
			</xsl:when>
			
			<xsl:otherwise>
				<!--xsl:value-of select="$candidateEndPosition"/-->
				<xsl:call-template name="getTextBlock">
					<xsl:with-param name="inputText" select="$inputText"/>
					<xsl:with-param name="candidateEndPosition" select="$candidateEndPosition - 1"/>
					<xsl:with-param name="maxEndPosition" select="$maxEndPosition"/>
					<xsl:with-param name="acceptableBreakChars" select="$acceptableBreakChars"/>			
				</xsl:call-template>
			</xsl:otherwise>
			
		</xsl:choose>
						
	</xsl:template>
	
</xsl:stylesheet>
