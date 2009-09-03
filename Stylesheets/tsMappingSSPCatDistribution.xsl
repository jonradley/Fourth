<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps catalogue distributions into a csv format for SSP.
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date      	 | Name      	 | Description of modification
******************************************************************************************
 27/10/2008 | Rave Tech	 | Created module.
******************************************************************************************
 03/09/2009 | Rave Tech	 | 3071 Handle commas in section name.
******************************************************************************************
 
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
  <xsl:output method="text"/>
  		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
			
  		<xsl:template match="/">  
  			<xsl:value-of select="script:msGetCurrentDate()"/>
  			<xsl:text>,</xsl:text>
  			<xsl:value-of select="/Catalogue/CatalogueHeader/CatalogueCode" />
  			<xsl:text>,</xsl:text>
  			<xsl:value-of select="/Catalogue/CatalogueHeader/CatalogueName"/>
  			<xsl:text>,</xsl:text>
  			<xsl:value-of select="/Catalogue/TradeSimpleHeader/RecipientsCodeForSender"/>
  			<xsl:text>,</xsl:text>
  			<xsl:value-of select="/Catalogue/CatalogueHeader/ValidFrom"/>
  			<xsl:value-of select="$NewLine"/>
  			<xsl:text>Product Code</xsl:text>
  			<xsl:text>,</xsl:text>  			
  			<xsl:text>Long Description</xsl:text>
  			<xsl:text>,</xsl:text>
  			<xsl:text>Pack Size</xsl:text>
  			<xsl:text>,</xsl:text>
  			<xsl:text>Order Price</xsl:text>
  			<xsl:text>,</xsl:text>
  			<xsl:text>Category</xsl:text>
  			<xsl:text>,</xsl:text>
  			<xsl:text>Sub Category</xsl:text>
  			<xsl:text>,</xsl:text>
  			<xsl:text>Order UOM</xsl:text>
  			<xsl:text>,</xsl:text>
  			<xsl:text>Invoice Price</xsl:text>
  			<xsl:text>,</xsl:text>
  			<xsl:text>Invoice UOM</xsl:text>
  			<xsl:text>,</xsl:text>
  			<xsl:text>Miscellaneous Attributes</xsl:text>  			
  			<xsl:value-of select="$NewLine"/>  						 				
	            <xsl:apply-templates select="/Catalogue/Products/Product">
	              <xsl:sort select="/Product/ProductID/SuppliersProductCode"/>                      
	            </xsl:apply-templates>                    
  		</xsl:template>
  		
		<xsl:template match="Product">
			<xsl:value-of select="./ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="./ProductDescription"/>
			<xsl:text>,</xsl:text>  
			<xsl:value-of select="./PackSize"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="./UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>  
			<xsl:variable name="SectionID"><xsl:value-of select="SectionID"/></xsl:variable>
			<xsl:choose>
				<xsl:when test="//Section[@ID=$SectionID]/../@ID">
						<xsl:choose>
							<xsl:when test="contains(//Section[@ID=$SectionID]/../@Name,',')">
									<xsl:text>"</xsl:text><xsl:value-of select="//Section[@ID=$SectionID]/../@Name"/><xsl:text>"</xsl:text>
							</xsl:when>
							<xsl:otherwise>
									<xsl:value-of select="//Section[@ID=$SectionID]/../@Name"/>
							</xsl:otherwise>
						</xsl:choose>
					       <xsl:text>,</xsl:text>
						<xsl:choose>
							<xsl:when test="contains(//Section[@ID=$SectionID]/@Name,',')">
									<xsl:text>"</xsl:text><xsl:value-of select="//Section[@ID=$SectionID]/@Name"/><xsl:text>"</xsl:text>
							</xsl:when>
							<xsl:otherwise>
									<xsl:value-of select="//Section[@ID=$SectionID]/@Name"/>
							</xsl:otherwise>
						</xsl:choose>					
				</xsl:when>
				<xsl:otherwise>	
						<xsl:choose>
							<xsl:when test="contains(//Section[@ID=$SectionID]/@Name,',')">
									<xsl:text>"</xsl:text><xsl:value-of select="//Section[@ID=$SectionID]/@Name"/><xsl:text>"</xsl:text>
							</xsl:when>
							<xsl:otherwise>
									<xsl:value-of select="//Section[@ID=$SectionID]/@Name"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>,</xsl:text>						 					
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>		
			<xsl:value-of select="./UOM"/>
			<xsl:text>,</xsl:text>	  
			 <xsl:choose>
			       <xsl:when test="./ExtraData/Item/@Name='InvoicePrice'"> <xsl:value-of select="./ExtraData/Item[@Name='InvoicePrice']"/></xsl:when>          
			     </xsl:choose>
			 <xsl:text>,</xsl:text>	  
			 <xsl:choose>
			       <xsl:when test="./ExtraData/Item/@Name='InvoicePriceUOM'"> <xsl:value-of select="./ExtraData/Item[@Name='InvoicePriceUOM']"/></xsl:when>          
			  </xsl:choose>
			  <xsl:text>,</xsl:text>			
			   <xsl:variable name="ProductAttributes" >
				   <xsl:for-each select="./ExtraData/Item">			
				  	  <xsl:if test="(@Name[.!='InvoicePrice']) and (@Name[.!='InvoicePriceUOM'])"> 		  		 
				  		<xsl:value-of select="concat(concat(@Name,'=',node()),';')" /> 
				  	</xsl:if>   	 
				   </xsl:for-each>
			   </xsl:variable>
			   <xsl:value-of select="substring($ProductAttributes,1,string-length($ProductAttributes)-1)"/>
			 <xsl:value-of select="$NewLine"/>		
		</xsl:template>
		
  <msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 

		/*=========================================================================================
		' Routine       	 : msGetCurrentDate
		' Description 	 : Gets the current date in the format "dd/mm/yy"
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 12/07/2007
		' Alterations   	 : 
		'========================================================================================*/
		function msGetCurrentDate()
		{
			var dtDate = new Date();
			var sReturn = '';
			
			if(dtDate.getDate() < 10)
			{
				sReturn += '0';
			}
			sReturn += dtDate.getDate() + '/';
	
			if(dtDate.getMonth() < 9)
			{
				sReturn += '0';
			}
			sReturn += (dtDate.getMonth() + 1) + '/';
			var sTemp = dtDate.getYear() + ' ';
			sReturn += sTemp.substr(2,2)

			return sReturn;
		}
	]]></msxsl:script>

</xsl:stylesheet>
