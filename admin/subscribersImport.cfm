<!-- 
=====================================================================
Mail List Version 2.0

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              January 4, 2003
Date Last Modified:        April 30, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mail List: Admin Main</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href=" rel="stylesheet" type="text/css">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="180" valign="top"> <cfinclude template="globals/_navSidebar.cfm"> </td>
    <td width="2"><img src="../images/spacer_white.gif" width="2"></td>
    <td width="100%" valign="top"><cfinclude template="globals/_navHeader.cfm">
<table width="100%" border="0">
  <tr>
    <td height="20" class="tdBackGrnd"><strong>Import a List of Subscribers:</strong></td>
  </tr>
  <tr>
    <td height="16" bgcolor="#CCCCCC" class="bodyText">&gt;&gt; <strong>Import
        CSV File</strong>      (use to upload a csv file and import into Email Addresses table)</td>
  </tr>
  <tr>
    <td height="16" class="bodyText"><u>Instructions</u>:<br>
      <strong>1.</strong> Create a comma delimited file and name it &quot;anyfilename.csv&quot; (without
        the quotes)<br>
        The file should have up to a total of 10 columns in the following exact
        order<br>
        List ID, Email Address, First Name, Last Name, City, State,
        Zip, Country, Phone, Cell Phone. You may <a href="import/AddressImportTemplate.csv">download
        a sample file</a> here
        to use as your template<br>
        <font color="Red">** DO NOT CREATE YOUR FILE WITH ANY HEADER COLUMNS **</font><br>
        Note to import into this list your List ID is <strong><cfoutput>#lid#</cfoutput></strong><br>
        <strong>2.</strong> Click the browse button and locate the file on your
        hard drive<br>
        <strong>3.</strong> Click the Import CSV File button to import the addresses in this file
        into your active subscribers database</td>
  </tr>
  <form name="importCSV" enctype="multipart/form-data" method="post" action="subscriptionLists.cfm">
  <cfoutput><input type="hidden" name="lid" value="#lid#"></cfoutput>
  <tr>
    <td class="bodyText">
      <input type="file" name="importFile" class="bodyText">
	  <input name="bImportCSV" type="submit" id="bImportCSV" value="Import CSV File" class="tdHeader">
    </td>
  </tr>
  </form>
  <tr>
    <td height="16" bgcolor="#CCCCCC" class="bodyText">&gt;&gt; <strong>Import pasted
      list of email addresses</strong></td>
  </tr>
  <tr>
    <td class="bodyText"><u>Instructions</u>: <br>
      <strong>1.</strong>      Paste 1 email per line<br>
      <strong>2.</strong> Click Import Button<br>
      i.e<br>
      joe@aol.com<br>
      joe2@aol.com<br>
      joe3@hotmail.com<br>
      ....etc</td>
  </tr>
  <form action="subscriptionLists.cfm" method="post">
  <cfoutput><input type="hidden" name="lid" value="#lid#"></cfoutput>
  <tr>
    <td><textarea name="subscriberImportList" cols="45" rows="15"></textarea></td>
  </tr>
  <tr>
    <td><input name="bImport" type="submit" id="bImport" value="Import" class="tdHeader"></td>
  </tr>
  </form>
  </table> 
    </td>
  </tr>
  <tr align="center"> 
    <td colspan="3"><cfinclude template="globals/_Footer.cfm"></td>
  </tr>
</table>
</body>
</html>
