<cfsetting enablecfoutputonly="yes">
<CFPARAM NAME="attributes.showpage" DEFAULT="yes">
<CFPARAM NAME="attributes.showpagemenu" DEFAULT="yes">
<CFPARAM NAME="attributes.part" DEFAULT="0">
<CFPARAM NAME="attributes.mymaxrows" DEFAULT="10">
<CFPARAM NAME="attributes.CFMX" DEFAULT="0">
<CFPARAM NAME="attributes.group" DEFAULT="">
<CFPARAM NAME="caller.RCResults" DEFAULT="0">
<CFPARAM NAME="caller.pagecount" DEFAULT="0">
<CFPARAM NAME="caller.realnextstart" DEFAULT="0">
<CFPARAM NAME="caller.realprevstart" DEFAULT="0">
<CFPARAM NAME="caller.nextstart" DEFAULT="0">
<CFPARAM NAME="caller.prevstart" DEFAULT="0">
<CFPARAM NAME="caller.thispage" DEFAULT="1">
<CFPARAM NAME="attributes.imagepath" DEFAULT="">

<cfswitch expression="#attributes.part#">
<cfcase value = "recordcount">
<CFIF isDefined('form.ParseStartRow')>
<cfset caller.RealStartRow = listgetat(form.ParseStartRow, 1)>
<cfset attributes.MyStartRow = listgetat(form.ParseStartRow, 2)>
<cfelse>
<cfset caller.RealStartRow = attributes.RealStartRow>
</CFIF>

<cfset request.mymaxrows = attributes.mymaxrows>

<CFPARAM NAME="attributes.RCItem" DEFAULT="Record">
<cfset caller.RCItem = attributes.RCItem>

<CFIF request.RCQuery.recordcount IS 0><cfset caller.noresults = 1>
<cfelse><cfset caller.RCResults = 0><cfset caller.arrayrow = 0><cfset caller.arraycount = 0><cfset request.startarray = arraynew(2)>
<cfswitch expression="#listlen(attributes.group)#">
<cfcase value = "0">
<cfset request.startarray[1][1] = 1>
<CFOUTPUT query="request.RCQuery"><cfset caller.RCResults = caller.RCResults + 1>
<CFIF (caller.RCResults - 1) MOD attributes.myMaxRows IS 0 and caller.RCResults - 1 GTE attributes.myMaxRows><cfset request.startarray[arraylen(request.startarray) + 1][1] = currentrow></CFIF>
</CFOUTPUT>
</cfcase>
<cfcase value = "1">
<cfset request.startarray[1][1] = 1>
<CFOUTPUT query="request.RCQuery" group="#attributes.Group#"><cfset caller.RCResults = caller.RCResults + 1>
<CFIF (caller.RCResults - 1) MOD attributes.myMaxRows IS 0 and caller.RCResults - 1 GTE attributes.myMaxRows><cfset request.startarray[arraylen(request.startarray) + 1][1] = currentrow></CFIF>
</CFOUTPUT>
</cfcase>
</cfswitch>

<cfset caller.pagecount = Ceiling(caller.RCResults / attributes.mymaxrows)>
<CFIF caller.pagecount GTE "2"><cfset caller.pagenum = "0">
<cfset caller.thispage = int((attributes.mystartrow + attributes.mymaxrows - 1) / attributes.mymaxrows)>
</cfif>

<cfset caller.thisrow = attributes.mystartrow - 1><cfset caller.realrows = 0>
<CFPARAM NAME="caller.realPrevStart" DEFAULT="0">

<CFIF caller.thispage GT 1><cfset caller.realPrevStart = request.startarray[caller.thispage - 1][1]></CFIF>
<CFIF caller.thispage LT caller.pagecount><cfset caller.realNextStart = request.startarray[caller.thispage + 1][1]></CFIF>

<cfswitch expression="#attributes.CFMX#">
<cfcase value = "0">
<cfset caller.mymaxrows = attributes.mymaxrows>
</cfcase>
<cfcase value = "1">
<CFIF caller.realnextstart IS 0>
	<CFIF caller.thispage LT caller.pagecount>
	<cfset caller.mymaxrows = caller.realNextStart - caller.realstartrow>
	<CFELSE>
	<cfset caller.mymaxrows = request.RCQuery.recordcount + 1 - caller.realstartrow>
	</CFIF>
<CFELSE>
<cfset caller.mymaxrows = caller.realNextStart - caller.realstartrow>
</CFIF>
</cfcase>
</cfswitch>

