<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Installation URL Validation - DO NOT REMOVE THIS FILE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>

<body>
<cfif IsDefined("Server.ColdFusion.ProductVersion") AND ListLen(Server.ColdFusion.ProductVersion) gte 2>
	  <cfset nSvrMajorNum = ListGetAt(Server.ColdFusion.ProductVersion, 1)>
	  <cfset nSvrMinorNum = ListGetAt(Server.ColdFusion.ProductVersion, 2)>
	  <cfset strSvrVersion = nSvrMajorNum & "." & nSvrMinorNum>
</cfif>

server:<cfoutput>#cgi.server_name#</cfoutput>;;version:2.5;;cfserver:<cfoutput>#strSvrVersion#</cfoutput>
</body>
</html>
