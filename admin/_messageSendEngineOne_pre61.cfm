<!-- 
=====================================================================
Mail List Version 2.1

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 5, 2003
Date Last Modified:        August 9, 2003
=====================================================================
 -->
<cfscript>
	currPath = ExpandPath("*.*");
	tempCurrDir = GetDirectoryFromPath(currPath) & "attachments";
	if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { trailingSlash = '\'; }
	else { trailingSlash = '/'; }
	currDir = tempCurrDir & trailingSlash;
</cfscript>
<cfset lf=Chr(10)>
<cfset crlf=Chr(13)&Chr(10)>

<cfinclude template="_qryMessageSendEngineOne.cfm">
<!--- Comment out below line to not create click thru stats links --->
	<cfinclude template="_actUpdateMessageLinks.cfm">
<!--- End Comment out to not create click thru stats links --->

<!--- UN-Comment out below to not create click thru stats links --->
	<!--- <cfset vHTMLMessage = #message.MessageHTML#> --->
<!--- End UN-Comment out below to not create click thru stats links --->
<cfset MessageTxtLF = #message.MessageTXT#>

<cfif attachmentList.Recordcount gte 1>
<!--- Attachments --->
<cfmail 
	server="#mailServerInfo.EmailListSMTPServer#" 
	to="#singleEmail#" 
	from="#mailServerInfo.EmailListFromEmail#"
	subject="#message.MessageSubject#" 
	type="html" mailerid="#globals.ELMVersion#">
<cfsilent>
<cfloop query="attachmentList">
<cfset fileToAttach = #currDir# & #AttachmentFileName#>
<cfif FileExists(fileToAttach)>
<cfmailparam file="#fileToAttach#">
</cfif>
</cfloop>
</cfsilent>

<html>
<body>
<cfif IsDefined("mailServerInfo.EmailListGlobalHeaderHTML") AND Len(mailServerInfo.EmailListGlobalHeaderHTML) neq 0>#mailServerInfo.EmailListGlobalHeaderHTML#<br></cfif>
#vHTMLMessage#
<br>
<cfif IsDefined("mailServerInfo.EmailListGlobalFooterHTML") AND Len(mailServerInfo.EmailListGlobalFooterHTML) neq 0>
#mailServerInfo.EmailListGlobalFooterHTML#
</cfif>
<br>
<font face="#mailServerInfo.EmailMessageGlobalFontFace#" size="#mailServerInfo.EmailMessageGlobalFontSize#">
<br>
To be removed from further mailings from our list please click the <a href="#globals.siteServerAddress#unsubscribe.cfm?vEmailAddress=#singleEmail#&vEmailList=#lid#&act=subr">unsubscribe</a> link
</font>
</body>
</html>

</cfmail>

<cfelse>
<!--- No attachments --->
<cfmail 
	server="#mailServerInfo.EmailListSMTPServer#" 
	to="#singleEmail#" 
	from="#mailServerInfo.EmailListFromEmail#"
	subject="#message.MessageSubject#">	
<cfmailparam name="Content-Type" value="multipart/alternative; boundary=""AlternativeMessage""">
<cfmailparam name="Content-Transfer-Encoding" value="7bit">
--AlternativeMessage
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

<cfif IsDefined("mailServerInfo.EmailListGlobalHeader") AND Len(mailServerInfo.EmailListGlobalHeader) neq 0>#mailServerInfo.EmailListGlobalHeader#
#MessageTxtLF#<cfelse>#MessageTxtLF#</cfif>
<cfif IsDefined("mailServerInfo.EmailListGlobalFooter") AND Len(mailServerInfo.EmailListGlobalFooter) neq 0>#mailServerInfo.EmailListGlobalFooter#</cfif>

--AlternativeMessage
Content-Type: text/html
Content-Transfer-Encoding: 7bit

<html>
<body>
<!--
**********************************************************
The following is an HTML formatted email, in the event
you are reading this and see a bunch of garbled text or
code below this line your email application is not capable
of displaying HTML based email. We apologize for this
inconvenience
**********************************************************
-->
<cfif IsDefined("mailServerInfo.EmailListGlobalHeaderHTML") AND Len(mailServerInfo.EmailListGlobalHeaderHTML) neq 0>#mailServerInfo.EmailListGlobalHeaderHTML#<br></cfif>
#vHTMLMessage#
<br>
<cfif IsDefined("mailServerInfo.EmailListGlobalFooterHTML") AND Len(mailServerInfo.EmailListGlobalFooterHTML) neq 0>
#mailServerInfo.EmailListGlobalFooterHTML#
</cfif>
<br>
<font face="#mailServerInfo.EmailMessageGlobalFontFace#" size="#mailServerInfo.EmailMessageGlobalFontSize#">
<br>
To be removed from further mailings from our list please click the <a href="#globals.siteServerAddress#unsubscribe.cfm?vEmailAddress=#singleEmail#&vEmailList=#lid#&act=subr">unsubscribe</a> link
</font>

</body>
</html>

--AlternativeMessage--

</cfmail>
</cfif>