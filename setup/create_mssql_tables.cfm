<!--- Enterprise Version --->

<cfparam name="form.DSN" default="Mail-List">

<!--- 

Create all tables required for Email List Manager 2.5 in MSSQL
** You must have a DSN already established named "Mail-List" OR pass appropriate name of DSN in form preceeding this page **

 --->
<cftry>

  <cfquery name="createTableSchema" datasource="#form.DSN#">
  CREATE TABLE admin (
		AdminID int  
		IDENTITY(1,1)
      	PRIMARY KEY CLUSTERED,
		AdminLevelID int NOT NULL,
		AdminName varchar (50) NOT NULL,
		AdminPwd varchar (50) NOT NULL,
		AdminEmail varchar (75) NULL 
	)
  </cfquery>
  <cfquery name="UpdateDefaultData" datasource="#form.DSN#">
  INSERT INTO admin (AdminLevelID, AdminName, AdminPwd)
  VALUES (1, <cfif Len(form.adminUsername) gt 0>'#form.adminUsername#'<cfelse>'admin'</cfif>, <cfif Len(form.adminPwd) gt 0>'#form.adminPwd#'<cfelse>'admin'</cfif>)
  </cfquery>
  <span class="subscribeSuccess">Table: admin ... created successfully!</span><br />
  <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: Admin</span><br />
	  <cfdump var="#cfcatch#">
	  <cfset setupErr = 1>
  </cfcatch>
  
</cftry>

<cftry>
	<cfquery name="createTableSchema" datasource="#form.DSN#">
	CREATE TABLE admin_access_levels (
		AccessID int NOT NULL
		PRIMARY KEY CLUSTERED,
		AccessLevelDesc varchar (50) NOT NULL,
		MaxNumberOfLists int DEFAULT 0 NULL,
		MaxNumberOfAdminUsers int DEFAULT 0 NULL  
	)
	</cfquery>
	<cfquery name="UpdateDefaultData" datasource="#form.DSN#">
	  INSERT INTO admin_access_levels (AccessID, AccessLevelDesc)
	  VALUES (1, 'Administrator')
	</cfquery>
 <span class="subscribeSuccess">Table: admin_access_levels ... created successfully!</span><br />
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: admin_access_levels</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: attachments</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: auto_responder_attachments</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
	
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: auto_responder_messages</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: auto_responder_schedule</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
	  <span class="subscribeFail">! Error creating table: bounce_exceptions</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: bounce_log</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: broadcast_success_log</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: chart_types</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: click_thru_stats</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: click_thru_stats_detail</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
	  <span class="subscribeFail">! Error creating table: database_types</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_addresses</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>

</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_addresses_removed</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_messages</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_groups</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_groups_members</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_groups_tempholder</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
  
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_lst_messages_personalize</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>

</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_messages_schedule</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>

</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_list_messages_send_log</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>

</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: email_lists</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>

</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: font_faces</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>

</cftry>

<cftry>

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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: globals</span><br>
	  Error Message: <cfoutput>#cfcatch.detail#</cfoutput>
	  <br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>
</cftry>

<cftry>
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
 <cfcatch type="any">
	  <span class="subscribeFail">! Error creating table: send_log_id</span><br />
	  <cfset setupErr = 1>
	  <cfdump var="#cfcatch#">
  </cfcatch>

</cftry>

<cfif IsDefined("setupErr") AND setupErr eq 1>
	<br />
	<br />
	There was error/s in creating the Microsoft SQL Server tables, you must correct this before proceeding!
<cfelse>
	<br />
	<br />
	<strong><span class="bodyText">If all tables were created successfully above <a href="../admin/index.cfm">click
	here to proceed</a> to administrator
	login
	</span></strong>
</cfif>
