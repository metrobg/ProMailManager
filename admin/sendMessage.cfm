<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<cfinclude template="globals/validateLogin.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm"> </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td width="100%" align="center" valign="top" class="bodyText">
	<cfinclude template="globals/_navHeader.cfm">      
	  <cfif IsDefined("bSendMessage")>
			<cfinclude template="_qryMessageSendEngine.cfm">
			<cfinclude template="_actUpdateMessageLinks.cfm">
			<cfif globals.cfmxInstalled eq 1>
				<cfinclude template="_messageSendEngine.cfm">
			<cfelse>
				<cfinclude template="_messageSendEngine_pre61.cfm">
			</cfif>
			<cfinclude template="_actMessageSendLog.cfm">
	  </cfif>
	  <br>
    <span class="adminAddNewTdBackGrnd">Message Sent Successfully to your Subscription List</span>
	</td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
