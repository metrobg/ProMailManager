<!--- Set DSN if you do not have it globally set in application.cfm --->
<!--- Set Your List ID also below --->
<cfparam name="DSN" default="MailList">
<cfparam name="lid" default="">
<cfparam name="mlEmailAddress" default="">
<cfparam name="mlFirstName" default="">
<cfparam name="mlLastName" default="">
<cfparam name="mlCity" default="">
<cfparam name="mlState" default="">
<cfparam name="mlZipCode" default="">

<cfmodule template="admin/adminpro_emailValidate.cfm" email="#EmailAddress#">
<cfquery name="checkEmailExists" datasource="#DSN#">
	SELECT * FROM email_addresses 
	WHERE EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailAddress#">
	AND ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
</cfquery>
<cfif Error eq 0 AND checkEmailExists.RecordCount eq 0>
	<cfquery name="addSubscriber" datasource="#DSN#">
		INSERT INTO email_addresses (ListID, EmailAddress, FirstName, LastName, City, State, ZipCode)
		VALUES (#lid#, '#mlEmailAddress#', '#mlFirstName#', '#mlLastName#', '#mlCity#', '#mlState#', '#mlZipCode#')
	</cfquery>
</cfif>
