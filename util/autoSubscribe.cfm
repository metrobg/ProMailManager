
<cfsetting requesttimeout="40" enablecfoutputonly="yes" showdebugoutput="no">
<cfparam name="email" default="noemail@metrobg.com" type="email" max="100">
<cfparam name="action" default="suba" type="string" max="4">
<cfparam name="listID" default="0" type="numeric" max="99999">
 
  
    <cfhttp url="http://www.heritagemfg.com/util/subscribeResponse.cfm" method="post" charset="utf-8" result="acc">
        <cfhttpparam name="request" value="#url.action#" type="formfield">
        <cfhttpparam name="listID" value="#url.listID#" type="formfield">
        
        <cfhttpparam name="FirstName" value="" type="formfield">
        <cfhttpparam name="LastName" value="" type="formfield">
        <cfhttpparam name="city" value="" type="formfield">
        <cfhttpparam name="state" value="" type="formfield">
        <cfhttpparam name="zip" value="" type="formfield">
        <cfhttpparam name="country" value="" type="formfield">
        
        <cfhttpparam name="SubscribeSubmit" value="Submit" type="formfield">
        <cfhttpparam name="EmailAddress" value="#url.email#" type="formfield">
    </cfhttp> 
 <!--- <cfdump var="#acc.FileContent#"/>   --->
  <cfoutput> #acc.FileContent#</cfoutput>
 
 
 
 
 
 
 
 