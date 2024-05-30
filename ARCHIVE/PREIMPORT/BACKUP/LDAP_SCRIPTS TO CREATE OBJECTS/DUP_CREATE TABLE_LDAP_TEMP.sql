--CREATION DE LA TABLE TABLE_LDAP_TEMP

use EVO_BACKOFFICE
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[EZV_ADMIN].[TABLE_LDAP_TEMP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EZV_ADMIN].[TABLE_LDAP_TEMP]
GO

CREATE TABLE [EZV_ADMIN].[TABLE_LDAP_TEMP]
(
	[COL_0]  [nvarchar] (255) NULL ,
	[COL_1]  [nvarchar] (255) NULL ,
	[COL_2]  [nvarchar] (255) NULL ,
	[COL_3]  [nvarchar] (255) NULL,
	[COL_4]  [nvarchar] (255) NULL,
	[COL_5]  [nvarchar] (255) NULL  
 	

) ON [PRIMARY]
GO