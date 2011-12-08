<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.andrewkelly.com
Contact Information:       http://www.andrewkelly.com/contact
Date Created:              January 4, 2003
Date Last Modified:        November 20, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Groups</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>
<cfif Session.AccessLevelID neq 1>
	<cflocation url="index.cfm" addtoken="no"> 
</cfif>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
  <cfif IsDefined("bUpdate")>
		<cfquery name="updateAdminGroup" datasource="#DSN#">
			UPDATE admin_access_levels
			SET AccessLevelDesc = '#AccessLevelDesc#'
			WHERE AccessID = <cfqueryparam cfsqltype="cf_sql_integer" value="#AccessID#">
		</cfquery>  
  <cfelseif IsDefined("bAdd")>
		<cfquery name="getAccessDesc" datasource="#DSN#">
		SELECT AccessLevelDesc
		FROM  admin_access_levels
		WHERE AccessLevelDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AccessLevelDesc#">
		</cfquery>
	   <cfif getAccessDesc.RecordCount eq 0>	
		<cfquery name="getID" datasource="#DSN#">
		SELECT MAX(AccessID) AS lastID
		FROM  admin_access_levels
		</cfquery>
		<cfset newID = ( #Val(getID.lastID)# + 1 )>
		<cfquery name="addAdminGroup" datasource="#DSN#">
			INSERT INTO admin_access_levels (AccessID, AccessLevelDesc)
			VALUES (#newID#, '#AccessLevelDesc#')
		</cfquery>
	   </cfif>
  <cfelseif IsDefined("bDelete")>
		<cfquery name="delAdminGroup" datasource="#DSN#">
			DELETE FROM admin_access_levels
			WHERE AccessID = <cfqueryparam cfsqltype="cf_sql_integer" value="#AccessID#">
		</cfquery>
  <cfelse>
  </cfif>
	<cfquery name="adminGroups" datasource="#DSN#">
		SELECT *
		FROM  admin_access_levels
	</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm"> </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td width="100%" valign="top"><cfinclude template="globals/_navHeader.cfm">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="20" colspan="4" class="adminAddNewTdBackGrnd"><span class="bodyText"><strong>List Administration Group Menu</strong></span></td>
    </tr>
  <tr>
    <td colspan="4" valign="top" class="bodyText"><em>Instructions</em>: <br>
  You can create as many Administration Groups as you need, but remember,
        users will only be able to access Subscription Lists that have been set
        to the Administration Group that the user is a part of!</td>
    </tr>
  <tr>
    <td height="1" colspan="4" class="tdHorizDivider"></td>
  </tr>
  <tr>
    <td height="22" class="tdBackGrnd"><strong>Group Name</strong></td>
    <td align="center" class="tdBackGrnd"><strong>Group Members</strong></td>
    <td align="center" class="tdBackGrnd"><strong>Update</strong></td>
    <td align="center" class="tdBackGrnd"><strong>Remove</strong></td>
  </tr>
  <cfoutput query="adminGroups">
    <cfquery name="numInGroup" datasource="#DSN#">
		SELECT COUNT(AdminID) AS userCount
		FROM  admin
		WHERE AdminLevelID = #adminGroups.AccessID#
	</cfquery>
  <cfform action="adminGroupList.cfm" method="post">
  <input type="hidden" name="AccessID" value="#AccessID#">
  <tr>
    <td height="22" class="bodyText">
	 <cfif AccessLevelDesc eq "Administrator">
	 	#AccessLevelDesc# <font color="Red">[Locked - Not changeable]</font>
	 <cfelse>	
		<cfinput name="AccessLevelDesc" type="text" value="#AccessLevelDesc#" size="45" maxlength="50" required="yes" message="Please enter a group name" class="bodyText">
	 </cfif>
	</td>
    <td align="center" class="bodyText">#numInGroup.userCount#</td>
    <td align="center">
		<cfif AccessLevelDesc eq "Administrator">
		<cfelse>
		<input name="bUpdate" type="submit" class="tdHeader" id="bUpdate" value="Update">
		</cfif>
		</td>
    <td align="center">
		<cfif AccessLevelDesc eq "Administrator">
		<cfelse>
		<input name="bDelete" type="submit" class="tdHeader" id="bDelete" value="Delete">
		</cfif>
	</td>
  </tr>
  <tr>
    <td height="1" colspan="4" class="tdHorizDivider"></td>
  </tr>
  </cfform>
  </cfoutput>
  <tr>
    <td height="8" colspan="4"><img src="../images/spacer_white.gif" width="5" height="8"></td>
    </tr>
  <cfform action="adminGroupList.cfm" method="post">
  <tr>
    <td height="22"><cfinput name="AccessLevelDesc" type="text" size="45" maxlength="50" required="yes" message="Please enter a group name" class="bodyText"></td>
    <td colspan="3" align="center"><input name="bAdd" type="submit" class="tdHeader" id="bAdd" value="Add New Group"></td>
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
