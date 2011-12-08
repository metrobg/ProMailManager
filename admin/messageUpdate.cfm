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
<title>Mail List: Message Update</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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
<cfparam name="editorWidth" default="#globals.DefaultEditorWidth#">
<cfparam name="editorHeight" default="#globals.DefaultEditorHeight#">

<cfif IsDefined("bSave")>
<cfelseif NOT IsDefined("mid")>
	<cflocation url="subscriptionLists.cfm" addtoken="no">
<cfelse>
</cfif>
 <cfif IsDefined("bUpdate") OR IsDefined("bSendMessage")>
			<cfset vTargetEmpty = ' target=""'>
			<cfset vClassEmpty = ' class=""'>
			<cfscript>
			// Remove outer paragraph tags if present
			if ( (CGI.HTTP_USER_AGENT DOES NOT CONTAIN "Mac") AND (CGI.HTTP_USER_AGENT CONTAINS "MSIE") ) {
				tmpOpeningP = Left(MessageHTML, 3);
				tmpCloseingP = Right(MessageHTML, 4);
				tmpLength = Len(MessageHTML);
				if ( (tmpOpeningP eq "<p>") AND (tmpCloseingP eq "</p>") ) {
					MessageHTML = Mid(MessageHTML, 4, (Val(tmpLength) - 8) );
				}
			}
			</cfscript>
			<cfset MessageHTML = ReplaceNoCase(MessageHTML, vTargetEmpty , "", "all")>
			<cfset MessageHTML = ReplaceNoCase(MessageHTML, vClassEmpty , "", "all")>
		<cfquery name="updateMessage" datasource="#DSN#">
			UPDATE email_list_messages 
			SET MessageName = '#MessageName#',
			 MessageSubject = '#MessageSubject#', 
			 MessageTXT = '#MessageTXT#', 
			 MessageHTML =  <cfqueryparam value="#MessageHTML#" cfsqltype="cf_sql_clob">, 
			 ShowEditor = #ShowEditor#,
			 MessageMultiPart = #MessageType#
			WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Trim(mid)#">
			</cfquery>
			
	<!---			 Upload and record attachment --->
			<cfif Len(Trim(attachmentFileField)) eq 0>
				<!--- no attachment received no action required --->
			
			<cfelseif Len(Trim(attachmentFileField)) gte 2>
			
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
						<cfset attachmentFileName = #serverFile#>
						<cfset attachmentFileSize = #File.FileSize#>		
					</cfoutput>
				<!--- Add info to database --->
				<cfquery name="uploadAttachment" datasource="#DSN#">
					INSERT INTO attachments (AttachmentFileName, AttachmentFileSize, UploadedByUser, UploadIP, MessageID, ListID)
					VALUES ('#Trim(AttachmentFileName)#', #attachmentFileSize#, '#Session.UserName#', '#currUserIP#', #mid#, #lid#)
				</cfquery>
			 </cfif>
			 
			<cfelse>
				<!--- no attachment received no action required possibly badly named attachment --->
			</cfif>
			<!--- Upload and record attachment close --->
			
			<!--- Remove flagged attachments for deletion --->
			<cfif IsDefined("attachDelFlag") AND ListLen(attachDelFlag) gte 1>
			  
			  <cfloop from="1" to="#ListLen(attachDelFlag)#" index="i">
			  
				<cfset currAttachID = ListGetAt(attachDelFlag, i, ",")>	
				<cfquery name="locateAttachment" datasource="#DSN#">
					SELECT * FROM attachments WHERE recID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currAttachID#">
				</cfquery>
				<cfif locateAttachment.RecordCount eq 1>
					<cfquery name="removeAttachment" datasource="#DSN#">
						DELETE FROM attachments WHERE recID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currAttachID#">
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
							<!--- Must manually remove the file yourself form the attachment directory --->
							<cfset fileDeleted = 0>
					</cfif>
				</cfif>
				
			  </cfloop>	
			
			<cfelse>
				<!--- No attachments flagged for deletion --->
			</cfif>
			<!--- Remove flagged attachments for deletion close --->
			
			<!--- Send Message broadcast --->
			<cfif IsDefined("bSendMessage")>
				<cfif IsDefined("MessageType")>
				  <!--- sendMessage.cfm?bSendMessage=Broadcast&lid=#lid#&mid=#mid#&MessageType=#MessageType# --->
				  <cflocation url="broadcast_prepare.cfm?lid=#lid#&mid=#mid#&MessageType=#MessageType#" addtoken="no">
				<cfelse>
				  <cflocation url="broadcast_prepare.cfm?lid=#lid#&mid=#mid#" addtoken="no">
				</cfif>
			</cfif>
			<!--- Close Send Message broadcast --->
			
<cfelseif IsDefined("bSendOneMessage")>
	<cfif globals.cfmxInstalled eq 1>
		<cfinclude template="_messageSendEngineOne.cfm">
		<cfset oneMessageSent = 1>
	<cfelse>
		<cfinclude template="_messageSendEngineOne_pre61.cfm">
		<cfset oneMessageSent = 1>
	</cfif>

<cfelseif IsDefined("bResize")>
	<cfif IsDefined("form.ShowEditor") AND form.ShowEditor eq 1>
		<cfset ShowEditor = 1>
	<cfelse>
		<cfset ShowEditor = 0>
	</cfif>
	<cfquery name="updateMessage" datasource="#DSN#">
			UPDATE email_list_messages 
			SET
			 ShowEditor = #ShowEditor#
			WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Trim(mid)#">
	</cfquery>
<cfelse>
</cfif>

<cfif IsDefined("bSave")>
	<cfquery name="getMessage" datasource="#DSN#">
	SELECT *
	FROM email_list_messages
	WHERE MessageTempID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tempID#">
	</cfquery>
	<cfoutput query="getMessage">
		<cfset mid = #MessageID#>
	</cfoutput>
<cfelse>
	<cfquery name="getMessage" datasource="#DSN#">
	SELECT *
	FROM email_list_messages
	WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
	</cfquery>	
</cfif>
<cfif getMessage.RecordCount eq 0>
	<cflocation url="subscriptionLists.cfm" addtoken="no">
</cfif>
<cfquery name="attachCheck" datasource="#DSN#">
	SELECT * FROM attachments
	WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
</cfquery>
<cfquery name="ListInfo" datasource="#DSN#">
	SELECT EmailPersonalization FROM email_lists
	WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
	</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" align="center" valign="top">
	<cfinclude template="globals/_navSidebar.cfm">
	<br><br>
      <table width="180" border="0" cellspacing="0" cellpadding="1" class="tdTipsHeader">
        <tr>
          <td>
            <table width="100%" border="0" cellpadding="3" cellspacing="0">
              <tr>
                <td align="center" class="tdTipsHeader" background="images/gradient-bar-dark-blue.gif" height="20"><strong>Message
                  Preview</strong></td>
              </tr>
              <tr>
                <td align="center" bgcolor="#FFFFFF"><span class="bodyText"><img src="images/icon-help.gif" width="24" height="25"><br>
                  Click to
                  see a preview of how your HTML message will look when sent</span>
				  <form action="messagePreview.cfm?mid=<cfoutput>#getMessage.MessageID#&lid=#lid#</cfoutput>" method="post">
				  	<input name="bPreview" type="submit" class="tdHeader" id="bPreview" value="Preview Message">
				  </form><br>
				  </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <br>
      
    </td>
    <td width="2"><br>      <img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">       
		<tr align="center" bgcolor="#CCCCCC">	  
		  <cfform action="messageUpdate.cfm" method="post">
		  <cfoutput>
		  <input type="hidden" name="mid" value="#mid#">
		  <input type="hidden" name="lid" value="#lid#">
		  <input type="hidden" name="ShowEditor" value="#getMessage.ShowEditor#">
		  </cfoutput> 
		  <td height="25" colspan="3" class="bodyText"><strong>Send Message to 1 recipient</strong>: 
		    <cfinput name="singleEmail" type="text" size="35" maxlength="100" required="yes" message="Please enter a Valid E-Mail Address before continuing" class="bodyText">
			<input name="bSendOneMessage" type="submit" class="buttonTestSend" id="bSendOneMessage" value="Send">
		  </td>
		  </cfform>
		  </tr>
		<cfif IsDefined("oneMessageSent") AND oneMessageSent eq 1>
		<tr align="center">
		  <td height="25" colspan="3"><span class="adminUpdateSuccessful">Message has been sent to: <cfoutput>#singleEmail#</cfoutput></span></td>
		</tr>
		</cfif>
		<cfquery name="getSubLists" datasource="#DSN#">
			SELECT *
			FROM email_lists
			WHERE EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
				AND EmailListID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
		</cfquery>
		<form action="messageLists.cfm" method="post">
		<cfoutput>
		<input type="hidden" name="mid" value="#mid#">
		<input type="hidden" name="lidOrig" value="#lid#">
		</cfoutput>
		<cfif getSubLists.RecordCount gte 1>
		<tr align="center">
		  <td height="25" colspan="3" class="bodyText">Save a copy of this message to another list: 
		  <select name="EmailListID" class="bodyText">
		  	<cfoutput query="getSubLists">
			<option value="#EmailListID#">#EmailListDesc#</option>
			</cfoutput>
		  </select>
		  <input name="bSaveMessageCopy" type="submit" class="copyButton" id="bSaveMessageCopy" value="Copy Message">
		  </td>
		</tr>
		</cfif>
		<tr align="center">
		  <td height="1" colspan="3" bgcolor="#333333"></td>
		  </tr>
		</form>
		<tr> 
          <td height="25" colspan="3" class="tdBackGrnd"><strong>Subscription
               List: Update your Message/Newsletter to broadcast to your subscribers</strong><strong></strong></td>
        </tr>
        <tr> 
          <td height="2" colspan="3" class="tdHorizDivider"></td>
        </tr>
        <form action="messageUpdate.cfm" method="post">
		<cfoutput>
		<input type="hidden" name="lid" value="#lid#">
		<input type="hidden" name="mid" value="#mid#">
		<tr bgcolor="##EEEEEE">
		    <td height="20" colspan="3" align="center" class="bodyText">WYSIWYG Editor Properties
		      (compatible with IE 5.5 and above on Windows only)</td>
	   </tr>
	   <tr>
		    <td height="20" colspan="3" align="center" class="bodyText">Editor Status:
		      <input type="radio" name="ShowEditor" value="1" class="bodyText" <cfif getMessage.ShowEditor eq 1>checked</cfif>>On <input type="radio" name="ShowEditor" value="0" class="bodyText" <cfif getMessage.ShowEditor eq 0>checked</cfif>>
		      Off
		      (useful to disable editor when importing full web pages)</td>
		</tr>
		<tr>
			<td colspan="3" align="center" class="bodyText">
			Update editor size: <strong>Width</strong>	        
			<select name="editorWidth" id="editorWidth" class="bodyText">
	          <option value="#editorWidth#" selected>#editorWidth#</option>
			  <option value="300">300</option>
	          <option value="350">350</option>
	          <option value="400">400</option>
			  <option value="450">450</option>
	          <option value="500">500</option>
			  <option value="550">550</option>
	          <option value="600">600</option>
			  <option value="650">650</option>
	          <option value="700">700</option>
			  <option value="750">750</option>
	          <option value="800">800</option>
			  <option value="850">850</option>
			  <option value="900">900</option>
	          <option value="950">950</option>
	          <option value="1000">1000</option>
            </select>
			<strong>Height</strong>	        
			<select name="editorHeight" id="editorHeight" class="bodyText">
	          <option value="#editorHeight#" selected>#editorHeight#</option>
			  <option value="300">300</option>
	          <option value="350">350</option>
	          <option value="400">400</option>
			  <option value="450">450</option>
	          <option value="500">500</option>
			  <option value="550">550</option>
	          <option value="600">600</option>
			  <option value="650">650</option>
	          <option value="700">700</option>
			  <option value="750">750</option>
	          <option value="800">800</option>
			  <option value="850">850</option>
			  <option value="900">900</option>
	          <option value="950">950</option>
	          <option value="1000">1000</option>
            </select>
			<input name="bResize" type="submit" class="bodyText" id="bResize" value="Resize Editor">
			</td>
		</tr>
		</cfoutput>
		</form>
		<tr> 
          <td height="2" colspan="3" class="tdHorizDivider"></td>
        </tr>		
          <cfform action="messageUpdate.cfm" method="post" name="messageUpdate" enctype="multipart/form-data">
		  <cfoutput query="getMessage" maxrows="1">
		  <input type="hidden" name="mid" value="#MessageID#">
		  <input type="hidden" name="lid" value="#lid#">
		  <input type="hidden" name="editorWidth" value="#editorWidth#">
		  <input type="hidden" name="editorHeight" value="#editorHeight#">
		  <input type="hidden" name="ShowEditor" value="#ShowEditor#">
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Message Name</strong>: </td>
            <td width="2" class="tdVertDivider"></td>
            <td align="left"><cfinput name="MessageName" value="#MessageName#" type="text" size="50" required="yes" message="Please enter a Descriptive Name for this Message" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
          <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Message
                Subject</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="MessageSubject" value="#MessageSubject#" type="text" size="50" maxlength="100" required="yes" message="Please enter a SUBJECT for this Message (Will be the subject line of the final email sent)" class="bodyText"></td>
          </tr>
          <cfif IsDefined("fileDeleted")>
		  <tr align="center">
		  	<td height="25" colspan="3">
				<cfif fileDeleted eq 1>
				<span class="adminRemoveSuccessful">The selected attachments have been successfully deleted</span>
				<cfelse>
				<span class="adminRemoveSuccessful">The selected attachments have been detached from this message but as you do not have access to cffile, you must manually remove them from your attachments folder</span>
				</cfif>
			</td>
		  </tr>
		  </cfif>
		  <cfif attachCheck.RecordCount gte 1>
		  <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Attachment/s already present:</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left" class="bodyText"><cfloop query="attachCheck">#attachCheck.AttachmentFileName# (#attachCheck.AttachmentFileSize# bytes) <input name="attachDelFlag" type="checkbox" value="#attachCheck.recID#"> [ check box to delete this attachment <img src="images/deleteDocIcon.gif"> ]<cfif attachCheck.CurrentRow neq attachCheck.RecordCount><br></cfif></cfloop></td>
          </tr>
		  </cfif>
		  <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Add
                an attachment <img src="images/attachment.jpg" width="18" height="16" align="absbottom"></strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><input type="file" name="attachmentFileField" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr>
		    <td height="22" colspan="3" align="center" nowrap class="bodyText"><strong>Message (HTML
	        Version)</strong>:<br>
	        </td>
		    </tr>
		  <cfif ListInfo.EmailPersonalization eq 1>
		  <tr>
		    <td colspan="3" align="center" class="bodyText" bgcolor="##CCCCCC">The following personalization
		      variables are available to be used anywhere in your HTML message body<br>
              <strong>[First Name] [Last Name] [Email] [List] [Date Short] [Date Med] [Date Long]</strong></td>
		  </tr>
		  </cfif>
		
		  <tr> 
          
            <td colspan="3" align="center" valign="top"><textarea name="MessageHTML" cols="90%" rows="30">#MessageHTML#</textarea>
            </td>
            </tr>
            <cfif showEditor eq 1>
               <cfset edit = "MessageHTML">
                  <cfelse>
                    <cfset edit = "MessageNoHTML">
                      </cfif>
                      
                      
            <script type="text/javascript">				
					CKEDITOR.replace( 'MessageHTML',
					{
						toolbar :
						[
							{ name: 'basicstyles', items : [ 'Bold','Italic','Subscript','Superscript','-','RemoveFormat' ] },
							{ name: 'paragraph', items : [ 'NumberedList','BulletedList','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
							{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
							{ name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
							{ name: 'colors', items : [ 'TextColor','BGColor' ] },
							{ name: 'tools', items : [ 'Maximize','-','About' ] }
						]
					});
		        </script>
       
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr align="center">
		    <td height="22" colspan="3" nowrap class="bodyText"><strong>Message
	        (Text Version)</strong>:</td>
		    </tr>
		  <tr align="center" valign="top"> 
            <td colspan="3"><textarea name="MessageTXT" cols="65" rows="10">#MessageTXT#</textarea>
            </td>
            </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Do
                you wish to send as a multi-part/HTML Message</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left">
			 <input name="MessageType" type="radio" value="1" <cfif MessageMultiPart eq 1>checked</cfif>><br>
			</td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Do
                you wish to send as a Text only Message</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left">
 			 <input name="MessageType" type="radio" value="0" <cfif MessageMultiPart eq 0>checked</cfif>>
			</td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr align="center">
		    <td height="25" colspan="3" nowrap class="bodyText">
			  <input name="bUpdate" type="submit" class="tdHeader" id="bSave" value="Update Message">
			  &nbsp;&nbsp;
			  <input name="bSendMessage" type="submit" class="tdHeader" id="bSendMessage" value="Broadcast Message">
		      </td>
		    </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  </cfoutput>
		  </cfform>
		  <tr align="center" bgcolor="#FFE9D2">
		    <td height="18" colspan="3" align="center" nowrap class="bodyText">
			  <img src="images/help_Animated.gif" width="10" height="10" align="absmiddle"> [<a href="javascript:popUpWindow('../docs/MessageUpdate.htm', 'yes', 'yes', '50', '50', '700', '550')">click
		  for help on using this screen</a>]</td>
	      </tr>
		  <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
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
