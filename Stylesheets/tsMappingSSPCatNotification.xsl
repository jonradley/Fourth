<?xml version="1.0" encoding="utf-8"?>
<!--
******************************************************************************************
 Overview

 Maps Notification into a html format for SSP.
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date      	 | Name      	 | Description of modification
******************************************************************************************
 28/10/2008 | Rave Tech	 | Created module.
******************************************************************************************
 
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="html"/>
  <xsl:template match="/">
    <html>
      <head>
        <title>Catalogue Notification</title>
        <style type="text/css">
          <![CDATA[
            BODY
            {
              FONT-SIZE: 8pt;
              COLOR: black;
              FONT-FAMILY: Arial;
              BACKGROUND-COLOR: white;
              TEXT-DECORATION: none
            }
            TH
            {
              FONT-WEIGHT: bold;
              FONT-SIZE: 8pt;
              PADDING-BOTTOM: 2pt;
              COLOR: white;
              PADDING-TOP: 2pt;
              FONT-FAMILY: Arial;
              BACKGROUND-COLOR: #c41230
            }
            THEAD TH
            {
              BORDER-RIGHT: black thin solid;
              BORDER-TOP: black thin solid;
              PADDING-BOTTOM: 0pt;
              BORDER-LEFT: black thin solid;
              COLOR: white;
              PADDING-TOP: 0pt;
              BORDER-BOTTOM: black thin solid;
              BACKGROUND-COLOR: black
            }
            TABLE
            {
              MARGIN-BOTTOM: 30px;
            }
            TD
            {
              FONT-SIZE: 8pt
            }
          ]]>
        </style>
      </head>
      <body>		
        <table>                  
          <tbody>          	
            <tr>
              <th>Catalogue Version Status</th>
              <td>
			<xsl:value-of select="/CatalogueApprovalNotification/HeaderDetails/Status"/>
              </td>
            </tr>
            <tr>
              <th>Catalogue loaded</th>
              <td>
                <xsl:value-of select="/CatalogueApprovalNotification/HeaderDetails/CreatedDate"/>
              </td>
            </tr>
            <tr>
              <th>Supplier Name</th>
              <td>               
                    <xsl:value-of select="/CatalogueApprovalNotification/HeaderDetails/SupplierName"/>                  
              </td>
            </tr>
            <tr>
              <th>Catalogue Reference</th>
              <td>             
                    <xsl:value-of select="/CatalogueApprovalNotification/HeaderDetails/CatalogueReference"/>                  
              </td>
            </tr>
            <tr>
              <th>Catalogue Name</th>
              <td>
                <xsl:value-of select="/CatalogueApprovalNotification/HeaderDetails/CatalogueName"/>
              </td>
            </tr>
                <tr>
              <th>Effective Date</th>
              <td>
                <xsl:value-of select="/CatalogueApprovalNotification/HeaderDetails/ValidFrom"/>
              </td>
            </tr>
                <tr>
              <th>End date</th>
              <td>
                <xsl:value-of select="/CatalogueApprovalNotification/HeaderDetails/ValidTo"/>
              </td>
            </tr>
             <tr>
              <th>Number of products</th>
              <td>
                <xsl:value-of select="/CatalogueApprovalNotification/HeaderDetails/ProductCount"/>
              </td>
            </tr>
            <xsl:if test="/CatalogueApprovalNotification/HeaderDetails/Status='Rejected'">
	              <tr>
		              <th>Rejection Reason</th>
		              <td>
		                <xsl:value-of select="/CatalogueApprovalNotification/HeaderDetails/RejectionReason"/>
		              </td>
	            	</tr>
            </xsl:if>
          </tbody>
        </table>
        <xsl:if test="/CatalogueApprovalNotification/HeaderDetails/Status !='Rejected'">	  
	        <table>
	          <thead>
	            <tr>
	              <th colspan="9">New Products</th>
	            </tr>
	          </thead>
	          <tbody>
	            <tr>
	              <th>Code</th>
	              <th>Description</th>
	              <th>Pack</th>
	              <th>Order Price</th>
	              <th>Order UOM</th>
	              <th>Invoice Price</th>
	              <th>Invoice UOM</th>
	              <th>Category</th>
	              <th>Sub-category</th>
	            </tr>
	            <xsl:apply-templates select="/CatalogueApprovalNotification/NewProducts/NewProduct">
	              <xsl:sort select="./SuppliersProductCode"/>
	            </xsl:apply-templates>
	          </tbody>
	        </table>
	        <table>
	          <thead>
	            <tr>
	              <th colspan="9">Deleted Products</th>
	            </tr>
	          </thead>
	          <tbody>
	            <tr>
	              <th>Code</th>
	              <th>Description</th>
	              <th>Pack</th>
	              <th>Order Price</th>
	              <th>Order UOM</th>
	              <th>Invoice Price</th>
	              <th>Invoice UOM</th>
	              <th>Category</th>
	              <th>Sub-category</th>
	            </tr>
	            <xsl:apply-templates select="/CatalogueApprovalNotification/OldProducts/OldProduct">
	              <xsl:sort select="./SuppliersProductCode"/>
	            </xsl:apply-templates>
	          </tbody>
	        </table>
         </xsl:if>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="NewProduct">
    <tr>
      <td>
        <xsl:value-of select="./SuppliersProductCode"/>
      </td>
      <td>
        <xsl:value-of select="./ProductDescription"/>
      </td>
      <td>
        <xsl:value-of select="./PackSize"/>
      </td>
      <td>
        <xsl:value-of select="./UnitValueExclVAT"/>
      </td>
      <td>
        <xsl:value-of select="./UOM"/>
      </td>
      <td>
        <xsl:value-of select="./InvoiceUnitValueExclVAT"/>
      </td>
      <td>
        <xsl:value-of select="./InvoiceUOM"/>
      </td>
      <td>
        <xsl:value-of select="./Category"/>
      </td>
      <td>
       <xsl:value-of select="./SubCategory"/>
      </td>
    </tr>
  </xsl:template>
  
<xsl:template match="OldProduct">
    <tr>
      <td>
        <xsl:value-of select="./SuppliersProductCode"/>
      </td>
      <td>
        <xsl:value-of select="./ProductDescription"/>
      </td>
      <td>
        <xsl:value-of select="./PackSize"/>
      </td>
      <td>
        <xsl:value-of select="./UnitValueExclVAT"/>
      </td>
      <td>
        <xsl:value-of select="./UOM"/>
      </td>
      <td>
        <xsl:value-of select="./InvoiceUnitValueExclVAT"/>
      </td>
      <td>
        <xsl:value-of select="./InvoiceUOM"/>
      </td>
      <td>
        <xsl:value-of select="./Category"/>
      </td>
      <td>
       <xsl:value-of select="./SubCategory"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
