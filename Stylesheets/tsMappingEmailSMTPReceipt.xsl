<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
Formats a receipt as plain text

 © Alternative Business Solutions Ltd., 2005.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date			| Name 				 | Description of modification
==========================================================================================
03/06/2005	| Robert Cambridge| Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
22/04/2009	| Robert Cambridge| FB2815 port of King:trunk/Stylesheets/tsMapping_Outbound_Text_Receipt.xsl 
											 to Hopsitality (removed translation language strings)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 					    |
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                              exclude-result-prefixes="msxsl">
    <xsl:output method="text"/>
    
    
    
     <xsl:template match="/">
    
        <!--The Message-->
        <xsl:text>The Message</xsl:text>
        <xsl:text>:- </xsl:text><xsl:text>&#13;&#10;</xsl:text>
        
        <!--From -->
        <xsl:text>From</xsl:text>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/From"/><xsl:text>&#13;&#10;</xsl:text>
        
        <!--Subject  -->
        <xsl:text>Subject</xsl:text>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/Subject"/><xsl:text>&#13;&#10;</xsl:text>
        
        <!--Size-->
        <xsl:text>Size</xsl:text>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/Size"/><xsl:text>&#13;&#10;</xsl:text>
        
        <!--Sent-->
        <xsl:text>Sent</xsl:text>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/DateTimeSent"/><xsl:text>&#13;&#10;</xsl:text>
        
        <!--Received -->
        <xsl:text>Received</xsl:text>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/DateTimeReceived"/><xsl:text>&#13;&#10;</xsl:text>
        
        <xsl:if test="count(/Receipt/Details/Attachments/Attachment) &gt; 0">
            
            <!--With -->
            <xsl:text>With</xsl:text>
            <xsl:text> </xsl:text>
            <xsl:value-of select="count(/Receipt/Details/Attachments/Attachment)"/>
            <xsl:text> </xsl:text>
            
            <!-- attachment(s)-->
            <xsl:text>attachment(s)</xsl:text>
            <xsl:text> [</xsl:text>
            
            <xsl:for-each select="/Receipt/Details/Attachments/Attachment">
                 <xsl:if test="position() != 1">, </xsl:if>
                 <xsl:value-of select="."/>
            </xsl:for-each>
            
            <xsl:text>]&#13;&#10;</xsl:text>
        
        </xsl:if>
                
        <xsl:choose>
            <xsl:when test="translate(/Receipt/Details/ReceivedSuccessfully,'TRUE','true')= 'true'">
                <xsl:text>Was received successfully.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Was not received successfully.</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    
    </xsl:template>

</xsl:stylesheet>
