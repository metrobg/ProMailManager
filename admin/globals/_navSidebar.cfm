<table width="180" border="0" cellspacing="0" cellpadding="1" class="tableBackGrnd">
        <tr> 
          <td> <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="22" class="tdHeader">Menu Choices</td>
              </tr>
                <tr>
                  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='mainReport.cfm'">&nbsp;<a href="mainReport.cfm">System
                      Overview</a></td>
                </tr>
                <tr>
                  <td height="1" align="left"></td>
                </tr>
				<tr> 
                  <td height="25" align="left" nowrap class="tdBackGrnd"><strong>Subscription
                      Lists</strong></td>
                </tr>
                <tr>
                  <td height="1" align="left"></td>
                </tr>
                <tr>
                  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='subscriptionLists.cfm'">&nbsp;<a href="subscriptionLists.cfm">View
                  all Lists</a></td>
                </tr>
                <tr>
                  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='subscriptionListNew.cfm'">&nbsp;<a href="subscriptionListNew.cfm">Create
                  New List</a></td>
                </tr>
                <tr>
                  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='subscribersList.cfm?act=subshow'">&nbsp;<a href="subscribersList.cfm?act=subshow">View Subscribers</a></td>
                </tr>
                <tr>
            		<td height="20" align="left" bgcolor="#FFFFFF" class="bodyText">&nbsp;</td>
                </tr>
               <tr>
                  <td height="1" align="left"></td>
                </tr>
			   <tr>             
               	<td height="25" align="left" nowrap class="tdBackGrnd"><strong>Messages/Campaigns</strong></td>
                </tr>
				<tr>
                  <td height="1" align="left"></td>
                </tr>
                <tr>
                  <td height="20" align="left" bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='messageLists.cfm?View=All'">&nbsp;<a href="messageLists.cfm?View=All">View
                  Message List</a></td>
                </tr>
                <tr>
                  <td height="20" align="left" bgcolor="#FFFFFF" class="bodyText">
                  </td>
                </tr>
				<tr>
                  <td height="1" align="left"></td>
                </tr>
				<tr>             
               	<td height="25" align="left" nowrap class="tdBackGrnd"><strong>Auto
               	    Responders</strong></td>
                </tr>
				<tr>
                  <td height="1" align="left"></td>
                </tr>
                <tr>
                  <td height="20" align="left" bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='auto_responder_messageLists.cfm?View=All'">&nbsp;<a href="auto_responder_messageLists.cfm?View=All">View
                  AR Message List</a></td>
                </tr>
                <tr>
                  <td height="20" align="left" bgcolor="#FFFFFF" class="bodyText">
                  </td>
                </tr>
				<tr>
                  <td height="1" align="left"></td>
                </tr>
				<tr>             
               <td height="25" align="left" nowrap class="tdBackGrnd"><strong>Help/Documentation</strong></td>
                </tr>
				<tr>
                  <td height="1" align="left"></td>
                </tr>
                <tr>
                  <td height="20" align="left" bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='messageLists.cfm'">&nbsp;<a href="../docs/index.html" target="_blank">View
                      Help Docs</a></td>
                </tr>
                <tr>
                  <td height="20" align="left" bgcolor="#FFFFFF" class="bodyText">
                  </td>
                </tr>
                <cfif Session.AccessLevelID eq 1>
				<tr>
                  <td height="1" align="left"></td>
                </tr>
				<tr>
            		<td height="25" align="left" nowrap class="tdAdminOnlyBackGrnd" ><strong>List 
              		Users Admin</strong></td>
                </tr>
                <tr>
                  <td height="1" align="left"></td>
                </tr>
				<tr>
                  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='adminUserList.cfm'">&nbsp;<a href="adminUserList.cfm">View User List/Add New</a></td>
                </tr>
				<tr>
				  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText">&nbsp;</td>
				</tr>				
				<tr>
                  <td height="1" align="left"></td>
			    </tr>
				<tr>
                  <td height="25" align="left" nowrap class="tdAdminOnlyBackGrnd"><strong>Administration
                      Groups</strong></td>
			    </tr>
				<tr>
                  <td height="1" align="left"></td>
			    </tr>
				<tr>
                  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='adminGroupList.cfm'">&nbsp;<a href="adminGroupList.cfm">View
                  Groups/Add New</a></td>
			    </tr>
				<tr>
				  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText">&nbsp;</td>
				  </tr>
				<tr>
                  <td height="1" align="left"></td>
			    </tr>
				<tr>
                  <td height="25" align="left" nowrap class="tdAdminOnlyBackGrnd"><strong>Site
                      Defaults</strong></td>
			    </tr>
				<tr>
                  <td height="1" align="left"></td>
			    </tr>
				<tr>
                  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText" onMouseOver="this.style.backgroundColor='#D9ECFF'" onMouseOut="this.style.backgroundColor=''" onClick="parent.location='adminExtras.cfm'">&nbsp;<a href="adminExtras.cfm">Edit
                      globals</a></td>
			    </tr>
				<tr>
				  <td height="20" align="left" nowrap bgcolor="#FFFFFF" class="bodyText">&nbsp;</td>
				  </tr>

				</cfif>
				<tr>
            		<td height="25" align="center" nowrap bgcolor="#D9ECFF" class="bodyText"><strong>Logout</strong></td>
                </tr>
				<tr>
                  <td height="1"></td>
                </tr>
                
				<tr>
                  <td height="25" align="center" bgcolor="White">
                    <br>
					<form action="logout.cfm" method="post">
					<input name="bLogout" type="submit" value="Logout" class="bodyText">
					</form>
			      </td></tr>
				
            </table></td>
        </tr>
      </table>