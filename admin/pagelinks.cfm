<!--- 
    File name:  pagelinks.cfm
  Description:  Displays NextN links
   Created by:  Paul Kocar (pkocar@yahoo.com)
      Created:  November, 2003
Last Modified:  N/A
        Usage:  <cf_pagelinks
                  displaypreviousnext="yes"
                  displaypagelinks="yes"
				  displaypageinput="no">
--->

<!--- These attributes are required --->
<cfparam name="ATTRIBUTES.DisplayPreviousNext" type="boolean">
<cfparam name="ATTRIBUTES.DisplayPageLinks" type="boolean">
<cfparam name="ATTRIBUTES.DisplayPageInput" type="boolean">
<cfparam name="ATTRIBUTES.QueryString" default="" type="string">

<cfoutput>
<!--- Display page link section --->
<!--- If DisplayPageLinks attribute is yes, display page links --->
<cfif ATTRIBUTES.DisplayPageLinks EQ "Yes">
<span class="nextn_pagelinks">

<!--- Display the first page link only if CurrentPage is greater than 1 --->
<cfif REQUEST.CurrentPage GT 1>
<a href="#cgi.script_name#?PageNum=1&#ATTRIBUTES.QueryString#">&lt;&lt;</a> 
<cfelse>
&lt;&lt;
</cfif>
 
<!--- Display page links by looping from StartPage to EndPage --->
<cfloop from="#REQUEST.StartPage#" to="#REQUEST.EndPage#" index="ThisPage">
<!--- If this is the current page display as text, --->
<!--- otherwise, display as a link --->
<cfif REQUEST.CurrentPage EQ ThisPage>
<strong>#ThisPage#</strong>
<cfelse>
<a href="#cgi.script_name#?PageNum=#ThisPage#&#ATTRIBUTES.QueryString#">#ThisPage#</a>
</cfif>
</cfloop>

<!--- Display the last page link only if CurrentPage is less than TotalPages --->
<cfif REQUEST.CurrentPage LT REQUEST.Totalpages>
<a href="#cgi.script_name#?PageNum=#REQUEST.TotalPages#&#ATTRIBUTES.QueryString#">&gt;&gt;</a> 
<cfelse>
&gt;&gt;
</cfif>
</span>

</cfif>

<!--- If DisplayPageInput attribute is yes, display page input form --->
<cfif ATTRIBUTES.DisplayPageInput EQ "YES">
<form class="nextn_form" action="#cgi.script_name#" method="get">
Page <input class="nextn_input" type="text" name="PageNum" value="#REQUEST.CurrentPage#" size="3" /> of #REQUEST.TotalPages#.
</form>
</cfif>

<!--- If DisplayPreviousNext attribute is yes, display previous/next --->
<cfif ATTRIBUTES.DisplayPreviousNext EQ "Yes">
<span class="nextn_prevnext">

<!--- Display the previous page link only if CurrentPage is greater than 1 --->
<cfif REQUEST.CurrentPage GT 1>
<a href="#cgi.script_name#?PageNum=#REQUEST.PreviousPage#&#ATTRIBUTES.QueryString#">Prev</a> 
<cfelseif ATTRIBUTES.DisplayPreviousNext EQ "Yes">
Prev
</cfif>
 | 
<!--- Display the next page link only if CurrentPage is less than TotalPages --->
<cfif REQUEST.CurrentPage LT REQUEST.Totalpages>
<a href="#cgi.script_name#?PageNum=#REQUEST.NextPage#&#ATTRIBUTES.QueryString#">Next</a>
<cfelseif ATTRIBUTES.DisplayPreviousNext EQ "Yes">
Next
</cfif>

</span>
</cfif>
</cfoutput>