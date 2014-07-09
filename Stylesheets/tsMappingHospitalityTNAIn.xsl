<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview  
==========================================================================================
 01/07/2014	| J Miguel		|	FB: 7872 Created
========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:user="http://www.abs-ltd.com/dummynamespaces/javascript" 
				xmlns:msxml="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:template match="/TimeAndAttendance">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<TimeAndAttendance>
							<xsl:apply-templates select="*"/>
						</TimeAndAttendance>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	<!-- tiny trick to get rid of extra 00:00 pading in the dates -->
	<xsl:template match="CheckIn | CheckOut">
		<!-- Only process entries not modified by the user as this would cause the system to show repeated entries -->
		<xsl:if test="@AdjustmentType = '0' or @AdjustmentType = '2'">
			<xsl:element name="{local-name(.)}">
				<xsl:value-of select="concat(user:convertToYYYYMMDD(translate(substring(string(@Date), 0, 11), '-', '/')), ' ', string(@Time))"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- Use the time stamp of the transalation (as the input does not have a proper value here -->
	<xsl:template match="TimeAndAttendanceHeader">
		<TimeAndAttendanceHeader>
			<xsl:apply-templates/>
			<DateTime>
				<xsl:value-of select="user:getTimeStamp()"/>
			</DateTime>
		</TimeAndAttendanceHeader>
	</xsl:template>
	<!-- copy template -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<msxml:script language="Javascript" implements-prefix="user">
<![CDATA[
function right (str, count)
{
	return str.substring(str.length - count, str.length);
}

function pad2 (str)
{
	return right('0' + str, 2);
}

function getTimeStamp()
{
	var now = new Date();
	return pad2(now.getDate()) + '/' + pad2(1 + now.getMonth()) + '/' + now.getFullYear() 
			+ ' ' + pad2(now.getHours()) + ':' + pad2(now.getMinutes()) + ':' + pad2(now.getSeconds());
}

function convertToYYYYMMDD (str)
{
	try
	{
		if (str == null) return '';
		
		var dateParts = str.split('/');
		
		if (dateParts.length != 3) return str;
	
		var year;
		var month;
		var day;
		
		if (dateParts[0].length == 4)
		{
			year = parseInt(dateParts[0]);
			month = parseInt(dateParts[1]);
			day = parseInt(dateParts[2]);
		}
		else
		{
			year = parseInt(dateParts[2]);
			month = parseInt(dateParts[1]);
			day = parseInt(dateParts[0]);	
		}
		
		return year + '/' + pad2(month) + '/' + pad2(day);
	}
	catch (e)
	{
		return e.message;
	}
}
]]></msxml:script>
</xsl:stylesheet>
