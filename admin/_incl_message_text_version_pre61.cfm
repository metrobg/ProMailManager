<cfif session.BatchEnd gt subscriberList.RecordCount>
	<cfset session.BatchEnd = subscriberList.RecordCount>
</cfif>
<!--- Text Message Send --->
<cfloop query="subscriberList" startrow="#session.BatchStart#" endrow="#session.BatchEnd#">
	<cfset session.messageSentCount = session.messageSentCount + 1>

<cfset lf=Chr(10)>
<cfset crlf=Chr(13)&Chr(10)>
<!--- <cfset MessageTxtLF ="#Replace(message.MessageTXT, lf, crlf, "All")#"> --->
<cfset MessageTxtLF = #message.MessageTXT# >

<cfmail 
	server="#mailServerInfo.EmailListSMTPServer#" 
	to="#EmailAddress#" 
	from="#mailServerInfo.EmailListFromEmail#"
	subject="#message.MessageSubject#"
	mailerid="#globals.ELMVersion#">
<cfif Len(mailServerInfo.EmailListReplyToEmail) neq 0><cfmailparam name="reply-to" value="#mailServerInfo.EmailListReplyToEmail#"></cfif>	
<cfif IsDefined("mailServerInfo.EmailListGlobalHeader") AND Len(mailServerInfo.EmailListGlobalHeader) neq 0>#mailServerInfo.EmailListGlobalHeader# #crlf##MessageTxtLF#<cfelse>#MessageTxtLF#</cfif><cfif IsDefined("mailServerInfo.EmailListGlobalFooter") AND Len(mailServerInfo.EmailListGlobalFooter) neq 0>#crlf##mailServerInfo.EmailListGlobalFooter#</cfif>

</cfmail>

	<cfif IsDefined("globals.logSuccessfulBroadcasts") AND globals.logSuccessfulBroadcasts eq 1>
		<!--- Log successful send to Broadcast_Success_Log database --->
		<cfinclude template="_act_broadcast_success_log.cfm">		
	</cfif>
	
</cfloop>
	