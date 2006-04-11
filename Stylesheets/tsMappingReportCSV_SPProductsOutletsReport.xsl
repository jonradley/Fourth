<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Sodexho Products vs Outlets Report into a CSV format

 © Alternative Business Solutions Ltd., 2006.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 28/03/2006 | Steve Hewitt | Created for H575
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:script="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:value-of select="script:msFormatForCSV(/Report/ReportName)"/><xsl:text> - </xsl:text><xsl:value-of select="script:msFormatDate(/Report/ReportDate)"/>
		<xsl:text>&#xD;</xsl:text>
		<xsl:text>&#xD;</xsl:text>
		
		<!--Header Details-->
		<xsl:if test="/Report/HeaderDetails">
			<xsl:for-each select="/Report/HeaderDetails/HeaderDetail">
				<xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(Value)"/>
				<xsl:text>&#xD;</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<xsl:text>&#xD;</xsl:text>
		
		<!--Line Details-->
		<!-- Due to the nature of this report this does not follow a nice generic report structure - most values are hard coded -->
		<xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = 1])"/><xsl:text>,</xsl:text>
		<xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = 2])"/><xsl:text>,</xsl:text>
		<xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = 3])"/><xsl:text>,</xsl:text>
		<xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = 4])"/><xsl:text>,</xsl:text>
		<xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = 5])"/><xsl:text>,</xsl:text>
		<xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = 6])"/><xsl:text>,</xsl:text>
		<xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = 7])"/><xsl:text>,</xsl:text>
		
		<!-- this will produce two extra headers for every buyer on the report -->		
		<xsl:value-of select="script:headerLine(//Column[@ID=9], //Column[@ID=8])"/>
		<xsl:text>&#xD;</xsl:text>
				
		<!-- Now we can handle each line, we need to merge them together so we store all of this in the JS -->
		<xsl:for-each select="//LineDetail/Columns">
			<xsl:value-of select="script:productLine(./Column[@ID=1], ./Column[@ID=8], ./Column[@ID=6], ./Column[@ID=7], ./Column[@ID=2], ./Column[@ID=3], ./Column[@ID=4], ./Column[@ID=5])"/>
		</xsl:for-each>
	
		<!-- then we can simply write the lot in one go -->
		<xsl:value-of select="script:productLinesWrite()"/> 	
		<xsl:text>&#xD;</xsl:text>
		
		<!--Trailer Details-->
		<xsl:if test="/Report/TrailerDetails">
			<xsl:for-each select="/Report/TrailerDetails/TrailerDetail">
				<xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(Value)"/><xsl:text>&#xD;</xsl:text>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		var buyerPositions = new Array();
		var productCodes = new Array();
		var productLines = new Array();
		var productDetails = new Array();
		var productOrderedTotal = new Array();
		var productConfirmedTotal = new Array();

		/*=========================================================================================
		' Routine       	 : headerLine
		' Description 	 : Creates the report detail column headers 
		' Inputs          	 : The nodesets containing all buyer names and their memberIDs
		' Outputs       	 : None
		' Returns       	 : A string of column header csv for the report
		' Author       		 : Steve Hewitt, 28/03/2006
		' Alterations   	 : 
		'========================================================================================*/
		function headerLine(buyerNames, buyerIDs)
		{
			var headerLine = '';
			var found = 0;
			var result = '';
									
			// we start from 1 to avoid the first element which will be the column name
			for(i=1;i<buyerNames.length;i++)
			{
				found = 0;
				for (j=0;j<buyerPositions.length;j++)
				{
					if (buyerPositions[j] == buyerIDs(i).text)
						found = 1;
				}
				
				if (found == 0)
				{
					headerLine += buyerNames(i).text + ' Quantity Ordered, ' + buyerNames(i).text + ' Quantity Confirmed, ' ;
					buyerPositions[buyerPositions.length] = buyerIDs(i).text;
				}	
			}
			
			return (headerLine);
		}

		/*=========================================================================================
		' Routine       	 : productLine
		' Description 	 : Processes a report line - stores all relevant details in the module
		' Inputs          	 : All report line details
		' Outputs       	 : None
		' Returns       	 : None
		' Author       		 : Steve Hewitt, 28/03/2006
		' Alterations   	 : 
		'========================================================================================*/	
		function productLine(productCode, buyerID, ordered, confirmed, description, packSize, category, subCategory)
		{
			var productCodeIndex = -1;
			var newIndex;
			
			// does this product already exist in the product array?
			for (i=0;i<productCodes.length;i++)
			{
				if (productCodes[i] == productCode(0).text)
				{
					productCodeIndex = i;
				}
			}		
			
			if (productCodeIndex == -1)
			{
				newIndex = productCodes.length;
				productCodes[newIndex] = productCode(0).text;		
				productLines[newIndex] = '';	
				productCodeIndex = newIndex;
			}
						
			// Add the quantities into the correct position in the buyerLines array
			quantitiesStore(productCodeIndex, buyerID(0).text, ordered(0).text, confirmed(0).text)	
			
			// Add the static fields into the correct position in the productDetails array
			detailsStore(productCodeIndex, description(0).text, packSize(0).text, category(0).text, subCategory(0).text)
			
			// keep track of the ordered and confirmed totals
		return 	totalsStore(productCodeIndex, ordered(0).text, confirmed(0).text)
			
			return '';		
		}		

		/*=========================================================================================
		' Routine       	 : totalsStore
		' Description 	 : Keeps a running total of ordered/confirmed for each productCode
		' Inputs          	 : The index to use in the array plus quantities
		' Outputs       	 : None
		' Returns       	 : None
		' Author       		 : Steve Hewitt, 28/03/2006
		' Alterations   	 : 
		'========================================================================================*/
		function totalsStore(productCodeIndex, ordered, confirmed)
		{
			var currentOrderedTotal = 0;
			var currentConfirmedTotal = 0;
			
			// we keep a running total for ordered and confirmed, all other details are simply stored - they will b ethe same for the same product code
			currentOrderedTotal = productOrderedTotal[productCodeIndex];
			currentConfirmedTotal = productConfirmedTotal[productCodeIndex];
			
			// They may be empty, in which case we simply add nothing (0)
			if (ordered == '')				
				ordered = 0;
			
			if (confirmed == '')
				confirmed = 0;	
						
			if (isNaN(currentOrderedTotal))
				productOrderedTotal[productCodeIndex] = ordered;
			else
				productOrderedTotal[productCodeIndex] = parseInt(currentOrderedTotal) + parseInt(ordered);				

			if (isNaN(currentConfirmedTotal))
				productConfirmedTotal[productCodeIndex] = confirmed;
			else	
				productConfirmedTotal[productCodeIndex] = parseInt(currentConfirmedTotal) + parseInt(confirmed);
				
			return ''; 
		}
		
		/*=========================================================================================
		' Routine       	 : detailsStore
		' Description 	 : Stores product detail values in a module level array
		' Inputs          	 : The index to use in the array plus product detail values
		' Outputs       	 : None
		' Returns       	 : None
		' Author       		 : Steve Hewitt, 28/03/2006
		' Alterations   	 : 
		'========================================================================================*/			
		function detailsStore(productCodeIndex, description, packSize, category, subCategory, ordered, confirmed)
		{
			productDetails[productCodeIndex] = description + ',' + packSize +',' + category +',' + subCategory;
		}
		
		/*=========================================================================================
		' Routine       	 : quantitiesStore
		' Description 	 : Stores unit ordered/confirmed amounts in a module level array
		' Inputs          	 : The index to use in the array, the buyer identifier and the quantities ordered and confirmed
		' Outputs       	 : None
		' Returns       	 : None
		' Author       		 : Steve Hewitt, 28/03/2006
		' Alterations   	 : 
		'========================================================================================*/		
		function quantitiesStore(productCodeIndex, buyerID, ordered, confirmed)
		{
			var orderedPosition = 0;
			var confirmedPosition = 0;
			var buyerIndex = 0;
					
			// find the buyer position
			for (var i=0;i<buyerPositions.length;i++)
			{
				if (buyerPositions[i] == buyerID)
					buyerIndex = i;
			}					
			
			// The position in the productLine array will be buyerIndex * 2 (ordered) and buyerIndex * 2 + 1 (confirmed)
			orderedPosition = buyerIndex * 2;
			confirmedPosition = orderedPosition + 1;

			// get the string from the productLines array and turn it into an array
			var productQuantities = productLines[productCodeIndex].split(",");
						
			// add the quantities into their correct positions within the temporary array
			productQuantities[orderedPosition] =  ordered;
			productQuantities[confirmedPosition] =  confirmed;
			
			// convert the temp array back to a string and save to the module level array of all entries
			productLines[productCodeIndex] = productQuantities.toString();
																	
			return '';
		}

		/*=========================================================================================
		' Routine       	 : productLinesWrite
		' Description 	 : Writes out complete product lines
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : A string of all report detail lines
		' Author       		 : Steve Hewitt, 28/03/2006
		' Alterations   	 : 
		'========================================================================================*/
		function productLinesWrite()
		{	
			var result = '';		
			var productLine = new Array()
		
			for (i=0;i<productCodes.length;i++)
			{
				result += productCodes[i] + ',' + productDetails[i] + ',' + productOrderedTotal[i] + ',' + productConfirmedTotal[i] + ',' + productLines[i]; 
				result += '\n'
			}	
			return result;
		}	
	
		/*=========================================================================================
		' Routine       	 : msFormatForCSV
		' Description 	 : Formats the string for a csv file
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatForCSV(vsString)
		{
			if(vsString.length > 0)
			{
				vsString = vsString(0).text;
			}
			
			while(vsString.indexOf('"') != -1)
			{
				vsString = vsString.replace('"','¬');
			}
			while(vsString.indexOf('¬') != -1)
			{
				vsString = vsString.replace('¬','""');
			}
			
			if(vsString.indexOf('"') != -1 || vsString.indexOf(',') != -1)
			{
				vsString = '"' + vsString + '"';
			}
			
			return vsString;
				
		}
		/*=========================================================================================
		' Routine       	 : msFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in mm/dd/yyyy format
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatDate(vsDate)
		{
		
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(0,4);
			}
			else
			{
				return '';
			}
				
		}
		
		/*=========================================================================================
		' Routine       	 : mbNeedHeader
		' Description 	 : Determines whether a new header row is required
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : A Sheppard, 23/08/2004
		' Alterations   	 : 
		'========================================================================================*/
		var msPreviousGroupingValues = '-';
		function mbNeedHeader(vcolGroupingValues)
		{
		var sCurrentGroupingValues = '';	
			
			if(vcolGroupingValues.length > 0)
			{
				for(var n1 = 0; n1 <= vcolGroupingValues.length - 1; n1++)
				{
					sCurrentGroupingValues += vcolGroupingValues(n1).text + '¬';
				}
			}
			
			if(sCurrentGroupingValues != msPreviousGroupingValues)
			{
				msPreviousGroupingValues = sCurrentGroupingValues;
				msPreviousRowClass = 'listrow0'
				return true;
			}
			else
			{
				return false;
			}
		}
	]]></msxsl:script>
</xsl:stylesheet>