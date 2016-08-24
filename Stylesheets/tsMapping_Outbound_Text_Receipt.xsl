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
				| 					    |
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                              exclude-result-prefixes="msxsl">
    <xsl:output method="text"/>
    
    <xsl:param name="vsDefaultTranslationPath" select="'C:/Data/TS Implementations/King/trunk/Translations/English/Language Strings.xml'"/>
    <xsl:param name="vsOverrideTranslationPath" select="''"/>  
        
    
    <xsl:include href="tsLanguageTranslationInclude.xsl"/>    
                   
    <!-- Text for each lang string ID is held here -->
    <xsl:variable name="mobjTrans">
        <xsl:call-template name="mobjCreateTranslationTable">
            <xsl:with-param name="vsDefaultTextPath" select="$vsDefaultTranslationPath"/>
            <xsl:with-param name="vsTranslationPath" select="$vsOverrideTranslationPath"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:template match="/">
    
        <!--The Message-->
        <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='216']"/>
        <xsl:text>:- </xsl:text><xsl:text>&#13;&#10;</xsl:text>
        
        <!--From -->
        <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='21']"/>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/From"/><xsl:text>&#13;&#10;</xsl:text>
        
        <!--Subject  -->
        <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='98']"/>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/Subject"/><xsl:text>&#13;&#10;</xsl:text>
        
        <!--Size-->
        <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='217']"/>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/Size"/><xsl:text>&#13;&#10;</xsl:text>
        
        <!--Sent-->
        <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='218']"/>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/DateTimeSent"/><xsl:text>&#13;&#10;</xsl:text>
        
        <!--Received -->
        <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='219']"/>
        <xsl:text>: </xsl:text><xsl:value-of select="/Receipt/Details/DateTimeReceived"/><xsl:text>&#13;&#10;</xsl:text>
        
        <xsl:if test="count(/Receipt/Details/Attachments/Attachment) &gt; 0">
            
            <!--With -->
            <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='220']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="count(/Receipt/Details/Attachments/Attachment)"/>
            <xsl:text> </xsl:text>
            
            <!-- attachment(s)-->
            <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='221']"/>
            <xsl:text> [</xsl:text>
            
            <xsl:for-each select="/Receipt/Details/Attachments/Attachment">
                 <xsl:if test="position() != 1">, </xsl:if>
                 <xsl:value-of select="."/>
            </xsl:for-each>
            
            <xsl:text>]&#13;&#10;</xsl:text>
        
        </xsl:if>
                
        <xsl:choose>
            <xsl:when test="translate(/Receipt/Details/ReceivedSuccessfully,'TRUE','true')= 'true'">
                <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='222']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="msxsl:node-set($mobjTrans)/LanguageString[@ID='223']"/>
            </xsl:otherwise>
        </xsl:choose>
    
    </xsl:template>

</xsl:stylesheet>
