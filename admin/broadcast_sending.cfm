<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Template Information:	   Send broadcast to selected subscriber group and send message
Date Created:              November 15, 2003
Date Last Modified:        January 6, 2003
=====================================================================
 -->
<cfset nSvrMajorNum = ListGetAt(Server.ColdFusion.ProductVersion, 1)>
<cfif nSvrMajorNum gte 6>	
	<cfsetting enablecfoutputonly="no" requesttimeout="#globals.PageTimeout#">
</cfif>
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
	<br>
	<span class="adminUpdateSuccessful">Broadcast in progress.......</span>
	</td>
  </tr>
  <tr align="center">
    <td colspan="3"><cfinclude template="globals/_Footer.cfm">
    </td>
  </tr>
</table>

<cf_pause seconds="3">
<cfif session.BatchEnd lt nSCount>
	<cfset session.BatchStart = session.BatchEnd>
	<cflocation url="broadcast_sent.cfm?BatchAmount=#BatchAmount#&nSCount=#nSCount#&lid=#lid#&mid=#mid#&Group=#Group#" addtoken="no">
</cfif>
</body>
</html>
