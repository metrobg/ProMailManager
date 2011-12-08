<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Delete all Tables</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<cfset strDSN = "maillist_test">

<cfstoredproc procedure="sp_tables" datasource="#strDSN#" debug="yes">
	<cfprocresult name = "qAllTables">
</cfstoredproc>
	<!--- <cfoutput><cfdump var="#qAllTables#"></cfoutput> --->
	<cfset lTableList = valuelist(qAllTables.TABLE_NAME)><br>
	<cfset j = 1>
	
	<cfif qAllTables.RecordCount gte 1>
	  <cfloop from="1" to="#ListLen(lTableList)#" index="j">
	   <cftry>	
		<cfquery name="qDropTables" datasource="#strDSN#">
			DROP TABLE #ListGetAt(lTableList, j)#
		</cfquery>
		<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Table: <strong><font color="#000033"><cfoutput>#ListGetAt(lTableList, j)# (#j#)</cfoutput></font></strong> ... removed successfully!</font><br />
		 <cfcatch type="database">
			  <!--- System table most probably - cannot be deleted --->
	    </cfcatch>
		</cftry>
	  </cfloop>
	</cfif>
 
  

</body>
</html>
