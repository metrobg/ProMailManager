<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.andrewkelly.com
Contact Information:       http://www.andrewkelly.com/contact
Date Created:              January 8 2003
Date Last Modified:        March 11, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Email Subscriber Export</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfscript>
	currPath = ExpandPath("*.*");
	tempCurrDir = GetDirectoryFromPath(currPath);
	if ( CGI.SERVER_SOFTWARE CONTAINS "Microsoft" ) { 
		trailingSlash = '\'; 
	}
	else { 
		trailingSlash = '/';
	}
</cfscript>
<table width="100%" border="0" cellspacing="0" cellpadding="1" bgcolor="#000000">
  <tr>
    <td>
      <table width="100%" border="0" cellpadding="8" cellspacing="0">
        <tr>
          <td class="tdHeader"><span class="bodyTextWhite"><strong>Email List
                Export (CSV)</strong></span></td>
        </tr>
        <tr>
          <td align="center" bgcolor="#FFFFFF" class="bodyText"><a href="javascript: window.close();">Close Window</a></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF" class="bodyText">
		  Your Email List file is ready for download, <a href="<cfoutput>export#trailingSlash##exportfile#</cfoutput>">click here</a> to download the file
          <br>
          <font color="#990000"><strong>* To save this file to your hard drive,
          right click the link and select &quot;Save Target As&quot;</strong></font></td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</body>
</html>
