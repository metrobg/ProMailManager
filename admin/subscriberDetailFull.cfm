<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        January 1, 2004
=====================================================================
 -->
<html>
<head>
<title>Subscriber Full Detail</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
	<script language="JavaScript" type="text/JavaScript">
		function doClose()
		{
			setTimeout( "close()", 3000 );

		}
	</script>
</head>
<body<cfif IsDefined("bDelete")> onLoad="doClose()"</cfif>>
<cfparam name="list" default="active">

<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
      <td height="18" colspan="5" align="right" class="bodyText">[<a href="javascript:window.close()">x</a>] <a href="javascript:window.close()">close window</a></td>
    </tr>
  <cfif IsDefined("bUpdate")>
    <cfquery name="updateSubscriber" datasource="#DSN#">
    UPDATE <cfif list eq "active">email_addresses<cfelse>email_addresses_removed</cfif> 
	SET EmailAddress = '#EmailAddress#', 
	FirstName = '#FirstName#',
    LastName = '#LastName#', 
	City = '#City#', 
	State = '#State#', 
	ZipCode = '#ZipCode#',
	Country = '#Country#',
	PhoneNumber = '#PhoneNumber#',
	CellNumber = '#CellNumber#',
	Custom1 = '#Custom1#', 
	Custom2 = '#Custom2#', 
	Custom3 = '#Custom3#', 
	Custom4 = '#Custom4#', 
	Custom5 = '#Custom5#'
    WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">
    </cfquery>
    <tr>
      <td height="18" colspan="5" align="center"><span class="adminUpdateSuccessful">The
          selected Subscriber has been updated</span></td>
    </tr>
  <cfelseif IsDefined("bDelete")>
    <cfquery name="removeSubscriber" datasource="#DSN#">
    DELETE FROM <cfif list eq "active">email_addresses<cfelse>email_addresses_removed</cfif> WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">
    </cfquery>
    <tr>
      <td height="18" colspan="5" align="center"><span class="adminRemoveSuccessful">The
          selected Subscriber has been removed</span></td>
    </tr>
  <cfelse>
  </cfif>

    <cfquery name="getSubscriberDetail" datasource="#DSN#">
    SELECT * FROM <cfif list eq "active">email_addresses<cfelse>email_addresses_removed</cfif>
    WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
    AND EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">
    </cfquery>
  
  <cfparam name="email" default="">
  
  <tr bgcolor="#CCCCCC">
    <td height="1" colspan="5" align="center" class="tdVertDivider"></td>
  </tr>
  <tr>
    <td align="center" nowrap class="tdBackGrnd">&nbsp;</td>
    <td height="18" colspan="4" align="center" nowrap class="tdBackGrnd"><strong>Subscriber
        Detail</strong><strong> (Update/View)</strong></td>
  </tr>
  <tr>
    <td height="2" colspan="5" class="tdHorizDivider"></td>
  </tr>
  <cfoutput query="getSubscriberDetail" maxrows="1">
    <cfform action="#cgi.script_name#" method="post">
      <input type="hidden" name="sid" value="#EmailID#">
      <input type="hidden" name="lid" value="#lid#">
	  <input type="hidden" name="list" value="#list#">     
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" colspan="4" align="left" nowrap class="bodyText">
		<cfif list eq "active">Date Added: #DateFormat(DateAdded, globals.DateDisplay)#<cfelse>Date Unsubscribed: #DateFormat(DateRemoved, globals.DateDisplay)#</cfif>
		</td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">          
		Email Address: 
		
        </td>
        <td width="1" class="tdVertDivider"></td>
        <td align="left" class="bodyText"><img src="images/spacer_white.gif" width="5" height="5"></td>
        <td align="left" class="bodyText">
		  <cfinput name="EmailAddress" type="text" value="#EmailAddress#" size="35" maxlength="100" required="yes" message="You must enter a User Name (please no spaces)" class="bodyText">
          <cfif Bounced eq 1>
            <img src="../images/bouncedBombRed.gif" width="20" height="17" align="absmiddle">
            <cfquery name="getBounceLog" datasource="#DSN#">
            SELECT * FROM bounce_log WHERE EmailAddressID =
            <cfqueryparam cfsqltype="cf_sql_integer" value="#EmailID#">
            </cfquery>
            [<a href="javascript:popUpWindow('addressBounceLog.cfm?EmailID=#EmailID#', 'yes', 'no', '50', '50', '400', '400')">#getBounceLog.RecordCount#</a>]
          </cfif>
          <cfif ExceededMailQuota eq 1>
            <img src="../images/bouncedBomb.gif" width="20" height="17" align="absmiddle">
          </cfif>
		</td>
      </tr>
      <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">First Name:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="FirstName" type="text" value="#FirstName#" size="15" maxlength="75" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">Last Name:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="LastName" type="text" value="#LastName#" size="15" maxlength="75" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">City:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="City" type="text" value="#City#" size="10" maxlength="75" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">State:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="State" type="text" value="#State#" size="5" maxlength="10" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">Zip/Post Code:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="ZipCode" type="text" value="#ZipCode#" size="6" maxlength="10" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">Phone Number:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="PhoneNumber" type="text" value="#Trim(PhoneNumber)#" size="15" maxlength="30" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">Cell Number:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="CellNumber" type="text" value="#Trim(CellNumber)#" size="15" maxlength="30" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">Country:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="Country" type="text" value="#Country#" size="30" maxlength="75" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" colspan="4" align="left" nowrap class="bodyText"><strong>Custom
          Fields [1 - 5]</strong></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">[1] <cfif Len(globals.Custom1Name) neq 0>#globals.Custom1Name#<cfelse>Custom Field 1</cfif>:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="Custom1" type="text" value="#Custom1#" size="30" maxlength="75" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">[2] <cfif Len(globals.Custom2Name) neq 0>#globals.Custom2Name#<cfelse>Custom Field 2</cfif>:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="Custom2" type="text" value="#Custom2#" size="30" maxlength="75" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">[3] <cfif Len(globals.Custom3Name) neq 0>#globals.Custom3Name#<cfelse>Custom Field 3</cfif>:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="Custom3" type="text" value="#Custom3#" size="30" maxlength="75" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">[4] <cfif Len(globals.Custom4Name) neq 0>#globals.Custom4Name#<cfelse>Custom Field 4</cfif>:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="Custom4" type="text" value="#Custom4#" size="30" maxlength="75" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" align="left" nowrap class="bodyText">[5] <cfif Len(globals.Custom5Name) neq 0>#globals.Custom5Name#<cfelse>Custom Field 5</cfif>:</td>
        <td class="tdVertDivider"></td>
        <td align="left" class="bodyText">&nbsp;</td>
        <td align="left" class="bodyText"><input name="Custom5" type="text" value="#Custom5#" size="30" maxlength="75" class="bodyText"></td>
      </tr>
	  <tr>
        <td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
        <td height="1" colspan="4" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td align="left" nowrap class="bodyText">&nbsp;</td>
        <td height="22" colspan="4" align="center" nowrap class="bodyText"><input name="bUpdate" type="submit" class="tdHeader" id="bUpdate" value="Update">
          <img src="images/spacer_transparent.gif" width="10" height="5">
        <input name="bDelete" type="submit" class="tdHeader" id="bDelete" value="Remove" onClick="return confirm('Are you sure you want to DELETE This subscriber')"></td>
      </tr>
      <tr>
        <td height="1" colspan="5" class="tdVertDivider"></td>
      </tr>
    </cfform>
  </cfoutput>
    <tr>
      <td height="30" colspan="5" align="center" valign="middle" class="bodyText"><table width="70%" border="0" align="center" cellpadding="2" cellspacing="2">
          <tr>
            <td width="6%" align="right"><img src="../images/bouncedBombRed.gif" width="20" height="17"></td>
            <td width="94%" nowrap class="bodyText">denotes Email address has
              bounced on a recent broadcast)</td>
          </tr>
          <tr>
            <td align="right"><img src="../images/bouncedBomb.gif"></td>
            <td nowrap class="bodyText">denotes Email address has bounced on
              a recent broadcast due to exceeding mailbox allocation</td>
          </tr>
        </table>
      </td>
    </tr>

</table>
</body>
</html>
