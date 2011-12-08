<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css" />
</head>

<body>
<!--- Verify a datasource is working --->
<cffunction name="VerifyDSN" returntype="boolean">

	<cfargument name="DSN" type="string" required="yes">
	
	<!--- Init local variables --->
	<cfset VAR dsService="">
	<cfset VAR result="true">
	
	<!--- Try/catch block --->
	<cftry>
	<!--- Get "factory" --->
	<cfobject action="CREATE" type="JAVA" class="coldfusion.server.ServiceFactory" name="factory">
	<!--- Get datasource service --->
	<cfset dsService=factory.getDataSourceService()>
	<!--- Validate DSN --->
	<cfset result=dsService.verifyDatasource(DSN)>
	
	<!--- If any error, return FALSE --->
	<cfcatch type="any">
		<cfset result="false">
	</cfcatch>
	</cftry>
	
	<cfreturn result>

</cffunction>

<!--- Security settings --->
<cffunction name="DisplaySecurity" returntype="boolean">
	
	<!--- Init local variables --->
	<cfset VAR dsSecurity="">
	<cfset VAR result="true">
	
	<!--- Try/catch block --->
	<cftry>
	<!--- Get "factory" --->
	<cfobject action="CREATE" type="JAVA" class="coldfusion.server.ServiceFactory" name="factory">
	<!--- Get datasource service --->
	<cfset dsSecurity=factory.getSecurityService()>
	<!--- Validate DSN --->
	<cfset result=dsSecurity.getStatus>
	
	<!--- If any error, return FALSE --->
	<cfcatch type="any">
		<cfset result="false">
	</cfcatch>
	</cftry>
	
	<cfreturn result>

</cffunction>

<br />
<table width="400" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="20" class="bodyText">Datasource Validation: <strong><cfoutput>#VerifyDSN("Mail-List")#</cfoutput></strong></td>
  </tr>
  <tr>
    <td height="20" class="bodyText">Security Settings: <strong><cfoutput>#DisplaySecurity#</cfoutput></strong></td>
  </tr>
</table>
<cfoutput>

</cfoutput> 
</body>
</html>
