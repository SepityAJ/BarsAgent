/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 12                       */
/* Created on:     03.03.2017 11:39:11                          */
/*==============================================================*/


if exists(select 1 from sys.sysforeignkey where role='FK_AU_ACTRL_ACT_ACTRL_AU_ACT') then
    alter table AU_ACTRL
       delete foreign key FK_AU_ACTRL_ACT_ACTRL_AU_ACT
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_ACTRL_ROLE_ACTR_AU_ROLE') then
    alter table AU_ACTRL
       delete foreign key FK_AU_ACTRL_ROLE_ACTR_AU_ROLE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_GROUP_ACT_GROUP_AU_ACT') then
    alter table AU_GROUPACT
       delete foreign key FK_AU_GROUP_ACT_GROUP_AU_ACT
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_GROUP_GROUP_GRO_AU_GROUP') then
    alter table AU_GROUPACT
       delete foreign key FK_AU_GROUP_GROUP_GRO_AU_GROUP
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_MENU_MENU_PARE_AU_MENU') then
    alter table AU_MENU
       delete foreign key FK_AU_MENU_MENU_PARE_AU_MENU
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_MENUA_ACT_MENUA_AU_ACT') then
    alter table AU_MENUACT
       delete foreign key FK_AU_MENUA_ACT_MENUA_AU_ACT
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_MENUA_MENU_MENU_AU_MENU') then
    alter table AU_MENUACT
       delete foreign key FK_AU_MENUA_MENU_MENU_AU_MENU
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_PRMVA_PRM_VAL_R_AU_PRM') then
    alter table AU_PRMVAL
       delete foreign key FK_AU_PRMVA_PRM_VAL_R_AU_PRM
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_PRMVA_USER_PRM__AU_USER') then
    alter table AU_PRMVAL
       delete foreign key FK_AU_PRMVA_USER_PRM__AU_USER
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_USRRL_ROLE_USRR_AU_ROLE') then
    alter table AU_USRRL
       delete foreign key FK_AU_USRRL_ROLE_USRR_AU_ROLE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_AU_USRRL_USER_USRR_AU_USER') then
    alter table AU_USRRL
       delete foreign key FK_AU_USRRL_USER_USRR_AU_USER
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_DIC_ACCO_CURRENCY__DIC_CURR') then
    alter table DIC_ACCOUNTS
       delete foreign key FK_DIC_ACCO_CURRENCY__DIC_CURR
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_DIC_ACCO_CUSTOMER__DIC_CUST') then
    alter table DIC_ACCOUNTS
       delete foreign key FK_DIC_ACCO_CUSTOMER__DIC_CUST
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_DIC_CURR_CAL_CURRA_DIC_CAL') then
    alter table DIC_CURRATES
       delete foreign key FK_DIC_CURR_CAL_CURRA_DIC_CAL
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_DIC_CURR_CURRENCY__DIC_CURR') then
    alter table DIC_CURRATES
       delete foreign key FK_DIC_CURR_CURRENCY__DIC_CURR
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_RES_SCHE_REFERENCE_RES_SCHE') then
    alter table RES_SCHEDRLN
       delete foreign key FK_RES_SCHE_REFERENCE_RES_SCHE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_RES_SCHE_REFERENCE_SRC_SCHE') then
    alter table RES_SCHEDRLN
       delete foreign key FK_RES_SCHE_REFERENCE_SRC_SCHE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_RES_SCHE_SCHEDULE__SRC_SCHE') then
    alter table RES_SCHEDRLN
       delete foreign key FK_RES_SCHE_SCHEDULE__SRC_SCHE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_RES_SCHE_RES_SCHED_SRC_DEAL') then
    alter table RES_SCHEDULES
       delete foreign key FK_RES_SCHE_RES_SCHED_SRC_DEAL
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_RES_SCHE_REFERENCE_SRC_DEAL') then
    alter table RES_SCHEDULES
       delete foreign key FK_RES_SCHE_REFERENCE_SRC_DEAL
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_RES_SCHE_RES_SCHED_RES_SCHE') then
    alter table RES_SCHEDULE_FLOWS
       delete foreign key FK_RES_SCHE_RES_SCHED_RES_SCHE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_DEAL_CREDIT_TY_DIC_CRED') then
    alter table SRC_DEALS
       delete foreign key FK_SRC_DEAL_CREDIT_TY_DIC_CRED
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_DEAL_FACILITY__SRC_FACI') then
    alter table SRC_DEALS
       delete foreign key FK_SRC_DEAL_FACILITY__SRC_FACI
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_DEAL_DEAL_PERC_SRC_DEAL') then
    alter table SRC_DEAL_PERCENTS
       delete foreign key FK_SRC_DEAL_DEAL_PERC_SRC_DEAL
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_DLBT_DEAL_DLBT_SRC_DEAL') then
    alter table SRC_DLBTH
       delete foreign key FK_SRC_DLBT_DEAL_DLBT_SRC_DEAL
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_DLRL_ACCOUNT_D_DIC_ACCO') then
    alter table SRC_DLRLN
       delete foreign key FK_SRC_DLRL_ACCOUNT_D_DIC_ACCO
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_DLRL_DEAL_DLRL_SRC_DEAL') then
    alter table SRC_DLRLN
       delete foreign key FK_SRC_DLRL_DEAL_DLRL_SRC_DEAL
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_EVEN_EVENT_TYP_DIC_EVEN') then
    alter table SRC_EVENTS
       delete foreign key FK_SRC_EVEN_EVENT_TYP_DIC_EVEN
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_EVEN_REFERENCE_SRC_DEAL') then
    alter table SRC_EVENTS
       delete foreign key FK_SRC_EVEN_REFERENCE_SRC_DEAL
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_FACI_PARENT_FA_SRC_FACI') then
    alter table SRC_FACILITIES
       delete foreign key FK_SRC_FACI_PARENT_FA_SRC_FACI
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_SCHE_DEAL_SHED_SRC_DEAL') then
    alter table SRC_SCHEDULES
       delete foreign key FK_SRC_SCHE_DEAL_SHED_SRC_DEAL
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_SCHE_SCHEDULE__DIC_SCHE') then
    alter table SRC_SCHEDULES
       delete foreign key FK_SRC_SCHE_SCHEDULE__DIC_SCHE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SRC_SCHE_SCHEDULES_SRC_SCHE') then
    alter table SRC_SCHEDULE_FLOWS
       delete foreign key FK_SRC_SCHE_SCHEDULES_SRC_SCHE
