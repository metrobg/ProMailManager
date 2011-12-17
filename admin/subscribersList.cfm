<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 4, 2003
Date Last Modified:        NOvember 27, 2003
MBG Modified 12/11/11
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
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
    <td width="180" valign="top">
      <cfinclude template="globals/_navSidebar.cfm">
    </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <cfif IsDefined("bAdd")  AND Len(Trim(EmailAddress)) neq 0>
          <cfmodule template="adminpro_emailValidate.cfm" email="#EmailAddress#">
          <cfquery name="checkEmailExists" datasource="#DSN#">
          SELECT * FROM email_addresses WHERE lower(EmailAddress) =
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(EmailAddress)#">
          AND ListID =
          <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
          </cfquery>
		  <cfif Error eq 0 AND checkEmailExists.RecordCount eq 0>
            <cfquery name="addSubscriber" datasource="#DSN#">
            INSERT INTO email_addresses (ListID, EmailAddress, FirstName, LastName, City, State, ZipCode, Country, PhoneNumber, CellNumber, Custom1, Custom2, Custom3, Custom4, Custom5, DateAdded)
	  		VALUES (#lid#, '#lcase(EmailAddress)#', '#FirstName#', '#LastName#', '#City#', '#State#', '#ZipCode#', '#Country#', '#PhoneNumber#', '#CellNumber#', '#Custom1#', '#Custom2#', '#Custom3#', '#Custom4#', '#Custom5#', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
            </cfquery>
            <tr>
              <td height="18" colspan="15" align="center"><span class="adminUpdateSuccessful">The
                  new Subscriber has added</span></td>
            </tr>
          </cfif>
          <cfelseif IsDefined("bUpdate")  AND Len(Trim(EmailAddress)) neq 0>
          <cfquery name="updateSubscriber" datasource="#DSN#">
			  UPDATE email_addresses SET EmailAddress = '#lcase(EmailAddress)#', 
			  FirstName = '#FirstName#', 
			  LastName = '#LastName#', 
			  City = '#City#', 
			  State = '#State#', 
			  ZipCode = '#ZipCode#' 
			  WHERE EmailID =<cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">
          </cfquery>
          <tr>
            <td height="18" colspan="15" align="center"><span class="adminUpdateSuccessful">The
                selected Subscriber has been updated</span></td>
          </tr>
          <cfelseif IsDefined("bDelete")  AND Len(Trim(EmailAddress)) neq 0>
          <cfquery name="removeSubscriber" datasource="#DSN#">
          DELETE FROM email_addresses WHERE EmailID =
          <cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">
          </cfquery>
          <tr>
            <td height="18" colspan="15" align="center"><span class="adminRemoveSuccessful">The
                selected Subscriber has been removed</span></td>
          </tr>
          <cfelseif IsDefined("bDeleteFrmRemoved")>
          <cfquery name="removeSubscriberFromRemoved" datasource="#DSN#">
          	DELETE FROM email_addresses_removed WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">
          </cfquery>
          <tr>
            <td height="18" colspan="15" align="center"><span class="adminRemoveSuccessful">The
                selected Subscriber has been removed</span></td>
          </tr>
          <cfelseif IsDefined("bReactivate")>
			  <cfquery name="qSubscriber" datasource="#DSN#">
				SELECT * FROM email_addresses_removed WHERE EmailID = #sid#
			  </cfquery>
			  <cfquery name="removeSubscriberFromRemoved" datasource="#DSN#">
				DELETE FROM email_addresses_removed WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">
			  </cfquery>
			  <cfquery name="checkEmailExists" datasource="#DSN#">
				SELECT * FROM email_addresses WHERE EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qSubscriber.EmailAddress#">
				AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
			  </cfquery>
			  <cfif checkEmailExists.RecordCount eq 0>
				<cfquery name="addSubscriber" datasource="#DSN#">
				INSERT INTO email_addresses (ListID, EmailAddress, FirstName, LastName, City, State, ZipCode, Country, PhoneNumber, CellNumber, Custom1, Custom2, Custom3, Custom4, Custom5)
	  			VALUES (#lid#, '#lcase(qSubscriber.EmailAddress)#', '#qSubscriber.FirstName#', '#qSubscriber.LastName#', '#qSubscriber.City#', '#qSubscriber.State#', '#qSubscriber.ZipCode#', '#qSubscriber.Country#', '#qSubscriber.PhoneNumber#', '#qSubscriber.CellNumber#', '#qSubscriber.Custom1#', '#qSubscriber.Custom2#', '#qSubscriber.Custom3#', '#qSubscriber.Custom4#', '#qSubscriber.Custom5#')
			  </cfquery>
            <tr>
              <td height="18" colspan="15" align="center"><span class="adminUpdateSuccessful">The
                  Subscriber has re-activated</span></td>
            </tr>
          </cfif>
          <tr>
            <td height="18" colspan="15" align="center"><span class="adminRemoveSuccessful">The
                selected Subscriber has been removed</span></td>
          </tr>
          <cfelse>
        </cfif>
        <cfif IsDefined("act") AND act eq "subshow">
          <!--- If view subscribers selected from Menu, need to check if current has 1 or more lists --->
          <cfquery name="getSubListDetails" datasource="#DSN#">
          SELECT * FROM email_lists WHERE EmailListAdminID =
          <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
          </cfquery>
          <cfif getSubListDetails.RecordCount eq 1>
            <cfset lid = #getSubListDetails.EmailListID#>
            <cfset list = "active">
            <!--- Admin user has only 1 list can go direct to view active subscribers for this list --->
            <cfquery name="getSubscribers" datasource="#DSN#">
            SELECT * FROM email_addresses WHERE ListID =
            <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
            ORDER BY ExceededMailQuota DESC, Bounced DESC
            </cfquery>
            <cfelse>
            <!--- View subscribers selected but admin has more then 1 list available, must redirect to list
				view then choose subscriber list from there --->
            <cflocation url="subscriptionLists.cfm?viewsub=1" addtoken="no">
          </cfif>
          <cfelse>
          <cfquery name="getSubscribers" datasource="#DSN#">
          SELECT *
          <cfif IsDefined("list") AND list eq "active">
            FROM email_addresses
            <cfelseif IsDefined("list") AND list eq "removed">
            FROM email_addresses_removed
            <cfelse>
            <cflocation url="subscriptionLists.cfm" addtoken="no">
          </cfif>
          WHERE ListID = #lid#
          <cfif IsDefined("bEmailSearch")>
            AND lower(EmailAddress) LIKE '%#lcase(email)#%'
          </cfif>
          <cfif IsDefined("list") AND list eq "active">
            ORDER BY ExceededMailQuota DESC, Bounced DESC, EmailAddress
            <cfelseif IsDefined("list") AND list eq "removed">
            ORDER BY DateRemoved DESC
            <cfelse>
          </cfif>
          </cfquery>
        </cfif>
        <cfparam name="email" default="">
        <!--- RecordCount --->
        <cfparam name="mystartrow" default="1">
        <cfparam name="realstartrow" default="1">
        <cfparam name="maxPages" default="#globals.subscribersList_MaxPages#">
        <cfparam name="maxRows" default="#globals.subscribersList_MaxRows#">
        <cfparam name="cfmx" default="#globals.cfmxInstalled#">
        <cfset request.RCQuery = getSubscribers>
        <cfset currentGroupID = 0>
        <tr>
          <td colspan="15" class="bodyText"> (<cf_recordcountml
			part="recordcount"
			mystartrow="#mystartrow#"
			realstartrow="#realstartrow#"
			group="EmailID"
			mymaxrows="#maxRows#"
			rcitem="Subscriber"
			cfmx="#cfmx#">) <br>
            <cf_recordcountml
			template="subscribersList.cfm"
			part="link"
			rcresults="#RCResults#"
			prevstart="#PrevStart#"
			nextstart="#NextStart#"
			realprevstart="#RealPrevStart#"
			realnextstart="#RealNextStart#"
			mymaxrows="#maxrows#"
			mymaxpages="#maxPages#"
			pagecount="#pagecount#"
			thispage="#thispage#" > </td>
        </tr>
        <tr>
          <cfform action="subscribersList.cfm" method="post">
            <input type="hidden" name="list" value="active">
            <cfoutput>
              <input type="hidden" name="lid" value="#lid#">
              <input type="hidden" name="mystartrow" value="#mystartrow#">
              <input type="hidden" name="realstartrow" value="#realstartrow#">
            </cfoutput>
            <td height="18" colspan="15" class="bodyText"><strong>Subscriber
                List: [Search for an email:
              <cfinput name="email" type="text" size="25" maxlength="100" required="yes" message="Please enter a valid E-Mail address before continuing" class="bodyText">
              <input name="bEmailSearch" type="submit" class="buttonTestSend" id="bEmailSearch" value="Search">
              ] </strong><a href="subscribersList.cfm?lid=<cfoutput>#lid#&list=#list#</cfoutput>">View
              All Subscribers</a> </td>
          </cfform>
        </tr>
        <tr>
          <td height="1" colspan="15" nowrap class="tdHorizDivider"></td>
        </tr>
        <tr>
          <td height="18" align="center" nowrap class="tdBackGrnd"><strong>Email
              Address</strong></td>
          <td class="tdVertDivider" width="1" nowrap></td>
          <td align="center" class="tdBackGrnd"><strong>First Name</strong></td>
          <td class="tdVertDivider" width="1" nowrap></td>
          <td align="center" class="tdBackGrnd"><strong>Last Name</strong></td>
          <td class="tdVertDivider" width="1" nowrap></td>
          <td align="center" class="tdBackGrnd"><strong>City</strong></td>
          <td class="tdVertDivider" width="1" nowrap></td>
          <td align="center" class="tdBackGrnd"><strong>State</strong></td>
          <td class="tdVertDivider" width="1" nowrap></td>
          <td align="center" class="tdBackGrnd"><strong>Zip</strong>&nbsp;</td>
          <td class="tdVertDivider" width="1" nowrap></td>
          <cfif list eq "active">
            <td align="center" class="tdBackGrnd"><strong>Update</strong>&nbsp;</td>
            <cfelse>
            <td align="center" class="tdBackGrnd"><strong>Date<br>
              Unsubscribed</strong>&nbsp;</td>
          </cfif>
          <td class="tdVertDivider" width="1" nowrap></td>
          <cfif list eq "active">
            <td align="center" class="tdBackGrnd"><strong>Remove</strong></td>
            <cfelse>
            <td align="center" class="tdBackGrnd"><strong>Reactivate/Remove</strong></td>
          </cfif>
        </tr>
        <tr>
          <td height="2" colspan="15" class="tdHorizDivider"></td>
        </tr>
        <cfoutput query="getSubscribers" startrow="#realstartrow#" maxrows="#maxRows#">
          <cfform action="subscribersList.cfm" method="post">
            <input type="hidden" name="sid" value="#EmailID#">
            <input type="hidden" name="lid" value="#lid#">
            <input type="hidden" name="list" value="#list#">
            <input type="hidden" name="mystartrow" value="#mystartrow#">
            <input type="hidden" name="realstartrow" value="#realstartrow#">
            <cfif IsDefined("bEmailSearch")>
              <input type="hidden" name="bEmailSearch" value="Search">
              <input type="hidden" name="email" value="#email#">
            </cfif>
            <tr>
              <td height="22" align="left" nowrap class="bodyText"> 
			    <a href="javascript:popUpWindow('subscriberDetailFull.cfm?sid=#EmailID#&lid=#lid#&list=#list#', 'yes', 'yes', '50', '50', '550', '500')"><cfif Duplicate eq 1><img src="../images/icon-subscriber-bad.gif" width="24" height="18" align="absmiddle" border="0" title="This is a badly formatted address"><cfelse><img src="../images/icon-subscriber.gif" width="24" height="18" align="absmiddle" border="0" title="Click to view extended information for this subscriber"></cfif></a>
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
              <td width="1" class="tdVertDivider"></td>
              <td align="center" class="bodyText"><input name="FirstName" type="text" value="#FirstName#" size="15" maxlength="75" class="bodyText">
              </td>
              <td class="tdVertDivider" width="1"></td>
              <td align="center" class="bodyText">
                <input name="LastName" type="text" value="#LastName#" size="15" maxlength="75" class="bodyText">
              </td>
              <td width="1" class="tdVertDivider"></td>
              <td align="center" class="bodyText"><input name="City" type="text" value="#City#" size="10" maxlength="75" class="bodyText">
              </td>
              <td width="1" class="tdVertDivider"></td>
              <td align="center" class="bodyText"><input name="State" type="text" value="#State#" size="5" maxlength="10" class="bodyText">
              </td>
              <td width="1" class="tdVertDivider"></td>
              <td align="center" class="bodyText"><input name="ZipCode" type="text" value="#ZipCode#" size="6" maxlength="10" class="bodyText">
              </td>
              <td width="1" class="tdVertDivider"></td>
              <cfif list eq "active">
                <td align="center" class="bodyText"><input name="bUpdate" type="submit" class="tdHeader" id="bUpdate" value="Update">
                </td>
                <cfelse>
                <td align="center" class="bodyText">#DateFormat(DateRemoved, globals.DateDisplay)#</td>
              </cfif>
              <td width="1" class="tdVertDivider"></td>
              <cfif list eq "active">
                <td class="bodyText" align="center"><input name="bDelete" type="submit" class="tdHeader" id="bDelete" value="Remove" onClick="return confirm('Are you sure you want to DELETE This subscriber')">
                </td>
                <cfelse>
                <td class="bodyText" align="center"><input name="bReactivate" type="submit" class="tdHeader" id="bReactivate" value=" + ">
                  <input name="bDeleteFrmRemoved" type="submit" class="tdHeader" id="bDeleteFrmRemoved" value=" - ">
                </td>
              </cfif>
            </tr>
            <tr>
              <td height="1" colspan="15" class="tdVertDivider"></td>
            </tr>
          </cfform>
        </cfoutput>
        <tr>
          <td colspan="15" class="bodyText"> <cf_recordcountml
			template="subscribersList.cfm"
			part="link"
			rcresults="#RCResults#"
			prevstart="#PrevStart#"
			nextstart="#NextStart#"
			realprevstart="#RealPrevStart#"
			realnextstart="#RealNextStart#"
			mymaxrows="#maxrows#"
			mymaxpages="#maxPages#"
			pagecount="#pagecount#"
			thispage="#thispage#"> </td>
        </tr>
        <tr>
          <td height="8" colspan="15"></td>
        </tr>
        <cfif list eq "active">
          <cfform action="subscribersList.cfm" method="post">
            <cfoutput>
              <input type="hidden" name="lid" value="#lid#">
              <input type="hidden" name="list" value="#list#">
            </cfoutput>
            <tr>
              <td colspan="15">
			  <!--- Add a new subscriber open --->
				<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
				  <tr bgcolor="##CCCCCC">
					<td height="1" colspan="6" align="center" class="tdVertDivider"></td>
				  </tr>
				  <tr>
					<td align="center" nowrap class="tdBackGrnd">&nbsp;</td>
					<td height="18" colspan="4" align="center" nowrap class="adminAddNewTdBackGrnd"><span class="bodyText"><strong>Subscriber
						</strong> (Add New)</span></td>
					<td height="18" align="center" nowrap class="tdBackGrnd">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="2" colspan="6" class="tdHorizDivider"></td>
				  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText"> Email Address: </td>
						<td width="1" class="tdVertDivider"></td>
						<td align="left" class="bodyText"><img src="images/spacer_white.gif" width="5" height="5"></td>
						<td align="left" class="bodyText">
						  <cfinput name="EmailAddress" type="text" size="35" maxlength="100" required="yes" message="You must enter a User Name (please no spaces)" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">First Name:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="FirstName" type="text" size="15" maxlength="75" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">Last Name:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="LastName" type="text" size="15" maxlength="75" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">City:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="City" type="text" size="10" maxlength="75" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">State:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="State" type="text" size="5" maxlength="30" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">Zip/Post Code:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="ZipCode" type="text" size="6" maxlength="15" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">Phone Number:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="PhoneNumber" type="text" size="15" maxlength="30" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">Cell Number:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="CellNumber" type="text" size="15" maxlength="30" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">Country:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="Country" type="text" size="30" maxlength="75" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" colspan="5" align="left" nowrap class="bodyText"><strong>Custom
							Fields [1 - 5]</strong></td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <cfoutput>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">[1]
							<cfif Len(globals.Custom1Name) neq 0>
							  #globals.Custom1Name#
								<cfelse>
								Custom Field 1
							</cfif>
							:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="Custom1" type="text" size="30" maxlength="75" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">[2]
							<cfif Len(globals.Custom2Name) neq 0>
							  #globals.Custom2Name#
								<cfelse>
								Custom Field 2
							</cfif>
							:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="Custom2" type="text" size="30" maxlength="75" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">[3]
							<cfif Len(globals.Custom3Name) neq 0>
							  #globals.Custom3Name#
								<cfelse>
								Custom Field 3
							</cfif>
							:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="Custom3" type="text" size="30" maxlength="75" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">[4]
							<cfif Len(globals.Custom4Name) neq 0>
							  #globals.Custom4Name#
								<cfelse>
								Custom Field 4
							</cfif>
							:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="Custom4" type="text" ize="30" maxlength="75" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" align="left" nowrap class="bodyText">[5]
							<cfif Len(globals.Custom5Name) neq 0>
							  #globals.Custom5Name#
								<cfelse>
								Custom Field 5
							</cfif>
							:</td>
						<td class="tdVertDivider"></td>
						<td align="left" class="bodyText">&nbsp;</td>
						<td align="left" class="bodyText"><input name="Custom5" type="text"size="30" maxlength="75" class="bodyText">
						</td>
						<td align="left" class="bodyText">&nbsp;</td>
					  </tr>
					  </cfoutput>
					  <tr>
						<td height="1" align="left" nowrap class="bodyText"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
						<td height="1" colspan="5" align="left" nowrap class="tdHorizDivider"><img src="images/spacer_transparent.gif" width="1" height="1"></td>
					  </tr>
					  <tr>
						<td align="left" nowrap class="bodyText">&nbsp;</td>
						<td height="22" colspan="5" align="center" nowrap class="bodyText">
							<input name="bAdd" type="submit" class="tdHeader" id="bAdd" value="Add">
						</td>
					  </tr>
					  <tr>
						<td height="1" colspan="6" class="tdVertDivider"></td>
					  </tr>
				</table>
				<!--- Add a new subscriber close --->
			  </td>
            </tr>
          </cfform>
        </cfif>
        <cfif list eq "active">
          <tr>
            <td height="30" colspan="15" align="center" valign="middle" bgcolor="#EEEEEE" class="bodyText"><img src="../images/importIconGrn.gif" width="12" height="15" border="0" align="absmiddle"> <strong><a href="subscribersImport.cfm?lid=<cfoutput>#lid#</cfoutput>">Import
                  a Subscriber List</a></strong></td>
          </tr>
          <tr>
            <td height="30" colspan="15" align="center" valign="middle" class="bodyText"><table width="70%" border="0" align="center" cellpadding="2" cellspacing="2">
                <tr>
                  <td width="6%" align="right"><img src="../images/bouncedBombRed.gif" width="20" height="17"></td>
                  <td width="94%" nowrap class="bodyText">denotes Email address
                    has bounced on a recent broadcast)</td>
                </tr>
                <tr>
                  <td align="right"><img src="../images/bouncedBomb.gif"></td>
                  <td nowrap class="bodyText">denotes Email address has bounced
                    on a recent broadcast due to exceeding mailbox allocation</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td height="18" colspan="15" align="center" valign="middle" bgcolor="#FFE9D2" class="bodyText"><img src="../images/help_Animated.gif" width="10" height="10" align="absmiddle"> [<a href="javascript:popUpWindow('../docs/subscriberAdmin.htm', 'yes', 'yes', '50', '50', '650', '475')">click
            for help on using this screen</a>]</td>
          </tr>
        </cfif>
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
