  <link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
  <cfquery name="qCurrentGroups" datasource="#DSN#">
    SELECT * FROM email_list_groups WHERE ListID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lid#">
    ORDER BY GroupDesc
  </cfquery>
  <cfquery name="qCurrentSchedules" datasource="#DSN#">
    SELECT * FROM email_list_messages_schedule WHERE MSchedMessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MessageID#">
    ORDER BY MSchedStartDate
  </cfquery>
  <cfif qCurrentSchedules.RecordCount gte 1>
  <!--- Open Current Schedules --->
  <table width="95%" border="1" cellspacing="0" cellpadding="1">
    <tr>
      <td height="22" colspan="8" nowrap class="bodyText" bgcolor="#CCCCCC"><font color="#000066"><strong>Update
            a schedule for this message to be sent</strong></font></td>
    </tr>
    <tr>
      <td height="22" nowrap class="bodyText"><strong>Schedule Start Date</strong></td>
      <td nowrap class="bodyText"><strong>Schedule Start Time</strong></td>
      <td nowrap class="bodyText"><strong>Scheduled End Date</strong></td>
      <td nowrap class="bodyText"><strong>Schedule End Time</strong></td>
      <td nowrap class="bodyText"><strong>Schedule Interval</strong></td>
      <td nowrap class="bodyText"><strong>Group To Send Message To</strong></td>
      <td nowrap class="bodyText"><strong>Active</strong></td>
      <td width="100%" height="22" nowrap class="bodyText">&nbsp;</td>
    </tr>
    <cfoutput query="qCurrentSchedules">
	<form action="messageLists.cfm" name="fScheduleUpdate#MsgScheduleID#" method="post">
	<input type="hidden" name="MsgScheduleID" value="#MsgScheduleID#">
	<input type="hidden" name="Drill" value="#Drill#">
	<input type="hidden" name="mid" value="#mid#">
	<input type="hidden" name="lid" value="#lid#">
	<cfquery name="qCurrentGroupName" datasource="#DSN#">
    SELECT * FROM email_list_groups WHERE GroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCurrentSchedules.MSchedGroupID#">
  	</cfquery>
	<tr>
      <td height="22" nowrap class="bodyText">	
		<cfmodule template="popdatetime.cfm" formname="fScheduleUpdate#MsgScheduleID#"
             fieldname="MSchedStartDate" 
			 classstyle="textFields" size="12" maxlength="10" defaultdate="#DateFormat(MSchedStartDate, globals.DateDisplay)#"
             time="no"
             euro="no"
             scriptpath="popDateTime/">
	  </td>
      <td nowrap class="bodyText"><input name="MSchedStartTime" value="#MSchedStartTime#" type="text" class="textFields" size="8" maxlength="7"></td>
      <td nowrap class="bodyText">
	  		<cfmodule template="popdatetime.cfm" formname="fScheduleUpdate#MsgScheduleID#"
             fieldname="MSchedEndDate" classstyle="textFields" size="12" maxlength="10" 
			 defaultdate="#DateFormat(MSchedEndDate, globals.DateDisplay)#"
             time="no"
             euro="no"
             scriptpath="popDateTime/"></td>
      <td nowrap class="bodyText"><input name="MSchedEndTime" value="#MSchedEndTime#" type="text" class="textFields" size="8" maxlength="7"></td>
      <td nowrap class="bodyText">
	  	<select name="MSchedInterval" class="textFields">
			<option value="once" <cfif MSchedInterval eq 'once'>selected</cfif>>Once Only</option>
			<option value="daily" <cfif MSchedInterval eq 'daily'>selected</cfif>>Daily</option>
			<option value="weekly" <cfif MSchedInterval eq 'weekly'>selected</cfif>>Weekly</option>
			<option value="monthly" <cfif MSchedInterval eq 'monthly'>selected</cfif>>Monthly</option>
      	</select>      
  	OR                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  	<input name="MSchedIntervalInt" <cfif IsNumeric(MSchedInterval)>value="#MSchedInterval#"</cfif> type="text" class="textFields" size="6" maxlength="10"> seconds</td>
      <td nowrap class="bodyText">
	  <select name="MSchedGroupID" id="MSchedGroupID" class="bodyText">
          <option value="#qCurrentSchedules.MSchedGroupID#"><cfif qCurrentSchedules.MSchedGroupID eq 0>All Subscribers<cfelse>#qCurrentGroupName.GroupDesc#</cfif></option>
		  <cfif qCurrentSchedules.MSchedGroupID neq 0>
		  <option value="0">All Subscribers</option>
		  </cfif>
		<cfloop query="qCurrentGroups">
          <cfif qCurrentSchedules.MSchedGroupID neq qCurrentGroups.GroupID>
		  <option value="#GroupID#">#GroupDesc#</option>
		  </cfif>
        </cfloop>
      </select>
	  </td>
      <td nowrap class="bodyText">
	  <select name="MSchedActive" class="textFields">
      	<cfif MSchedActive eq 1>	
			<option value="1" selected>Yes</option>
			<option value="0">No</option>
		<cfelse>
			<option value="0" selected>No</option>
			<option value="1">Yes</option>
		</cfif>
	  </select>
	   <cfif MSchedActive eq 1>[<a href="messageLists.cfm?mid=#mid#&lid=#lid#&bScheduleRunNow=1&MsgScheduleID=#MsgScheduleID#">run now</a>]</cfif>
	  </td>
      <td height="22" nowrap class="bodyText"><input name="bUpdateSchedule" type="submit" class="bodyText" id="bUpdateSchedule" value="Update">
        <img src="../images/spacer_white.gif" width="8" height="5">
        <input name="bDeleteSchedule" type="submit" class="bodyText" id="bDeleteSchedule" value="Delete"></td>
    </tr>
	</form>
	</cfoutput>
	</table>
	<!--- Close Current Schedules --->
	<br>
	</cfif>
 		
	<!--- Open Add Schedule --->	
	<table width="95%" border="1" cellspacing="0" cellpadding="1">
	<tr>
      <td height="22" colspan="7" nowrap class="bodyText" bgcolor="#CCCCCC"><font color="#000066"><strong>Add
            a new schedule for this message to be sent</strong></font></td>
    </tr>
    <tr>
      <td height="22" nowrap class="bodyText"><strong>Schedule Start Date</strong></td>
      <td nowrap class="bodyText"><strong>Schedule Start Time</strong></td>
      <td nowrap class="bodyText"><strong>Scheduled End Date</strong></td>
      <td nowrap class="bodyText"><strong>Schedule End Time</strong></td>
      <td nowrap class="bodyText"><strong>Schedule Interval</strong></td>
      <td nowrap class="bodyText"><strong>Group To Send Message To</strong></td>
      <td width="100%" height="22" nowrap class="bodyText">&nbsp;</td>
    </tr>
    <form action="messageLists.cfm" name="fScheduleAdd" method="post">
	<cfoutput>
	<input type="hidden" name="mid" value="#mid#">
	<input type="hidden" name="lid" value="#lid#">
	<input type="hidden" name="Drill" value="#Drill#">
	</cfoutput>
	<tr>
      <td height="22" nowrap class="bodyText">
	  	<cfmodule template="popdatetime.cfm" formname="fScheduleAdd"
             fieldname="MSchedStartDate" 
			 classstyle="textFields" size="10" maxlength="10"
             time="no"
             euro="no"
             scriptpath="popDateTime/">
	  </td>
      <td nowrap class="bodyText"><input name="MSchedStartTime" type="text" class="textFields" size="8" maxlength="7"></td>
      <td nowrap class="bodyText">
	  		<cfmodule template="popdatetime.cfm" formname="fScheduleAdd"
             fieldname="MSchedEndDate" classstyle="textFields" size="10" maxlength="10" 
             time="no"
             euro="no"
             scriptpath="popDateTime/"></td>
      <td nowrap class="bodyText"><input name="MSchedEndTime" type="text" class="textFields" size="8" maxlength="7"></td>
      <td nowrap class="bodyText">
	  	<select name="MSchedInterval" class="textFields">
			<option value="once">Once Only</option>
			<option value="daily">Daily</option>
			<option value="weekly">Weekly</option>
			<option value="monthly">Monthly</option>
      	</select>      
  	OR                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  	<input name="MSchedIntervalInt" type="text" class="textFields" size="6" maxlength="10"> seconds</td>
      <td nowrap class="bodyText">
	  <select name="MSchedGroupID" id="MSchedGroupID" class="bodyText">
          <option value="0">All Subscribers</option>
		<cfoutput query="qCurrentGroups">
          <option value="#GroupID#">#GroupDesc#</option>
        </cfoutput>
      </select>
	  </td>
      <td height="22" nowrap class="bodyText"><input name="bAddSchedule" type="submit" class="bodyText" id="bAddSchedule" value="Add">
      </td>
	</tr>
	</form>
  </table>
  <!--- Close Add Schedule --->
