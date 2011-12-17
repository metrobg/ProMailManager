<cfparam name="MaxRows" default="500">
<cfparam name="StartRow" default="1">

<cfsetting requesttimeout="40">

<cfquery datasource="#DSN#" name="getList">
  select id,email from tmp_email order by email
</cfquery>
 
 <table cellpadding="1" cellspacing="1" align="center">
    <tr>
        <td bgcolor="f0f0f0">&nbsp;
            
        </td>
        <td bgcolor="f0f0f0">
            <b><i>ID</i></b>
        </td>
        <td bgcolor="f0f0f0">
            <b><i>Email Address</i></b>
        </td>
         <td bgcolor="f0f0f0">
            <b><i>Status</i></b>
        </td>
        
    </tr>
 <cfoutput query="getList" startrow="#StartRow#" maxrows="#MaxRows#">
 
    <cfhttp url="http://www.heritagemfg.com/subscribeResponse.cfm" method="post" charset="utf-8" result="acc">
        <cfhttpparam name="request" value="suba" type="formfield">
        <cfhttpparam name="listID" value="132" type="formfield">
        
        <cfhttpparam name="FirstName" value="" type="formfield">
        <cfhttpparam name="LastName" value="" type="formfield">
        <cfhttpparam name="city" value="" type="formfield">
        <cfhttpparam name="state" value="" type="formfield">
        <cfhttpparam name="zip" value="" type="formfield">
        <cfhttpparam name="country" value="" type="formfield">
        
        <cfhttpparam name="SubscribeSubmit" value="Submit" type="formfield">
        <cfhttpparam name="EmailAddress" value="#getList.email#" type="formfield">
    </cfhttp> 
 <!--- <cfdump var="#acc.FileContent#"/>   --->
 
 <tr>
        <td valign="top" bgcolor="ffffed">
            <b>#Getlist.CurrentRow#</b>
        </td>
        <td valign="top">
            <font size="-1">#id#</font>
        </td>
        <td valign="top">
            <font size="-1">#email#</font>
        </td>
        <td valign="top">
            <font size="-1">#acc.fileContent#</font>
        </td>
    </tr>
</cfoutput>
<!--- If the total number of records is less than or equal to the total number of rows, 
then offer a link to the same page, with the startrow value incremented by maxrows 
(in the case of this example, incremented by 10). --------->
    <tr>
        <td colspan="4">
        <cfif (StartRow + MaxRows) LTE GetList.RecordCount>
            <cfoutput><a href="#CGI.SCRIPT_NAME#?startrow=#Evaluate(StartRow + MaxRows)#">
            See next #MaxRows# rows</a></cfoutput> 
        </cfif>
        </td>
    </tr>
</table> 
 
 
 
 
 
 
 