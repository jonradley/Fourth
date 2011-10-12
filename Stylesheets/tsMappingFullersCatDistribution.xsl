<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="html"/>
  <xsl:template match="/">
    <html>
      <head>
        <title>Catalogue Export Report</title>
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
        <h1>Catalogue Export Report</h1>

        <table>
          <thead>
            <tr>
              <th colspan="2">Catalogue Details</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Catalogue Description:</td>
              <td>
			<xsl:value-of select="/PriceCatalog/PriceCatHeader/ListOfDescription/Description"/>
              </td>
            </tr>
            <tr>
              <td>Catalogue Reference Code:</td>
              <td>
                <xsl:value-of select="/PriceCatalog/PriceCatHeader/CatHdrRef/PriceCat/RefNum"/>
              </td>
            </tr>
            <tr>
              <td>Document Date:</td>
              <td>
                <xsl:choose>
                  <xsl:when test="/PriceCatalog/PriceCatHeader/DocumentDate">
                    <xsl:value-of select="/PriceCatalog/PriceCatHeader/DocumentDate"/>
                  </xsl:when>
                  <xsl:when test="/PriceCatalog/PriceCatHeader/ValidStartDate">
                    <xsl:value-of select="/PriceCatalog/PriceCatHeader/ValidStartDate"/>
                  </xsl:when>
                  <xsl:otherwise>None provided.</xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
            <tr>
              <td>Start Date:</td>
              <td>
                <xsl:choose>
                  <xsl:when test="/PriceCatalog/PriceCatHeader/ValidStartDate">
                    <xsl:value-of select="/PriceCatalog/PriceCatHeader/ValidStartDate"/>
                  </xsl:when>
                  <xsl:when test="/PriceCatalog/PriceCatHeader/DocumentDate">
                    <xsl:value-of select="/PriceCatalog/PriceCatHeader/DocumentDate"/>
                  </xsl:when>
                  <xsl:otherwise>None provided.</xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
            <tr>
              <td>Catalogue Type:</td>
              <td>
                <xsl:value-of select="/PriceCatalog/@CatType"/>
              </td>
            </tr>
          </tbody>
        </table>

        <table>
          <thead>
            <tr>
              <th colspan="9">Products</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>Supplier Product Code</th>
              <th>Product Description</th>
              <th>Pack Size</th>
              <th>Order UOM</th>
              <th>Order Unit Price</th>
              <th>Category</th>
              <th>Sub-Category</th>
              <th>In Aztec?</th>
              <th>Not For Order</th>
            </tr>
            <xsl:apply-templates select="/PriceCatalog/ListOfPriceCatAction/PriceCatAction">
              <xsl:sort select="PriceCatDetail/PartNum/PartID"/>
            </xsl:apply-templates>
          </tbody>
        </table>
        <h3>
          Number Of Products: <xsl:value-of select="count(/PriceCatalog/ListOfPriceCatAction/PriceCatAction)"/>
        </h3>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="PriceCatAction">
    <tr>
      <td>
        <xsl:value-of select="./PriceCatDetail/PartNum/PartID"/>
      </td>
      <td>
        <xsl:value-of select="./PriceCatDetail/ListOfDescription/Description"/>
      </td>
      <td>
        <xsl:value-of select="./PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='PackSize']"/>
      </td>
      <td>
        <xsl:value-of select="./PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='UOM']"/>
      </td>
      <td>
        <xsl:value-of select="./PriceCatDetail/ListOfPrice/Price/UnitPrice"/>
      </td>
      <td>
        <xsl:value-of select="./PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group']"/>
      </td>
      <td>
        <xsl:value-of select="./PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='SubGroup']"/>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="./PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='InAztec']='1'">Yes</xsl:when>
          <xsl:otherwise>No</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="./PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='NotForOrder']='1'">Yes</xsl:when>
          <xsl:otherwise>No</xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
