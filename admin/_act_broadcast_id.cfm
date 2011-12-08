<cflock name="lBCast" type="exclusive" timeout="20">
	<cfquery name="qBroadcastID" datasource="#DSN#">
	SELECT SendLogID
	FROM send_log_id
	</cfquery>
	<cfset nBcastID = (qBroadcastID.SendLogID + 1)>
	<cfquery name="qUpdateBroadcastID" datasource="#DSN#">
	UPDATE send_log_id
	SET SendLogID = <cfqueryparam cfsqltype="cf_sql_integer" value="#nBcastID#">
	WHERE recID = 1
	</cfquery>
</cflock>