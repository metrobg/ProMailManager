<cfif IsDefined("bUpdate") OR IsDefined("bSendMessage")>
			<cfset vTargetEmpty = ' target=""'>
			<cfset vClassEmpty = ' class=""'>
			<cfset MessageHTML = ReplaceNoCase(MessageHTML, vTargetEmpty , "", "all")>
			<cfset MessageHTML = ReplaceNoCase(MessageHTML, vClassEmpty , "", "all")>
			
			<cfscript>
				if ( IsDefined("ResponseType") AND ResponseType eq "subscribe" ) {
					SubscribeRequest = 1;
					UnsubscribeRequest = 0;
				}
				else {
					SubscribeRequest = 0;
					UnsubscribeRequest = 1;
				}
			</cfscript>
			<cfquery name="qUpdateARMessage" datasource="#DSN#">
			UPDATE auto_responder_messages 
			SET MessageName = '#MessageName#',
			 MessageSubject = '#MessageSubject#', 
			 MessageTXT = '#MessageTXT#', 
			 MessageHTML = '#MessageHTML#',
			 SubscribeRequest = #SubscribeRequest#,
			 UnsubscribeRequest = #UnsubscribeRequest#
			WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Trim(mid)#">
			</cfquery>
			
			<!--- Upload and record attachment --->
			<cfif Len(Trim(attachmentFileField)) eq 0>
				<!--- no attachment received no action required --->
			
			<cfelseif Len(Trim(attachmentFileField)) gte 2>
			
			  <cfif IsDefined("globals.cffileEnabled") AND globals.cffileEnabled eq 1>
				<cfscript>
					currPath = ExpandPath("*.*");
					tempCurrDir = GetDirectoryFromPath(currPath) & "attachments";
					if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { trailingSlash = '\'; }
					else { trailingSlash = '/'; }
					if ( globals.cfmxInstalled eq 1 ) {
						currDir = tempCurrDir;
					}
					else {
						currDir = tempCurrDir & trailingSlash;
					}
					currUserIP = #CGI.REMOTE_ADDR#;
				</cfscript>
				<cffile action="upload" destination="#currDir#" filefield="attachmentFileField" nameconflict="makeunique">
			
					<cfoutput>
						<cfset attachmentFileName = #serverFile#>
						<cfset attachmentFileSize = #File.FileSize#>		
					</cfoutput>
				<!--- Add info to database --->
				<cfquery name="qUploadAttachment" datasource="#DSN#">
					INSERT INTO auto_responder_attachments (AttachmentFileName, AttachmentFileSize, UploadedByUser, UploadIP, MessageID, ListID)
					VALUES ('#Trim(AttachmentFileName)#', #attachmentFileSize#, '#Session.UserName#', '#currUserIP#', #mid#, #lid#)
				</cfquery>
			 </cfif>
			 
			<cfelse>
				<!--- no attachment received no action required possibly badly named attachment --->
			</cfif>
			<!--- Upload and record attachment close --->
			
			<!--- Remove flagged attachments for deletion --->
			<cfif IsDefined("attachDelFlag") AND ListLen(attachDelFlag) gte 1>
			  
			  <cfloop from="1" to="#ListLen(attachDelFlag)#" index="i">
			  
				<cfset currAttachID = ListGetAt(attachDelFlag, i, ",")>	
				<cfquery name="locateAttachment" datasource="#DSN#">
					SELECT * FROM auto_responder_attachments WHERE recID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currAttachID#">
				</cfquery>
				<cfif locateAttachment.RecordCount eq 1>
					<cfquery name="removeAttachment" datasource="#DSN#">
						DELETE FROM auto_responder_attachments WHERE recID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currAttachID#">
					</cfquery>
					<cfif IsDefined("globals.cffileEnabled") AND globals.cffileEnabled eq 1>
						<cfscript>
							currPath = ExpandPath("*.*");
							tempCurrDir = GetDirectoryFromPath(currPath) & "attachments";
							if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { trailingSlash = '\'; }
							else { trailingSlash = '/'; }
							currDir = tempCurrDir & trailingSlash;
							attachmentNameToDelete = #currDir# & #locateAttachment.AttachmentFileName#;
						</cfscript>
						<cfif FileExists(attachmentNameToDelete)>
							<cffile action = "delete" file = "#attachmentNameToDelete#">
						</cfif>
							<cfset fileDeleted = 1>
					<cfelse>
							<!--- Must manually remove the file yourself from the attachment directory --->
							<cfset fileDeleted = 0>
					</cfif>
				</cfif>
				
			  </cfloop>	
			
			<cfelse>
				<!--- No attachments flagged for deletion --->
			</cfif>
			<!--- Remove flagged attachments for deletion close --->
			
			<!--- Send Message broadcast --->
			<cfif IsDefined("bSendMessage")>
				<cfif IsDefined("MessageType")>
				  <cflocation url="sendMessage.cfm?bSendMessage=Broadcast&lid=#lid#&mid=#mid#&MessageType=#MessageType#" addtoken="no">
				<cfelse>
				  <cflocation url="sendMessage.cfm?bSendMessage=Broadcast&lid=#lid#&mid=#mid#" addtoken="no">
				</cfif>
			</cfif>

<cfelseif IsDefined("bSendOneMessage")>
	<cfif globals.cfmxInstalled eq 1>
		<cfinclude template="_messageSendEngineOne.cfm">
		<cfset oneMessageSent = 1>
	<cfelse>
		<cfinclude template="_messageSendEngineOne_pre61.cfm">
		<cfset oneMessageSent = 1>
	</cfif>

<cfelse>
</cfif>
