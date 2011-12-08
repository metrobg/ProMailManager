<!--- Enterprise Version --->

<cfparam name="form.DSN" default="Mail-List">

<!--- 

Create/Update all tables required for Email List Manager 2.5 in MSSQL
** You must have a DSN already established named "Mail-List" OR pass appropriate name of DSN in form preceeding this page **

 --->

<!--- Check tables present --->
	<cfstoredproc procedure="sp_tables" datasource="#form.DSN#" debug="yes">
		<cfprocresult name = "qAllTables">
	</cfstoredproc>
	<!--- <cfoutput><cfdump var="#qAllTables#"></cfoutput> --->
	<cfset lTableList = valuelist(qAllTables.TABLE_NAME)>
	<cfscript>
		structTables = StructNew();
		structTables.admin_access_levels = 0;
		structTables.attachments = 0;
		structTables.auto_responder_attachments = 0;
		structTables.auto_responder_messages = 0;
		structTables.auto_responder_schedule = 0;
		structTables.Bounce_Exceptions = 0;
		structTables.bounce_log = 0;
		structTables.broadcast_success_log = 0;
		structTables.chart_types = 0;
		structTables.click_thru_stats = 0;
		structTables.Click_Thru_Stats_Detail = 0;
		structTables.database_types = 0;
		structTables.email_addresses = 0;
		structTables.email_addresses_removed = 0;
		structTables.email_list_messages = 0;
		structTables.email_list_groups = 0;
		structTables.email_list_groups_members = 0;
		structTables.email_list_groups_tempholder = 0;
		structTables.email_lst_messages_personalize = 0;
		structTables.email_list_messages_schedule = 0;
		structTables.email_list_messages_send_log = 0;
		structTables.email_lists = 0;
		structTables.email_list_messages_send_log = 0;
		structTables.font_faces = 0;
		structTables.globals = 0;
		structTables.send_log_id = 0;
		
		if ( ListFind(lTableList, "admin_access_levels") ) { structTables.admin_access_levels = 1; }
		if ( ListFind(lTableList, "attachments") ) { structTables.attachments = 1; }
		if ( ListFind(lTableList, "auto_responder_attachments") ) { structTables.auto_responder_attachments = 1; }
		if ( ListFind(lTableList, "auto_responder_messages") ) { structTables.auto_responder_messages = 1; }
		if ( ListFind(lTableList, "auto_responder_schedule") ) { structTables.auto_responder_schedule = 1; }
		if ( ListFind(lTableList, "bounce_exceptions") ) { structTables.bounce_exceptions = 1; }
		if ( ListFind(lTableList, "bounce_log") ) { structTables.bounce_log = 1; }
		if ( ListFind(lTableList, "broadcast_success_log") ) { structTables.broadcast_success_log = 1; }
		if ( ListFind(lTableList, "chart_types") ) { structTables.chart_types = 1; }
		if ( ListFind(lTableList, "click_thru_stats") ) { structTables.click_thru_stats = 1; }
		if ( ListFind(lTableList, "click_thru_stats_detail") ) { structTables.click_thru_stats_detail = 1; }
		if ( ListFind(lTableList, "database_types") ) { structTables.database_types = 1; }
		if ( ListFind(lTableList, "email_addresses") ) { structTables.email_addresses = 1; }
		if ( ListFind(lTableList, "email_addresses_removed") ) { structTables.email_addresses_removed = 1; }
		if ( ListFind(lTableList, "email_list_messages") ) { structTables.email_list_messages = 1; }
		if ( ListFind(lTableList, "email_list_groups") ) { structTables.email_list_groups = 1; }
		if ( ListFind(lTableList, "email_list_groups_members") ) { structTables.email_list_groups_members = 1; }
		if ( ListFind(lTableList, "email_list_groups_tempholder") ) { structTables.email_list_groups_tempholder = 1; }
		if ( ListFind(lTableList, "email_lst_messages_personalize") ) { structTables.email_lst_messages_personalize = 1; }
		if ( ListFind(lTableList, "email_list_messages_schedule") ) { structTables.email_list_messages_schedule = 1; }
		if ( ListFind(lTableList, "email_list_messages_send_log") ) { structTables.email_list_messages_send_log = 1; }
		if ( ListFind(lTableList, "email_lists") ) { structTables.email_lists = 1; }
		if ( ListFind(lTableList, "email_list_messages_send_log") ) { structTables.email_list_messages_send_log = 1; }
		if ( ListFind(lTableList, "font_faces") ) { structTables.font_faces = 1; }
		if ( ListFind(lTableList, "globals") ) { structTables.globals = 1; }
		if ( ListFind(lTableList, "send_log_id") ) { structTables.send_log_id = 1; }
	</cfscript>
	<!--- <cfoutput><cfdump var="#structTables#"></cfoutput> --->
	
