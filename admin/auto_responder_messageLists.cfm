<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              August 15, 2003
Date Last Modified:        December 11, 2003
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
<cfparam name="View" default="">

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
		<!--- Save new Auto Responder Message --->
		<cfif IsDefined("bSaveAR") AND bSaveAR eq "Save Message">
		 <!--- <cftry> --->
			<cfscript>
				MessageMultiPart = 1;
			
				if ( IsDefined("ResponseType") AND ResponseType eq "subscribe" ) {
					SubscribeRequest = 1;
					UnsubscribeRequest = 0;
				}
				else {
					SubscribeRequest = 0;
					UnsubscribeRequest = 1;
				}
			</cfscript>
			
			<cflock name="saveARMsg" type="exclusive" timeout="30">
				<cfquery name="qSaveARMessage" datasource="#DSN#">
				INSERT INTO auto_responder_messages (MessageListID, MessageTempID, MessageName, MessageSubject, MessageTXT, MessageHTML, MessageMultiPart, SubscribeRequest, UnsubscribeRequest)
				VALUES (#lid#, #tempID#, '#MessageName#', '#MessageSubject#', '#MessageTXT#', '#MessageHTML#', #MessageMultiPart#, #SubscribeRequest#, #UnsubscribeRequest#)
				</cfquery>
				
				<cfquery name="qGetARMessage" datasource="#DSN#">
				SELECT *
				FROM auto_responder_messages
				WHERE MessageTempID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Trim(tempID)#">
				</cfquery>

			</cflock>
			
			<!--- Upload and record attachment --->
			<cfif Len(Trim(attachmentFileField)) eq 0>
				<!--- no attachment received no action required --->
			
			<cfelseif Trim(attachmentFileField) gte "2">
			  <cfif IsDefined("globals.cffileEnabled") AND globals.cffileEnabled eq 1>
				<cfscript>
					currPath = ExpandPath("*.*");
					tempCurrDir = GetDirectoryFromPath(currPath) & "attachments";
					if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { trailingSlash = '\'; }
					else { trailingSlash = '/'; }
					if ( globals.cfmxInstalled eq 1 ) {
						currDir = tempCurrDir;
					}
					else {
						currDir = tempCurrDir & trailingSlash;
					}
					currUserIP = #CGI.REMOTE_ADDR#;
				</cfscript>
				<cffile action="upload" destination="#currDir#" filefield="attachmentFileField" nameconflict="makeunique">
			
					<cfoutput>
					<span class="bodyText">You uploaded the file <strong>#File.ClientFileName#.#File.ClientFileExt#</strong> 
					successfully (type: #File.ContentType#).</span><br>
						<cfset attachmentFileName = #serverFile#>
						<cfset attachmentFileSize = #File.FileSize#>		
					</cfoutput>
				<!--- Add info to database --->
				<cfquery name="uploadAttachment" datasource="#DSN#">
					INSERT INTO auto_responder_attachments (AttachmentFileName, AttachmentFileSize, UploadedByUser, UploadIP, MessageID, ListID)
					VALUES ('#Trim(AttachmentFileName)#', #attachmentFileSize#, '#Session.UserName#', '#currUserIP#', #qGetARMessage.MessageID#, #lid#)
				</cfquery>
			  </cfif>
			<cfelse>
				<!--- no attachment received no action required possibly badly named attachment --->
			
			</cfif>
			<!--- Upload and record attachment close --->
			
			<!--- <cfoutput query="getMessage" maxrows="1">
				<cflocation url="messageUpdate.cfm?mid=#MessageID#&lid=#MessageListID#" addtoken="no">
			</cfoutput> --->
		
		<tr>
			<td height="25" colspan="13" align="center">
			<span class="adminUpdateSuccessful">* New Auto Responder message has been saved
			</span>
			</td>
		</tr>
		<!---  <cfcatch type="any"> .. There was an error saving your Auto Responder message - this action failed</cfcatch>
		 </cftry> --->
        <cfelseif IsDefined("act") AND act eq "Delete">
				<cfquery name="qAttachCheckForDeletion" datasource="#DSN#">
				  SELECT recID FROM auto_responder_attachments
				  WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
				</cfquery>
		  		<cfif qAttachCheckForDeletion.RecordCount gte 1>
					<cfset attachDelFlag = ValueList(qAttachCheckForDeletion.recID, ",")>
				</cfif>
				<cfquery name="removeMessage" datasource="#DSN#">
				DELETE
				FROM auto_responder_attachments
				WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
				</cfquery>
				
				<!--- Remove attachments for deletion --->
				<cfif IsDefined("qAttachCheckForDeletion") AND ListLen(attachDelFlag) gte 1>
				  
				  <cfloop from="1" to="#ListLen(attachDelFlag)#" index="i">
				  
					<cfset currAttachID = ListGetAt(attachDelFlag, i, ",")>	
					<cfquery name="locateAttachment" datasource="#DSN#">
						SELECT * FROM auto_responder_attachments WHERE recID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currAttachID#">
					</cfquery>
					<cfif locateAttachment.RecordCount eq 1>
						<cfquery name="removeAttachment" datasource="#DSN#">
							DELETE FROM auto_responder_attachments WHERE recID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currAttachID#">
						</cfquery>
						<cfif IsDefined("globals.cffileEnabled") AND globals.cffileEnabled eq 1>
							<cfscript>
								currPath = ExpandPath("*.*");
								tempCurrDir = GetDirectoryFromPath(currPath) & "attachments";
								if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { trailingSlash = '\'; }
								else { trailingSlash = '/'; }
								currDir = tempCurrDir & trailingSlash;
								attachmentNameToDelete = #currDir# & #locateAttachment.AttachmentFileName#;
							</cfscript>
							<cfif FileExists(attachmentNameToDelete)>
								<cffile action = "delete" file = "#attachmentNameToDelete#">
							</cfif>
								<cfset fileDeleted = 1>
						<cfelse>
								<!--- Must manually remove the file yourself from the attachment directory --->
								<cfset fileDeleted = 0>
						</cfif>
					</cfif>
					
				  </cfloop>	
				
				<cfelse>
					<!--- No attachments for deletion --->
				</cfif>
				<!--- Remove attachments for deletion close --->
			
		<tr>
		  <td height="18" colspan="16" align="center"><span class="adminRemoveSuccessful">The selected Auto Responder Message has been removed from your archive</span></td>
	    </tr>
		<cfelse>
		</cfif>
		
		<cfquery name="getMessages" datasource="#DSN#">
			SELECT *
			FROM auto_responder_messages AR, email_lists L
			WHERE (AR.MessageListID = L.EmailListID)
			<cfif IsDefined("Session.AccessLevelDesc") AND Session.AccessLevelDesc eq "Administrator">
				<cfif IsDefined("lid") AND view neq "All">
					AND EmailListID = #lid#
				</cfif>
			<cfelse>
			AND EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
				<cfif IsDefined("lid") AND view neq "All">
					AND EmailListID = #lid#
				</cfif>
			</cfif>
			ORDER BY EmailListDesc, MessageCreateDate DESC
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
		  <td height="18" colspan="9" class="bodyText"><strong>Current Auto Responder Message List Archive</strong></td>
	    </tr>
        <tr>
		  <td height="25" colspan="9" class="bodyText">
			  (<cf_recordcountml
			part="recordcount"
			mystartrow="#mystartrow#"
			realstartrow="#realstartrow#"
			group="MessageID"
			mymaxrows="#maxRows#"
			rcitem="Message"
			cfmx="#cfmx#">) <br> <cf_recordcountml
			template="#cgi.script_name#"
			part="link"
			rcresults="#RCResults#"
			prevstart="#PrevStart#"
			nextstart="#NextStart#"
			realprevstart="#RealPrevStart#"
			realnextstart="#RealNextStart#"
			mymaxrows="#maxrows#"
			mymaxpages="#maxPages#"
			pagecount="#pagecount#"
			thispage="#thispage#" >
		  </td>
	    </tr>
		<cfoutput query="getMessages" group="MessageID" startrow="#realstartrow#" maxrows="#maxRows#"> 
		<cfif NOT IsDefined("currentListID") OR currentListID neq #getMessages.EmailListID#>
		<tr> 
            <td height="8" colspan="9"></td>
          </tr>
		<tr>
		  <td height="25" colspan="9" class="adminAddNewTdBackGrnd"><span class="bodyText"><strong>Subscription List:</strong> <strong>#getMessages.EmailListDesc#</strong> <a href="auto_responder_messageNew.cfm?lid=#getMessages.EmailListID#"><img src="../images/icon-new-doc.gif" alt="Click to create a new auto response message" width="15" height="15" border="0" align="absmiddle"></a> <a href="auto_responder_messageNew.cfm?lid=#getMessages.EmailListID#">Create
		    New Message</a></span></td>
	    </tr>
		<tr> 
          <td height="18" nowrap class="tdBackGrnd"><strong>Message Name</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Date Created</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Subscribe</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Un-Subscribe</strong></td>
          <td class="tdVertDivider" width="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Delete</strong></td>
        </tr>
        <tr> 
          <td height="1" colspan="9" class="tdHorizDivider"></td>
        </tr>
		</cfif>
		 <cfoutput>
		  <cfquery name="getMessageCount" datasource="#DSN#">
			SELECT COUNT(MessageID) AS msgCnt
			FROM email_list_messages_send_log
			WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MessageID#">
		  </cfquery>
		  <cfquery name="getStats" datasource="#DSN#">
		  SELECT MessageID FROM click_thru_stats
		  WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getMessages.MessageID#">
		  </cfquery>
		  <cfquery name="qAttachCheck" datasource="#DSN#">
		  SELECT recID FROM auto_responder_attachments
		  WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getMessages.MessageID#">
		  </cfquery>
          <tr> 
            <td height="18" nowrap class="bodyText"><a href="auto_responder_messageUpdate.cfm?mid=#MessageID#&lid=#getMessages.EmailListID#"><img src="../images/edit.gif" alt="Click to edit current Message" width="8" height="12" border="0" align="absmiddle">[
              Edit ]</a>#MessageName# <cfif qAttachCheck.RecordCount gte 1><img src="images/attachment.jpg" align="absmiddle"></cfif>
			</td>
            <td class="tdVertDivider" width="1"></td>
            <td align="center" class="bodyText">#DateFormat(MessageCreateDate, globals.DateDisplay)# (#TimeFormat(MessageCreateDate, globals.TimeDisplay)#)</td>
            <td class="tdVertDivider" width="1"></td>
            <td align="center" class="bodyText"><cfif SubscribeRequest eq 1><img src="../images/icon-check-box.gif" width="19" height="19">
            </cfif></td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" class="bodyText"><cfif UnsubscribeRequest eq 1><img src="../images/icon-check-box-red.gif" width="19" height="19">
            </cfif></td>
            <td width="1" class="tdVertDivider"></td>
            <td align="center" nowrap class="bodyText"> <a href="auto_responder_messageLists.cfm?act=delete&mid=#MessageID#&lid=#getMessages.EmailListID#&View=#View#" onClick="return confirm('Are you sure you wish to delete this message?')"><img src="../images/icon-delete-xp.gif" alt="Click to delete this message" width="22" height="19" border="0" align="absmiddle"></a>[ <a href="auto_responder_messageLists.cfm?act=delete&mid=#MessageID#&lid=#getMessages.EmailListID#" onClick="return confirm('Are you sure you wish to delete this message?')">Delete</a> ] </td>
          </tr>
          <tr> 
            <td height="1" colspan="9" class="tdVertDivider"></td>
          </tr>
		  </cfoutput>
		  <cfset currentListID = #getMessages.EmailListID#>
        </cfoutput>
		   <tr align="left"> 
            <td height="20" colspan="9" class="bodyText">
			<cf_recordcountml
			template="#cgi.script_name#"
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
