
 CREATE SEQUENCE  "MAIL_SEQ"  MINVALUE 10 MAXVALUE 999999999 INCREMENT BY 1 START WITH 10 NOCACHE  ORDER  NOCYCLE ;
 CREATE TABLE "ADMIN" 
   (	"ADMINID" NUMBER(5,0), 
		"ADMINLEVELID" NUMBER(5,0), 
		"ADMINNAME" VARCHAR2(50 BYTE), 
		"ADMINPWD" VARCHAR2(50 BYTE), 
		"ADMINEMAIL" VARCHAR2(50 BYTE)
	);
     CREATE UNIQUE INDEX "ADMIN_PK" ON "ADMIN" ("ADMINID");
     ALTER TABLE "ADMIN" ADD CONSTRAINT "ADMIN_PK" PRIMARY KEY ("ADMINID");
      ALTER TABLE "HERITAGE"."ADMIN" MODIFY ("ADMINID" NOT NULL ENABLE);
      ALTER TABLE "HERITAGE"."ADMIN" MODIFY ("ADMINLEVELID" NOT NULL ENABLE);
      ALTER TABLE "HERITAGE"."ADMIN" MODIFY ("ADMINNAME" NOT NULL ENABLE);
      ALTER TABLE "HERITAGE"."ADMIN" MODIFY ("ADMINPWD" NOT NULL ENABLE);
      ALTER TABLE "HERITAGE"."ADMIN" MODIFY ("ADMINEMAIL" NOT NULL ENABLE)    
 
   INSERT INTO admin (adminid,AdminLevelID, AdminName, AdminPwd,AdminEmail)
   VALUES (MAIL_SEQ.nextval,1, 'admin','admin','admin@domain.com');
               
   
 
	CREATE TABLE "ADMIN_ACCESS_LEVELS" 
   (	"ACCESSID" NUMBER(9,0), 
        "ACCESSLEVELDESC" VARCHAR2(50 BYTE), 
        "MAXNUMBEROFLISTS" NUMBER DEFAULT 0, 
        "MAXNUMBEROFADMINUSERS" NUMBER DEFAULT 0
   );
  
        CREATE UNIQUE INDEX "ADMIN_ACCESS_LEVELS_PK" ON "ADMIN_ACCESS_LEVELS" ("ACCESSID");
        ALTER TABLE "ADMIN_ACCESS_LEVELS" ADD CONSTRAINT "ADMIN_ACCESS_LEVELS_PK" PRIMARY KEY ("ACCESSID")
        ALTER TABLE "HERITAGE"."ADMIN_ACCESS_LEVELS" MODIFY ("ACCESSLEVELDESC" NOT NULL ENABLE);   
	 
	  INSERT INTO admin_access_levels (AccessID, AccessLevelDesc)
	  VALUES (1, 'Administrator')
	 
 CREATE TABLE "ATTACHMENTS" 
   (	"RECID" NUMBER(9,0), 
	"ATTACHMENTFILENAME" VARCHAR2(255 BYTE), 
	"ATTACHMENTDIRECTORY" VARCHAR2(255 BYTE), 
	"ATTACHMENTFILESIZE" NUMBER(9,0), 
	"UPLOADEDBYUSER" VARCHAR2(100 BYTE), 
	"UPLOADDATE" DATE, 
	"MESSAGEID" NUMBER(9,0), 
	"LISTID" NUMBER(9,0)
);
 
 CREATE UNIQUE INDEX "ATTACHMENTS_PK" ON "ATTACHMENTS" ("RECID") ;
 ALTER TABLE "ATTACHMENTS" ADD CONSTRAINT "ATTACHMENTS_PK" PRIMARY KEY ("RECID");
 
CREATE TABLE "AUTO_RESPONDER_ATTACHMENTS"
  (
    "RECID"               NUMBER(9,0) NOT NULL ENABLE,
    "AttachmentFileName " VARCHAR2(255 BYTE),
    "ATTACHMENTDIRECTORY" VARCHAR2(255 BYTE),
    "ATTACHMENTFILESIZE"  NUMBER(9,0),
    "UPLOADEDBYUSE"       VARCHAR2(100 BYTE),
    "UPLOADIP"            VARCHAR2(50 BYTE),
    "UPLOADDATE" DATE,
    "MESSAGEID" NUMBER(9,0),
    "LISTID"    NUMBER(9,0)
);
 
