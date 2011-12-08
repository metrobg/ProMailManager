<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Setup: Step 1</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css" />
</head>

<body>
<cfif cgi.REQUEST_METHOD eq "POST">
	<!--- Create tables --->
	<cfswitch expression="#DatabaseType#">
		<cfcase value="2">
			<cfif upgrade eq 0>
				<cfinclude template="create_mssql_tables.cfm">
			<cfelse>
				<cfinclude template="upgrade_mssql_tables.cfm">
			</cfif>
		</cfcase>
		<cfcase value="3">
			<cfinclude template="create_mysql_tables.cfm">
		</cfcase>
        <cfcase value="4">
			<cfinclude template="create_oracle_tables.cfm">
		</cfcase>
	</cfswitch>
	
	<cftry>
	<cfif cffileFlag eq 1 AND Len(form.DSN) gte 1>
		<!--- Update DSN in Application file --->
		<cfscript>
		currPath = ExpandPath("*.*");
		tempCurrDir = GetDirectoryFromPath(currPath);
		if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { 
			trailingSlash = '\'; 
		}
		else { 
			trailingSlash = '/';
		}
			dirPathLen = ListLen(tempCurrDir, trailingSlash);
			strMailListPath = ListDeleteAt(tempCurrDir, dirPathLen, trailingSlash);
			strApplicationFilePath = strMailListPath & trailingSlash & "Application.cfm";
		</cfscript>
		<cffile action="read" file="#strApplicationFilePath#" variable="strApplicationFile">
		<cfset strApplicationFileUpdate = ReplaceNoCase(strApplicationFile, "Mail-List", form.DSN)>
		<cffile action="write" file="#strApplicationFilePath#" output="#strApplicationFileUpdate#">
	</cfif>
	
		<cfif DatabaseType eq 1>
		   <!--- Update admin username & password --->
		   <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  UPDATE admin 
			  SET AdminName = <cfif Len(form.adminUsername) gt 0>'#form.adminUsername#'<cfelse>'admin'</cfif>, 
				AdminPwd = <cfif Len(form.adminPwd) gt 0>'#form.adminPwd#'<cfelse>'admin'</cfif>
			  WHERE AdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		   </cfquery>
		   <span class="subscribeSuccess"><a href="../admin/index.cfm">click
				here to proceed</a> to administrator
				login
			</span></strong>
		</cfif>
		<cfcatch type="any">
			<span class="subscribeFail">There was a setup error: <cfoutput>#CFCATCH.Detail#</cfoutput></span>
		</cfcatch>
	</cftry>

<cfelse>
<table width="550" border="0" align="center" cellpadding="1" cellspacing="0" bgcolor="#009900">
  <tr>
    <td><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
      <tr align="center">
        <td colspan="2"><img src="../images/MailListManagerLogo.gif" width="300" height="47" /></td>
      </tr>
      <tr>
        <td height="1" colspan="2" bgcolor="#333333"><img src="../images/spacerdot_333333.jpg" width="1" height="1" /></td>
      </tr>
      <tr align="center">
        <td height="30" colspan="2" class="bodyText">The following form will
          create all the required tables for you in your database which you should
          have already created on your Database Server.</td>
      </tr>
      <tr>
        <td height="25" colspan="2" class="bodyText"><strong>Please verify you
            have completed the following steps:</strong></td>
      </tr>
      <tr>
        <td height="25" colspan="2" class="bodyText"><strong><font color="#990000">1.</font></strong> Created
          your <strong>database</strong> on your preferred Database Server</td>
      </tr>
      <tr>
        <td height="25" colspan="2" class="bodyText"><font color="#990000"><strong>2.</strong></font> Created
          and verified your <strong>datasource</strong> in CF Administrator</td>
      </tr>
      <tr align="center">
        <td height="25" colspan="2" class="adminRemoveSuccessful"> ** DO NOT
          PROCEED UNTIL YOU HAVE COMPLETED THE ABOVE 2 STEPS **</td>
      </tr>
      <cfform action="#cgi.script_name#" method="post" scriptsrc="/cfide/scripts/cfform.js">
	  <tr>
        <td width="195" height="25" nowrap="nowrap" class="bodyText"><font color="#990000"><strong>3.</strong></font> Choose
          your Database Server:</td>
        <td width="255">
		  <select name="DatabaseType" id="select" class="bodyText">
            <option value="1">Microsoft Access</option>
			<option value="2" selected>Microsoft SQL Server 7/2000</option>
            <option value="3">MySQL</option>
            <option value="4">Oracle</option>
          </select>
        </td>
      </tr>
	  <tr>
	    <td height="25" nowrap="nowrap" class="bodyText"><font color="#990000"><strong>3a.</strong></font> Are
	      you upgrading from a previous version?:</td>
	    <td>
			<select name="upgrade" id="upgrade" class="bodyText">
				<option value="0">No</option>
				<option value="1">Yes</option>
	      	</select>
		  </td>
	    </tr>
      <tr>
        <td height="25" nowrap="nowrap" class="bodyText"><font color="#990000"><strong>4.</strong></font> Enter
          your Datasource name:</td>
        <td class="bodyText"><cfinput name="DSN" type="text" size="20" value="Mail-List" maxlength="30" required="yes" message="Please enter your datasource name" id="DSN" class="bodyText" />
      (as created in step 2)</td>
      </tr>
      <tr>
        <td height="25" nowrap="nowrap" class="bodyText"><font color="#990000"><strong>5.</strong></font> Enter
          your Administrator username:</td>
        <td class="bodyText"><cfinput name="adminUsername" type="text" value="admin" size="20" maxlength="30" required="yes" message="Please enter an administrator username" class="bodyText" id="adminUsername" />
    (default: admin)</td>
      </tr>
      <tr>
        <td height="25" nowrap="nowrap" class="bodyText"><font color="#990000"><strong>6.</strong></font> Enter
          your Administrator password:</td>
        <td class="bodyText"><cfinput name="adminPwd" type="text" value="admin" size="20" maxlength="30" required="yes" message="Please enter an administrator password" class="bodyText" id="adminPwd" />
    (default: admin)</td>
      </tr>
      <tr>
        <td height="25" nowrap="nowrap" class="bodyText"><font color="#990000"><strong>7.</strong></font> Do
          you have access to cffile tag on your server?:</td>
        <td class="bodyText">
		<select name="cffileFlag" id="select" class="bodyText">
            <option value="1" selected>Yes</option>
            <option value="0">No</option>
          </select>
        (if you do not have cffile access and choose yes and error will take place)</td>
      </tr>
      <tr align="center">
        <td height="25" colspan="2"><input type="submit" name="Submit" value="Proceed" class="tdHeader" /></td>
      </tr>
	  </cfform>
    </table></td>
  </tr>
</table>
</cfif>
</body>
</html>
