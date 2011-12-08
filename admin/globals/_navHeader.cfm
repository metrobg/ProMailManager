	<table width="100%" border="0" cellspacing="0" cellpadding="1">
  <tr> 
    <td width="23%"><img src="images/MailListManagerLogo.gif" width="300" height="47"></td>
    <td width="77%" height="22" class="bodyText" align="right"><strong>E-Mail List Manager - List Subscription 
      Management</strong><br>
    <font color="#006699">Version 2.5.1</font></td>
  </tr>
  <tr>
    <td colspan="2" height="1" class="tdHeader"></td>
  </tr>
  <tr> 
    <td colspan="2" align="right" class="bodyText"> 
	<cflock timeout=20 scope="Session" type="Readonly">
        <cfoutput>#Session.UserName# [Logged In] Access Level [#Session.AccessLevelDesc#] </cfoutput> 
	</cflock> </td>
  </tr>
  <tr> 
    <td align="right" class="tdHeader"></td>
    <td height="1" align="right" class="tdHeader"></td>
  </tr>
</table>