ALTER TABLE "AUTO_RESPONDER_ATTACHMENTS" MODIFY ("RECID" NOT NULL ENABLE);
 
 
 CREATE TABLE "AUTO_RESPONDER_MESSAGES" 
   (	"MESSAGEID" NUMBER(9,0), 
	"MESSAGETEMPID" NUMBER(9,0), 
	"MESSAGELISTID" NUMBER(9,0), 
	"MESSAGENAME" VARCHAR2(75 BYTE), 
	"MESSAGESUBJECT" VARCHAR2(75 BYTE), 
	"MESSAGETXT" VARCHAR2(2000 BYTE), 
	"MESSAGEHTML" VARCHAR2(4000 BYTE), 
	"MESSAGEMULTIPART" NUMBER(5,0), 
	"SHOWEDITOR" NUMBER(5,0), 
	"MESSAGECREATEDATE" DATE, 
	"SUBSCRIBEREQUEST" NUMBER(5,0), 
	"UNSUBSCRIBEREQUEST" NUMBER(5,0)
);   
      CREATE UNIQUE INDEX "AUTO_RESPONDER_MESSAGES_PK" ON "HERITAGE"."AUTO_RESPONDER_MESSAGES" ("MESSAGEID") ;
     ALTER TABLE "AUTO_RESPONDER_MESSAGES" ADD CONSTRAINT "AUTO_RESPONDER_MESSAGES_PK" PRIMARY KEY ("MESSAGEID");
     
 
CREATE TABLE "AUTO_RESPONDER_SCHEDULE"
  (
    "RECID" NUMBER(9,0) NOT NULL ENABLE,
    "MESSAGESTARTDATE" DATE,
    "MESSAGEENDDATE" DATE,
    "MESSAGEFREQUENCY"      VARCHAR2(50 BYTE),
    "AUTORESPONDMESSAGEID"  NUMBER(9,0),
    "SENDONSUBSCRIBE"       NUMBER(9,0),
    "SENDONSUBSCRIBELISTID" NUMBER(9,0),
    "CREATIONDATE" DATE
     
  ) 
 
  CREATE UNIQUE INDEX "AUTO_RESPONDER_SCHEDULE_PK" ON "AUTO_RESPONDER_SCHEDULE" ("RECID");
  ALTER TABLE "AUTO_RESPONDER_SCHEDULE" ADD CONSTRAINT "AUTO_RESPONDER_SCHEDULE_PK" PRIMARY KEY ("RECID");
  
  CREATE OR REPLACE TRIGGER "RESPONDER_SCHEDULE_TRIGGER" before
  INSERT ON AUTO_RESPONDER_SCHEDULE FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.recid FROM dual;
END;
/
 
ALTER TRIGGER "RESPONDER_SCHEDULE_TRIGGER" ENABLE;
  
CREATE TABLE bounce_exceptions (
	BounceExcID NUMBER(9) NOT NULL ,	
	BounceListID NUMBER(9) NULL ,
	BounceExcText varchar2 (100 BYTE) NULL ,
	BounceExcActive NUMBER(9) NULL ,
	BounceExcCreateDate DATE NULL
);
 
  CREATE UNIQUE INDEX bounce_exceptions_PK  ON bounce_exceptions (BounceExcID);
  ALTER TABLE bounce_exceptions ADD CONSTRAINT bounce_exceptions_PK  PRIMARY KEY (BounceExcID);
  
CREATE OR REPLACE TRIGGER bounce_exceptions_TRIGGER  before
  INSERT ON bounce_exceptions FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.BounceExcID FROM dual;
END;
/
ALTER TRIGGER bounce_exceptions_TRIGGER ENABLE;
 
 
CREATE TABLE bounce_log (
	recID NUMBER(9) NOT NULL ,
	EmailAddressID NUMBER(9) NULL ,
	BounceDate DATE NULL ,
	BounceSubject varchar2 (255 BYTE) NULL ,
	BounceBody varchar2(4000)  NULL 
);

  CREATE UNIQUE INDEX  bounce_log_PK  ON  bounce_log (recID);
  ALTER TABLE  bounce_log ADD CONSTRAINT  bounce_log_PK  PRIMARY KEY (recID);
  ALTER TABLE  bounce_log MODIFY (recID NOT NULL ENABLE);
  
     
