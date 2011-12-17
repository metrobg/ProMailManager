<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Subscriber Find</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfif IsDefined("Update") AND cgi.request_method eq "post">
	<cfloop from="1" to="#ListLen(Email)#" index="i">
	  <cfif ListGetAt(bSubscribed, i) eq 0>	
		<cf_subscribeengine 
		vemailaddress=#ListGetAt(Email, i)# 
		vemaillist=#ListGetAt(ListID, i)# 	
		act="subr"
		>
	  </cfif>
	</cfloop>
			<cfif IsDefined("vErrorResult")>
				There was an error, your request was not completed<br>
			 <cfswitch expression="#vErrorResult#">
			 	<cfcase value="err2">
			 	Reason: Your must supply a valid subscription list id
			 	</cfcase>
			 	<cfcase value="err3">
			 	Reason: Your must supply a valid subscription list id, list id that was passed was not found to be active
			 	</cfcase>
			 	<cfcase value="err4">
			 	Reason: Your E-mail does not contain enough characters to be valid
			 	</cfcase>
			 	<cfcase value="err5">
			 	Reason: Your E-mail was not valid
			 	</cfcase>
			 </cfswitch>
			</cfif>
			<cfif IsDefined("response")>
			 <cfswitch expression="#response#">
			 	<cfcase value="addedSuccess">
			 	Your E-mail has been successfully added to our list
			 	</cfcase>
			 	<cfcase value="existsNotAdded">
			 	Your E-mail is already subscribed to our list, it was not added again
			 	</cfcase>
			 	<cfcase value="removeSuccess">
			 	Your E-mail has been successfully removed from our list
			 	</cfcase>
			 	<cfcase value="removeFail">
			 	Your E-mail was not found in our list
			 	</cfcase>
			 </cfswitch>
			</cfif>
			<hr>

<cfelse>
	<cfquery name="qFindSubscriber" datasource="#DSN#">
     SELECT * FROM email_addresses EA, email_lists EL
      WHERE EA.ListID = EL.EmailListID
      AND EmailAddress = '#email#'
	  AND EmailListAdminID = #groupid#
	</cfquery>
	<table width="75%" border="0" cellspacing="2" cellpadding="2">
	  <form action="subscriber_find_list.cfm" method="post" name="fSubFind">
		<tr> 
		  <td colspan="2" class="bodyText"><strong>Searched for email address is currently 
			subscribed to the following list/s</strong><br> <hr size="1" noshade></td>
		</tr>
		<tr> 
		  <td class="bodyText" bgcolor="#EEEEEE">List Name </td>
		  <td bgcolor="#EEEEEE" class="bodyText">Subscribed</td>
		</tr>
		<cfoutput query="qFindSubscriber" group="ListID"> 
		  <input type="hidden" name="Email" value="#email#">
		  <input type="hidden" name="ListID" value="#ListID#">
		  <tr> 
			<td class="bodyText">#EmailListDesc#</td>
			<td> 
			  <select name="bSubscribed" class="bodyText">
				<option value="1" selected>Yes</option>
				<option value="0">No</option>
			  </select> </td>
		  </tr>
		</cfoutput> 
		<tr> 
		  <td colspan="2" align="center">
			<input type="submit" name="Update" value="Update" class="bodyText"></td>
		</tr>
	  </form>
	</table>

</cfif>


</body>
</html>
