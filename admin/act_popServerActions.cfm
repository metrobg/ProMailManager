<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 8, 2003
Date Last Modified:        Febuary 25, 2003
=====================================================================
 -->
<cftry>
<cfparam name="listnum" default="1"> <!--- Testing Purposes only - remove for production --->
<cfparam name="mailcheckErr" default="0">
<cfparam name="mailcheckErrMsg" default="">

<cfset bounceCount = 0>

<cfquery name="retrieveEmail" datasource="#DSN#">
SELECT EmailListID AS ListID, EmailListSMTPServer AS SMTPSrv, 
	EmailListPOPServer AS POPSrv, EmailListPOPLogin AS Login, EmailListPOPPwd AS Password
FROM email_lists
WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listnum#">
</cfquery>

<cfquery name="activeSubscriberList" datasource="#DSN#">
	SELECT EmailAddress
	FROM email_addresses
</cfquery>

<cfquery name="qBounceExceptions" datasource="#DSN#">
   SELECT *
   FROM bounce_exceptions
   WHERE BounceExcActive = 1
   AND BounceListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listnum#">
</cfquery>
<cfif qBounceExceptions.RecordCount gte 1>
	<cfset lExceptions = ValueList(qBounceExceptions.BounceExcText)>
</cfif>

<!--- Retrieve number of messages to check for any erroneous messages mx cannot read - open --->
<cfpop 
	action="getHeaderOnly"
	name="qGetMailHeaders"
	server="#retrieveEmail.POPSrv#"
	timeout="#globals.PopServerTimeout#"
	username="#retrieveEmail.Login#"
	password="#retrieveEmail.Password#">
<!--- Retrieve number of messages to check for any erroneous messages mx cannot read - close --->
	
