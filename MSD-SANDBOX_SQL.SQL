--ST LOUIS MSD SANDBOX
UPDATE SD_REQUEST
SET E_CR_RISK_SCORE = '52'
	,E_CR_BUSINESS_IMPACT = 'Enterprise & External'
	,E_CR_SERVICE_STATE = 'System/Service Outage'
	,E_CR_OCCURS = 'Non Business Hours'
	,E_CR_EXPECTED_LENGTH = '2-4 Hours'
	,E_CR_TESTED = 'No'
	,E_CR_BACKOUT_EFFORT = 'Difficult%Impossible%Undesirable'
	,E_CR_LOCATION = 'All Locations Impacted'
WHERE END_DATE_UT IS NULL
AND RFC_NUMBER LIKE '%CHG%'
AND CAST(CREATION_DATE_UT AS DATE) = CAST(GETDATE() AS DATE)
AND CI_ID IN (SELECT ASSET_ID FROM AM_ASSET WHERE IS_CI = 1 AND NETWORK_IDENTIFIER = '')
AND COMMENT LIKE '%%'
	




E_CR_RISK_SCORE = ‘Calculated based on fields auto filled in below’
E_CR_BUSINESS_IMPACT = 'Enterprise & External'
E_CR_SERVICE_STATE = 'System/Service Outage'
E_CR_OCCURS = 'Non Business Hours'
E_CR_EXPECTED_LENGTH = '2-4 Hours'
E_CR_TESTED = 'No'
E_CR_BACKOUT_EFFORT LIKE 'Difficult%Impossible%Undesirable'
E_CR_LOCATION = 'All Locations Impacted'


UPDATE SD_REQUEST
SET E_CR_RISK_SCORE =
(
SELECT 
	CASE
		WHEN R.E_CR_BUSINESS_IMPACT = 'Enterprise & External'
		THEN 12
		WHEN R.E_CR_BUSINESS_IMPACT = 'Enterprise'
		THEN 12
		WHEN R.E_CR_BUSINESS_IMPACT = 'Multiple Departments'
		THEN 8
		WHEN R.E_CR_BUSINESS_IMPACT = 'Single Department'
		THEN 4
		WHEN R.E_CR_BUSINESS_IMPACT = 'Small Functional Area'
		THEN 1
		ELSE 1
	END
	+
	CASE
		WHEN R.E_CR_SERVICE_STATE = 'System/Service Outage'
		THEN 12
		WHEN R.E_CR_SERVICE_STATE = 'Limited/Reduced Functionality'
		THEN 4
		WHEN R.E_CR_SERVICE_STATE = 'Read-Only'
		THEN 1
		WHEN R.E_CR_SERVICE_STATE = 'Normal Functionality'
		THEN 0
		ELSE 0
	END
	+
	CASE
		WHEN R.E_CR_OCCURS = 'During the Scheduled Maintenance Window'
		THEN 1
		WHEN R.E_CR_OCCURS = 'Non Business Hours'
		THEN 4
		WHEN R.E_CR_OCCURS = 'Business Hours'
		THEN 8
		ELSE 1
	END
	+
	CASE
		WHEN R.E_CR_EXPECTED_LENGTH = 'Greater than 9 Hours'
		THEN 12
		WHEN R.E_CR_EXPECTED_LENGTH = '5-8 Hours'
		THEN 8
		WHEN R.E_CR_EXPECTED_LENGTH = '2-4 Hours'
		THEN 4
		WHEN R.E_CR_EXPECTED_LENGTH = '0-2 Hours'
		THEN 2
		WHEN R.E_CR_EXPECTED_LENGTH = 'No Outage Expected'
		THEN 0
		ELSE 0
	END
	+
	CASE
		WHEN R.E_CR_TESTED = 'Yes'
		THEN 1
		WHEN R.E_CR_TESTED = 'No'
		THEN 8
		ELSE 1
	END
	+
	CASE
		WHEN R.E_CR_BACKOUT_EFFORT LIKE 'Difficult%Impossible%Undesirable'
		THEN 12
		WHEN R.E_CR_BACKOUT_EFFORT LIKE 'Possible%Not easily executed%Would extend beyond the Maintenance Window%'
		THEN 8
		WHEN R.E_CR_BACKOUT_EFFORT = 'In Place and Easily Executed in the Maintenance Window'
		THEN 4
		WHEN R.E_CR_BACKOUT_EFFORT = 'Minimal'
		THEN 1
		ELSE 1
	END AS "RISK_SCORE"
FROM SD_REQUEST R
WHERE REQUEST_ID IN (@ID@)
)
WHERE REQUEST_ID IN (@ID@);

