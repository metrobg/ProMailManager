<!-- 
=====================================================================
Mail List Version 2.5

Author:                    Andrew Kelly
Web Address:               http://www.adminprotools.com
Contact Information:       http://www.adminprotools.com/contact
Date Created:              December 12, 2003
Date Last Modified:        December 12, 2003
=====================================================================
 -->
<cfinclude template="globals/validateLogin.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Click Thru Statistics Graph</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/defaultStyle.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#FFFFFF">
<cfquery name="qMessageStats" datasource="#DSN#">
	SELECT clickTruOriginalURL, SUM(clickThruCount) AS clickTotalCount
	FROM click_thru_stats
	WHERE MessageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mid#">
		AND BroadcastSession = <cfqueryparam cfsqltype="cf_sql_integer" value="#sessid#">
		AND clickThruCount > 0
	GROUP BY clickTruOriginalURL
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="1" bgcolor="#000000">
  <tr>
    <td>
      <table width="100%" border="0" cellpadding="8" cellspacing="0">
        <tr>
          <td class="tdHeader"><font color="#CCCCCC">Message Link Click Thru
              Report</font></td>
        </tr>
        <tr>
          <td align="center" bgcolor="#FFFFFF" class="bodyText"><a href="javascript: window.close();">Close Window</a></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF" class="bodyText" align="center">
		  <cfif IsDefined("Server.ColdFusion.ProductVersion") AND ListGetAt(Server.ColdFusion.ProductVersion, 1) gte 6>
		  <!--- Coldfusion MX --->
			<cfquery name="qChartType" datasource="#DSN#">
			SELECT * FROM chart_types C LEFT JOIN globals G ON (C.chartID = G.ChartStyle)
			WHERE C.chartID = <cfqueryparam cfsqltype="cf_sql_integer" value="#globals.ChartStyle#">
			</cfquery>
				<cfif qChartType.RecordCount eq 1>
				<cfchart
					  xaxistitle="Click Through Link"
					  yaxistitle="Click Through Count"
					  font="Arial"
					  showborder="No"
					  show3d="No" chartheight="650" chartwidth="500" format="flash">

					   <cfchartseries 
						  type="#qChartType.chartType#"
						  query="qMessageStats" 
						  valuecolumn="clickTotalCount" 
						  itemcolumn="clickTruOriginalURL" seriescolor="##000080" paintstyle="shade"/>
						  
				</cfchart>
				<cfelse>
				Database Error retrieving Chart Type
				</cfif>

			<cfelseif IsDefined("Server.ColdFusion.ProductVersion") AND ListGetAt(Server.ColdFusion.ProductVersion, 1) eq 5>
			<!--- Coldfusion 5 --->
				<cfgraph type="pie"
					query="qMessageStats" 
					valuecolumn="clickTotalCount" 
					itemcolumn="clickTruOriginalURL">
				</cfgraph>
				
			<cfelse>
				<!--- no graph capability --->
			</cfif>
		  </table>
		  </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</body>
</html>