CREATE OR REPLACE TRIGGER  bounce_log_TRIGGER  before
  INSERT ON  bounce_log FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.recID FROM dual;
END;
/
ALTER TRIGGER  bounce_log_TRIGGER ENABLE;
 
CREATE TABLE broadcast_success_log (
	bslID NUMBER(9),
	SubscriberID NUMBER(9) NULL ,
	BroadcastID NUMBER(9) NULL ,
	MessageID NUMBER(9) NULL ,
	SentDate DATE NULL
);

CREATE UNIQUE INDEX  broadcast_success_log_PK  ON  broadcast_success_log (bslid);
ALTER TABLE  broadcast_success_log ADD CONSTRAINT  broadcast_success_log_PK  PRIMARY KEY (bslid);


     
CREATE OR REPLACE TRIGGER  broadcast_success_log_TRIGGER  before
  INSERT ON  broadcast_success_log FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.bsliD FROM dual;
END;
/
ALTER TRIGGER  broadcast_success_log_TRIGGER ENABLE;
  
CREATE TABLE chart_types (
	chartID NUMBER(9) NOT NULL,
     
	chartType varchar2 (50 BYTE) NULL
);

CREATE UNIQUE INDEX  chart_types_PK  ON  chart_types (chartID);
ALTER TABLE chart_types ADD CONSTRAINT  chart_types_PK  PRIMARY KEY (chartID);

 
	  INSERT INTO chart_types (chartID, chartType)
	  VALUES (1, 'Pie');
  
	  INSERT INTO chart_types (chartID, chartType)
	  VALUES (2, 'Bar');
  </cfquery>
 
CREATE TABLE click_thru_stats (
	recID NUMBER(9) NOT NULL,
	MessageListID NUMBER(9) DEFAULT '0' NOT NULL ,
	MessageID NUMBER(9)  DEFAULT '0' NULL ,
	BroadcastSession NUMBER(9) NULL ,
	clickThruID NUMBER(9)  DEFAULT '0' NULL ,
	clickTruOriginalURL varchar (255) NULL ,
	clickThruCount NUMBER(9)  DEFAULT '0' NULL ,
	addedDate DATE NULL 
  )

CREATE UNIQUE INDEX  click_thru_stats_PK  ON  click_thru_stats (recid);
ALTER TABLE  click_thru_stats ADD CONSTRAINT  click_thru_stats_PK  PRIMARY KEY (recid);
     
CREATE OR REPLACE TRIGGER  click_thru_stats_TRIGGER  before
  INSERT ON  click_thru_stats FOR EACH row BEGIN
  SELECT mail_seq.nextval into :new.recID FROM dual;
END;
/
ALTER TRIGGER  click_thru_stats_TRIGGER ENABLE;
 
CREATE TABLE click_thru_stats_detail (
	recID NUMBER(9) NOT NULL,
 
	ClickThruID NUMBER(9) NULL ,
	ClickThruSubscriberID NUMBER(9) NULL ,
	DateClicked DATE NULL ,
	ClickCount NUMBER(9) DEFAULT '0' NULL 
);


CREATE UNIQUE INDEX  click_thru_stats_detail_PK  ON  click_thru_stats_detail (recID);
ALTER TABLE  click_thru_stats_detail ADD CONSTRAINT  click_thru_stats_detail_PK  PRIMARY KEY (recID);


     
CREATE OR REPLACE TRIGGER  click_thru_stats_dtl_TRIGGER  before
  INSERT ON  click_thru_stats_detail FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.recID FROM dual;
END;
/
ALTER TRIGGER  click_thru_stats_dtl_TRIGGER ENABLE;
 
CREATE TABLE database_types (
	dbID NUMBER(9) NOT NULL,
	DatabaseDesc varchar2 (50 BYTE) NULL
);


