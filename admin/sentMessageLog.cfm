<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 4, 2003
Date Last Modified:        December 31, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Message Sent Log</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="1" bgcolor="#000000">
  <tr>
    <td>
      <table width="100%" border="0" cellpadding="8" cellspacing="0">
        <tr>
          <td class="tdHeader"><font color="#CCCCCC">Message
              Sent Log</font></td>
        </tr>
        <tr>
          <td align="center" bgcolor="#FFFFFF" class="bodyText"><a href="javascript: window.close();">Close Window</a></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF" class="bodyText">
		  <cfquery name="msgSentLog" datasource="#DSN#">
		  SELECT *
		  FROM email_list_messages_send_log
		  WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
		  </cfquery>
		  <table width="100%" cellspacing="1" cellpadding="2">
		    	
			<tr>
			  <td align="center" class="bodyText" bgcolor="#CCCCCC"><strong>Send
			    Num [Broadcast  ID]</strong></td>
			  <td align="left" nowrap class="bodyText" bgcolor="#CCCCCC"><strong>Date
			    Broadcast Initiated</strong></td>
			  <td align="left" nowrap class="bodyText" bgcolor="#CCCCCC"><strong>Date
			      Broadcast Completed</strong></td>
			  <td align="left" class="bodyText" bgcolor="#CCCCCC"><strong>Result</strong></td>
			</tr>
			<cfoutput query="msgSentLog">
			<tr>
				<td align="center" class="bodyText" <cfif (msgSentLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>>#msgSentLog.CurrentRow# [#MessageBroadcastID#]</td>
				<td align="left" nowrap class="bodyText" <cfif (msgSentLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>>#DateFormat(MessagePreSentDate, globals.DateDisplay)# (#TimeFormat(MessagePreSentDate, globals.TimeDisplay)#)</td>
				<td align="left" class="bodyText" <cfif (msgSentLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>>#DateFormat(MessageSentDate, globals.DateDisplay)# (#TimeFormat(MessageSentDate, globals.TimeDisplay)#)</td>
			    <td align="left" class="bodyText" <cfif (msgSentLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>><cfif Len(MessageSentDate) neq 0><img src="images/icon-check-box.gif" alt="Successfully completed" width="19" height="19"><cfelse><img src="images/icon-cross-box-red.gif" alt="Broadcast may not have fully completed" width="19" height="19"></cfif></td>
			</tr>
			</cfoutput>
		  </table>
		  </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</body>
</html>
