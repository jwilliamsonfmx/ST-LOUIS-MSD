--CREATION DE LA FONCTION DE CONVERSION DU FORMAT DE DATE AD

use EVO_BACKOFFICE
GO

drop function [EZV_ADMIN].AD_DATE_CONVERT
GO

create function [EZV_ADMIN].AD_DATE_CONVERT (@LDAP_DATE as bigint)
returns datetime
begin
declare @nb bigint;
declare @dateres datetime;

if @LDAP_DATE=9223372036854770000 begin return NULL; end;
if @LDAP_DATE=9223372036854775807 begin return NULL; end;
if @LDAP_DATE=0 begin return NULL; end;

set @dateres='01/01/2000';
set @LDAP_DATE = @LDAP_DATE-125911584000000000;
set @nb = @LDAP_DATE % 10000000;
set @LDAP_DATE = @LDAP_DATE / 10000000;
set @dateres = DATEADD ( millisecond , @nb , @dateres ) ;
set @nb = @LDAP_DATE % 60;
set @LDAP_DATE = @LDAP_DATE / 60;
set @dateres = DATEADD ( second , @nb , @dateres ) ;
set @nb = @LDAP_DATE % 60;
set @LDAP_DATE = @LDAP_DATE / 60;
set @dateres = DATEADD ( minute , @nb , @dateres ) ;
set @nb = @LDAP_DATE % 24;
set @LDAP_DATE = @LDAP_DATE / 24;
set @dateres = DATEADD ( hour , @nb , @dateres ) ;
set @dateres = DATEADD ( day , @LDAP_DATE , @dateres ) ;

return @dateres 

END