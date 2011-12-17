
<cfquery datasource="#DSN#" name="findClickThruID">
	SELECT *
	FROM click_thru_stats
	WHERE MessageID = #MID#
		AND clickThruID = #ID#
</cfquery>

<cfif findClickThruID.RecordCount gte 1>
	<cfset clickCount = #findClickThruID.clickThruCount# + 1>
	<cfquery name="updateStats" datasource="#DSN#">
	UPDATE click_thru_stats
	SET clickThruCount = #clickCount#
	WHERE clickThruID = #findClickThruID.clickThruID#
	</cfquery>
	
<cfelse>
	<cfset clickCount = 1>
	<cfquery datasource="#DSN#" name="insertStats">
	INSERT INTO click_thru_stats(MessageListID, MessageID, clickThruID, clickTruOriginalURL, clickThruCount)
	VALUES (#ListID#, #MID#, #ID#, '#LINK#', #clickCount#)
	</cfquery>
</cfif>

<cfif IsDefined("EID") AND Len(EID) neq 0>
	<cfquery datasource="#DSN#" name="findClickThruEmailID">
	SELECT *
	FROM click_thru_stats_detail
	WHERE ClickThruSubscriberID = #EID#
		AND ClickThruID = #ID#
	</cfquery>
	
	<cfif findClickThruEmailID.RecordCount gte 1>
	<cfset clickCountEmail = #findClickThruEmailID.ClickCount# + 1>
	<cfquery name="updateDetailStats" datasource="#DSN#">
	UPDATE click_thru_stats_detail
	SET ClickCount = #clickCountEmail#
	WHERE recID = #findClickThruEmailID.recID#
	</cfquery>
	
	<cfelse>
		<cfset clickCountEmail = 1>
		<cfquery datasource="#DSN#" name="insertDetailStats">
		INSERT INTO click_thru_stats_detail(ClickThruID, ClickThruSubscriberID, ClickCount)
		VALUES (#ID#, #EID#, #clickCountEmail#)
		</cfquery>
	</cfif>
	
</cfif>

<cfoutput query="findClickThruID" maxrows="1">
 <!--- <cfset clickTruOriginalURLConvert = #URLDecode(clickTruOriginalURL)#> --->
 <cfset clickTruOriginalURLConvert = ReplaceNoCase(clickTruOriginalURL, "&amp;", "&", "ALL")>
 <cflocation url="#clickTruOriginalURLConvert#" addtoken="no">
</cfoutput>


