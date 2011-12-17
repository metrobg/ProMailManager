<cfapplication name="MailList25" sessionmanagement="yes" clientmanagement="No"
 sessiontimeout="#CreateTimeSpan(0,2,0,0)#" setclientcookies="yes" setdomaincookies="no">

<cfset DSN = "HMITest">
<cfset Application.DSN = "#DSN#">

<cfquery name="globals" datasource="#DSN#" cachedwithin="#CreateTimeSpan(0,0,0,0)#">
SELECT * FROM globals
WHERE recID = 1
</cfquery>

<!--- <cfset nSvrMajorNum = ListGetAt(Server.ColdFusion.ProductVersion, 1)>
<cfif nSvrMajorNum gte 6>	
	<cfsetting enablecfoutputonly="no" requesttimeout="#globals.PageTimeout#">
</cfif> --->






































