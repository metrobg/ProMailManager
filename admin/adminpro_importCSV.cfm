<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 8 2003
Date Last Modified:        December 24, 2003
=====================================================================
 -->
<cfscript>
	currPath = ExpandPath("*.*");
	tempCurrDir = GetDirectoryFromPath(currPath) & "attachments";
	if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { trailingSlash = '\'; }
	else { trailingSlash = '/'; }
</cfscript>
<cfparam name="ATTRIBUTES.ImportFilePath" default="">
<cfparam name="ATTRIBUTES.ImportFileName" default="AddressTemplate.csv">
<cfparam name="ATTRIBUTES.ColumnNames" default="ListID, EmailAddress, FirstName, LastName, City, State, ZipCode, Country, PhoneNumber, CellNumber">
<cfparam name="ATTRIBUTES.ColumnTypes" default="integer, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar">
	<!--- Valid options [integer | varchar] --->
<cfparam name="ATTRIBUTES.DSN" default="">
<cfparam name="ATTRIBUTES.ImportIntoTable" default="email_addresses">
<cfparam name="ATTRIBUTES.ListID" default="1">

<cfscript>
	newLine = chr(10)&chr(13);
	delimChar = ",";
	vListLength = ListLen(ATTRIBUTES.ColumnNames);
</cfscript>


	<!--- Must check required attributes have been passed and that they are valid --->
	<cfif Len(ATTRIBUTES.ImportFilePath) lt 4>
		<cfthrow errorcode="1" detail="adminpro_importCSV error code 1" message="You must specify a valid full Path on your server to the file being imported">
	<cfelseif Len(ATTRIBUTES.ImportFilePath) lt 5>
		<cfthrow errorcode="2" detail="adminpro_importCSV error code 2" message="You must provide a valid name of the file you are importing (this file should be named with the .csv file extension)">
	<cfelseif Trim(Len(ATTRIBUTES.DSN)) eq 0>
		<cfthrow errorcode="3" detail="adminpro_importCSV error code 3" message="You must provide a valid datasource name for the database you are importing this csv file into">
	<cfelseif Len(ATTRIBUTES.ColumnNames) eq 0 AND Len(ATTRIBUTES.ColumnTypes) eq 0>
		<cfthrow errorcode="4" detail="adminpro_importCSV error code 4" message="You must provide Column Names and matching Column types for your database (which you are importing the csv file into)">	
	<cfelseif ListLen(ATTRIBUTES.ColumnNames) neq ListLen(ATTRIBUTES.ColumnTypes)>
		<cfthrow errorcode="5" detail="adminpro_importCSV error code 5" message="You must provide an equal number of Column Names to the matching Column types">	
	<cfelse>
	</cfif>

<cftry>	
	<cfset strFileToRead = #ATTRIBUTES.ImportFilePath# & #ATTRIBUTES.ImportFileName#>
	<cffile action = "read" 
		file = "#strFileToRead#" 
		variable = "vAddressImportList">

	<cfset vColumnNumber = ListLen(ATTRIBUTES.ColumnNames)>
	<cfset vImportArray = ArrayNew(2)>
	<cfset i = 1>
	
	<cfloop index = "lineIndex"
   			list = "#vAddressImportList#"
   			delimiters = "#newLine#">
	  
	  <cfset j = 1>
	  <cfset lineIndex=replace(lineIndex,",",",-","ALL")> <!--- must account for bug in CF ignoring empty list elements --->
	  <cfset lineIndexLen = ListLen(lineIndex)>
	  <cfset lineIndexDiff = Val(vListLength - lineIndexLen)>
	  <cfif lineIndexDiff gt 0>
	  <!--- Add extra list elements --->
	  	<cfset loopcount = 0>	
		<cfloop condition="loopcount neq lineIndexDiff">
			<cfset loopcount = loopcount + 1>
			<cfset lineIndex = lineIndex & ", " & "-">
		</cfloop>	
	  </cfif>

	  <!--- Validate and check email for existence, no duplicates allowed --->
	    <cfset emailAddr = ListGetAt(lineIndex, 2)>
		<cfif Left(emailAddr, 1) eq "-">
			<cfset emailAddrLen = Len(emailAddr)>
			<cfif emailAddrLen gt 1>
				<cfset emailAddr = Right(emailAddr,(emailAddrLen - 1))>
			<cfelse>
				<cfset emailAddr = "">
			</cfif>
	    <cfelse>
		</cfif>
	  <cfmodule template="adminpro_emailValidate.cfm" email="#emailAddr#">
	  <cfquery name="checkEmailExists" datasource="#ATTRIBUTES.DSN#">
		SELECT * FROM email_addresses 
		WHERE EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emailAddr#">
		AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
	  </cfquery>
	 
	  <cfif Error eq 0 AND checkEmailExists.RecordCount eq 0> <!--- Start email validation/duplicate check, address insert if pass --->
	  <!--- Insert each line into database --->
	  <!--- Array created also in case you wish to cfdump to view elements vImportArray --->
	  <cfquery name="insert" datasource="#ATTRIBUTES.DSN#">
	  	INSERT INTO #ATTRIBUTES.ImportIntoTable# (#ATTRIBUTES.ColumnNames#) 
		VALUES (
	  <cfloop index = "columnIndex" list = "#lineIndex#">
		  <cfif Left(columnIndex, 1) eq "-">
			<cfset columnIndexLen = Len(columnIndex)>
			<cfif columnIndexLen gt 1>
				<cfset columnIndex = Right(columnIndex,(columnIndexLen - 1))>
			<cfelseif columnIndexLen eq 1>
				<cfset columnIndex = "">
			<cfelse>
				<cfset columnIndex = "">
			</cfif>
		  </cfif>
		   
		   <cfif #ListGetAt(ATTRIBUTES.ColumnTypes, j)# eq "integer">
			<cfqueryparam cfsqltype="cf_sql_integer" value="#trim(columnIndex)#">
			<cfif j lt vColumnNumber>, </cfif>
		   <cfelseif #ListGetAt(ATTRIBUTES.ColumnTypes, j)# eq "varchar">
			<cfif trim(columnIndex) eq "-">
				<cfqueryparam cfsqltype="cf_sql_varchar" value="">
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(columnIndex)#">
			</cfif>
			<cfif j lt vColumnNumber>, </cfif>
	   	   <cfelse>
			<cfif trim(columnIndex) eq "-">
				<cfqueryparam cfsqltype="cf_sql_varchar" value="">
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(columnIndex)#">
			</cfif>
			<cfif j lt vColumnNumber>, </cfif>
		   </cfif>
			
		<cfset vImportArray[i][j] = #columnIndex#>
		<cfset j = j + 1>
		
	  </cfloop>	    	
	  )
	  </cfquery>
	  </cfif> <!--- End email validation/duplicate check, address insert if pass --->
	  	
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
		file. <br>
		1. Please DO NOT save it with quotes surrounding each field, save a default comma separated format only.<br>
		2. If using Microsoft Excel save with defualt settings only and file should be OK (you may try uploading it again to server as it may be corrupted).<br>
		3. Please verify you have provided a valid datasource name.
		<hr>
		<cfoutput>#cfcatch.message#<br>
		#cfcatch.detail#</cfoutput>
		<cfset CALLER.errImport = 1>
	</cfcatch>
	
</cftry>
