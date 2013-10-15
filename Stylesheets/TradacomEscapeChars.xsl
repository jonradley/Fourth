<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
'
' Maps BADSA 3 Purchase OrderAcks into the DMSC internal format.
' 
' © Alternative Business Solutions Ltd., 2000,2001,2002.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name            | Description of modification
'******************************************************************************************
'  05/02/2003 | J Madhar | Created 
''******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                                               xmlns:fo="http://www.w3.org/1999/XSL/Format"
                                                xmlns:TradacomEscapeChars="http://abs-Ltd.com"
                                                exclude-result-prefixes="xsl msxsl  TradacomEscapeChars"
                                                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                                               >
                                               
                                               
  <msxsl:script language="VBScript" implements-prefix="TradacomEscapeChars"><![CDATA[ 
    Function msGetReserveChars(vsSearchString)
         
         Dim sSearchString 
         Dim sSearchChars
         Dim asMyArray
         Dim i
         Dim sOutputString 


       ' sSearchString = "STX= +::RCS'DNS=++::+.?'CDT= ++++'"
        sSearchChars = "?,',+,:,.,="
        asMyArray = Split(sSearchChars, ",")        
        sOutputString = vsSearchString

       For i = 0 To UBound(asMyArray)
             'Set sOutputString = sSearchString so that result of each loop can be stored
             'The ? is placed at front of array rather than at the end,
             'so that double ? prefixes do not occur as code is looped.
   
             sOutputString = Replace(sOutputString, asMyArray(i), "?" & asMyArray(i))
       Next
     msGetReserveChars = sOutputString
   End Function
]]></msxsl:script>

                                             

</xsl:stylesheet>
