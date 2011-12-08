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
<title>Mail List: Auto Responder Message Update</title>
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
	<cflocation url="auto_responder_messageLists.cfm" addtoken="no">
<cfelse>
</cfif>

<cfinclude template="auto_responder_messageUpdateAct.cfm">

<cfif IsDefined("bSave")>
	<cfquery name="qGetMessage" datasource="#DSN#">
	SELECT *
	FROM auto_responder_messages
	WHERE MessageTempID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tempID#">
	</cfquery>
	<cfoutput query="getMessage">
		<cfset mid = #MessageID#>
	</cfoutput>
<cfelse>
	<cfquery name="qGetMessage" datasource="#DSN#">
	SELECT *
	FROM auto_responder_messages
	WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
	</cfquery>	
</cfif>
<cfif qGetMessage.RecordCount eq 0>
	<cflocation url="auto_responder_messageLists.cfm" addtoken="no">
</cfif>
<cfquery name="qAttachCheck" datasource="#DSN#">
	SELECT * FROM auto_responder_attachments
	WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
</cfquery>
<cfquery name="qListInfo" datasource="#DSN#">
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
                <td height="20" align="center" background="images/gradient-bar-dark-blue.gif" class="tdTipsHeader"><strong>Message
                  Preview</strong></td>
              </tr>
              <tr>
                <td align="center" bgcolor="#FFFFFF"><span class="bodyText"><img src="images/icon-help.gif" width="24" height="25"><br>
                  Click to
                  see a preview of how your HTML message will look when sent</span>
				  <form action="messagePreview.cfm?mid=<cfoutput>#qGetMessage.MessageID#&lid=#lid#</cfoutput>" method="post">
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
    <td width="2"><br><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">       
		<cfquery name="getSubLists" datasource="#DSN#">
			SELECT *
			FROM email_lists
			WHERE EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
				AND EmailListID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
		</cfquery>
		<form action="auto_responder_messageLists.cfm" method="post">
		<cfoutput>
		<input type="hidden" name="mid" value="#mid#">
		<input type="hidden" name="lidOrig" value="#lid#">
		</cfoutput>
		<cfif getSubLists.RecordCount gte 1>
		<tr align="center">
		  <td height="25" colspan="3" class="bodyText">Save a copy of this response
		    message to another list: 
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
              List: Update your Auto Response Message/Newsletter</strong><strong></strong></td>
        </tr>
        <tr> 
          <td height="2" colspan="3" class="tdHorizDivider"></td>
        </tr>
        <form action="#cgi.script_name#" method="post">
		<cfoutput>
		<input type="hidden" name="lid" value="#lid#">
		<input type="hidden" name="mid" value="#mid#">
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
          <cfform action="#cgi.script_name#" method="post" name="messageUpdate" enctype="multipart/form-data">
		  <cfoutput query="qGetMessage" maxrows="1">
		  <input type="hidden" name="mid" value="#MessageID#">
		  <input type="hidden" name="lid" value="#lid#">
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
		  <cfif qAttachCheck.RecordCount gte 1>
		  <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Attachment/s already present:</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left" class="bodyText">
			<cfloop query="qAttachCheck">#qAttachCheck.AttachmentFileName# (#qAttachCheck.AttachmentFileSize# bytes) 
			<input name="attachDelFlag" type="checkbox" value="#qAttachCheck.recID#"> [ check box to delete this attachment <img src="images/deleteDocIcon.gif"> ]<cfif qAttachCheck.CurrentRow neq qAttachCheck.RecordCount><br></cfif></cfloop></td>
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
		    <td height="22" colspan="3" align="center" nowrap class="bodyText"><strong>Message (HTML Version)</strong>:<br>
	        </td>
		    </tr>
		  <cfif qListInfo.EmailPersonalization eq 1>
		  <tr>
		    <td colspan="3" align="center" class="bodyText" bgcolor="##CCCCCC">The following personalization
		      variables are available to be used anywhere in your HTML message body<br>
              <strong>[First Name] [Last Name] [Email] [List] [Date Short] [Date Med] [Date Long]</strong>
			  </td>
		  </tr>
		  </cfif>		  
		  <tr>
		  	<td colspan="3" align="center" class="bodyText">
			
            <textarea name="MessageHTML" rows="4" cols="40" style="WIDTH: #editorWidth#; HEIGHT: #editorHeight#" wrap="virtual" id="MessageHTML">#HTMLEditFormat(MessageHTML)#</textarea>
			</td>
		  </tr>
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
            <td height="22" align="right" nowrap class="bodyText"><strong>Successful
                Subscribe Auto Response</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left">
			 <input name="ResponseType" type="radio" value="subscribe" <cfif SubscribeRequest eq 1>checked</cfif>><br>
			</td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Successful
                UN-SubscribeAuto Response</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left">
			 <input name="ResponseType" type="radio" value="unsubscribe" <cfif UnsubscribeRequest eq 1>checked</cfif>><br>
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
		    </td>
		    </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  </cfoutput>
		  </cfform>
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
