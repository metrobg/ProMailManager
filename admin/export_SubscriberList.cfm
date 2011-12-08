<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 8 2003
Date Last Modified:        September 11, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Email Subscriber Export</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfscript>
	currPath = ExpandPath("*.*");
	tempCurrDir = GetDirectoryFromPath(currPath);
	if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { 
		trailingSlash = '\'; 
	}
	else { 
		trailingSlash = '/';
	}
</cfscript>
<cftry>
<table width="100%" border="0" cellspacing="0" cellpadding="1" bgcolor="#000000">
  <tr>
    <td>
      <table width="100%" border="0" cellpadding="8" cellspacing="0">
        <tr>
          <td class="tdHeader"><span class="bodyTextWhite"><strong>Email List
                Export (CSV)</strong></span></td>
        </tr>
        <tr>
          <td align="center" bgcolor="#FFFFFF" class="bodyText"><a href="javascript: window.close();">Close Window</a></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF" class="bodyText">
		  	  <cfif NOT IsDefined("lid")>
			  Your must provide a valid Email List ID to continue ....
			  <cfelse>
		  		<cfparam name="list" default="active">
				<cfparam name="lid" default="">
				<cfquery name="exportSubscribers" datasource="#DSN#">
				SELECT *
				<cfif IsDefined("list") AND list eq "active">
				FROM email_addresses
				<cfelseif IsDefined("list") AND list eq "removed">
				FROM email_addresses_removed
				<cfelse>
					<cflocation url="subscriptionLists.cfm" addtoken="no">
				</cfif>
				WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
				</cfquery>

				<cfset exportList = "Email Address,First Name,Last Name,Date Subscribed">
				<cfset exportList = exportList & "#Chr(10)#">
				<cfset exportFilename = "EmailList"&#lid#&".csv">
				
				<cfoutput query="exportSubscribers">
					<cfset exportList = exportList & "#EmailAddress#,#FirstName#,#LastName#,#DateFormat(DateAdded, globals.DateDisplay)##Chr(10)#">
				</cfoutput>
				
				<cfif globals.cffileEnabled eq 1> 
					<cffile 
					   action = "write" 
					   file = "#globals.exportFilePath##trailingSlash##exportFilename#"
					   output = "#exportList#"
					   addnewline = "No"
					   >
					
					<cflocation url="fileDownload.cfm?exportfile=#exportFilename#" addtoken="no">
				<cfelse>
					You may copy and paste the output below to a text file and then import into Excel using delimited by a comma
					as the criteria<hr>
					<pre>
					<div align="left">
					<cfoutput>
						#exportList#
					</cfoutput>
					</div>
					</pre>
					
				</cfif>
			</cfif>
			<cfcatch type="any">
				<strong><font color="Red">! There has been an error, if you are using linux the most often cause of this error is insufficient permissions set on the
				admin/export directory</font></strong><hr>
				<u>CF Server Error Information</u><br>
				<cfoutput>#cfcatch.Detail#</cfoutput>
			</cfcatch>
		  </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</cftry>
</body>
</html>
