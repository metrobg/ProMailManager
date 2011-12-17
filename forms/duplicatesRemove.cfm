<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Duplicates</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfquery name="subscriberListLeads" datasource="#DSN#">
SELECT ListID, EmailAddress
FROM email_addresses
WHERE ListID = 10
</cfquery>

<cfloop query="subscriberListLeads">
	<cfquery name="subscriberListMain" datasource="#DSN#">
	SELECT ListID, EmailAddress
	FROM email_addresses
	WHERE ListID = 4
		AND EmailAddress = '<cfoutput>#subscriberListLeads.EmailAddress#</cfoutput>'
	</cfquery>
	<cfif subscriberListMain.RecordCount eq 1>
	<cfoutput>#subscriberListLeads.EmailAddress#</cfoutput><br>
	<cfquery name="deleteDuplicate" datasource="#DSN#">
		DELETE FROM email_addresses
		WHERE ListID = 10
		AND EmailAddress = '<cfoutput>#subscriberListLeads.EmailAddress#</cfoutput>'
	</cfquery>
	</cfif>
</cfloop>
</body>
</html>
