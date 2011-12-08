<!---
=====================================================================
Mail List Version 2.1

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        August 15, 2003
MBG Last Modified:			Dec 8 20111
=====================================================================
 --->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!--- <link href=" rel="stylesheet" type="text/css"> --->
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> 
    <cfinclude template="globals/_navSidebar.cfm"> </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="18" colspan="3" class="tdBackGrnd"><strong>Subscription
               List: Create New List</strong><strong></strong></td>
        </tr>
        <tr> 
          <td height="2" colspan="3" bgcolor="#666666"></td>
        </tr>
          <cfform action="subscriptionLists.cfm" method="post">
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List Name</strong>: </td>
            <td width="2" class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListDesc" type="text" size="50" maxlength="50" required="yes" message="Please enter a Descriptive Name for this List" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
          <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List From E-Mail Address</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListFromEmail" type="text" size="50" maxlength="100" required="yes" message="Please enter a FROM Email Address for this List" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
          <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List From Name</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListFrom_Name" type="text" size="50" maxlength="100" required="yes" message="Please enter a FROM Name for this List" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List SMTP Mail Server</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left">
            <cfinput name="EmailListSMTPServer" type="text" size="50" maxlength="100" required="yes" message="Please enter an SMTP Server (to send mail out) for this List" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List POP Mail Server</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><input name="EmailListPOPServer" type="text" class="bodyText" size="50" maxlength="100"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List POP Server Login</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListPOPLogin" type="text" size="50" maxlength="75" required="yes" message="Please enter a POP username for your account on your incoming Mail Server" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="22" align="right" nowrap class="bodyText"><strong>Email 
              List POP Server Password</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><cfinput name="EmailListPOPPwd" type="text" size="50" maxlength="100" required="yes" message="Please enter a POP password for your account on your incoming Mail Server" class="bodyText"></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="18" align="right" nowrap class="bodyText"><strong>Email 
              List Global Header</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><textarea name="EmailListGlobalHeader" cols="35" rows="4"></textarea></td>
          </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
          </tr>
		  <tr> 
            <td height="18" align="right" nowrap class="bodyText"><strong>Email 
              List Global Footer</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><textarea name="EmailListGlobalFooter" cols="35" rows="4"></textarea></td>
          </tr>
		  <tr>
            <td height="18" align="right" nowrap class="bodyText"><strong>Email
                List Global Header (HTML)</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><textarea name="EmailListGlobalHeaderHTML" cols="35" rows="4"></textarea>
            </td>
		    </tr>
		  <tr>
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
		    </tr>
		  <tr>
            <td height="18" align="right" nowrap class="bodyText"><strong>Email
                List Global Footer (HTML)</strong>: </td>
            <td class="tdVertDivider"></td>
            <td align="left"><textarea name="EmailListGlobalFooterHTML" cols="35" rows="4"></textarea>
            </td>
		    </tr>
		  <tr>
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
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
				WHERE AccessID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
			  </cfquery>
		  <tr>
            <td height="22" align="right" nowrap class="bodyText"><font color="#990000"><strong>List
                  Administration Group:</strong></font> </td>
            <td class="tdVertDivider"></td>
            <td align="left">
              <select name="OverrideAdminID" class="bodyText">
                <cfoutput><option value="#Session.AccessLevelID#" selected>#getAdminGroupName.AccessLevelDesc#</option></cfoutput>
                <cfloop query="getAdminGroups">
                  <cfif getAdminGroups.AccessID neq Session.AccessLevelID>
                    <cfoutput><option value="#getAdminGroups.AccessID#">#getAdminGroups.AccessLevelDesc#</option></cfoutput>
                  </cfif>
                </cfloop>
              </select>
            </td>
		  </tr>
		  </cfif>
		  <tr align="center" bgcolor="#EEEEEE">
		    <td height="25" colspan="3" nowrap class="bodyText"><input name="bNewList" type="submit" class="tdHeader" id="bNewList" value="Create New List"></td>
		  </tr>
          <tr> 
            <td height="1" colspan="3" align="right" class="tdHorizDivider"></td>
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
