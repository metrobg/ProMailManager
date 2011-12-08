<!--- Find an email address with a string --->
<cfparam name="ATTRIBUTES.MessageBody" default="">
<CFSET CALLER.vEmail = ReFindNoCase("\b[A-Z0-9._%-]+@[A-Z0-9._%-]+\.[A-Z0-9._%-]{2,4}\b", ATTRIBUTES.MessageBody, 1, "True")>