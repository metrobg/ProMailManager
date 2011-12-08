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
<title>Mail List: Create New Auto Responder Message</title>
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
	<cfparam name="editorWidth" default="#globals.DefaultEditorWidth#">
	<cfparam name="editorHeight" default="#globals.DefaultEditorHeight#">
	<cfscript>
		tmp1 = #RandRange(19, 1999)#;
		tmp2 = #RandRange(19, 1999)#;
		tmp3 = #RandRange(19, 1999)#;
		tmpEpoch = #int(now()/1000)#;
		tmpMessageID = tmp1&tmpEpoch&tmp2&tmp3;
		tmpMessageID = Left(tmpMessageID, 9);
	</cfscript>
	<cfquery name="qListInfo" datasource="#DSN#">
	SELECT EmailPersonalization, EmailListDesc FROM email_lists
	WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
	</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm">
	</td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">       
		<tr> 
          <td height="25" colspan="3" class="tdBackGrnd"><strong>Subscription
              List: Create a New Auto Responder Message/Newsletter</strong><strong></strong></td>
        </tr>
        <cfoutput>
		<form action="#cgi.script_name#" method="post">
		<input type="hidden" name="lid" value="#lid#">
		<tr align="left">
		  <td height="20" colspan="3" bgcolor="##CCCCCC" class="bodyText">Current Subscription List: #qListInfo.EmailListDesc#</td>
		</tr>
		<tr>
			<td colspan="3" align="center" class="bodyText">
			Update editor size: <strong>Width</strong>	        
			<select name="editorWidth" id="editorWidth" class="bodyText">
	          <option value="#editorWidth#" selected>#editorWidth#</option>
			  <option value="100%">100%</option>
			  <option value="90%">90%</option>
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
          <cfform action="auto_responder_messageLists.cfm" method="post" name="messageNew" enctype="multipart/form-data">
		  <cfoutput>
		  <input type="hidden" name="lid" value="#lid#">
		  <input type="hidden" name="tempID" value="#tmpMessageID#">
		  <input type="hidden" name="editorHeight" value="#editorHeight#">
		  <input type="hidden" name="editorWidth" value="#editorWidth#">
		  </cfoutput>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Auto Responder Message Name</strong>: </td>
            <td width="2" class="tdVertDivider"></td>
            <td align="left"><cfinput name="MessageName" type="text" size="50" required="yes" message="Please enter a Descriptive Name for this Message" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
          <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Auto Responder Message Subject</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="MessageSubject" type="text" size="50" maxlength="100" required="yes" message="Please enter a SUBJECT for this Message (Will be the subject line of the final email sent)" class="bodyText"></td>
          </tr>
		  <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Auto
                Responder Add an attachment <img src="images/attachment.jpg" width="18" height="16" align="absbottom"></strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><input type="file" name="attachmentFileField" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr align="center">
		    <td height="22" colspan="3" nowrap class="bodyText"><strong>Message (HTML Version)</strong>:<br>
	        
			</td>
		    </tr>
		  <cfif qListInfo.EmailPersonalization eq 1>
		  <tr>
		    <td colspan="3" align="center" class="bodyText" bgcolor="#CCCCCC">The following personalization
		      variables are available to be used anywhere in your HTML message body<br>
              <strong>[First Name] [Last Name] [Email] [List] [Date Short] [Date Med] [Date Long]</strong></td>
		  </tr>
		  </cfif>
          <cfparam name="importedHTMLMsg" default="">
		  <cfif (CGI.HTTP_USER_AGENT CONTAINS "Mac") OR (CGI.HTTP_USER_AGENT DOES NOT CONTAIN "MSIE")>
		  <tr> 
            <td colspan="3" align="center" valign="top"><textarea name="MessageHTML" cols="65" rows="10"><cfoutput>#importedHTMLMsg#</cfoutput></textarea>
            </td>
            </tr>
          <cfelse>
		  <tr>
		  	<td colspan="3" align="center" class="bodyText">
			The Font Face defaults to &quot;Verdana, Arial, Helvetica, sans-serif&quot;<br>
	        Size defaults to &quot;1&quot; if you do not specifically set the font or size
	        it will remain as such<br>
			<cfoutput>
			<cfmodule template="editor/fckeditor.cfm" 
				fckeditorbasepath="#globals.EditorPath#" 
				instancename="MessageHTML" 
				width="#editorWidth#" 
				height="#editorHeight#" 
				toolbarsetname="Default" 
				canupload="false" 
				canbrowse="false" 
				initialvalue="">
			</cfoutput>
			</td>
		  </tr>
		  
		  </cfif>
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr align="center">
		    <td height="22" colspan="3" nowrap class="bodyText"><strong>Message
	        (Text Version)</strong>:</td>
		    </tr>
		  <tr align="center" valign="top"> 
            <td colspan="3" nowrap class="bodyText"><textarea name="MessageTXT" cols="65" rows="10"></textarea>
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
              <input name="ResponseType" type="radio" value="subscribe" checked>
              <br>
            </td>
		    </tr>
		  <tr>
            <td height="22" align="right" nowrap class="bodyText"><strong>Successful
                UN-SubscribeAuto Response</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left">
              <input name="ResponseType" type="radio" value="unsubscribe">
              <br>
            </td>
		    </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr align="center">
		    <td height="25" colspan="3" nowrap bgcolor="#EEEEEE" class="bodyText"><input name="bSaveAR" type="submit" class="tdHeader" id="bSaveAR" value="Save Message"></td>
		    </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  </cfform>
		  <tr align="center">
		    <td height="18" colspan="3" align="center" nowrap bgcolor="#FFE9D2" class="bodyText">
			  <img src="../images/help_Animated.gif" width="10" height="10" align="absmiddle"> [<a href="javascript:popUpWindow('../docs/messageNew.htm', 'yes', 'yes', '50', '50', '650', '475')">click
		  for help on using this screen</a>]</td>
	      </tr>
          <tr>
      </table>
	</td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
