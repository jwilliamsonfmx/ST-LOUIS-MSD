--OLD AUTO CLOSURE CODE
UPDATE AM_ACTION
SET AM_ACTION.STATUS_ID_ON_TERMINATE = (SELECT SD_STATUS.STATUS_ID FROM SD_STATUS
WHERE SD_STATUS.STATUS_GUID = '{C3D9DFA7-7A21-46C2-B3A3-8BC50C9FF4F3}'), AM_ACTION.END_DATE_UT = getutcdate(), AM_ACTION.START_DATE_UT = getutcdate()
WHERE AM_ACTION.REQUEST_ID in (#LIST_ID#) AND AM_ACTION.END_DATE_UT IS NULL;

UPDATE SD_REQUEST
SET DESCRIPTION = ISNULL(Description,'')+ '-AUTOCLOSED DUE TO AGING',
SD_REQUEST.STATUS_ID = 
(SELECT STATUS_ID FROM SD_STATUS
WHERE STATUS_GUID = '{C3D9DFA7-7A21-46C2-B3A3-8BC50C9FF4F3}'), SD_REQUEST.END_DATE_UT = getutcdate()
WHERE SD_REQUEST.REQUEST_ID in (#LIST_ID#);

--CLEANED UP AUTO CLOSURE CODE
UPDATE A
SET A.DESCRIPTION = ISNULL(A.DESCRIPTION,'') + ' -AUTOCLOSED DUE TO AGING',
    A.STATUS_ID_ON_TERMINATE = 8,
    A.END_DATE_UT = GETUTCDATE()
FROM AM_ACTION A
WHERE A.REQUEST_ID in (#LIST_ID#) 
AND A.END_DATE_UT IS NULL;

UPDATE R 
SET R.DESCRIPTION = ISNULL(R.DESCRIPTION,'') + ' -AUTOCLOSED DUE TO AGING',
    R.STATUS_ID = 8,
    R.END_DATE_UT = GETUTCDATE()
FROM SD_REQUEST R
WHERE R.REQUEST_ID in (#LIST_ID#);

--PENDING VALIDATION FILTER
SD_STATUS.STATUS_GUID IN ('{F99A2EED-C9A6-47F1-9C02-F7BD8E4E5407}', '{2CD231EC-1807-4D76-BFCA-39E86439951E}', '{514479D3-CC35-4695-8B1A-DB0B4B23C985}', '{A7678021-441F-453B-AC7D-A202AEAD4D6C}') AND {# FILTER_DATE('SD_REQUEST.CREATION_DATE_UT','BEFORE', '02/28/2024', EN) #} AND ( {# TREEWHERE('SD_CATALOG', 'CATALOG_GUID', '{932E417B-2798-4E45-9918-7FB6A9CB49D5}', 'SD_CATALOG') #} OR {# TREEWHERE('SD_CATALOG', 'CATALOG_GUID', '{2BD6E0E2-E21F-40D9-B10F-34CA9A28B239}', 'SD_CATALOG') #} )

--BROKEN WORKFLOWS FILTER
SD_META_STATUS.META_STATUS_GUID IN ('{C9FB9FC4-BDDB-4D31-8F5B-9913F34EE888}') AND SD_REQUEST.END_DATE_UT IS NOT NULL

--STIL OPEN FILTER
SD_STATUS.STATUS_GUID IN ('{27B405D2-63F9-47E3-919C-18A7B90C2510}', '{E636FA3E-641D-434E-92D6-38AB0D683D4D}', '{BBB67B03-212B-4A7E-BAE1-9FD2D0E21C87}') AND {# FILTER_DATE('SD_REQUEST.CREATION_DATE_UT','BEFOREYEARS', '1') #} AND {# TREEWHERE('SD_CATALOG', 'CATALOG_GUID', '{2BD6E0E2-E21F-40D9-B10F-34CA9A28B239}', 'SD_CATALOG') #}

--NEW STILL OPEN FILTER
SD_STATUS.STATUS_GUID IN ('{27B405D2-63F9-47E3-919C-18A7B90C2510}', '{E636FA3E-641D-434E-92D6-38AB0D683D4D}', '{BBB67B03-212B-4A7E-BAE1-9FD2D0E21C87}') AND {# TREEWHERE('SD_CATALOG', 'CATALOG_GUID', '{2BD6E0E2-E21F-40D9-B10F-34CA9A28B239}', 'SD_CATALOG') #} AND {# FILTER_DATE('SD_REQUEST.CREATION_DATE_UT','BEFOREMONTHS', '6') #}