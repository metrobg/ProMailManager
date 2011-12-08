<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.andrewkelly.com
Contact Information:       http://www.andrewkelly.com/contact
Date Created:              January 2, 2003
Date Last Modified:        January 3, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href=" rel="stylesheet" type="text/css">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<cfif NOT IsDefined("mid")>
	<cflocation url="subscriptionLists.cfm" addtoken="no">
</cfif>
<cfquery name="getMessage" datasource="#DSN#">
	SELECT *
	FROM email_list_messages
	WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
</cfquery>
<cfquery name="mailServerInfo" datasource="#DSN#">
SELECT *
FROM email_lists
WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
</cfquery>
<cfif getMessage.RecordCount eq 0>
	<cflocation url="subscriptionLists.cfm" addtoken="no">
</cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm"> </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td valign="top"><cfinclude template="globals/_navHeader.cfm"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">       
		<form action="sendMessage.cfm" method="post">
		<cfoutput>
		<input type="hidden" name="mid" value="#mid#">
		<input type="hidden" name="lid" value="#lid#">
		</cfoutput>		</form>
		<tr align="center"> 
          <td height="22" class="tdBackGrnd"><strong>Preview of your
              HTML Message is below</strong><strong></strong></td>
        </tr>
        <tr> 
          <td height="1" class="tdHorizDivider"></td>
        </tr>
		  <cfoutput query="getMessage" maxrows="1">
		  <tr> 
            <td height="1" align="right" class="tdHorizDivider"></td>
          </tr>
          <tr> 
            <td height="22" align="left" class="bodyText">Subject: #MessageSubject#
			<br><br>
			#mailServerInfo.EmailListGlobalHeader#
			<br><br>
			#MessageHTML#
			<br><br>
			#mailServerInfo.EmailListGlobalFooter#
			<br>
			<font face="#mailServerInfo.EmailMessageGlobalFontFace#" size="#mailServerInfo.EmailMessageGlobalFontSize#">
			<br><br>
			You received this message because you subscribed to #mailServerInfo.EmailListDesc# mailing list.<br>
			To unsubscribe click the link below<br>
			<a href="#mailServerInfo.EmailListWebRoot#/Unsubscribe.cfm?Email=EmailAddress&lid=#lid#">Unsunscribe</a><br>
			or reply to this message with the word UNSUBSCRIBE in the subject field.<br>
			This message was sent to EmailAddress<br>
			</font>
			</td>
          </tr>
          <tr> 
            <td height="1" align="right" class="tdHorizDivider"></td>
          </tr>
          
		  <form action="messageUpdate.cfm?mid=#MessageID#&lid=#lid#" method="post">
		  <tr align="center">
		    <td height="25" nowrap class="bodyText">
			  <input name="bEdit" type="submit" class="tdHeader" id="bSave" value="Edit Message">
		      </td>
		    </tr>
			</form>
          <tr> 
            <td height="1" align="right" class="tdHorizDivider"></td>
          </tr>
		  </cfoutput>
      </table>
	</td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