end if;

drop table if exists AU_ACT;

drop table if exists AU_ACTRL;

drop table if exists AU_GROUP;

drop table if exists AU_GROUPACT;

drop table if exists AU_MENU;

drop table if exists AU_MENUACT;

drop table if exists AU_PRM;

drop table if exists AU_PRMVAL;

drop table if exists AU_ROLE;

drop table if exists AU_USER;

drop table if exists AU_USRRL;

drop table if exists DIC_ACCOUNTS;

drop table if exists DIC_CAL;

drop table if exists DIC_CREDIT_TYPE;

drop table if exists DIC_CURRATES;

drop table if exists DIC_CURRENCY;

drop table if exists DIC_CUSTOMERS;

drop table if exists DIC_EVENT_TYPE;

drop table if exists DIC_MARKET_RATES;

drop table if exists DIC_RESTRUCT_TYPE;

drop table if exists DIC_SCHEDULE_TYPE;

drop table if exists RES_SCHEDRLN;

drop table if exists RES_SCHEDULES;

drop table if exists RES_SCHEDULE_FLOWS;

drop table if exists SRC_DEALS;

drop table if exists SRC_DEAL_PERCENTS;

drop table if exists SRC_DLBTH;

drop table if exists SRC_DLRLN;

drop table if exists SRC_EVENTS;

drop table if exists SRC_FACILITIES;

drop table if exists SRC_SCHEDULES;

drop table if exists SRC_SCHEDULE_FLOWS;

drop table if exists WRK_AUDIT;

drop table if exists WRK_SCHED;

/*==============================================================*/
/* Table: AU_ACT                                                */
/*==============================================================*/
create table AU_ACT
(
   ID                   bigint                         null,
   CODE                 varchar                        null,
   "DESC"               varchar                        null
);

comment on table AU_ACT is
'Действия';

/*==============================================================*/
/* Table: AU_ACTRL                                              */
/*==============================================================*/
create table AU_ACTRL
(
   ROLE_ID              bigint                         null,
   ACT_ID               bigint                         null,
   USR_AUT              varchar                        null,
   DAT_AUT              timestamp                      null
);

