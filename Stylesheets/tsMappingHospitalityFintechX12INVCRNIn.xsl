<?xml version="1.0" encoding="UTF-8"?>
<!--=====================================================================================================================
 Overview

 © Fourth Hospitality Ltd, 2015.
=========================================================================================================================
 Module History
=========================================================================================================================
 Version        | 
=========================================================================================================================
 Date       | Name          |       Description of modification
=========================================================================================================================
22/01/2018	| M Dimant		| FB12239 Taken from standard X12 mapper. Applied correct formatting to UnitValue & LineValue
=========================================================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
        <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
        <!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
        <xsl:template match="*">
                <!-- Copy the node unchanged -->
                <xsl:copy>
                        <!--Then let attributes be copied/not copied/modified by other more specific templates -->
                        <xsl:apply-templates select="@*"/>
                        <!-- Then within this node, continue processing children -->
                        <xsl:apply-templates/>
                </xsl:copy>
        </xsl:template>
        <xsl:template match="/">
                <BatchRoot>
                        <xsl:apply-templates/>
                </BatchRoot>
        </xsl:template>
        <!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
        <xsl:template match="@*">
                <!--Copy the attribute unchanged-->
                <xsl:copy/>
        </xsl:template>
        <!-- END of GENERIC HANDLERS -->
        <!-- DATE CONVERSION dd/mm/yyyy to xsd:date -->
        <xsl:template match="InvoiceDate">
                <xsl:copy>
                        <xsl:call-template name="formatDate">
                                <xsl:with-param name="date" select="."/>
                        </xsl:call-template>
                </xsl:copy>
        </xsl:template>
        
        <xsl:template name="formatDate">
                <xsl:param name="date"/>
                <xsl:value-of select="concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date,7, 2))"/>
        </xsl:template>
        
        <!-- Main template to generate the skeleton of Invoice or Credit, depending on the type of the document -->
        <xsl:template match="BatchDocument">
                <BatchDocument>
                        <xsl:choose>
                                <xsl:when test="@DocumentTypeNo = 'DI'">
                                        <xsl:attribute name="DocumentTypeNo"><xsl:text>86</xsl:text></xsl:attribute>
                                        <Invoice>
                                                <xsl:apply-templates select="Invoice/TradeSimpleHeader"/>
                                                <InvoiceHeader>
                                                        <xsl:apply-templates select="Invoice/InvoiceHeader/*"/>
                                                </InvoiceHeader>
                                                <InvoiceDetail>
                                                        <xsl:for-each select="Invoice/InvoiceDetail/InvoiceLine[ProductID]">
                                                                <InvoiceLine>
                                                                        <xsl:call-template name="createLine">
                                                                                <xsl:with-param name="typeOfLine">invoice</xsl:with-param>
                                                                        </xsl:call-template>
                                                                </InvoiceLine>
                                                        </xsl:for-each>
                                                </InvoiceDetail>
                                                <InvoiceTrailer>
                                                        <xsl:apply-templates select="Invoice/InvoiceTrailer/*"/>
                                                </InvoiceTrailer>
                                        </Invoice>                                        
                                </xsl:when>
                                <xsl:when test="@DocumentTypeNo = 'CN'">
                                        <xsl:attribute name="DocumentTypeNo"><xsl:text>87</xsl:text></xsl:attribute>
                                        <CreditNote>
                                                <TradeSimpleHeader>
                                                        <xsl:apply-templates select="Invoice/TradeSimpleHeader/*"/>
                                                </TradeSimpleHeader>
                                                <CreditNoteHeader>
                                                        <xsl:apply-templates select="Invoice/InvoiceHeader/*"/>
                                                        <InvoiceReferences>
                                                                <!-- For credits, the reference to the invoice is in the CreditNoteReference tag -->
                                                                <InvoiceReference>
                                                                        <xsl:value-of select="Invoice/InvoiceHeader/InvoiceReferences/InvoiceMatchingDetails/CreditNoteReference"/>
                                                                </InvoiceReference>
                                                                <!-- as the original invoice date is missing for the credits, I am using the date of the credit -->
                                                                <InvoiceDate>
                                                                        <xsl:call-template name="formatDate">
                                                                                <xsl:with-param name="date" select="Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
                                                                        </xsl:call-template>
                                                                </InvoiceDate>
                                                        </InvoiceReferences>
                                                        <CreditNoteReferences>
                                                                <CreditNoteReference>
                                                                        <xsl:value-of select="Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
                                                                </CreditNoteReference>
                                                                <CreditNoteDate>
                                                                        <xsl:call-template name="formatDate">
                                                                                <xsl:with-param name="date" select="Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
                                                                        </xsl:call-template>
                                                                </CreditNoteDate>
                                                        </CreditNoteReferences>
                                                </CreditNoteHeader>
                                                <CreditNoteDetail>
                                                        <xsl:for-each select="Invoice/InvoiceDetail/InvoiceLine[ProductID]">
                                                                <CreditNoteLine>
                                                                        <xsl:call-template name="createLine">
                                                                                <xsl:with-param name="typeOfLine">credit</xsl:with-param>
                                                                        </xsl:call-template>
                                                                </CreditNoteLine>
                                                        </xsl:for-each>
                                                </CreditNoteDetail>
                                                <CreditNoteTrailer>
                                                        <xsl:apply-templates select="Invoice/InvoiceTrailer/*"/>
                                                </CreditNoteTrailer>
                                        </CreditNote>
                                </xsl:when>
                        </xsl:choose>
                </BatchDocument>
        </xsl:template>
                
        <!-- Create each line for invoices or credits -->
        <xsl:template name="createLine">
                <xsl:param name="typeOfLine"/>
                <PurchaseOrderReferences>
                        <PurchaseOrderReference>
                                <xsl:value-of select="../../InvoiceHeader/InvoiceReferences/InvoiceMatchingDetails/GoodsReceivedNoteReference"/>
                        </PurchaseOrderReference>
                </PurchaseOrderReferences>
                <xsl:apply-templates select="ProductID | SuppliersProductCode | BuyersProductCode | ProductDescription "/>
                <xsl:choose>
                        <xsl:when test="$typeOfLine='invoice'">
                                <InvoicedQuantity>
                                        <xsl:apply-templates select="@*"/>
                                        <xsl:value-of select="InvoicedQuantity"/>
                                </InvoicedQuantity>
                        </xsl:when>
                        <xsl:when test="$typeOfLine='credit'">
                                <CreditedQuantity>
                                        <xsl:apply-templates select="@*"/>
                                        <xsl:value-of select="translate(InvoicedQuantity, '-', '')"/>
                                </CreditedQuantity>
                        </xsl:when>
                </xsl:choose>
                <xsl:apply-templates select="UnitValueExclVAT | LineValueExclVAT"/>             
                <VATCode>
                        <xsl:text>E</xsl:text>
                </VATCode>
                <VATRate>
                        <xsl:choose>
                                <xsl:when test="VATRate != ''"><xsl:value-of select="format-number(100 * number(VATRate) div number(LineValueExclVAT), '00.00')"/></xsl:when>
                                <xsl:otherwise><xsl:text>00.00</xsl:text></xsl:otherwise>
                        </xsl:choose>
                </VATRate>
        </xsl:template>
        
        <!-- Remove the sign of amounts as credits have negative values -->
        <xsl:template match="UnitValueExclVAT | LineValueExclVAT">
                <xsl:element name="{name(.)}">
                        <xsl:value-of select="translate(format-number(. div 100, '00.00'), '-', '')"/>
                </xsl:element>
        </xsl:template>
        
        <!-- Translate the Units of measure - Actually, only one has been described to far, but maybe more in the future so, generalising a bit -->
        <xsl:template match="@UnitOfMeasure">
                <xsl:attribute name="UnitOfMeasure">
                        <xsl:choose>
                                <xsl:when test=".='CA'"><xsl:text>CS</xsl:text></xsl:when>
                                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                        </xsl:choose>
                </xsl:attribute>
        </xsl:template>

        <!-- Remove all InvoiceMatchingDetails node and contents as this has been handled manually -->
        <xsl:template match="InvoiceMatchingDetails"/>
        
        <!-- Total in the document is provided with no decimal position (x 100) so I am just dividing it back -->
        <xsl:template match="DocumentTotalInclVAT">
                <DocumentTotalInclVAT>
                        <xsl:value-of select="translate(format-number(. div 100, '00.00'), '-', '')"/>
                </DocumentTotalInclVAT>
        </xsl:template>
</xsl:stylesheet>