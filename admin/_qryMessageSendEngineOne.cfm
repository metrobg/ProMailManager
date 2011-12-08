<cfquery name="mailServerInfo" datasource="#DSN#">
SELECT *
FROM email_lists
WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
</cfquery>

<cfquery name="message" datasource="#DSN#">
SELECT *
FROM email_list_messages
WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
</cfquery>

<cfquery name="attachmentList" datasource="#DSN#">
SELECT *
FROM attachments
WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
</cfquery>