/*==============================================================*/
/* Table: AU_GROUP                                              */
/*==============================================================*/
create table AU_GROUP
(
   ID                   bigint                         null,
   NAME                 varchar                        null
);

comment on table AU_GROUP is
'Группы действий';

/*==============================================================*/
/* Table: AU_GROUPACT                                           */
/*==============================================================*/
create table AU_GROUPACT
(
   ACT_ID               bigint                         null,
   GROUP_ID             bigint                         null,
   USR_AUT              varchar                        null,
   DAT_AUT              date                           null
);

comment on table AU_GROUPACT is
'Группировка действий';

/*==============================================================*/
/* Table: AU_MENU                                               */
/*==============================================================*/
create table AU_MENU
(
   ID                   bigint                         null,
   NAME                 varchar                        null,
   TYPE                 bigint                         null,
   PARENT_ID            bigint                         null
);

comment on table AU_MENU is
'Пункты меню';

/*==============================================================*/
/* Table: AU_MENUACT                                            */
/*==============================================================*/
create table AU_MENUACT
(
   ACT_ID               bigint                         null,
   MENU_ID              bigint                         null,
   USR_AUT              varchar                        null,
   DAT_AUT              date                           null
);

comment on table AU_MENUACT is
'Связь пунктов меню с действиями';

/*==============================================================*/
/* Table: AU_PRM                                                */
/*==============================================================*/
create table AU_PRM
(
   ID                   bigint                         null,
   CODE                 varchar                        null,
   NAME                 varchar                        null
);

comment on table AU_PRM is
'Справочник параметров';

/*==============================================================*/
/* Table: AU_PRMVAL                                             */
/*==============================================================*/
create table AU_PRMVAL
(
   ID                   bigint                         null,
   USER_ID              bigint                         null,
   PRM_CODE             varchar                        null,
   PRM_VAL              varchar                        null,
   DAT                  date                           null,
   DATTO                date                           null,
   USR_AUT              varchar                        null,
   DAT_AUT              timestamp                      null
);

comment on table AU_PRMVAL is
'Значения параметров для пользователей';

/*==============================================================*/
/* Table: AU_ROLE                                               */
/*==============================================================*/
create table AU_ROLE
(
   ID                   bigint                         null,
   ROLE_NAME            varchar                        null
);

comment on table AU_ROLE is
'Роли';

/*==============================================================*/
/* Table: AU_USER                                               */
/*==============================================================*/
create table AU_USER
(
   ID                   bigint                         null,
   NAME                 varchar(255)                   null,
   PWD                  varchar(30)                    null
);

comment on table AU_USER is
'Пользователи';

/*==============================================================*/
/* Table: AU_USRRL                                              */
/*==============================================================*/
create table AU_USRRL
(
   USER_ID              bigint                         null,
   ROLE_ID              bigint                         null,
   USR_AUT              varchar                        null,
   DAT_AUT              timestamp                      null
);

comment on table AU_USRRL is
'Вхождение пользователей в роли';

/*==============================================================*/
/* Table: DIC_ACCOUNTS                                          */
/*==============================================================*/
create table DIC_ACCOUNTS
(
   ID                   bigint                         null,
   ACID                 char(20)                       null,
   BSAACID              char(20)                       null,
   AC_TYPE              bigint                         null,
   CCY                  char(3)                        null,
   CNUM                 char(8)                        null
);

comment on table DIC_ACCOUNTS is
'Счета (справочник)';

/*==============================================================*/
/* Table: DIC_CAL                                               */
/*==============================================================*/
create table DIC_CAL
(
   DAT                  date                           null,
   HOL                  char(1)                        null,
   CCY                  char(3)                        null
);

comment on table DIC_CAL is
'Календарь (справочник)';

/*==============================================================*/
/* Table: DIC_CREDIT_TYPE                                       */
/*==============================================================*/
create table DIC_CREDIT_TYPE
(
   DAT                  date                           null,
   DATTO                date                           null,
   ID                   bigint                         null,
   NAME                 varchar(100)                   null
);

comment on table DIC_CREDIT_TYPE is
'Типы кредитов (справочник)';

/*==============================================================*/
/* Table: DIC_CURRATES                                          */
/*==============================================================*/
create table DIC_CURRATES
(
   DAT                  date                           null,
   CCY                  char(3)                        null,
   RATE                 decimal(15,9)                  null,
   AMNT                 decimal(6,2)                   null,
   RATE0                decimal(15,9)                  null
);

