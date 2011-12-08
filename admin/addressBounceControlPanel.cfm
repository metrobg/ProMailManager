<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 8 2003
Date Last Modified:        April 20, 2003
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
<cfif CGI.REQUEST_METHOD eq "POST" AND IsDefined("bounceType") AND IsDefined("count") AND IsDefined("lid")>
	<cfquery name="getAddresses" datasource="#DSN#">
		SELECT email_addresses.EmailID, bounce_log.EmailAddressID
		FROM email_addresses INNER JOIN
		bounce_log ON email_addresses.EmailID = bounce_log.EmailAddressID
		WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
			AND (email_addresses.Bounced = 1) 
			<cfif bounceType eq "1">
			AND (email_addresses.ExceededMailQuota <> 1)
			<cfelseif bounceType eq "2">
			AND (email_addresses.ExceededMailQuota = 1)
			<cfelse>
			</cfif>
		GROUP BY email_addresses.EmailID, bounce_log.EmailAddressID
		<cfif count neq 5>HAVING (COUNT(bounce_log.EmailAddressID) >= #count#)</cfif>
		ORDER BY email_addresses.EmailID
	</cfquery>
	<cfif getAddresses.RecordCount gt 0>
	  <cfloop query="getAddresses">	
		<cfquery name="removeAddresses" datasource="#DSN#">
		DELETE FROM email_addresses
		WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getAddresses.EmailID#">
		</cfquery>
	  </cfloop>
	  <cfloop query="getAddresses">	
		<cfquery name="removeBounceLogEntries" datasource="#DSN#">
		DELETE FROM bounce_log
		WHERE EmailAddressID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getAddresses.EmailID#">
		</cfquery>
	  </cfloop>
	</cfif>
	<span class="bodyText"><strong><font color="Red"><cfoutput>#getAddresses.RecordCount#</cfoutput></font> subscriber/s have been removed</strong></span>
	<br>
	<br>
</cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="1" bgcolor="#000000">
  <tr>
    <td>
      <table width="100%" border="0" cellpadding="8" cellspacing="0">
        <tr>
          <td class="tdHeader"><span class="bodyTextWhite"><strong>Address Bounce
                Removal</strong></span></td>
        </tr>
        <tr>
          <td align="center" bgcolor="#FFFFFF" class="bodyText"><a href="javascript: window.close();">Close Window</a></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF" class="bodyText">
		 
		  <table width="100%" cellspacing="1" cellpadding="0">
		    <tr align="left">
		      <td colspan="2" class="bodyText">Window Help:<br>
		        1. <strong>Bounce Type - </strong>choose what type of bounced emails
		        you wish to remove, this gives you the power to be selective
		        on the type of bounced emails you wish to remove. For example
		        if an address has only bounced due to its mailbox being over
		        its quota you may decide you wish to keep this email active in
		        hopes this user will empty their mailbox and future messages
		        broadcast will be successfully delivered.<br>
		        <br>
		        2. <strong>Bounce Count</strong> - you have the extra option here to
		        add criteria to the matches in your bounce log that you wish
		        to remove<br>
		        <u>Examples</u>:<br> 
		        You wish to remove only emails that have bounced (not due to
		        exceeded quota and that have bounced at least 2 times). To remove
		        all emails that meet this criteria then in the <strong>Bounce Type</strong> Pop-Up
		        menu choose <strong>Bounced/Not Exceeded Quota </strong>and in the
		        Bounce Count Pop-Up Menu choose <strong>2</strong></td>
		      </tr>
		    <tr bgcolor="#333333">
		      <td height="1" colspan="2" align="right"></td>
		      </tr>
		    <form action="addressBounceControlPanel.cfm" method="post">
			<input type="hidden" name="lid" value="<cfoutput>#lid#</cfoutput>">
			<tr bgcolor="#EEEEEE">
			  <td width="43%" align="right" class="bodyText"><strong>Bounce Type: </strong></td>
			  <td width="57%" align="left" class="bodyText">
			    <select name="bounceType" id="bounceType" class="bodyText">
			      <option value="1">Bounced/Not Exceeded Quota</option>
			      <option value="2">Bounced/Exceeded Quota</option>
			      <option value="3">Bounced/Either Reason</option>
		        </select></td>
			  </tr>
		    <tr bgcolor="#EEEEEE">
		      <td align="right" class="bodyText"><strong>Bounce Count: </strong></td>
		      <td align="left" class="bodyText"><select name="count" id="count" class="bodyText">
		        <option value="1">1</option>
		        <option value="2">2</option>
		        <option value="3">3</option>
		        <option value="4">4</option>
		        <option value="5">All</option>
		        </select></td>
		      </tr>
		    <tr align="center" bgcolor="#EEEEEE">
		      <td colspan="2" class="bodyText"><input type="submit" name="Submit" value="Perform Removal"></td>
		    </tr>
			</form>
		  </table>
		  </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</body>
</html>
