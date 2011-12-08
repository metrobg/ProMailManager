<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.andrewkelly.com
Contact Information:       http://www.andrewkelly.com/contact
Date Created:              January 2, 2003
Date Last Modified:        January 13, 2003  
MBG Last Modified:         Dec 8 2011
=====================================================================
 -->
<cfset vHTMLMessage = #message.MessageHTML#>
<CFMAIL 
	QUERY="subscriberList" 
	SERVER="#mailServerInfo.EmailListSMTPServer#" 
	TO="#EmailAddress#" 
	FROM="#mailServerInfo.from_name# <#mailServerInfo.EmailListFromEmail#>"
	SUBJECT="#message.MessageSubject#" 
	type="html">

<html>
<body>
<cfif IsDefined("mailServerInfo.EmailListGlobalHeaderHTML") AND Len(mailServerInfo.EmailListGlobalHeaderHTML) neq 0>#mailServerInfo.EmailListGlobalHeaderHTML#<br></cfif>
#vHTMLMessage#
<br>
<cfif IsDefined("mailServerInfo.EmailListGlobalFooterHTML") AND Len(mailServerInfo.EmailListGlobalFooterHTML) neq 0>
#mailServerInfo.EmailListGlobalFooterHTML#
</cfif>
<br>
<font face="#mailServerInfo.EmailMessageGlobalFontFace#" size="#mailServerInfo.EmailMessageGlobalFontSize#">
<br>
If you wish to be taken off this list, visit the link provided below. You will be taken off automatically. <a href="#serverGlobals.siteServerAddress#unsubscribe.cfm?vEmailAddress=#EmailAddress#&vEmailList=#lid#&act=subr">unsubscribe</a> 
</font>
</body>
</html>
</CFMAIL>