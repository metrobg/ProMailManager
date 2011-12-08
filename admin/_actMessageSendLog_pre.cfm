<cfif IsDefined("nBcastID")>
		<cfquery name="qUpdateMessageSendLogInitial" datasource="#DSN#">
			INSERT INTO email_list_messages_send_log (ListID, MessageID, MessageBroadcastID, MessagePreSentDate)
			VALUES (#lid#, #mid#, #nBcastID#, #CreateODBCDateTime(Now())#)
		</cfquery>
</cfif>