<cftry>
	<cfstoredproc procedure="sp_columns" datasource="#form.DSN#">
		<cfprocparam type="in" dbvarname="@table_name" value="admin_access_levels" cfsqltype="cf_sql_varchar">
		<cfprocresult name = "qAALColumns">
	</cfstoredproc>
	<!--- <cfoutput><cfdump var="#qAALColumns#"></cfoutput> --->
	<cfquery name="qColumnCheck" dbtype="query">
		SELECT * FROM qAALColumns
		WHERE COLUMN_NAME = 'MaxNumberOfLists'
	</cfquery>
	<cfif qColumnCheck.RecordCount eq 0>
		<cfquery name="qAlterTable" datasource="#form.DSN#">
			ALTER TABLE admin_access_levels ADD MaxNumberOfLists int DEFAULT 0 NULL
		</cfquery>
	</cfif>
	<cfquery name="qColumnCheck2" dbtype="query">
		SELECT * FROM qAALColumns
		WHERE COLUMN_NAME = 'MaxNumberOfAdminUsers'
	</cfquery>
	<cfif qColumnCheck2.RecordCount eq 0>
		<cfquery name="qAlterTable" datasource="#form.DSN#">
			ALTER TABLE admin_access_levels ADD MaxNumberOfAdminUsers int DEFAULT 0 NULL
		</cfquery>
	</cfif>
 <span class="subscribeSuccess">Table: admin_access_levels ... updated successfully!</span><br />
 <cfcatch type="database">
	  <span class="subscribeFail">! Error updating table: admin_access_levels<br />
	  	Database Error: <cfoutput>#cfcatch.Detail#</cfoutput>
	  </span>
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<!--- no upgrading needed, only add if not present --->
	<cfif structTables.attachments eq 0>	
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE attachments (
			recID int NOT NULL
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			AttachmentFileName varchar (255) NULL ,
			AttachmentDirectory varchar (255) DEFAULT 'Attachments' NULL ,
			AttachmentFileSize int NULL ,
			UploadedByUser varchar (100) NULL ,
			UploadIP varchar (50) NULL ,
			UploadDate datetime DEFAULT getdate() NULL ,
			MessageID int NULL ,
			ListID int NULL 
		);
		</cfquery>
			<span class="subscribeSuccess">Table: attachments ... created successfully!</span><br />
	</cfif>
	
	<cfcatch type="any">
		  <span class="subscribeFail">! Error creating table: attachments<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
		  <cfset setupErr = 1>
	 </cfcatch>
  
</cftry>

<cftry>
	<!--- no upgrading needed, only add if not present --->
	<cfif structTables.auto_responder_attachments eq 0>	
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE auto_responder_attachments (
			recID int NOT NULL
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			AttachmentFileName varchar (255) NULL ,
			AttachmentDirectory varchar (255) DEFAULT 'Attachments' NULL ,
			AttachmentFileSize int NULL ,
			UploadedByUser varchar (100) NULL ,
			UploadIP varchar (50) NULL ,
			UploadDate datetime DEFAULT getdate() NULL ,
			MessageID int NULL ,
			ListID int NULL 
		);
		</cfquery>
	
		<span class="subscribeSuccess">Table: auto_responder_attachments ... created successfully!</span><br />
	</cfif>
		
	<cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: auto_responder_attachments<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
	</cfcatch>
  
</cftry>

<cftry>
		<cfif structTables.auto_responder_messages eq 0>
			<cfquery name="createTableSchema" datasource="#form.DSN#">
			CREATE TABLE auto_responder_messages (
				MessageID int NOT NULL
				IDENTITY(1,1)
    			PRIMARY KEY CLUSTERED,
				MessageTempID int NULL ,
				MessageListID int NOT NULL ,
				MessageName varchar (75) NULL ,
				MessageSubject varchar (75) NULL ,
				MessageTXT text NULL ,
				MessageHTML text NULL ,
				MessageMultiPart bit NULL ,
				ShowEditor bit DEFAULT 1 NULL,
				MessageCreateDate datetime DEFAULT getdate() NULL,
				SubscribeRequest bit NULL ,
				UnsubscribeRequest bit NULL
				);
			</cfquery>	 	
				<span class="subscribeSuccess">Table: auto_responder_messages ... created successfully!</span><br />
		</cfif>
		
	<cfcatch type="any">
		<span class="subscribeFail">! Error creating table: auto_responder_messages<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
		<cfset setupErr = 1>
	</cfcatch>
  
</cftry>

