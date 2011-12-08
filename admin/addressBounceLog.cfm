<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.andrewkelly.com
Contact Information:       http://www.andrewkelly.com/contact
Date Created:              January 8 2003
Date Last Modified:        March 11, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Address Bounce Log</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="1" bgcolor="#000000">
  <tr>
    <td>
      <table width="100%" border="0" cellpadding="8" cellspacing="0">
        <tr>
          <td class="tdHeader"><span class="bodyTextWhite"><strong>Address Bounce Log</strong></span></td>
        </tr>
        <tr>
          <td align="center" bgcolor="#FFFFFF" class="bodyText"><a href="javascript: window.close();">Close Window</a></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF" class="bodyText">
		 <cfquery name="getBounceLog" datasource="#DSN#">
				SELECT *
				FROM bounce_log
				WHERE EmailAddressID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmailID#">
				ORDER BY BounceDate
		  </cfquery>
		  <table width="100%" cellspacing="1" cellpadding="0">
		    <tr>
			  <td width="20%" align="right" class="bodyText"><strong>Count</strong></td>
			  <td width="80%" align="left" class="bodyText">&nbsp;<strong>Date</strong>&nbsp;</td>
			  </tr>
			<cfoutput query="getBounceLog">	
			<tr>
				<td align="right" class="bodyText" <cfif (getBounceLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>>#getBounceLog.CurrentRow#.</td>
				<td align="left" class="bodyText" <cfif (getBounceLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>>#DateFormat(BounceDate, globals.DateDisplay)# (#TimeFormat(BounceDate, globals.TimeDisplay)#)</td>
			    </tr>
			<cfif Len(BounceSubject) gt 1 AND Len(BounceBody) gt 1>
			<tr>
			  <td align="right" class="bodyText" <cfif (getBounceLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>><u>Subject</u>: </td>
			  <td align="left" class="bodyText" <cfif (getBounceLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>>#BounceSubject#</td>
			  </tr>
			<tr>
			  <td align="right" class="bodyText" <cfif (getBounceLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>><u>Body</u>:</td>
			  <td align="left" class="bodyText" <cfif (getBounceLog.CurrentRow MOD 2) gt 0>bgcolor="##EEEEEE"</cfif>>#BounceBody#</td>
			</tr>
			</cfif>
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
