<cfset vHTMLMessageExtra = ReplaceNoCase(vHTMLMessage,  "[First Name]",  #subscriberList.FirstName# ,  "All")>
<cfset vHTMLMessageExtra2 = ReplaceNoCase(vHTMLMessageExtra,  "[Last Name]",  #subscriberList.LastName# ,  "All")>
<cfset vHTMLMessageExtra3 = ReplaceNoCase(vHTMLMessageExtra2,  "[Email]",  #subscriberList.EmailAddress# ,  "All")>
<cfset vHTMLMessageExtra4 = ReplaceNoCase(vHTMLMessageExtra3,  "[List]",  #mailServerInfo.EmailListDesc# ,  "All")>
<cfset vHTMLMessageExtra5 = ReplaceNoCase(vHTMLMessageExtra4,  "[Date Long]",  #DateFormat(#Now()#, "ddd, mmmm dd, yyyy")# ,  "All")>
<cfset vHTMLMessageExtra6 = ReplaceNoCase(vHTMLMessageExtra5,  "[Date Med]",  #DateFormat(#Now()#, "d-mmm-yyyy")# ,  "All")>
<cfset vHTMLMessageExtra7 = ReplaceNoCase(vHTMLMessageExtra6,  "[Date Short]",  #DateFormat(#Now()#, "m-d-y")# ,  "All")>
<cfset vHTMLMessageExtra8 = ReplaceNoCase(vHTMLMessageExtra7,  "[Custom1]",  #subscriberList.Custom1# ,  "All")>
<cfset vHTMLMessageExtra9 = ReplaceNoCase(vHTMLMessageExtra8,  "[Custom2]",  #subscriberList.Custom2# ,  "All")>
<cfset vHTMLMessageExtra10 = ReplaceNoCase(vHTMLMessageExtra9,  "[Custom3]",  #subscriberList.Custom3# ,  "All")>
<cfset vHTMLMessageExtra11 = ReplaceNoCase(vHTMLMessageExtra10,  "[Custom4]",  #subscriberList.Custom4# ,  "All")>
<cfset vHTMLMessageExtra12 = ReplaceNoCase(vHTMLMessageExtra11,  "[Custom5]",  #subscriberList.Custom5# ,  "All")>
<cfset vHTMLMessageExtraFinal = vHTMLMessageExtra12>
