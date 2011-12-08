<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Delete all Tables</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<cfset strDSN = "mbgXE">
 
<cfset lTableList = "ADMIN,ADMIN_ACCESS_LEVELS,ATTACHMENTS,AUTO_RESPONDER_ATTACHMENTS,AUTO_RESPONDER_MESSAGES,AUTO_RESPONDER_SCHEDULE,BOUNCE_EXCEPTIONS,BOUNCE_LOG,BROADCAST_SUCCESS_LOG,CHART_TYPES,CLICK_THRU_STATS,CLICK_THRU_STATS_DETAIL,DATABASE_TYPES,EMAIL_ADDRESSES,EMAIL_ADDRESSES_REMOVED,EMAIL_LIST_MESSAGES,EMAIL_LIST_GROUPS,EMAIL_LIST_GROUPS_MEMBERS,EMAIL_LIST_GROUPS_TEMPHOLDER,EMAIL_LST_MESSAGES_PERSONALIZE,EMAIL_LIST_MESSAGES_SEND_LOG,EMAIL_LISTS,EMAIL_LIST_MESSAGES_SCHEDULE,FONT_FACES,GLOBALS,SEND_LOG_ID"><br>

	<!--- <cfoutput><cfdump var="#qAllTables#"></cfoutput> 
	<cfset lTableList = valuelist(qAllTables.TABLE_NAME)><br>--->
    
	<cfset j = 1>
	
	 
	  <cfloop from="1" to="#ListLen(lTableList)#" index="j">
	   <cftry>	
         <!--- Processing  <cfoutput>#ListGetAt(lTableList, j)# <br /> --->
         <cfoutput>
         
		 DROP TABLE #ListGetAt(lTableList, j)# cascade constraints PURGE; <br> 
        
	 </cfoutput>
		<!---   <cfquery name="qDropTables" datasource="mbgXE">
			DROP TABLE #ListGetAt(lTableList, j)# cascade constraints PURGE
		</cfquery>  --->
		<!--- <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Table: <strong><font color="#000033">
		<cfoutput>#ListGetAt(lTableList, j)# (#j#)</cfoutput>
        </font></strong> ... removed successfully!</font><br /> --->
		 <cfcatch type="database">
                    <cfoutput>#cfcatch.Message# -  #cfcatch.Detail#    </cfoutput>
			  <!--- System table most probably - cannot be deleted --->
	    </cfcatch>
		</cftry>
	  </cfloop>
	 
 
  

</body>
</html>
