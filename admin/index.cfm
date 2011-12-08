<!-- 
=====================================================================
Mail List Version 2.1

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 2, 2003
Date Last Modified:        August 16, 2003
=====================================================================
 -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Login</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body>

<table width="300" height="182" border="0" align="center" cellpadding="1" cellspacing="0" bgcolor="#009900">
  <tr>
    <td>
	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
            <cfform name="Login" action="mainReport.cfm" method="post">
              <tr>
                <td height="22" colspan="2" align="right" nowrap><img src="images/EmailListManager_Login.jpg" width="300" height="182"></td>
              </tr>
              <tr>
                <td width="31%" height="22" align="right" nowrap><strong><span class="bodyText">Login
                    Name:</span></strong></td>
                <td width="69%">
                  <cfinput name="vUser" type="text" size="25" maxlength="20" tabindex="1" required="yes" message="You must enter your Login Name" class="textFields" id="vUser">
                </td>
              </tr>
              <tr>
                <td height="22" align="right" nowrap><strong><span class="bodyText">Password:</span></strong> </td>
                <td class="bodyText">
                  <input name="vPwd" type="password" size="15" maxlength="12" tabindex="2" class="textFields" id="vPwd">
                </td>
              </tr>
              <tr>
                <td height="22" align="right">&nbsp;</td>
                <td><input type="submit" name="LoginSubmit" value="Login" class="textFields">
                </td>
              </tr>
            </cfform>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