CREATE UNIQUE INDEX  database_types_PK  ON  database_types (dbID);
ALTER TABLE  database_types ADD CONSTRAINT  database_types_PK  PRIMARY KEY (dbID);
 
	  INSERT INTO database_types (dbID, DatabaseDesc)
	  VALUES (1, 'Microsoft Access');
  
	  INSERT INTO database_types (dbID, DatabaseDesc)
	  VALUES (2, 'Microsoft SQL Server 7/2000');
  
	  INSERT INTO database_types (dbID, DatabaseDesc)
	  VALUES (3, 'MySQL');
  
	  INSERT INTO database_types (dbID, DatabaseDesc)
	  VALUES (4, 'Oracle');
  
 
CREATE TABLE email_addresses (
	EmailID NUMBER(9) ,
	ListID NUMBER(9) NOT NULL ,
	EmailAddress varchar2 (100 BYTE) NOT NULL ,
	FirstName varchar2 (75 BYTE) NULL ,
	LastName varchar2 (75 BYTE) NULL ,
	City varchar2 (75 BYTE) NULL ,
	State varchar2 (50 BYTE) NULL ,
	ZipCode varchar2 (50 BYTE) NULL ,
	Country varchar2 (75 BYTE) NULL ,
	PhoneNumber varchar2 (30 BYTE) NULL ,
	CellNumber varchar2 (30 BYTE) NULL ,
	VerificationID varchar2 (50 BYTE) NULL ,
	Verified NUMBER (1) DEFAULT '0' NULL ,
	Bounced NUMBER (1) DEFAULT '0' NULL ,
	ExceededMailQuota NUMBER (1) DEFAULT '0' NULL ,
	DateAdded DATE NULL ,
	DateBounced DATE NULL ,
	Duplicate NUMBER (1) DEFAULT '0' NULL,
	Active NUMBER (1) DEFAULT '1' NULL ,
	IncludeInBroadcast NUMBER (1) DEFAULT '1' NULL,
	Custom1	varchar2	(75 BYTE) NULL,
	Custom2	varchar2	(75 BYTE) NULL,
	Custom3	varchar2	(75 BYTE) NULL,
	Custom4	varchar2	(75 BYTE) NULL,
	Custom5	varchar2	(75 BYTE) NULL
);

CREATE UNIQUE INDEX  email_addresses_PK  ON  email_addresses (EmailID);
ALTER TABLE  email_addresses ADD CONSTRAINT  email_addresses_PK  PRIMARY KEY (EmailID);


     
CREATE OR REPLACE TRIGGER  email_addresses_TRIGGER  before
  INSERT ON  email_addresses FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.EmailID FROM dual;
END;
/
ALTER TRIGGER  email_addresses_TRIGGER ENABLE;
 
CREATE TABLE email_addresses_removed (
	EmailID NUMBER(8) NOT NULL ,
	 
	ListID int NOT NULL ,
	EmailAddress varchar2 (100 BYTE) NOT NULL ,
	FirstName varchar2 (75 BYTE) NULL ,
	LastName varchar2 (75 BYTE) NULL ,
	City varchar2 (75 BYTE) NULL ,
	State varchar2 (50 BYTE) NULL ,
	ZipCode varchar2 (50 BYTE) NULL ,
	Country varchar2 (75 BYTE) NULL ,
	PhoneNumber varchar2 (30 BYTE) NULL ,
	CellNumber varchar2 (30 BYTE) NULL ,
	VerificationID varchar2 (50 BYTE) NULL ,
	Verified NUMBER (1) DEFAULT '0' NULL ,
	Bounced NUMBER (1) DEFAULT '0' NULL ,
	Duplicate NUMBER (1) DEFAULT '0' NULL,
	ExceededMailQuota NUMBER (1) DEFAULT '0' NULL ,
	DateRemoved DATE NULL ,
	DateBounced DATE NULL ,
	Unsubscribed NUMBER (1) DEFAULT '1' NULL,
	Custom1	varchar2	(75 BYTE) NULL,
	Custom2	varchar2	(75 BYTE) NULL,
	Custom3	varchar2	(75 BYTE) NULL,
	Custom4	varchar2	(75 BYTE) NULL,
	Custom5	varchar2	(75 BYTE) NULL
);