<cftry>
	
	<cfif structTables.auto_responder_schedule eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE auto_responder_schedule (
			recID int NOT NULL
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			MessageStartDate datetime NULL ,
			MessageEndDate datetime NULL ,
			MessageFrequency varchar (50) NULL ,
			AutoRespondMessageID int NULL ,
			SendOnSubscribe bit NULL ,
			SendOnSubscribeListID int NULL ,
			CreationDate datetime DEFAULT getdate() NULL 
		);
		</cfquery>
		<span class="subscribeSuccess">Table: auto_responder_schedule ... created successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: auto_responder_schedule<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span><br>
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.bounce_exceptions eq 0>
	<cfelse>
		<!--- Drop table and create new one --->
		<cfquery name="qDropTable" datasource="#form.DSN#">
			DROP TABLE bounce_exceptions
		</cfquery>
	</cfif>
	<cfquery name="createTableSchema" datasource="#form.DSN#">
	CREATE TABLE bounce_exceptions (
		BounceExcID int NOT NULL
		IDENTITY(1,1)
		PRIMARY KEY CLUSTERED,
		BounceListID int NULL ,
		BounceExcText varchar (100) NULL ,
		BounceExcActive bit NULL ,
		BounceExcCreateDate datetime DEFAULT getdate() NULL
	);
	</cfquery>
 	<span class="subscribeSuccess">Table: bounce_exceptions ... created successfully!</span><br />
	<cfcatch type="any">
		<span class="subscribeFail">! Error creating table: bounce_exceptions<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
		<cfset setupErr = 1>
	 </cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.bounce_log eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE bounce_log (
			recID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			EmailAddressID int NULL ,
			BounceDate datetime DEFAULT getdate() NULL ,
			BounceSubject varchar (255) NULL ,
			BounceBody text NULL 
		);
		</cfquery>
		 <span class="subscribeSuccess">Table: bounce_log ... created successfully!</span><br />
 	
	<cfelse>
		<!--- no updating needed --->
		
	</cfif>
		
	<cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: bounce_log<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  	</cfcatch>
  
</cftry>

<cftry>

	<cfif structTables.broadcast_success_log eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE broadcast_success_log (
			bslID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			SubscriberID int NULL ,
			BroadcastID int NULL ,
			MessageID int NULL ,
			SentDate datetime DEFAULT getdate() NULL
		);
		</cfquery>
		<span class="subscribeSuccess">Table: broadcast_success_log ... created successfully!</span><br />
	<cfelse>
	</cfif>
 	<cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: broadcast_success_log<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  	</cfcatch>
  
</cftry>