UPDATE SD_REQUEST
SET E_CR_LOCATION =
(
SELECT
	(SELECT
		CASE
		WHEN Q.QUESTION_CODE = 'LOC_ALL' AND QR.RESULT_BIT = 1
		THEN 'All Locations Impacted '
		ELSE ''
		END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_ALL'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_BISSEL' AND QR.RESULT_BIT = 1
	THEN 'Bissel, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_BISSEL'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_COLDWATER' AND QR.RESULT_BIT = 1
	THEN 'Coldwater, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_COLDWATER'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_FENTON' AND QR.RESULT_BIT = 1
	THEN 'Fenton, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_FENTON'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_GBLAZE' AND QR.RESULT_BIT = 1
	THEN 'Grand Blaze, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_GBLAZE'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_LPLANT' AND QR.RESULT_BIT = 1
	THEN 'Lemay Plant, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_LPLANT'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_LPUMP' AND QR.RESULT_BIT = 1
	THEN 'Lemay Pump, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_LPUMP'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_MARKET' AND QR.RESULT_BIT = 1
	THEN 'Market, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_MARKET'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_MERAMEC' AND QR.RESULT_BIT = 1
	THEN 'Meramec, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_MERAMEC'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_MINTERT' AND QR.RESULT_BIT = 1
	THEN 'Minrert, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_MINTERT'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_MORIVER' AND QR.RESULT_BIT = 1
	THEN 'MO River, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_MORIVER'))
	+
	(SELECT
		CASE
	WHEN Q.QUESTION_CODE = 'LOC_SULPHUR' AND QR.RESULT_BIT = 1
	THEN 'Sulphur, '
	ELSE ''
	END
	FROM SD_QUESTION_RESULT QR
	INNER JOIN SD_QUESTION Q ON Q.QUESTION_ID = QR.QUESTION_ID
	WHERE QR.REQUEST_ID IN (PR.REQUEST_ID)
	AND Q.QUESTION_CODE IN ('LOC_SULPHUR')) AS "CR_LOCATIONS_IMPACTED"
FROM SD_REQUEST PR
WHERE PR.REQUEST_ID IN (@ID@)
)
WHERE REQUEST_ID IN (@ID@);

INSERT INTO AM_ACTION
	(DONE_BY_ID
	,ACTION_LABEL_EN
	,REQUEST_ID
	,LOCATION_ID
	,COMMENT
	,START_DATE_UT
	,END_DATE_UT
	,CREATION_DATE_UT
	,STATUS_ID_ON_CREATE
	,STATUS_ID_ON_TERMINATE
	,ACTION_TYPE_ID
	,TO_TRUNC
	,IS_LOCKED_PROGRESS_POINT
	,ORIGIN_TOOL_ID
	,LAST_UPDATE)
SELECT TOP 1
	R.REQUESTOR_ID
	,'Link to a Ticket'
	,R.REQUEST_ID
	,6
	,R.EXTERNAL_REFERENCE
	,GETUTCDATE()
	,GETUTCDATE()
	,GETUTCDATE()
	,R.STATUS_ID
	,R.STATUS_ID
	,72
	,0
	,0
	,1
	,GETUTCDATE()
FROM SD_REQUEST R
WHERE R.REQUEST_ID IN (@ID@);