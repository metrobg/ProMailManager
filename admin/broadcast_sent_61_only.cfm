<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Template Information:	   Send broadcast to selected subscriber group and send message
Date Created:              November 15, 2003
Date Last Modified:        January 13, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<cfif IsDefined("lid") AND IsDefined("mid")>
<cfelse>
	<!--- Illegally directly called --->
	<cflocation url="subscribersList.cfm">
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Email List Manager: Broadcast Sent</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="180" valign="top">
      <cfinclude template="globals/_navSidebar.cfm">
    </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td align="center" valign="top">
	<cfinclude template="globals/_navHeader.cfm">
	
	<cfinclude template="_qryMessageSendEngine.cfm">
	<cfoutput>
	<cfset session.messageTotalCount = subscriberList.RecordCount>
	</cfoutput>
	<cfif session.BatchStart eq 1>
		<cfset session.batchTimeout = BatchInterval>
		<!--- Get broadcast ID --->
		<cfinclude template="_act_broadcast_id.cfm">
		<!--- Update message log --->
		<cfinclude template="_actMessageSendLog_pre.cfm">
		<cfinclude template="_actUpdateMessageLinks.cfm">
		<!--- Update vHTMLMessage to database --->
		<cfquery name="qUpdateMsg" datasource="#DSN#">
			UPDATE email_list_messages
			SET MessageWithRedirects = '#vHTMLMessage#'
			WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
		</cfquery>
	</cfif>
	
		<cfif BatchAmount lt nSCount>
			<!--- Send in batches --->
			<cfset session.BatchEnd = (session.BatchStart + BatchAmount - 1)>
			<cfif session.BatchEnd lt nSCount>
				<cfinclude template="_messageSendEngine.cfm">
			<cfelse>
				<cfset session.BatchEnd = nSCount>
				<cfinclude template="_messageSendEngine.cfm">
			</cfif>
		<cfelseif BatchAmount eq nSCount>
			<!--- Send entire amount --->
			<cfset session.messageSentCount = 0>
			<cfset session.BatchStart = 1>
			<cfset session.BatchEnd = nSCount>
			<cfinclude template="_messageSendEngine.cfm">
		<cfelse>
		</cfif>
	<br>
	<span class="adminUpdateSuccessful">Broadcast successfully sent!</span>
	</td>
  </tr>
  <tr align="center">
    <td colspan="3"><cfinclude template="globals/_Footer.cfm">
    </td>
  </tr>
</table>
<cfif session.BatchEnd lt nSCount>
	<cfset session.BatchStart = session.BatchEnd + 1>
	<cf_pause seconds="#BatchInterval#">
	<cflocation url="broadcast_sent.cfm?BatchAmount=#BatchAmount#&BatchInterval=#BatchInterval#&nSCount=#nSCount#&nBcastID=#nBcastID#&lid=#lid#&mid=#mid#&Group=#Group#" addtoken="no">
<cfelse>
	<cfinclude template="_actMessageSendLog_post.cfm">
</cfif>
</body>
</html>
