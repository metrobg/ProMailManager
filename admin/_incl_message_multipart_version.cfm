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

<cftry>	
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
	
	<cfif Len(mailServerInfo.EmailListReplyToEmail) neq 0>
		<cfset strReplyTo = mailServerInfo.EmailListReplyToEmail>
	<cfelse>
		<cfset strReplyTo = mailServerInfo.EmailListFromEmail>
	</cfif>

<cfif IsDefined("EmailListSMTPLogin") AND Len(Trim(EmailListSMTPLogin)) gt 1 AND IsDefined("EmailListSMTPPassword") AND Len(Trim(EmailListSMTPPassword)) gt 1> <!--- SMTP Auth Check Open --->
<!--- Send SMTP authentication also   #mailServerInfo.EmailListFromEmail#--->
<cfmail
	server="#mailServerInfo.EmailListSMTPServer#" 
	to="#EmailAddress#" 
	from="#mailServerInfo.from_name# <#mailServerInfo.EmailListFromEmail#>"
	username = "#mailServerInfo.EmailListSMTPLogin#"
	password = "#mailServerInfo.EmailListSMTPPassword#"
	subject="#message.MessageSubject#"
	failto="#mailServerInfo.EmailListFromEmail#"
	replyto="#strReplyTo#"
	mailerid="#globals.ELMVersion#"
	>
<cfmailpart type="text" wraptext="74">

<cfif IsDefined("mailServerInfo.EmailListGlobalHeader") AND Len(mailServerInfo.EmailListGlobalHeader) neq 0>#mailServerInfo.EmailListGlobalHeader# #crlf##MessageTxtLF#<cfelse>#MessageTxtLF#</cfif><cfif IsDefined("mailServerInfo.EmailListGlobalFooter") AND Len(mailServerInfo.EmailListGlobalFooter) neq 0>#crlf##mailServerInfo.EmailListGlobalFooter#</cfif>

</cfmailpart>
<cfmailpart type="html">
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

<cfif attachmentList.Recordcount gte 1>
<cfloop query="attachmentList">
	<cfset fileToAttach = #currDir# & #AttachmentFileName#>
	<cfif FileExists(fileToAttach)>
		<cfmailparam file="#fileToAttach#">
	</cfif>
</cfloop>
</cfif>
</cfmailpart>

</cfmail>

<cfelse> <!--- SMTP Auth Check #mailServerInfo.EmailListFromEmail#--->
<cfmail
	server="#mailServerInfo.EmailListSMTPServer#" 
	to="#EmailAddress#" 
	from="#mailServerInfo.from_name# <#mailServerInfo.EmailListFromEmail#>"
	subject="#message.MessageSubject#"
	failto="#mailServerInfo.EmailListFromEmail#"
	replyto="#strReplyTo#"
	mailerid="#globals.ELMVersion#"
	>
<cfmailpart type="text" wraptext="74">

<cfif IsDefined("mailServerInfo.EmailListGlobalHeader") AND Len(mailServerInfo.EmailListGlobalHeader) neq 0>#mailServerInfo.EmailListGlobalHeader# #crlf##MessageTxtLF#<cfelse>#MessageTxtLF#</cfif><cfif IsDefined("mailServerInfo.EmailListGlobalFooter") AND Len(mailServerInfo.EmailListGlobalFooter) neq 0>#crlf##mailServerInfo.EmailListGlobalFooter#</cfif>

</cfmailpart>
<cfmailpart type="html">
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
If you wish to be taken off this list, visit the link provided below. You will be taken off automatically. <a href="#globals.siteServerAddress#unsubscribe.cfm?vEmailAddress=#EmailAddress#&vEmailList=#lid#&act=subr">unsubscribe</a>  
</font>
</body>
</html>

<cfif attachmentList.Recordcount gte 1>
<cfloop query="attachmentList">
	<cfset fileToAttach = #currDir# & #AttachmentFileName#>
	<cfif FileExists(fileToAttach)>
		<cfmailparam file="#fileToAttach#">
	</cfif>
</cfloop>
</cfif>
</cfmailpart>

</cfmail>

</cfif> <!--- SMTP Auth Check Close --->

	<cfif IsDefined("globals.logSuccessfulBroadcasts") AND globals.logSuccessfulBroadcasts eq 1>
		<!--- Log successful send to Broadcast_Success_Log database --->
		<cfinclude template="_act_broadcast_success_log.cfm">		
	</cfif>

	<cfcatch type="any">
		<!--- badly formatted email --->
		<cfquery name="qFlagBadAddress" datasource="#Application.DSN#">
			UPDATE email_addresses
			SET Duplicate = 1
			WHERE EmailID = #subscriberList.EmailID#
		</cfquery>
	</cfcatch>
</cftry>
		
</cfloop>