comment on table DIC_CURRATES is
'Курсы валют (справочник)';

/*==============================================================*/
/* Table: DIC_CURRENCY                                          */
/*==============================================================*/
create table DIC_CURRENCY
(
   GLCCY                char(3)                        null,
   CBCCY                char(3)                        null,
   CYNMEN               varchar(14)                    null,
   CYNM                 varchar(35)                    null,
   NBDP                 numeric(1)                     null,
   DAT                  date                           null
);

comment on table DIC_CURRENCY is
'Валюты (справочник)';

/*==============================================================*/
/* Table: DIC_CUSTOMERS                                         */
/*==============================================================*/
create table DIC_CUSTOMERS
(
   CUSTOMER_NO          varchar(8)                     null,
   CUSTOMER_NAME        varchar(500)                   null,
   CUSTOMER_TYPE        bigint                         null
);

comment on table DIC_CUSTOMERS is
'Клиенты (справочник)';

/*==============================================================*/
/* Table: DIC_EVENT_TYPE                                        */
/*==============================================================*/
create table DIC_EVENT_TYPE
(
   DAT                  date                           null,
   DATTO                date                           null,
   ID                   bigint                         null,
   NAME                 varchar(100)                   null
);

comment on table DIC_EVENT_TYPE is
'Типы событий (справочник)';

/*==============================================================*/
/* Table: DIC_MARKET_RATES                                      */
/*==============================================================*/
create table DIC_MARKET_RATES
(
   ID                   bigint                         null
);

comment on table DIC_MARKET_RATES is
'Рыночные ставки (справочник)';

/*==============================================================*/
/* Table: DIC_RESTRUCT_TYPE                                     */
/*==============================================================*/
create table DIC_RESTRUCT_TYPE
(
   DAT                  date                           null,
   DATTO                date                           null,
   ID                   bigint                         null,
   NAME                 varchar(100)                   null
);

comment on table DIC_RESTRUCT_TYPE is
'Типы реструктуризации (справочник)';

/*==============================================================*/
/* Table: DIC_SCHEDULE_TYPE                                     */
/*==============================================================*/
create table DIC_SCHEDULE_TYPE
(
   DAT                  date                           null,
   DATTO                date                           null,
   ID                   bigint                         null,
   NAME                 varchar(100)                   null
);

comment on table DIC_SCHEDULE_TYPE is
'Типы графиков (справочник)';

/*==============================================================*/
/* Table: RES_SCHEDRLN                                          */
/*==============================================================*/
create table RES_SCHEDRLN
(
   RES_ID               bigint                         null,
   SRC_ID               bigint                         null
);

comment on table RES_SCHEDRLN is
'Связь результирующего графика с исходными';

/*==============================================================*/
/* Table: RES_SCHEDULES                                         */
/*==============================================================*/
create table RES_SCHEDULES
(
   ID                   bigint                         null,
   DEAL_ID              bigint                         null,
   TYPE                 bigint                         null,
   CCY                  char(3)                        null
);

comment on table RES_SCHEDULES is
'Результирующие графики';

/*==============================================================*/
/* Table: RES_SCHEDULE_FLOWS                                    */
/*==============================================================*/
create table RES_SCHEDULE_FLOWS
(
   SCHEDULE_ID          bigint                         null,
   VDAT                 date                           null,
   PAY                  decimal                        null,
   DUE                  decimal                        null,
   DUE_INT_OD           decimal                        null,
   DUE_INT_DUE_OD       decimal                        null,
   AS_BEFORE            decimal                        null,
   AS_AFTER             decimal                        null,
   PROGIT_INT           decimal                        null,
   DUE_INT_EFS          decimal                        null,
   AS_AFTER_DUE         decimal                        null,
   PROFIT_INT_DUE       decimal                        null,
   EPS                  decimal                        null
);

comment on table RES_SCHEDULE_FLOWS is
'Движения по результирующим графикам';

/*==============================================================*/
/* Table: SRC_DEALS                                             */
/*==============================================================*/
create table SRC_DEALS
(
   ID                   bigint                         null,
   SOURCE_NUM           varchar(30)                    null,
   SOURCE_ID            varchar(30)                    null,
   FACILITY_ID          bigint                         null,
   CCY                  char(3)                        null,
   FILIAL               char(4)                        null,
   PRC_BASE             date                           null,
   PRC_TYPE             bigint                         null,
   CR_START             date                           null,
   CR_END_PLAN          date                           null,
   CR_END_FACT          date                           null,
   CR_TYPE              bigint                         null,
   SOURCE               varchar                        null
);

