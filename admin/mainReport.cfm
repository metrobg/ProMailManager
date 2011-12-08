<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        December 16, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<cfquery name="getSubListCount" datasource="#DSN#">
			SELECT *
			FROM email_lists
			<cfif IsDefined("Session.AccessLevelDesc") AND Session.AccessLevelDesc eq "Administrator">
			<cfelse>
			WHERE EmailListAdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.AccessLevelID#">
			</cfif>
			ORDER BY EmailListDesc
</cfquery>
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
                <td align="center" valign="top" bgcolor="White"><span class="bodyText"><img src="images/icon-help.gif" width="24" height="25"></span></td>
              </tr>
              <tr>
                <td height="1"></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="White" class="bodyText"><img src="images/icon-new-message.gif" width="17" height="18"> <strong>-
                  Create a new message</strong></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="White"><span class="bodyText">                  Click
                    this icon below the desired list to go directly to create
                    a new message to be broadcast to your subscribers</span></td>
              </tr>
              <tr>
                <td height="1"></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="White" class="bodyText"><img src="../images/importIconGrn.gif" width="12" height="15" align="absmiddle"> <strong>-
                Import a list of emails</strong></td>
              </tr>
              <tr>
                <td align="center" valign="top" bgcolor="White" class="bodyText">Click
                  this icon to import a list of email addresses you have in either
                  a CSV (comma delimited) file or a text file (you can simply
                  paste a group of emails separated by a line feed into a text
                  area box)</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
	  <br>
	</td>
    <td width="2"><img src="../IMAGES/spacer_Transparent_1pixel.gif" width="2"></td>
    <td width="100%" valign="top"><cfinclude template="globals/_navHeader.cfm">
	<!--- Report Body Start --->
    <br>	
    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
	  <tr>
		<td valign="top"><table width="225" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td><img src="../images/ReportHeaderLists.gif" width="225" height="50"></td>
		    </tr>
		  </table>		  <table width="225" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="660000">
		  <tr>
		    <td bgcolor="660000"><table width="100%" border="0" cellpadding="0" cellspacing="0">
		      <tr>
		        <td height="1"></td>
		      </tr>
		      <tr>
		        <td bgcolor="White"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td height="20%" align="right" class="reportText"><strong><cfoutput>#getSubListCount.RecordCount#</cfoutput></strong></td>
                    <td width="2" class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                    <td height="18" class="reportText"><strong>Active Subscription
                        Lists</strong></td>
                  </tr>
                  <tr align="center">
                    <td height="1" colspan="3" bgcolor="#333333" class="reportText"><img src="../images/SPACERDOT_333333.JPG" width="1" height="1"></td>
                  </tr>
                  <tr>
                    <td align="right" class="reportText"><img src="../images/EDIT.GIF" width="8" height="12"></td>
                    <td width="2" class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                    <td height="18" class="reportText"><a href="subscribersList.cfm">Edit
                        subscription lists</a></td>
                  </tr>
                  <tr>
                    <td align="right" class="reportText"><img src="../images/icon-list.gif" width="15" height="15"></td>
                    <td class="reportText">&nbsp;</td>
                    <td height="18" class="reportText"><a href="subscriptionListNew.cfm">Create new subscription
                      list</a></td>
                  </tr>
                  <tr>
                    <td align="right" class="reportText"><img src="../images/EDIT.GIF" width="8" height="12"></td>
                    <td class="reportText">&nbsp;</td>
                    <td height="18" class="reportText"><a href="adminUserList.cfm">Add/edit
                        administrators</a></td>
                  </tr>
                </table></td>
		        </tr>
		      </table></td>
		    </tr>
		  </table>
		  <br>
		  <table width="225" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
              <td><img src="../images/ReportHeaderEmail.gif" width="225" height="50"></td>
            </tr>
          </table>
		  <table width="225" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="660000">
            <tr>
              <td bgcolor="660000"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td height="1"></td>
                  </tr>
                  <tr>
                    <td bgcolor="White"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <cfoutput query="getSubListCount">
						<cfquery name="getMessageCount" datasource="#DSN#">
						  SELECT COUNT(MessageID) AS MessageCnt FROM email_list_messages WHERE 
						  MessageListID = 
						  <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
						</cfquery>
						<cfquery name="getLastMessage" datasource="#DSN#" maxrows="1">
						  SELECT MessageListID, MessageCreateDate, MessageID
						  FROM email_list_messages 
						  WHERE MessageListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
						  ORDER BY MessageCreateDate DESC
						</cfquery>
						<tr align="center">
                          <td height="18" colspan="3" class="reportText" bgcolor="##83A2E0"><strong>#getSubListCount.EmailListDesc#</strong></td>
                          </tr>
                        <tr>
                          <td height="20%" align="right" class="reportText">#getMessageCount.MessageCnt#</td>
                          <td width="2" class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                          <td height="18" class="reportText">Number of Messages</td>
                        </tr>
                        <tr>
                          <td align="right" class="reportText">#DateFormat(getLastMessage.MessageCreateDate, globals.DateDisplay)#</td>
                          <td width="2" class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                          <td height="18" class="reportText">Date Last Message
                            Sent</td>
                        </tr>
                        <tr align="center">
                          <td height="1" colspan="3" bgcolor="##333333" class="reportText"><img src="../images/SPACERDOT_333333.JPG" width="1" height="1"></td>
                        </tr>
                        <tr>
                          <td align="right" class="reportText"><img src="images/icon-new-message.gif" width="17" height="18"></td>
                          <td width="2" class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                          <td height="18" class="reportText"><a href="messagenew.cfm?lid=#getSubListCount.EmailListID#">Create
                              a New Message</a></td>
                        </tr>
                        <cfif #getMessageCount.MessageCnt# gte 1>
						<tr>
                          <td align="right" class="reportText"><img src="../images/icon-message-copy.gif" width="18" height="16"></td>
                          <td class="reportText">&nbsp;</td>
                          <td height="18" class="reportText"><a href="messageLists.cfm?act=copy&lid=#getSubListCount.EmailListID#&mid=#getLastMessage.MessageID#">Duplicate
                              existing Message</a></td>
                        </tr>
                        <tr>
                          <td align="right" class="reportText"><img src="../images/clickThruStats.gif" width="19" height="16"></td>
                          <td class="reportText">&nbsp;</td>
                          <td height="18" class="reportText"><a href="messageStats.cfm?mid=#getLastMessage.MessageID#">View click through
                            stats</a></td>
                        </tr>
						</cfif>
						</cfoutput>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table></td>
		<td width="5" valign="top"><img src="../images/spacer_white.gif" width="5" height="5"></td>
		<td align="center" valign="top"><table width="225" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><img src="../images/ReportHeaderSubscribers.gif" width="225" height="50"></td>
          </tr>
        </table>		  
		<cfoutput query="getSubListCount">
		<table width="225" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="660000">
          <tr>
            <td bgcolor="660000"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="1"></td>
                </tr>
                <tr>
                  <td bgcolor="White">
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <cfset dayOfMonth = DatePart("d", Now())>
					  <cfset monthOfYear = DatePart("m", Now())>
					  <cfset currYear = DatePart("yyyy", Now())>
					  
					  <cfquery name="getSubscribedCount" datasource="#DSN#">
							SELECT COUNT(EmailID) AS subscribersCnt
							FROM email_addresses WHERE ListID 
								  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
					  </cfquery>
					  <cfquery name="getUnSubscribedCount" datasource="#DSN#">
							SELECT COUNT(EmailID) AS subscribersRemovedCnt
							FROM email_addresses_removed WHERE ListID 
								  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
					  </cfquery>
					  <cfif globals.DatabaseType eq 1 OR globals.DatabaseType eq 2>
						  <!--- /////////////// MSSQL, Access ///////////////// --->
						  <cfquery name="getSubscribedCountToday" datasource="#DSN#">
								SELECT COUNT(EmailID) AS subscribersCntToday
								FROM email_addresses WHERE ListID 
									  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
									AND ( DatePart ( <cfif globals.DatabaseType eq 1>'d'<cfelse>"d"</cfif> , email_addresses.DateAdded ) = #dayOfMonth# )
									AND ( DatePart ( <cfif globals.DatabaseType eq 1>'m'<cfelse>"m"</cfif> , email_addresses.DateAdded ) = #monthOfYear# )
									AND ( DatePart ( <cfif globals.DatabaseType eq 1>'yyyy'<cfelse>"yyyy"</cfif> , email_addresses.DateAdded ) = #currYear# )
						  </cfquery>
						  <cfquery name="getUnSubscribedCountToday" datasource="#DSN#">
								SELECT COUNT(EmailID) AS subscribersRemovedCntToday
								FROM email_addresses_removed WHERE ListID 
									  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
									AND ( DatePart ( <cfif globals.DatabaseType eq 1>'d'<cfelse>"d"</cfif> , DateRemoved ) = #dayOfMonth# )
									AND ( DatePart ( <cfif globals.DatabaseType eq 1>'m'<cfelse>"m"</cfif> , DateRemoved ) = #monthOfYear# )
									AND ( DatePart ( <cfif globals.DatabaseType eq 1>'yyyy'<cfelse>"yyyy"</cfif> , DateRemoved ) = #currYear# )
						  </cfquery>
						  <cfquery name="getSubscribedCountYear" datasource="#DSN#">
								SELECT COUNT(EmailID) AS subscribersCntYear
								FROM email_addresses WHERE ListID 
									  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
									AND ( DatePart ( <cfif globals.DatabaseType eq 1>'yyyy'<cfelse>"yyyy"</cfif> , DateAdded ) = #currYear# )
						  </cfquery>
						  <cfquery name="getUnSubscribedCountYear" datasource="#DSN#">
								SELECT COUNT(EmailID) AS subscribersRemovedCntYear
								FROM email_addresses_removed WHERE ListID 
									  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
									AND ( DatePart ( <cfif globals.DatabaseType eq 1>'yyyy'<cfelse>"yyyy"</cfif> , DateRemoved ) = #currYear# )
						  </cfquery>
						  <!--- /////////////// MSSQL, Access /////////////////// --->
					  
					  <cfelseif globals.DatabaseType eq 3>
						  <!--- /////////////// MySQL ////////////////////////// --->
						  <cfquery name="getSubscribedCountToday" datasource="#DSN#">
								SELECT COUNT(EmailID) AS subscribersCntToday
								FROM email_addresses WHERE ListID 
									  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
									AND ( DAYOFMONTH(email_addresses.DateAdded) = #dayOfMonth# )
									AND ( MONTH(email_addresses.DateAdded) = #monthOfYear# )
									AND ( YEAR(email_addresses.DateAdded) = #currYear# )
						  </cfquery>
						  <cfquery name="getUnSubscribedCountToday" datasource="#DSN#">
								SELECT COUNT(EmailID) AS subscribersRemovedCntToday
								FROM email_addresses_removed WHERE ListID 
									  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
									AND ( DAYOFMONTH(email_addresses_removed.DateRemoved) = #dayOfMonth# )
									AND ( MONTH(email_addresses_removed.DateRemoved) = #monthOfYear# )
									AND ( YEAR(email_addresses_removed.DateRemoved) = #currYear# )
						  </cfquery>
						  <cfquery name="getSubscribedCountYear" datasource="#DSN#">
								SELECT COUNT(EmailID) AS subscribersCntYear
								FROM email_addresses WHERE ListID 
									  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
									AND ( YEAR(email_addresses.DateAdded) = #currYear# )
						  </cfquery>
						  <cfquery name="getUnSubscribedCountYear" datasource="#DSN#">
								SELECT COUNT(EmailID) AS subscribersRemovedCntYear
								FROM email_addresses_removed WHERE ListID 
									  = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
									AND ( YEAR(email_addresses_removed.DateRemoved) = #currYear# )
						  </cfquery>
						  <!--- /////////////// MySQL ///////////////// --->
					  <cfelse>
					  	<!--- Undefined database type, should not happen --->
						<cfset getSubscribedCountToday = QueryNew("subscribersCntToday")>
						<cfset getUnSubscribedCountToday = QueryNew("subscribersRemovedCntToday")>
						<cfset getSubscribedCountYear = QueryNew("subscribersCntYear")>
						<cfset getUnSubscribedCountYear = QueryNew("subscribersRemovedCntYear")>
					  </cfif>
					  <cfquery name="getSubscribedBounced" datasource="#DSN#">
							SELECT COUNT(EmailID) AS bouncedCnt FROM email_addresses
							WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSubListCount.EmailListID#">
								AND Bounced = 1
					  </cfquery>
					  <tr align="center">
                        <td height="18" colspan="3" class="reportText" bgcolor="##FF9933">
						  <strong>#getSubListCount.EmailListDesc#
						  </strong></td>
                        </tr>
                      <tr>
                        <td height="20%" align="right" class="reportText"><strong>#getSubscribedCount.subscribersCnt#</strong></td>
                        <td width="2" class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                        <td height="18" class="reportText"><strong><a href="subscribersList.cfm?lid=#getSubListCount.EmailListID#&list=active">Active subscribers</a></strong></td>
                      </tr>
                      <tr>
                        <td align="right" class="reportText">#getSubscribedCountToday.subscribersCntToday#</td>
                        <td width="2" class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                        <td height="18" class="reportText">New subscribers today</td>
                      </tr>
                      <tr>
                        <td align="right" class="reportText">#getSubscribedCountYear.subscribersCntYear#</td>
                        <td class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                        <td height="18" class="reportText">New subscribers for
                          the year</td>
                      </tr>
                      <tr>
                        <td align="right" class="reportText">#getSubscribedBounced.bouncedCnt#</td>
                        <td class="reportText">&nbsp;</td>
                        <td height="18" class="reportText">Bounced subscribers</td>
                      </tr>
					  <tr>
                        <td align="right" class="reportText"><font color="Red">#getUnSubscribedCount.subscribersRemovedCnt#</font></td>
                        <td width="2" class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                        <td height="18" class="reportText"><a href="subscribersList.cfm?lid=#getSubListCount.EmailListID#&list=removed">Members have Un-subscribed</a></td>
                      </tr>
                      <tr>
                        <td align="right" class="reportText"><font color="Red">#getUnSubscribedCountToday.subscribersRemovedCntToday#</font></td>
                        <td class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                        <td height="18" class="reportText">Member<cfif #getUnSubscribedCountToday.subscribersRemovedCntToday# gt 1>s</cfif> <cfif #getUnSubscribedCountToday.subscribersRemovedCntToday# gt 1> have<cfelse> has</cfif> Un-subscribed today</td>
                      </tr>
					  <tr>
                        <td align="right" class="reportText"><font color="Red">#getUnSubscribedCountYear.subscribersRemovedCntYear#</font></td>
                        <td class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                        <td height="18" class="reportText">Members have Un-subscribed this year</td>
                      </tr>
                      <tr align="center">
                        <td height="3" colspan="3" class="reportText"><img src="../images/spacer_white.gif" width="3" height="3"></td>
                      </tr>
					  <tr align="center">
                        <td height="1" colspan="3" bgcolor="##333333" class="reportText"><img src="../images/SPACERDOT_333333.JPG" width="1" height="1"></td>
                      </tr>
                      <tr>
                        <td align="right" class="reportText"><img src="../images/EDIT.GIF" width="8" height="12"></td>
                        <td width="2" class="reportText"><img src="../images/spacer_Transparent_1pixel.gif" width="2" height="2"></td>
                        <td height="18" class="reportText"><a href="subscribersList.cfm?lid=#getSubListCount.EmailListID#&list=active">Add/Edit
                            New/Current Subscriber</a>s</td>
                      </tr>
                      <tr>
                        <td align="right" class="reportText"><img src="../images/importIconGrn.gif" width="12" height="15"></td>
                        <td class="reportText">&nbsp;</td>
                        <td height="18" class="reportText"><a href="subscribersImport.cfm?lid=#getSubListCount.EmailListID#">Import subscriber
                          list</a></td>
                      </tr>
					  
                    </table>
                  </td>
                </tr>
              </table>
			  
            </td>
          </tr>
        </table>
		<br>
		</cfoutput>
		</td>
	  </tr>
	</table>
	<!--- Report Body End --->
	</td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
