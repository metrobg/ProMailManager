<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        November 28, 2003
MBG Date Last Modified:    Dec 8 2011
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<cfparam name="EmailIDLinkAdded" default="0">
<cfparam name="EmailPersonalization" default="0">
<cfparam name="EmailMessageGlobalFontFace" default="1">
<cfif IsDefined("bUpdate")>
	<cfquery name="updateListDetails" datasource="#DSN#">
	UPDATE email_lists
	SET EmailListDesc = '#EmailListDesc#',
		EmailListFromEmail = '#EmailListFromEmail#',
		EmailListReplyToEmail = '#EmailListReplyToEmail#',
		EmailListSMTPServer = '#EmailListSMTPServer#',
		EmailListPOPServer = '#EmailListPOPServer#',
		EmailListPOPLogin = '#EmailListPOPLogin#',
		EmailListPOPPwd = '#EmailListPOPPwd#',
		EmailListGlobalHeader = '#EmailListGlobalHeader#',
		EmailListGlobalFooter = '#EmailListGlobalFooter#',
		EmailListGlobalHeaderHTML = '#EmailListGlobalHeaderHTML#',
		EmailListGlobalFooterHTML = '#EmailListGlobalFooterHTML#',
		EmailMessageGlobalFontFace = '#EmailMessageGlobalFontFace#',
		EmailMessageGlobalFontSize = '#EmailMessageGlobalFontSize#',
		EmailIDLinkAdded = #EmailIDLinkAdded#,
        From_NAME = '#EmailListFrom_Name#',
		EmailPersonalization = #EmailPersonalization#
		<cfif Session.AccessLevelID eq 1>
		,EmailListAdminID = #EmailListAdminID#
		</cfif>
	WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
	</cfquery>
<cfelseif IsDefined("bDelete")>
	<cfquery name="deleteList" datasource="#DSN#">
	DELETE FROM email_lists
	WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
	</cfquery>
	<cflocation url="subscriptionLists.cfm" addtoken="no">
<cfelse>
</cfif>
<cfquery name="getSubListInfo" datasource="#DSN#">
	SELECT *
	FROM email_lists
	WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Trim(lid)#">
</cfquery>
<cfquery name="fontFaces" datasource="#DSN#">
	SELECT *
	FROM font_faces
	ORDER BY FontFace
