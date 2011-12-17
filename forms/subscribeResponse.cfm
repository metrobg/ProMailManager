<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.andrewkelly.com
Contact Information:       http://www.andrewkelly.com/contact
Document Name/Description: refer documentation [U2]
Date Created:              January 2, 2003
Date Last Modified:        January 17, 2003
=====================================================================
 -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Subscribe to list</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
	.bodyText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	}
	.tdBackGround {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
	color: #FFFFFF;
	background-color: #003366;
	}
	.tableBackGrnd {
	background-color: #003366;
	}
</style>
</head>

<body>
<!--- 
*** Error Codes passed - in case of an error ***
err1 = *NOT ACTIVE* - script accessed with incorrect method (i.e called directly instead of POST action)
err2 = missing/blank List ID
err3 = non-valid List ID
err4 = missing/blank email address
err5 = non-valid email address (per email validation rules defined)

*** Success response codes passed if no error above ***
addedSuccess = Email successfulyl added to database
existsNotAdded = Email is already in the database so not added
removeSuccess = Email successfully removed from database
removeFail = Email could not be removed from database as it is not there
 --->
<cfif IsDefined("form.request") AND IsDefined("form.SubscribeSubmit")>

<cf_subscribeengine 
	vemailaddress=#form.EmailAddress# 
	vemaillist=#form.listID# 	
	firstname=#firstname# 
	lastname=#lastname# 
	city=#City# 
	state=#State# 
	zipcode=#zip#
	country=#Country#
	act=#form.request# 
	>

<table width="70%" border="0" align="center" cellpadding="1" cellspacing="0" class="tableBackGrnd">
  <tr> 
    <td> <table width="100%" border="0" cellspacing="0" cellpadding="4">
        <tr> 
          <td height="22" class="tdBackGround">Subscription Request Received</td>
        </tr>
          <tr>
            <td align="left" nowrap bgcolor="#FFFFFF" class="bodyText">
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
			</td>
          </tr>
      </table></td>
  </tr>
</table>
</cfif>
</body>
</html>
