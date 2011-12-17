<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>E-Mail List Unsubscribe</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>


<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" bgcolor='#D0D1EE' >
	<cf_subscribeengine 
		vemailaddress = "#vEmailAddress#" 
		vemaillist = "#vEmailList#"
		dsn = "#Application.DSN#" 	
		act = "subr" >
  
<STYLE>

 .headerTop { background-color:#FFCC66; border-top:0px solid #000000; border-bottom:1px solid #FFFFFF; text-align:center; }
 .adminText { font-size:10px; color:#996600; line-height:200%; font-family:verdana; text-decoration:none; }
 .headerBar { background-color:#FFFFFF; border-top:0px solid #333333; border-bottom:10px solid #FFFFFF; }
 .title { font-size:20px; font-weight:bold; color:#CC6600; font-family:arial; line-height:110%; }
 .subTitle { font-size:11px; font-weight:normal; color:#666666; font-style:italic; font-family:arial; }
 .defaultText { font-size:12px; color:#000000; line-height:150%; font-family:trebuchet ms; }
 .footerRow { background-color:#FFFFCC; border-top:10px solid #FFFFFF; }
 .footerText { font-size:10px; color:#996600; line-height:100%; font-family:verdana; }
 a { color:#FF6600; color:#FF6600; color:#FF6600; }
</STYLE>


<table width="100%" cellpadding="10" cellspacing="0" class="backgroungTable" bgcolor="#D0D1EE">
<tr>

<td valign="top" align="center">





<table width="550" cellpadding="0" cellspacing="0">  



<tr>

<td style="background-color:#010066;border-top:0px solid #000000;border-bottom:1px solid #FFFFFF;text-align:center;" align="center"><span style="font-size:10px;color:#ffffff;line-height:200%;font-family:verdana;text-decoration:none;">Unsubscribe Request </span></td>

</tr>

 

<tr>

<td style="background-color:#FFFFFF;border-top:0px solid #333333;border-bottom:10px solid #FFFFFF;"><center><img src="http://dealer.heritagemfg.com/images/logo_USA.png"  alt="Heritage" width="550" BORDER="0" align="center" id=editableImg1 title="Gobble up the savings"></center></td>

</tr>
<tr><td align="center">
  <cfif response IS"removeSuccess">
    
       Your email address has been removed. You will also receive a confirmation email.
       <cfelse>
         Your email address has NOT been removed from the list.
    
    
    </cfif>
    </td></tr>
</table>



</body>
</html>
