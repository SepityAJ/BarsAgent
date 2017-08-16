-- ***************************************************************************
--   Таблица CL_CHART - График погашения кредита.
--
--  Столбцы:
--    AGREEMENT_KEY             Внутренний номер договора.
--    EFFECT_DATE               Ожидаемая дата платежа. 
--    TRANCHE_KEY               Внутренний номер транша
--    AMOUNT_DEBT               Сумма выплаты основного долга
--    PERCENT_DEBT              Сумма процентов к выплате
--    AMOUNT_COMMIS             Сумма комиссии за обслуживание
--    AMOUNT_ANNUITY            Сумма аннуитета
--    CREDIT_AMOUNT_REST        Сумма остатка задолженности
--    PAYMENT_STATUS            Статус
--    START_DATE                Дата начала начисления %
--    END_DATE                  Дата окончания начисления %
--    PAYMENT_DATE              Дата оплаты ОС (до какой включительно)
--    PAYMENT_PRC_DATE          Дата оплаты %% (до какой включительно)
--    AMOUNT_DEBT_REST          Остаток оплаты ОС плана
--    PERCENT_DEBT_REST         Остаток оплаты ОС %%
--    DELINQUENCY_RETURN_DATE   Дата окончания просрочки
--    AMOUNT_COMMIS_REST        Остаток оплаты ОС комиссии
--    PAYMENT_COM_DATE          Дата оплаты комиссии (до какой включительно)
--    REAL_DATE                 Дата платежа без учета выходных дней
--    PERCENT_ROUND_DELTA       Дельта округления %% (расчитанного и начисленного)
-- ***************************************************************************

spool TAB_CL_CHART.log

prompt Creating table CL_CHART...

-- Create table
create table CL_CHART
(
  AGREEMENT_KEY           NUMBER(12) not null,
  EFFECT_DATE             DATE not null,
  TRANCHE_KEY             NUMBER(12),
  AMOUNT_DEBT             NUMBER,
  PERCENT_DEBT            NUMBER,
  AMOUNT_COMMIS           NUMBER,
  PAYMENT_STATUS          VARCHAR2(4) default 'П' not null,
  AMOUNT_ANNUITY          NUMBER(18,2),
  CREDIT_AMOUNT_REST      NUMBER(18,2),
  START_DATE              DATE,
  END_DATE                DATE,
  PAYMENT_DATE            DATE,
  PAYMENT_PRC_DATE        DATE,
  AMOUNT_DEBT_REST        NUMBER,
  PERCENT_DEBT_REST       NUMBER,
  DELINQUENCY_RETURN_DATE DATE,
  AMOUNT_COMMIS_REST      NUMBER,
  PAYMENT_COM_DATE        DATE,
  REAL_DATE               DATE,
  PERCENT_ROUND_DELTA     NUMBER,
  INTERNAL_KEY            NUMBER(20) not null
);

-- Add comments to the columns 
comment on column CL_CHART.AGREEMENT_KEY            is 'Дата оплаты просрочки';
comment on column CL_CHART.EFFECT_DATE              is 'Ожидаемая дата платежа.';
comment on column CL_CHART.TRANCHE_KEY              is 'Внутренний номер транша';
comment on column CL_CHART.AMOUNT_DEBT              is 'Сумма выплаты основного долга';
comment on column CL_CHART.PERCENT_DEBT             is 'Сумма процентов к выплате';
comment on column CL_CHART.AMOUNT_COMMIS            is 'Сумма комиссии за обслуживание';
comment on column CL_CHART.PAYMENT_STATUS           is 'Статус П- план,Ф - факт, Р - вынос на просрочку,Н - первоначальный план';
comment on column CL_CHART.AMOUNT_ANNUITY           is 'Сумма аннуитета';
comment on column CL_CHART.CREDIT_AMOUNT_REST       is 'Сумма остатка задолженности';
comment on column CL_CHART.START_DATE               is 'Дата начала начисления %';
comment on column CL_CHART.END_DATE                 is 'Дата окончания начисления %';
comment on column CL_CHART.PAYMENT_DATE             is 'Дата оплаты ОС (до какой включительно)';
comment on column CL_CHART.PAYMENT_PRC_DATE         is 'Дата оплаты %% (до какой включительно)';
comment on column CL_CHART.AMOUNT_DEBT_REST         is 'Остаток оплаты ОС плана';
comment on column CL_CHART.PERCENT_DEBT_REST        is 'Остаток оплаты ОС %%';
comment on column CL_CHART.DELINQUENCY_RETURN_DATE  is 'Дата окончания просрочки';
comment on column CL_CHART.AMOUNT_COMMIS_REST       is 'Остаток оплаты ОС комиссии';
comment on column CL_CHART.PAYMENT_COM_DATE         is 'Дата оплаты комиссии (до какой включительно)';
comment on column CL_CHART.REAL_DATE                is 'Дата платежа без учета выходных дней';
comment on column CL_CHART.PERCENT_ROUND_DELTA      is 'Дельта округления %% (расчитанного и начисленного)';
comment on column CL_CHART.INTERNAL_KEY             is 'Суррогатный уникальный ключ';

-- Create/Recreate primary, unique and foreign key constraints 
alter table CL_CHART
  add constraint CL_CHART_PK primary key (INTERNAL_KEY)
  using index 
  tablespace IDX;

alter table CL_CHART
  add constraint CL_CHART_FK1 foreign key (AGREEMENT_KEY)
  references CL_AGREEMENT (AGREEMENT_KEY);

-- Create/Recreate indexes 
create index CL_CHART_I1 on CL_CHART (AGREEMENT_KEY, EFFECT_DATE, PAYMENT_STATUS)
  tablespace IDXL;

create index CL_CHART_I2 on CL_CHART (AGREEMENT_KEY, EFFECT_DATE, SUBSTR(PAYMENT_STATUS,1,1))
  tablespace IDXL;

create unique index CL_CHART_UI on CL_CHART (AGREEMENT_KEY, EFFECT_DATE, TRANCHE_KEY, PAYMENT_STATUS)
  tablespace IDXL;


spool off