comment on table SRC_DEALS is
'Сделки';

/*==============================================================*/
/* Table: SRC_DEAL_PERCENTS                                     */
/*==============================================================*/
create table SRC_DEAL_PERCENTS
(
   ID                   bigint                         null,
   DEAL_ID              bigint                         null,
   DAT                  date                           null,
   DATTO                date                           null,
   PERCENT              decimal                        null
);

comment on table SRC_DEAL_PERCENTS is
'Проценты по сделке';

/*==============================================================*/
/* Table: SRC_DLBTH                                             */
/*==============================================================*/
create table SRC_DLBTH
(
   DAT                  date                           null,
   DATTO                date                           null,
   DATL                 date                           null,
   BSAACID              char(20)                       null,
   DLID                 bigint                         null,
   OBAC                 decimal                        null,
   DTAC                 decimal                        null,
   CTAC                 decimal                        null,
   OBBC                 decimal                        null,
   DTBC                 decimal                        null,
   CTBC                 decimal                        null,
   LYCBAC               decimal                        null,
   YDCAC                decimal                        null,
   YCCBC                decimal                        null,
   SDTSUM               decimal                        null,
   SDTPROC              decimal                        null,
   SDTTERM              decimal                        null,
   YDSAC                decimal                        null
);

comment on table SRC_DLBTH is
'Остатки в разрезе сделок';

/*==============================================================*/
/* Table: SRC_DLRLN                                             */
/*==============================================================*/
create table SRC_DLRLN
(
   ACCOUNT_ID           bigint                         null,
   DEAL_ID              bigint                         null
);

comment on table SRC_DLRLN is
'Связи счетов со сделками';

/*==============================================================*/
/* Table: SRC_EVENTS                                            */
/*==============================================================*/
create table SRC_EVENTS
(
   ID                   bigint                         null,
   DEAL_ID              bigint                         null,
   DAT                  date                           null,
   CREATED              timestamp                      null,
   TYPE                 bigint                         null
);

comment on table SRC_EVENTS is
'События';

/*==============================================================*/
/* Table: SRC_FACILITIES                                        */
/*==============================================================*/
create table SRC_FACILITIES
(
   ID                   bigint                         null,
   LAW_NUM              varchar(30)                    null,
   SOURCE_NUM           varchar(30)                    null,
   SOURCE_ID            varchar(30)                    null,
   REVL                 char(1)                        null,
   RESTRUCT             char(1)                        null,
   ORG                  varchar(30)                    null,
   PARENT_ID            bigint                         null,
   DAT                  date                           null,
   TYPE                 varchar                        null,
   DATTO                date                           null,
   PLAN_DATTO           date                           null,
   SOURCE               varchar                        null
);

comment on table SRC_FACILITIES is
'Фасилити (договоры)';

/*==============================================================*/
/* Table: SRC_SCHEDULES                                         */
/*==============================================================*/
create table SRC_SCHEDULES
(
   ID                   bigint                         null,
   DEAL_ID              bigint                         null,
   TYPE                 bigint                         null
);

comment on table SRC_SCHEDULES is
'Графики';

/*==============================================================*/
/* Table: SRC_SCHEDULE_FLOWS                                    */
/*==============================================================*/
create table SRC_SCHEDULE_FLOWS
(
   SCHEDULE_ID          bigint                         null,
   DAT                  date                           null,
   PAYMENT              decimal                        null,
   TYPE                 bigint                         null,
   CCY                  char(3)                        null
);

comment on table SRC_SCHEDULE_FLOWS is
'Движения по графикам';

/*==============================================================*/
/* Table: WRK_AUDIT                                             */
/*==============================================================*/
create table WRK_AUDIT
(
   ID                   bigint                         null,
   SYSDATE              date                           null,
   SYSTIME              time                           null,
   USER_NAME            varchar(64)                    null,
   USER_HOST            varchar(64)                    null,
   LOG_CODE             varchar(64)                    null,
   LOG_LEVEL            varchar(8)                     null,
   "MESSAGE"            varchar(512)                   null,
   ERRORMSG             varchar(4000)                  null,
   STCK_TRACE           clob                           null,
   ENTITY_ID            varchar(128)                   null,
   ENTITY_TYPE          varchar(256)                   null,
   TRANSACT_ID          varchar(512)                   null,
   SRC                  varchar(512)                   null,
   ERROR_SRC            varchar(4000)                  null,
   ATTACHMENT           clob                           null,
   PROCTIMEMS           integer                        null
);

