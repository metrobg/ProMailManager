<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              July 7, 2003
Date Last Modified:        June 24, 2004
=====================================================================
 -->
<cfscript>
	vServerURL = #globals.siteServerAddress#;
	RedirectLinkOrig = vServerURL&'redirect.cfm?';
	RedirectLink = RedirectLinkOrig;
	vHTMLMessage = #message.MessageHTML#;
</cfscript>

<cfset startPos = 1>
<cfinclude template="hrefLinkFind.cfm">
<cfif vHrefFound.Pos[1] neq 0>
	
	<cfquery name="getLastLinkID" datasource="#DSN#">
	SELECT MAX(clickThruID) AS maxClickThruID
	FROM click_thru_stats
	</cfquery>
	<cfoutput query="getLastLinkID">
		<cfset linkCount = ( #Val(maxClickThruID)# + 1 )>
	</cfoutput>
	
	<cfloop condition="#vHrefFound.Pos[1]# neq 0">
		<cfset strTag = Mid( vHTMLMessage, (vHrefFound.Pos[1] + 6), (vHrefFound.Len[1] - 7) )>
		<cfset aFullURLLink = ReFindNoCase('href="([^"])+"[^>]*>', vHTMLMessage, startPos, "True")>
		<cfset strFullURLLink = Mid( vHTMLMessage, (aFullURLLink.Pos[1] + 6), (aFullURLLink.Len[1] - 7) )>
		<cfset nNoTrack = FindNoCase('ELM="NOTRACK"', strFullURLLink, 1)>
		
		 <cfoutput>
			<cfset vLinkFound = strTag>
		      <cfif nNoTrack eq 0>
				<cfif (Left(vLinkFound, 6) neq "mailto")>
				 <!--- -- Added for 2.5 to keep track of broadcast session --->
				 <cfquery name="qCheckSentCount" datasource="#DSN#">
					SELECT COUNT(MessageID) AS nSentCount FROM email_list_messages_send_log
					WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#message.MessageID#">
				 </cfquery>
				 <cfif qCheckSentCount.nSentCount gt 0>
					<cfset nBroadcastSession = qCheckSentCount.nSentCount + 1>
				 <cfelse>
					<cfset nBroadcastSession = 1>	
				 </cfif> 
				 <cfquery name="addLink" datasource="#DSN#">
					INSERT INTO click_thru_stats (MessageListID, MessageID, BroadcastSession, clickThruID, clickTruOriginalURL, clickThruCount)
					VALUES (#message.MessageListID#, #message.MessageID#, #nBroadcastSession#, #linkCount#, '#URLDecode(vLinkFound)#', 0)
				 </cfquery>		
				 <cfif #mailServerInfo.EmailIDLinkAdded# eq 1>
					<cfset RedirectLink = #RedirectLink#&"ID="&#linkCount#&"&MID="&#MID#&"&LID="&#LID#&"&[[CTDIDELM21]]">
				 <cfelse>
					<cfset RedirectLink = #RedirectLink#&"ID="&#linkCount#&"&MID="&#MID#&"&LID="&#LID#>
				 </cfif>
				 		
				 <!--- Replace original link with redirect link from actual start position only --->
				 <cfset vHTMLMessageLeft = Left(vHTMLMessage, (vHrefFound.Pos[1] + 5))>
				 <cfset vHTMLMessageRight = RemoveChars(vHTMLMessage, 1, (vHrefFound.Pos[1] + 5))>
				 <cfset vHTMLMessageRight2 = ReplaceNoCase(vHTMLMessageRight, strTag, RedirectLink, "one")>
				 <cfset vHTMLMessage = vHTMLMessageLeft&vHTMLMessageRight2>
				 <cfset RedirectLink = #RedirectLinkOrig#>
				 <cfset linkCount = linkCount + 1>
				</cfif>
			  </cfif>
			<cfset startPos = (vHrefFound.Pos[1] + vHrefFound.Len[1] + 5)>
			<cfinclude template="hrefLinkFind.cfm">
		 </cfoutput>
	</cfloop>
</cfif>