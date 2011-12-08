<cfoutput>
<cfif IsDefined("mailServerInfo.EmailPersonalization") AND mailServerInfo.EmailPersonalization eq 1>
 <cfset tempHTMLMessage = vHTMLMessageExtraFinal>
<cfelse>
 <cfset tempHTMLMessage = vHTMLMessage>
</cfif>
<cfset tempHTMLMessage2 = Replace(tempHTMLMessage, "[[CTDIDELM21]]", "EID=#subscriberList.EmailID#" , "All")>
<cfset vHTMLMessageExtraFinal = tempHTMLMessage2>
</cfoutput>