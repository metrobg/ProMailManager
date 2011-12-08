<cfquery name="qCheckScheduleStatus" datasource="#DSN#">
SELECT * FROM email_lists
WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
</cfquery>

<cfif qCheckScheduleStatus.taskScheduled eq 1>
	<!--- schedule active, delete --->
	
	<cfschedule 
   		action = "delete" 
   		task = "Email List Manager: Scheduled Mail Check for List #lid#">
		
	<cfquery name="updateScheduled" datasource="#DSN#">
	UPDATE email_lists
		SET taskScheduled = 0
	WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
	</cfquery>
	<cfset ret = 0>

<cfelse>
	<!--- schedule not yet created, create now --->
	
	<cfschedule action = "update"
	   task = "Email List Manager: Scheduled Mail Check for List #lid#" 
	   operation = "HTTPRequest"
	   url = "#globals.localServerAddress#admin/act_popServerActions.cfm?listnum=#lid#"
	   startdate = "1/1/2003"
	   starttime = "2:00 AM"
	   interval = "86400"
	   publish = "No"
	   requesttimeout = "600">
	   
	<cfquery name="updateScheduled" datasource="#DSN#">
	UPDATE email_lists
		SET taskScheduled = 1
	WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
	</cfquery>
	<cfset ret = 1>
	
</cfif>