<cfloop from="1" to="#qGetMailHeaders.RecordCount#" index="i">

  <cftry>
	
	<cfpop 
	action="getall"
	name="qGetMail"
	server="#retrieveEmail.POPSrv#"
	timeout="#globals.PopServerTimeout#"
	username="#retrieveEmail.Login#"
	password="#retrieveEmail.Password#" startrow="1" maxrows="1">
	<!--- Message OK --->
	
	<!--- ////// process all valid pop message - open ////// --->
	
	<!--- Check for Unsubscribe in Subject --->
	<cfif qGetMail.Subject CONTAINS 'unsubscribe'>
		<cf_emailaddressfind messagebody="#HTMLEditFormat(qGetMail.from)#">
		<cfset emailFound = Mid(HTMLEditFormat(qGetMail.from), vEmail.Pos[1], vEmail.Len[1])>
		<cf_subscribeengine 
			vemailaddress=#emailFound# 
			vemaillist=#listnum# 	
			act="subr" 
			>
	
	<!--- Check For Subscribe in Subject --->
	<cfelseif qGetMail.Subject CONTAINS 'subscribe'>
    <cflog file="ptTest" type="information" text="subscribe found list number #listnum# ">
		<!--- <cf_emailaddressfind messagebody="#HTMLEditFormat(qGetMail.from)#"> 
		<cfset emailFound = Mid(HTMLEditFormat(qGetMail.from), vEmail.Pos[1], vEmail.Len[1])>--->
           <cflog file="ptTest" type="information" text="address located #qGetMail.from#">
		<cf_subscribeengine 
			vemailaddress=#emailFound# 
			vemaillist=#listnum# 	
			act="suba" 
			>
	
	<!--- Check For remove in Subject --->
	<cfelseif qGetMail.Subject CONTAINS 'remove'>
		<cf_emailaddressfind messagebody="#HTMLEditFormat(qGetMail.from)#">
		<cfset emailFound = Mid(HTMLEditFormat(qGetMail.from), vEmail.Pos[1], vEmail.Len[1])>
		<cf_subscribeengine 
			vemailaddress=#emailFound# 
			vemaillist=#listnum# 	
			act="subr" 
			>
				
	<!--- Check for Bounced messages --->	
	<cfelse>
	
	  <cfif qBounceExceptions.RecordCount gte 1>
	  	<cfif ListContainsNoCase(lExceptions, #HTMLEditFormat(qGetMail.body)#) is not 0>
		<!--- Message contains an exception message so do not process as a legitimate bounce --->
	  	<cfelse>
			<!--- Open Message does not contain an exception message process as normal and check for an email address to flag as bounced --->
			<cf_emailaddressfind messagebody="#HTMLEditFormat(qGetMail.body)#">
			<cfset emailStartPos = #vEmail.Pos[1]#>
			<cfif emailStartPos neq 0>
			 <cfset emailFound = Mid( HTMLEditFormat(qGetMail.body), emailStartPos, vEmail.Len[1] )>
			  <cfif Len(emailFound) gt 6>
				<cfquery name="findEmail" datasource="#DSN#">
				SELECT EmailID, EmailAddress
				FROM email_addresses
				WHERE EmailAddress = '#emailFound#'
					AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listnum#">
				</cfquery>
				<cfif findEmail.RecordCount eq 1>
					<cfset bounceCount = bounceCount + 1>
					<cfquery name="updateBounceColumn" datasource="#DSN#">
					UPDATE email_addresses
					SET Bounced = 1
					WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#findEmail.EmailID#">
					</cfquery>
					<cfquery name="updateBounceLog" datasource="#DSN#">
					INSERT INTO bounce_log (EmailAddressID, BounceSubject, BounceBody)
					VALUES (#findEmail.EmailID#, '#qGetMail.Subject#', '#qGetMail.body#')
					</cfquery>
					<!--- Check if exceeded message size quota --->
				   <cfif #HTMLEditFormat(qGetMail.body)# CONTAINS "exceeded" OR
					#HTMLEditFormat(qGetMail.body)# CONTAINS "quota">
					<cfquery name="updateExceededColumn" datasource="#DSN#">
					UPDATE email_addresses
					SET ExceededMailQuota = 1
					WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#findEmail.EmailID#">
					 </cfquery>
				   </cfif>
				</cfif>
			   </cfif>
			 </cfif>
			 <!--- Close Message does not contain an exception message process as normal and check for an email address to flag as bounced --->

		</cfif>
		
	  <cfelse>
	  		<!--- Open no exceptions active process as normal and check for an email address to flag as bounced --->
			<cfmodule template="emailAddressFind.cfm" messagebody="#HTMLEditFormat(qGetMail.body)#">
			<cfset emailStartPos = #vEmail.Pos[1]#>
			<cfif emailStartPos neq 0>
			 <cfset emailFound = Mid( HTMLEditFormat(qGetMail.body), emailStartPos, vEmail.Len[1] )>
			  <cfif Len(emailFound) gt 6>
				<cfquery name="findEmail" datasource="#DSN#">
				SELECT EmailID, EmailAddress
				FROM email_addresses
				WHERE EmailAddress = '#emailFound#'
					AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listnum#">
				</cfquery>
				<cfif findEmail.RecordCount eq 1>
					<cfset bounceCount = bounceCount + 1>
					<cfquery name="updateBounceColumn" datasource="#DSN#">
					UPDATE email_addresses
					SET Bounced = 1
					WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#findEmail.EmailID#">
					</cfquery>
					<cfquery name="updateBounceLog" datasource="#DSN#">
					INSERT INTO bounce_log (EmailAddressID, BounceSubject, BounceBody)
					VALUES (#findEmail.EmailID#, '#qGetMail.Subject#', '#qGetMail.body#')
					</cfquery>
					<!--- Check if exceeded message size quota --->
				   <cfif #HTMLEditFormat(qGetMail.body)# CONTAINS "exceeded" OR
					#HTMLEditFormat(qGetMail.body)# CONTAINS "quota">
					<cfquery name="updateExceededColumn" datasource="#DSN#">
					UPDATE email_addresses
					SET ExceededMailQuota = 1
					WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#findEmail.EmailID#">
					 </cfquery>
				   </cfif>
				</cfif>
			   </cfif>
			 </cfif>
			 <!--- Close no exceptions active process as normal and check for an email address to flag as bounced --->

	  </cfif>
	  <!--- End Check for Bounced messages --->

	</cfif>
	<!--- ////// process all valid pop message - close ////// --->
	
	 	<!--- Delete The Message/s from pop server as processing of it is complete --->
		 <cfpop 
				action="delete"
				name="deleteEmail"
				server="#retrieveEmail.POPSrv#"
				username="#retrieveEmail.Login#"
				password="#retrieveEmail.Password#"
				messagenumber="#qGetMail.messagenumber#" timeout="#globals.PopServerTimeout#">	
 
	<cfcatch type="any">
 		<!--- ERROR // Bad message --->
		<cfpop 
				action="delete"
				name="qDeleteBadMsg"
				server="#retrieveEmail.POPSrv#"
				username="#retrieveEmail.Login#"
				password="#retrieveEmail.Password#"
				messagenumber="#i#" timeout="#globals.PopServerTimeout#">
		<!--- * Need to Delete // badly encoded message cfmx/java cannot read --->
 	</cfcatch>
	
 </cftry>
 
</cfloop>
 
<cfcatch type="any">	
	<div align="center" class="subscribeFail">There was an error connecting to your POP Server, please verify you have enetered it correct in your
	list setup</div>
	<cfset mailcheckErr = 1>
	<cfset mailcheckErrMsg = cfcatch.Detail>
 </cfcatch>
 </cftry>