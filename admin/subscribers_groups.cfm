<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Template Information:	   Prepare for broadcast by choosing subscribers to send message to and choose message to broadcast
Date Created:              November 15, 2003
Date Last Modified:        December 5, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Email List Manager: Create Subscriber Groups within a List</title>
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
<cfparam name="bSearchReturned" default="0">

<cfif IsDefined("bSubSearch") AND IsDefined("subFilter")>
	<cfquery name="qSubscriberSearch" datasource="#DSN#">
    	SELECT *
        FROM email_addresses E
        WHERE E.ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
		AND (E.Active = 1 OR E.Active IS NULL)
			<cfif Len(Trim(subSearchTxt)) gt 0>
				<cfif subFilter eq "All">
				<cfelseif subFilter eq "Domain">
					AND EmailAddress LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#subSearchTxt#%">
				<cfelse>
					AND #subFilter# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#subSearchTxt#%">
				</cfif>
			</cfif>
     </cfquery>
	 
	 <cfif NOT IsDefined("PageNum")>
		 <!--- Reset Flag IncludeInBroadcast first --->
		 <cfquery name="qSubscriberFlagClear" datasource="#DSN#">
			UPDATE email_addresses
			SET IncludeInBroadcast = 0
		 </cfquery>
		 <!--- Flag all found as IncludeInBroadcast so can be potentially saved as a group --->
		 <cfquery name="qSubscriberSearchFlag" datasource="#DSN#">
			UPDATE email_addresses
			SET IncludeInBroadcast = 1
			WHERE email_addresses.ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
			AND (email_addresses.Active = 1 OR email_addresses.Active IS NULL)
			<cfif Len(Trim(subSearchTxt)) gt 0>
				<cfif subFilter eq "All">
				<cfelseif subFilter eq "Domain">
					AND EmailAddress LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#subSearchTxt#%">
				<cfelse>
					AND #subFilter# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#subSearchTxt#%">
				</cfif>
			</cfif>
		 </cfquery>
	 </cfif>

<cfelseif IsDefined("bRetrieveGroup") AND IsDefined("Group") AND NOT IsDefined("bUpdate")>
	
	 <cfquery name="qSubscriberGroup" datasource="#DSN#">
    	SELECT * FROM email_addresses E LEFT JOIN email_list_groups_members EGM ON (E.EmailID = EGM.GMEmailID)
        WHERE E.ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
		AND (E.Active = 1 OR E.Active IS NULL)
			AND EGM.GMGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Group#">
     </cfquery>
	 <cfquery name="qSubscriberGroupName" datasource="#DSN#">
    	SELECT *
        FROM email_list_groups
        WHERE GroupID = #Group#
     </cfquery>

