<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<cfparam name="form.DSN" default="Mail-List">
<cfstoredproc procedure="sp_help" datasource="#form.DSN#">
	<cfprocparam type="in" dbvarname="@table_name" value="globals" cfsqltype="cf_sql_varchar">
	<cfprocresult name = "qAALColumns1"  resultset="1">
	<cfprocresult name = "qAALColumns2"  resultset="2">
	<cfprocresult name = "qAALColumns3"  resultset="3">
	<cfprocresult name = "qAALColumns4"  resultset="4">
	<cfprocresult name = "qAALColumns5"  resultset="5">
	<cfprocresult name = "qAALColumns6"  resultset="6">
	<cfprocresult name = "qAALColumns7"  resultset="7">
</cfstoredproc>
<cfdump var="#qAALColumns1#">
<cfdump var="#qAALColumns2#">
<cfdump var="#qAALColumns3#">
<cfdump var="#qAALColumns4#">
<cfdump var="#qAALColumns5#">
<cfdump var="#qAALColumns6#">
<cfdump var="#qAALColumns7#" label="Default Values">
</body>
</html>
