<cfparam name="attributes.seconds" default="2">
<cfobject name="obj" action="create" type="java" class="java.lang.Thread">

<cfset obj.sleep(#evaluate(attributes.seconds*1000)#)>