CREATE UNIQUE INDEX  email_addresses_removed_PK  ON  email_addresses_removed (EmailID);
ALTER TABLE email_addresses_removed ADD CONSTRAINT email_addresses_removed_PK  PRIMARY KEY (EmailID);


     
CREATE OR REPLACE TRIGGER  email_addresses_rmvd_TRIGGER  before
  INSERT ON  email_addresses_removed FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.EmailID FROM dual;
END;
/
ALTER TRIGGER email_addresses_rmvd_TRIGGER ENABLE;
 
 
CREATE TABLE email_list_messages (
	MessageID  NUMBER(9),
	MessageTempID NUMBER(9) NULL ,
	MessageListID  NUMBER(9) NOT NULL ,
	MessageName varchar (75) NULL ,
	MessageSubject varchar (75) NULL ,
	MessageTXT varchar2 (4000) NULL ,
	MessageHTML varchar2 (4000) NULL ,
	MessageMultiPart NUMBER(1) DEFAULT '1' NULL ,
	ShowEditor NUMBER(1) DEFAULT '1' NULL,
	MessageCreateDate DATE NULL,
	MessageWithRedirects varchar2 (4000) NULL
);


CREATE UNIQUE INDEX  email_list_messages_PK  ON  email_list_messages (MessageID);
ALTER TABLE email_list_messages ADD CONSTRAINT email_list_messages_PK  PRIMARY KEY (MessageID);


     
CREATE OR REPLACE TRIGGER  email_list_messages_TRIGGER  before
  INSERT ON  email_list_messages FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.MessageID FROM dual;
END;
/
ALTER TRIGGER  email_list_messages_TRIGGER ENABLE;
 
CREATE TABLE email_list_groups (
	GroupID number (9),
 
	GroupDesc varchar2 (100 BYTE) NULL ,
	ListID NUMBER(9) NULL ,
	subFilter varchar2  (80 BYTE) NULL,
	subSearchTxt varchar2 (75 BYTE) NULL,
	GroupCreateDate DATE NULL 
);



CREATE UNIQUE INDEX  email_list_groups_PK  ON  email_list_groups (GroupID);
ALTER TABLE email_list_groups ADD CONSTRAINT email_list_groups_PK  PRIMARY KEY (GroupID);


     
CREATE OR REPLACE TRIGGER  email_list_groups_TRIGGER  before
  INSERT ON  email_list_groups FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.GroupID FROM dual;
END;
/
ALTER TRIGGER  email_list_groups_TRIGGER ENABLE;
 
CREATE TABLE email_list_groups_members (
	GMID NUMBER(9) ,
	GMEmailID NUMBER (9) NULL ,
	GMGroupID NUMBER (9) NULL 
  );
  
  
CREATE UNIQUE INDEX  email_list_groups_members_PK  ON  email_list_groups_members (GMID);
ALTER TABLE email_list_groups_members ADD CONSTRAINT email_list_groups_members_PK  PRIMARY KEY (GMID);


     
CREATE OR REPLACE TRIGGER  email_list_groups_mbr_TRIGGER  before
  INSERT ON  email_list_groups_members FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.GMID FROM dual;
END;
/
ALTER TRIGGER  email_list_groups_mbr_TRIGGER ENABLE;
 
<cftry>
<cfquery name="createTableSchema" datasource="#form.DSN#">
CREATE TABLE email_list_groups_tempholder (
	recID NUMBER(9),
	 
	tempGroupID NUMBER(9) NULL
);


CREATE UNIQUE INDEX  email_list_groups_temp_PK  ON  email_list_groups_tempholder (recid);
ALTER TABLE email_list_groups_tempholder ADD CONSTRAINT email_list_groups_tem_PK  PRIMARY KEY (recid);


     
CREATE OR REPLACE TRIGGER  email_list_groups_temp_TRIGGER  before
  INSERT ON  email_list_groups_tempholder FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.recid FROM dual;
END;
/
ALTER TRIGGER  email_list_groups_temp_TRIGGER ENABLE;
 
	 INSERT INTO email_list_groups_tempholder (tempGroupID)
	 VALUES (1);
 </cfquery>
  
CREATE TABLE email_lst_messages_personalize (
	recID NUMBER(9) NOT NULL,
	personalizeNotation varchar2 (100 BYTE) NULL ,
	personalizeDesc varchar2 (100 BYTE) NULL ,
	assocVarName varchar2 (50 BYTE) NULL 
);