comment on table WRK_AUDIT is
'Аудит';

/*==============================================================*/
/* Table: WRK_SCHED                                             */
/*==============================================================*/
create table WRK_SCHED
(
   ID                   bigint                         null,
   NAME                 varchar(255)                   null,
   PROPS                varchar(1000)                  null,
   "DESC"               varchar(512)                   null,
   STATE                varchar(64)                    null,
   STR_TYPE             varchar(64)                    null,
   SCH_TYPE             varchar(64)                    null,
   RUN_CLS              varchar(512)                   null,
   DELAY                bigint                         null,
   INTERVAL             bigint                         null,
   SCH_EXPR             varchar(512)                   null
);

comment on table WRK_SCHED is
'Задачи';

alter table AU_ACTRL
   add constraint FK_AU_ACTRL_ACT_ACTRL_AU_ACT foreign key (ACT_ID)
      references AU_ACT (ID)
      on update restrict
      on delete restrict;

alter table AU_ACTRL
   add constraint FK_AU_ACTRL_ROLE_ACTR_AU_ROLE foreign key (ROLE_ID)
      references AU_ROLE (ID)
      on update restrict
      on delete restrict;

alter table AU_GROUPACT
   add constraint FK_AU_GROUP_ACT_GROUP_AU_ACT foreign key (ACT_ID)
      references AU_ACT (ID)
      on update restrict
      on delete restrict;

alter table AU_GROUPACT
   add constraint FK_AU_GROUP_GROUP_GRO_AU_GROUP foreign key (GROUP_ID)
      references AU_GROUP (ID)
      on update restrict
      on delete restrict;

alter table AU_MENU
   add constraint FK_AU_MENU_MENU_PARE_AU_MENU foreign key (PARENT_ID)
      references AU_MENU (ID)
      on update restrict
      on delete restrict;

alter table AU_MENUACT
   add constraint FK_AU_MENUA_ACT_MENUA_AU_ACT foreign key (ACT_ID)
      references AU_ACT (ID)
      on update restrict
      on delete restrict;

alter table AU_MENUACT
   add constraint FK_AU_MENUA_MENU_MENU_AU_MENU foreign key (MENU_ID)
      references AU_MENU (ID)
      on update restrict
      on delete restrict;

alter table AU_PRMVAL
   add constraint FK_AU_PRMVA_PRM_VAL_R_AU_PRM foreign key (PRM_CODE)
      references AU_PRM (CODE)
      on update restrict
      on delete restrict;

alter table AU_PRMVAL
   add constraint FK_AU_PRMVA_USER_PRM__AU_USER foreign key (USER_ID)
      references AU_USER (ID)
      on update restrict
      on delete restrict;

alter table AU_USRRL
   add constraint FK_AU_USRRL_ROLE_USRR_AU_ROLE foreign key (ROLE_ID)
      references AU_ROLE (ID)
      on update restrict
      on delete restrict;

alter table AU_USRRL
   add constraint FK_AU_USRRL_USER_USRR_AU_USER foreign key (USER_ID)
      references AU_USER (ID)
      on update restrict
      on delete restrict;

alter table DIC_ACCOUNTS
   add constraint FK_DIC_ACCO_CURRENCY__DIC_CURR foreign key (CCY)
      references DIC_CURRENCY (CBCCY)
      on update restrict
      on delete restrict;

alter table DIC_ACCOUNTS
   add constraint FK_DIC_ACCO_CUSTOMER__DIC_CUST foreign key (CNUM)
      references DIC_CUSTOMERS (CUSTOMER_NO)
      on update restrict
      on delete restrict;

alter table DIC_CURRATES
   add constraint FK_DIC_CURR_CAL_CURRA_DIC_CAL foreign key (DAT)
      references DIC_CAL (DAT)
      on update restrict
      on delete restrict;

alter table DIC_CURRATES
   add constraint FK_DIC_CURR_CURRENCY__DIC_CURR foreign key (CCY)
      references DIC_CURRENCY (GLCCY)
      on update restrict
      on delete restrict;

