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
M Emanuel	| 2012-10-17	| Mapped in Line number and Harrod Internal Site no
**********************************************************************
H Robson	| 2013-07-09	| FB 5841 Map in the Ordered UoM for Harrods only
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
		<!-- HDR:1 -->
		<xsl:text xml:space="preserve">HDR</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:2 -->
		<xsl:text xml:space="preserve">29</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:3 -->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:4 -->
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:5 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:6 -->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:with-param name="fieldSize" select="15"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:7 -->
		<xsl:call-template name="dateYYMMDD">
			<xsl:with-param name="dateUTC" select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:8 -->
		<!-- Order type = new order -->
		<xsl:text xml:space="preserve">O</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:9 -->
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:10 -->
		<xsl:call-template name="dateYYMMDD">
			<xsl:with-param name="dateUTC" select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:11 -->
		<!-- Stock location code (ie depot) would go here -->
		<xsl:text xml:space="preserve">               </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:12 -->
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:13 -->
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:14 -->
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:15 -->
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:16 -->
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:17 -->
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:18 -->
		<xsl:text xml:space="preserve">          </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:19 -->
		<xsl:text xml:space="preserve">               </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:20 -->
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:21 -->
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:22 -->
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:23 -->
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:24 -->
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:25 -->
		<xsl:text xml:space="preserve">               </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:26 -->
		<xsl:text xml:space="preserve">             </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:27 -->
		<xsl:text xml:space="preserve">              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:28 -->
		<xsl:text xml:space="preserve">TRADESIMPLE    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:29 -->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:with-param name="fieldSize" select="15"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:30 -->
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:31 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:32 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:33 -->
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:34 -->
		<xsl:text xml:space="preserve">          </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:35 -->
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:36 -->
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:37 -->
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:38 -->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="concat('ORD0',PurchaseOrderHeader/FileGenerationNumber)"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:39 -->
		<!-- Mapping Harrods internal site code -->	
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="PurchaseOrderHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:40 -->
		<xsl:text xml:space="preserve">          </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:41 -->		
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:42 -->
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:43 -->
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:44 -->
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:45 -->
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:46 -->
		<xsl:text xml:space="preserve">    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:47 -->
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:48 -->
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:49 -->
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:50 -->
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:51 -->
		<xsl:text xml:space="preserve">                         </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:52 -->
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:53 -->
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- HDR:54 -->
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
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'EA'">EA</xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CS'">PK</xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'KGM'">KG</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="customerIsHarrods">
			<xsl:choose>
				<xsl:when test="../../TradeSimpleHeader/SendersCodeForRecipient='0011489181'">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>		
		
		<!-- OLD:1 -->
		<xsl:text xml:space="preserve">OLD</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:2 -->
		<!-- used for Harrods' line number, not required for other integrations -->
		<xsl:choose>
			<xsl:when test="$customerIsHarrods = 1">
				<!-- prefix with magic number 5 as per HBF requirements -->
				<xsl:text xml:space="preserve">5</xsl:text>
				<!-- pad the line number to 3 digits so the field is always entirely filled -->
				<xsl:value-of select="format-number(LineNumber,'000')"/>
			</xsl:when>	
			<xsl:otherwise><xsl:text xml:space="preserve">    </xsl:text></xsl:otherwise>	
		</xsl:choose>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:3 -->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="ProductID/SuppliersProductCode"/>
			<xsl:with-param name="fieldSize" select="22"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:4 -->
		<xsl:call-template name="padLeft">
			<xsl:with-param name="inputText" select="format-number(OrderedQuantity,'0.00')"/>
			<xsl:with-param name="fieldSize" select="18"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:5 HARRODS Ordered UoM -->
		<xsl:choose>
			<xsl:when test="$customerIsHarrods = 1">
				<xsl:call-template name="padRight">
					<xsl:with-param name="inputText" select="$sUoM"/>
					<xsl:with-param name="fieldSize" select="15"/>
				</xsl:call-template>
			</xsl:when>	
			<xsl:otherwise><xsl:text xml:space="preserve">               </xsl:text></xsl:otherwise>	
		</xsl:choose>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:6 -->
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:7 -->
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:8 -->
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:9 -->
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:10 -->
		<xsl:call-template name="dateYYMMDD">
			<xsl:with-param name="dateUTC" select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:11 -->
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:12 -->
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:13 -->
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:14 -->
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:15 -->
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:16 -->
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:17 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:18 -->
		<xsl:text xml:space="preserve">          </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:19 -->
		<xsl:text xml:space="preserve">      </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:20 -->
		<xsl:text xml:space="preserve">                                        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:21 -->
		<xsl:text xml:space="preserve">               </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:22 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:23 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:24 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:25 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:26 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:27 -->
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:28 -->
		<xsl:text xml:space="preserve">TRADESIMPLE         </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:29 -->
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:30 -->
		<!--Map Line Number-->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="LineNumber"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template>                   
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:31 -->
		<!-- Mapping Harrod's Ship To GLN -->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template> 
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:32 -->
		<!-- Mapping Harrod's Purchasing Dept GLN -->
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
			<xsl:with-param name="fieldSize" select="20"/>
		</xsl:call-template> 
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:33 -->
		<xsl:text xml:space="preserve">        </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:34 -->
		<!-- Stock location code (ie depot) would go here -->
		<xsl:text xml:space="preserve">     </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:35 -->
		<xsl:text xml:space="preserve">                                                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:36 -->
		<xsl:text xml:space="preserve">                              </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:37 -->
		<xsl:text xml:space="preserve">       </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:38 -->
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:39 -->
		<xsl:text xml:space="preserve">                  </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		<!-- OLD:40 -->
		<xsl:call-template name="padLeft">
			<xsl:with-param name="inputText">
				<xsl:choose>
					<xsl:when test="$sUoM = 'KG'"><xsl:value-of select="format-number(OrderedQuantity,'0.00')"/></xsl:when>
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
