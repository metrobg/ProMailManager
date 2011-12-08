<cfquery name="qSuccessLog" datasource="#DSN#">
	INSERT INTO broadcast_success_log (SubscriberID<cfif IsDefined("nBcastID")>, BroadcastID</cfif>, MessageID)
	VALUES (#subscriberList.EmailID# <cfif IsDefined("nBcastID")>, #nBcastID#</cfif>, #mid#)
</cfquery>