<cfelseif IsDefined("bUpdateGroup") AND IsDefined("Group") AND NOT IsDefined("bUpdate")>
	<!--- /// Update group first /// --->
	<!--- Find matching members --->
		<!--- Reset Flag IncludeInBroadcast first --->
		<cfquery name="qSubscriberGroupInfo" datasource="#DSN#">
			SELECT *
			FROM email_list_groups
        	WHERE GroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Group#">
		 </cfquery>
		 <cfquery name="qSubscriberFlagClearReseed" datasource="#DSN#">
			UPDATE email_addresses
			SET IncludeInBroadcast = 0
		 </cfquery>
		 <!--- Flag all found as IncludeInBroadcast so can be potentially saved as a group --->
		 <cfquery name="qSubscriberSearchFlagReseed" datasource="#DSN#">
			UPDATE email_addresses
			SET IncludeInBroadcast = 1
			WHERE email_addresses.ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
			AND (email_addresses.Active = 1 OR email_addresses.Active IS NULL)
			<cfif Len(Trim(qSubscriberGroupInfo.subSearchTxt)) gt 0>
				<cfif qSubscriberGroupInfo.subFilter eq "All">
				<cfelseif qSubscriberGroupInfo.subFilter eq "Domain">
					AND EmailAddress LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#qSubscriberGroupInfo.subSearchTxt#%">
				<cfelse>
					AND #qSubscriberGroupInfo.subFilter# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#qSubscriberGroupInfo.subSearchTxt#%">
				</cfif>
			</cfif>
		 </cfquery>
		<!--- Delete current group members --->
		<cfquery name="qDeleteSubscriberGroupMembers" datasource="#DSN#">
			DELETE
			FROM email_list_groups_members
			WHERE GMGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Group#">
		</cfquery>
		<!--- Insert new members --->
		<cfquery name="qUpdateGroupTempID" datasource="#DSN#">
		  	UPDATE email_list_groups_tempholder
			SET tempGroupID = #Group#
			WHERE recID = 1
	 	</cfquery>
		<cfquery name="qAddGroupMembers" datasource="#DSN#">
			INSERT INTO email_list_groups_members  (GMEmailID, GMGroupID)
				SELECT email_addresses.EmailID, email_list_groups_tempholder.tempGroupID
				FROM email_addresses, email_list_groups_tempholder
				WHERE email_addresses.IncludeInBroadcast = 1
	    </cfquery>
	<!--- /// Retrieve updated group members /// --->
		 
<cfelseif IsDefined("bDeleteGroup") AND IsDefined("Group") AND NOT IsDefined("bUpdate")>
	
	<cfquery name="qDeleteSubscriberGroup" datasource="#DSN#">
    	DELETE
        FROM email_list_groups
        WHERE GroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Group#">
    </cfquery>
	<cfquery name="qDeleteSubscriberGroupMembers" datasource="#DSN#">
    	DELETE
        FROM email_list_groups_members
        WHERE GMGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Group#">
    </cfquery>
	 
