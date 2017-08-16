spool TAB_CL_ER_INFORM.log

prompt Creating table CL_ER_INFORM ...

-- -----------------------------------------------------------------(table)---
--  CL_ER_INFORM - Таблица типов платежей
-- ---------------------------------------------------------------------------

create table Cl_ER_Inform(
        Agreement_key number      not null
      , Value_Date    date        not null
      , Amount        number      not null
      , Amount_type   varchar2(2) not null CHECK( Amount_type  in ('КР','СП','ПК'))
);

COMMENT ON COLUMN Cl_ER_Inform.Agreement_key IS 'Внутренний номер договора';
COMMENT ON COLUMN Cl_ER_Inform.Value_Date    IS 'Дата валлютирования';
COMMENT ON COLUMN Cl_ER_Inform.Amount        IS 'Сумма';
COMMENT ON COLUMN Cl_ER_Inform.Amount_type   IS 'КР - сумма кредита, СП - страховые платежи, ПК - прочие коммиссии';

create index Cl_ER_Inform_I1
       on Cl_ER_Inform (Agreement_key, Value_Date);
       
alter table Cl_ER_Inform
   add constraint Cl_ER_Inform_01
   unique (Agreement_key, Value_Date, Amount_type) 
   using index tablespace IDX
/

spool off