<cftry>
  <cfif structTables.chart_types eq 0>
	<cfquery name="createTableSchema" datasource="#form.DSN#">
	CREATE TABLE chart_types (
		chartID int
		PRIMARY KEY CLUSTERED,
		chartType varchar (50) NULL
	);
	</cfquery>
    <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
	  INSERT INTO chart_types (chartID, chartType)
	  VALUES (1, 'Pie')
    </cfquery>
    <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
	  INSERT INTO chart_types (chartID, chartType)
	  VALUES (2, 'Bar')
    </cfquery>
	 <span class="subscribeSuccess">Table: chart_types ... created successfully!</span><br />
   </cfif>
   
 	<cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: chart_types<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  	</cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.click_thru_stats eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE click_thru_stats (
			recID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			MessageListID int DEFAULT 0 NOT NULL ,
			MessageID int  DEFAULT 0 NULL ,
			BroadcastSession int NULL ,
			clickThruID int  DEFAULT 0 NULL ,
			clickTruOriginalURL varchar (255) NULL ,
			clickThruCount int  DEFAULT 0 NULL ,
			addedDate datetime DEFAULT getdate() NULL 
		);
		</cfquery>
	
		<span class="subscribeSuccess">Table: click_thru_stats ... created successfully!</span><br />
	<cfelse>
		<cfstoredproc procedure="sp_columns" datasource="#form.DSN#">
			<cfprocparam type="in" dbvarname="@table_name" value="click_thru_stats" cfsqltype="cf_sql_varchar">
			<cfprocresult name = "qCTSColumns">
		</cfstoredproc>
		<cfif qCTSColumns.RecordCount eq 8>
		<cfelse>
			<cfset lCTSColumns = ValueList(qCTSColumns.COLUMN_NAME)>
			<cfif ListFind(lCTSColumns, "BroadcastSession") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE click_thru_stats ADD BroadcastSession int NULL
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	
	<cfcatch type="any">
		<span class="subscribeFail">! Error creating table: click_thru_stats<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
		<cfset setupErr = 1>
	</cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.chart_types eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE click_thru_stats_detail (
			recID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			ClickThruID int NULL ,
			ClickThruSubscriberID int NULL ,
			DateClicked datetime DEFAULT getdate() NULL ,
			ClickCount int DEFAULT 0 NULL 
		);
		</cfquery>
		
		 <span class="subscribeSuccess">Table: click_thru_stats_detail ... created successfully!</span><br />
 </cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: click_thru_stats_detail<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.database_types eq 0>
	<cfelse>
		<!--- Drop table and recreate to ensure correct --->
		<cfquery name="qDropTable" datasource="#form.DSN#">
			DROP TABLE database_types
		</cfquery>
	</cfif>
	<cfquery name="createTableSchema" datasource="#form.DSN#">
	CREATE TABLE database_types (
		dbID int NOT NULL
		PRIMARY KEY CLUSTERED,
		DatabaseDesc varchar (50) NULL
	);
	</cfquery>
	  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO database_types (dbID, DatabaseDesc)
		  VALUES (1, 'Microsoft Access')
	  </cfquery>
	  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO database_types (dbID, DatabaseDesc)
		  VALUES (2, 'Microsoft SQL Server 7/2000')
	  </cfquery>
	  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO database_types (dbID, DatabaseDesc)
		  VALUES (3, 'MySQL')
	  </cfquery>
	 <span class="subscribeSuccess">Table: database_types ... created successfully!</span><br />
 
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: database_types<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.email_addresses eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_addresses (
			EmailID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			ListID int NOT NULL ,
			EmailAddress varchar (100) NOT NULL ,
			FirstName varchar (75) NULL ,
			LastName varchar (75) NULL ,
			City varchar (75) NULL ,
			State varchar (50) NULL ,
			ZipCode varchar (50) NULL ,
			Country varchar (75) NULL ,
			PhoneNumber varchar (30) NULL ,
			CellNumber varchar (30) NULL ,
			VerificationID varchar (50) NULL ,
			Verified bit DEFAULT 0 NULL ,
			Bounced bit DEFAULT 0 NULL ,
			ExceededMailQuota bit DEFAULT 0 NULL ,
			DateAdded datetime DEFAULT getdate() NULL ,
			DateBounced datetime NULL ,
			Duplicate bit DEFAULT 0 NULL,
			Active bit DEFAULT 1 NULL ,
			IncludeInBroadcast bit DEFAULT 1 NULL,
			Custom1	varchar	(75) NULL,
			Custom2	varchar	(75) NULL,
			Custom3	varchar	(75) NULL,
			Custom4	varchar	(75) NULL,
			Custom5	varchar	(75) NULL
		);
		</cfquery>
 		<span class="subscribeSuccess">Table: email_addresses ... created successfully!</span><br />
	<cfelse>
		<!--- Update table --->
		<cfstoredproc procedure="sp_columns" datasource="#form.DSN#">
			<cfprocparam type="in" dbvarname="@table_name" value="email_addresses" cfsqltype="cf_sql_varchar">
			<cfprocresult name = "qEAColumns">
		</cfstoredproc>
			<cfset lEAColumns = ValueList(qEAColumns.COLUMN_NAME)>
			<cfif ListFind(lEAColumns, "Active") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses ADD Active bit DEFAULT 1 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEAColumns, "IncludeInBroadcast") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses ADD IncludeInBroadcast bit DEFAULT 1 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEAColumns, "Custom1") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses ADD Custom1 varchar (75) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEAColumns, "Custom2") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses ADD Custom2 varchar (75) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEAColumns, "Custom3") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses ADD Custom3 varchar (75) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEAColumns, "Custom4") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses ADD Custom4 varchar (75) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEAColumns, "Custom5") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses ADD Custom5 varchar (75) NULL
				</cfquery>
			</cfif>
		<span class="subscribeSuccess">Table: email_addresses ... updated successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating/updating table: email_addresses<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>

</cftry>

