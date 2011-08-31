<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Laurel Transmission Notification
  into an HTML page

 © Alternative Business Solutions Ltd., 2003.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 03/06/2003 | L Beattie      | Created module.
 ******************************************************************************************
 04/07/2003 | A Sheppard | Added time to trans date + tidied up.
  ******************************************************************************************
 22/12/2003 | A Sheppard | Added suppliers name
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
		      
<xsl:output method="html"/>
<xsl:template match="LaurelNotification">
	<html>
		<style>
			TABLE
			{
			    BORDER-BOTTOM: black thin solid;
			    BORDER-LEFT: black thin solid;
			    BORDER-RIGHT: black thin solid;
			    BORDER-TOP: black thin solid;    
			    BACKGROUND-COLOR: #f7f7e5;
			    FONT-SIZE: 10pt;
			    FONT-FAMILY: Arial; 
			    COLOR: BLACK;   
			    WIDTH: 100%;
			}
			TABLE.Header
			{
			    FONT-SIZE: 14pt;
			    BACKGROUND-COLOR: #003063;
			    COLOR: white;    
			    FONT-WEIGHT: Bold;
			}	
			TABLE.Address
			{
			    BACKGROUND-COLOR: Lemonchiffon;
			}
			TABLE.Address TH
			{
			    BACKGROUND-COLOR: #003063;
			    COLOR: white;  
			}
			TABLE.Products
			{
			    BACKGROUND-COLOR: Lemonchiffon;
			    COLOR: black;  
			    BORDER-BOTTOM: none;
			    BORDER-LEFT: none;
			    BORDER-RIGHT: none;
			    BORDER-TOP: none; 
			}
			TABLE.Products TH
			{
			    BACKGROUND-COLOR: #003063;
			    COLOR: white;  
			    BORDER-BOTTOM: black thin solid;
			    BORDER-LEFT: black thin solid;
			    BORDER-RIGHT: none;
			    BORDER-TOP: none; 
			}
			TABLE.Products TH.NoBorder
			{
			    BACKGROUND-COLOR: #003063;
			    COLOR: white;  
			    BORDER-BOTTOM: none;
			    BORDER-LEFT: none;
			    BORDER-RIGHT: none;
			    BORDER-TOP: none;
			}
			TABLE.Products TD
			{
			    BORDER-BOTTOM: black thin solid;
			    BORDER-LEFT: black thin solid;
			    BORDER-RIGHT: none;
			    BORDER-TOP: none; 
			    BACKGROUND-COLOR: Lemonchiffon;
			}
			TABLE.Products TD.NoBorder
			{
			    BORDER-BOTTOM: none;
			    BORDER-LEFT: none;
			    BORDER-RIGHT: none;
			    BORDER-TOP: none;
			    BACKGROUND-COLOR: Lemonchiffon;
			}
			TABLE.Products TD.Spacer
			{
			    BORDER-TOP: none;
			    BORDER-LEFT: none;
			    BORDER-RIGHT: none;
			    BORDER-BOTTOM: none;
			    BACKGROUND-COLOR: Lemonchiffon;
			}
			TABLE.Products TD.Supplier
			{
			    BORDER-BOTTOM: none;
			    BORDER-LEFT: none;
			    BORDER-RIGHT: none;
			    BORDER-TOP: none; 
			}
			TABLE.Totals
			{
			    BACKGROUND-COLOR: Lemonchiffon;
			    COLOR: black;  
			    BORDER-BOTTOM: none;
			    BORDER-LEFT: none;
			    BORDER-RIGHT: none;
			    BORDER-TOP: none; 
			}
			TABLE.Totals TH
			{
			   BACKGROUND-COLOR: #003063;
			    COLOR: white;    
			    BORDER-BOTTOM: black thin solid;
			    BORDER-LEFT: black thin solid;
			    BORDER-RIGHT: black thin solid;
			    BORDER-TOP: black thin solid; 
			}
			TABLE.Totals TD
			{ 
			    BORDER-BOTTOM: black thin solid;
			    BORDER-LEFT: none;
			    BORDER-RIGHT: black thin solid;
			    BORDER-TOP: none; 
			}
		</style>
		<body>
			<table>	
				<tr>
					<td align="center" colspan="7">
						<table class="Header">
							<tr>	<td align="center">Laurel Transmission Notification</td></tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="right" colspan="4" width="100%">
						<table class="products" cellpadding="0" cellspacing="0" width="100%">
							<tr>	
								<td style="border-top:black thin solid"><b>Notification Type</b></td>
								<td style="border-top:black thin solid;border-right:black thin solid"><xsl:value-of select="LaurelNotificationHeader/NotificationType"/></td>
							</tr>
							<tr>	
								<td><b>Reason</b></td>
								<td style="border-right:black thin solid"><xsl:value-of select="LaurelNotificationHeader/NotificationReason"/></td>
							</tr>
							<tr>	
								<td><b>Supplier's Name</b></td>
								<td style="border-right:black thin solid"><xsl:value-of select="LaurelNotificationHeader/SuppliersName"/></td>
							</tr>
							<tr>	
								<td><b>File Generation Number</b></td>
								<td style="border-right:black thin solid"><xsl:value-of select="LaurelNotificationHeader/FileGenerationNo"/></td>
							</tr>
							<tr>
								<td><b>File Version Number</b></td>
								<td style="border-right:black thin solid"><xsl:value-of select="LaurelNotificationHeader/FileVersionNo"/></td>
							</tr>
							<tr>	
								<td><b>Supplier's Transmission Reference</b></td>
								<td style="border-right:black thin solid"><xsl:value-of select="LaurelNotificationHeader/SendersTransmissionReference"/></td>
							</tr>
							<tr>
								<td><b>Supplier's Transmission Date/Time</b></td>
								<td style="border-right:black thin solid">
									<xsl:value-of select="msxsl:format-date(LaurelNotificationHeader/SendersTransmissionDate,'dd/MM/yyyy')"/>&#xA0;<xsl:value-of select="msxsl:format-time(substring-after(LaurelNotificationHeader/SendersTransmissionDate,'T'),'HH:mm')"/>
								</td>
							</tr>
							<tr>
								<td><b>Transmission Received Date/Time</b></td>
								<td style="border-right:black thin solid">
									<xsl:value-of select="msxsl:format-date(LaurelNotificationHeader/TransmissionReceivedDate,'dd/MM/yyyy')"/>&#xA0;<xsl:value-of select="msxsl:format-time(substring-after(LaurelNotificationHeader/TransmissionReceivedDate,'T'),'HH:mm')"/>
								</td>
							</tr>
							<tr>	
								<td><b>Transmission Type</b></td>
								<td style="border-right:black thin solid"><xsl:value-of select="LaurelNotificationHeader/DocumentType"/></td>
							</tr>
						</table>
					</td>
				</tr>
				<xsl:if test="Messages">
					<tr>
						<td align="center" colspan="7">
							<table class="products" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<th style="border-top:black thin solid" width="25%">Document Reference</th>		
									<th style="border-top:black thin solid" width="25%">Document Date</th>		
									<th style="border-top:black thin solid;border-right:black thin solid" width="50%" colspan="2">
										<table class="products" cellpadding="0" cellspacing="0" width="100%">
											<tr>
												<th class="NoBorder" width="50%" colspan="2" align="left">Rejection Reasons</th>
											</tr>
											<tr>
												<th class="NoBorder" style="border-top:black thin solid" width="50%" align="left">Line</th>
												<th class="NoBorder" style="border-left:black thin solid ;border-top:black thin solid" wdth="50%" align="left">Reason</th>
											</tr>
										</table>
									</th>		
								</tr>
								<xsl:for-each select="Messages/Message">
									<tr>
										<td width="25%" valign="top"><xsl:value-of select="DocumentReference"/></td>
										<td width="25%" valign="top"><xsl:value-of select="msxsl:format-date(DocumentDate,'dd/MM/yyyy')"/></td>
										<td width="50%" style="border-right:black thin solid;border-bottom:none">
											<table class="products" cellpadding="0" cellspacing="0" width="100%">
												<xsl:for-each select="Reasons/Reason">
													<tr>
														<td style="border-bottom:black thin solid" class="NoBorder" width="50%" align="left"><xsl:value-of select="Line"/></td>
														<td style="border-left:black thin solid;border-bottom:black thin solid" class="NoBorder" width="50%" align="left"><xsl:value-of select="Description"/></td></tr>
												</xsl:for-each>
												</table>
										</td>
									</tr>
								</xsl:for-each>
							</table>
						</td>
					</tr>
				</xsl:if>
			</table>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>
