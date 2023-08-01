--IMPORTLDAPUSERS
INSERT EVO_BACKOFFICE.EZV_ADMIN.E_MSD_LDAP_USERS_OK
        (FULL_NAME,
        LOGIN,
        EMAIL,
        LOCATION,
        DEPARTMENT,
        MANAGER,
        TITLE,
	PHONE_NUMBER,
        COST_CENTER
)

SELECT 
Name as "FULL_NAME",
        sAMAccountName AS "LOGIN",
        mail as "EMAIL",
        physicalDeliveryOfficeName as "LOCATION",
        Division +'/'+ Department as "DEPARTMENT_PATH",
	REPLACE(REPLACE(REPLACE(SUBSTRING(manager, CHARINDEX('CN=', manager), CHARINDEX(',OU=',manager) - CHARINDEX('CN=', manager) + Len(',OU=')),'CN=',''),',OU=',''),'','') as "MANAGER",
        title,
        telephoneNumber as "TELEPHONE_NUMBER",
        costcenter as "COST_CENTER"


FROM
        EVO_BACKOFFICE.EZV_ADMIN.E_MSD_LDAP_USERS_TEMP

WHERE
        (sAMAccountName IS NOT NULL
        AND mail IS NOT NULL
        AND Name IS NOT NULL
        AND sAMAccountName NOT LIKE '%208%' AND sAMAccountName NOT LIKE 'acct%' AND sAMAccountName NOT LIKE 'Administrator' AND sAMAccountName NOT LIKE 'BentleySSNotify' AND sAMAccountName NOT LIKE 'BILLINGQUEST' AND sAMAccountName NOT LIKE 'bankruptcies' AND sAMAccountName NOT LIKE 'conmkt%' AND sAMAccountName NOT LIKE 'conf%' AND sAMAccountName NOT LIKE 'eqair%' AND sAMAccountName NOT LIKE 'eqcar%'AND sAMAccountName NOT LIKE 'SM_%' AND sAMAccountName NOT LIKE 'Test%' AND sAMAccountName NOT LIKE 'MSOL_%'AND sAMAccountName NOT LIKE 'WFEB%' AND sAMAccountName NOT LIKE 'FederatedEmail%' AND sAMAccountName NOT LIKE 'WSS_%'AND sAMAccountName NOT LIKE 'decfore%'AND sAMAccountName NOT LIKE 'decpt%'AND sAMAccountName NOT LIKE 'dedinsp%'AND sAMAccountName NOT LIKE 'WSS_%' AND sAMAccountName NOT LIKE 'bmpannual%' AND sAMAccountName NOT LIKE 'SystemMailbo%' AND sAMAccountName NOT LIKE 'HealthMailboxd%' AND sAMAccountName NOT LIKE 'waterp%' AND sAMAccountName NOT LIKE '%D0030B42%' AND sAMAccountName NOT LIKE 'spdisch%' AND Name NOT LIKE 'DiscoverySearch%' AND Name NOT LIKE 'Webmaster%' AND Name NOT LIKE 'SystemMailbox%' AND Name NOT LIKE 'EQProj%'AND Name NOT LIKE '%INSPECTOR%'AND Name NOT LIKE '%hrmail%' AND Name NOT LIKE '%pmo%' AND Name NOT LIKE '%BentleyS%')                                        

--IMPORTLDAPDisabledUsers
INSERT EVO_BACKOFFICE.EZV_ADMIN.E_MSD_LDAP_ARCHIVED_USERS_OK
        (FULL_NAME,
        LOGIN,
        EMAIL)

SELECT
        Name as "FULL_NAME",
        sAMAccountName AS "LOGIN",
        mail as "EMAIL"

FROM
        EVO_BACKOFFICE.EZV_ADMIN.E_MSD_LDAP_ARCHIVED_USERS_TEMP
WHERE
        (sAMAccountName IS NOT NULL);