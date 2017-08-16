-- ----------------------------------------------------------------------
-- This package contains procedures to load data
-- from DWH showcase to the Stage Layer of the Dismod Database
-- It is expected that DWH showcase is mapped to Dismod schema
-- via DbLink
-- ----------------------------------------------------------------------
CREATE OR REPLACE PACKAGE LOAD_STAGE_LAYER AS
--    PROCEDURE LOAD_CURRATES_FROM_DWH;
--    PROCEDURE LOAD_CALENDAR_FROM_DWH;
    PROCEDURE LOAD_UNIT_FROM_DWH (STREAM VARCHAR2);
    PROCEDURE LOAD_CLORG_FROM_DWH (STREAM VARCHAR2);
    PROCEDURE LOAD_CLIND_FROM_DWH (STREAM VARCHAR2);
    PROCEDURE LOAD_FACILITY_FROM_DWH (STREAM VARCHAR2);
    PROCEDURE LOAD_DEAL_FROM_DWH (STREAM VARCHAR2);
    PROCEDURE LOAD_ACCOUNT_FROM_DWH (STREAM VARCHAR2);
    PROCEDURE LOAD_SALDO_FROM_DWH (STREAM VARCHAR2);
    PROCEDURE LOAD_CHART_FROM_DWH (STREAM VARCHAR2);
    PROCEDURE LOAD_CHANGE_FROM_DWH (STREAM VARCHAR2);
    PROCEDURE LOAD_EVENT_FROM_DWH (STREAM VARCHAR2);
END LOAD_STAGE_LAYER;
/
CREATE OR REPLACE PACKAGE BODY LOAD_STAGE_LAYER AS

--    PROCEDURE LOAD_CURRATES_FROM_DWH IS
--      BEGIN
--        INSERT /*+ append */ INTO STG_CURRATES S (
--            S.CCY_NM,
--            S.CCY_NOM,
--            S.MID_RATE,
--            S.CCY_NUM_CODE,
--            S.CCY_ALPHA_CODE,
--            S.ON_DATE
--        ) SELECT
--            W.CCY_NM,
--            W.CCY_NOM,
--            W.MID_RATE,
--            W.CCY_NUM_CODE,
--            W.CCY_ALPHA_CODE,
--            W.ON_DATE
--          FROM DWH.CURRATES W;
--      END;
--
--    PROCEDURE LOAD_CALENDAR_FROM_DWH IS
--      BEGIN
--        INSERT /*+ append */ INTO STG_CAL S (
--            S.CAL_DATE,
--            S.CCY,
--            S.HOLIDAY_FLAG,
--            S.RELEVANCE_DTTM
--        ) SELECT
--            W.CAL_DATE,
--            W.CCY,
--            W.HOLIDAY_FLAG,
--            W.RELEVANCE_DTTM
--          FROM DWH.CAL W;
--      END;