alter table RES_SCHEDRLN
   add constraint FK_RES_SCHE_REFERENCE_RES_SCHE foreign key (RES_ID)
      references RES_SCHEDULES (ID)
      on update restrict
      on delete restrict;

alter table RES_SCHEDRLN
   add constraint FK_RES_SCHE_REFERENCE_SRC_SCHE foreign key (RES_ID)
      references SRC_SCHEDULES (ID)
      on update restrict
      on delete restrict;

alter table RES_SCHEDRLN
   add constraint FK_RES_SCHE_SCHEDULE__SRC_SCHE foreign key (RES_ID)
      references SRC_SCHEDULES (ID)
      on update restrict
      on delete restrict;

alter table RES_SCHEDULES
   add constraint FK_RES_SCHE_RES_SCHED_SRC_DEAL foreign key (DEAL_ID)
      references SRC_DEALS (ID)
      on update restrict
      on delete restrict;

alter table RES_SCHEDULES
   add constraint FK_RES_SCHE_REFERENCE_SRC_DEAL foreign key (DEAL_ID)
      references SRC_DEALS (ID)
      on update restrict
      on delete restrict;

alter table RES_SCHEDULE_FLOWS
   add constraint FK_RES_SCHE_RES_SCHED_RES_SCHE foreign key (SCHEDULE_ID)
      references RES_SCHEDULES (ID)
      on update restrict
      on delete restrict;

alter table SRC_DEALS
   add constraint FK_SRC_DEAL_CREDIT_TY_DIC_CRED foreign key (CR_TYPE)
      references DIC_CREDIT_TYPE (ID)
      on update restrict
      on delete restrict;

alter table SRC_DEALS
   add constraint FK_SRC_DEAL_FACILITY__SRC_FACI foreign key (FACILITY_ID)
      references SRC_FACILITIES (ID)
      on update restrict
      on delete restrict;

alter table SRC_DEAL_PERCENTS
   add constraint FK_SRC_DEAL_DEAL_PERC_SRC_DEAL foreign key (DEAL_ID)
      references SRC_DEALS (ID)
      on update restrict
      on delete restrict;

alter table SRC_DLBTH
   add constraint FK_SRC_DLBT_DEAL_DLBT_SRC_DEAL foreign key (DLID)
      references SRC_DEALS (ID)
      on update restrict
      on delete restrict;

alter table SRC_DLRLN
   add constraint FK_SRC_DLRL_ACCOUNT_D_DIC_ACCO foreign key (ACCOUNT_ID)
      references DIC_ACCOUNTS (ID)
      on update restrict
      on delete restrict;

alter table SRC_DLRLN
   add constraint FK_SRC_DLRL_DEAL_DLRL_SRC_DEAL foreign key (DEAL_ID)
      references SRC_DEALS (ID)
      on update restrict
      on delete restrict;

alter table SRC_EVENTS
   add constraint FK_SRC_EVEN_EVENT_TYP_DIC_EVEN foreign key (TYPE)
      references DIC_EVENT_TYPE (ID)
      on update restrict
      on delete restrict;

alter table SRC_EVENTS
   add constraint FK_SRC_EVEN_REFERENCE_SRC_DEAL foreign key (DEAL_ID)
      references SRC_DEALS (ID)
      on update restrict
      on delete restrict;

alter table SRC_FACILITIES
   add constraint FK_SRC_FACI_PARENT_FA_SRC_FACI foreign key (PARENT_ID)
      references SRC_FACILITIES (ID)
      on update restrict
      on delete restrict;

alter table SRC_SCHEDULES
   add constraint FK_SRC_SCHE_DEAL_SHED_SRC_DEAL foreign key (DEAL_ID)
      references SRC_DEALS (ID)
      on update restrict
      on delete restrict;

alter table SRC_SCHEDULES
   add constraint FK_SRC_SCHE_SCHEDULE__DIC_SCHE foreign key (TYPE)
      references DIC_SCHEDULE_TYPE (ID)
      on update restrict
      on delete restrict;

alter table SRC_SCHEDULE_FLOWS
   add constraint FK_SRC_SCHE_SCHEDULES_SRC_SCHE foreign key (SCHEDULE_ID)
      references SRC_SCHEDULES (ID)
      on update restrict
      on delete restrict;

