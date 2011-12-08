<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              July 18, 2003
Date Last Modified:        May 24, 2004
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Message Click Thru Subscribers</title>
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
              Click Thru Subscriber Detail</font></td>
        </tr>
        <tr>
          <td align="center" bgcolor="#FFFFFF" class="bodyText"><a href="javascript: window.close();">Close Window</a></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF" class="bodyText">
		  <cfquery name="clickedDetailLog" datasource="#DSN#">
		  SELECT *
		  FROM click_thru_stats_detail LEFT JOIN email_addresses ON (click_thru_stats_detail.ClickThruSubscriberID = email_addresses.EmailID)
		  WHERE ClickThruID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ctdid#">
		  </cfquery>
		  <table width="100%" cellspacing="0" cellpadding="0">
		    <tr>
				<td height="15" align="left" class="bodyText"><strong>Subscriber Email Address</strong></td>
				<td align="left" class="bodyText"><strong>Click Date</strong></td>
				<td align="left" class="bodyText"><strong>Click Count</strong></td>
			</tr>
		    <tr bgcolor="#CCCCCC">
		      <td height="1" colspan="3" align="left" class="bodyText"><img src="../images/spacer_cccccc.gif" width="1" height="1"></td>
		      </tr>
			<cfoutput query="clickedDetailLog">	
			<tr>
				<td height="15" align="left" class="bodyText" <cfif (clickedDetailLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>><cfif Len(EmailAddress) gte 4>#EmailAddress#<cfelse> * Removed subscriber *</cfif></td>
				<td align="left" class="bodyText" <cfif (clickedDetailLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>>#DateFormat(DateClicked, globals.DateDisplay)# (#TimeFormat(DateClicked, globals.TimeDisplay)#)</td>
				<td align="left" class="bodyText" <cfif (clickedDetailLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>>#ClickCount#</td>
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
