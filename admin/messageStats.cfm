<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        May 24, 2004
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main</title>
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
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<cfquery name="getMessageStats" datasource="#DSN#">
	SELECT * FROM click_thru_stats
	WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
	AND clickThruCount > 0
	ORDER BY BroadcastSession, clickThruCount DESC
</cfquery>
<cfquery name="getMessageStatsTotal" datasource="#DSN#">
	SELECT SUM(clickThruCount) AS clickTotalCount FROM click_thru_stats
	WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm">
	<br><br>
      <table width="180" border="0" cellspacing="0" cellpadding="1" class="tdTipsHeader">
        <tr>
          <td>
            <table width="100%" border="0" cellpadding="3" cellspacing="0">
              <tr>
                <td align="center" class="tdTipsHeader"><strong>Click Through
                    Stats</strong></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF"><p><span class="bodyText"><img src="../images/tipExclPt.gif" width="33" height="29"><br>
                    When a customer or client click on a link within your message
                          a count is kept and updated. These statistics are provided
                          here</span></p>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
	</td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td width="100%" valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">       
		<tr>
		  <td height="25" colspan="5" class="adminAddNewTdBackGrnd"><strong><span class="bodyTextWhite">Message:
	      Click Through Statistics</span></strong></td>
        </tr>
		<tr> 
          <td height="25" class="tdBackGrnd"><strong>Message Link</strong><strong></strong></td>
          <td width="1" nowrap class="tdVertDivider"><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
		  <td align="center" nowrap class="tdBackGrnd"><strong>Click Through<br>
	    Count </strong> </td>
          <td width="1" nowrap class="tdVertDivider"><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
		  <td align="center" nowrap class="tdBackGrnd"><strong>Date</strong></td>
		</tr>
        <tr> 
          <td height="1" colspan="5" class="tdHorizDivider"></td>
        </tr>
		<tr>
		  <td height="18" colspan="3" align="right" class="bodyText">Click Through
		    Total for this message: <strong><cfoutput>#getMessageStatsTotal.clickTotalCount#</cfoutput></strong></td>
		  <td bgcolor="White" width="1"><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
		  <td align="center" nowrap class="bodyText">&nbsp;</td>
		  </tr>
		<tr>
		  <td class="tdVertDivider" height="1" colspan="5" ></td>
		</tr>
		<cfoutput query="getMessageStats" group="BroadcastSession">
		<tr>
		  <td height="18" colspan="5" class="textFields">Send Iteration: #BroadcastSession# <cfif IsDefined("Server.ColdFusion.ProductVersion") AND ListGetAt(Server.ColdFusion.ProductVersion, 1) gt 5>[<a href="javascript:popUpWindow('message_stats_graph.cfm?mid=#MessageID#&sessid=#BroadcastSession#', 'yes', 'yes', '50', '50', '650', '700')">view graph</a>]
		  </cfif></td>
		</tr>
		<tr>
		  <td class="tdVertDivider" height="1" colspan="5" ></td>
		</tr>
		<cfoutput>
		<tr>
		  <td height="18" class="bodyText"><a href="javascript:popUpWindow('#clickTruOriginalURL#', 'yes', 'yes', '50', '50', '450', '400')">#clickTruOriginalURL#</a></td>
		  <td width="1" nowrap class="tdVertDivider"><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
		  <td align="center" nowrap class="bodyText">
		  <cfif clickThruCount gte 1>
		  	<cfquery name="qClickedDetailLog" datasource="#DSN#">
			  SELECT *
			  FROM click_thru_stats_detail LEFT JOIN email_addresses ON (click_thru_stats_detail.ClickThruSubscriberID = email_addresses.EmailID)
			  WHERE ClickThruID = <cfqueryparam cfsqltype="cf_sql_integer" value="#clickThruID#">
			</cfquery>
			<cfif qClickedDetailLog.RecordCount gte 1>[ <a href="javascript:popUpWindow('messageStats_Detail.cfm?ctdid=#clickThruID#', 'yes', 'yes', '50', '50', '450', '400')">View Details</a> ]</cfif>
		  </cfif>#clickThruCount#</td>
          <td width="1" class="tdVertDivider"></td>
	      <td align="center" nowrap class="bodyText">#DateFormat(addedDate, globals.DateDisplay)#</td>
		</tr>
		<tr> 
          <td height="1" colspan="5" class="tdHorizDivider"></td>
        </tr>
		</cfoutput>		
		</cfoutput>
      </table>
	</td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
