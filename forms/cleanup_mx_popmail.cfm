<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>CFMX CFPop Message Validator/Message Cleanup</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfset strPopServer = "">
<cfset strPopUsername = "">
<cfset strPopPassword = "">
<cfset nTimeOut = "">

<cfpop 
	action="getHeaderOnly"
	name="qGetMailHeaders"
	server="#strPopServer#"
	timeout="#nTimeOut#"
	username="#strPopUsername#"
	password="#strPopPassword#">
	
<cfloop from="1" to="#qGetMailHeaders.RecordCount#" index="i">

  <cftry>
	<cfpop 
	action="getall"
	name="qGetMail"
	server="#strPopServer#"
	timeout="#nTimeOut#"
	username="#strPopUsername#"
	password="#strPopPassword#" startrow="#i#" maxrows="1">
	Message: <cfoutput>#i# [#qGetMail.messagenumber#] (Subject: #qGetMail.subject#) </cfoutput> - OK<br>
	
	<cfcatch type="any">
 	ERROR:
	<cfoutput>#cfcatch.Detail#</cfoutput><br>
		<cfpop 
		action="delete"
		name="qDeleteEmail"
		server="#strPopServer#"
		username="#strPopUsername#"
		password="#strPopPassword#" 
		messagenumber="#i#" timeout="#nTimeOut#">
		* Message Deleted<br>
 	</cfcatch>
 </cftry>
 
</cfloop>

 

</body>
</html>