<cfset caller.PrevStart = ((caller.thispage * attributes.mymaxrows) + 1) - (attributes.mymaxrows * 2)>
<cfset caller.NextStart = (caller.thispage * attributes.mymaxrows) + 1>

</CFIF><CFOUTPUT>
<!--- Start font or style class here --->
#caller.RCResults# #attributes.RCItem#<CFIF caller.RCResults NEQ 1>s</CFIF> Found
<!--- End font or style class here --->
<CFIF caller.pagecount gte 2>
<!--- Start font or style class here --->
Displaying Page #caller.thispage# - <CFIF attributes.mystartrow IS caller.RCResults>Record #attributes.mystartrow#<cfelse>Records
#attributes.mystartrow# to
<CFIF attributes.mystartrow + request.mymaxrows GT caller.RCResults>#caller.RCResults#<cfelse>#evaluate(attributes.mystartrow + request.mymaxrows - 1)#</CFIF></CFIF>
<!--- End font or style class here --->
</CFIF></CFOUTPUT>
</cfcase>

<cfcase value = "link">
<CFPARAM NAME="attributes.MyMaxPages" DEFAULT="25">
<CFIF attributes.pagecount GTE "2">
<CFPARAM NAME="qstring" DEFAULT="">
<CFIF cgi.query_string IS NOT "">
<cfloop index="qvariable" list="#cgi.query_string#" delimiters="&">
<cfswitch expression="#listgetat(qvariable, 1, "=")#">
<cfcase value = "mystartrow,realstartrow"></cfcase>
<cfdefaultcase>
	<cfset qstring = qstring & "&" & qvariable>
</cfdefaultcase>
</cfswitch>
</cfloop>
</CFIF>
<CFIF isDefined('form.fieldnames')>
<cfloop index="qvariable" list="#form.fieldnames#">
<cfswitch expression="#qvariable#">
<cfcase value = "mystartrow,realstartrow"></cfcase>
<cfdefaultcase>
	<!--- Added to ignore button parameters --->
	<cfif qvariable eq "mystartrow" OR qvariable eq "realstartrow"
	 OR qvariable eq "lid" OR qvariable eq "list" OR qvariable eq "bEmailSearch"
	 OR qvariable eq "email">
	 <cfset qstring = qstring & "&" & lcase(qvariable) & "=" & URLEncodedFormat(evaluate(qvariable))>
	</cfif>
</cfdefaultcase>
</cfswitch>
</cfloop>
</CFIF>
<CFPARAM NAME="pagefrom" DEFAULT="1">
<CFPARAM NAME="pageto" DEFAULT="#attributes.pagecount#">
<CFIF attributes.pagecount GT attributes.MyMaxPages>
	<cfloop index="FindPrevPage" from="#evaluate(attributes.MyMaxPages + 1)#" to="#attributes.pagecount#" step="#attributes.MyMaxPages#">
	<CFIF attributes.thispage GTE FindPrevPage and attributes.thispage LT FindPrevPage + attributes.MyMaxPages><cfset pagefrom = FindPrevPage><cfset newMyPrevStartRow = ((FindPrevPage - 1) * request.mymaxrows) - request.mymaxrows + 1><cfset NewPrevPage = request.startarray[FindPrevPage - 1][1]><cfbreak></CFIF>
	</cfloop>
	<cfloop index="FindNextPage" from="1" to="#evaluate(attributes.pagecount - attributes.MyMaxPages)#" step="#attributes.MyMaxPages#">
	<CFIF attributes.thispage GTE FindNextPage and attributes.thispage LT FindNextPage + attributes.MyMaxPages><cfset newMyNextStartRow = ((FindNextPage + attributes.MyMaxPages) * request.mymaxrows) - request.mymaxrows + 1><cfset NewNextPage = request.startarray[FindNextPage + attributes.mymaxpages][1]><cfbreak></CFIF>
	</cfloop>
</CFIF>
<CFIF pagefrom + attributes.MyMaxPages GT attributes.pagecount><cfset pageto = attributes.pagecount><cfelse><cfset pageto = pagefrom + attributes.MyMaxPages - 1></CFIF>
<cfoutput>
<CFIF attributes.showpage IS "yes">Page #attributes.thispage# of #attributes.pagecount#</CFIF>
 <CFIF isDefined('NewPrevPage')><a href="#attributes.template#?mystartrow=#newMyPrevStartRow#&realstartrow=#NewPrevPage##qstring#"><<</a>
