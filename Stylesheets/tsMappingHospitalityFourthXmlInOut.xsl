<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

 In/Out bound multi document XML mapper
 
All document types supported as single and batch for IN.
All document types supported as single for OUT.
******************************************************************************************
 Module History
******************************************************************************************
 Date        		 | Name         	| Description of modification
******************************************************************************************
  03/08/2015 | J Miguel			| Created
******************************************************************************************
  18/01/2016 | J Miguel			| FB10759 - Imporvements
******************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>

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

	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	
	<!-- Inbound root rule -->
	<xsl:template match="/FourthFile[@Direction='Inbound']">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<xsl:apply-templates/>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	
	<!-- Inbound rule - Remove collections -->
	<xsl:template match="/FourthFile[@Direction='Inbound']/PurchaseOrders
					   | /FourthFile[@Direction='Inbound']/PurchaseOrderAcknowledgements 
					   | /FourthFile[@Direction='Inbound']/PurchaseOrderConfirmations
					   | /FourthFile[@Direction='Inbound']/DeliveryNotes
					   | /FourthFile[@Direction='Inbound']/GoodsReceivedNotes
					   | /FourthFile[@Direction='Inbound']/Invoices
					   | /FourthFile[@Direction='Inbound']/CreditNotes">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Inbound rule - Add Batch document to each type -->
	<xsl:template match="/FourthFile[@Direction='Inbound']/PurchaseOrders/PurchaseOrder">
		<BatchDocument DocumentTypeNo="2">
			<PurchaseOrder>
				<xsl:apply-templates/>
			</PurchaseOrder>
		</BatchDocument>
	</xsl:template>
	
	<xsl:template match="/FourthFile[@Direction='Inbound']/PurchaseOrderAcknowledgements/PurchaseOrderAcknowledgement">
		<BatchDocument DocumentTypeNo="84">
			<PurchaseOrderAcknowledgement>
				<xsl:apply-templates/>
			</PurchaseOrderAcknowledgement>
		</BatchDocument>
	</xsl:template>

	<xsl:template match="/FourthFile[@Direction='Inbound']/PurchaseOrderConfirmations/PurchaseOrderConfirmation">
		<BatchDocument DocumentTypeNo="3">
			<PurchaseOrderConfirmation>
				<xsl:apply-templates/>
			</PurchaseOrderConfirmation>
		</BatchDocument>
	</xsl:template>
	
	<xsl:template match="/FourthFile[@Direction='Inbound']/DeliveryNotes/DeliveryNote">
		<BatchDocument DocumentTypeNo="7">
			<DeliveryNote>
				<xsl:apply-templates/>
			</DeliveryNote>
		</BatchDocument>
	</xsl:template>

	<xsl:template match="/FourthFile[@Direction='Inbound']/GoodsReceivedNotes/GoodsReceivedNote">
		<BatchDocument DocumentTypeNo="85">
			<GoodsReceivedNote>
				<xsl:apply-templates/>
			</GoodsReceivedNote>
		</BatchDocument>
	</xsl:template>
	
	<xsl:template match="/FourthFile[@Direction='Inbound']/Invoices/Invoice">
		<BatchDocument DocumentTypeNo="86">
			<Invoice>
				<xsl:apply-templates/>
			</Invoice>
		</BatchDocument>
	</xsl:template>

	<xsl:template match="/FourthFile[@Direction='Inbound']/CreditNotes/CreditNote">
		<BatchDocument DocumentTypeNo="86">
			<Invoice>
				<xsl:apply-templates/>
			</Invoice>
		</BatchDocument>
	</xsl:template>	

	<!-- Outbound rules - remove all possible containers -->
	<xsl:template match="BatchRoot | Batch | BatchDocuments | BatchDocument">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Outbound rules - add the root File tag for outbound -->
	<xsl:template match="PurchaseOrder">
		<FourthFile Direction="Outbound">
			<PurchaseOrders>
				<PurchaseOrder>
					<xsl:apply-templates/>
				</PurchaseOrder>
			</PurchaseOrders>
		</FourthFile>
	</xsl:template>

	<xsl:template match="PurchaseOrderAcknowledgement">
		<FourthFile Direction="Outbound">
			<PurchaseOrderAcknowledgements>
				<PurchaseOrderAcknowledgement>
					<xsl:apply-templates/>
				</PurchaseOrderAcknowledgement>
			</PurchaseOrderAcknowledgements>
		</FourthFile>
	</xsl:template>

	<xsl:template match="PurchaseOrderConfirmation">
		<FourthFile Direction="Outbound">
			<PurchaseOrderConfirmations>
				<PurchaseOrderConfirmation>
					<xsl:apply-templates/>
				</PurchaseOrderConfirmation>
			</PurchaseOrderConfirmations>
		</FourthFile>
	</xsl:template>
	
	<xsl:template match="DeliveryNote">
		<FourthFile Direction="Outbound">
			<DeliveryNotes>
				<DeliveryNote>
					<xsl:apply-templates/>
				</DeliveryNote>
			</DeliveryNotes>
		</FourthFile>
	</xsl:template>
	
	<xsl:template match="GoodsReceivedNote">
		<FourthFile Direction="Outbound">
			<GoodsReceivedNotes>
				<GoodsReceivedNote>
					<xsl:apply-templates/>
				</GoodsReceivedNote>
			</GoodsReceivedNotes>
		</FourthFile>
	</xsl:template>	

	<xsl:template match="Invoice">
		<FourthFile Direction="Outbound">
			<Invoices>
				<Invoice>
					<xsl:apply-templates/>
				</Invoice>
			</Invoices>
		</FourthFile>
	</xsl:template>	
	
	<xsl:template match="CreditNote">
		<FourthFile Direction="Outbound">
			<CreditNotes>
				<CreditNote>
					<xsl:apply-templates/>
				</CreditNote>
			</CreditNotes>
		</FourthFile>
	</xsl:template>		
</xsl:stylesheet>