CREATE UNIQUE INDEX  email_lst_messages_per_PK  ON  email_lst_messages_personalize (recid);
ALTER TABLE email_lst_messages_personalize ADD CONSTRAINT email_lst_messages_per_PK  PRIMARY KEY (recid);


     
CREATE OR REPLACE TRIGGER  email_lst_messages_per_TRIGGER  before
  INSERT ON  email_lst_messages_personalize FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.recid FROM dual;
END;
/
ALTER TRIGGER  email_lst_messages_per_TRIGGER ENABLE;
 
	  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc, assocVarName)
	  VALUES ('[First Name]', 'Subscribers First name', 'FirstName');
 
	  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc, assocVarName)
	  VALUES ('[Last Name]', 'Subscribers Last name', 'LastName');
   
	  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc, assocVarName)
	  VALUES ('[Email]', 'Subscribers Email Address', 'EmailAddress');
  
	  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc)
	  VALUES ('[List]', 'List Name');
  
	  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc)
	  VALUES ('[Date Med]', 'Medium Date from the Server');
  
	  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc)
	  VALUES ('[Date Short]', 'Short Date from the Server');
  
	  INSERT INTO email_lst_messages_personalize (personalizeNotation, personalizeDesc)
	  VALUES ('[Date Long]', 'Long Date from the Server');
 
CREATE TABLE email_list_messages_send_log (
	recID NUMBER(9) NOT NULL ,
	ListID NUMBER(9) NULL,
	MessageID NUMBER(9) NULL,
	MessageBroadcastID  NUMBER(9) NULL ,
	MessagePreSentDate DATE NULL ,
	MessageSentDate DATE NULL 
);



CREATE UNIQUE INDEX  email_list_mesg_send_log_PK  ON  email_list_messages_send_log (recid);
ALTER TABLE email_list_messages_send_log ADD CONSTRAINT email_list_mesg_send_log_PK  PRIMARY KEY (recid);


     
CREATE OR REPLACE TRIGGER  email_list_mesg_sndlog_TRIGGER  before
  INSERT ON  email_list_messages_send_log FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.recid FROM dual;
END;
/
ALTER TRIGGER  email_list_mesg_sndlog_TRIGGER ENABLE;
 
CREATE TABLE email_lists (
	EmailListID NUMBER (9) NOT NULL,
	EmailListDesc varchar (50) NOT NULL ,
	EmailListAdminID NUMBER (9) DEFAULT '1' NOT NULL ,
	EmailListWebRoot varchar (250) DEFAULT 'http://localhost/maillist' NULL ,
	EmailListReplyToEmail varchar (100) NULL ,
	EmailListFromEmail varchar (100) NOT NULL ,
	EmailListSMTPServer varchar (100) NOT NULL ,
	EmailListPOPServer varchar (100) NULL ,
	EmailListPOPLogin varchar (75) NOT NULL ,
	EmailListPOPPwd varchar (50) NOT NULL ,
	EmailListGlobalHeader varchar2 (4000) NULL ,
	EmailListGlobalFooter varchar2 (4000) NULL ,
	EmailListGlobalHeaderHTML varchar2 (4000) NULL ,
	EmailListGlobalFooterHTML varchar2 (4000) NULL ,
	EmailMessageGlobalFontFace varchar (255) DEFAULT 'Verdana, Arial, Helvetica, sans-serif' NULL ,
	EmailMessageGlobalFontSize varchar (50) DEFAULT '1' NULL ,
	EmailMessageGlobalFontColor varchar (50) DEFAULT 'Black' NULL ,
	taskScheduled NUMBER (1) DEFAULT '0' NULL ,
	EmailIDLinkAdded NUMBER (1) DEFAULT '0' NULL ,
	EmailPersonalization NUMBER (1) DEFAULT '0' NULL,
	BatchAmount NUMBER (9) DEFAULT '300' NULL
);


CREATE UNIQUE INDEX  email_lists_PK  ON  email_lists (EmailListID);
ALTER TABLE email_lists ADD CONSTRAINT email_lists_PK  PRIMARY KEY (EmailListID);


     
CREATE OR REPLACE TRIGGER  email_lists_TRIGGER  before
  INSERT ON  email_lists FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.EmailListID FROM dual;
