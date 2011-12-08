<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        January 6, 2004
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!--- <cfoutput><link href="../styles/#globals.siteStyle#" rel="stylesheet" type="text/css"></cfoutput>
 --->
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
<cfparam name="Drill" default="0">
<cfparam name="mailcheckErrMsg" default="">
<cfparam name="ShowEditor" default="1">
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm"> </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
		<cfif IsDefined("bSave")>
			<cfscript>
			if (IsDefined("MessageMultiPart"))
				MessageMultiPart = 1;
			else {
				MessageMultiPart = 0;
			}
			</cfscript>
			<cfset vTargetEmpty = 'target=""'>
			<cfset vClassEmpty = 'class=""'>
			<cfset MessageHTML = ReplaceNoCase(MessageHTML, vTargetEmpty , "", "all")>
			<cfset MessageHTML = ReplaceNoCase(MessageHTML, vClassEmpty , "", "all")>
			
			<cflock name="saveMsg" type="exclusive" timeout="30">
				<cfquery name="saveMessage" datasource="#DSN#">
				INSERT INTO email_list_messages (MessageListID, MessageTempID, MessageName, MessageSubject, MessageTXT, MessageHTML, MessageMultiPart, ShowEditor, MessageCreateDate)
				VALUES (#EmailListID#, 
                #tempID#, 
                '#MessageName#', 
                '#MessageSubject#', 
                <cfqueryparam value="#MessageTXT#" cfsqltype="cf_sql_clob">, 
                <cfqueryparam value="#MessageHTML#" cfsqltype="cf_sql_clob">, 
                #MessageMultiPart#, 
                #ShowEditor#, 
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
				</cfquery>
				
				<cfquery name="getMessage" datasource="#DSN#">
				SELECT *
				FROM email_list_messages
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
					You uploaded the file <strong>#File.ClientFileName#.#File.ClientFileExt#</strong> 
					successfully (type: #File.ContentType#).<br>
						<cfset attachmentFileName = #serverFile#>
						<cfset attachmentFileSize = #File.FileSize#>		
					</cfoutput>
				<!--- Add info to database --->
				<cfquery name="uploadAttachment" datasource="#DSN#">
					INSERT INTO attachments (AttachmentFileName, AttachmentFileSize, UploadedByUser, UploadIP, MessageID, ListID)
					VALUES ('#Trim(AttachmentFileName)#', #attachmentFileSize#, '#Session.UserName#', '#currUserIP#', #getMessage.MessageID#, #EmailListID#)
				</cfquery>
			  </cfif>
			<cfelse>
				<!--- no attachment received no action required possibly badly named attachment --->
			
			</cfif>
			<!--- Upload and record attachment close --->
			
			<cfoutput query="getMessage" maxrows="1">
				<cflocation url="messageUpdate.cfm?mid=#MessageID#&lid=#MessageListID#&ShowEditor=#ShowEditor#" addtoken="no">
			</cfoutput>
			
		<cfelseif IsDefined("bNewList")>
			<cfquery name="addNewList" datasource="#DSN#">
			INSERT INTO email_lists (EmailListDesc, EmailListAdminID, EmailListFromEmail, EmailListSMTPServer, EmailListPOPServer, EmailListPOPLogin, EmailListPOPPwd, EmailListGlobalHeader, EmailListGlobalFooter, EmailListGlobalHeaderHTML, EmailListGlobalFooterHTML,FROM_NAME)
			VALUES ('#EmailListDesc#', <cfif IsDefined("OverrideAdminID") AND OverrideAdminID gte 1>#OverrideAdminID#<cfelse>#Session.AccessLevelID#</cfif>, '#EmailListFromEmail#', '#EmailListSMTPServer#', '#EmailListPOPServer#', '#EmailListPOPLogin#', '#EmailListPOPPwd#', '#EmailListGlobalHeader#', '#EmailListGlobalFooter#', '#EmailListGlobalHeaderHTML#', '#EmailListGlobalFooterHTML#','#EmailListFrom_Name#')
			</cfquery>
		<tr>
			<td height="25" colspan="14" align="center"><span class="adminUpdateSuccessful">New Subscription List has been created and saved!</span></td>
		</tr>
		<cfelseif IsDefined("bImport")>
		   <cfscript>
		   	tmpSubscriberList = #Trim(subscriberImportList)#;
			tmpSubscriberList = #ReReplace(tmpSubscriberList, "[[:space:]]", ",", "all")#;
			vSubscriberArray = ArrayNew(1);
			vSubscriberArray = ListToArray(tmpSubscriberList, ",");
			tmpArrayLen = ArrayLen(vSubscriberArray);
			vSubscribersAddedCount = 0;
		   </cfscript>
			<cfloop from="1" to="#tmpArrayLen#" index="i">
			  <cfmodule template="adminpro_emailValidate.cfm" email="#vSubscriberArray[i]#">
			  <cfquery name="checkEmailExists" datasource="#DSN#">
				SELECT * FROM email_addresses 
				WHERE EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vSubscriberArray[i]#">
				AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
			  </cfquery>
			 <cfif Error eq 0 AND checkEmailExists.RecordCount eq 0>
			  <cfquery name="addNewSubscriber" datasource="#DSN#">
				INSERT INTO email_addresses (ListID, EmailAddress)
				VALUES (#lid#, '#vSubscriberArray[i]#')
			  </cfquery>
			  <cfset vSubscribersAddedCount = vSubscribersAddedCount + 1>
			 </cfif>
			</cfloop>
		<tr>
			<td height="25" colspan="14" align="center">
			<span class="adminUpdateSuccessful"><cfoutput>#vSubscribersAddedCount#</cfoutput> New Subscribers have been imported successfully!
			</span>
			</td>
		</tr>
		<cfelseif IsDefined("bImportCSV")>
		    <cfif Trim(importFile) neq "">
			<cfscript>
					currPath = ExpandPath("*.*");
					tempCurrDir = GetDirectoryFromPath(currPath) & "attachments";
					if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { trailingSlash = '\'; }
					else { trailingSlash = '/'; }
			</cfscript>
			<cfoutput>
			<cfset strImportPath = #globals.importFilePath#&trailingSlash>
			<cffile action="upload"
				destination="#strImportPath#"
				nameconflict="Overwrite"
				filefield="importFile">
		
			      <cfset strFileName = #File.ClientFileName#&"."&#File.ClientFileExt#>
				  <cfmodule template="adminpro_importCSV.cfm" importfilepath="#strImportPath#" importfilename="#strFileName#"
				  	dsn="#DSN#">
			
			</cfoutput>
			<cfelse>
			</cfif>
		<tr>
			<td height="25" colspan="14" align="center">
			<span class="adminUpdateSuccessful"><cfif Trim(importFile) neq "" AND Not IsDefined("errImport")>Your CSV file of addresses has been imported successfully, please verify your updated active subscribers list!</cfif>
			</span>
			</td>
		</tr>
		<cfelseif IsDefined("lnMailcheck")>
		<tr>
			<td height="25" colspan="14" align="center">
				<cfif IsDefined("mailcheckErr") AND mailcheckErr eq 0>
				<span class="adminUpdateSuccessful">Mail Box check is complete<br>
				all subscribe, unsubscribe requests have been processed. Bounced email addresses have also been flagged and logged
				</span>
				<cfelseif IsDefined("mailcheckErr") AND mailcheckErr eq 1>
				<span class="adminRemoveSuccessful">There was an error connecting to your POP Server, please verify you have entered all setings correct in your list setup.</span><br>
				<span class="bodyText"><strong>Error Message</strong>: <cfoutput>#mailcheckErrMsg#</cfoutput></span>
				
				<cfelse>
				<span class="adminUpdateSuccessful">Mail Box check is complete<br>
				all subscribe, unsubscribe requests have been processed. Bounced email addresses have also been flagged and logged [! Error check flag not present]
				</span>
				</cfif>
			</td>
		</tr>
		<cfelseif IsDefined("lnSchedule")>
		<cfinclude template="scheduleMailCheck.cfm">
		<tr>
			<td height="25" colspan="14" align="center">
			<cfif IsDefined("ret") AND ret eq 1>
			<span class="adminUpdateSuccessful">Mail Box check has now been scheduled<br>
			this list's mail box will be checked and processed every 24 hrs</span>
			<cfelseif IsDefined("ret") AND ret eq 0>
			<span class="adminRemoveSuccessful">Your scheduled mail box check has been removed</span>
			<cfelse>
			! There was an error creating your scheduled task
			</cfif>
			</td>
		</tr>
		<cfelseif IsDefined("lnDeleteBounced") AND IsDefined("lid")>
			  <cfquery name="deleteAllBounced" datasource="#DSN#">
				DELETE FROM email_addresses 
				WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
					AND Bounced = 1
			  </cfquery>
		<tr>
			<td height="25" colspan="14" align="center">
			<span class="adminUpdateSuccessful">All bounced Subscribers have been removed!
			</span>
			</td>
		</tr>
		<cfelseif IsDefined("viewsub") AND viewsub eq 1>
		<tr>
			<td height="25" colspan="14" align="center">
			<span class="subscribeFail">* You chose to view all current subscribers, as
			you have either no lists currently setup or more then 1 List you must select the subscriber list you
			wish to	view from this screen (or setup a new list first), simply click the
			edit/view button in the Subscriber List column of the list you wish
			to view
			</span>
			</td>
		</tr>
		<cfelseif IsDefined("deleteAllSub") AND deleteAllSub eq 1>
		 <cftry>
			<cfquery name="deleteAllSubs" datasource="#DSN#">
				DELETE FROM email_addresses 
				WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
			</cfquery>
		 
		<tr>
			<td height="25" colspan="14" align="center">
			<span class="subscribeFail">* All subscribers from your selected list have been removed - This cannot be reversed
			</span>
			</td>
		</tr>
		 <cfcatch type="any"> .. There was an error deleting your subscribers - this action failed</cfcatch>
		 </cftry>
		 
		<cfelse>				
		</cfif>
		
		<cfquery name="getSubListDetails" datasource="#DSN#">
			SELECT *
			FROM email_lists
			<cfif IsDefined("Session.AccessLevelDesc") AND Session.AccessLevelDesc eq "Administrator">
			<cfelse>
			WHERE EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
			</cfif>
			ORDER BY EmailListDesc
		</cfquery>
		<!--- RecordCount --->
		<cfparam name="mystartrow" default="1">
		<cfparam name="realstartrow" default="1">
		<cfset maxPages = "#globals.subscriptionLists_MaxPages#">
		<cfset maxRows = "#globals.subscriptionLists_MaxRows#">
		<cfset cfmx = "#globals.cfmxInstalled#">
		<cfset request.RCQuery = getSubListDetails>
		<cfset currentGroupID = 0>
		<cfif getSubListDetails.RecordCount gt 1>
		<tr>
		  <td height="18" colspan="14" class="bodyText">
			  (<cf_recordcountml
			part="recordcount"
			mystartrow="#mystartrow#"
			realstartrow="#realstartrow#"
			group="EmailListID"
			mymaxrows="#maxRows#"
			rcitem="List"
			cfmx="#cfmx#">) <br> <cf_recordcountml
			template="subscriptionLists.cfm"
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
		</cfif>
		<tr>
		  <td height="1" colspan="14" class="tdHorizDivider"></td>
	    </tr>
		<tr>
		  <td align="center" valign="middle" nowrap class="tdBackGrnd">&nbsp;</td> 
          <td height="25" align="center" valign="middle" nowrap class="tdBackGrnd"><strong>Subscription
            Lists [ID]</strong></td>
          <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
          <td align="center" class="tdBackGrnd"><strong>Current Messages</strong></td>
          <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Create New Message</strong></td>
          <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Subscribers[Active]
              <font color="Red">(Bounced)</font></strong></td>
          <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>          Subscribers<font color="Red">[-]</font></strong></td>
          <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Groups</strong></td>
          <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
          <td align="center" nowrap class="tdBackGrnd"><strong>Get<br>
            Mail
          </strong></td>
        </tr>
        <tr> 
          <td height="1" colspan="14" nowrap class="tdHorizDivider"></td>
        </tr>
        <cfoutput query="getSubListDetails" startrow="#realstartrow#" maxrows="#maxRows#">
          <cfquery name="getSubscribedCount" datasource="#DSN#">
          SELECT COUNT(EmailID) AS subscribersCnt FROM email_addresses WHERE ListID 
          = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListDetails.EmailListID#">
		  </cfquery>
          <cfquery name="getSubscribedBounced" datasource="#DSN#">
          SELECT COUNT(EmailID) AS bouncedCnt FROM email_addresses
		  WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListDetails.EmailListID#">
		  	AND Bounced = 1
		  </cfquery>
          <cfquery name="getRemovedCount" datasource="#DSN#">
          SELECT COUNT(EmailID) AS RemovedCnt FROM email_addresses_removed WHERE 
          ListID = 
          <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListDetails.EmailListID#">
          </cfquery>
          <cfquery name="getMessageCount" datasource="#DSN#">
          SELECT COUNT(MessageID) AS MessageCnt FROM email_list_messages WHERE 
          MessageListID = 
          <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListDetails.EmailListID#">
          </cfquery>
		  <cfquery name="qARMessageCount" datasource="#DSN#">
          SELECT COUNT(MessageID) AS ARMessageCnt FROM auto_responder_messages WHERE 
          MessageListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListDetails.EmailListID#">
          </cfquery>
          <tr>
            <td nowrap>
			<cfif (IsDefined("lid") AND lid eq EmailListID) AND (Drill eq 1)>
                	<a href="#cgi.script_name#?lid=#EmailListID#&Drill=0"><img src="../images/icon-arrow-down.gif" alt="View more options" width="17" height="12" border="0"></a>
            <cfelse>
                 	<a href="#cgi.script_name#?lid=#EmailListID#&Drill=1" title="Click to view more options"><img src="../images/icon-arrow-right.gif" alt="View more options" width="12" height="17" border="0"></a>
            </cfif>
			</td> 
            <td height="18" class="bodyText"><a href="subscriptionListDetail.cfm?lid=#EmailListID#"><img src="../images/icon-folder-edit.gif" width="20" height="19" border="0" align="absmiddle">#EmailListDesc#</a> [#getSubListDetails.EmailListID#]</td>
            <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
            <td align="center" nowrap class="bodyText">#getMessageCount.MessageCnt# <cfif getMessageCount.MessageCnt gt 0><a href="messageLists.cfm?lid=#EmailListID#">[ View ]</a></cfif> </td>
            <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
            <td class="bodyText" align="center" nowrap><a href="messageNew.cfm?lid=#EmailListID#"><img src="../images/icon-new-message.gif" width="17" height="18" border="0" align="absmiddle"></a>[<a href="messageNew.cfm?lid=#EmailListID#">New</a>]</td>
            <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
            <td class="bodyText" align="left" nowrap><img src="../images/spacer_white.gif"><a href="subscribersList.cfm?lid=#EmailListID#&list=active"><img src="../images/icon-users-active.gif" width="16" height="16" border="0" align="absmiddle"></a> [#getSubscribedCount.subscribersCnt#] 
              <cfif getSubscribedBounced.bouncedCnt gt 0><font color="Red">(#getSubscribedBounced.bouncedCnt#) <a href="subscriptionLists.cfm?lnDeleteBounced=1&lid=#EmailListID#"><img src="../images/deleteIcon_Red.gif" alt="Click to Delete all bounced addresses" width="12" height="15" border="0" align="absbottom"></a>
				 <a href="javascript:popUpWindow('addressBounceControlPanel.cfm?lid=#EmailListID#', 'yes', 'yes', '50', '50', '450', '450')"><img src="../images/deleteIcon_blue.gif" alt="Click to open a Bounced Address Control Panel to have more control over Addresses to delete" width="12" height="15" border="0" align="absbottom"></a></font>
            </cfif></td>
            <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
            <td class="bodyText" align="center"><cfif getRemovedCount.RemovedCnt neq 0> <a href="subscribersList.cfm?lid=#EmailListID#&list=removed"><img src="../images/icon-users-removed.gif" width="16" height="16" border="0" align="absmiddle"></a> 
                <cfelse><img src="../images/icon-users-removed.gif" width="16" height="16" border="0" align="absmiddle"></cfif> <font color="Red">[#getRemovedCount.RemovedCnt#]</font></td>
            <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
            <td class="bodyText" align="center"><a href="subscribers_groups.cfm?lid=#EmailListID#"><img src="../images/icon-groups.gif" alt="Create/View Subscriber Groups" width="21" height="19" border="0"></a></td>
            <td class="tdVertDivider" width="1"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
            <td class="bodyText" align="center"><a href="mailboxCollectionLocal.cfm?listnum=#EmailListID#"><img src="../images/logo-maillist-sm.gif" alt="Click to perform a manual check for mail on your Pop Server" width="33" height="21" border="0"></a></td>
          </tr>
		   <cfif (IsDefined("lid") AND lid eq EmailListID) AND (Drill eq 1)>
		  <tr> 
            <td height="1" colspan="14" class="tdVertDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
          </tr>
          <tr>
            <td><img src="../images/spacer_white.gif" width="12" height="12"></td>
			<td height="18" colspan="13" nowrap class="bodyText"><table width="95%" border="0" cellspacing="1" cellpadding="0">
              <tr>
                <td height="22" nowrap bgcolor="##EEEEEE" class="bodyText"><strong>Auto Responder
                    Messages:</strong></td>
                <td width="100%" align="left" class="bodyText">#qARMessageCount.ARMessageCnt# <cfif qARMessageCount.ARMessageCnt gt 0><a href="auto_responder_messageLists.cfm?lid=#EmailListID#">[ View ]</a></cfif> <a href="messageNew.cfm?lid=#EmailListID#"><img src="../images/icon-new-message.gif" width="17" height="18" border="0" align="absmiddle"></a>[<a href="auto_responder_messageNew.cfm?lid=#EmailListID#">New</a>]</td>
              </tr>
              <tr>
                <td height="22" nowrap bgcolor="##EEEEEE" class="bodyText"><strong>Manual Pop Mail Box Check:</strong></td>
                <td align="left"><a href="mailboxCollectionLocal.cfm?listnum=#EmailListID#&drill=#drill#"><img src="../images/logo-maillist-sm.gif" alt="Click to perform a manual check for mail on your Pop Server" width="33" height="21" border="0"></a> <a href="mailboxCollectionLocal_batch.cfm?listnum=#EmailListID#&drill=#drill#"><img src="../images/logo-maillist-sm-batch.gif" width="33" height="21" border="0"></a></td>
              </tr>
              <tr>
                <td height="22" nowrap bgcolor="##EEEEEE" class="bodyText"><strong>Create Mailbox Check Scheduled Task:</strong></td>
                <td align="left" class="bodyText"><cfif taskScheduled neq 1>
                  <a href="subscriptionLists.cfm?lnSchedule=1&lid=#EmailListID#&drill=#drill#"><img src="../images/icon-hd-schedule-inactive.gif" alt="Click to schedule regular mail checking" width="19" height="20" border="0" title="Click to add a scheduled task for this List"></a> (inactive)
                  <cfelse><a href="subscriptionLists.cfm?lnSchedule=1&lid=#EmailListID#&drill=#drill#"><img src="../images/icon-hd-schedule.gif" alt="Regular mail checking is already scheduled" width="19" height="20" border="0" title="Click to remove the current scheduled task for this List"></a> (active)
            		</cfif>
				</td>
              </tr>
              <tr>
                <td height="22" nowrap bgcolor="##EEEEEE" class="bodyText"><strong>Export Current Subscriber List To
                  File:</strong></td>
                <td align="left"><a href="javascript:popUpWindow('export_SubscriberList.cfm?lid=#EmailListID#', 'yes', 'yes', '50', '50', '480', '450')"><img src="../images/icon-save.gif" alt="Click to create a Comma Separated Value file (CSV)  of your active Email List" width="17" height="17" border="0"></a></td>
              </tr>
              <tr>
                <td height="22" nowrap bgcolor="##EEEEEE" class="bodyText"><strong>Import
                    a list of Subscribers:</strong></td>
                <td align="left" class="bodyText"><a href="subscribersImport.cfm?lid=#EmailListID#"><img src="images/importIconGrn.gif" alt="Import list of subscribers" width="12" height="15" border="0" align="absmiddle"></a> [<a href="subscribersImport.cfm?lid=#EmailListID#">import</a>]</td>
              </tr>
              <tr>
                <td height="22" nowrap bgcolor="##EEEEEE" class="bodyText"><strong>Bounce
                    Exclusion Text:</strong></td>
                <td align="left"><a href="bounce_excl_list.cfm"><img src="../images/edit.gif" alt="Edit Bounce Exclusion List" width="8" height="12" border="0">[ View/Edit ]</a></td>
              </tr>
              <tr>
                <td height="22" nowrap bgcolor="##EEEEEE" class="bodyText"><strong>List Administrators:</strong></td>
                <td align="left"><a href="adminUserList.cfm">[ View/Edit ]</a></td>
              </tr>
              <tr>
                <td height="22" nowrap bgcolor="##EEEEEE" class="bodyText"><strong><font color="Red">Delete
                  All</font> Current Subscribers:</strong></td>
                <td align="left"><a href="subscriptionLists.cfm?deleteAllSub=1&lid=#EmailListID#&drill=#drill#" onClick="return confirm('Are you sure you wish to delete all subscribers from this list - this is NOT reversible?')"><img src="images/subscribers_delete_all.jpg" width="23" height="20" border="0"></a></td>
              </tr>
            </table>
			</td>
          </tr>
		  </cfif>
          <tr> 
            <td height="1" colspan="14" class="tdVertDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
          </tr>
        </cfoutput> 
		  <cfif getSubListDetails.RecordCount gt 1>
		  <tr>
		  	<td colspan="14" class="bodyText">
			<cf_recordcountml
			template="subscriptionLists.cfm"
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
		  </cfif>
		  <tr align="center">
		    <td colspan="14" class="bodyText"><img src="../images/deleteIcon_Red.gif" width="12" height="15" align="absbottom"> [Click
		      to remove all bounced subscribers] <img src="../images/deleteIcon_blue.gif" width="12" height="15" align="absbottom"> [Click
		      to select the bounced subscribers to delete]<br>
		      <img src="images/subscribers_delete_all.jpg" width="23" height="20" align="absbottom"> [Click
		      to delete ALL subscribers for this list] <strong>* WARNING this is not
		      reversible, all subscribers will be deleted from the selected list</strong></td>
	    </tr>
		<tr align="center" bgcolor="#FFE9D2">
		    <td height="18" colspan="14" class="bodyText"><img src="../images/help_Animated.gif" width="10" height="10" align="absmiddle"> [<a href="javascript:popUpWindow('../docs/Listsadmin.htm', 'yes', 'yes', '50', '50', '650', '475')">click
		      for help on using this screen</a>]</td>
	    </tr>
	  </table></td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
