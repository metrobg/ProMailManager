<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>E-Mail List Unsubscribe</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
	<cf_subscribeengine 
		vemailaddress = "#vEmailAddress#" 
		vemaillist = "#vEmailList#"
		dsn = "#Application.DSN#" 	
		act = "subr" >
	 
    <cfif response IS"removeSuccess">
       Your email address has been removed from the list. You will also receive a confirmation email.
       <cfelse>
         Your email address has NOT been removed from the list.
    
    
    </cfif>
</body>
</html>