<cftry>
	<cfif structTables.email_addresses_removed eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_addresses_removed (
			EmailID int NOT NULL
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			ListID int NOT NULL ,
			EmailAddress varchar (100) NOT NULL ,
			FirstName varchar (75) NULL ,
			LastName varchar (75) NULL ,
			City varchar (75) NULL ,
			State varchar (50) NULL ,
			ZipCode varchar (50) NULL ,
			Country varchar (75) NULL ,
			PhoneNumber varchar (30) NULL ,
			CellNumber varchar (30) NULL ,
			VerificationID varchar (50) NULL ,
			Verified bit DEFAULT 0 NULL ,
			Bounced bit DEFAULT 0 NULL ,
			ExceededMailQuota bit DEFAULT 0 NULL ,
			DateRemoved datetime DEFAULT getdate() NULL ,
			DateBounced datetime NULL ,
			Duplicate bit DEFAULT 0 NULL,
			Unsubscribed bit DEFAULT 1 NULL,
			Custom1	varchar	(75) NULL,
			Custom2	varchar	(75) NULL,
			Custom3	varchar	(75) NULL,
			Custom4	varchar	(75) NULL,
			Custom5	varchar	(75) NULL
		);
		</cfquery>
	 	<span class="subscribeSuccess">Table: email_addresses_removed ... created successfully!</span><br />
	<cfelse>
		<!--- Update table --->
		<cfstoredproc procedure="sp_columns" datasource="#form.DSN#">
			<cfprocparam type="in" dbvarname="@table_name" value="email_addresses_removed" cfsqltype="cf_sql_varchar">
			<cfprocresult name = "qEARColumns">
		</cfstoredproc>
			<cfset lEARColumns = ValueList(qEARColumns.COLUMN_NAME)>
			<cfif ListFind(lEARColumns, "Custom1") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses_removed ADD Custom1 varchar (75) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEARColumns, "Custom2") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses_removed ADD Custom2 varchar (75) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEARColumns, "Custom3") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses_removed ADD Custom3 varchar (75) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEARColumns, "Custom4") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses_removed ADD Custom4 varchar (75) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lEARColumns, "Custom5") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_addresses_removed ADD Custom5 varchar (75) NULL
				</cfquery>
			</cfif>
		<span class="subscribeSuccess">Table: email_addresses_removed ... updated successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating/updating table: email_addresses_removed</span><br />
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.email_list_messages eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_list_messages (
			MessageID int NOT NULL
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			MessageTempID int NULL ,
			MessageListID int NOT NULL ,
			MessageName varchar (75) NULL ,
			MessageSubject varchar (75) NULL ,
			MessageTXT text NULL ,
			MessageHTML text NULL ,
			MessageMultiPart bit DEFAULT 1 NULL ,
			ShowEditor bit DEFAULT 1 NULL,
			MessageCreateDate datetime DEFAULT getdate() NULL,
			MessageWithRedirects Text NULL
		);
		</cfquery>
		 <span class="subscribeSuccess">Table: email_list_messages ... created successfully!</span><br />
	<cfelse>
		<!--- Update table --->
		<cfstoredproc procedure="sp_columns" datasource="#form.DSN#">
			<cfprocparam type="in" dbvarname="@table_name" value="email_list_messages" cfsqltype="cf_sql_varchar">
			<cfprocresult name = "qELMColumns">
		</cfstoredproc>
			<cfset lELMColumns = ValueList(qELMColumns.COLUMN_NAME)>
			<cfif ListFind(lELMColumns, "ShowEditor") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_list_messages ADD ShowEditor bit DEFAULT 1 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lELMColumns, "MessageWithRedirects") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_list_messages ADD MessageWithRedirects Text NULL
				</cfquery>
			</cfif>
			<span class="subscribeSuccess">Table: email_list_messages ... updated successfully!</span><br />
	</cfif>
  <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_messages<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.email_list_groups eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_list_groups (
			GroupID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			GroupDesc varchar (100) NULL ,
			ListID int NULL ,
			subFilter varchar (80) NULL,
			subSearchTxt varchar (75) NULL,
			GroupCreateDate datetime DEFAULT getdate() NULL 
		);
		</cfquery>
		 <span class="subscribeSuccess">Table: email_list_groups ... created successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_groups</span><br />
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.email_list_groups_members eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_list_groups_members (
			GMID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			GMEmailID int NULL ,
			GMGroupID int NULL 
		);
		</cfquery>
		 <span class="subscribeSuccess">Table: email_list_groups_members ... created successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_groups_members<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.email_list_groups_tempholder eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_list_groups_tempholder (
			recID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			tempGroupID int NULL
		);
		</cfquery>
		 <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			 INSERT INTO email_list_groups_tempholder (tempGroupID)
			 VALUES (1)
		 </cfquery>
		 <span class="subscribeSuccess">Table: email_list_groups_tempholder ... created successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_groups_tempholder<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<cfif structTables.email_lst_messages_personalize eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_lst_messages_personalize (
			recID int NOT NULL
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			personalizeNotation varchar (100) NULL ,
			personalizeDesc varchar (100) NULL ,
			assocVarName varchar (50) NULL 
		);
		</cfquery>
		  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc, assocVarName)
			  VALUES ('[First Name]', 'Subscribers First name', 'FirstName')
		  </cfquery>
		  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc, assocVarName)
			  VALUES ('[Last Name]', 'Subscribers Last name', 'LastName')
		  </cfquery>
		  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc, assocVarName)
			  VALUES ('[Email]', 'Subscribers Email Address', 'EmailAddress')
		  </cfquery>
		  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc)
			  VALUES ('[List]', 'List Name')
		  </cfquery>
		  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc)
			  VALUES ('[Date Med]', 'Medium Date from the Server')
		  </cfquery>
		  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc)
			  VALUES ('[Date Short]', 'Short Date from the Server')
		  </cfquery>
		  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc)
			  VALUES ('[Date Long]', 'Long Date from the Server')
		  </cfquery>
		 <span class="subscribeSuccess">Table: email_lst_messages_personalize ... created successfully!</span><br />
	</cfif>
	
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_lst_messages_personalize<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>

</cftry>

<cftry>
	<cfif structTables.email_list_messages_schedule eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_list_messages_schedule (
			MsgScheduleID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			MSchedStartDate varchar (10) NULL ,
			MSchedStartTime varchar (7) NULL ,
			MSchedEndDate varchar (10) NULL ,
			MSchedEndTime varchar (7) NULL ,
			MSchedInterval varchar (12) NULL ,
			MSchedListID int NULL ,
			MSchedGroupID int NULL ,
			MSchedMessageID int NULL ,
			MSchedActive bit NULL ,
			MSchedCreateDate datetime DEFAULT getdate() NULL 
		);
		</cfquery>
		 <span class="subscribeSuccess">Table: email_list_messages_schedule ... created successfully!</span><br />
	</cfif>
	
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_messages_schedule<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>

