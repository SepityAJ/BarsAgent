CREATE OR REPLACE PACKAGE LOAD_DATA_LAYER AS
   PROCEDURE LOAD_CALENDAR_FROM_STAGE (STREAM VARCHAR2);
   PROCEDURE LOAD_BRANCH_FROM_STAGE (STREAM VARCHAR2);
   PROCEDURE LOAD_CUSTOMERS_FROM_CLIND (STREAM VARCHAR2);
   PROCEDURE LOAD_CUSTOMERS_FROM_CLORG (STREAM VARCHAR2);
   PROCEDURE LOAD_FACILITIES_FROM_STAGE (STREAM VARCHAR2);
   PROCEDURE LOAD_DEALS_FROM_STAGE (STREAM VARCHAR2);
   --TODO
   PROCEDURE LOAD_SCHEDULES_FROM_STAGE (STREAM VARCHAR2);
   PROCEDURE LOAD_BALANCES_FROM_STAGE (STREAM VARCHAR2);
   PROCEDURE LOAD_FLOWS_FROM_STAGE (STREAM VARCHAR2);
   PROCEDURE LOAD_EVENTS_FROM_STAGE (STREAM VARCHAR2);
   PROCEDURE LOAD_OVERDUE_FROM_STAGE (STREAM VARCHAR2);
   PROCEDURE LOAD_ACCOUNT_FROM_STAGE (STREAM VARCHAR2);
   --
END LOAD_DATA_LAYER;
/
CREATE OR REPLACE PACKAGE BODY LOAD_DATA_LAYER AS

--  create or replace
    PROCEDURE LOAD_CALENDAR_FROM_STAGE (STREAM IN VARCHAR2) IS
      BEGIN
        MERGE INTO DIC_CAL d
          USING (
            SELECT
              CAL_DATE
              , CCY
              , HOLIDAY_FLAG
            FROM STG_CAL
          ) s
          ON (d.DAT = s.CAL_DATE AND d.CCY=s.CCY)
          WHEN MATCHED THEN UPDATE SET
            d.HOL = s.HOLIDAY_FLAG
          WHEN NOT MATCHED THEN INSERT (
            DAT
            , CCY
            , HOL
          ) VALUES (
            s.CAL_DATE
            , s.CCY
            , s.HOLIDAY_FLAG
          );
      END;