<cfelse>&nbsp;</CFIF>&nbsp;
<CFIF attributes.realprevstart GTE "1">
<a href="#attributes.template#?mystartrow=#attributes.prevstart#&realstartrow=#attributes.realprevstart##qstring#">[prev]</a>&nbsp;
<cfelse>&nbsp;</CFIF>
<CFIF attributes.pagecount GT "2">
<!--- Start font or style class here --->
<cfset pagenum = pagefrom - 1>
<cfloop index = "pagenumber" From="#pagefrom#" To="#pageto#"><cfset pagenum = pagenum + 1>
<cfset newstartrow = (pagenum * request.mymaxrows) - request.mymaxrows + 1>
<CFIF attributes.thispage IS pagenum><font color="Red">#pagenum#</font><cfelse><a href="#attributes.template#?mystartrow=#newstartrow#&realstartrow=#request.startarray[pagenum][1]##qstring#">#pagenum#</a></CFIF></cfloop>
 <!--- End font or style class here --->
</CFIF>
<CFIF attributes.nextstart lte attributes.RCResults>
&nbsp;<a href="#attributes.template#?mystartrow=#attributes.nextstart#&realstartrow=#attributes.realnextstart##qstring#">[Next]</a>
<cfelse>&nbsp;</CFIF>&nbsp;
<CFIF isDefined('NewNextPage')><a href="#attributes.template#?mystartrow=#newMyNextStartRow#&realstartrow=#NewNextPage##qstring#">>></a></a>
<cfelse>&nbsp;</CFIF>
</CFOUTPUT></cfif>

</cfcase>



<cfcase value = "form"><!--- Debug <CFOUTPUT>#attributes.PrevStart#-#attributes.NextStart#<br>#attributes.realPrevStart#-#attributes.realNextStart#</CFOUTPUT><p> --->
<CFPARAM NAME="qstring" DEFAULT="">
<CFPARAM NAME="form.fieldnames" DEFAULT="">
<CFIF cgi.query_string IS NOT ""><cfset qstring = "?" & cgi.query_string></CFIF>
<CFOUTPUT><table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<cfif attributes.PrevStart GTE 1><td>&nbsp;</td>
		<td>
<form action="#attributes.template##qstring#" method="POST">
<input type="Submit" value="&lt;&lt;&lt;&nbsp;&nbsp;Prev">
<cfloop index="field" list="#form.fieldnames#"><CFIF field IS NOT "RealStartRow" and field is not "MyStartRow" and field is not "ParseStartRow"><input type="hidden" name="#field#" value="#evaluate(field)#"></CFIF>
</cfloop><input type="hidden" name="RealStartRow" value="#attributes.realprevstart#"><input type="hidden" name="MyStartRow" value="#attributes.prevstart#">
</form>
		</td></cfif>
		<td>&nbsp;</td>
		<cfif attributes.NextStart LTE attributes.RCResults><td>
<form action="#attributes.template##qstring#" method="POST">
<input type="Submit" value="Next&nbsp;&nbsp;&gt;&gt;&gt;">
<cfloop index="field" list="#form.fieldnames#"><CFIF field IS NOT "RealStartRow" and field is not "MyStartRow" and field is not "ParseStartRow"><input type="hidden" name="#field#" value="#evaluate(field)#"></CFIF>
</cfloop><input type="hidden" name="RealStartRow" value="#attributes.realnextstart#"><input type="hidden" name="MyStartRow" value="#attributes.nextstart#">
</form>		
		</td>
		<td>&nbsp;</td></cfif>
	</tr>
</table></CFOUTPUT>

<CFIF attributes.showpagemenu IS "yes" and attributes.pagecount GT 2>

<cfset pagenum = 0>
<CFOUTPUT><p>
<form action="#attributes.template##qstring#" method="POST">
<input type="Submit" value="Go To Page">
<select name="ParseStartRow">
<cfloop index = "pagenumber" From="1" To="#attributes.pagecount#"><cfset pagenum = pagenum + 1>
<cfset newstartrow = (pagenum * request.mymaxrows) - request.mymaxrows + 1>
<option value="#request.startarray[pagenum][1]#,#newstartrow#"<CFIF pagenum IS attributes.thispage> selected</CFIF>>#pagenum#</cfloop>
</select>
<cfloop index="field" list="#form.fieldnames#"><CFIF field IS NOT "RealStartRow" and field is not "MyStartRow" and field is not "ParseStartRow"><input type="hidden" name="#field#" value="#evaluate(field)#"></CFIF>
</cfloop><input type="hidden" name="RealStartRow" value=""><input type="hidden" name="MyStartRow" value="">
</form>
</CFOUTPUT>
</CFIF>
</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="no">