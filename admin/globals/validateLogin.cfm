<cfparam name="vUser" default="">
<cfparam name="vPwd" default="">
<cfif ( NOT IsDefined("Session.AccessLevelID") AND IsDefined("LoginSubmit") ) OR ( IsDefined("LoginSubmit") )>
	<cfset structDelete(session,"AccessLevelID")>
	<cfset structDelete(session,"AccessLevelDesc")>
	<cfset structDelete(session,"UserName")>
	
	<cfquery name="getAccessLevel" datasource="#dsn#">
		SELECT *
		FROM admin, admin_access_levels
		WHERE AdminName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vUser#">
			AND AdminPwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vPwd#">
			AND (admin.AdminLevelID = admin_access_levels.AccessID)
	</cfquery>
	<cfif getAccessLevel.RecordCount gte 1>
	  <cflock timeout="20" scope="Session" type="exclusive">
		<cfset Session.AccessLevelID = #getAccessLevel.AccessID#>
		<cfset Session.AccessLevelDesc = #getAccessLevel.AccessLevelDesc#>
		<cfset Session.UserName = #getAccessLevel.AdminName#>
	  </cflock>
	<cfelse>
		<cflocation url="index.cfm" addtoken="no"> 
	</cfif>
<cfelseif IsDefined("Session.AccessLevelID") AND NOT IsDefined("Session.UserName")>
	<cflocation url="index.cfm" addtoken="no">
<cfelseif IsDefined("Session.AccessLevelID")>
<cfelse>
	<cflocation url="index.cfm" addtoken="no"> 
</cfif>