</cfquery>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main</title>
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
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm"> </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="18" colspan="3" class="tdBackGrnd"><strong>Subscription 
            List: Details</strong><strong></strong></td>
        </tr>
        <tr> 
          <td height="2" colspan="3" bgcolor="#666666"></td>
        </tr>
        <cfoutput query="getSubListInfo" maxrows="1"> 
          <cfform action="subscriptionListDetail.cfm" method="post">
		  <input type="hidden" name="lid" value="#EmailListID#">
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List Name</strong>: </td>
            <td width="2" class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListDesc" type="text" value="#EmailListDesc#" size="50" required="yes" message="Please enter a Descriptive Name for this List" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
          <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List From E-Mail Address</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListFromEmail" type="text" value="#EmailListFromEmail#" size="50" maxlength="100" required="yes" message="Please enter a FROM Email Address for this List" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
           <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List From Name</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListFrom_Name" type="text" value="#From_Name#" size="50" maxlength="100" required="no" message="Please enter a name for this email address" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr>
            <td height="22" align="right" nowrap class="bodyText"><strong>Email
                List Reply-To E-Mail Address</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><input name="EmailListReplyToEmail" type="text" value="#EmailListReplyToEmail#" size="50" maxlength="100" class="bodyText">
            </td>
		  </tr>
		  <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List SMTP Mail Server</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListSMTPServer" type="text" value="#EmailListSMTPServer#" size="50" maxlength="100" required="yes" message="Please enter an SMTP Server (to send mail out) for this List" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List POP Mail Server</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><input name="EmailListPOPServer" type="text" class="bodyText" value="#EmailListPOPServer#" size="50" maxlength="100"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List POP Server Login</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListPOPLogin" type="text" value="#EmailListPOPLogin#" size="50" maxlength="75" required="yes" message="Please enter a POP username for your account on your incoming Mail Server" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List POP Server Password</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListPOPPwd" type="text" value="#EmailListPOPPwd#" size="50" maxlength="100" required="yes" message="Please enter a POP password for your account on your incoming Mail Server" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="18" align="right" nowrap class="bodyText"><strong>Email 
              List Global Header</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><textarea name="EmailListGlobalHeader" cols="35" rows="4">#EmailListGlobalHeader#</textarea></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="18" align="right" nowrap class="bodyText"><strong>Email 
              List Global Footer</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><textarea name="EmailListGlobalFooter" cols="35" rows="4">#EmailListGlobalFooter#</textarea></td>
          </tr>
		  <tr>
            <td height="18" align="right" nowrap class="bodyText"><strong>Email
                List Global Header</strong> (HTML): </td>
            <td class="tdVertDivider"></td>
            <td align="left"><textarea name="EmailListGlobalHeaderHTML" cols="35" rows="4">#EmailListGlobalHeaderHTML#</textarea>
            </td>
		    </tr>
		  <tr>
		    <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
		  </tr>
		  <tr>
            <td height="18" align="right" nowrap class="bodyText"><strong>Email
                List Global Footer</strong> (HTML): </td>
            <td class="tdVertDivider"></td>
            <td align="left"><textarea name="EmailListGlobalFooterHTML" cols="35" rows="4">#EmailListGlobalFooterHTML#</textarea>
            </td>
		    </tr>
		  <tr>
            <td height="22" align="right" nowrap class="bodyText"><strong>Unsubscribe
                Text Font Face</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left">
			<select name="EmailMessageGlobalFontFace" class="bodyText">
					<option value="#getSubListInfo.EmailMessageGlobalFontFace#" selected>#getSubListInfo.EmailMessageGlobalFontFace#</option>
				<cfloop query="fontFaces">
					<option value="#fontFaces.FontFace#">#fontFaces.FontFace#</option>
				</cfloop>
			</select>
            </td>
		    </tr>
		  <tr>
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
		    </tr>
		  <tr>
            <td height="22" align="right" nowrap class="bodyText"><strong>Unsubscribe
              Text Font Size</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left">
			<select name="EmailMessageGlobalFontSize" class="bodyText">
				<option value="#getSubListInfo.EmailMessageGlobalFontSize#" selected>#getSubListInfo.EmailMessageGlobalFontSize#</option>				
				<option>1</option>
				<option>2</option>
				<option>3</option>
				<option>4</option>
				<option>5</option>
				<option>6</option>
				<option>7</option>
				<option>+1</option>
				<option>+2</option>
				<option>+3</option>
				<option>+4</option>
				<option>+5</option>
				<option>+6</option>
				<option>+7</option>
				<option>-1</option>
				<option>-2</option>
				<option>-3</option>
				<option>-4</option>
				<option>-5</option>
				<option>-6</option>
				<option>-7</option>
			</select>
            </td>
		    </tr>
		  <tr>
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
		  </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Allow
                Personalization variables in messages</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left">
			<select name="EmailPersonalization" class="bodyText">
              <option value="#getSubListInfo.EmailPersonalization#" selected><cfif #getSubListInfo.EmailPersonalization# eq 1>Yes<cfelse>No</cfif></option>
              <cfif #getSubListInfo.EmailPersonalization# eq 1>
			  	<option value="0">No</option>
			  <cfelse>
			  	<option value="1">Yes</option>
			  </cfif>
            </select>
			</td>
          </tr>
		  <tr>
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
		  </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Create
                click thru added details</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><select name="EmailIDLinkAdded" class="bodyText">
              <option value="#getSubListInfo.EmailIDLinkAdded#" selected><cfif #getSubListInfo.EmailIDLinkAdded# eq 1>Yes<cfelse>No</cfif></option>
              <cfif #getSubListInfo.EmailIDLinkAdded# eq 1>
			  	<option value="0">No</option>
			  <cfelse>
			  	<option value="1">Yes</option>
			  </cfif>
            </select></td>
          </tr>
		  <cfif Session.AccessLevelID eq 1>
			  <cfquery name="getAdminGroups" datasource="#DSN#">
				SELECT *
				FROM admin_access_levels
				ORDER BY AccessLevelDesc
			  </cfquery>
			  <cfquery name="getAdminGroupName" datasource="#DSN#">
				SELECT *
				FROM admin_access_levels
				WHERE AccessID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmailListAdminID#">
			  </cfquery>
		  <tr>
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
		  </tr>
		  <tr>
		    <td height="22" align="right" nowrap class="bodyText"><font color="##990000"><strong>List Administration
		      Group:</strong></font> </td>
		    <td class="tdVertDivider"></td>
		    <td align="left">
			<select name="EmailListAdminID" class="bodyText">
              <option value="#EmailListAdminID#" selected>#getAdminGroupName.AccessLevelDesc#</option>
              <cfloop query="getAdminGroups">
			  	<cfif getAdminGroups.AccessID neq getSubListInfo.EmailListAdminID>	
				<option value="#getAdminGroups.AccessID#">#getAdminGroups.AccessLevelDesc#</option>
				</cfif>
			  </cfloop>
            </select>
			</td>
		  </tr>
		  </cfif>
		  <tr>
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
		  </tr>
		  <tr align="center">
		    <td height="25" colspan="3" nowrap bgcolor="##EEEEEE" class="bodyText"><input type="submit" name="bUpdate" value="Update" class="tdHeader">
		       &nbsp;
	          <input name="bDelete" type="submit" class="tdHeader" id="bDelete" value="Delete" onClick="return confirm('Are you sure you want to DELETE this List')"></td>
		    </tr>
          </cfform>
        </cfoutput>
		  <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr align="center" bgcolor="#FFE9D2">
		    <td height="18" colspan="3" nowrap class="bodyText"><img src="../images/help_Animated.gif" width="10" height="10" align="absmiddle"> [<a href="javascript:popUpWindow('../docs/listSetup.htm', 'yes', 'yes', '50', '50', '650', '475')">click
	        for help on using this screen</a>]</td>
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
