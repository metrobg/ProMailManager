<cfset session.messageSentCount = 0>
<cfinclude template="_qryMessageSendEngine.cfm">
<cfoutput>
	<cfset session.messageTotalCount = subscriberList.RecordCount>
</cfoutput>
<cfinclude template="_act_broadcast_id.cfm">
<cfinclude template="_actMessageSendLog_pre.cfm">
<cfinclude template="_actUpdateMessageLinks.cfm">
	<!--- Update vHTMLMessage to database --->
	<cfquery name="qUpdateMsg" datasource="#DSN#">
		UPDATE email_list_messages
		SET MessageWithRedirects = '#vHTMLMessage#'
		WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
	</cfquery>
	
<cfset session.BatchStart = 1>
<cfset session.BatchEnd = subscriberList.RecordCount>
		
<cfif globals.cfmxInstalled eq 1>
	<cfinclude template="_messageSendEngine.cfm">
<cfelse>
	<cfinclude template="_messageSendEngine_pre61.cfm">
</cfif>
<cfinclude template="_actMessageSendLog_post.cfm">