END;
/
ALTER TRIGGER  email_lists_TRIGGER ENABLE;
 	  INSERT INTO email_lists (EmailListDesc, EmailListAdminID, EmailListFromEmail, EmailListSMTPServer,
	  EmailListPOPServer, EmailListPOPLogin, EmailListPOPPwd)
	  VALUES ('Default List (safe to delete after install)', 1, 'test@localhost', '192.168.1.5', '192.168.1.5', 'maillist', '1234')
  
CREATE TABLE email_list_messages_schedule (
	MsgScheduleID NUMBER (9) NOT NULL,
	PRIMARY KEY (MsgScheduleID),
	MSchedStartDate varchar2 (10) NULL ,
	MSchedStartTime varchar2 (7) NULL ,
	MSchedEndDate varchar2 (10) NULL ,
	MSchedEndTime varchar2 (7) NULL ,
	MSchedInterval varchar2 (12) NULL ,
	MSchedListID NUMBER (9) NULL ,
	MSchedGroupID NUMBER (9) NULL ,
	MSchedMessageID NUMBER (9) NULL ,
	MSchedActive NUMBER(1) NULL ,
	MSchedCreateDate timestamp NULL 
);


CREATE UNIQUE INDEX  emaillis_messagesschd_PK  ON  email_list_messages_schedule (MsgScheduleID);
ALTER TABLE email_list_messages_schedule ADD CONSTRAINT emaillis_messagesschd_PK  PRIMARY KEY (MsgScheduleID);


     
CREATE OR REPLACE TRIGGER  email_list_msg_schd_TRIGGER  before
  INSERT ON  email_list_messages_schedule FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.MsgScheduleID FROM dual;
END;
/
ALTER TRIGGER  email_list_msg_schd_TRIGGER ENABLE;
 
	CREATE TABLE font_faces (
		recID NUMBER(9) NOT NULL,
		FontFace varchar2 (255) NULL 
	);
  
  
CREATE UNIQUE INDEX  font_faces_PK  ON  font_faces (recid);
ALTER TABLE font_faces ADD CONSTRAINT font_faces_PK  PRIMARY KEY (recid);


     
CREATE OR REPLACE TRIGGER  font_faces_TRIGGER  before
  INSERT ON  font_faces FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.recid FROM dual;
