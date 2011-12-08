<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        December 9, 2003
=====================================================================
 -->

<!--- UN-Comment out below to not create click thru stats links --->
<!--- <cfset vHTMLMessage = #message.MessageHTML#> --->
<!--- End UN-Comment out below to not create click thru stats links --->
<cfscript>
	currPath = ExpandPath("*.*");
	tempCurrDir = GetDirectoryFromPath(currPath) & "attachments";
	if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { trailingSlash = '\'; }
	else { trailingSlash = '/'; }
	currDir = tempCurrDir & trailingSlash;
</cfscript>
<cfset endMessage=Chr(13)&Chr(10)&"."&Chr(13)&Chr(10)>

<cfif Len(message.MessageMultiPart) neq 0 AND message.MessageMultiPart eq "0">
<!--- ************* Text Email **************** --->

	<cfinclude template="_incl_message_text_version_pre61.cfm">
	
<cfelse>
<!--- ************* Multi-Part Email Loop **************** --->
 
	<cfinclude template="_incl_message_multipart_version_pre61.cfm">
	
</cfif>