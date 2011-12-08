<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.andrewkelly.com
Contact Information:       http://www.andrewkelly.com/contact
Document Name/Description: refer documentation [U2]
Date Created:              January 2, 2003
Date Last Modified:        January 2, 2003
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
<table width="70%" border="0" align="center" cellpadding="1" cellspacing="0" class="tableBackGrnd">
  <tr> 
    <td> <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td height="22" colspan="2" class="tdBackGround">Subscribe/Unsubscribe to/from 
            our E-mail Newsletter List</td>
        </tr>
        <cfform name="subscribeForm" action="subscribeResponse.cfm" method="post">
		<input type="hidden" name="listID" value="4">
          <tr> 
            <td height="22" align="right" nowrap bgcolor="#CCCCCC" class="bodyText"><strong>Email Address:</strong></td>
            <td bgcolor="#CCCCCC" class="tdBackGrnd"> <cfinput name="EmailAddress" type="text" size="45" maxlength="100" required="yes" message="Please enter an email address" class="bodyText"> 
            </td>
          </tr>
          <tr>
            <td height="22" align="right" nowrap bgcolor="#CCCCCC" class="bodyText"><strong>First
                Name:</strong></td>
            <td bgcolor="#CCCCCC" class="tdBackGrnd">
              <input name="FirstName" type="text" class="bodyText" id="FirstName" size="30" maxlength="75" required="yes" message="Please enter an email address">
            </td>
          </tr>
          <tr>
            <td height="22" align="right" nowrap bgcolor="#CCCCCC" class="bodyText"><strong>Last
                Name:</strong></td>
            <td bgcolor="#CCCCCC" class="tdBackGrnd">
              <input name="Lastname" type="text" class="bodyText" id="Lastname" size="30" maxlength="75" required="yes" message="Please enter an email address">
            </td>
          </tr>
          <tr>
            <td height="22" align="right" nowrap bgcolor="#CCCCCC" class="bodyText"><strong>City:</strong></td>
            <td bgcolor="#CCCCCC" class="tdBackGrnd">
              <input name="City" type="text" class="bodyText" id="City" size="30" maxlength="50" required="yes" message="Please enter an email address">
            </td>
          </tr>
          <tr>
            <td height="22" align="right" nowrap bgcolor="#CCCCCC" class="bodyText"><strong>State:</strong></td>
            <td bgcolor="#CCCCCC" class="tdBackGrnd">
              <input name="State" type="text" class="bodyText" id="State" size="30" maxlength="50" required="yes" message="Please enter an email address">
            </td>
          </tr>
          <tr>
            <td height="22" align="right" nowrap bgcolor="#CCCCCC" class="bodyText"><strong>Zip:</strong></td>
            <td bgcolor="#CCCCCC" class="tdBackGrnd">
              <input name="Zip" type="text" class="bodyText" id="Zip" size="10" maxlength="15" required="yes" message="Please enter an email address">
            </td>
          </tr>
          <tr>
            <td height="22" align="right" nowrap bgcolor="#CCCCCC" class="bodyText"><strong>Country:</strong></td>
            <td bgcolor="#CCCCCC" class="tdBackGrnd">
              <input name="Country" type="text" class="bodyText" id="Country" size="30" maxlength="50" required="yes" message="Please enter an email address">
            </td>
          </tr>
          <tr>
            <td align="right" valign="middle" nowrap bgcolor="#FFFFFF" class="bodyText"><strong>Action:</strong> 
            </td>
            <td bgcolor="#FFFFFF" class="bodyText"> 
              Subscribe <input name="request" type="radio" value="suba" checked class="bodyText"><br>
              Unsubscribe <input name="request" type="radio" value="subr" class="bodyText">
			</td>
          </tr>
          <tr> 
            <td align="right" nowrap bgcolor="#FFFFFF">&nbsp;</td>
            <td bgcolor="#FFFFFF"><input type="submit" name="SubscribeSubmit" value="Submit" class="bodyText"></td>
          </tr>
        </cfform>
      </table></td>
  </tr>
</table>
</body>
</html>