END;
/
ALTER TRIGGER  font_faces_TRIGGER ENABLE;
 

	 
	  INSERT INTO font_faces (FontFace)
	  VALUES ('Verdana, Arial, Helvetica, sans-serif');
	 
	  INSERT INTO font_faces (FontFace)
	  VALUES ('Arial');
	 
	  INSERT INTO font_faces (FontFace)
	  VALUES ('Arial, Helvetica, sans-serif');
 
	  INSERT INTO font_faces (FontFace)
	  VALUES ('Times New Roman, Times, serif');
	 
	  INSERT INTO font_faces (FontFace)
	  VALUES ('Georgia, Times New Roman, Times, serif');
	 
	  INSERT INTO font_faces (FontFace)
	  VALUES ('Geneva, Arial, Helvetica, sans-serif');
 	CREATE TABLE globals (
		recID NUMBER (9) not null,
		siteServerAddress varchar2 (255) DEFAULT 'http://www.yourdomain.com/maillist/' NOT NULL ,
		localServerAddress varchar2 (255) DEFAULT 'http://localhost/maillist/' NOT NULL ,
		siteStyle varchar2 (50) DEFAULT 'defaultStyle.css' NOT NULL ,
		subscriptionLists_MaxRows NUMBER (9) DEFAULT '15' NOT NULL ,
		subscriptionLists_MaxPages NUMBER (9) DEFAULT '10' NOT NULL ,
		subscribersList_MaxRows NUMBER (9) DEFAULT '15' NOT NULL ,
		subscribersList_MaxPages NUMBER (9) DEFAULT '10' NOT NULL ,
		messageLists_MaxRows NUMBER (9) DEFAULT '15' NOT NULL ,
		messageLists_MaxPages NUMBER (9) DEFAULT '10' NOT NULL ,
		cfmxInstalled NUMBER (1) DEFAULT '0' NOT NULL ,
		exportFilePath varchar2 (255) DEFAULT '/var/www/html/maillist/admin/export' NULL ,
		importFilePath varchar2 (255) DEFAULT '/var/www/html/maillist/admin/import' NULL ,
		cffileEnabled NUMBER (1) DEFAULT '1' NULL,
		useFtp NUMBER (1) DEFAULT '0' NULL,
		ftpServerName varchar2 (150) NULL ,
		ftpPassiveMode NUMBER (1) DEFAULT '1' NULL ,
		ftpRetry NUMBER (9) DEFAULT '1' NULL ,
		ftpTimeout NUMBER (9) DEFAULT '30' NULL ,
		ftpUserName varchar2 (50) NULL ,
		ftpPassword varchar2 (50) NULL ,
		ftpPathToAdminDir varchar2 (255) NULL,
		editorPath varchar2 (255) DEFAULT 'editor/' NULL,
		attachmentsPath varchar2 (255) DEFAULT '/var/www/html/maillist/admin/attachments' NULL,
		enableAutoResponders NUMBER (1) DEFAULT '0' NULL,
		logSuccessfulBroadcasts NUMBER (1) DEFAULT '0' NULL,
		DefaultEditorWidth NUMBER (9) DEFAULT '650' NULL ,
		DefaultEditorHeight NUMBER (9) DEFAULT '400' NULL ,
		ELMVersion varchar2 (50) DEFAULT 'Admin Pro Tools Email List Manager 2.5 Enterprise' NULL ,
		CFusionUndelivDir varchar2 (50) NULL ,
		ChartStyle NUMBER (9) DEFAULT '1' NULL,
		PopServerTimeout NUMBER (9) DEFAULT '300' NULL,
		PageTimeout NUMBER (9) DEFAULT '300' NULL,
		MailerType varchar2 (50) DEFAULT 'CFMAIL' NULL,
		DateDisplay varchar2 (50) DEFAULT 'mm-dd-yy' NULL,
		TimeDisplay varchar2 (50) DEFAULT 'hh:mm' NULL,
		DatabaseType NUMBER (9) DEFAULT '1' NULL,
		Custom1Name	varchar2	(50) NULL,
		Custom2Name	varchar2	(50) NULL,
		Custom3Name	varchar2	(50) NULL,
		Custom4Name	varchar2	(50) NULL,
		Custom5Name	varchar2	(50) NULL 
	);
  
  
  
CREATE UNIQUE INDEX  globals_PK  ON  globals (recid);
ALTER TABLE globals ADD CONSTRAINT globals_PK  PRIMARY KEY (recid);


     
CREATE OR REPLACE TRIGGER  globals_TRIGGER  before
  INSERT ON  globals FOR EACH row BEGIN
  SELECT mail_seq.nextval INTO :new.recid FROM dual;
END;
/
ALTER TRIGGER  globals_TRIGGER ENABLE;
	 
	  INSERT INTO globals (siteServerAddress, siteStyle, subscriptionLists_MaxRows, subscriptionLists_MaxPages, 
	  subscribersList_MaxRows , subscribersList_MaxPages,
		messageLists_MaxRows , messageLists_MaxPages ,
		cfmxInstalled , exportFilePath ,
		importFilePath,
		cffileEnabled, useFtp,
		ftpPassiveMode,
		ftpRetry , ftpTimeout, DatabaseType)
	  VALUES ('http://localhost/maillist/', 'defaultStyle.css', 15, 10, 15, 10, 15, 10, 0, '/var/www/html/maillist/admin/export', 
	  	'/var/www/html/maillist/admin/import', 1, 0, 1, 1, 30, 4)
	</cfquery>
 
CREATE TABLE send_log_id (
	recID NUMBER(9) NOT NULL,
	SendLogID NUMBER(9) NULL
);


CREATE UNIQUE INDEX send_log_id_PK  ON send_log_id (recid);
ALTER TABLE send_log_id ADD CONSTRAINT send_log_id_PK  PRIMARY KEY (recid);

 
	  INSERT INTO send_log_id (recID,SendLogID)
	  VALUES (1,1);
	 
