<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2010-08-02		| 3796 Created Module
**********************************************************************
				|						|
**********************************************************************
				|						|
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="ascii"/>
	
	<xsl:variable name="FIELD_PADDING" select="' '"/>
	<xsl:variable name="FIELD_SEPERATOR" select="'|'"/>
	<xsl:variable name="RECORD_SEPERATOR" select="'&#13;&#10;'"/>
	
	
	<xsl:template match="/PurchaseOrder">
	
		<xsl:call-template name="writePOHeader"/>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<xsl:call-template name="writePOLine"/>
		</xsl:for-each>
				
		<xsl:call-template name="writePOTrailer"/>	
	
	
	</xsl:template>
	
	
	<xsl:template name="writePOHeader">
	
		<xsl:text xml:space="preserve">HDR</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">29</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:call-template name="padRight">
			<xsl:with-param name="inputText" select="/PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender"/>
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
		
		<xsl:text xml:space="preserve">               </xsl:text>
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
		
		<xsl:text xml:space="preserve">                    </xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                    </xsl:text>
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
		
		<xsl:text xml:space="preserve">                    </xsl:text>
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
	
	
	<xsl:template name="writePOTrailer">
	
		<xsl:text xml:space="preserve">TRL</xsl:text>
		<xsl:value-of select="$FIELD_SEPERATOR"/>
		
		<xsl:text xml:space="preserve">                  </xsl:text>
		

		<xsl:value-of select="$RECORD_SEPERATOR"/>
		
	</xsl:template>


	<xsl:template name="padLeft">
		<xsl:param name="inputText"/>
		<xsl:param name="fieldSize"/>
		
		<xsl:variable name="trimmedInput" select="substring($inputText,1,$fieldSize)"/>
		
		<xsl:call-template name="repeatText">
			<xsl:with-param name="requiredSize" select="$fieldSize - string-length($trimmedInput)"/>
		</xsl:call-template>
		
		<xsl:value-of select="$trimmedInput"/>
	
	</xsl:template>
	
	
	<xsl:template name="padRight">
		<xsl:param name="inputText"/>
		<xsl:param name="fieldSize"/>
		
		<xsl:variable name="trimmedInput" select="substring($inputText,1,$fieldSize)"/>
		
		<xsl:value-of select="$trimmedInput"/>
		
		<xsl:call-template name="repeatText">
			<xsl:with-param name="requiredSize" select="$fieldSize - string-length($trimmedInput)"/>
		</xsl:call-template>
	
	</xsl:template>
	
	
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
	
	<xsl:template name="dateYYMMDD">
		<xsl:param name="dateUTC"/>
		
		<xsl:value-of select="translate(substring($dateUTC,3,8),'-','')"/>
	
	</xsl:template>
	
	
</xsl:stylesheet>