--  create or replace
    PROCEDURE LOAD_BRANCH_FROM_STAGE (STREAM IN VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
            MERGE INTO DIC_BRANCH_DWH d
              USING (
                SELECT
                  UNIT_RK
                  , INTERNAL_ORG_ID
                  , INTERNAL_ORG_ID as BRANCH
                  , SOURCE_SYSTEM_CD
                FROM STG_TUNIT
              ) s
              ON (d.BRANCH_ID = s.UNIT_RK)
              WHEN MATCHED THEN UPDATE SET
                d.INTERNAL_ORG_ID = s.INTERNAL_ORG_ID
                , d.BRANCH = s.BRANCH
                , d.SOURCE_SYSTEM = s.SOURCE_SYSTEM_CD
              WHEN NOT MATCHED THEN INSERT (
                BRANCH_ID
                , INTERNAL_ORG_ID
                , BRANCH
                , SOURCE_SYSTEM
              ) VALUES (
                s.UNIT_RK
                , s.INTERNAL_ORG_ID
                , s.BRANCH
                , s.SOURCE_SYSTEM_CD
              );
        ELSE
            MERGE INTO DIC_BRANCH_DWH d
              USING (
                SELECT
                  UNIT_RK
                  , INTERNAL_ORG_ID
                  , INTERNAL_ORG_ID as BRANCH
                  , SOURCE_SYSTEM_CD
                FROM STG_TUNIT
                WHERE STREAM_ID = STREAM
              ) s
              ON (d.BRANCH_ID = s.UNIT_RK)
              WHEN MATCHED THEN UPDATE SET
                d.INTERNAL_ORG_ID = s.INTERNAL_ORG_ID
                , d.BRANCH = s.BRANCH
                , d.SOURCE_SYSTEM = s.SOURCE_SYSTEM_CD
              WHEN NOT MATCHED THEN INSERT (
                BRANCH_ID
                , INTERNAL_ORG_ID
                , BRANCH
                , SOURCE_SYSTEM
              ) VALUES (
                s.UNIT_RK
                , s.INTERNAL_ORG_ID
                , s.BRANCH
                , s.SOURCE_SYSTEM_CD
              );
        END IF;
      END;

--  create or replace
    PROCEDURE LOAD_CUSTOMERS_FROM_CLIND (STREAM IN VARCHAR2) IS
      BEGIN
        MERGE INTO DIC_CUSTOMER d
          USING (
            SELECT
              CNUM
              , TRIM(CUSTOMER_LAST_NM || ' ' || CUSTOMER_FIRST_NM || ' ' || CUSTOMER_MID_NM) as nm
              , TYPE_OWNERSHIP_CD
              , CASE WHEN RESIDENT_FLG = '1' THEN NULL ELSE '1' END as flg
              , CUSTOMER_RK
              , 'IND'
            FROM STG_TCLIND WHERE CNUM != NULL
                ) s
          ON (d.EXTERNAL_RK = s.CUSTOMER_RK AND d.SOURCE_CD='IND')
          WHEN MATCHED THEN UPDATE SET
            d.CUSTOMER_NO = s.CNUM
            , d.CUSTOMER_NAME = s.nm
            , d.CUSTOMER_TYPE = s.TYPE_OWNERSHIP_CD
            , d.NONRESIDENT = flg
          WHEN NOT MATCHED THEN INSERT (
            CUSTOMER_NO
            , CUSTOMER_NAME
            , CUSTOMER_TYPE
            , NONRESIDENT
            , EXTERNAL_RK
            , SOURCE_CD
          ) VALUES (
            s.CNUM
            , s.nm
            , s.TYPE_OWNERSHIP_CD
            , s.flg
            , s.CUSTOMER_RK
            , 'IND'
          );
      END;

--  create or replace
    PROCEDURE LOAD_CUSTOMERS_FROM_CLORG (STREAM IN VARCHAR2) IS
      BEGIN
        MERGE INTO DIC_CUSTOMER d
          USING (
            SELECT
              CNUM
              , TRIM(LEGAL_ENTITY_NM || ' ' || CUSTOMER_NM) as nm
              , TYPE_OWNERSHIP_CD
              , CASE WHEN RESIDENT_FLG = '1' THEN NULL ELSE '1' END as flg
              , CUSTOMER_RK
              , 'ORG'
            FROM STG_TCLORG WHERE CNUM != NULL
          ) s
          ON (d.EXTERNAL_RK = s.CUSTOMER_RK AND d.SOURCE_CD='ORG')
          WHEN MATCHED THEN UPDATE SET
            d.CUSTOMER_NO = s.CNUM
            , d.CUSTOMER_NAME = s.nm
            , d.CUSTOMER_TYPE = s.TYPE_OWNERSHIP_CD
            , d.NONRESIDENT = flg
          WHEN NOT MATCHED THEN INSERT (
            CUSTOMER_NO
            , CUSTOMER_NAME
            , CUSTOMER_TYPE
            , NONRESIDENT
            , EXTERNAL_RK
            , SOURCE_CD
          ) VALUES (
            s.CNUM
            , s.nm
            , s.TYPE_OWNERSHIP_CD
            , s.flg
            , s.CUSTOMER_RK
            , 'ORG'
          );
      END;

  PROCEDURE LOAD_FACILITIES_FROM_STAGE (STREAM IN VARCHAR2) IS
    BEGIN
      MERGE INTO SRC_FACILITY d
      USING (
              SELECT
                ACCOUNT_RK
                , REGISTRATION_NM
                , OPEN_DT
                , SRC_ACCOUNT_ID
                , ALTERNATE_NM
                , REVOLVING_FLG
                , PRODUCT_CODE_MD
                , PRODUCT_RK
                , CASE WHEN ACCOUNT_STATUS_CD = 'C' THEN CLOSE_DT ELSE NULL END AS end_date
                , CASE WHEN ACCOUNT_STATUS_CD = 'A' THEN CLOSE_DT ELSE NULL END AS close_dat
                , ACCOUNT_STATUS_CD
                , SOURCE
              FROM STG_TLOANDEAL WHERE FIN_TYPE = 'FAC' AND OPEN_DT IS NOT NULL AND SOURCE IS NOT NULL
            ) s
      ON (d.ACCOUNT_RK = s.ACCOUNT_RK)
      WHEN MATCHED THEN UPDATE SET
        d.LAW_NUM = s.REGISTRATION_NM
        , d.OPEN_DAT = s.OPEN_DT
        , d.AGREEMENT_NUM = s.SRC_ACCOUNT_ID
        , d.ALTERNATE_NUM = s.ALTERNATE_NM
        , d.REVOLVING_FLG = s.REVOLVING_FLG
        , d.PRODUCT_CODE_MD = s.PRODUCT_CODE_MD
        , d.PRODUCT_ID = s.PRODUCT_RK
        , d.END_DATE = s.end_date
        , d.CLOSE_DAT = s.close_dat
        , d.STATUS = s.ACCOUNT_STATUS_CD
        , d.SOURCE = s.SOURCE
      WHEN NOT MATCHED THEN INSERT (
        ID_
        , LAW_NUM
        , OPEN_DAT
        , AGREEMENT_NUM
        , ALTERNATE_NUM
        , ACCOUNT_RK
        , REVOLVING_FLG
        , PRODUCT_CODE_MD
        , PRODUCT_ID
        , END_DATE
        , CLOSE_DAT
        , STATUS
        , SOURCE
      ) VALUES (
        SEQ_ID_SRC_FACILITY.nextval
        , s.REGISTRATION_NM
        , s.OPEN_DT
        , s.SRC_ACCOUNT_ID
        , s.ALTERNATE_NM
        , s.ACCOUNT_RK
        , s.REVOLVING_FLG
        , s.PRODUCT_CODE_MD
        , s.PRODUCT_RK
        , s.end_date
        , s.close_dat
        , s.ACCOUNT_STATUS_CD
        , s.SOURCE
      );
    END;

  PROCEDURE LOAD_DEALS_FROM_STAGE (STREAM IN VARCHAR2) IS
    BEGIN
      MERGE INTO SRC_DEAL d
      USING (
              SELECT
                ACCOUNT_RK
                , REGISTRATION_NM
                , OPEN_DT
                , CLOSE_DT
                , ACCOUNT_STATUS_CD
                , CCY
                , SRC_ACCOUNT_ID
                , FACILITY_RK
                , BRANCH
                , PRODUCT_CODE_MD
                , PRODUCT_RK
                , SOURCE
              FROM STG_TLOANDEAL WHERE FIN_TYPE <> 'FAC' AND OPEN_DT IS NOT NULL AND SOURCE IS NOT NULL
            ) s
      ON (d.GL_ACCOUNT_RK = s.GL_ACCOUNT_RK)
      WHEN MATCHED THEN UPDATE SET
        d.OPEN_DAT = s.OPEN_DT
        , d.END_DATE = CASE WHEN ACCOUNT_STATUS_CD = 'C' THEN s.CLOSE_DT ELSE NULL END
        , d.CLOSE_DAT = CASE WHEN ACCOUNT_STATUS_CD = 'A' THEN s.CLOSE_DT ELSE NULL END
        , d.STATUS = s.ACCOUNT_STATUS_CD
        , d.CCY = s.CCY
        , d.AGREEMENT_NUM = CASE WHEN s.SOURCE = 'F12' THEN s.SRC_ACCOUNT_ID END
        , d.FACILITY_ID = s.FACILITY_RK
        , d.BRANCH = s.BRANCH
        , d.PRODUCT_CODE_MD = s.PRODUCT_CODE_MD
        , d.PRODUCT_ID = s.PRODUCT_RK
        , d.SOURCE = s.SOURCE
      WHEN NOT MATCHED THEN INSERT (
        ID_
        , OPEN_DAT
        , END_DATE
        , CLOSE_DAT
        , STATUS
        , CCY
        , AGREEMENT_NUM
        , ACCOUNT_RK
        , FACILITY_ID
        , BRANCH
        , PRODUCT_CODE_MD
        , PRODUCT_ID
        , SOURCE
      ) VALUES (
        SEQ_ID_SRC_DEAL.nextval
        , s.OPEN_DT
        , CASE WHEN ACCOUNT_STATUS_CD = 'C' THEN s.CLOSE_DT END
        , CASE WHEN ACCOUNT_STATUS_CD = 'A' THEN s.CLOSE_DT END
        , s.ACCOUNT_STATUS_CD
        , s.CCY
        , s.SRC_ACCOUNT_ID
        , s.ACCOUNT_RK
        , s.FACILITY_RK
        , s.BRANCH
        , s.PRODUCT_CODE_MD
        , s.PRODUCT_RK
        , s.SOURCE
      );
    END;

    PROCEDURE LOAD_EVENTS_FROM_STAGE (STREAM IN VARCHAR2) IS
        BEGIN
            SELECT NULL FROM DUAL;
        END;

    PROCEDURE LOAD_OVERDUE_FROM_STAGE (STREAM IN VARCHAR2) IS
        BEGIN
            SELECT NULL FROM DUAL;
        END;

    PROCEDURE LOAD_ACCOUNT_FROM_STAGE (STREAM IN VARCHAR2) IS
        BEGIN
            SELECT NULL FROM DUAL;
        END;

END LOAD_DATA_LAYER;
/

COMMIT;
