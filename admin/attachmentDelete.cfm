<!-- 
=====================================================================
Mail List Version 2.1

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              August 9 2003
Date Last Modified:        August 9, 2003
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
<cfif IsDefined("r") AND r eq 1>
 
 <cfif Len(atid) neq 0>
	<cfquery name="locateAttachment" datasource="#DSN#">
		SELECT * FROM attachments WHERE recID = <cfqueryparam cfsqltype="cf_sql_integer" value="#atid#">
	</cfquery>
	<cfif locateAttachment.RecordCount eq 1>
		<cfquery name="removeAttachment" datasource="#DSN#">
			DELETE FROM attachments WHERE recID = <cfqueryparam cfsqltype="cf_sql_integer" value="#atid#">
		</cfquery>
		<cfif globals.cffileEnabled eq 1>
			<cfscript>
				currPath = ExpandPath("*.*");
				currDir = GetDirectoryFromPath(currPath);
				attachmentNameToDelete = #currDir# & #locateAttachment.AttachmentFileName#;
			</cfscript>
			<cffile action = "delete" file = "#attachmentNameToDelete#">
			<cfset fileDeleted = 1>
		<cfelse>
			<!--- Must manually remove the file yourself form the attachment directory --->
		</cfif>
		<cfset removeError = 0>
	<cfelse>
		<cfset removeError = 2> <!--- attachment not found --->
	</cfif>
	
 <cfelse>
 	<cfset removeError = 1> <!--- no attachment ID was passed --->
	<cfset fileDeleted = 0>	
 </cfif>
<cfelse>
	<cfset removeError = 3> <!--- non valid call of page --->
	<cfset fileDeleted = 0>
</cfif>	
<table width="100%" border="0" cellspacing="0" cellpadding="1" bgcolor="#000000">
  <tr>
    <td>
      <table width="100%" border="0" cellpadding="8" cellspacing="0">
        <tr>
          <td class="tdHeader"><span class="bodyTextWhite"><strong>Delete Attachment</strong></span></td>
        </tr>
        <tr>
          <td align="center" bgcolor="#FFFFFF" class="bodyText"><a href="javascript: window.close();">Close Window</a></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF" class="bodyText">
		 
		  <table width="100%" cellspacing="1" cellpadding="0">
		    <tr align="left">
		      <td width="100%" align="center" class="bodyText">
			  <cfif removeError eq 0>
			  <font color="#990000">Attachment has been <em>successfully deleted</em> from the database</font>
			  <cfelseif removeError eq 1>
			  no attachment ID was passed, attachment was not removed from the database
			  <cfelseif removeError eq 2>
			  no attachment with the passed ID was found - it may have already been removed or if manually 
			  uploaded via ftp it may have not been recorded in the Attachments table.
			  <cfelseif removeError eq 3>
			  This page has been incorrectly referenced, it cannot be directly referenced!
			  <cfelse>
			  </cfif>
			  <cfif IsDefined("fileDeleted") AND fileDeleted eq 1>
			  	<br>
				* File has been successfully deleted from the attachments directory
			  <cfelseif IsDefined("fileDeleted") AND fileDeleted eq 0>
			  <cfelse>
			    * You will need to now manually remove the attachment from the attachments directory <cfif globals.cffileEnabled eq 0>(you have cffile usage disbaled in your global settings)</cfif>
			  </cfif>
			  </td>
		      </tr>
		    
		  </table>
		  </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</body>
</html>
