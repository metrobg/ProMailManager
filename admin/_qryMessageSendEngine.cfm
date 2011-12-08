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

<!--- Get subscriber List --->
<cfif Group eq 0>
	<!--- All subscribers for list --->	
	<cfquery name="subscriberList" datasource="#DSN#">
		SELECT *
		FROM email_addresses
		WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
	</cfquery>
<cfelse>
	<cfquery name="subscriberList" datasource="#DSN#">
		SELECT *
		FROM email_addresses E LEFT JOIN email_list_groups_members EGM ON (E.EmailID = EGM.GMEmailID)
		WHERE E.ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
			AND (E.Active = 1 OR E.Active IS NULL)
			AND EGM.GMGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Group#">
	</cfquery>
</cfif>

<cfquery name="attachmentList" datasource="#DSN#">
SELECT *
FROM attachments
WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
</cfquery>
