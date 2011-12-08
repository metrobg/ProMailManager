<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 11, 2003
Date Last Modified:        January 9, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Extras</title>
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
<!--- get validation info if available --->
<cfscript>
	strSvrName = cgi.server_name;
	strScriptPath = cgi.script_name;
	if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { 
		strMaillistPath = ListFindNoCase(strScriptPath, "admin", "/");
	}
	else { 
		strMaillistPath = ListFindNoCase(strScriptPath, "admin", "\");
		strMaillistPath = ListChangeDelims(strMaillistPath, "/", "\");
	}
	if ( strMaillistPath gt 0 ) {
		strAdminPath = ListDeleteAt(strScriptPath, strMaillistPath + 1, "/");
		strPathCropped1 = ListDeleteAt(strScriptPath, strMaillistPath, "/");
		strPathActual = ListDeleteAt(strPathCropped1, strMaillistPath, "/");
	}
	else {
		strPathActual = 'unknown';
	}
	if ( strPathActual eq "unknown" ) {
		strFullFilePath = "unknown";
	}
	else {
		strFullFilePath = strSvrName & strPathActual;
	}
	if ( Left(strFullFilePath, 7) neq "http://" ) {
		strFullFilePath = "http://" & strFullFilePath;
	}
	if ( IsDefined("PageTimeout") AND Len(PageTimeout) eq 0) {
		PageTimeout = 300;
	}
</cfscript>
<cfif IsDefined("bUpdate")>
	<cfif IsDefined("cfmxInstalled")>
		<cfset cfmxInstalled = 1>
	<cfelse>
		<cfset cfmxInstalled = 0>		
	</cfif>
	<cfquery name="qUpdateGlobals" datasource="#DSN#">
	UPDATE globals
	SET siteServerAddress = '#siteServerAddress#',
		localServerAddress = '#localServerAddress#',
		siteStyle = '#siteStyle#',
		subscriptionLists_MaxRows = #subscriptionLists_MaxRows#,
		subscriptionLists_MaxPages = #subscriptionLists_MaxPages#,
		subscribersList_MaxRows = #subscribersList_MaxRows#,
		subscribersList_MaxPages = #subscribersList_MaxPages#,
		messageLists_MaxRows = #messageLists_MaxRows#,
		messageLists_MaxPages = #messageLists_MaxPages#,
		cfmxInstalled = #cfmxInstalled#,
		exportFilePath = '#exportFilePath#',
		importFilePath = '#importFilePath#',
		cffileEnabled = #cffileEnabled#,
		editorPath = '#editorPath#',
		attachmentsPath = '#attachmentsPath#',
		enableAutoResponders = #enableAutoResponders#,
		DefaultEditorWidth = #DefaultEditorWidth#,
		DefaultEditorHeight = #DefaultEditorHeight#,
		logSuccessfulBroadcasts = #logSuccessfulBroadcasts#,
		ChartStyle = #ChartStyle#,
		PopServerTimeout = #PopServerTimeout#,
		PageTimeout = #PageTimeout#,
		DateDisplay = '#DateDisplay#',
		TimeDisplay = '#TimeDisplay#',
		DatabaseType = #DatabaseType#,
		Custom1Name = '#Custom1Name#',
		Custom2Name = '#Custom2Name#',
		Custom3Name = '#Custom3Name#',
		Custom4Name = '#Custom4Name#',
		Custom5Name = '#Custom5Name#'
  </cfquery>
</cfif>
<cfquery name="globalsLocal" datasource="#DSN#">
SELECT * FROM globals
</cfquery>
<cfquery name="qChartTypes" datasource="#DSN#">
SELECT * FROM chart_types
</cfquery>
<cfquery name="qDBTypes" datasource="#DSN#">
SELECT * FROM database_types
</cfquery>			
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm"> </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td width="100%" valign="top"><cfinclude template="globals/_navHeader.cfm">
		<!--- body --->
		<table width="100%" border="0">
		  <tr>
			<td height="20" colspan="3" class="tdBackGrnd"><strong>Global Settings</strong></td>
		  </tr>
		  <cfform action="adminExtras.cfm" method="post">
			<cfoutput query="globalsLocal" maxrows="1">
			  <tr align="center">
				<td colspan="3" class="bodyText"><table width="375" border="0" cellpadding="1" cellspacing="0" bgcolor="##006699">
					<tr>
					  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td width="12" align="center" bgcolor="White" class="bodyText"><font color="##003366"><img src="../images/help_Animated.gif" width="10" height="10"></font></td>
							<td height="18" align="center" bgcolor="White" class="bodyText"><font color="##003366">
							  <cfif Left(siteServerAddress, 16) eq "http://localhost">
							  Try running this page from a remote workstation not locally
							  on the server to determine correct server url
							  <cfelse>
							  We have determined your Server address should be:<br>
							  <strong>#strFullFilePath#</strong></font><br>
							  try entering this into the box below and press the update
							  button
							  </cfif>
							</td>
						  </tr>
						</table>
					  </td>
					</tr>
				  </table>
				</td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Server Address (URL to
				  this server)</td>
				<td class="bodyText"><input name="siteServerAddress" value="#siteServerAddress#" type="text" size="45" maxlength="150" class="bodyText">
				  (must end with a trailing &quot;/&quot;)</td>
				<td class="bodyText"><cfif Left(siteServerAddress, 16) eq "http://localhost">
					<img src="../images/icon-cross-box-red.gif" alt="Not a valid value" width="19" height="19" title="You must set your domain url not localhost">
				  </cfif>
				</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Local Server Address (URL to this
				  server when browsed from the local server)</td>
				<td class="bodyText"><input name="localServerAddress" value="#localServerAddress#" type="text" size="45" maxlength="150" class="bodyText">
				  (must end with a trailing &quot;/&quot;)</td>
				<td class="bodyText"></td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <cfif IsDefined("Server.ColdFusion.ProductVersion") AND ListLen(Server.ColdFusion.ProductVersion) gte 2>
				<cfset nSvrMajorNum = ListGetAt(Server.ColdFusion.ProductVersion, 1)>
				<cfset nSvrMinorNum = ListGetAt(Server.ColdFusion.ProductVersion, 2)>
				<cfset strSvrVersion = nSvrMajorNum & "." & nSvrMinorNum>
			  </cfif>
			  <cfif nSvrMajorNum gt 0 AND nSvrMinorNum gte 0>
				<tr align="center">
				  <td height="22" colspan="3" nowrap class="bodyText">
					<table width="375" border="0" cellpadding="1" cellspacing="0" bgcolor="##006699">
					  <tr>
						<td><table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
							  <td width="12" align="center" bgcolor="White" class="bodyText"><font color="##003366"><img src="../images/help_Animated.gif" width="10" height="10"></font></td>
							  <td height="18" align="center" bgcolor="White" class="bodyText"><font color="##003366"> It
								  appears your CF Server version is: <strong>#strSvrVersion#</font></strong> <br>
								the box below should be
								<cfif Val(strSvrVersion) gte "6.1">
								  checked
								  <cfelse>
								  un-checked
								</cfif>
								(we have done this for you)
								<cfif cfmxInstalled eq 0 AND Val(strSvrVersion) gte "6.1">
								  <br>
								  <font color="Red">** PLEASE CLICK UPDATE BELOW TO UPDATE
								  YOUR SETTINGS FOR THIS FIELD TO CORRECT VALUE **</font>
								</cfif>
							  </td>
							</tr>
						  </table>
						</td>
					  </tr>
					</table>
				  </td>
				</tr>
			  </cfif>
			  <cfif Val(strSvrVersion) gte "6.1">
				<cfset bCFMX = 1>
				<cfelse>
				<cfset bCFMX = 0>
			  </cfif>
			  <tr>
				<td align="right" class="bodyText">Are you using Coldfusion MX <strong>6.1</strong>?</td>
				<td class="bodyText"><input type="checkbox" name="cfmxInstalled" value="1" <cfif cfmxInstalled eq 1>checked<cfelseif bCFMX eq 1>checked<cfelse></cfif>>
				  (<strong><font color="Red">uncheck if you are using MX 6.0 or below</font></strong> -
				  including 4.5 / 5)</td>
				<td class="bodyText"><cfif Val(strSvrVersion) gte "6.1" AND cfmxInstalled eq 1>
					<img src="../images/icon-check-box.gif" alt="Validated" width="19" height="19">
					<cfelseif Val(strSvrVersion) lt "6.1" AND cfmxInstalled eq 0>
					<img src="../images/icon-check-box.gif" alt="Validated" width="19" height="19">
					<cfelse>
					<img src="../images/icon-cross-box-red.gif" title="Click Update button to store correct setting" alt="Not Validated" width="19" height="19">
				  </cfif>
				</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Site Style</td>
				<td class="bodyText"><input name="siteStyle" value="#siteStyle#" type="text" size="30" maxlength="50" class="bodyText">
				</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr align="left" bgcolor="##CCCCCC">
			    <td height="20" colspan="3" class="bodyText"><strong>Subscription Lists Global Settings</strong></td>
		      </tr>
			  <tr>
				<td align="right" class="bodyText">Subscription Lists - Maximum Records
				  Per Page</td>
				<td class="bodyText"><cfinput name="subscriptionLists_MaxRows" value="#subscriptionLists_MaxRows#" type="text" size="3" maxlength="3" class="bodyText">
				</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Subscription Lists - Maximum Pages
				  per group</td>
				<td class="bodyText"><cfinput name="subscriptionLists_MaxPages" value="#subscriptionLists_MaxPages#" type="text" size="3" maxlength="3" class="bodyText">
				</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr align="left" bgcolor="##CCCCCC">
                <td height="20" colspan="3" class="bodyText"><strong>Subscriber
                    Global Settings</strong></td>
		      </tr>
			  <tr>
				<td align="right" class="bodyText">Subscribers List Page - Maximum Records
				  Per Page</td>
				<td class="bodyText"><cfinput name="subscribersList_MaxRows" value="#subscribersList_MaxRows#" type="text" size="3" maxlength="3" class="bodyText">
				</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Subscribers List Page - Maximum Pages
				  per group</td>
				<td class="bodyText"><cfinput name="subscribersList_MaxPages" value="#subscribersList_MaxPages#" type="text" size="3" maxlength="3" class="bodyText">
				</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
			    <td align="right" class="bodyText">Custom Field 1 Label:</td>
			    <td class="bodyText"><input name="Custom1Name" value="#Custom1Name#" type="text" size="30" maxlength="50" class="bodyText"></td>
			    <td class="bodyText">&nbsp;</td>
		      </tr>
			  <tr>
			    <td align="right" class="bodyText">Custom Field 2 Label:</td>
			    <td class="bodyText"><input name="Custom2Name" value="#Custom2Name#" type="text" size="30" maxlength="50" class="bodyText">
		        </td>
			    <td class="bodyText">&nbsp;</td>
		      </tr>
			  <tr>
			    <td align="right" class="bodyText">Custom Field 3 Label:</td>
			    <td class="bodyText"><input name="Custom3Name" value="#Custom3Name#" type="text" size="30" maxlength="50" class="bodyText">
		        </td>
			    <td class="bodyText">&nbsp;</td>
		      </tr>
			  <tr>
			    <td align="right" class="bodyText">Custom Field 4 Label:</td>
			    <td class="bodyText"><input name="Custom4Name" value="#Custom4Name#" type="text" size="30" maxlength="50" class="bodyText">
		        </td>
			    <td class="bodyText">&nbsp;</td>
		      </tr>
			  <tr>
			    <td align="right" class="bodyText">Custom Field 5 Label:</td>
			    <td class="bodyText"><input name="Custom5Name" value="#Custom5Name#" type="text" size="30" maxlength="50" class="bodyText">
		        </td>
			    <td class="bodyText">&nbsp;</td>
		      </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr align="left" bgcolor="##CCCCCC">
                <td height="20" colspan="3" class="bodyText"><strong>Messages/Campaigns Global
                    Settings</strong></td>
		      </tr>
			  <tr>
				<td align="right" class="bodyText">Message List Page - Maximum Records
				  Per Page</td>
				<td class="bodyText"><cfinput name="messageLists_MaxRows" value="#messageLists_MaxRows#" type="text" size="3" maxlength="3" class="bodyText">
				</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Message List Page - Maximum Pages
				  per group</td>
				<td class="bodyText"><cfinput name="messageLists_MaxPages" value="#messageLists_MaxPages#" type="text" size="3" maxlength="3" class="bodyText">
				</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr align="left" bgcolor="##CCCCCC">
                <td height="20" colspan="3" class="bodyText"><strong>WYSIWYG
                    Editor Settings (viewable on IE 5.5+ on Windows only)</strong></td>
		      </tr>
			  <tr>
				<td align="right" class="bodyText">Path to editor directory</td>
				<td class="bodyText"><input name="editorPath" value="#editorPath#" type="text" size="55" maxlength="254" class="bodyText">
				  (admin/editor)</td>
				<td></td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Default Editor Width</td>
				<td class="bodyText"><input name="DefaultEditorWidth" value="#DefaultEditorWidth#" type="text" size="5" maxlength="4" class="bodyText">
				  (install default: admin/attachments)</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Default Editor Height</td>
				<td class="bodyText"><input name="DefaultEditorHeight" value="#DefaultEditorHeight#" type="text" size="5" maxlength="4" class="bodyText">
				  (install default: admin/attachments)</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr align="left" bgcolor="##CCCCCC">
                <td height="20" colspan="3" class="bodyText"><strong>Attachments/Import/Export
                    File Paths</strong></td>
		      </tr>
			  <tr>
				<td align="right" class="bodyText">Path to Attachments directory</td>
				<td class="bodyText"><input name="attachmentsPath" value="#attachmentsPath#" type="text" size="55" maxlength="254" class="bodyText">
				  (install default: admin/attachments)</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Path to folder to store csv import
				  file</td>
				<td class="bodyText"><input name="importFilePath" value="#importFilePath#" type="text" size="55" maxlength="254" class="bodyText">
				</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Path to directory to store csv export
				  file</td>
				<td class="bodyText"><input name="exportFilePath" value="#exportFilePath#" type="text" size="55" maxlength="254" class="bodyText">
				</td>
				<td class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr align="left" bgcolor="##CCCCCC">
                <td height="20" colspan="3" class="bodyText"><strong>Database
                    and other application Global
                    Settings</strong></td>
		      </tr>
			  <tr>
				<td align="right" class="bodyText">Database Type system is using?<br>
				</td>
				<td valign="middle" class="bodyText">
				  <select name="DatabaseType" id="DatabaseType" class="bodyText">
					<cfloop query="qDBTypes">
						<option value="#dbID#" <cfif globalsLocal.DatabaseType eq dbID>selected</cfif>>#DatabaseDesc#</option>
					</cfloop>
				  </select>
				  an error will be generated within the application 
				  if set incorrectly)</td>
				<td valign="middle" class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" class="bodyText">Do you have the <strong>cffile</strong> tag
				  enabled?<br>
				</td>
				<td valign="middle" class="bodyText"><br>
				  <select name="cffileEnabled" id="cffileEnabled" class="bodyText">
					<option value="<cfif cffileEnabled eq 1>1<cfelse>0</cfif>" selected>
					<cfif cffileEnabled eq 1>
					  Yes
					  <cfelse>
					  No
					</cfif>
					</option>
					<cfif cffileEnabled eq 1>
					  <option value="0">No</option>
					  <cfelse>
					  <option value="1">Yes</option>
					</cfif>
				  </select>
				  (choose no if your ISP does not allow use of cffile tag or you have
				  it disabled)<br>
				  * used in import / export and attachments upload/delete functions</td>
				<td valign="middle" class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" valign="middle" class="bodyText">Enable Auto Responses? </td>
				<td valign="middle" class="bodyText">
				  <select name="enableAutoResponders" id="enableAutoResponders" class="bodyText">
					<option value="<cfif enableAutoResponders eq 1>1<cfelse>0</cfif>" selected>
					<cfif enableAutoResponders eq 1>
					  Yes
					  <cfelse>
					  No
					</cfif>
					</option>
					<cfif enableAutoResponders eq 1>
					  <option value="0">No</option>
					  <cfelse>
					  <option value="1">Yes</option>
					</cfif>
				  </select>
				  **</td>
				<td valign="middle" class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" valign="middle" class="bodyText">Do you wish to log
				  successful broadcasts? </td>
				<td valign="middle" class="bodyText">
				  <select name="logSuccessfulBroadcasts" id="logSuccessfulBroadcasts" class="bodyText">
					<option value="<cfif logSuccessfulBroadcasts eq 1>1<cfelse>0</cfif>" selected>
					<cfif logSuccessfulBroadcasts eq 1>
					  Yes
					  <cfelse>
					  No
					</cfif>
					</option>
					<cfif logSuccessfulBroadcasts eq 1>
					  <option value="0">No</option>
					  <cfelse>
					  <option value="1">Yes</option>
					</cfif>
				  </select>
				</td>
				<td valign="middle" class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
				<td align="right" valign="middle" class="bodyText">Chart Type Preference? </td>
				<td valign="middle" class="bodyText">
				  <select name="ChartStyle" id="ChartStyle" class="bodyText">
					<cfloop query="qChartTypes">
					  <option value="#chartID#" <cfif globalsLocal.ChartStyle eq chartID>selected</cfif>>#chartType#</option>
					</cfloop>
				  </select>
				</td>
				<td valign="middle" class="bodyText">&nbsp;</td>
			  </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
			    <td align="right" valign="middle" class="bodyText">Pop Server Timeout
			      (secs)</td>
			    <td valign="middle" class="bodyText"><input name="PopServerTimeout" value="#PopServerTimeout#" type="text" size="10" maxlength="5" class="bodyText"></td>
			    <td valign="middle" class="bodyText">&nbsp;</td>
		      </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
			    <td align="right" valign="middle" class="bodyText">Page  Timeout
			      (secs)</td>
			    <td valign="middle" class="bodyText"><input name="PageTimeout" value="#PageTimeout#" type="text" size="10" maxlength="5" class="bodyText"></td>
			    <td valign="middle" class="bodyText">&nbsp;</td>
		      </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
			    <td align="right" valign="middle" class="bodyText">Date Display Format</td>
			    <td colspan="2" valign="middle" class="bodyText"><input name="DateDisplay" value="#DateDisplay#" type="text" size="15" maxlength="20" class="bodyText"> 
			      [preview: <font color="##000099">#DateFormat(Now(), DateDisplay)#</font>] (must be a valid <a href="javascript:popUpWindow('http://livedocs.macromedia.com/coldfusion/6.1/htmldocs/functi59.htm', 'yes', 'yes', '50', '50', '600', '500')">coldfusion
			      date &quot;mask&quot;</a>)</td>
		      </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr>
			    <td align="right" valign="middle" class="bodyText">Time Display Format</td>
			    <td colspan="2" valign="middle" class="bodyText"><input name="TimeDisplay" value="#TimeDisplay#" type="text" size="15" maxlength="20" class="bodyText">
		        [preview: <font color="##000099">#TimeFormat(Now(), TimeDisplay)#</font>] (must be a valid <a href="javascript:popUpWindow('http://livedocs.macromedia.com/coldfusion/6.1/htmldocs/funca107.htm', 'yes', 'yes', '50', '50', '600', '500')">coldfusion
		        time &quot;mask&quot;</a>)</td>
		      </tr>
			  <tr>
				<td height="1" colspan="3" align="right" nowrap bgcolor="##666666"></td>
			  </tr>
			  <tr align="center">
				<td colspan="3" class="bodyText"><input name="bUpdate" type="submit" class="tdHeader" id="bUpdate" value="Update">
				</td>
			  </tr>
			  <tr align="left">
				<td colspan="3" class="bodyText"> ** if you have created an auto response
				  message for your list it will be sent to all successful subscription
				  requests to your site when subscribed via a form. This is triggered
				  from the SubscribeEngine.cfm custom tag so wherever you use this tag
				  then auto responses will be activated.</td>
			  </tr>
			</cfoutput>
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