</cftry>

<cftry>
	<cfif structTables.email_list_messages_send_log eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_list_messages_send_log (
			recID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			ListID int NULL,
			MessageID int NULL ,
			MessageBroadcastID int NULL ,
			MessagePreSentDate datetime NULL ,
			MessageSentDate datetime NULL 
		);
		</cfquery>
		 <span class="subscribeSuccess">Table: email_list_messages_send_log ... created successfully!</span><br />
	<cfelse>
		<!--- Update table --->
		<cfstoredproc procedure="sp_columns" datasource="#form.DSN#">
			<cfprocparam type="in" dbvarname="@table_name" value="email_list_messages_send_log" cfsqltype="cf_sql_varchar">
			<cfprocresult name = "qELMSLColumns">
		</cfstoredproc>
			<cfset lELMSLColumns = ValueList(qELMSLColumns.COLUMN_NAME)>
			<cfif ListFind(lELMSLColumns, "ListID") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_list_messages_send_log ADD ListID int NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lELMSLColumns, "MessageBroadcastID") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_list_messages_send_log ADD MessageBroadcastID int NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lELMSLColumns, "MessagePreSentDate") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_list_messages_send_log ADD MessagePreSentDate datetime NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lELMSLColumns, "MessageSentDate") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_list_messages_send_log ADD MessageSentDate datetime NULL
				</cfquery>
			</cfif>
			<span class="subscribeSuccess">Table: email_list_messages_send_log ... updated successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_messages_send_log<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>

</cftry>

<cftry>
	<cfif structTables.email_lists eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE email_lists (
			EmailListID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			EmailListDesc varchar (50) NOT NULL ,
			EmailListAdminID int DEFAULT 1 NOT NULL ,
			EmailListWebRoot varchar (250) DEFAULT 'http://localhost/MailList' NULL ,
			EmailListReplyToEmail varchar (100) NULL ,
			EmailListFromEmail varchar (100) NULL ,
			EmailListSMTPServer varchar (100) NULL ,
			EmailListPOPServer varchar (100) NULL ,
			EmailListPOPLogin varchar (75) NULL ,
			EmailListPOPPwd varchar (50) NULL ,
			EmailListGlobalHeader text NULL ,
			EmailListGlobalFooter text NULL ,
			EmailListGlobalHeaderHTML text NULL ,
			EmailListGlobalFooterHTML text NULL ,
			EmailMessageGlobalFontFace varchar (255) DEFAULT 'Verdana, Arial, Helvetica, sans-serif' NULL ,
			EmailMessageGlobalFontSize varchar (50) DEFAULT 1 NULL ,
			EmailMessageGlobalFontColor varchar (50) DEFAULT 'Black' NULL ,
			taskScheduled bit DEFAULT 0 NULL ,
			EmailIDLinkAdded bit DEFAULT 0 NULL ,
			EmailPersonalization bit DEFAULT 0 NULL,
			BatchAmount int DEFAULT 300 NULL
		);
		</cfquery>
		<cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  INSERT INTO email_lists (EmailListDesc, EmailListAdminID, EmailListFromEmail, EmailListSMTPServer,
			  EmailListPOPServer, EmailListPOPLogin, EmailListPOPPwd)
			  VALUES ('Default List (safe to delete after install)', 1, 'test@localhost', '192.168.1.5', '192.168.1.5', 'maillist', '1234')
		  </cfquery>
		 <span class="subscribeSuccess">Table: email_lists ... created successfully!</span><br />
	<cfelse>
		<!--- Update table --->
		<cfstoredproc procedure="sp_columns" datasource="#form.DSN#">
			<cfprocparam type="in" dbvarname="@table_name" value="email_lists" cfsqltype="cf_sql_varchar">
			<cfprocresult name = "qELColumns">
		</cfstoredproc>
			<cfset lELColumns = ValueList(qELColumns.COLUMN_NAME)>
			<cfif ListFind(lELColumns, "EmailListReplyToEmail") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_lists ADD EmailListReplyToEmail varchar (100) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lELColumns, "EmailIDLinkAdded") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_lists ADD EmailIDLinkAdded bit DEFAULT 0 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lELColumns, "EmailPersonalization") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE email_lists ADD EmailPersonalization bit DEFAULT 0 NULL
				</cfquery>
			</cfif>
			<span class="subscribeSuccess">Table: email_lists ... updated successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_lists<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>

</cftry>

