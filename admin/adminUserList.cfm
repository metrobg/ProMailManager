<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        Febuary 24, 2004
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main</title>
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
		<cfif IsDefined("bAdd") AND Len(Trim(AdminName)) neq 0 AND Len(Trim(AdminPwd)) neq 0>
			<cfquery name="checkUserExists" datasource="#DSN#">
			SELECT * FROM admin
			WHERE AdminLevelID = <cfqueryparam cfsqltype="cf_sql_integer" value="#AdminLevelID#">
				AND AdminName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AdminName#">
			</cfquery>
			<cfif checkUserExists.RecordCount eq 0>
			<cfquery name="addUser" datasource="#DSN#">
			INSERT INTO admin (AdminLevelID, AdminName, AdminPwd, AdminEmail)
			VALUES (#AdminLevelID#, '#AdminName#', '#AdminPwd#', '#AdminEmail#')
			</cfquery>
				<cfset userAdded = 1>
			<cfelse>
				<cfset userAdded = 0>
			</cfif>
		<tr>
		  <td height="18" colspan="11" align="center"><span class="adminUpdateSuccessful"><cfif userAdded eq 1>The new User has added<cfelse>This user name already exists, please try another</cfif></span></td>
	    </tr>
		<cfelseif IsDefined("bUpdate") AND Len(Trim(AdminName)) neq 0 AND Len(Trim(AdminPwd)) neq 0>
			<cfquery name="updateUser" datasource="#DSN#">
			UPDATE admin
			SET AdminLevelID = #AdminLevelID#,
				AdminName = '#AdminName#',
				AdminPwd = '#AdminPwd#',
				AdminEmail = '#AdminEmail#'
			WHERE AdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#uid#">
			</cfquery>
				<cfset userUpdated = 1>
		<tr>
		  <td height="18" colspan="11" align="center"><span class="adminUpdateSuccessful"><cfif userUpdated eq 1>The selected User has been updated<cfelse>The selected user could not be updated to an already existing user name</cfif></span></td>
	    </tr>		
		<cfelseif (IsDefined("bDelete")) AND (uid neq 1)>
			<cfquery name="removeUser" datasource="#DSN#">
			DELETE
			FROM admin
			WHERE AdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#uid#">
			</cfquery>
		<tr>
		  <td height="18" colspan="11" align="center"><span class="adminRemoveSuccessful">The selected User has been removed</span></td>
	    </tr>		
		<cfelse>
		</cfif>
		<cfquery name="getUsers" datasource="#DSN#">
			SELECT *
			FROM admin, admin_access_levels
			WHERE (admin.AdminLevelID = admin_access_levels.AccessID)
			<cfif Session.AccessLevelID neq 1>
			AND AccessID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#"> 
			</cfif>
		</cfquery>
		
		<cfquery name="getAdminLevels" datasource="#DSN#">
			SELECT *
			FROM admin_access_levels
			<cfif Session.AccessLevelID neq 1>
			WHERE AccessID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#"> 
			</cfif>
			ORDER BY AccessLevelDesc
		</cfquery>
		
		<tr>
		  <td height="18" colspan="11" class="bodyText"><strong>User List with priveleges
		      for this Access Level</strong></td>
	    </tr>
		<tr>
		  <td height="18" colspan="11" class="bodyText">
		  Access Level: <strong><cfoutput>#getUsers.AccessLevelDesc#</cfoutput></strong>
          </td>
	    </tr>
		<tr> 
          <td height="1" colspan="11" class="tdHorizDivider"></td>
        </tr>
		<tr> 
          <td height="25" align="center" nowrap class="tdBackGrnd"><strong>User Name</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>User Password</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Access Level</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>User Email</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Update</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Delete</strong></td>
        </tr>
        <cfoutput query="getUsers">
          <cfform action="adminUserList.cfm" method="post">
		  <input type="hidden" name="uid" value="#AdminID#">
		  <tr> 
            <td height="22" align="center" class="bodyText"><cfinput name="AdminName" type="text" value="#AdminName#" size="20" maxlength="20" required="yes" message="You must enter a User Name (please no spaces)" class="bodyText"></td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="bodyText"><cfinput name="AdminPwd" type="text" value="#AdminPwd#" size="15" maxlength="12" required="yes" message="You must enter a password for this user (please no spaces - maximum of 12 characters)" class="bodyText"></td>
            <td class="tdVertDivider" width="1"></td>
            <td align="center" class="bodyText">
			<select name="AdminLevelID" class="bodyText">
				<cfloop query="getAdminLevels">
					<cfif getAdminLevels.AccessID eq getUsers.AdminLevelID>
						<option value="#getAdminLevels.AccessID#" selected>#getAdminLevels.AccessLevelDesc#</option>
					<cfelse>
						<option value="#getAdminLevels.AccessID#">#getAdminLevels.AccessLevelDesc#</option>
					</cfif>
				</cfloop>
			</select>
			</td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="bodyText"><input name="AdminEmail" type="text" value="#AdminEmail#" size="25" maxlength="75" class="bodyText"></td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="bodyText"><input name="bUpdate" type="submit" class="tdHeader" id="bUpdate" value="Update"></td>
            <td width="1" class="tdVertDivider"></td>
            <td class="bodyText" align="center"><input name="bDelete" type="submit" class="tdHeader" id="bDelete" value="Remove"></td>
          </tr>
          <tr> 
            <td height="1" colspan="11" class="tdVertDivider"></td>
          </tr>
		  </cfform>
        </cfoutput>
		 <cfform action="adminUserList.cfm" method="post">
		 <tr> 
            <td height="22" align="center" class="adminAddNewTdBackGrnd"><cfinput name="AdminName" type="text" size="20" maxlength="20" required="yes" message="You must enter a User Name (please no spaces)" class="bodyText"></td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="adminAddNewTdBackGrnd"><cfinput name="AdminPwd" type="text" size="15" maxlength="12" required="yes" message="You must enter a password for this user (please no spaces - maximum of 12 characters)" class="bodyText"></td>
            <td class="tdVertDivider" width="1"></td>
            <td align="center" class="adminAddNewTdBackGrnd">
			<select name="AdminLevelID" class="bodyText">
				<cfoutput query="getAdminLevels">
				<option value="#AccessID#">#AccessLevelDesc#</option>
				</cfoutput>
			</select>
			</td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="adminAddNewTdBackGrnd">
              <input name="AdminEmail" type="text" size="25" maxlength="75" class="bodyText">
			</td>
            <td width="1" class="tdVertDivider"></td>
            <td colspan="3" align="center" class="adminAddNewTdBackGrnd"><input name="bAdd" type="submit" class="tdHeader" id="bAdd" value="Add New User"></td>
         </tr>
		 </cfform>
		</table></td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
