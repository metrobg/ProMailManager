<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Template Information:	   Prepare for broadcast by choosing subscribers to send message to and choose message to broadcast
Date Created:              November 15, 2003
Date Last Modified:        November 15, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<cfif IsDefined("nSCount") AND nSCount gte 1>
<cfelse>
	<!--- Illegally directly called --->
	<cflocation url="subscribersList.cfm">
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Email List Manager: Broadcast Processing ...</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
var popUpWin=0;
function popUpWindow(URLStr, scrollbar, resizable, left, top, width, height)
{
  if(popUpWin)
  {
    if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbars='+scrollbar+',resizable='+resizable+',copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
  location.replace('broadcast_sent.cfm?<cfoutput>lid=#lid#&mid=#mid#</cfoutput>');
}
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="popUpWindow('_broadcast_progress_bar.cfm?session.messageSentCount=0&session.messageTotalCount=<cfoutput>#nSCount#</cfoutput>', 'no', 'no', '50', '50', '410', '170')">
<cfset session.messageSentCount = 0>
<cfoutput>
<cfset session.messageTotalCount = nSCount>
</cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="180" valign="top">
      <cfinclude template="globals/_navSidebar.cfm">
    </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td align="center" valign="top" class="bodyText"><cfinclude template="globals/_navHeader.cfm">
    <br>
    Broadcast processing ....</td>
  </tr>
  <tr align="center">
    <td colspan="3"><cfinclude template="globals/_Footer.cfm">
    </td>
  </tr>
</table>
</body>
</html>
