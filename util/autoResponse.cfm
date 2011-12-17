<cfsetting showdebugoutput="no" enablecfoutputonly="yes">

<cfif IsDefined("form.request") AND IsDefined("form.SubscribeSubmit")>

<cf_subscribeengine
        vemailaddress=#form.EmailAddress#
        vemaillist=#form.listID#
        firstname=#firstname#
        lastname=#lastname#
        city=#City#
        state=#State#
        zipcode=#zip#
        country=#Country#
    dsn = "#DSN#"
        act=#form.request#
        >

                        <cfif IsDefined("vErrorResult")>
                                <cfoutput>There was an error, your request was not completed</cfoutput>
                         <cfswitch expression="#vErrorResult#">
                                <cfcase value="err2">
                                <cfoutput>Reason: Your must supply a valid subscription list id</cfoutput>
                                </cfcase>
                                <cfcase value="err3">
                                <cfoutput>Reason: Your must supply a valid subscription list id, list id that was passed was not found to be active</cfoutput>
                                </cfcase>
                                <cfcase value="err4">
                                <cfoutput>Reason: Your E-mail does not contain enough characters to be valid</cfoutput>
                                </cfcase>
                                <cfcase value="err5">
                                <cfoutput>Reason: Your E-mail was not valid</cfoutput>
                                </cfcase>
                         </cfswitch>
                        </cfif>
                        <cfif IsDefined("response")>
                         <cfswitch expression="#response#">
                                <cfcase value="addedSuccess">
                                <cfoutput>Your E-mail has been successfully added to our list</cfoutput>
                                </cfcase>
                                <cfcase value="existsNotAdded">
                                <cfoutput>Your E-mail is already subscribed to our list, it was not added again</cfoutput>
                                </cfcase>
                                <cfcase value="removeSuccess">
                                <cfoutput>Your E-mail has been successfully removed from our list</cfoutput>
                                </cfcase>
                                <cfcase value="removeFail">
                                <cfoutput>Your E-mail was not found in our list</cfoutput>
                                </cfcase>
                         </cfswitch>
                        </cfif>

</cfif>
