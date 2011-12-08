<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Template Information:	   Prepare for broadcast by choosing subscribers to send message to and choose message to broadcast
Date Created:              November 15, 2003
Date Last Modified:        January 12, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Email List Manager: Prepare Broadcast</title>
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

<cfif IsDefined("bSubGroup") AND IsDefined("Group")>
	
	<cfif Group eq 0>
		<!--- All subscribers for list --->	
		<cfquery name="qSubscriberGroup" datasource="#DSN#">
			SELECT *
			FROM email_addresses
			WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
		 </cfquery>
	<cfelse>
		<cfquery name="qSubscriberGroup" datasource="#DSN#">
			SELECT *
			FROM email_list_groups_members
			WHERE email_list_groups_members.GMGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Group#">
		 </cfquery>
	 </cfif>
	 
<cfelse>
	<!--- Get first group member recordset --->
	<cfquery name="qCurrentGroups" datasource="#DSN#">
		SELECT *
		FROM email_list_groups		
		WHERE ListID = #lid#
		ORDER BY GroupDesc
	</cfquery>
	<cfif qCurrentGroups.RecordCount gte 1>
		<cfoutput query="qCurrentGroups" maxrows="1">
			<cfset Group = qCurrentGroups.GroupID>
			<cfquery name="qSubscriberGroup" datasource="#DSN#">
				SELECT *
				FROM email_list_groups_members
				WHERE email_list_groups_members.GMGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCurrentGroups.GroupID#">
			</cfquery>
		</cfoutput>
	<cfelse>
		<!--- All subscribers for list --->	
		<cfset Group = 0>
		<cfquery name="qSubscriberGroup" datasource="#DSN#">
			SELECT *
			FROM email_addresses
			WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
		 </cfquery>
	</cfif>
</cfif>
<cfoutput>
	<cfset session.messageTotalCount = qSubscriberGroup.RecordCount>
	<cfset session.messageSentCount = 0>
	<cfset session.messageSentCountPBarLocal = 0>
	<cfset session.BatchStart = 1>
</cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="180" valign="top">
      <cfinclude template="globals/_navSidebar.cfm">
    </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr align="left">
        	<td colspan="17"><img src="images/maillist-broadcast-step-1.gif" alt="Broadcast step 1" width="206" height="29"></td>
        </tr>
        
		<tr align="left" bgcolor="#E7E7CF">
		  <td height="25" colspan="17" class="bodyText"><strong>Select the group of
	      subscribers you wish to broadcast this message to:</strong></td>
		</tr>
		<!--- Using cfqueryparam gives a crazy error in 6.1 --->
		<cfquery name="qCurrentGroups" datasource="#DSN#">
			SELECT *
			FROM email_list_groups		
			WHERE ListID = #lid#
			ORDER BY GroupDesc
		</cfquery>
		<cfoutput>
		<form action="#cgi.script_name#" method="post">
		<input type="hidden" name="lid" value="#lid#">
		<input type="hidden" name="mid" value="#mid#">
		</cfoutput>
		<tr align="left">
		  <td height="25" colspan="17" bgcolor="#E7E7CF" class="bodyText">Previously
		    saved groups:
            <select name="Group" id="select" class="bodyText">
              		<option value="0">All Subscribers</option>			
				<cfoutput query="qCurrentGroups">
			  		<option value="#GroupID#" <cfif IsDefined('Group') AND Group eq GroupID>selected</cfif>>#GroupDesc#</option>
           		</cfoutput>		
            </select>
            <input name="bSubGroup" type="submit" class="buttonTestSend" id="bSubGroup" value="Retrieve group"> 
            <cfif IsDefined("qSubscriberGroup")>(<cfoutput>#qSubscriberGroup.RecordCount#</cfoutput> subscribers retrieved)</cfif></td>
	      </tr>
		  </form>
		  <tr>
			 <td colspan="17" class="bodyText"><hr size="1" noshade></td>
		  </tr>
          <tr align="left">
            <td height="30" colspan="17" valign="middle" class="bodyText"><img src="images/maillist-broadcast-step-2.gif" alt="Broadcast Step 2" width="206" height="29"></td>
          </tr>
          <tr align="left">
            <td height="25" colspan="17" valign="middle" bgcolor="#E7E7CF" class="bodyText"><strong>2.</strong> Select the message you wish to broadcast to your subscriber list
              from
              the menu below</td>
        </tr>
        <cfquery name="qMessageList" datasource="#DSN#">
			SELECT *
			FROM email_list_messages		
			WHERE MessageListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
			ORDER BY MessageCreateDate DESC
		</cfquery>
        
		<cfif IsDefined("qMessageList")>
		<form action="broadcast_sent.cfm?RequestTimeOut=<cfoutput>#globals.PageTimeout#</cfoutput>" method="post" onSubmit="popUpWindow('broadcast_progress_bar.cfm?session.messageSentCount=0&session.messageTotalCount=<cfoutput>#qSubscriberGroup.RecordCount#</cfoutput>', 'no', 'no', '50', '50', '410', '255')">
		<input type="hidden" name="lid" value="<cfoutput>#lid#</cfoutput>">
		<input type="hidden" name="Group" value="<cfoutput>#Group#</cfoutput>">
		<input type="hidden" name="nSCount" value="<cfoutput>#qSubscriberGroup.RecordCount#</cfoutput>">
		<tr align="left" bgcolor="#E7E7CF">
            <td height="25" colspan="17" valign="middle" class="bodyText"><strong>Message
            Name</strong>: 
            <select name="mid" id="mid" class="bodyText">
              <cfoutput query="qMessageList">
			   <option value="#MessageID#" <cfif IsDefined('mid') AND mid eq MessageID>selected</cfif>>#MessageName# [#DateFormat(MessageCreateDate, globals.DateDisplay)#]</option>
			  </cfoutput>
            </select>
			</td>
          </tr>
		  </cfif>
          <tr align="left">
            <td height="30" colspan="17" valign="middle" class="bodyText"><hr size="1" noshade></td>
          </tr>
          <tr align="left">
            <td height="30" colspan="17" valign="middle" class="bodyText"><img src="images/maillist-broadcast-step-3.gif" alt="Broadcast Step 3" width="206" height="29"></td>
          </tr>
          <cfif IsDefined("qSubscriberGroup") AND qSubscriberGroup.RecordCount gte 1 AND IsDefined("qMessageList") AND qMessageList.RecordCount gte 1>
		  <tr align="left" bgcolor="#D6D6AB">
            <td height="30" colspan="17" valign="middle" class="bodyText"><strong>3.
                Once you have your group of subscribers selected and your message
                selected,
              simply click the button below to broadcast this message<br>
              3a. Send Messages in batches of 
              <input name="BatchAmount" type="text" id="BatchAmount" value="<cfoutput>#qSubscriberGroup.RecordCount#</cfoutput>" size="8" maxlength="6" class="bodyText">
              messages, with 
              <input name="BatchInterval" type="text" id="BatchInterval" value="1" size="5" maxlength="6" class="bodyText">
              seconds interval between each batch (useful for
              busy servers)</strong></td>
          </tr>
          <tr align="left" bgcolor="#D6D6AB">
            <td height="30" colspan="17" valign="middle" class="bodyText">
			<input name="bSendMessage" type="submit" class="tdHeader" id="bSendMessage" value="Broadcast Message">
			</td>
          </tr>
		  </form>
		  </cfif>
          <tr bgcolor="White">
            <td height="8" colspan="17" align="center" valign="middle" class="bodyText"><img src="images/spacer_white.gif" width="8" height="8"></td>
        </tr>
          <tr>
            <td height="18" colspan="17" align="center" valign="middle" bgcolor="#FFE9D2" class="bodyText"><img src="../images/help_Animated.gif" width="10" height="10" align="absmiddle"> [<a href="javascript:popUpWindow('../docs/subscriberAdmin.htm', 'yes', 'yes', '50', '50', '650', '475')">click
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
