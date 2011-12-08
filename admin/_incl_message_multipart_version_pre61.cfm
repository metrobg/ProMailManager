<!--- Multi-Part Email Message --->
<cfquery name="qRetrieveMsg" datasource="#DSN#">
	SELECT MessageWithRedirects FROM email_list_messages
	WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
</cfquery>
<cfset vHTMLMessage = qRetrieveMsg.MessageWithRedirects>

<cfif session.BatchEnd gt subscriberList.RecordCount>
	<cfset session.BatchEnd = subscriberList.RecordCount>
</cfif>
<cfloop query="subscriberList" startrow="#session.BatchStart#" endrow="#session.BatchEnd#">
	<cfset session.messageSentCount = session.messageSentCount + 1>
	
	<cfif mailServerInfo.EmailPersonalization eq 1 AND mailServerInfo.EmailIDLinkAdded eq 1>
		<cfinclude template="_actUpdateMessageLinksPersonals.cfm">
		<cfinclude template="_actUpdateMessageClickExtras.cfm">
	<cfelseif mailServerInfo.EmailPersonalization eq 1 AND mailServerInfo.EmailIDLinkAdded eq 0>
		<cfinclude template="_actUpdateMessageLinksPersonals.cfm">
	<cfelseif mailServerInfo.EmailPersonalization eq 0 AND mailServerInfo.EmailIDLinkAdded eq 1>
		<cfinclude template="_actUpdateMessageClickExtras.cfm">
	<cfelse>
		<cfset vHTMLMessageExtraFinal = vHTMLMessage>
	</cfif>

	<cfset lf=Chr(10)>
	<cfset crlf=Chr(13)&Chr(10)>
	<cfset MessageTxtLF = #message.MessageTXT#>
	
<cfif attachmentList.Recordcount gte 1>
<!--- ************* Message with attachment/s can only be sent as HTML not multi-part **************** --->
<cfmail 
	server="#mailServerInfo.EmailListSMTPServer#" 
	to="#EmailAddress#" 
	from="#mailServerInfo.EmailListFromEmail#"
	subject="#message.MessageSubject#" type="html"
	mailerid="#globals.ELMVersion#">	
<cfif Len(mailServerInfo.EmailListReplyToEmail) neq 0><cfmailparam name="reply-to" value="#mailServerInfo.EmailListReplyToEmail#"></cfif>
<cfif mailServerInfo.EmailPersonalization eq 1><cfinclude template="_actUpdateMessageLinksPersonals.cfm"></cfif><cfif mailServerInfo.EmailIDLinkAdded eq 1><cfinclude template="_actUpdateMessageClickExtras.cfm"></cfif>

<cfloop query="attachmentList">
<cfset fileToAttach = #currDir# & #AttachmentFileName#>
<cfif FileExists(fileToAttach)>
<cfmailparam file="#fileToAttach#">
</cfif>
</cfloop>

<html>
<body>
<cfif IsDefined("mailServerInfo.EmailListGlobalHeaderHTML") AND Len(mailServerInfo.EmailListGlobalHeaderHTML) neq 0>#mailServerInfo.EmailListGlobalHeaderHTML#<br></cfif>#vHTMLMessage#<br>
<cfif IsDefined("mailServerInfo.EmailListGlobalFooterHTML") AND Len(mailServerInfo.EmailListGlobalFooterHTML) neq 0>#mailServerInfo.EmailListGlobalFooterHTML#</cfif>
<br><font face="#mailServerInfo.EmailMessageGlobalFontFace#" size="#mailServerInfo.EmailMessageGlobalFontSize#"><br>
To be removed from further mailings from our list please click the <a href="#globals.siteServerAddress#unsubscribe.cfm?vEmailAddress=#EmailAddress#&vEmailList=#lid#&act=subr">unsubscribe</a> link
</font>
</body>
</html>

</cfmail>

<cfelse> 
<!--- Close Attachments check, no attachments send multi-part email --->

	<cfif mailServerInfo.EmailPersonalization eq 1><cfinclude template="_actUpdateMessageLinksPersonals.cfm"></cfif><cfif mailServerInfo.EmailIDLinkAdded eq 1><cfinclude template="_actUpdateMessageClickExtras.cfm"></cfif>

<!--- ************* Multi-Part Email Loop **************** --->
	<cfset lf=Chr(10)>
	<cfset crlf=Chr(13)&Chr(10)>
	<!--- <cfset vHTMLMessage = REReplaceNoCase(vHTMLMessage, '([[:print:]])(#Chr(10)#)([[:print:]])','\1'&Chr(13)&Chr(10)&'\3', 'ALL')> --->
	<!--- <cfset MessageTxtLF ="#Replace(message.MessageTXT, lf, crlf, "All")#"> --->
	<cfset MessageTxtLF = #message.MessageTXT# >
	
<cfmail
	server="#mailServerInfo.EmailListSMTPServer#" 
	to="#EmailAddress#" 
	from="#mailServerInfo.EmailListFromEmail#"
	subject="#message.MessageSubject#"
	mailerid="#globals.ELMVersion#"
	>
<cfif Len(mailServerInfo.EmailListReplyToEmail) neq 0><cfmailparam name="reply-to" value="#mailServerInfo.EmailListReplyToEmail#"></cfif>
<cfmailparam name="MIME-Version" value="1.0">
<cfmailparam name="Content-Type" value="multipart/alternative; boundary=""AlternativeMessage""">
<cfmailparam name="Content-Transfer-Encoding" value="7bit">
--AlternativeMessage
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

<cfif IsDefined("mailServerInfo.EmailListGlobalHeader") AND Len(mailServerInfo.EmailListGlobalHeader) neq 0>#mailServerInfo.EmailListGlobalHeader# #crlf##MessageTxtLF#<cfelse>#MessageTxtLF#</cfif><cfif IsDefined("mailServerInfo.EmailListGlobalFooter") AND Len(mailServerInfo.EmailListGlobalFooter) neq 0>#crlf##mailServerInfo.EmailListGlobalFooter#</cfif>

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

<cfif IsDefined("mailServerInfo.EmailListGlobalHeaderHTML") AND Len(mailServerInfo.EmailListGlobalHeaderHTML) neq 0>#mailServerInfo.EmailListGlobalHeaderHTML#<br></cfif>#vHTMLMessageExtraFinal#<br>
<cfif IsDefined("mailServerInfo.EmailListGlobalFooterHTML") AND Len(mailServerInfo.EmailListGlobalFooterHTML) neq 0>#mailServerInfo.EmailListGlobalFooterHTML#</cfif>
<br><font face="#mailServerInfo.EmailMessageGlobalFontFace#" size="#mailServerInfo.EmailMessageGlobalFontSize#"><br>
To be removed from further mailings from our list please click the <a href="#globals.siteServerAddress#unsubscribe.cfm?vEmailAddress=#EmailAddress#&vEmailList=#lid#&act=subr">unsubscribe</a> link
</font>
</body>
</html>

--AlternativeMessage--

</cfmail>

</cfif>

	<cfif IsDefined("globals.logSuccessfulBroadcasts") AND globals.logSuccessfulBroadcasts eq 1>
		<!--- Log successful send to Broadcast_Success_Log database --->
		<cfinclude template="_act_broadcast_success_log.cfm">		
	</cfif>
	
</cfloop>
