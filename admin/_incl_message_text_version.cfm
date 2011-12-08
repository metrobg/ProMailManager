<!--- Text Message Send --->
<cfif session.BatchEnd gt subscriberList.RecordCount>
	<cfset session.BatchEnd = subscriberList.RecordCount>
</cfif>
<cfloop query="subscriberList" startrow="#session.BatchStart#" endrow="#session.BatchEnd#">
	<cfset session.messageSentCount = session.messageSentCount + 1>

<cftry>	
<cfset lf=Chr(10)>
<cfset crlf=Chr(13)&Chr(10)>
<!--- <cfset MessageTxtLF ="#Replace(message.MessageTXT, lf, crlf, "All")#"> --->
<cfset MessageTxtLF = #message.MessageTXT# >
	<cfif Len(mailServerInfo.EmailListReplyToEmail) neq 0>
		<cfset strReplyTo = mailServerInfo.EmailListReplyToEmail>
	<cfelse>
		<cfset strReplyTo = mailServerInfo.EmailListFromEmail>
	</cfif>
<cfif IsDefined("EmailListSMTPLogin") AND Len(Trim(EmailListSMTPLogin)) gt 1 AND IsDefined("EmailListSMTPPassword") AND Len(Trim(EmailListSMTPPassword)) gt 1> <!--- SMTP Auth Check Open --->
<!--- Send SMTP authentication also --->
<cfmail
	server="#mailServerInfo.EmailListSMTPServer#" 
	to="#EmailAddress#" 
	from="#mailServerInfo.EmailListFromEmail#"
	username = "#mailServerInfo.EmailListSMTPLogin#"
	password = "#mailServerInfo.EmailListSMTPPassword#"
	subject="#message.MessageSubject#"
	failto="#mailServerInfo.EmailListFromEmail#"
	replyto="#strReplyTo#"
	mailerid="#globals.ELMVersion#">	
<cfif IsDefined("mailServerInfo.EmailListGlobalHeader") AND Len(mailServerInfo.EmailListGlobalHeader) neq 0>#mailServerInfo.EmailListGlobalHeader# #crlf##MessageTxtLF#<cfelse>#MessageTxtLF#</cfif><cfif IsDefined("mailServerInfo.EmailListGlobalFooter") AND Len(mailServerInfo.EmailListGlobalFooter) neq 0>#crlf##mailServerInfo.EmailListGlobalFooter#</cfif>

</cfmail>

<cfelse> <!--- SMTP Auth Check --->
<cfmail
	server="#mailServerInfo.EmailListSMTPServer#" 
	to="#EmailAddress#" 
	from="#mailServerInfo.EmailListFromEmail#"
	subject="#message.MessageSubject#"
	failto="#mailServerInfo.EmailListFromEmail#"
	replyto="#strReplyTo#"
	mailerid="#globals.ELMVersion#">	
<cfif IsDefined("mailServerInfo.EmailListGlobalHeader") AND Len(mailServerInfo.EmailListGlobalHeader) neq 0>#mailServerInfo.EmailListGlobalHeader# #crlf##MessageTxtLF#<cfelse>#MessageTxtLF#</cfif><cfif IsDefined("mailServerInfo.EmailListGlobalFooter") AND Len(mailServerInfo.EmailListGlobalFooter) neq 0>#crlf##mailServerInfo.EmailListGlobalFooter#</cfif>

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
	