--CREATION DE LA TABLE TABLE_LDAP_OK

use EVO_BACKOFFICE
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[EZV_ADMIN].[TABLE_LDAP_OK]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EZV_ADMIN].[TABLE_LDAP_OK]
GO

CREATE TABLE [EZV_ADMIN].[TABLE_LDAP_OK]
(
	[FULL_NAME]         [nvarchar] (255) NULL ,
	[LOGIN]		    [nvarchar] (255) NULL ,
	[EMAIL]             [nvarchar] (255) NULL ,
	[EXPIRATION_DATE]   [datetime] NULL 

) ON [PRIMARY]
GO