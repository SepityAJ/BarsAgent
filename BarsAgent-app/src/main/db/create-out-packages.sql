CREATE OR REPLACE PACKAGE LOAD_OUT_LAYER AS
   PROCEDURE LOAD_EPS_FROM_RESULT;
   PROCEDURE LOAD_VAL_FROM_RESULT;
END LOAD_OUT_LAYER;
/
CREATE OR REPLACE PACKAGE BODY LOAD_OUT_LAYER AS

--  create or replace
    PROCEDURE LOAD_EPS_FROM_RESULT IS
      BEGIN
        MERGE INTO OUT_EPS o
        USING (
          SELECT
            d.ACCOUNT_RK,
            d.AGREEMENT_NUM,
            (CASE WHEN d.SOURCE='F12' THEN f.LAW_NUM ELSE NULL END) AS LAW_NUM,
            r.EPS,
            r.BEG_DATE,
            r.BEG_DATE AS END_DATE,
            d.DEAL_TYPE_CD,
            d.CCY,
            d.STATUS,
            r.OPERDAY
          FROM RES_EPS r
          INNER JOIN SRC_DEAL d ON r.DEAL_ID = d.ID_PK
          LEFT JOIN SRC_FACILITY f ON d.FACILITY_ID = f.ID_PK
        ) s
        ON (o.ACCOUNT_RK = s.ACCOUNT_RK AND o.VALID_FROM = s.BEG_DATE)
        WHEN MATCHED THEN UPDATE SET
          o.DEAL_NUMBER = s.AGREEMENT_NUM
          , o.AGREEMENT_NUMBER = s.LAW_NUM
          , o.EPS = s.EPS
          , o.VALID_TO = s.END_DATE
          , o.DEAL_TYPE_CD = s.DEAL_TYPE_CD
          , o.CURRENCY_CD = s.CCY
          , o.STATUS_CD = s.STATUS
          , o.OPERDAY = s.OPERDAY
        WHEN NOT MATCHED THEN INSERT (
          ACCOUNT_RK
          , DEAL_NUMBER
          , AGREEMENT_NUMBER
          , EPS
          , VALID_FROM
          , VALID_TO
          , DEAL_TYPE_CD
          , CURRENCY_CD
          , STATUS_CD
          , OPERDAY
        ) VALUES (
          s.ACCOUNT_RK
          , s.AGREEMENT_NUM
          , s.LAW_NUM
          , s.EPS
          , s.BEG_DATE
          , s.END_DATE
          , s.DEAL_TYPE_CD
          , s.CCY
          , s.STATUS
          , s.OPERDAY
        );
      END;

--  create or replace
    PROCEDURE LOAD_VAL_FROM_RESULT IS
      BEGIN
        MERGE INTO OUT_VALUE o
        USING (
          SELECT
            d.ACCOUNT_RK,
            d.AGREEMENT_NUM,
            (CASE WHEN d.SOURCE='F12' THEN f.LAW_NUM ELSE NULL END) AS LAW_NUM,
            r.AC_TO_ST,
            r.AC_AFTER_ST_PR,
            r.PERCENT_PR,
            r.DATE_CALCULATE AS FROM_DATE,
            r.DATE_CALCULATE AS TILL_DATE,
            d.DEAL_TYPE_CD,
            d.CCY,
            d.STATUS,
            r.OPERDAY
          FROM RES_VALUE r
          INNER JOIN SRC_DEAL d ON r.DEAL_ID = d.ID_PK
          LEFT JOIN SRC_FACILITY f ON d.FACILITY_ID = f.ID_PK
        ) s
        ON (o.ACCOUNT_RK = s.ACCOUNT_RK AND o.VALID_FROM = s.FROM_DATE)
        WHEN MATCHED THEN UPDATE SET
          o.DEAL_NUMBER = s.AGREEMENT_NUM
          , o.AGREEMENT_NUMBER = s.LAW_NUM
          , o.AC_TO_ST = coalesce (s.AC_TO_ST, 0)
          , o.AC_AFTER_ST = coalesce (s.AC_AFTER_ST_PR, 0)
          , o."PERCENT" = coalesce (s.PERCENT_PR, 0)
          , o.VALID_TO = s.TILL_DATE
          , o.DEAL_TYPE_CD = s.DEAL_TYPE_CD
          , o.CURRENCY_CD = s.CCY
          , o.STATUS_CD = s.STATUS
          , o.OPERDAY = s.OPERDAY
        WHEN NOT MATCHED THEN INSERT (
          ACCOUNT_RK
          , DEAL_NUMBER
          , AGREEMENT_NUMBER
          , AC_TO_ST
          , AC_AFTER_ST
          , "PERCENT"
          , VALID_FROM
          , VALID_TO
          , DEAL_TYPE_CD
          , CURRENCY_CD
          , STATUS_CD
          , OPERDAY
        ) VALUES (
          s.ACCOUNT_RK
          , s.AGREEMENT_NUM
          , s.LAW_NUM
          , coalesce (s.AC_TO_ST, 0)
          , coalesce (s.AC_AFTER_ST_PR, 0)
          , coalesce (s.PERCENT_PR, 0)
          , s.FROM_DATE
          , s.TILL_DATE
          , s.DEAL_TYPE_CD
          , s.CCY
          , s.STATUS
          , s.OPERDAY
        );
      END;

END LOAD_OUT_LAYER;
/

COMMIT;
