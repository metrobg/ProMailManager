		<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
		<cfparam name="email" default="">
		<!--- Initialize NextN variables using <cf_nextn> --->
		<cf_nextn recordcount="#qSubscriberSearch.RecordCount#" resultsperpage="#globals.subscribersList_MaxRows#">
			
			
		<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
			<!--- Group name retrieved display --->
			<tr>
			  <td colspan="11" class="bodyText">
			  <table width="100%" border="0" cellpadding="2" cellspacing="0" bgcolor="#B1B163" align="center">
			    <tr>
			      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
			        <tr>
			          <td height="22" align="center" class="bodyText">Current Subscriber
			            Group Displayed: <strong>No group saved yet</strong>
					  </td>
		            </tr>
		          </table></td>
		        </tr>
		      </table>
			  </td>
		  	</tr>
			<!--- End Group name retrieved display --->
			<tr>
			  <td colspan="11" class="bodyText"> 
				  <table cellpadding="3" cellspacing="0" width="100%" bgcolor="#EEEEEE">
					<tr>
					  <td height="22" align="left" bgcolor="White" class="bodyText">
					  <cfoutput>
						<span class="bold">#REQUEST.StartRow#</span> - <span class="bold">#REQUEST.EndRow#</span> of <span class="bold">#REQUEST.TotalRows#</span> 
						(Page <span class="bold">#REQUEST.CurrentPage#</span> of <span class="bold">#REQUEST.TotalPages#</span>)
					  </cfoutput>
					  </td>
				    </tr>
					<cfif qSubscriberSearch.RecordCount gt globals.subscribersList_MaxRows>
					<tr>
						<td height="22" align="left" class="bodyText">
						Page: [ <cf_pagelinks displaypagelinks="Yes" displaypageinput="No" displaypreviousnext="No" querystring="lid=#lid#&subSearchTxt=#subSearchTxt#&subFilter=#subFilter#&bSubSearch=1"> ] <cf_pagelinks displaypagelinks="No" displaypageinput="No" displaypreviousnext="Yes" querystring="lid=#lid#&subSearchTxt=#subSearchTxt#&subFilter=#subFilter#&bSubSearch=1">
						</td>
					</tr>
					</cfif>
					<tr>
					  <td height="5" align="left" bgcolor="White" class="bodyText"><img src="../images/spacer_white.gif" width="5" height="5"></td>
				    </tr>
			       </table>
			  </td>
			</tr>
			<tr>
			  <td height="1" colspan="11" nowrap class="tdHorizDivider"><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
			</tr>
			<tr>
			  <td height="18" align="left" nowrap class="tdBackGrnd"><strong>Email
				  Address</strong></td>
			  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
			  <td align="center" class="tdBackGrnd"><strong>First Name</strong></td>
			  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
			  <td align="center" class="tdBackGrnd"><strong>Last Name</strong></td>
			  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
			  <td align="center" class="tdBackGrnd"><strong>City</strong></td>
			  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
			  <td align="center" class="tdBackGrnd"><strong>State</strong></td>
			  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
			  <td align="center" class="tdBackGrnd"><strong>Zip</strong>&nbsp;</td>
		    </tr>
			<tr>
			  <td height="2" colspan="11" class="tdHorizDivider"></td>
			</tr>
			<cfloop query="qSubscriberSearch" startrow="#REQUEST.StartRow#" endrow="#REQUEST.EndRow#">
			<cfoutput>
			  <cfform action="#cgi.script_name#" method="post">
				<input type="hidden" name="subSearchTxt" value="#subSearchTxt#">
				<input type="hidden" name="subFilter" value="#subFilter#">
				<input type="hidden" name="eid" value="#EmailID#">
				<input type="hidden" name="lid" value="#lid#">
				<cfif IsDefined("bEmailSearch")>
				  <input type="hidden" name="bEmailSearch" value="Search">
				  <input type="hidden" name="email" value="#email#">
				</cfif>
				<tr>
				  <td height="22" align="left" nowrap class="bodyText"> 
					<a href="javascript:popUpWindow('subscriberDetailFull.cfm?sid=#EmailID#&lid=#lid#', 'yes', 'yes', '50', '50', '850', '400')"><img src="../images/editDocIcon.gif" width="12" height="15" align="absmiddle" border="0" title="Click to view extended information for this subscriber"></a>
					#EmailAddress#
					<cfif Bounced eq 1>
					  <img src="../images/bouncedBombRed.gif" width="20" height="17" align="absmiddle">
					  <cfquery name="getBounceLog" datasource="#DSN#">
					  SELECT * FROM bounce_log WHERE EmailAddressID =
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#EmailID#">
					  </cfquery>
					  [<a href="javascript:popUpWindow('addressBounceLog.cfm?EmailID=#EmailID#', 'yes', 'no', '50', '50', '400', '400')">#getBounceLog.RecordCount#</a>]
					</cfif>
					<cfif ExceededMailQuota eq 1>
					  <img src="../images/bouncedBomb.gif" width="20" height="17" align="absmiddle">
					</cfif>
				  </td>
				  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
				  <td align="center" class="bodyText">#FirstName#
				  </td>
				  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
				  <td align="center" class="bodyText">
					#LastName#
				  </td>
				  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
				  <td align="center" class="bodyText">#City#
				  </td>
				  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
				  <td align="center" class="bodyText">#State#
				  </td>
				  <td class="tdVertDivider" width="1" nowrap><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
				  <td align="center" class="bodyText">#ZipCode#
				  </td>
			    </tr>
				<tr>
				  <td height="1" colspan="11" class="tdVertDivider"><img src="../images/spacer_transparent.gif" width="1" height="1"></td>
				</tr>
			  </cfform>
			</cfoutput>
			</cfloop>
			<tr>
			  <td colspan="11" class="bodyText">
			  	<table cellpadding="3" cellspacing="0" width="100%" bgcolor="#EEEEEE">
					<tr>
					  <td height="22" align="left" bgcolor="White" class="bodyText">
					  <cfoutput>
						<span class="bold">#REQUEST.StartRow#</span> - <span class="bold">#REQUEST.EndRow#</span> of <span class="bold">#REQUEST.TotalRows#</span> 
						(Page <span class="bold">#REQUEST.CurrentPage#</span> of <span class="bold">#REQUEST.TotalPages#</span>)
					  </cfoutput>
					  </td>
				    </tr>
					<cfif qSubscriberSearch.RecordCount gt globals.subscribersList_MaxRows>
					<tr>
						<td height="22" align="left" class="bodyText">
						Page: [ <cf_pagelinks displaypagelinks="Yes" displaypageinput="No" displaypreviousnext="No" querystring="lid=#lid#&subSearchTxt=#subSearchTxt#&subFilter=#subFilter#&bSubSearch=1"> ] <cf_pagelinks displaypagelinks="No" displaypageinput="No" displaypreviousnext="Yes" querystring="lid=#lid#&subSearchTxt=#subSearchTxt#&subFilter=#subFilter#&bSubSearch=1">
						</td>
					</tr>
					</cfif>
					<tr>
					  <td height="5" align="left" bgcolor="White" class="bodyText"><img src="../images/spacer_white.gif" width="5" height="5"></td>
				    </tr>
			       </table>
			  </td>
			</tr>
			<tr>
			  <td height="8" colspan="11"></td>
			</tr>
			<tr>
				<td height="30" colspan="11" align="center" valign="middle" class="bodyText">
				<table width="70%" border="0" align="center" cellpadding="2" cellspacing="2">
					<tr>
					  <td width="6%" align="right"><img src="../images/bouncedBombRed.gif" width="20" height="17"></td>
					  <td width="94%" nowrap class="bodyText">denotes Email address
						has bounced on a recent broadcast)</td>
					</tr>
					<tr>
					  <td align="right"><img src="../images/bouncedBomb.gif"></td>
					  <td nowrap class="bodyText">denotes Email address has bounced
						on a recent broadcast due to exceeding mailbox allocation</td>
					</tr>
				  </table>
				</td>
		  </tr>
		</table>
