<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Broadcast in progress ...</title>
<cfif IsDefined("session.batchTimeout")>
		<cfset nRefreshIntervalMs = (session.batchTimeout * 1000)>
		<cfset nRefreshIntervalS = session.batchTimeout>
<cfelse>
		<cfset nRefreshIntervalMs = 1000>
		<cfset nRefreshIntervalS = 1>
</cfif> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Refresh" content="<cfoutput>#nRefreshIntervalS#</cfoutput>;URL=<cfoutput>#globals.siteServerAddress#</cfoutput>admin/broadcast_progress_bar.cfm">
<cfparam name="session.messageSentCount" default="0">
<cfif session.messageSentCount gte session.messageTotalCount>
	<script language="JavaScript" type="text/JavaScript">
		function doClose()
		{
			setTimeout( "close()", 800 );

		}
	</script>

<cfelse>
	<script language="JavaScript" type="text/JavaScript">
		function doClose()
		{
			window.setInterval("pageRefresh()", <cfoutput>#nRefreshIntervalMs#</cfoutput>);
		}
		
		function pageRefresh()
		{
			window.location.reload(true);			
		}
		
	</script>
</cfif>
<style type="text/css">
<!--
.bodyText {
	font-family: tahoma, verdana, sans-serif;
	font-size: 11px;
}
-->
</style>
<noscript>
<!--- non javascript capable browser --->
</noscript>

</head>

<body bgcolor="#EEEEEE" onLoad="doClose()">
<cfif IsDefined("session.messageTotalCount") AND session.messageTotalCount gt 0>
	<cfset nPercentComplete = (session.messageSentCount / session.messageTotalCount * 100)>
<cfelse>
	<cfset nPercentComplete = 0>
</cfif>
<cfscript>
	if ( IsDefined("session.messageSentCount") ) {
		nCountMsgsSentPerSec = session.messageSentCount - session.messageSentCountPBarLocal;
	}
	else {
		nCountMsgsSentPerSec = 0;
	}
	nCountRemaining = session.messageTotalCount - session.messageSentCount;
	if ( nCountRemaining neq 0 AND nCountMsgsSentPerSec neq 0 ){
	nSecsRemaining = Round(nCountRemaining / nCountMsgsSentPerSec);
	}
	else {
	nSecsRemaining = 0;
	}
</cfscript>
<cfset session.messageSentCountPBarLocal = session.messageSentCount>
<table width="350" border="0" align="center" cellpadding="2" cellspacing="2">
  <tr>
    <td width="300" height="25" colspan="2" align="center" class="bodyText"><strong>Please
    wait ...</strong></td>
  </tr>
  <tr>
    <td width="150" height="20" align="left" class="bodyText"><img src="images/logo-maillist-med.gif" width="144" height="87"></td>
    <td width="200" align="center" class="bodyText">Sending broadcast:<br>
.... do not close this window</td>
  </tr>
  <tr>
    <td colspan="2" align="center">
	<!--- Open Progress table --->
                <table width="300" border="0" cellspacing="0" cellpadding="0" height="10" bgcolor="#FFFFFF">
                  <tr>
					<td width="10" height="10"><cfif nPercentComplete gte 3><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
					<td width="10" height="10"><cfif nPercentComplete gte 6><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
					<td width="10" height="10"><cfif nPercentComplete gte 10><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 13><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 16><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 20><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 23><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 26><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 30><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 33><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 36><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 40><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 43><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 46><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 50><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 53><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 56><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 60><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 63><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 66><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 70><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 73><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 76><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 80><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 83><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 86><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 90><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 93><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 96><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                    <td width="10" height="10"><cfif nPercentComplete gte 100><img src="images/icon-percentmarker.gif" width="10" height="10" /></cfif></td>
                  </tr>
          </table>
	<!--- Close Progress table --->
	</td>
  </tr>
  <tr>
    <td colspan="2" align="left" class="bodyText">Estimated time left <cfoutput>#nSecsRemaining#</cfoutput> sec (<cfoutput>#session.messageSentCount# / #session.messageTotalCount#</cfoutput> messages sent)</td>
  </tr>
  <tr>
    <td colspan="2" align="left" class="bodyText">Message Send Rate: <cfoutput>#nCountMsgsSentPerSec#</cfoutput> messages/sec</td>
  </tr>
  <cfif nPercentComplete gte 100>
  <tr>
    <td colspan="2" align="center" bgcolor="#EEEEEE" class="bodyText"><font color="#000066"><strong>Broadcast complete!</strong></font></td>
  </tr>
  <cfelse>
  <tr>
    <td width="300" height="25" colspan="2" align="center" bgcolor="#CCCCCC" class="bodyText"><font color="Red"><strong>**
      DO NOT CLOSE **</strong></font></td>
  </tr>
  </cfif>
</table>
</body>
</html>
