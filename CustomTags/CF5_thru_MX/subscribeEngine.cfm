<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        January 1, 2004
=====================================================================
 -->

<!-- ================Default variables=============================== -->
<cfparam name="ATTRIBUTES.vEmailAddress" default="">
<cfparam name="ATTRIBUTES.FirstName" default="">
<cfparam name="ATTRIBUTES.LastName" default="">
<cfparam name="ATTRIBUTES.City" default="">
<cfparam name="ATTRIBUTES.State" default="">
<cfparam name="ATTRIBUTES.ZipCode" default="">
<cfparam name="ATTRIBUTES.Phone" default="">
<cfparam name="ATTRIBUTES.Country" default="">
<cfparam name="ATTRIBUTES.Custom1" default="">
<cfparam name="ATTRIBUTES.Custom2" default="">
<cfparam name="ATTRIBUTES.Custom3" default="">
<cfparam name="ATTRIBUTES.Custom4" default="">
<cfparam name="ATTRIBUTES.Custom5" default="">

<cfparam name="ATTRIBUTES.vSubject" default="">
<cfparam name="ATTRIBUTES.vErrorResult" default="0">
<cfparam name="ATTRIBUTES.listCnt" default="0">
<cfparam name="ATTRIBUTES.act" default="">
<cfparam name="ATTRIBUTES.DSN" default="Mail-List">

<cfscript>
	currDate = #Now()#;
	tmp1 = RandRange(1000, 1999);
	tmp2 = RandRange(1000, 1999);
	tmp3 = DatePart("n", currDate);
	tmp4 = DatePart("s", currDate);
	vVerifyID = tmp1&tmp2&"-"&tmp3&tmp4;
</cfscript>

<cfquery name="globals" datasource="#ATTRIBUTES.DSN#" cachedwithin="#CreateTimeSpan(0,0,0,0)#">
SELECT * FROM globals
WHERE recID = 1
</cfquery>
<cfquery name="mailServerInfo" datasource="#ATTRIBUTES.DSN#">
SELECT *
FROM email_lists
WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.vEmailList#">
</cfquery>

<!-- 
err1 = script accessed with incorrect method (i.e called directly instead of POST action)
err2 = missing/blank List ID
err3 = non-valid List ID
err4 = missing/blank email address
err5 = non-valid email address (per email validation rules defined)

act (suba) = subscribe add from FORM
act (subr) = subscribe remove from FORM
 -->
<!-- ============End Default variables=============================== -->

