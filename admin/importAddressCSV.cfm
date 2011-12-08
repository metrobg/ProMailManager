<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 8 2003
Date Last Modified:        April 26, 2003
=====================================================================
 -->
<cfparam name="ATTRIBUTES.ImportFilePath" default="#globals.importFilePath#">
<cfparam name="ATTRIBUTES.ImportFileName" default="AddressTemplate.csv">
<cfparam name="ATTRIBUTES.ColumnNames" default="ListID, EmailAddress, FirstName, LastName, City, State, ZipCode, Country, PhoneNumber, CellNumber">
<cfparam name="ATTRIBUTES.DSN" default="#DSN#">
<cfparam name="ATTRIBUTES.ImportIntoTable" default="email_addresses">
<cfparam name="ATTRIBUTES.ListID" default="1">

<cfscript>
	newLine = chr(10)&chr(13);
	delimChar = ",";
</cfscript>

<cftry>
	
	<cffile action = "read" 
		file = "#ATTRIBUTES.ImportFilePath#\#ATTRIBUTES.ImportFileName#" 
		variable = "vAddressImportList">

	<cfset vImportArray = ArrayNew(2)>
	<cfset i = 1>
	
	<cfloop index = "lineIndex"
   			list = "#vAddressImportList#"
   			delimiters = "#newLine#">
	  
	  <cfset j = 1>
	  <cfset lineIndex=replace(lineIndex,",",",-","ALL")> <!--- must account for bug in CF ignoring empty list elements --->
	  <cfset insertList = "#ATTRIBUTES.ListID#">
	 <!--- Insert each line into database --->
	 
	  <cfquery name="insert" datasource="#ATTRIBUTES.DSN#">
	  	INSERT INTO #ATTRIBUTES.ImportIntoTable# (#ATTRIBUTES.ColumnNames#) 
		VALUES (#ATTRIBUTES.ListID#
	  <cfloop index = "columnIndex" list = "#lineIndex#">
		  <cfif Left(columnIndex, 1) eq "-">
			<cfset columnIndexLen = Len(columnIndex)>
			<cfif columnIndexLen gt 1>
				<cfset columnIndex = Right(columnIndex,(columnIndexLen - 1))>
			<cfelse>
				<cfset columnIndex = "">
			</cfif>
		  </cfif>
			, '#columnIndex#'
		<cfset insertList =  #insertList#&", '#columnIndex#'">
		<cfset vImportArray[i][j] = #columnIndex#> <!--- Array provided also in case you wish to cfdump to view elements --->
		<cfset j = j + 1>
		
	  </cfloop>	    	
	  )
	  </cfquery>
		
		<cfset i = i + 1>
		
	</cfloop>

<!--- 
 ** To output an array of he imported elements uncomment this cfoutput section ** 
<cfoutput>
	<cfdump var="#vImportArray#">
</cfoutput> 
--->

	<cfcatch type="any">
		Sorry there has been an error importing you CSV file, please ensure it is a valid CSV
		file. Please DO NOT save it with quotes surrounding each field, save a default comma separated format only.
		If using Microsoft Excel save with defualt settings only and file should be OK (you may try uploading it again to server as it may be corrupted)
	</cfcatch>
	
</cftry>
