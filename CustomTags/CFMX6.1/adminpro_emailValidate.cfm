<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Document Name/Description: 
Date Created:              January 2, 2003
Date Last Modified:        December 17, 2003
=====================================================================
 -->
<cfparam name="ATTRIBUTES.Email" default="">
<cfparam name="ATTRIBUTES.minEmailLength" default="6">

<cfparam name="CALLER.Error" default="0">
<cfparam name="CALLER.ErrorPass1" default="0">
<cfparam name="CALLER.ErrorPass2" default="0">
<cfparam name="CALLER.ErrorPass3" default="0">
<cfparam name="CALLER.ErrorPass4" default="0">
<cfparam name="CALLER.ErrorPass5" default="0">
<cfparam name="CALLER.ErrorPass6" default="0">

<!-- Email address cannot contain any spaces, first remove any spaces -->
<cfset ATTRIBUTES.Email = REReplace(Trim(ATTRIBUTES.Email), '[[:space:]]', "", "all")>
<cfset CALLER.EmailAddress = REReplace(Trim(ATTRIBUTES.Email), '[[:space:]]', "", "all")>
<cfif (Len(ATTRIBUTES.Email)) gte ATTRIBUTES.minEmailLength>
	<cfif ( FindOneOf(ATTRIBUTES.Email, "@", 1) ) AND ( FindOneOf(ATTRIBUTES.Email, ".", 1) )>
		<cfset firstAtPos = FindOneOf(ATTRIBUTES.Email, "@", 1)>
		<cfif Left(ATTRIBUTES.Email, 4) neq "www."> <!-- trap people that confuse a web address with their email address -->
			<cfset CALLER.ErrorPass3 = 0>
		<cfelse>
			<cfset CALLER.ErrorPass3 = 3>
		</cfif>
		<cfif reFindNoCase("[^0-9|^a-z|^@|^.|^_|^-]", "#ATTRIBUTES.Email#")>
			<cfset CALLER.ErrorPass4 = 1> <!-- illegal char found in email address -->
		<cfelse>
			<cfset CALLER.ErrorPass4 = 0>
		</cfif>
		<cfif firstAtPos gt 0>
			<cfif REFind("[\@]{2,}",  ATTRIBUTES.Email,  1)>
				<!--- more then 1 at found - this is not valid --->
				<cfset CALLER.ErrorPass5 = 1>
			<cfelse>
				<cfset CALLER.ErrorPass5 = 0>
			</cfif>
		</cfif>
	<cfelse>
		<cfset CALLER.ErrorPass2 = 1>
	</cfif>
<cfelse>
	<cfset CALLER.ErrorPass1 = 1>
</cfif>

<cfif CALLER.ErrorPass1 gt 0 OR CALLER.ErrorPass2 gt 0 OR CALLER.ErrorPass3 gt 0 OR CALLER.ErrorPass4 gt 0
	OR CALLER.ErrorPass5 gt 0 OR CALLER.ErrorPass6 gt 0>
	
	<!--- validation failed for this email --->
	<cfset CALLER.Error = 1>	
</cfif>