<cfif ( Len(ATTRIBUTES.act) eq 4 ) AND ( ATTRIBUTES.act eq "suba" )>
<!-- ================Subscribe From FORM ACTION====================== -->
		<cfif Len(ATTRIBUTES.vEmailList) neq 0>
			<cfif Len(Trim(ATTRIBUTES.vEmailAddress)) gte 6>
				<cfquery name="checkEmailList" datasource="#ATTRIBUTES.DSN#">
				SELECT COUNT(EmailListID) AS listCnt FROM email_lists
				WHERE EmailListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.vEmailList#">
				</cfquery>
				<cfif #checkEmailList.listCnt# eq 1>
				 <!--- Validate Email Address for inserting to database --->
				 <cf_adminpro_emailvalidate email="#ATTRIBUTES.vEmailAddress#">
				 <cfif Error eq 0>
				 	<!--- Check Email is unique to this list --->
					<cfquery name="checkEmailList" datasource="#ATTRIBUTES.DSN#">
				     SELECT * FROM email_addresses 
					 WHERE EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.vEmailAddress#">
					 	AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.vEmailList#">
				    </cfquery>
				  	<!--- Insert Email into subscription table --->
					<cfif checkEmailList.RecordCount eq 0>	
					 <cflock name="addEmail" timeout="30">
				      <cfquery name="addEmail" datasource="#ATTRIBUTES.DSN#">
				      INSERT INTO email_addresses (ListID, EmailAddress, <cfif IsDefined("ATTRIBUTES.FirstName")>FirstName,</cfif> <cfif IsDefined("ATTRIBUTES.LastName")>LastName,</cfif> <cfif IsDefined("ATTRIBUTES.City")>City,</cfif> <cfif IsDefined("ATTRIBUTES.State")>State,</cfif> <cfif IsDefined("ATTRIBUTES.ZipCode")>ZipCode,</cfif> <cfif IsDefined("ATTRIBUTES.Phone")>PhoneNumber,</cfif> <cfif IsDefined("ATTRIBUTES.Country")>Country,</cfif> verificationID, Custom1, Custom2, Custom3, Custom4, Custom5)
				   	  VALUES ('#ATTRIBUTES.vEmailList#', '#ATTRIBUTES.vEmailAddress#', <cfif IsDefined("ATTRIBUTES.FirstName")>'#ATTRIBUTES.FirstName#',</cfif> <cfif IsDefined("ATTRIBUTES.LastName")>'#ATTRIBUTES.LastName#',</cfif> <cfif IsDefined("ATTRIBUTES.City")>'#ATTRIBUTES.City#',</cfif> <cfif IsDefined("ATTRIBUTES.State")>'#ATTRIBUTES.State#',</cfif> <cfif IsDefined("ATTRIBUTES.ZipCode")>'#ATTRIBUTES.ZipCode#',</cfif> <cfif IsDefined("ATTRIBUTES.Phone")>'#Left(ATTRIBUTES.Phone, 30)#',</cfif> <cfif IsDefined("ATTRIBUTES.Country")>'#Left(ATTRIBUTES.Country, 50)#',</cfif> '#vVerifyID#', '#ATTRIBUTES.Custom1#', '#ATTRIBUTES.Custom2#', '#ATTRIBUTES.Custom3#', '#ATTRIBUTES.Custom4#', '#ATTRIBUTES.Custom5#')
				      </cfquery>
				  	 </cflock>
				   	 <cfset CALLER.response = "addedSuccess">
					 <!--- Send Subscribed Auto Response --->
					 	<cfif IsDefined("globals.enableAutoResponders") AND globals.enableAutoResponders eq 1>
							<!--- Check for an auto response message for this list --->
							<cfquery name="qCheckARMessage" datasource="#ATTRIBUTES.DSN#" maxrows="1">
							SELECT * FROM auto_responder_messages WHERE MessageListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.vEmailList#">
							AND SubscribeRequest = 1
							</cfquery>
							<cfif qCheckARMessage.RecordCount gte 1>
							  <!--- message found for this list - Send Auto Response email --->
							  	<!--- Perform personalization updates --->	
								<cfset vHTMLMessage = qCheckARMessage.MessageHTML>
								<cfset vHTMLMessageExtra = ReplaceNoCase(vHTMLMessage,  "[First Name]",  #ATTRIBUTES.FirstName# ,  "All")>
								<cfset vHTMLMessageExtra2 = ReplaceNoCase(vHTMLMessageExtra,  "[Last Name]",  #ATTRIBUTES.LastName# ,  "All")>
								<cfset vHTMLMessageExtra3 = ReplaceNoCase(vHTMLMessageExtra2,  "[Email]",  #ATTRIBUTES.vEmailAddress# ,  "All")>
								<cfset vHTMLMessageExtra4 = ReplaceNoCase(vHTMLMessageExtra3,  "[List]",  #mailServerInfo.EmailListDesc# ,  "All")>
								<cfset vHTMLMessageExtra5 = ReplaceNoCase(vHTMLMessageExtra4,  "[Date Long]",  #DateFormat(#Now()#, "ddd, mmmm dd, yyyy")# ,  "All")>
								<cfset vHTMLMessageExtra6 = ReplaceNoCase(vHTMLMessageExtra5,  "[Date Med]",  #DateFormat(#Now()#, "d-mmm-yyyy")# ,  "All")>
								<cfset vHTMLMessageExtra7 = ReplaceNoCase(vHTMLMessageExtra6,  "[Date Short]",  #DateFormat(#Now()#, "m-d-y")# ,  "All")>
								<cfset vHTMLMessageExtraFinal = vHTMLMessageExtra7>
							  
								<!--- 4.5 - 6 message send --->
								<cfmail 
									server="#mailServerInfo.EmailListSMTPServer#" 
									to="#ATTRIBUTES.vEmailAddress#" 
									from="#mailServerInfo.EmailListFromEmail#"
									subject="#qCheckARMessage.MessageSubject#">	
								<cfmailparam name="Content-Type" value="multipart/alternative; boundary=""alternativemessage""">
								<cfmailparam name="Content-Transfer-Encoding" value="7bit">
								--AlternativeMessage
								Content-Type: text/plain
								Content-Transfer-Encoding: 7bit
								
								#qCheckARMessage.MessageTxt#
								
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
								
								#vHTMLMessageExtraFinal#
								
								<font face="#mailServerInfo.EmailMessageGlobalFontFace#" size="#mailServerInfo.EmailMessageGlobalFontSize#">
								To unsubscribe from our list please click the <a href="#globals.siteServerAddress#unsubscribe.cfm?vEmailAddress=#ATTRIBUTES.vEmailAddress#&vEmailList=#ATTRIBUTES.vEmailList#&act=subr">unsubscribe</a> link
								</font>
								
								</body>
								</html>
								
								--AlternativeMessage--
								
								</cfmail>
							  
							</cfif>
						</cfif>
					 <!--- Send Subscribed Auto Response close --->
					<cfelse>
					 <cfset CALLER.response = "existsNotAdded">
					</cfif>
				 <cfelse>
				 <!--- Email failed validation --->
				   <cfset CALLER.vErrorResult = "err5">
				 </cfif>
				<cfelse>
					<cfset CALLER.vErrorResult = "err3">
				</cfif>
			<cfelse>
				<cfset CALLER.vErrorResult = "err4">
			</cfif>
		<cfelse>
			<cfset CALLER.vErrorResult = "err2">
		</cfif>
	
<!-- ============End Subscribe From FORM ACTION====================== -->

<cfelseif ( Len(ATTRIBUTES.act) eq 4 ) AND ( ATTRIBUTES.act eq "subr" )>
<!-- ================UnSubscribe From FORM ACTION==================== -->
		<cfif Len(ATTRIBUTES.vEmailList) neq 0>
			<cfif Len(Trim(ATTRIBUTES.vEmailAddress)) gte 6>
				<!--- Check Email is unique to this list --->
				<cfquery name="checkEmailList" datasource="#ATTRIBUTES.DSN#">
				    SELECT * FROM email_addresses 
					WHERE EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.vEmailAddress#">
					 AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.vEmailList#">
				</cfquery>
				<!--- Remove Email into subscription table --->
					<cfif checkEmailList.RecordCount eq 1>	
					 <cflock name="removeEmail" timeout="30">
				      <!--- Add to removed table --->
					  <cfquery name="checkEmailRemovedList" datasource="#ATTRIBUTES.DSN#">
				    	SELECT * FROM email_addresses_removed
						WHERE EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.vEmailAddress#">
					 	AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.vEmailList#">
					  </cfquery>
					   <cfif checkEmailRemovedList.RecordCount neq 1>
					    <cfquery name="addToRemove" datasource="#ATTRIBUTES.DSN#">
				        INSERT INTO email_addresses_removed (ListID, EmailAddress, <cfif Len(checkEmailList.FirstName) neq 0>FirstName,</cfif> <cfif Len(checkEmailList.LastName) neq 0>LastName,</cfif> <cfif Len(checkEmailList.City) neq 0>City,</cfif> <cfif Len(checkEmailList.State) neq 0>State,</cfif> <cfif Len(checkEmailList.ZipCode) neq 0>ZipCode,</cfif>Country, VerificationID <cfif checkEmailList.Verified neq 0>,Verified</cfif> <cfif checkEmailList.Bounced neq 0>,Bounced</cfif> ,Unsubscribed, Custom1, Custom2, Custom3, Custom4, Custom5)
				   	    VALUES (#ATTRIBUTES.vEmailList#, '#checkEmailList.EmailAddress#', <cfif Len(checkEmailList.FirstName) neq 0>'#checkEmailList.FirstName#',</cfif> <cfif Len(checkEmailList.LastName) neq 0>'#checkEmailList.LastName#',</cfif> <cfif Len(checkEmailList.City) neq 0>'#checkEmailList.City#',</cfif> <cfif Len(checkEmailList.State) neq 0>'#checkEmailList.State#',</cfif> <cfif Len(checkEmailList.ZipCode) neq 0>'#checkEmailList.ZipCode#',</cfif> '#checkEmailList.Country#', '#checkEmailList.VerificationID#' <cfif checkEmailList.Verified neq 0>,#checkEmailList.Verified#</cfif> <cfif checkEmailList.Bounced neq 0>,#checkEmailList.Bounced#</cfif> ,1 , '#checkEmailList.Custom1#', '#checkEmailList.Custom2#', '#checkEmailList.Custom3#', '#checkEmailList.Custom4#', '#checkEmailList.Custom5#')
				        </cfquery>
					   <cfelse>
					    <cfquery name="updateRemove" datasource="#ATTRIBUTES.DSN#">
				        UPDATE email_addresses_removed 
						SET Unsubscribed = 1
						WHERE EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkEmailRemovedList.EmailID#">
						</cfquery>					    
					   </cfif>
					  <cfquery name="removeEmail" datasource="#ATTRIBUTES.DSN#">
					    DELETE FROM email_addresses
					    WHERE EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.vEmailAddress#">
					 	 AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.vEmailList#">
					  </cfquery>
					  <!--- Remove from main table --->
				  	 </cflock>
				   	 <cfset CALLER.response = "removeSuccess">
					 
					 <!--- Send UN-Subscribed Auto Response --->
					 	<cfif IsDefined("globals.enableAutoResponders") AND globals.enableAutoResponders eq 1>
							<!--- Check for an auto response message for this list --->
							<cfquery name="qCheckARUSMessage" datasource="#ATTRIBUTES.DSN#" maxrows="1">
							SELECT * FROM auto_responder_messages WHERE MessageListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.vEmailList#">
							AND UnsubscribeRequest = 1
							</cfquery>
							<cfif qCheckARUSMessage.RecordCount gte 1>
							  <!--- message found for this list - Send Auto Response unsubscribe email --->
							  	<!--- Perform personalization updates --->	
								<cfset vHTMLMessage = qCheckARUSMessage.MessageHTML>
								<cfset vHTMLMessageExtra = ReplaceNoCase(vHTMLMessage,  "[First Name]",  #ATTRIBUTES.FirstName# ,  "All")>
								<cfset vHTMLMessageExtra2 = ReplaceNoCase(vHTMLMessageExtra,  "[Last Name]",  #ATTRIBUTES.LastName# ,  "All")>
								<cfset vHTMLMessageExtra3 = ReplaceNoCase(vHTMLMessageExtra2,  "[Email]",  #ATTRIBUTES.vEmailAddress# ,  "All")>
								<cfset vHTMLMessageExtra4 = ReplaceNoCase(vHTMLMessageExtra3,  "[List]",  #mailServerInfo.EmailListDesc# ,  "All")>
								<cfset vHTMLMessageExtra5 = ReplaceNoCase(vHTMLMessageExtra4,  "[Date Long]",  #DateFormat(#Now()#, "ddd, mmmm dd, yyyy")# ,  "All")>
								<cfset vHTMLMessageExtra6 = ReplaceNoCase(vHTMLMessageExtra5,  "[Date Med]",  #DateFormat(#Now()#, "d-mmm-yyyy")# ,  "All")>
								<cfset vHTMLMessageExtra7 = ReplaceNoCase(vHTMLMessageExtra6,  "[Date Short]",  #DateFormat(#Now()#, "m-d-y")# ,  "All")>
								<cfset vHTMLMessageExtraFinal = vHTMLMessageExtra7>
							 
								<!--- 4.5 - 6 message send --->
								<cfmail 
									server="#mailServerInfo.EmailListSMTPServer#" 
									to="#ATTRIBUTES.vEmailAddress#" 
									from="#mailServerInfo.EmailListFromEmail#"
									subject="#qCheckARUSMessage.MessageSubject#">	
								<cfmailparam name="Content-Type" value="multipart/alternative; boundary=""alternativemessage""">
								<cfmailparam name="Content-Transfer-Encoding" value="7bit">
								--AlternativeMessage
								Content-Type: text/plain
								Content-Transfer-Encoding: 7bit
								
								#qCheckARUSMessage.MessageTxt#
								
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
								
								#vHTMLMessageExtraFinal#
								
								</body>
								</html>
								
								--AlternativeMessage--
								
								</cfmail>
							  
							</cfif>
						</cfif>
					 <!--- Send Subscribed Auto Response close --->
					 
					<cfelse>
					 <cfset CALLER.response = "removeFail">
					</cfif>
			<cfelse>
			 	<cfset Caller.vErrorResult = "err4">
			</cfif>
		<cfelse>
			<cfset CALLER.vErrorResult = "err2">
		</cfif>
<!-- ============End UnSubscribe From FORM ACTION==================== -->

<cfelse>
</cfif>