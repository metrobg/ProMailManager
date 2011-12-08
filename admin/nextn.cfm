<!--- 
    File name:  nextn.cfm
  Description:  Initializes NextN variables required by <cf_pagelinks>
   Created by:  Paul Kocar (pkocar@yahoo.com)
      Created:  November, 2003
Last Modified:  N/A	
        Usage:  <cf_nextn
                  recordcount="#GetEmployees.RecordCount#"
                  resultsperpage="10"
                  pagelinks="9">
--->

<!--- These attributes are required --->
<cfparam name="ATTRIBUTES.RecordCount" type="numeric">
<cfparam name="ATTRIBUTES.ResultsPerPage" type="numeric">
<cfparam name="ATTRIBUTES.PageLinks" type="numeric" default="7">

<!--- Andrew - accept passed page num to keep track of current page --->
<cfif IsDefined("CurrentPageNum")>
	<cfset URL.PageNum = CurrentPageNum>
</cfif>

<!--- If URL.PageNum does not exist, set its value to 1 --->
<cfparam name="URL.PageNum" type="numeric" default="1">

<!--- If page links value is less than 3, set it to 3 --->
<cfif ATTRIBUTES.PageLinks LT 3>
<cfset ATTRIBUTES.PageLinks=3>
</cfif>

<!--- ResultsPerPage: displayed records per page --->
<!--- PageLinks: displayed page links per page --->
<cfset ResultsPerPage=ATTRIBUTES.ResultsPerPage>
<cfset PageLinks=ATTRIBUTES.PageLinks>

<!--- TotalRows: total rows of current query --->
<!--- TotalPages: total pages needed to display all records --->
<cfset TotalRows=ATTRIBUTES.RecordCount>
<cfset TotalPages=ceiling(TotalRows/ResultsPerPage)>

<!--- If URL.PageNum is lower than 1, set CurrentPage number to 1 --->
<!--- If URL.PageNum is higher than TotalPages, set CurrentPage number to TotalPages --->
<!--- Otherwise, set CurrentPage to URL.PageNum --->
<cfif URL.PageNum LT 1>
	<cfset CurrentPage=1>
<cfelseif URL.PageNum GT TotalPages>
	<cfset CurrentPage=TotalPages>
<cfelse>
	<cfset CurrentPage=int(URL.PageNum)>
</cfif>
 
<!--- MidPos: middle position of page links --->
<cfset MidPos=ceiling(PageLinks/2)>

<!--- Set the start page to display in the page links in relation to MidPos --->
<cfif CurrentPage LTE MidPos>
<cfset StartPage=1>
<cfelseif CurrentPage GTE TotalPages-(MidPos-1)>
<cfset StartPage=max(TotalPages-(PageLinks-1),1)>
<cfelse>
<cfset StartPage=CurrentPage-(MidPos-1)>
</cfif>

<!--- Set the last page to display in the page links --->
<cfset EndPage=min(StartPage+(PageLinks-1),TotalPages)>

<!--- Set variables for the previous and next links --->
<cfset PreviousPage=CurrentPage-1>
<cfset NextPage=CurrentPage+1>

<!--- Set variables for the start row and end row  --->
<!--- These variables are used to loop through the query on the calling page --->
<cfset StartRow=(CurrentPage*ResultsPerPage)-(ResultsPerPage-1)> 
<cfset EndRow=min((CurrentPage*ResultsPerPage),TotalRows)>

<!--- Create NextN variables in Request scope --->
<!--- cf_pagelinks custom tag relies on these variables --->
<cfset REQUEST.StartRow=StartRow>
<cfset REQUEST.EndRow=EndRow>
<cfset REQUEST.TotalRows=TotalRows>
<cfset REQUEST.StartPage=Startpage>
<cfset REQUEST.EndPage=EndPage>
<cfset REQUEST.PreviousPage=PreviousPage>
<cfset REQUEST.CurrentPage=CurrentPage>
<cfset REQUEST.NextPage=NextPage>
<cfset REQUEST.TotalPages=TotalPages>