--  create or replace
    PROCEDURE LOAD_UNIT_FROM_DWH (STREAM IN VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
            INSERT /*+ append */ INTO STG_TUNIT S (
                S.UNIT_RK,
                S.INTERNAL_ORG_ID,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID,
                S.SOURCE_SYSTEM_CD
            ) SELECT
                W.UNIT_RK,
                W.INTERNAL_ORG_ID,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID,
                W.SOURCE_SYSTEM_CD
              FROM TUNIT@DWH06.IMB.RU W;
        ELSE
            INSERT /*+ append */ INTO STG_TUNIT S (
                S.UNIT_RK,
                S.INTERNAL_ORG_ID,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID,
                S.SOURCE_SYSTEM_CD
            ) SELECT
                W.UNIT_RK,
                W.INTERNAL_ORG_ID,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID,
                W.SOURCE_SYSTEM_CD
              FROM TUNIT@DWH06.IMB.RU W
              WHERE W.STREAM_ID = STREAM;
         END IF;
      END;

--  create or replace
    PROCEDURE LOAD_CLORG_FROM_DWH (STREAM VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
          INSERT /*+ append */ INTO STG_TCLORG S (
              S.CUSTOMER_RK,
              S.CUSTOMER_NM,
              S.LEGAL_ENTITY_NM,
              S.RESIDENT_FLG,
              S.TYPE_OWNERSHIP_CD,
              S.CNUM,
              S.SOURCE_SYSTEM_CD,
              S.VALID_FROM_DTTM,
              S.VALID_TO_DTTM,
              S.PROCESSED_DTTM,
              S.STREAM_ID
          ) SELECT
              W.CUSTOMER_RK,
              W.CUSTOMER_NM,
              W.LEGAL_ENTITY_NM,
              W.RESIDENT_FLG,
              W.TYPE_OWNERSHIP_CD,
              W.CNUM,
              W.SOURCE_SYSTEM_CD,
              W.VALID_FROM_DTTM,
              W.VALID_TO_DTTM,
              W.PROCESSED_DTTM,
              W.STREAM_ID
            FROM TCLORG@DWH06.IMB.RU W;
        ELSE
          INSERT /*+ append */ INTO STG_TCLORG S (
              S.CUSTOMER_RK,
              S.CUSTOMER_NM,
              S.LEGAL_ENTITY_NM,
              S.RESIDENT_FLG,
              S.TYPE_OWNERSHIP_CD,
              S.CNUM,
              S.SOURCE_SYSTEM_CD,
              S.VALID_FROM_DTTM,
              S.VALID_TO_DTTM,
              S.PROCESSED_DTTM,
              S.STREAM_ID
          ) SELECT
              W.CUSTOMER_RK,
              W.CUSTOMER_NM,
              W.LEGAL_ENTITY_NM,
              W.RESIDENT_FLG,
              W.TYPE_OWNERSHIP_CD,
              W.CNUM,
              W.SOURCE_SYSTEM_CD,
              W.VALID_FROM_DTTM,
              W.VALID_TO_DTTM,
              W.PROCESSED_DTTM,
              W.STREAM_ID
            FROM TCLORG@DWH06.IMB.RU W
            WHERE W.STREAM_ID = STREAM;
        END IF;
      END;

--  create or replace
    PROCEDURE LOAD_CLIND_FROM_DWH (STREAM VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
          INSERT /*+ append */ INTO STG_TCLIND S (
              S.CUSTOMER_RK,
              S.CUSTOMER_FIRST_NM,
              S.CUSTOMER_MID_NM,
              S.CUSTOMER_LAST_NM,
              S.RESIDENT_FLG,
              S.TYPE_OWNERSHIP_CD,
              S.CNUM,
              S.SOURCE_SYSTEM_CD,
              S.VALID_FROM_DTTM,
              S.VALID_TO_DTTM,
              S.PROCESSED_DTTM,
              S.STREAM_ID
          ) SELECT
              W.CUSTOMER_RK,
              W.CUSTOMER_FIRST_NM,
              W.CUSTOMER_MID_NM,
              W.CUSTOMER_LAST_NM,
              W.RESIDENT_FLG,
              W.TYPE_OWNERSHIP_CD,
              W.CNUM,
              W.SOURCE_SYSTEM_CD,
              W.VALID_FROM_DTTM,
              W.VALID_TO_DTTM,
              W.PROCESSED_DTTM,
              W.STREAM_ID
            FROM TCLIND@DWH06.IMB.RU W;
        ELSE
          INSERT /*+ append */ INTO STG_TCLIND S (
              S.CUSTOMER_RK,
              S.CUSTOMER_FIRST_NM,
              S.CUSTOMER_MID_NM,
              S.CUSTOMER_LAST_NM,
              S.RESIDENT_FLG,
              S.TYPE_OWNERSHIP_CD,
              S.CNUM,
              S.SOURCE_SYSTEM_CD,
              S.VALID_FROM_DTTM,
              S.VALID_TO_DTTM,
              S.PROCESSED_DTTM,
              S.STREAM_ID
          ) SELECT
              W.CUSTOMER_RK,
              W.CUSTOMER_FIRST_NM,
              W.CUSTOMER_MID_NM,
              W.CUSTOMER_LAST_NM,
              W.RESIDENT_FLG,
              W.TYPE_OWNERSHIP_CD,
              W.CNUM,
              W.SOURCE_SYSTEM_CD,
              W.VALID_FROM_DTTM,
              W.VALID_TO_DTTM,
              W.PROCESSED_DTTM,
              W.STREAM_ID
            FROM TCLIND@DWH06.IMB.RU W
            WHERE W.STREAM_ID = STREAM;
        END IF;
      END;

--  create or replace
    PROCEDURE LOAD_FACILITY_FROM_DWH (STREAM VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
          INSERT /*+ append */ INTO STG_TFACILITY S (
              S.ACCOUNT_RK,
              S.VALUE_DT,
              S.MATURITY_DT,
              S.STATUS_CD,
              S.DEAL_TYPE_CD,
              S.DEAL_NO,
              S.AGREEMENT_NM,
              S.ALTERNATE_NM,
              S.CNUM,
              S.SOURCE_SYSTEM_CD,
              S.CURRENCY_CD,
              S.LOAN_ORIGINAL_AMT,
              S.PRODUCT_CODE,
              S.PRODUCT_RK,
              S.REVOLVING_FLG,
              S.BRANCH_CODE,
              S.VALID_FROM_DTTM,
              S.VALID_TO_DTTM,
              S.PROCESSED_DTTM,
              S.STREAM_ID
          ) SELECT
              W.ACCOUNT_RK,
              W.VALUE_DT,
              W.MATURITY_DT,
              'STB',--W.STATUS_CD,
              W.DEAL_TYPE_CD,
              W.DEAL_NO,
              W.AGREEMENT_NM,
              W.ALTERNATE_NM,
              W.CNUM,
              W.SOURCE_SYSTEM_CD,
              W.CURRENCY_CD,
              W.LOAN_ORIGINAL_AMT,
              W.PRODUCT_CODE,
              W.PRODUCT_RK,
              W.REVOLVING_FLG,
              W.BRANCH_CODE,
              W.VALID_FROM_DTTM,
              W.VALID_TO_DTTM,
              W.PROCESSED_DTTM,
              W.STREAM_ID
            FROM TFACILITY@DWH06.IMB.RU W;
        ELSE
          INSERT /*+ append */ INTO STG_TFACILITY S (
              S.ACCOUNT_RK,
              S.VALUE_DT,
              S.MATURITY_DT,
              S.STATUS_CD,
              S.DEAL_TYPE_CD,
              S.DEAL_NO,
              S.AGREEMENT_NM,
              S.ALTERNATE_NM,
              S.CNUM,
              S.SOURCE_SYSTEM_CD,
              S.CURRENCY_CD,
              S.LOAN_ORIGINAL_AMT,
              S.PRODUCT_CODE,
              S.PRODUCT_RK,
              S.REVOLVING_FLG,
              S.BRANCH_CODE,
              S.VALID_FROM_DTTM,
              S.VALID_TO_DTTM,
              S.PROCESSED_DTTM,
              S.STREAM_ID
          ) SELECT
              W.ACCOUNT_RK,
              W.VALUE_DT,
              W.MATURITY_DT,
              'STB',--W.STATUS_CD,
              W.DEAL_TYPE_CD,
              W.DEAL_NO,
              W.AGREEMENT_NM,
              W.ALTERNATE_NM,
              W.CNUM,
              W.SOURCE_SYSTEM_CD,
              W.CURRENCY_CD,
              W.LOAN_ORIGINAL_AMT,
              W.PRODUCT_CODE,
              W.PRODUCT_RK,
              W.REVOLVING_FLG,
              W.BRANCH_CODE,
              W.VALID_FROM_DTTM,
              W.VALID_TO_DTTM,
              W.PROCESSED_DTTM,
              W.STREAM_ID
            FROM TFACILITY@DWH06.IMB.RU W
            WHERE W.STREAM_ID = STREAM;
        END IF;
      END;

--  create or replace
    PROCEDURE LOAD_DEAL_FROM_DWH (STREAM VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
            INSERT /*+ append */ INTO STG_TLOANDEAL S (
                S.ACCOUNT_RK,
                S.VALUE_DT,
                S.MATURITY_DT,
                S.STATUS_CD,
                S.DEAL_TYPE_CD,
                S.DEAL_NO,
                S.AGREEMENT_NM,
                S.ALTERNATE_NM,
                S.CNUM,
                S.SOURCE_SYSTEM_CD,
                S.CURRENCY_CD,
                S.LOAN_ORIGINAL_AMT,
                S.PRODUCT_CODE,
                S.PRODUCT_RK,
                S.REVOLVING_FLG,
                S.BRANCH_CODE,
                S.FACILITY_RK,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.ACCOUNT_RK,
                W.VALUE_DT,
                W.MATURITY_DT,
                W.STATUS_CD,
                W.DEAL_TYPE_CD,
                W.DEAL_NO,
                W.AGREEMENT_NM,
                W.ALTERNATE_NM,
                W.CNUM,
                W.SOURCE_SYSTEM_CD,
                W.CURRENCY_CD,
                W.LOAN_ORIGINAL_AMT,
                W.PRODUCT_CODE,
                W.PRODUCT_RK,
                W.REVOLVING_FLG,
                W.BRANCH_CODE,
                W.FACILITY_RK,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TLOANDEAL@DWH06.IMB.RU W;
        ELSE
            INSERT /*+ append */ INTO STG_TLOANDEAL S (
                S.ACCOUNT_RK,
                S.VALUE_DT,
                S.MATURITY_DT,
                S.STATUS_CD,
                S.DEAL_TYPE_CD,
                S.DEAL_NO,
                S.AGREEMENT_NM,
                S.ALTERNATE_NM,
                S.CNUM,
                S.SOURCE_SYSTEM_CD,
                S.CURRENCY_CD,
                S.LOAN_ORIGINAL_AMT,
                S.PRODUCT_CODE,
                S.PRODUCT_RK,
                S.REVOLVING_FLG,
                S.BRANCH_CODE,
                S.FACILITY_RK,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.ACCOUNT_RK,
                W.VALUE_DT,
                W.MATURITY_DT,
                W.STATUS_CD,
                W.DEAL_TYPE_CD,
                W.DEAL_NO,
                W.AGREEMENT_NM,
                W.ALTERNATE_NM,
                W.CNUM,
                W.SOURCE_SYSTEM_CD,
                W.CURRENCY_CD,
                W.LOAN_ORIGINAL_AMT,
                W.PRODUCT_CODE,
                W.PRODUCT_RK,
                W.REVOLVING_FLG,
                W.BRANCH_CODE,
                W.FACILITY_RK,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TLOANDEAL@DWH06.IMB.RU W
              WHERE W.STREAM_ID = STREAM;
        END IF;
      END;

--  create or replace
    PROCEDURE LOAD_ACCOUNT_FROM_DWH (STREAM VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
            INSERT /*+ append */ INTO STG_TACCOUNT S (
                S.GL_ACCOUNT_RK,
                S.GL_ACCOUNT_NUMBER,
                S.CURRENCY_CD,
                S.CNUM,
                S.ACCOUNT_TYPE_CD,
                S.ACCOUNT_RK,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID,
                S.SOURCE_SYSTEM_CD
            ) SELECT
                W.GL_ACCOUNT_RK,
                W.GL_ACCOUNT_NUMBER,
                W.CURRENCY_CD,
                W.CNUM,
                W.ACCOUNT_TYPE_CD,
                W.ACCOUNT_RK,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID,
                W.SOURCE_SYSTEM_CD
              FROM TACCOUNT@DWH06.IMB.RU W;
        ELSE
            INSERT /*+ append */ INTO STG_TACCOUNT S (
                S.GL_ACCOUNT_RK,
                S.GL_ACCOUNT_NUMBER,
                S.CURRENCY_CD,
                S.CNUM,
                S.ACCOUNT_TYPE_CD,
                S.ACCOUNT_RK,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID,
                S.SOURCE_SYSTEM_CD
            ) SELECT
                W.GL_ACCOUNT_RK,
                W.GL_ACCOUNT_NUMBER,
                W.CURRENCY_CD,
                W.CNUM,
                W.ACCOUNT_TYPE_CD,
                W.ACCOUNT_RK,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID,
                W.SOURCE_SYSTEM_CD
              FROM TACCOUNT@DWH06.IMB.RU W
              WHERE W.STREAM_ID = STREAM;
        END IF;
      END;

--  create or replace
    PROCEDURE LOAD_SALDO_FROM_DWH (STREAM VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
            INSERT /*+ append */ INTO STG_TACCOUNT_SALDO S (
                S.GL_ACCOUNT_RK,
                S.BAL_AMT,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.GL_ACCOUNT_RK,
                W.BAL_AMT,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TACCOUNT_SALDO@DWH06.IMB.RU W;
        ELSE
            INSERT /*+ append */ INTO STG_TACCOUNT_SALDO S (
                S.GL_ACCOUNT_RK,
                S.BAL_AMT,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.GL_ACCOUNT_RK,
                W.BAL_AMT,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TACCOUNT_SALDO@DWH06.IMB.RU W
              WHERE W.STREAM_ID = STREAM;
         END IF;
      END;

    PROCEDURE LOAD_CHART_FROM_DWH (STREAM VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
            INSERT /*+ append */ INTO STG_TCHART S (
                S.ACCOUNT_RK,
                S.PAYMENT_DT,
                S.CURRENCY_CD,
                S.PAYMENT_AMT,
                S.SOURCE_SYSTEM_CD,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.ACCOUNT_RK,
                W.PAYMENT_DT,
                W.CURRENCY_CD,
                W.PAYMENT_AMT,
                W.SOURCE_SYSTEM_CD,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM   ,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TCHART@DWH06.IMB.RU W;
        ELSE
            INSERT /*+ append */ INTO STG_TCHART S (
                S.ACCOUNT_RK,
                S.PAYMENT_DT,
                S.CURRENCY_CD,
                S.PAYMENT_AMT,
                S.SOURCE_SYSTEM_CD,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.ACCOUNT_RK,
                W.PAYMENT_DT,
                W.CURRENCY_CD,
                W.PAYMENT_AMT,
                W.SOURCE_SYSTEM_CD,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM   ,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TCHART@DWH06.IMB.RU W
              WHERE W.STREAM_ID = STREAM;
        END IF;
      END;

    PROCEDURE LOAD_CHANGE_FROM_DWH (STREAM VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
            INSERT /*+ append */ INTO STG_TDEALCHNG S (
                S.ACCOUNT_RK,
                S.PAST_DUE_AMT,
                S.PAST_DUE_INT_AMT,
                S.MAIN_INT_OVERDUE_AMT,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.ACCOUNT_RK,
                W.PAST_DUE_AMT,
                W.PAST_DUE_INT_AMT,
                W.MAIN_INT_OVERDUE_AMT,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TDEALCHNG@DWH06.IMB.RU W;
        ELSE
            INSERT /*+ append */ INTO STG_TDEALCHNG S (
                S.ACCOUNT_RK,
                S.PAST_DUE_AMT,
                S.PAST_DUE_INT_AMT,
                S.MAIN_INT_OVERDUE_AMT,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.ACCOUNT_RK,
                W.PAST_DUE_AMT,
                W.PAST_DUE_INT_AMT,
                W.MAIN_INT_OVERDUE_AMT,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TDEALCHNG@DWH06.IMB.RU W
              WHERE W.STREAM_ID = STREAM;
        END IF;
      END;

    PROCEDURE LOAD_EVENT_FROM_DWH (STREAM VARCHAR2) IS
      BEGIN
        IF STREAM IS NULL THEN
            INSERT /*+ append */ INTO STG_TLOANEVENT S (
                S.FACILITY_RK,
                S.FACILITY_ID,
                S.AGREENEMT_NM,
                S.ORIGINAL_FACILITY_ID,
                S.ORIGINAL_FACILITY_RK,
--                S.LOAN_ACCOUNT_ID,
                S.LOAN_ACCOUNT_RK,
                S.PREV_LOAN_ACCOUNT_ID,
                S.PREV_LOAN_ACCOUNT_RK,
                S.ORIGINAL_LOAN_ACCOUNT_ID,
                S.ORIGINAL_LOAN_ACCOUNT_RK,
                S.COMPONENT_NM,
                S.EXECUTE_DT,
                S.EVENT_DT,
                S.EVENT_CODE_CD,
                S.RESTRUCTURING_NM,
                S.RESTR_TYPE_NM,
                S.PAYMENT_AMT,
                S.SOURCE_SYSTEM_CD,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.FACILITY_RK,
                W.FACILITY_ID,
                W.AGREENEMT_NM,
                W.ORIGINAL_FACILITY_ID,
                W.ORIGINAL_FACILITY_RK,
--                W.LOAN_ACCOUNT_ID,
                W.LOAN_ACCOUNT_RK,
                W.PREV_LOAN_ACCOUNT_ID,
                W.PREV_LOAN_ACCOUNT_RK,
                W.ORIGINAL_LOAN_ACCOUNT_ID,
                W.ORIGINAL_LOAN_ACCOUNT_RK,
                W.COMPONENT_NM,
                W.EXECUTE_DT,
                W.EVENT_DT,
                W.EVENT_CODE_CD,
                W.RESTRUCTURING_NM,
                W.RESTR_TYPE_NM,
                W.PAYMENT_AMT,
                W.SOURCE_SYSTEM_CD,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TLOANEVENT@DWH06.IMB.RU W;
        ELSE
            INSERT /*+ append */ INTO STG_TLOANEVENT S (
                S.FACILITY_RK,
                S.FACILITY_ID,
                S.AGREENEMT_NM,
                S.ORIGINAL_FACILITY_ID,
                S.ORIGINAL_FACILITY_RK,
--                S.LOAN_ACCOUNT_ID,
                S.LOAN_ACCOUNT_RK,
                S.PREV_LOAN_ACCOUNT_ID,
                S.PREV_LOAN_ACCOUNT_RK,
                S.ORIGINAL_LOAN_ACCOUNT_ID,
                S.ORIGINAL_LOAN_ACCOUNT_RK,
                S.COMPONENT_NM,
                S.EXECUTE_DT,
                S.EVENT_DT,
                S.EVENT_CODE_CD,
                S.RESTRUCTURING_NM,
                S.RESTR_TYPE_NM,
                S.PAYMENT_AMT,
                S.SOURCE_SYSTEM_CD,
                S.VALID_FROM_DTTM,
                S.VALID_TO_DTTM,
                S.PROCESSED_DTTM,
                S.STREAM_ID
            ) SELECT
                W.FACILITY_RK,
                W.FACILITY_ID,
                W.AGREENEMT_NM,
                W.ORIGINAL_FACILITY_ID,
                W.ORIGINAL_FACILITY_RK,
--                W.LOAN_ACCOUNT_ID,
                W.LOAN_ACCOUNT_RK,
                W.PREV_LOAN_ACCOUNT_ID,
                W.PREV_LOAN_ACCOUNT_RK,
                W.ORIGINAL_LOAN_ACCOUNT_ID,
                W.ORIGINAL_LOAN_ACCOUNT_RK,
                W.COMPONENT_NM,
                W.EXECUTE_DT,
                W.EVENT_DT,
                W.EVENT_CODE_CD,
                W.RESTRUCTURING_NM,
                W.RESTR_TYPE_NM,
                W.PAYMENT_AMT,
                W.SOURCE_SYSTEM_CD,
                W.VALID_FROM_DTTM,
                W.VALID_TO_DTTM,
                W.PROCESSED_DTTM,
                W.STREAM_ID
              FROM TLOANEVENT@DWH06.IMB.RU W
              WHERE W.STREAM_ID = STREAM;
        END IF;
      END;
--
--    PROCEDURE LOAD__FROM_DWH IS
--      BEGIN
--        INSERT /*+ append */ INTO STG_ S (
--            S.*
--        ) SELECT
--            W.*
--          FROM DWH. W;
--      END;
--
END;
/
COMMIT;

