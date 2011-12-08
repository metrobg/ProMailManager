<cfscript>
	StructDelete(session, "AccessLevelID");
	StructDelete(session, "AccessLevelDesc");
	StructDelete(session, "UserName");
</cfscript>

<cflocation url="index.cfm" addtoken="no">
