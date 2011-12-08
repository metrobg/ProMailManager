<cfif IsDefined("nBcastID")>
	<cfquery name="qUpdateMessageSendLogComplete" datasource="#DSN#">
			UPDATE email_list_messages_send_log 
				SET MessageSentDate = #CreateODBCDateTime(Now())#
				WHERE MessageBroadcastID = <cfqueryparam cfsqltype="cf_sql_integer" value="#nBcastID#">
	</cfquery>
</cfif>