<cftry>
	<cfif structTables.font_faces eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE font_faces (
			recID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			FontFace varchar (255) NULL 
		);
		</cfquery>
		<cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO font_faces (FontFace)
		  VALUES ('Verdana, Arial, Helvetica, sans-serif')
		</cfquery>
		<cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO font_faces (FontFace)
		  VALUES ('Arial')
		</cfquery>
		<cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO font_faces (FontFace)
		  VALUES ('Arial, Helvetica, sans-serif')
		</cfquery>
		<cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO font_faces (FontFace)
		  VALUES ('Times New Roman, Times, serif')
		</cfquery>
		<cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO font_faces (FontFace)
		  VALUES ('Georgia, Times New Roman, Times, serif')
		</cfquery>
		<cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO font_faces (FontFace)
		  VALUES ('Geneva, Arial, Helvetica, sans-serif')
		</cfquery>
	 <span class="subscribeSuccess">Table: font_faces ... created successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: font_faces<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>

</cftry>

<cftry>
	<cfif structTables.globals eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE globals (
			recID int
			IDENTITY(1,1)
			PRIMARY KEY CLUSTERED,
			siteServerAddress varchar (255) DEFAULT 'http://www.yourdomain.com/maillist/' NOT NULL ,
			localServerAddress varchar (255) DEFAULT 'http://localhost/maillist/' NOT NULL ,
			siteStyle varchar (50) DEFAULT 'defaultStyle.css' NOT NULL ,
			subscriptionLists_MaxRows int DEFAULT 15 NOT NULL ,
			subscriptionLists_MaxPages int DEFAULT 10 NOT NULL ,
			subscribersList_MaxRows int DEFAULT 15 NOT NULL ,
			subscribersList_MaxPages int DEFAULT 10 NOT NULL ,
			messageLists_MaxRows int DEFAULT 15 NOT NULL ,
			messageLists_MaxPages int DEFAULT 10 NOT NULL ,
			cfmxInstalled bit DEFAULT 0 NOT NULL ,
			exportFilePath varchar (255) DEFAULT 'c:\InetPub\wwwroot\mailList\admin\export' NULL ,
			importFilePath varchar (255) DEFAULT 'c:\InetPub\wwwroot\mailList\admin\import' NULL ,
			cffileEnabled bit DEFAULT 1 NULL,
			useFtp bit DEFAULT 0 NULL,
			ftpServerName varchar (150) NULL ,
			ftpPassiveMode bit DEFAULT 1 NULL ,
			ftpRetry int DEFAULT 1 NULL ,
			ftpTimeout int DEFAULT 30 NULL ,
			ftpUserName varchar (50) NULL ,
			ftpPassword varchar (50) NULL ,
			ftpPathToAdminDir varchar (255) NULL,
			editorPath varchar (255) DEFAULT 'editor/' NULL,
			attachmentsPath varchar (255) DEFAULT 'c:\InetPub\wwwroot\mailList\admin\attachments' NULL,
			enableAutoResponders bit DEFAULT 0 NULL,
			logSuccessfulBroadcasts bit DEFAULT 0 NULL,
			DefaultEditorWidth int DEFAULT 650 NULL ,
			DefaultEditorHeight int DEFAULT 400 NULL ,
			ELMVersion varchar (50) DEFAULT 'Admin Pro Tools Email List Manager 2.5 Enterprise' NULL ,
			CFusionUndelivDir varchar (50) NULL ,
			ChartStyle int DEFAULT 1 NULL,
			PopServerTimeout int DEFAULT 300 NULL,
			PageTimeout int DEFAULT 300 NULL,
			MailerType varchar (50) DEFAULT 'CFMAIL' NULL,
			DateDisplay varchar (50) DEFAULT 'mm-dd-yy' NULL,
			TimeDisplay varchar (50) DEFAULT 'hh:mm' NULL,
			DatabaseType int DEFAULT 1 NULL,
			Custom1Name	varchar	(50) NULL,
			Custom2Name	varchar	(50) NULL,
			Custom3Name	varchar	(50) NULL,
			Custom4Name	varchar	(50) NULL,
			Custom5Name	varchar	(50) NULL 
		);
		</cfquery>
		<cfquery name="UpdateDefaultData" datasource="#form.DSN#">
		  INSERT INTO globals (siteServerAddress, siteStyle, subscriptionLists_MaxRows, subscriptionLists_MaxPages, 
		  subscribersList_MaxRows , subscribersList_MaxPages,
			messageLists_MaxRows , messageLists_MaxPages ,
			cfmxInstalled , exportFilePath ,
			importFilePath,
			cffileEnabled, useFtp,
			ftpPassiveMode,
			ftpRetry , ftpTimeout, DatabaseType)
		  VALUES ('http://localhost/MailList/', 'defaultStyle.css', 15, 10, 15, 10, 15, 10, 0, 'c:\InetPub\wwwroot\mailList\admin\export', 
			'c:\InetPub\wwwroot\mailList\admin\import', 1, 0, 1, 1, 30, #form.DatabaseType#)
		</cfquery>
	
	 <span class="subscribeSuccess">Table: globals... created successfully!</span><br />
 	<cfelse>
 		<!--- Upgrade table --->
		<cfstoredproc procedure="sp_columns" datasource="#form.DSN#">
			<cfprocparam type="in" dbvarname="@table_name" value="globals" cfsqltype="cf_sql_varchar">
			<cfprocresult name = "qGColumns">
		</cfstoredproc>
			<cfset lGColumns = ValueList(qGColumns.COLUMN_NAME)>
			<cfif ListFind(lGColumns, "localServerAddress") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD localServerAddress varchar (255) DEFAULT 'http://localhost/maillist/' NOT NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "cffileEnabled") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD cffileEnabled bit DEFAULT 1 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "useFtp") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD useFtp bit DEFAULT 0 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "ftpServerName") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD ftpServerName varchar (150) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "ftpPassiveMode") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD ftpPassiveMode bit DEFAULT 1 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "ftpRetry") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD ftpRetry int DEFAULT 1 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "ftpTimeout") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD ftpTimeout int DEFAULT 30 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "ftpUserName") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD ftpUserName varchar (50) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "ftpPassword") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD ftpPassword varchar (50) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "ftpPathToAdminDir") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD ftpPathToAdminDir varchar (255) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "editorPath") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD editorPath varchar (255) DEFAULT 'editor/' NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "attachmentsPath") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD attachmentsPath varchar (255) DEFAULT 'c:\InetPub\wwwroot\mailList\admin\attachments' NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "enableAutoResponders") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD enableAutoResponders bit DEFAULT 0 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "logSuccessfulBroadcasts") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD logSuccessfulBroadcasts bit DEFAULT 0 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "DefaultEditorWidth") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD DefaultEditorWidth int DEFAULT 650 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "DefaultEditorHeight") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD DefaultEditorHeight int DEFAULT 400 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "ELMVersion") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD ELMVersion varchar (50) DEFAULT 'Admin Pro Tools Email List Manager 2.5 Enterprise' NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "CFusionUndelivDir") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD CFusionUndelivDir varchar (50) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "ChartStyle") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD ChartStyle int DEFAULT 1 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "PopServerTimeout") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD PopServerTimeout int DEFAULT 300 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "PageTimeout") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD PageTimeout int DEFAULT 300 NULL
				</cfquery>
				<cfquery name="qUpdateTable" datasource="#form.DSN#">
					UPDATE globals
					SET PageTimeout = 300
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "MailerType") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD MailerType varchar (50) DEFAULT 'CFMAIL' NULL
				</cfquery>
				<cfquery name="qUpdateTable" datasource="#form.DSN#">
				UPDATE globals
				SET MailerType = 'CFMAIL'
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "DateDisplay") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD DateDisplay varchar (50) DEFAULT 'mm-dd-yy' NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "TimeDisplay") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD TimeDisplay varchar (50) DEFAULT 'hh:mm' NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "DatabaseType") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD DatabaseType int DEFAULT 1 NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "Custom1Name") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD Custom1Name	varchar	(50) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "Custom2Name") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD Custom2Name	varchar	(50) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "Custom3Name") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD Custom3Name	varchar	(50) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "Custom4Name") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD Custom4Name	varchar	(50) NULL
				</cfquery>
			</cfif>
			<cfif ListFind(lGColumns, "Custom5Name") eq 0>
				<cfquery name="qAlterTable" datasource="#form.DSN#">
					ALTER TABLE globals ADD Custom5Name	varchar	(50) NULL
				</cfquery>
			</cfif>
			
			<span class="subscribeSuccess">Table: globals... updated successfully!</span><br />
	</cfif>
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: globals</span><br>
	  Error Message: <cfoutput>#cfcatch.detail#</cfoutput>
	  <br />
	  <cfset setupErr = 1>
  </cfcatch>
</cftry>

<cftry>
	<cfif structTables.send_log_id eq 0>
		<cfquery name="createTableSchema" datasource="#form.DSN#">
		CREATE TABLE send_log_id (
			recID int NOT NULL
			PRIMARY KEY CLUSTERED,
			SendLogID int NULL
		);
		</cfquery>
		 <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
			  INSERT INTO send_log_id (recID,SendLogID)
			  VALUES (1,1)
			</cfquery>
		 <span class="subscribeSuccess">Table: send_log_id ... created successfully!</span><br />
	</cfif>
  <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: send_log_id<br />
		  Database Error: <cfoutput>#cfcatch.Detail#</cfoutput></span>
	  <cfset setupErr = 1>
  </cfcatch>

</cftry>

<cfif IsDefined("setupErr") AND setupErr eq 1>
	<br />
	<br />
	There was error/s in creating/upgrading the Microsoft SQL Server tables, you must correct this before proceeding!
<cfelse>
	<br />
	<br />
	<strong><span class="bodyText">If all tables were created successfully above <a href="../admin/index.cfm">click
	here to proceed</a> to administrator
	login
	</span></strong>
</cfif>
