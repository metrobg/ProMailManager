<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        December 31, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>
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
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<cfparam name="Drill" default="0">
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top">
	<cfinclude template="globals/_navSidebar.cfm">
	<br><br>
      <table width="180" border="0" cellspacing="0" cellpadding="1" class="tdTipsHeader">
        <tr>
          <td>
            <table width="100%" border="0" cellpadding="3" cellspacing="0">
              <tr>
                <td height="20" align="center" background="images/gradient-bar-dark-blue.gif" class="tdTipsHeader"><strong>Time Saving Tips</strong></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF"><span class="bodyText"><img src="images/icon-help.gif" width="24" height="25"></span></td>
              </tr>
              <tr>
                <td height="1"></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF" class="bodyText"><span class="bodyText"><img src="../images/icon-broadcast-sent.gif" width="19" height="19" border="0" align="absmiddle"></span> <strong>-
                  Sent Message Log</strong></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF"><span class="bodyText">                  (When You see this icon <img src="../images/icon-broadcast-sent.gif" width="19" height="19" border="0" align="absmiddle"> Click
                  it to View a Send Log History for this message)</span></td>
              </tr>
              <tr>
                <td height="1"></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF" class="bodyText"><img src="../images/icon-message-copy.gif" width="18" height="16" align="absmiddle"> <strong>-
                Duplicate Message</strong></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF" class="bodyText">Click
                  this icon <img src="../images/icon-message-copy.gif" width="18" height="16" align="absmiddle"> to
                  make a copy of an existing message. (Use this feature to create
                  a new message based on an existing message you have set up
                  already!</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
	  <br>
	</td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td width="100%" valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif IsDefined("act")>
			<cfif act eq "Delete">
				<cfquery name="removeMessage" datasource="#DSN#">
				DELETE
				FROM email_list_messages
				WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
				</cfquery>
		<tr>
		  <td height="18" colspan="19" align="center"><span class="adminRemoveSuccessful">The selected Message has been removed from your archive</span></td>
	    </tr>
			<cfelseif act eq "Copy">
				<cfquery name="getMessage" datasource="#DSN#">
				SELECT *
				FROM email_list_messages
				WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
				</cfquery>
				<cfif getMessage.RecordCount eq 1>
				  <cfoutput query="getMessage" maxrows="1">
					<cfset tmpMessageName = #MessageName#&" "&"copy">
					<cfset tmptmpMessageNameLen = #Len(tmpMessageName)#>
					<cfif tmptmpMessageNameLen gt 75>
						<cfset tmpMessageName = Left(tmpMessageName, 75)>
						<cfset messageTruncated = 1>
					</cfif>
					<cfquery name="duplicateMessage" datasource="#DSN#">
					INSERT INTO email_list_messages (MessageListID, MessageName, MessageSubject, MessageTXT, MessageHTML, MessageMultiPart, MessageCreateDate)
					VALUES (#lid#, '#tmpMessageName#', 
                    '#MessageSubject#', 
                    <cfqueryparam value="#MessageTXT#" cfsqltype="cf_sql_clob">, 
                    <cfqueryparam value="#MessageHTML#" cfsqltype="cf_sql_clob">, 
                    #MessageMultiPart#, 
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
					</cfquery>
				  </cfoutput>
				</cfif>
		<tr>
		  <td height="18" colspan="19" align="center" class="adminUpdateSuccessful">The selected Message has been duplicated succesfully
			  <cfif IsDefined("messageTruncated") AND messageTruncated eq 1>
			  <br>
			  <font color="Red">** Please note your message name was longer then the allowed maximum length of 75 characters,
			  it has been truncated to the first 75 characters</font>
			  </cfif>
		  </td>
	    </tr>
			<cfelse>
			</cfif>	
		<cfelseif IsDefined("bSaveMessageCopy")>
				<cfquery name="getMessage" datasource="#DSN#">
				SELECT *
				FROM email_list_messages
				WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
				AND MessageListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lidOrig#">
				</cfquery>
				<cfif getMessage.RecordCount eq 1>
				  <cfoutput query="getMessage" maxrows="1">
					<cfset tmpMessageName = #MessageName#&" "&"copy">
					<cfquery name="duplicateMessage" datasource="#DSN#">
					INSERT INTO email_list_messages (MessageListID, MessageName, MessageSubject, MessageTXT, MessageHTML, MessageMultiPart, MessageCreateDate)
					VALUES (#EmailListID#, '#tmpMessageName#', '#MessageSubject#', '#MessageTXT#', '#MessageHTML#', #MessageMultiPart#, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
					</cfquery>
				  </cfoutput>
				</cfif>
		<tr>
		  <td height="18" colspan="19" align="center"><span class="adminUpdateSuccessful">
		  The selected Message has been copied to the selected list
		  </span></td>
	    </tr>
		
		<cfelseif IsDefined("bAddSchedule")>
				<!--- Add Message Schedule --->
				<cfscript>
					if ( Len(form.MSchedIntervalInt) gt 1 AND IsNumeric(form.MSchedIntervalInt) ) {
						strInterval = Trim(form.MSchedIntervalInt);
					}
					else {
						strInterval = form.MSchedInterval;
					}
					if ( Len(form.MSchedStartDate) eq 0 ) {
						strStartDate = #DateFormat(Now(), globals.DateDisplay)#;
					}
					else {
						strStartDate = #form.MSchedStartDate#;
					}
					if ( Len(form.MSchedStartTime) eq 0 ) {
						strStartTime = '2:00 AM';
					}
					else {
						strStartTime = #form.MSchedStartTime#;
					}
				</cfscript>
				
				<cfquery name="qAddSchedule" datasource="#DSN#">
				INSERT INTO email_list_messages_schedule (MSchedStartDate, MSchedStartTime, MSchedEndDate, MSchedEndTime, MSchedInterval, MSchedListID, MSchedGroupID, MSchedMessageID, MSchedActive)
				VALUES ('#strStartDate#', '#strStartTime#', '#MSchedEndDate#', '#MSchedEndTime#', '#MSchedInterval#', #lid#, #MSchedGroupID#, #mid#, 1)
				</cfquery>
				<cfquery name="qScheduleID" datasource="#DSN#">
					SELECT MAX(MsgScheduleID) AS nSchedID FROM email_list_messages_schedule
				</cfquery>
				<cfschedule action = "update"
				   task = "Email List Manager: Message Schedule #qScheduleID.nSchedID#" 
				   operation = "HTTPRequest"
				   url = "#globals.localServerAddress#admin/_message_broadcast_scheduled.cfm?mid=#mid#&lid=#lid#&Group=#MSchedGroupID#&nSCount="
				   startdate = "#strStartDate#"
				   starttime = "#strStartTime#" 
				   enddate="#MSchedEndDate#" 
				   endtime="#MSchedEndTime#"
				   interval = "#strInterval#"
				   publish = "No"
				   requesttimeout = "600">
				   
				
		<tr>
		  <td height="18" colspan="19" align="center"><span class="adminUpdateSuccessful">
		  Message Schedule has been updated
		  </span></td>
	    </tr>
		
		<cfelseif IsDefined("bUpdateSchedule")>
				<!--- Update Message Schedule --->
				<cfscript>
					if ( Len(form.MSchedIntervalInt) gt 1 AND IsNumeric(form.MSchedIntervalInt) ) {
						strInterval = Trim(form.MSchedIntervalInt);
					}
					else {
						strInterval = form.MSchedInterval;
					}
					if ( Len(form.MSchedStartDate) eq 0 ) {
						strStartDate = #DateFormat(Now(), globals.DateDisplay)#;
					}
					else {
						strStartDate = #form.MSchedStartDate#;
					}
					if ( Len(form.MSchedStartTime) eq 0 ) {
						strStartTime = '2:00 AM';
					}
					else {
						strStartTime = #form.MSchedStartTime#;
					}
				</cfscript>
				
				<cfquery name="qAddSchedule" datasource="#DSN#">
				UPDATE email_list_messages_schedule 
					SET MSchedStartDate = '#strStartDate#', 
					MSchedStartTime = '#strStartTime#', 
					MSchedEndDate = '#form.MSchedEndDate#', 
					MSchedEndTime = '#form.MSchedEndTime#', 
					MSchedInterval = '#strInterval#', 
					MSchedListID = #form.lid#, 
					MSchedGroupID = #form.MSchedGroupID#, 
					MSchedMessageID = #form.mid#, 
					MSchedActive = #form.MSchedActive#
					WHERE MsgScheduleID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MsgScheduleID#">
				</cfquery>
				
				<cfif form.MSchedActive eq 1>
					<cfschedule action = "update"
					   task = "Email List Manager: Message Schedule #form.MsgScheduleID#" 
					   operation = "HTTPRequest"
					   url = "#globals.localServerAddress#admin/_message_broadcast_scheduled.cfm?mid=#form.MsgScheduleID#&lid=#form.lid#&Group=#form.MSchedGroupID#&nSCount="
					   startdate = "#strStartDate#"
					   starttime = "#strStartTime#" 
					   enddate="#form.MSchedEndDate#" 
					   endtime="#form.MSchedEndTime#"
					   interval = "#strInterval#"
					   publish = "No"
					   requesttimeout = "600">
				<cfelse>
					<cfschedule 
					action = "delete"
				   	task = "Email List Manager: Message Schedule #form.MsgScheduleID#" 
				   	>
				   
				</cfif>
				   
				
		<tr>
		  <td height="18" colspan="19" align="center"><span class="adminUpdateSuccessful">
		  Message Schedule has been updated
		  </span></td>
	    </tr>
		
		<cfelseif IsDefined("bDeleteSchedule")>
				<!--- Delete Message Schedule --->
				
				<cfquery name="qDelSchedule" datasource="#DSN#">
				DELETE FROM email_list_messages_schedule WHERE MsgScheduleID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MsgScheduleID#">
				</cfquery>
				
				<cfschedule 
					action = "delete"
				   	task = "Email List Manager: Message Schedule #form.MsgScheduleID#" 
				   >
				   
				
		<tr>
		  <td height="18" colspan="19" align="center"><span class="adminRemoveSuccessful">
		  Message Schedule has been deleted
		  </span></td>
	    </tr>
		
		<cfelseif IsDefined("bScheduleRunNow") AND bScheduleRunNow eq 1>
				<!--- Run Message Schedule --->
				
				<cfschedule 
					action = "run"
				   	task = "Email List Manager: Message Schedule #MsgScheduleID#" 
				   >
				   
				
		<tr>
		  <td height="18" colspan="19" align="center"><span class="adminUpdateSuccessful">
		  Message Schedule has been set to run immediately ...
		  </span></td>
	    </tr>
		
		<cfelseif IsDefined("bDeleteStats")>
				<!--- Delete Message Click Thru Stats --->
				
				<cfquery name="qDelStats" datasource="#DSN#">
				DELETE FROM click_thru_stats
				WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
				</cfquery>
				   		
		<tr>
		  <td height="18" colspan="19" align="center"><span class="adminRemoveSuccessful">
		  Click Thru Statistics for this message have been deleted
		  </span></td>
	    </tr>
		
		<cfelse>
		</cfif>
		<cfquery name="getMessages" datasource="#DSN#">
			SELECT *
			FROM email_list_messages, email_lists		
			WHERE (email_list_messages.MessageListID = email_lists.EmailListID)
			<cfif IsDefined("Session.AccessLevelDesc") AND Session.AccessLevelDesc eq "Administrator">
			<cfelse>
			AND EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
			</cfif>
			<cfif IsDefined("lid")>
			AND EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
			</cfif>
			ORDER BY EmailListID, MessageCreateDate DESC
		</cfquery>
		<!--- RecordCount --->
		<cfparam name="mystartrow" default="1">
		<cfparam name="realstartrow" default="1">
		<cfparam name="maxPages" default="#globals.messageLists_MaxPages#">
		<cfparam name="maxRows" default="#globals.messageLists_MaxRows#">
		<cfparam name="cfmx" default="#globals.cfmxInstalled#">
		<cfset request.RCQuery = getMessages>
		<cfset currentGroupID = 0>
		<tr>
		  <td height="18" colspan="19" class="bodyText"><strong>Current Message List Archive</strong></td>
	    </tr>
        <tr>
		  <td height="25" colspan="19" class="bodyText">
			  (<cf_recordcountml
			part="recordcount"
			mystartrow="#mystartrow#"
			realstartrow="#realstartrow#"
			group="MessageID"
			mymaxrows="#maxRows#"
			rcitem="Message"
			cfmx="#cfmx#">) <br> <cf_recordcountml
			template="messageLists.cfm"
			part="link"
			rcresults="#RCResults#"
			prevstart="#PrevStart#"
			nextstart="#NextStart#"
			realprevstart="#RealPrevStart#"
			realnextstart="#RealNextStart#"
			mymaxrows="#maxrows#"
			mymaxpages="#maxPages#"
			pagecount="#pagecount#"
			thispage="#thispage#">
		  </td>
	    </tr>
		<cfoutput query="getMessages" group="MessageID" startrow="#realstartrow#" maxrows="#maxRows#"> 
		<cfif NOT IsDefined("currentListID") OR currentListID neq #getMessages.EmailListID#>
		<tr> 
            <td height="8" colspan="19"></td>
          </tr>
		<tr>
		  <td height="25" colspan="19" class="adminAddNewTdBackGrnd"><span class="bodyText"><strong><img src="../images/icon-list.gif" width="15" height="15" align="absbottom">Subscription List:</strong> <strong>#getMessages.EmailListDesc#</strong> <a href="messageNew.cfm?lid=#getMessages.EmailListID#"><img src="../images/icon-new-message.gif" alt="Click to create a new message" width="17" height="18" border="0" align="absmiddle"></a> <a href="messageNew.cfm?lid=#getMessages.EmailListID#">Create
		    New Message</a></span></td>
	    </tr>
		<tr>
		  <td nowrap class="tdBackGrnd">&nbsp;</td> 
          <td height="18" nowrap class="tdBackGrnd"><strong>Message Name</strong></td>
          <td align="left" class="tdBackGrnd"><img src="../images/copyIconBlack.gif" width="12" height="15"></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Date Created</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Sent
            Count</strong><font color="##CCCCCC">&nbsp;</font></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Click Thru <br>
            Stats</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Broadcast</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Scheduled</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>HTML <br>
            Content</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Text <br>
            Content</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Delete</strong></td>
        </tr>
        <tr> 
          <td height="1" colspan="19" class="tdHorizDivider"></td>
        </tr>
		</cfif>
		  <cfquery name="getMessageCount" datasource="#DSN#">
			SELECT COUNT(MessageID) AS msgCnt
			FROM email_list_messages_send_log
			WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MessageID#">
		  </cfquery>
		  <cfquery name="getStats" datasource="#DSN#">
		  SELECT MessageID FROM click_thru_stats
		  WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getMessages.MessageID#">
		  </cfquery>
		  <cfquery name="attachCheck" datasource="#DSN#">
		  SELECT recID FROM attachments
		  WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getMessages.MessageID#">
		  </cfquery>
		  <cfquery name="qScheduleCheck" datasource="#DSN#">
		  SELECT COUNT(MsgScheduleID) AS nSchedules FROM email_list_messages_schedule
		  WHERE MSchedMessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getMessages.MessageID#">
		  </cfquery>
          <tr>
            <td nowrap class="bodyText">
			<cfif (IsDefined("mid") AND mid eq MessageID) AND (Drill eq 1)>
                	<a href="#cgi.script_name#?mid=#MessageID#&lid=#getMessages.EmailListID#&Drill=0"><img src="../images/icon-arrow-down.gif" alt="View more options" width="17" height="12" border="0"></a>
            <cfelse>
                 	<a href="#cgi.script_name#?mid=#MessageID#&lid=#getMessages.EmailListID#&Drill=1" title="Click to view more options"><img src="../images/icon-arrow-right.gif" alt="View more options" width="12" height="17" border="0"></a>
            </cfif>
			</td> 
            <td height="18" nowrap class="bodyText"><a href="messageUpdate.cfm?mid=#MessageID#&lid=#getMessages.EmailListID#"><img src="../images/edit.gif" alt="Click to edit current Message" width="8" height="12" border="0" align="absmiddle">[
              Edit ]</a>#MessageName# <cfif attachCheck.RecordCount gte 1><img src="images/attachment.jpg" align="absmiddle"></cfif>
			</td>
            <td align="center" class="bodyText"><a href="messageLists.cfm?act=copy&lid=#getMessages.EmailListID#&mid=#MessageID#"><img src="../images/icon-message-copy.gif" width="18" height="16" border="0" align="absmiddle"></a></td>
            <td class="tdVertDivider" width="1"></td>
            <td align="center" class="bodyText">#DateFormat(MessageCreateDate, globals.DateDisplay)# (#TimeFormat(MessageCreateDate, globals.TimeDisplay)#)</td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" nowrap class="bodyText"><font color="##990000"> [ #getMessageCount.msgCnt# ] <cfif getMessageCount.msgCnt gte 1><a href="javascript:popUpWindow('sentMessageLog.cfm?mid=#MessageID#', 'yes', 'yes', '50', '50', '550', '400')"><img src="../images/icon-broadcast-sent.gif" alt="Click to view Log of sent date/s and time/s" width="19" height="19" border="0" align="absmiddle"></a>
                  <cfelse><img src="../images/spacer_white.gif" width="12" height="15" border="0" align="absmiddle"></cfif></font></td>
            <td class="tdVertDivider" width="1"></td>
            <td align="center" class="bodyText"><cfif getStats.RecordCount neq 0>
            <a href="messageStats.cfm?mid=#MessageID#"><img src="../images/clickThruStats.gif" alt="Click to view click through statistics for this message" width="19" height="22" border="0"></a>
                <img src="../images/spacer_transparent.gif" width="5" height="5"><a href="messageLists.cfm?bDeleteStats=1&mid=#MessageID#" onClick="return confirm('!! THIS WILL RENDER ALL PREVIOUS BROADCASTS OF THIS MESSAGE TO SUBSCRIBERS USELESS!, Are you sure you want to delete click thru stats for this message - this is not reversible?')"><img src="../images/deleteDocIcon.gif" alt="Delete all Stats for this message" width="12" height="15" border="0"></a>
                <cfelse><img src="../images/clickThruStats_None.gif" width="22" height="20" border="0"></cfif></td>
            <td class="tdVertDivider" width="1"></td>
            <td align="center" nowrap class="bodyText"><a href="broadcast_prepare.cfm?lid=#getMessages.EmailListID#&mid=#MessageID#"><img src="../images/icon-trigger-broadcast.gif" alt="Broadcast this message" width="19" height="19" border="0"></a></td>
            <td class="tdVertDivider" width="1"></td>
            <td align="center" nowrap class="bodyText"><cfif qScheduleCheck.nSchedules gte 1>
            <img src="../images/icon-schedule-date.gif" alt="Active Schedule/s for this message" width="16" height="16" align="absbottom">
            <cfelse><img src="../images/icon-schedule-date-inactive.gif" alt="No Active Schedule/s for this message" width="16" height="16" align="absbottom">
            </cfif> (#qScheduleCheck.nSchedules#)</td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="bodyText"><cfif Len(MessageHTML) neq 0><img src="../images/icon-check-box.gif" width="19" height="19">
            </cfif></td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="bodyText"><cfif Len(MessageTXT) neq 0><img src="../images/icon-check-box.gif" width="19" height="19">
            </cfif></td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" nowrap class="bodyText"> <a href="messageLists.cfm?act=delete&mid=#MessageID#&lid=#getMessages.EmailListID#" onClick="return confirm('Are you sure you wish to delete this message?')"><img src="../images/icon-delete-xp.gif" alt="Click to delete this message" width="22" height="19" border="0" align="absmiddle"></a>[ <a href="messageLists.cfm?act=delete&mid=#MessageID#&lid=#getMessages.EmailListID#" onClick="return confirm('Are you sure you wish to delete this message?')">Delete</a> ] </td>
          </tr>
          <cfif (IsDefined("mid") AND mid eq MessageID) AND (Drill eq 1)>
		  <!--- Open Show Messages schedule --->
		  <tr> 
            <td></td>
			<td colspan="18"><cfinclude template="incl_message_schedule.cfm"></td>
		  </tr>
		  <!--- Close Show Messages schedule --->
		  <cfelse>
		  <tr> 
            <td height="1" colspan="19" class="tdVertDivider"></td>
          </tr>
		  </cfif>
		  <cfset currentListID = #getMessages.EmailListID#>
        </cfoutput>
		   <tr align="left"> 
            <td height="20" colspan="19" class="bodyText">
			<cf_recordcountml
			template="messageLists.cfm"
			part="link"
			rcresults="#RCResults#"
			prevstart="#PrevStart#"
			nextstart="#NextStart#"
			realprevstart="#RealPrevStart#"
			realnextstart="#RealNextStart#"
			mymaxrows="#maxrows#"
			mymaxpages="#maxPages#"
			pagecount="#pagecount#"
			thispage="#thispage#">			
			</td>
        </tr>
	  </table>
    </td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