<cfelse>
</cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="180" valign="top">
      <cfinclude template="globals/_navSidebar.cfm">
    </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif IsDefined("bUpdate") AND IsDefined("egmid")>
        <!--- Open Update subscriber information request --->
          <cfif IsDefined("IncludeInBroadcast")>
		  	<cfset IncludeInBroadcast = 1>
		  <cfelse>
		  	<cfset IncludeInBroadcast = 0>	
		  </cfif>
		  <cfif IncludeInBroadcast eq 0>
			  <cfquery name="qRemoveGroupMember" datasource="#DSN#">
			  DELETE FROM email_list_groups_members 
			  WHERE GMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#egmid#">
			  </cfquery>
			   <tr>
				 <td height="18" colspan="15" align="center"><span class="adminUpdateSuccessful">The
					selected Subscriber has been removed from this group</span></td>
			   </tr>
		   	   <!--- Update query --->
			   <cfquery name="qSubscriberGroup" datasource="#DSN#">
					SELECT *
					FROM email_addresses E JOIN email_list_groups_members EGM ON (E.EmailID = EGM.GMEmailID)
					WHERE E.ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
					AND (E.Active = 1 OR E.Active IS NULL)
						AND EGM.GMGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Group#">
				</cfquery>
				<cfquery name="qSubscriberGroupName" datasource="#DSN#">
					SELECT *
					FROM email_list_groups
					WHERE GroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Group#">
				 </cfquery>
	 
		   </cfif>
		<!--- Close Update subscriber information request --->
		<cfelseif IsDefined("bSaveGroup") AND Len(Trim(GroupDesc)) neq 0 AND IsDefined("lid")>
        <!--- Open save group request --->
		 <cflock name="lGroups" type="exclusive" timeout="30">
		  <cfquery name="qSaveGroup" datasource="#DSN#">
          INSERT INTO email_list_groups (GroupDesc, ListID, subFilter, subSearchTxt)
		  VALUES ('#GroupDesc#', #lid#, '#subFilter#', '#subSearchTxt#')
          </cfquery>
		  <cfquery name="qGroupID" datasource="#DSN#">
		  	SELECT MAX(GroupID) AS nGroupID FROM email_list_groups
		  </cfquery>
		  <cfquery name="qUpdateGroupTempID" datasource="#DSN#">
		  	UPDATE email_list_groups_tempholder
			SET tempGroupID = #qGroupID.nGroupID#
			WHERE recID = 1
		  </cfquery>
		  <cfquery name="qAddGroupMembers" datasource="#DSN#">
			INSERT INTO email_list_groups_members (GMEmailID, GMGroupID)
				SELECT email_addresses.EmailID, email_list_groups_tempholder.tempGroupID
				FROM email_addresses, email_list_groups_tempholder
				WHERE (email_addresses.IncludeInBroadcast = 1)
	      </cfquery>
		 </cflock> 
        <tr>
            <td height="18" colspan="15" align="center"><span class="adminUpdateSuccessful">The
                group <strong><cfoutput>#GroupDesc#</cfoutput></strong> has been saved</span>
			</td>
        </tr>
		<cfelse>
		</cfif>
		<!--- Close save group request --->
		
		<!--- Retrieve all available lists / based on admin level --->
		<cfquery name="qAvailableLists" datasource="#DSN#">
			SELECT *
			FROM email_lists
			<cfif IsDefined("Session.AccessLevelDesc") AND Session.AccessLevelDesc eq "Administrator">
			<cfelse>
			WHERE EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
			</cfif>
			ORDER BY EmailListDesc
		</cfquery>
		<!--- Close Retrieve all available lists / based on admin level --->
		<tr align="left">
        	<td colspan="15"><img src="images/maillist-broadcast-step-1.gif" alt="Broadcast step 1" width="206" height="29" name="step1">			</td>
        </tr>
		<tr align="left">
		  <td colspan="15" class="bodyText"><strong>Select the group of subscribers from this entire list of
		    active subscribers in 1 of 2 ways:</strong><br>
		    1a - Use the search form to locate a subset of subscribers you wish
		    to save as a subscriber group for later broadcast (or simply click
		    search button without any changes to select ALL
		    subscribers in this list)<br>
		    1b - Select form the pop-up menu a group you created already from
		    a previous search</td>
	    </tr>
        <tr align="left">
          <td height="25" colspan="15" bgcolor="#E7E7CF" class="bodyText"><strong>1a.</strong>            
		  Use the search form below to select either &quot;ALL&quot; subscribers
            in this list or a group of subscribers based on search criteria you
            enter</td>
        </tr>
        <cfoutput>
		<form action="subscribers_groups.cfm" method="post">
		<input type="hidden" name="lid" value="#lid#">
		<input type="hidden" name="bSearchReturned" value="1">
		</cfoutput>
		<tr align="left">
          <td height="25" colspan="15" bgcolor="#E7E7CF" class="bodyText">Search criteria:<br>
            <input name="subSearchTxt" type="text" id="subSearchTxt" size="25" maxlength="75" class="bodyText">
			<select name="subSearchOp1" id="subSearchOp1" class="bodyText">
            	<option value="contains">Contains</option>
				<option value="begins">Begins With</option>
				<option value="ends">Ends With</option>
				<option value="equal">Equals</option>
				<option value="not">Does not equal</option>
			</select>
			<select name="subFilter" id="subFilter" class="bodyText">
            	<option value="All">All Subscribers</option>
				<option value="City">City</option>
				<option value="State">State</option>
				<option value="ZipCode">Zipcode</option>
				<option value="Country">Country</option>
				<option value="FirstName">First Name</option>
				<option value="LastName">Last Name</option>
				<option value="Domain">Domain Name/Email</option>
				<cfoutput>
				<option value="Custom1"><cfif Len(globals.Custom1Name) neq 0>#globals.Custom1Name#<cfelse>Custom Field 1</cfif></option>
				<option value="Custom2"><cfif Len(globals.Custom2Name) neq 0>#globals.Custom2Name#<cfelse>Custom Field 2</cfif></option>
				<option value="Custom3"><cfif Len(globals.Custom3Name) neq 0>#globals.Custom3Name#<cfelse>Custom Field 3</cfif></option>
				<option value="Custom4"><cfif Len(globals.Custom4Name) neq 0>#globals.Custom4Name#<cfelse>Custom Field 4</cfif></option>
				<option value="Custom5"><cfif Len(globals.Custom5Name) neq 0>#globals.Custom5Name#<cfelse>Custom Field 5</cfif></option>
				</cfoutput>
			</select>
			<br>
			<select name="subSearchOp2" id="subSearchOp2" class="bodyText">
            	<option value="AND" selected>AND</option>
				<option value="or">OR</option>
			</select>
			<br>
			<input name="subSearchTxt2" type="text" id="subSearchTxt2" size="25" maxlength="75" class="bodyText">
            <select name="subSearchOp3" id="subSearchOp3" class="bodyText">
              <option value="contains">Contains</option>
              <option value="begins">Begins With</option>
              <option value="ends">Ends With</option>
              <option value="equal">Equals</option>
              <option value="not">Does not equal</option>
            </select>
            <select name="subFilter2" id="subFilter2" class="bodyText">
              <option value="All">All Subscribers</option>
              <option value="City">City</option>
              <option value="State">State</option>
              <option value="ZipCode">Zipcode</option>
              <option value="Country">Country</option>
              <option value="FirstName">First Name</option>
              <option value="LastName">Last Name</option>
              <option value="Domain">Domain Name/Email</option>
              <cfoutput>
                <option value="Custom1">
                <cfif Len(globals.Custom1Name) neq 0>
                  #globals.Custom1Name#
                    <cfelse>
                    Custom Field 1
                </cfif>
                </option>
                <option value="Custom2">
                <cfif Len(globals.Custom2Name) neq 0>
                  #globals.Custom2Name#
                    <cfelse>
                    Custom Field 2
                </cfif>
                </option>
                <option value="Custom3">
                <cfif Len(globals.Custom3Name) neq 0>
                  #globals.Custom3Name#
                    <cfelse>
                    Custom Field 3
                </cfif>
                </option>
                <option value="Custom4">
                <cfif Len(globals.Custom4Name) neq 0>
                  #globals.Custom4Name#
                    <cfelse>
                    Custom Field 4
                </cfif>
                </option>
                <option value="Custom5">
                <cfif Len(globals.Custom5Name) neq 0>
                  #globals.Custom5Name#
                    <cfelse>
                    Custom Field 5
                </cfif>
                </option>
              </cfoutput>
            </select>
            <br>
            <cfoutput query="qAvailableLists">
				<input type="checkbox" name="ListID" value="#EmailListID#" <cfif qAvailableLists.EmailListID eq lid>checked</cfif>>#EmailListDesc#
				<cfif qAvailableLists.CurrentRow neq qAvailableLists.RecordCount><br></cfif>
			</cfoutput>
            <br>
			<input type="submit" name="bSubSearch" value="search" class="buttonTestSend">
		  </td>
        </tr>
		</form>
		<tr align="left" bgcolor="#FFFFFF">
		  <td height="25" colspan="15" class="bodyText"> <strong>-- OR --</strong></td>
	    </tr>
		<tr align="left" bgcolor="#E7E7CF">
		  <td height="25" colspan="15" class="bodyText"><strong>1b.</strong> Select
		    from the pop-menu below a previously saved group to update members
		    of.</td>
		</tr>
		<!--- Using cfqueryparam gives a crazy error in 6.1 --->
		<cfquery name="qCurrentGroups" datasource="#DSN#">
			SELECT *
			FROM email_list_groups		
			WHERE ListID = #lid#
			ORDER BY GroupDesc
		</cfquery>
		<cfif qCurrentGroups.RecordCount gte 1>
			<cfoutput>
			<form action="#cgi.script_name#" method="post">
			<input type="hidden" name="lid" value="#lid#">
			</cfoutput>
			<tr align="left">
			  <td height="25" colspan="15" bgcolor="#E7E7CF" class="bodyText">Previously
				saved groups:
				<select name="Group" id="select" class="bodyText">
					<cfoutput query="qCurrentGroups">
						<option value="#GroupID#" <cfif IsDefined("Group") AND Group eq qCurrentGroups.GroupID>selected</cfif>>#GroupDesc#</option>
					</cfoutput>		
				</select>
				<input name="bRetrieveGroup" type="submit" class="buttonSearch" id="bRetrieveGroup" value="Retrieve Group">
				<img src="images/spacer_transparent.gif" width="10" height="5">
				<input name="bUpdateGroup" type="submit" class="buttonTestSend" id="bUpdateGroup" value="Update Group">
                <img src="images/spacer_transparent.gif" width="10" height="5">
                <input name="bDeleteGroup" type="submit" class="buttonDelete" id="bDeleteGroup" value="Delete Group" onClick="return confirm('Are you sure you wish to delete this group')"></td>
			</tr>
			</form>
		<cfelse>
			<tr>
			  <td height="25" colspan="15" bgcolor="White" class="bodyText" align="left">
			  No currently saved groups for this List
			  </td>
			</tr>
		</cfif>
        <!--- open show found subscriber group --->
		<cfif IsDefined("qSubscriberSearch") AND qSubscriberSearch.RecordCount gte 1>
			<tr>
			  <td colspan="15" class="bodyText"><hr size="1" noshade></td>
			</tr>
			<form action="<cfoutput>#cgi.script_name#</cfoutput>" method="post">
			<cfoutput>
			<input type="hidden" name="lid" value="#lid#">
			<input type="hidden" name="subFilter" value="#subFilter#">
			<input type="hidden" name="subSearchTxt" value="#subSearchTxt#">
			</cfoutput>
			<tr>
			  <td height="30" colspan="15" class="bodyText"><img src="../images/icon-save.gif" alt="Save the group" width="17" height="18" align="absbottom" name="saveicon"> Save
			    this filtered group of subscribers as: 
			    <input name="GroupDesc" type="text" class="bodyText" size="30" maxlength="50"> 
				<input type="submit" name="bSaveGroup" value="Save Group" class="bodyText">
				</td>
	  	  	</tr>
			</form>
			<tr align="left">
				<td height="30" colspan="15" valign="middle" class="bodyText"><hr size="1" noshade></td>
			</tr>
			<tr>
				<td colspan="15" valign="middle" class="bodyText"><cfinclude template="incl_subscriber_group_search_list.cfm"></td>
			</tr>
	    
		<cfelseif IsDefined("qSubscriberGroup") AND qSubscriberGroup.RecordCount gte 1>
			<tr>
				<td colspan="15" valign="middle" class="bodyText"><cfinclude template="incl_subscriber_group_saved_list.cfm"></td>
			</tr>
		<cfelse>
		</cfif>
		<!--- close show found subscriber group --->
        <tr bgcolor="White">
           <td height="8" colspan="15" align="center" valign="middle" class="bodyText"><img src="images/spacer_white.gif" width="8" height="8"></td>
        </tr>
          <tr>
            <td height="18" colspan="15" align="center" valign="middle" bgcolor="#FFE9D2" class="bodyText"><img src="../images/help_Animated.gif" width="10" height="10" align="absmiddle"> [<a href="javascript:popUpWindow('../docs/subscriberAdmin.htm', 'yes', 'yes', '50', '50', '650', '475')">click
            for help on using this screen</a>]</td>
          </tr>
      </table>
    </td>
  </tr>
  <tr align="center">
    <td colspan="3"><cfinclude template="globals/_Footer.cfm">
    </td>
  </tr>
</table>
</body>
</html>
