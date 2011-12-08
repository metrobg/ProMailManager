<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              December 2, 2003
Date Last Modified:        April 16, 2004
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main - Bounce Exclusions</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href=" rel="stylesheet" type="text/css">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm"> </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif IsDefined("bAdd") AND Len(Trim(BounceExcText)) neq 0>
			<cfquery name="qCheckExists" datasource="#DSN#">
			SELECT * FROM bounce_exceptions
			WHERE BounceListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BounceListID#">
				AND BounceExcText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#BounceExcText#">
			</cfquery>
			<cfif qCheckExists.RecordCount eq 0>
				<cfscript>
					if ( IsDefined("BounceExcActive") ) {
						BounceExcActive = 1;
					}
					else {
						BounceExcActive = 0;
					}
				</cfscript>
				<cfquery name="qAddExcl" datasource="#DSN#">
				INSERT INTO bounce_exceptions (BounceListID, BounceExcText, BounceExcActive)
				VALUES (#BounceListID#, '#BounceExcText#', #BounceExcActive#)
				</cfquery>
				<cfset exclAdded = 1>
			<cfelse>
				<cfset exclAdded = 0>
			</cfif>
		<tr>
		  <td height="18" colspan="9" align="center"><span class="adminUpdateSuccessful"><cfif exclAdded eq 1>The new Bounce Exclusion has added<cfelse>This bounce exclusion already exists for this list, please try another</cfif></span></td>
	    </tr>
		<cfelseif IsDefined("bUpdate") AND Len(Trim(BounceExcText)) neq 0>
			<cfscript>
					if ( IsDefined("BounceExcActive") ) {
						BounceExcActive = 1;
					}
					else {
						BounceExcActive = 0;
					}
			</cfscript>
			<cfquery name="qUpdateExcl" datasource="#DSN#">
			UPDATE bounce_exceptions
			SET BounceExcText = '#BounceExcText#',
				BounceListID = #BounceListID#,
				BounceExcActive = #BounceExcActive#
			WHERE BounceExcID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BounceExcID#">
			</cfquery>
				<cfset exclUpdated = 1>
		<tr>
		  <td height="18" colspan="9" align="center"><span class="adminUpdateSuccessful"><cfif exclUpdated eq 1>The selected Bounce Exclusion has been updated<cfelse>The selected user could not be updated to an already existing user name</cfif></span></td>
	    </tr>		
		<cfelseif (IsDefined("bDelete") AND IsDefined("BounceExcID"))>
			<cfquery name="qDelExcl" datasource="#DSN#">
			DELETE
			FROM bounce_exceptions
			WHERE BounceExcID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BounceExcID#">
			</cfquery>
		<tr>
		  <td height="18" colspan="9" align="center"><span class="adminRemoveSuccessful">The selected Bounce Exclusion has been removed</span></td>
	    </tr>		
		<cfelse>
		</cfif>
		<cfquery name="qBounceExclList" datasource="#DSN#">
			SELECT *
			FROM email_lists EL, bounce_exceptions BE
			WHERE EL.EmailListID = BE.BounceListID
			<cfif IsDefined("Session.AccessLevelDesc") AND Session.AccessLevelDesc eq "Administrator">
			<cfelse>
			AND EL.EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
			</cfif>
			ORDER BY EmailListDesc
		</cfquery>
		
		<cfquery name="qLists" datasource="#DSN#">
			SELECT *
			FROM email_lists
			<cfif IsDefined("Session.AccessLevelDesc") AND Session.AccessLevelDesc eq "Administrator">
			<cfelse>
			WHERE EL.EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
			</cfif>
			ORDER BY EmailListDesc
		</cfquery>
		<cfquery name="qLists" datasource="#DSN#">
				SELECT *
				FROM email_lists EL
				<cfif IsDefined("Session.AccessLevelDesc") AND Session.AccessLevelDesc eq "Administrator">
				<cfelse>
				WHERE EL.EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
				</cfif>
				ORDER BY EmailListDesc
		</cfquery>
		<tr>
		  <td height="18" colspan="9" class="bodyText"><strong>Bounce Exclusions for
		      this List</strong></td>
	    </tr>
		<tr>
		  <td height="18" colspan="9" class="bodyText">Below you can add phrases of
		    text that if they appear in a bounced message, the user's email will
		    not be flagged as bounced. This allows you to make provisions for
		    legitimate bounces such as users who set their email account to auto
		    rely with &quot;out of office&quot; or &quot;vacation&quot; responses.</td>
	    </tr>
		<tr>
		  <td height="18" colspan="9" class="bodyText">Exclusions Found: <cfoutput>#qBounceExclList.RecordCount#</cfoutput>
		  </td>
	    </tr>
		<tr> 
          <td height="1" colspan="9" class="tdHorizDivider"></td>
        </tr>
		<tr> 
          <td height="25" align="center" nowrap class="tdBackGrnd"><strong>Bounce
              Phrase</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Subscription List</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Exclusion Active</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Update</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Delete</strong></td>
        </tr>
        <tr> 
            <td height="1" colspan="9" class="tdVertDivider"></td>
          </tr>
        <cfoutput query="qBounceExclList" group="BounceListID">
		  <tr align="left">
		    <td height="22" colspan="9" class="bodyText">List: <font color="##990000"><strong>#EmailListDesc#</strong></font></td>
		  </tr>
		  <tr> 
            <td height="1" colspan="9" class="tdVertDivider"></td>
          </tr>
		  <cfoutput>
		  <cfform action="#cgi.script_name#" method="post">
		  <input type="hidden" name="BounceExcID" value="#qBounceExclList.BounceExcID#">
		  <tr> 
            <td height="22" align="center" class="bodyText"><cfinput name="BounceExcText" type="text" value="#qBounceExclList.BounceExcText#" size="40" maxlength="100" required="yes" message="You must enter a phrase to be excluded" class="bodyText"></td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="bodyText">
			<cfset nCurrListID = qBounceExclList.BounceListID>
			<select name="BounceListID" class="bodyText">
				<cfloop query="qLists">
					<cfif qLists.EmailListID eq nCurrListID>
					<option value="#qLists.EmailListID#" selected>#qLists.EmailListDesc#</option>
					<cfelse>
					<option value="#qLists.EmailListID#">#qLists.EmailListDesc#</option>
					</cfif>
				</cfloop>
			</select>
			</td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="bodyText">
				<input name="BounceExcActive" type="checkbox" value="1" class="bodyText" <cfif qBounceExclList.BounceExcActive eq 1>checked</cfif>>
			</td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="bodyText"><input name="bUpdate" type="submit" class="tdHeader" id="bUpdate" value="Update"></td>
            <td width="1" class="tdVertDivider"></td>
            <td class="bodyText" align="center"><input name="bDelete" type="submit" class="tdHeader" id="bDelete" value="Remove"></td>
          </tr>
          <tr> 
            <td height="1" colspan="9" class="tdVertDivider"></td>
          </tr>
		  </cfform>
		  </cfoutput>
        </cfoutput>
		 <cfform action="#cgi.script_name#" method="post">
		 <tr> 
            <td height="22" align="center" class="adminAddNewTdBackGrnd"><cfoutput>
              <cfinput name="BounceExcText" type="text" size="40" maxlength="100" required="yes" message="You must enter a phrase to be excluded" class="bodyText">
            </cfoutput></td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="adminAddNewTdBackGrnd">
			<select name="BounceListID" class="bodyText">
				<cfoutput query="qLists">
					<option value="#qLists.EmailListID#">#qLists.EmailListDesc#</option>
				</cfoutput>
			</select>
			</td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="adminAddNewTdBackGrnd">
              <input name="BounceExcActive" type="checkbox" value="1" class="bodyText" checked>
			</td>
            <td width="1" class="tdVertDivider"></td>
            <td colspan="3" align="center" class="adminAddNewTdBackGrnd"><input name="bAdd" type="submit" class="tdHeader" id="bAdd" value="Add New"></td>
         </tr>
		 </cfform>
		</table>
	
	</td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
