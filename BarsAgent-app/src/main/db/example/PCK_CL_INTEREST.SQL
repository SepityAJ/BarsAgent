-- ***************************************************************************
--## Пакет CL_INTEREST - Расчет сумм резервирования и графика погашения.
--##   . . .
--
--   $Workfile::                                                             $
--   $Revision: 1.47 $
--     $Author: chernov $
--       $Date: 2012/05/23 10:26:40 $
--
--# Процедуры и функции:
--#   Get_Agr_Amount             - расчет суммы договора на дату расчета
--#   Get_Reserve_Amount         - расчет суммы подлежащей резервированию
--#   Get_Reserve_Amount_IfKey   - расчет суммы подлежащей резервированию 
--#                                по параметру номер договора
--#   Get_Delta                  - расчитывает разницу между текущей сумма 
--#                                резерва и  расчитанным резервом на run_date
--#   Cl_Plan_Interest_Calculate - расчет процентов для планового графика
--#   Cl_Flat_Interest           - вычисление суммы процентов в соответствии с
--#                                пропорциональным методом
--#   . . .
--# Пояснения:
--#   . . .
--
-- ***************************************************************************

spool PCK_CL_INTEREST.log

prompt Creating package CL_INTEREST...

create or replace package CL_INTEREST as

   -- Расчет рублевого эквивалента суммы в валюте по курсу ЦБ
   function RUR_EQ( pAmount in number,
                    pCCY    in varchar2,
                    pDate   in date
                  ) return number;

   pragma restrict_references (RUR_EQ, WNDS, WNPS );

   -- расчет суммы договора на дату расчета
   function Get_Agr_Amount(p_agreement_key      in number
                          ,p_type_reserve       in varchar2
                          ,p_run_date           in date     default null ) return number;

   pragma restrict_references (Get_Agr_Amount, WNDS, WNPS );

   -- расчет коэф. резервирования
   function Get_Reserve_Factor
    (p_agreement_key    in number
    ,p_type_reserve     in varchar2
    ,p_run_date         in date     default null) return number;

   pragma restrict_references (Get_Reserve_Factor, WNDS, WNPS );

   -- расчет суммы подлежащей резервированию
   function  Get_Reserve_Amount
    (p_agreement        in CL_AGREEMENT %ROWTYPE
    ,p_type_reserve     in varchar2
    ,p_run_date         in date     default null
    ,p_risk_group       in varchar2 default null
    ) return number;

   pragma restrict_references (Get_Reserve_Amount, WNDS );

   -- расчет суммы подлежащей резервированию по параметру номер договора
   function  Get_Reserve_Amount_IfKey
    (p_agreement_key    in number
    ,p_type_reserve     in varchar2
    ,p_run_date         in date     default null) return number;

   pragma restrict_references (Get_Reserve_Amount_IfKey, WNDS );

   -- расчитывает разницу между текущей сумма резерва и расчитанным резервом
   -- на run_date
   function  Get_Delta
    (p_agreement_key    in  number ,
     p_run_date         in  date   default null ) return number;

   pragma restrict_references (Get_Delta, WNDS );

   -- Проверка необходимости расчета резерва
   function Check_Reserve_agr(
     p_agreement_key    in number
    ,p_ccy              in varchar2
    ,p_type_reserve     in varchar2
    ,p_run_date         in date) return varchar2;

   pragma restrict_references (Check_Reserve_agr, WNDS, WNPS );

   -- расчет процентов для планового графика
   function Cl_Plan_Interest_Calculate
    (p_int_type         in  varchar2,
     p_effect_date      in  date,
     p_ccy              in  varchar2,
     p_int_rate         in  number,
     p_balance          in  number,
     p_start_date       in  date,
     p_end_date         in  date) return number;

   pragma restrict_references (Cl_Plan_Interest_Calculate, WNDS);

   -- вычисление суммы процентов в соответствии с пропорциональным методом
   function Cl_Flat_Interest
    (p_int_rate         in  number,
     p_days_between     in  number,
     p_day_basis        in  number,
     p_balance          in  number) return number;

   pragma restrict_references (Cl_Flat_Interest, RNDS, RNPS, WNDS, WNPS);

   -- расчет суммы подлежащей резервированию по параметрам номер портфеля и б/с
   procedure Calc_Reserve_Case ( pCase_Id       in cl_agreement.case_id%type,
                                 pBal_Acct      in Varchar2,
                                 pType_Reserve  in Varchar2,
                                 pRun_Date      in Date,
                                 pRes_Acct_Key  out gl_account.internal_key%Type,
                                 pRes_Calc      out Number
                               );

   -- Проверка необходимости расчета резерва по портфелю однородных ссуд
   function Check_Reserve_Case( pCase_Id in cl_agreement.case_id%type,
                                pType_Reserve  in Varchar2,
                                pRun_Date      in Date
                              ) Return Varchar2;

   pragma restrict_references (Check_Reserve_Case, WNDS, WNPS);

   -- расчет суммы, подлежащей резервированию, при выносе на просрочку.
   function  Get_Reserve_Removal
    (p_agreement_key    in number
    ,p_Amount           in number
    ,p_run_date         in date     default null) return number;

   -- расчет справедливой стоимости для кред. договоров.
   procedure Calc_Fair_Value( pAgreement_Key in number );

   -- расчет эффективной ставки
   procedure Calculate_IRR( pn_Agreement_Key   in  Number
                           ,pn_Eff_Rate        out Number
                          );


end CL_INTEREST;
/

show errors package CL_INTEREST

prompt Creating package body CL_INTEREST...

create or replace package body CL_INTEREST as

  --=========================================================================
  -- Расчет рублевого эквивалента суммы в валюте по курсу ЦБ
  --=========================================================================
  function RUR_EQ( pAmount in number,
                   pCCY    in varchar2,
                   pDate   in date
                 ) return number
  is
    vRUR_Sum  number;
  begin
    vRUR_Sum := round(pAmount * fm_ccy_rate_all(pCCY, pDate, 'CENTRAL_BANK_RATE'), 2);
    Return (vRUR_Sum);
  end;


  --=========================================================================
  --## Функция CL_INTEREST.Get_Agr_Amount - расчет суммы договора на дату расчета
  --##
  --# Входные параметры:
  --#   p_agreement_key  - ключ договора(О);
  --#   p_type_reserve   - тип резерва:  О - основной,
  --#                                    П - просрочки,
  --#                                    Т - текущие %%,
  --#                                    С - просроченные %%,
  --#                                    В - внебаланс,
  --#                                    Ш - штрафы.
  --#   p_run_date       - дата резервирования(Н = run_date системы);
  --# Возвращаемые значения:
  --#   Сумма подлежащая резервированию;
  --# Директивы:
  --#   pragma restrict_references (Get_Agr_Amount, WNDS, WNPS );
  --# Необрабатываемые исключения:
  --=========================================================================
  function Get_Agr_Amount(p_agreement_key    in number
                         ,p_type_reserve     in varchar2
                         ,p_run_date         in date     default null ) return number
   is
     cursor c_trn( p_agreement_key number,
                   p_reserve_type  varchar2,
                   p_credit_line   varchar2 ) is
       select c.account_key
       from cl_agreement_acct c, cl_agr_acct_res a
       where c.agreement_key = p_agreement_key
         and a.reserve_type  = p_reserve_type
         and NVL(a.credit_line, p_credit_line) = p_credit_line
         and c.acct_category = a.acct_category;
     --
     v_error            varchar2(100);                         -- Сообщение об ошибке
     v_run_date         fm_system.run_date              %type; -- Дата расчета резерва
     v_amount           cl_agreement.amount             %type; -- Сумма по договору на дату расчета
     v_credit_line      cl_agreement.credit_line        %type; -- Тип кредита
   begin
      v_amount := 0;
      -- Если дата расчета резерва не указана во входном параметре p_run_date
      -- то считаем ее равной текущей системной дате
      v_error := 'Системные параметры.';
      if p_run_date is null then
         select run_date into v_run_date from fm_system;
      else
         v_run_date := p_run_date;
      end if;
      --
      -- Определим тип кредита
      v_error := 'Договор не найден!';
      select a.credit_line
      into v_credit_line
      from cl_agreement a
      where a.agreement_key = p_agreement_key;
      --
      -- Расчет суммы на дату резервирования
      v_error := 'Расчет суммы резерва!';
      for r in c_trn(p_agreement_key, p_type_reserve, v_credit_line) loop
        v_amount := v_amount + cl_agr_attr.Get_Acct_Amount_Date(r.account_key, v_run_date);
      end loop;
      --
      return v_amount;
   exception
     when others then
      raise_application_error( -20001,v_error);
   end Get_Agr_Amount;


  --=========================================================================
  --## Функция CL_INTEREST.Get_Reserve_Factor - расчет коэффициента резерва
  --##
  --# Входные параметры:
  --#   p_agreement_key- внутренний номер договора(О);
  --#   p_type_reserve - тип резерва (О - основной, П - просрочки, В - внебаланса)
  --#   p_run_date     - дата резервирования(О);
  --#
  --# Возвращаемые значения:
  --#   Коэффициент резервирования;
  --# Директивы:
  --#   pragma restrict_references (Get_Reserve_Factor, WNDS, WNPS );
  --# Необрабатываемые исключения:
  --=========================================================================
  function Get_Reserve_Factor
    (p_agreement_key    in number
    ,p_type_reserve     in varchar2
    ,p_run_date         in date     default null) return number
   is
     cursor c_factor( p_Date in date ) is
       select nvl(f.factor_category,0)  Factor_category
             ,nvl(f.amount,0)           Amount_FV
             ,f.ccy                     Ccy_FV
       from CL_FAIR_VALUE f
       where f.agreement_key = p_agreement_key
         and f.change_date   = p_Date;
     --
     vRun_date           date;
     vCcy                cl_agreement.ccy                 %type; /* Валюта договора*/
     vFair_value         number;   /* Справедливая стоимость в рублях*/
     vCcy_amt            number;
     vLcy_amt            number;
     vSum                number := 0;
     vLast_Fair_Date     date;
     --
     vRes_factor         number;
   begin
     --
     if p_type_reserve in ('Ш','К') then
       Return 1;  -- Всегда так
     end if;
     --
     vRun_date := p_run_date;
     if vRun_date is null then
        select run_date into vRun_date from fm_system;
     end if;
     --
     -- Определение даты, за которую будем искать справедливую стоимость
     select max(f.change_date)
     into vLast_Fair_Date
     from cl_fair_value f
     where f.agreement_key = p_agreement_key
       and f.change_date <= vRun_date;
     --
     for r in c_factor(vLast_Fair_Date) loop
       -- Справедливая стоимость в рублях
       vFair_value := r.Amount_FV * fm_ccy_rate_all(r.Ccy_FV,vRun_Date,'CENTRAL_BANK_RATE');
       vFair_value := round(NVL(vFair_value, 0), 2);
       --
       vSum := vSum + NVL(r.Factor_category * vFair_value, 0);
     end loop;
     --
     if vSum = 0 then
       return 1;
     end if;
     --
     -- Оперделение параметров договора
     select a.ccy
     into vCcy
     from cl_agreement a
     where a.agreement_key = p_agreement_key;
     --
     -- Остаток в валюте
     vCcy_amt := NVL(Get_Agr_Amount(p_agreement_key,'О',vRun_date), 0) +
                 NVL(Get_Agr_Amount(p_agreement_key,'П',vRun_date), 0);
     -- Остаток в покрытии
     vLcy_amt := round(vCcy_amt * fm_ccy_rate_all(vCcy,vRun_date,'CENTRAL_BANK_RATE'),2);

     --
     if p_type_reserve = 'В' then    -- Внебаланс
       vSum := vSum - vLcy_amt;
       if vSum <= 0 then
         return 1;
       else
         -- Перерасчитываем vLcy_amt
         vLcy_amt := round(NVL(Get_Agr_Amount(p_agreement_key,'В',vRun_date), 0) *
                           fm_ccy_rate_all(vCcy,vRun_date,'CENTRAL_BANK_RATE'),2);
       end if;
     end if;
     -- защита от деления на 0
     if vLcy_amt = 0 then
       return 1;
     end if;
     --
     vRes_factor := 1 - vSum/vLcy_amt;
     if vRes_factor < 0 then
       return 0;
     elsif vRes_factor > 1 then
       return 1;
     else
       return vRes_factor;
     end if;
   end Get_Reserve_Factor;


  --=========================================================================
  --## Функция CL_INTEREST.Get_Reserve_Amount - расчет суммы подлежащей
  --## резервированию по параметру строки кредитного договора;
  --# Входные параметры:
  --#   p_agreement    - строчка договора(О);
  --#   p_type_reserve   - тип резерва:  О - основной,
  --#                                    П - просрочки,
  --#                                    Т - текущие %%,
  --#                                    С - просроченные %%,
  --#                                    В - внебаланс,
  --#                                    Ш - штрафы,
  --#                                    К - комиссии.
  --#   p_run_date     - дата резервирования(Н = run_date системы);
  --#   p_risk_group   - группа риска (новая)
  --# Возвращаемые значения:
  --#   Сумма подлежащая резервированию;
  --# Директивы:
  --#   pragma restrict_references (Get_Reserve_Amount, WNDS, WNPS );
  --# Необрабатываемые исключения:
  --=========================================================================
   function  Get_Reserve_Amount
    (p_agreement        in CL_AGREEMENT %ROWTYPE
    ,p_type_reserve     in varchar2
    ,p_run_date         in date     default null
    ,p_risk_group       in varchar2 default null
    ) return number
   is
      --
      -- Переменные функции
      --
      v_risk_group      cl_agreement.risk_group         %type; -- Группа риска на дату расчета
      v_error           varchar2(100);                         -- Сообщение об ошибке
      v_risk_rate       fm_int_rate.actual_rate         %type; -- Процентная ставка по резервированию
      v_case_id         cl_agreement.case_id            %type; -- Портфель на дату расчёта
      v_ccy             fm_currency.ccy                 %type; -- Код валюты для расчета суммы
      v_ccy_rate        fm_currency.central_bank_rate   %type; -- Курс валюты на дату расчета
      v_amount          cl_agreement.amount             %type; -- Сумма по договору на дату расчета
      v_reserve_amount  number := 0;
      v_run_date        date;
   begin
      -- сумма
      v_error := 'Сумма договора.';
      v_amount :=cl_interest.Get_Agr_Amount(p_agreement.agreement_key
                                           ,p_type_reserve
                                           ,p_run_date);
      v_error := 'Системные параметры.';
      if p_run_date is null then
         select run_date into v_run_date from fm_system;
      else
         v_run_date := p_run_date;
      end if;
      --
      -- Определим портфель договора
      v_error := 'Портфель. ';
      v_case_id := cl_agr_attr.Get_CASE_ID_Seq( p_agreement.agreement_key, v_run_date );
      --
      -- Определение процентной ставки
      if v_case_id is null then
        -- Вытащим группу риска
        if p_risk_group is null then
          v_error := 'Группа риска';
          v_risk_group := cl_agr_attr.Get_Risk_Group_Seq( p_agreement.agreement_key, v_run_date );
        else
          v_risk_group := p_risk_group;
        end if;
      else
        v_risk_group := null;
      end if;
      --
      -- Теперь по группе риска или коду портфеля (что-то одно) найдем
      -- процентную ставку на дату резервирования
      v_error := 'Процентная ставка по группе риска/портфелю.';
      v_risk_rate := cl_agr_attr.get_risk_prc( p_agreement.agreement_key,
                                               v_risk_group,
                                               v_run_date,
                                               v_case_id,
                                               p_type_reserve
                                             );
      --
      if p_type_reserve in ('Ш','К') then
         v_error := 'Валюта (тип резерва: '||p_type_reserve||')';
         begin
            select a.ccy
            into   v_ccy
            from   gl_account a, cl_agreement_acct c, cl_agr_acct_res r
            where  r.reserve_type  = p_type_reserve
              and  c.agreement_key = p_agreement.agreement_key
              and  c.acct_category = r.acct_category
              and  a.internal_key  = c.account_key;
         exception
            when no_data_found then
               v_ccy := p_agreement.ccy;
         end;
      else
         v_ccy := p_agreement.ccy;
      end if;
      --
      -- Узнаем курс валюты на дату резервирования
      v_ccy_rate := fm_ccy_rate_all ( v_ccy, v_run_date, 'CENTRAL_BANK_RATE');
      --
      -- Теперь все готово для расчета суммы резерва
      v_reserve_amount := round(
                            round( round(v_ccy_rate * v_amount, 2) * v_risk_rate / 100, 2) *
                            Get_Reserve_Factor(p_agreement.agreement_key
                                              ,p_type_reserve
                                              ,p_run_date)
                             ,2);
      return v_reserve_amount;
      --
   exception
     when Others then

      raise_application_error( -20000,'Get_Reserve_Amount: '||to_char(p_agreement.agreement_key)||': '||v_error||': '||sqlerrm);

   end Get_Reserve_Amount;


  --=========================================================================
  --## Функция CL_INTEREST.Get_Reserve_Amount_IfKey - расчет суммы подлежащей
  --## резервированию по параметру внутренний номер договора;
  --# Входные параметры:
  --#   p_agreement_key - внутренний номер договора(О);
  --#   p_type_reserve - тип резерва (О - основной, П - просрочки, В - внебаланса)
  --#   p_run_date     - дата резервирования(Н = run_date системы);
  --# Возвращаемые значения:
  --#   Сумма подлежащая резервированию;
  --# Директивы:
  --#   pragma restrict_references (Get_Reserve_Amount_IfKey, WNDS, WNPS );
  --# Необрабатываемые исключения:
  --=========================================================================
   function  Get_Reserve_Amount_IfKey
    (p_agreement_key    in number
    ,p_type_reserve     in varchar2
    ,p_run_date         in date     default null) return number
   is
      v_run_date    fm_system.run_date              % type; -- Дата расчета резерва
      v_agreement   CL_AGREEMENT                    % rowtype;
      v_error           varchar2(100); -- Сообщение об ошибке
      --
   begin
      -- Если дата расчета резерва не указана во входном параметре p_run_date
      -- то считаем ее равной текущей системной дате
      v_error := 'Системные параметры.';
      if p_run_date is null then
         select run_date into v_run_date from fm_system;
      else
         v_run_date := p_run_date;
      end if;
      --
      -- Атрибуты договора
      v_error := 'Атрибуты договора.';
      select *
      into v_agreement
      from cl_agreement
      where agreement_key = p_agreement_key;
      --
      -- Вызовем процедуру расчета резерва
      v_error := 'Расчет резерва!';
      return Get_Reserve_Amount( v_agreement,p_type_reserve,v_run_date);
      --
   exception
     when others then
        raise_application_error( -20001,'Get_Reserve_Amount_IfKey: '||v_error||': '||sqlerrm);
   end Get_Reserve_Amount_IfKey;


  --=========================================================================
  --## Функция CL_INTEREST.Get_Delta - расчет разницы между суммой подлежащей
  --## резервированию и текущей суммой на счете резерва по параметру внутренний
  --## номер договора;
  --# Входные параметры:
  --#   p_agreement_key  - внутренний номер договора(О);
  --#   p_run_date       - дата расчета(Н);
  --# Возвращаемые значения:
  --#   Сумма подлежащая списанию или доначислению на счет резерва;
  --# Директивы:
  --#   pragma restrict_references (Get_Delta, WNDS, WNPS );
  --# Необрабатываемые исключения:
  --# Пояснения:
  --#   Сдлужит для пересчета резерва по уже акцептованным договорам.
  --=========================================================================
   function  Get_Delta
    (p_agreement_key    in number,
     p_run_date         in date  default null) return number
   is
      --
      -- Переменные функции
      --
      v_run_date     date;   -- Дата расчета резерва
      v_sum_reserve  number; -- Сумма подлежащая резервированию
      v_sum_acct     number; -- Сумма на счета резерва
      --
      v_error           varchar2(100); -- Сообщение об ошибке
      --
   begin
      v_error := 'Системные параметры.';
      if p_run_date is null then
         -- Узнаем текущую системную дату
         select run_date into v_run_date from fm_system;
      else
         v_run_date := p_run_date;
      end if;
      v_error := 'Вызовем процедуру расчета резерва';
      v_sum_reserve := Get_Reserve_Amount_IfKey( p_agreement_key,v_run_date);
      v_error := 'Узнаем остаток на счета резерва';
      v_sum_acct := CL_AGR_ATTR.Get_Acct_Amount_Date(
            CL_AGR_ATTR.Get_Account_key( p_agreement_key,'РЕЗ'),v_run_date);
      return nvl(v_sum_reserve,0)-nvl(v_sum_acct,0);
   exception
     when others then
    raise_application_error( -20001,v_error);
   end Get_Delta;


  --=========================================================================
  --## Функция CL_INTEREST.Check_Reserve_agr - Функция проверки необходимости
  --##   проведения операции резервирования
  --# Входные параметры:
  --#   p_agreement_key - внутренний номер договора(О);
  --#   p_ccy           - валюта договора
  --#   p_type_reserve  - тип резерва (О - основной, П - просрочки, В - внебаланса)
  --#   p_run_date      - дата резервирования(Н = run_date системы);
  --# Возвращаемые значения:
  --#   признах необходимости проведения операции резервирования (CL0230)
  --# Директивы:
  --#   pragma restrict_references (Check_Reserve_agr, WNDS);
  --# Необрабатываемые исключения:
  --# Пояснения:
  --=========================================================================
   function Check_Reserve_agr(
     p_agreement_key    in number
    ,p_ccy              in varchar2
    ,p_type_reserve     in varchar2
    ,p_run_date         in date) return varchar2
   is
     cursor c_fair( pDate in date ) is
       select max(f.change_date) Change_Date
       from cl_fair_value f
       where f.agreement_key = p_agreement_key
         and f.change_date   = pDate;
     --
     vRun_Date    Date;
     vLocal_ccy    varchar2(3) := 'RUR';
     vCcy_bal      number;
     vPrev_ccy_bal number;
   begin
     --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- Теперь (с 01.08.2006) резервы пересчитываются ежедневно и в любом случае,
     -- даже при изменении курса валюты.
     Return 'TRUE';
     --
     --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     if p_run_date is null then
        select run_date into vRun_Date from fm_system;
     else
        vRun_Date := p_run_date;
     end if;
     --
     if p_ccy = vLocal_ccy or                   -- Договор в рублях
        last_day(vRun_Date) = vRun_Date  then   -- Последний день месяца
       return 'TRUE';
     end if;
     --
     for ff in c_fair(vRun_Date) loop  -- Изменилась ли справедливая стоимость
       return 'TRUE';
     end loop;
     --
     vCcy_bal := Get_Agr_Amount(p_agreement_key
                               ,p_type_reserve
                               ,vRun_Date);
     vPrev_ccy_bal := Get_Agr_Amount(p_agreement_key
                                    ,p_type_reserve
                                    ,vRun_Date-1);
     if nvl(vCcy_bal,0) != nvl(vPrev_ccy_bal,0) then
       --Изменение остатка
       return 'TRUE';
     end if;
     return 'FALSE';
   end Check_Reserve_agr;


  --=========================================================================
  --## Функция CL_INTEREST.Cl_Plan_Interest_Calculate - расчет суммы
  --##   процентов для планового графика погашения;
  --# Входные параметры:
  --#   p_int_type - тип процентной ставки(О);
  --#   p_effect_date - дата расчета процентной ставки(О);
  --#   p_ccy - валюта счета(О);
  --#   p_int_rate - процентная ставка (берется из договора)(О);
  --#   p_balance - базовая сумма (остаток основного долга )(О);
  --#   p_start_date - дата начала начисления(О);
  --#   p_end_date   - дата окончания начисления(О);
  --# Возвращаемые значения:
  --#   Сумма начисленных процентов;
  --# Директивы:
  --#   pragma restrict_references (Cl_Plan_Interest_Calculate, WNDS);
  --# Необрабатываемые исключения:
  --# Пояснения:
  --#   Первые три параметра нужны лишь для того чтобы определить базу начисления
  --#   (количество дней в году 360 или 365 или 366) и количество дней в месяце
  --#   из таблицы ставок fm_int_rate.
  --#   Задача функции как раз и состоит в учете високосных лет при базе
  --#   начисления, исходя из действительного количества дней в году.
  --=========================================================================
   function Cl_Plan_Interest_Calculate
    (p_int_type         in  varchar2,
     p_effect_date      in  date,
     p_ccy              in  varchar2,
     p_int_rate         in  number,
     p_balance          in  number,
     p_start_date       in  date,
     p_end_date         in  date) return number is
   --
   -- Задача курсора вытащить последнее изменение процентной ставки
   -- при минимальной (первой ) границе диапазона
   cursor c_rate
   is
   select nvl ( mth_days, 'ACT' ) mth_days,
          day_basis
     from fm_int_rate
   where int_type = p_int_type
     and ccy      = p_ccy
     and effect_date <= p_effect_date
   order by effect_date desc, balance asc;
   rat c_rate %rowtype;
   -- Переменные функции
   v_start_year          number; -- год начала начисления
   v_end_year            number; -- год окончания начисления
   v_rate_ladder         fm_int_type.rate_ladder%type; -- метод расчета
                    -- процентов (пропорцианальный, пороговый или расщепленный)
   v_sum_prc             number; -- Сумма процентов
   v_error               varchar2(100); -- сообщение об ошибке
   v_leap_years          number; -- кол-во високосных лет внутри периода расчета
   v_standart_years      number; -- кол-во невисокосных лет внутри периода расчета
   v_days_between_365    number; -- количество дней внутри периода с базой 365
   v_days_between_366    number; -- количество дней внутри периода с базой 366
   begin
      -- Сначала определим метод расчета процентов
      v_error := 'Вытаскиваем тип процентной ставки';
      select rate_ladder into v_rate_ladder
        from fm_int_type
      where int_type = p_int_type;
      -- Найдем базу начисления и количество дней в месяце на дату
      -- рачета (дата открытия кредитного договора)
      v_error := 'Не найдена процентная ставка';
      open c_rate;
      fetch c_rate into rat;
      -- Если записей по ставке нет - то нет и расчета
      if c_rate %notfound then
         Raise_Application_Error(-20001,v_error);
      end if;
      close c_rate;
      -- Начинаем расчет процентов
      v_sum_prc := 0;
      if rat.day_basis in (365,366) then
         -- Если количество дней в году соответсвует реальному, то
         -- расчитаем сколько високосных лет входит в период расчета
         -- Метод очень прост. Разница лет между двумя датами делится на 4
         -- и если хотя бы одна из дат в високосном году (mod(Data,4)=0) то
         -- добавляем к результату 1.
         v_start_year := to_number( to_char( p_start_date, 'YYYY') );
         v_end_year   := to_number( to_char( p_end_date, 'YYYY') );
         v_leap_years := trunc( ( v_end_year - v_start_year ) / 4);
         if ( mod( v_start_year, 4)=0 ) or ( mod( v_end_year, 4)=0 ) then
            v_leap_years := v_leap_years + 1;
         end if;
         -- Узнаем сколько невисокосных лет ( 1 добавляется т.к. например
         -- между 1999 и 2001 г. разница 2, но участвуют-то 1999,2000,2001)
         v_standart_years := v_end_year - v_start_year - v_leap_years + 1;
--            DBMS_OUTPUT.put_line(to_char(v_standart_years)||' '||to_char(v_leap_years));
         -- Расчет периодов (расчет кол-вa дней расчитываемых по разным базам)
         -- Знаем кол-во лет между двумя датами, из них кол-во високосных.
         -- Выравним промежутки до года, т.е. узнаем сколько дней от начала
         -- периода расчета до 01.01 следующего года и от 31.12 предыдущего
         -- до конца периода, уменьшая при этом счетчик либо високосных лет
         -- либо невысокосных.
         v_days_between_365 := 0;
         v_days_between_366 := 0;
         -- Начало периода
         if mod( v_start_year, 4 ) = 0 then
            v_days_between_366 := v_days_between_366 +
               to_date('01.01.'||to_char(v_start_year+1),'dd.mm.yyyy')-
               p_start_date;
            v_leap_years := v_leap_years - 1;
         else
            v_days_between_365 := v_days_between_365 +
               to_date('01.01.'||to_char(v_start_year+1),'dd.mm.yyyy')-
               p_start_date;
            v_standart_years := v_standart_years - 1;
         end if;
--         DBMS_OUTPUT.put_line(to_char(v_days_between_365)||' '||to_char(v_days_between_366));
         -- Окончание периода
         if mod( v_end_year, 4 ) = 0 then
            v_days_between_366 := v_days_between_366 + p_end_date -
               to_date('31.12.'||to_char(v_end_year-1),'dd.mm.yyyy');
            v_leap_years := v_leap_years - 1;
         else
            v_days_between_365 := v_days_between_365 + p_end_date -
               to_date('31.12.'||to_char(v_end_year-1),'dd.mm.yyyy');
            v_standart_years := v_standart_years - 1;
         end if;
--         DBMS_OUTPUT.put_line(to_char(v_days_between_365)||' '||to_char(v_days_between_366));
         -- Теперь все известно для расчета кол-ва дней для каждой базы
         v_days_between_366 := v_days_between_366 + v_leap_years*366;
         v_days_between_365 := v_days_between_365 + v_standart_years*365;
         -- расчет суммы процентов
--         DBMS_OUTPUT.put_line(to_char(v_days_between_365)||' '||to_char(v_days_between_366));
         v_sum_prc := Cl_Flat_Interest( p_int_rate, v_days_between_366, 366, p_balance )+
                      Cl_Flat_Interest( p_int_rate, v_days_between_365, 365, p_balance );
      else
         -- если база начисления не равна реальному количеству дней в году
         -- (иными словами фиксированная)
         v_sum_prc := Cl_Flat_Interest( p_int_rate,
                 Glstor.days_between ( p_start_date, p_end_date, rat.mth_days),
                 rat.day_basis, p_balance );
      end if;
      return v_sum_prc;
   exception
      when others then
         if c_rate %isopen then
            close c_rate;
         end if;
         Raise_Application_Error(-20001,'Cl_Plan_Interest_Calculate '||
                                 nvl(v_error,sqlerrm));
   end Cl_Plan_Interest_Calculate;


  --=========================================================================
  --## Функция CL_INTEREST.Cl_Flat_Interest - расчет процентов исходя
  --##   из пропорционального метода начисления.
  --# Входные параметры:
  --#   p_int_rate - процентная ставка(О);
  --#   p_days_between - сколько дней в промежутке расчета(О);
  --#   p_day_basis    - сколько дней в году (база начисления)(О);
  --#   p_balance      - сумма на которую начисляем проценты(О);
  --# Возвращаемые значения:
  --#   Сумма начисленных процентов за период исходя из пропорционального
  --#   метода начисления.
  --# Директивы:
  --#   pragma restrict_references (Cl_Flat_Interest, RNDS, RNPS, WNDS, WNPS);
  --# Необрабатываемые исключения:
  --#   value_error;
  --=========================================================================
   function Cl_Flat_Interest
    (p_int_rate         in  number,
     p_days_between     in  number,
     p_day_basis        in  number,
     p_balance          in  number) return number is
   begin
      return p_balance*(p_int_rate/100)*(p_days_between/p_day_basis);
   end Cl_Flat_Interest;


  --=========================================================================
  -- Процедура CL_INTEREST.Calc_Reserve_Case
  -- Расчет суммы резерва по заданному портфелю однородных ссуд и б/с
  -- Параметры:
  --   pCase_ID       - Код портфеля
  --   pCb_gl_code    - Бал. счет
  --   pType_Reserve  - тип резерва (О - основной, П - просрочки, В - внебаланс)
  --   pRun_Date      - дата расчета
  --   pRes_Acct_Key  - счет резерва
  --   pRes_Calc      - рассчитанная сумма резерва
  --=========================================================================
  procedure Calc_Reserve_Case ( pCase_Id       in cl_agreement.case_id%type,
                                pBal_Acct      in Varchar2,
                                pType_Reserve  in Varchar2,
                                pRun_Date      in Date,
                                pRes_Acct_Key  out gl_account.internal_key%Type,
                                pRes_Calc      out Number
                              )
  is
    cursor c_agr is
      select /*+CHOOSE*/
             d.agreement_key,
             d.ccy
      from   cl_agreement d, cl_agreement_acct s, gl_account a
      where  ( d.status in ('A','P','B')
               or
               (d.status in ('C','S') and d.close_date >= pRun_Date)
             )
        and  CL_AGR_ATTR.Get_Agr_Params( d.agreement_key,
                                         pRun_Date,
                                         'CASE_ID'     -- ВНИМАНИЕ!!! При существенном увеличении кол-ва договоров
                                       ) = pCase_Id    --             лучше вынести эту проверку в курсор!
        and  s.agreement_key = d.agreement_key
        and  s.acct_category = 'ССД'
        and  a.internal_key = s.account_key
        and  substr(a.cb_gl_code,1,3) = pBal_Acct;
    --
    vAcct_Type       varchar2(3);
    vMsg             varchar2(200);
  begin
    -- Определение типа счета
    vMsg := 'Ошибка определения типа счета резерва: ' || pType_Reserve || '!';
    select r.acct_type
    into vAcct_Type
    from cl_reserve_type r
    where r.reserve_type = pType_Reserve;
    --
    vMsg := 'Не найден счет резерва!';
    select t.reserve_key
    into pRes_Acct_Key
    from cl_case_type t
    where t.case_id    = pCase_Id
      and t.acct_type  = vAcct_Type
      and reserve_type = pType_Reserve
      and t.acct_code  = pBal_Acct;
    --
    -- Расчет новой суммы резерва
    pRes_Calc := 0;
    vMsg := 'Ошибка расчета резерва!';
    for r in c_agr loop
      pRes_Calc := pRes_Calc + NVL(CL_INTEREST.Get_Reserve_Amount_IfKey(r.agreement_key,pType_Reserve,pRun_Date), 0);
    end loop;
  exception
    when others then
      raise_application_error( -20001, vMsg ||' '|| SQLERRM);
  end Calc_Reserve_Case;
  --=========================================================================
  -- Функция CL_INTEREST.Check_Reserve_Case
  -- Проверка необходимости проведения операции резервирования
  -- по заданному портфелю однородных ссуд
  -- Параметры:
  --   pCase_ID       - Код портфеля
  --   pType_Reserve  - тип резерва (О - основной, П - просрочки, В - внебаланс)
  --   pRun_Date      - дата расчета
  -- Директивы:
  --#   pragma restrict_references (Check_Reserve_Case, WNDS);
  --=========================================================================
  function Check_Reserve_Case( pCase_Id in cl_agreement.case_id%type,
                               pType_Reserve  in Varchar2,
                               pRun_Date      in Date
                             ) Return Varchar2
  is
    cursor c_agr is
      select a.agreement_key,
             a.ccy
      from cl_agreement a
      where a.case_id = pCase_Id
        and a.status in ('A','P','B');
    --
    vRes varchar2(5) := 'FALSE';
  begin
    -- Если хоть один договор надо пересчитывать, то пересчитывается весь портфель
    for r in c_agr loop
      vRes := CL_INTEREST.Check_Reserve_agr(r.agreement_key, r.ccy, pType_Reserve, pRun_Date);
      exit when vRes = 'TRUE';
    end loop;
    Return vRes;
  end Check_Reserve_Case;
  --=========================================================================
  --## Функция CL_INTEREST.Get_Reserve_Removal - расчет суммы, подлежащей
  --## резервированию, при выносе на просрочку.
  --# Входные параметры:
  --#   p_agreement_key - внутренний номер договора(О);
  --#   p_amount        - сумма, выносимая на просрочку
  --#   p_run_date     - дата резервирования(Н = run_date системы);
  --# Возвращаемые значения:
  --#   Сумма, подлежащая резервированию;
  --# Директивы:
  --# Необрабатываемые исключения:
  --=========================================================================
   function  Get_Reserve_Removal
    (p_agreement_key    in number
    ,p_amount           in number
    ,p_run_date         in date     default null) return number
   is
      v_agreement       CL_AGREEMENT%rowtype;
      v_run_date        fm_system.run_date%TYPE;      -- Дата расчета резерва
      v_risk_group      cl_agreement.risk_group%TYPE; -- Группа риска на дату расчета
      v_risk_rate       fm_int_rate.actual_rate%TYPE; -- Процентная ставка по резервированию
      v_ccy_rate        fm_currency.central_bank_rate%TYPE; -- Курс валюты на дату расчета
      v_Acct_REZ        gl_account.internal_key%TYPE;       -- Счет типа 'РЕЗ' для договора
      v_Rate_Date       Date;
      v_Rest_REZ        number := 0;
      v_type_reserve    varchar2(1) := 'П';   -- тип резерва
      v_reserve_amount  number := 0;
      v_error           varchar2(100); -- Сообщение об ошибке
   begin
      -- Если дата расчета резерва не указана во входном параметре p_run_date
      -- то считаем ее равной текущей системной дате
      v_error := 'Системные параметры.';
      if p_run_date is null then
         select run_date into v_run_date from fm_system;
      else
         v_run_date := p_run_date;
      end if;
      --
      -- Атрибуты договора
      v_error := 'Аттрибуты договора.';
      select * into v_agreement
      from cl_agreement
      where agreement_key = p_agreement_key;
      --
      -- Для портфеля резерв не расчитываем
      if v_agreement.case_id is not null then
        Return 0;
      end if;
      --
      -- Найдем счет резерва (типа РЕЗ) и остаток по нему.
      -- Если остаток = 0, то дальше ничего не считаем.
      v_error := 'Счет типа "РЕЗ".';
      select a.account_key, gl_barc.get_Current_Ccy_Out_Bal(a.account_key, v_run_date)
      into v_Acct_REZ, v_Rest_REZ
      from cl_agreement_acct a
      where a.agreement_key = p_agreement_key
        and a.acct_category = 'РЕЗ';
      --
      if v_Rest_REZ = 0 then
        return 0;
      end if;
      --
      -- Определение процентной ставки
      if v_agreement.case_id is null then
        -- Вытащим группу риска
        v_error := 'Группа риска';
        v_risk_group := cl_agr_attr.Get_Risk_Group_Seq(p_agreement_key, v_run_date);
        -- Теперь по группе риска найдем процентную ставку на дату резервирования
        v_error := 'Процентная ставка по группе риска';
        v_risk_rate := cl_agr_attr.get_risk_prc (p_agreement_key, v_risk_group, v_run_date, null, v_type_reserve);
      else
        -- По коду кредитного портфеля найдем процентную ставку на дату резервирования
        v_error := 'Процентная ставка по коду кред. портфеля';
        v_risk_rate := cl_agr_attr.get_risk_prc (p_agreement_key, null, v_run_date, v_agreement.case_id, v_type_reserve);
      end if;
      --
      -- Найдем дату последней операции по счету "РЕЗ". Считать будем по курсу на эту дату.
      -- Проводки точно есть, т.к. остаток по счету != 0 (разобрали выше)
      select NVL(max(p.value_date), v_run_date)
      into v_Rate_Date
      from gl_post_turnover_v p
      where p.internal_key = v_Acct_REZ -- счет типа 'РЕЗ'
      and not exists ( select 'X'
                       from cl_operation o, cl_oper_type t
                       where o.agreement_key = p_agreement_key
                         and o.internal_key = p.tran_key
                         and t.oper_type = o.operation_type
                         and t.auto_oper_type = 46  -- Вынос на просрочку
                     );
      -- Узнаем курс валюты на дату резервирования
      v_ccy_rate := fm_ccy_rate_all (v_agreement.ccy, v_Rate_Date, 'CENTRAL_BANK_RATE');
      -- Теперь все готово для расчета суммы резерва
      v_reserve_amount := round(
                            round( round(v_ccy_rate * p_Amount, 2) * v_risk_rate / 100, 2) *
                            Get_Reserve_Factor(p_agreement_key
                                              ,v_type_reserve
                                              ,v_Rate_Date)
                             ,2);
      return v_reserve_amount;
   exception
     when others then
    raise_application_error( -20008,v_error);
   end Get_Reserve_Removal;
  --=========================================================================
  --# Функция CL_INTEREST.Calc_Fair_Value - расчет справедливой стоимости
  --#                                       для кред. договоров.
  --# Входные параметры:
  --#   pAgreement_Key    - внутр. номер договора (null - все договора);
  --=========================================================================
  procedure Calc_Fair_Value( pAgreement_Key in number )
  is
    --
    cursor c_agr is
      select *
      from cl_agreement a
      where a.agreement_key = NVL(pAgreement_Key, a.agreement_key)
        and a.status in ('A','P','B')
        and a.fair_flag = 'Д';
    --
    cursor c_guar( pAgr_Key in number ) is
      select g.*
      from cl_agreement_guarantee g
      where g.agreement_key = pAgr_Key
        and g.status in ('A', 'N')
        and NVL(g.assessed_amount, 0) > 0
        and NVL(g.factor_category, 0) != 0;
    --
    cursor c_guar_fair( pAgr_Key in number ) is
      select sum(f.amount)  Amount,
             f.ccy,
             f.factor_category
      from cl_guarantee_fair_val f
      where f.agreement_key = pAgr_Key
        and f.calc_user     = user
      group by f.ccy, f.factor_category;
    --
    vRun_Date        Date;
    vSum_Guar_FV     Number;
    vCCY_Guar_FV     fm_currency.ccy%type;
    --
    vSum_Ins         Number;
    vSum_Ass         Number;
    vSum_Fair        Number;
    vSum_New         Number;
    vLast_Fair_Date  Date;
    vErr             varchar2(1000);
    --
    procedure Insert_Rec( pAgreement_Key in number,
                          pAmount        in number,
                          pCCY           in varchar2,
                          pFactor        in number,
                          pChange_Date   in date ) is
    begin
      insert into cl_fair_value ( agreement_key,
                                  amount,
                                  ccy,
                                  factor_category,
                                  change_date
                                )
      values ( pAgreement_Key,
               pAmount,
               pCCY,
               pFactor,
               pChange_Date
             );
    end Insert_Rec;
    --
  begin
    vErr := 'Системные параметры.';
    select s.run_date
    into vRun_Date
    from fm_system s;
    --
    -- Очистим старый расчет за текущий день (на случай повторного запуска процедуры)
    vErr := 'Удаление предыдущего расчета.';
    delete from cl_fair_value f
    where f.agreement_key = NVL(pAgreement_Key, f.agreement_key)
      and f.change_date   = vRun_Date
      and not exists ( select 'X'
                       from cl_agreement a
                       where a.agreement_key = f.agreement_key
                         and a.fair_flag = 'Н'
                     );
    --
    vErr := 'Очистка врем. таблицы расчета (1).';
    delete from CL_GUARANTEE_FAIR_VAL t
    where t.calc_user = user;
    --
    for agr in c_agr loop
      begin
        savepoint sv;
        --
        for g in c_guar(agr.agreement_key) loop
          -- C 31.07.2007 в расчете справедливой стоимости участвует только сумма оценки
          if vRun_Date >= to_date('31.07.2007','DD.MM.YYYY') then
            vSum_Guar_FV     := g.assessed_amount;
            vCCY_Guar_FV     := g.assessed_ccy;
          else
            if NVL(g.insurance_sum, 0) <= 0 then
              vSum_Guar_FV     := g.assessed_amount;
              vCCY_Guar_FV     := g.assessed_ccy;
            else
              vSum_Ins := rur_eq(g.insurance_sum,g.insurance_ccy,vRun_Date);
              vSum_Ass := rur_eq(g.assessed_amount,g.assessed_ccy,vRun_Date);
              if vSum_Ins > vSum_Ass then
                vSum_Guar_FV     := g.assessed_amount;
                vCCY_Guar_FV     := g.assessed_ccy;
              else
                vSum_Guar_FV     := g.insurance_sum;
                vCCY_Guar_FV     := g.insurance_ccy;
              end if;
            end if;
          end if;
          --
          -- Вставляем запись во временную таблицу
          insert into CL_GUARANTEE_FAIR_VAL
                        ( CALC_USER,
                          GUARANTEE_KEY,
                          AGREEMENT_KEY,
                          AMOUNT,
                          CCY,
                          FACTOR_CATEGORY
                        )
          values ( USER,
                   g.guarantee_key,
                   g.agreement_key,
                   vSum_Guar_FV,
                   vCCY_Guar_FV,
                   g.factor_category
                 );
        end loop;
        --
        -- Определение новой общей суммы справедливой стоимости по договору
        select NVL(sum(round(rur_eq(v.Amount,v.ccy,vRun_Date) * v.factor_category, 2)), 0)
        into vSum_New
        from ( select sum(t.amount) Amount,
                      t.ccy,
                      t.factor_category
               from cl_guarantee_fair_val t
               where t.agreement_key = agr.agreement_key
                 and t.calc_user     = user
               group by t.ccy, t.factor_category
             ) v;
        --
        -- Расчет текущей общей суммы справедливой стоимости
        select max(f.change_date)
        into vLast_Fair_Date
        from cl_fair_value f
        where f.agreement_key = agr.agreement_key
          and f.change_date  <= vRun_date;
        --
        select NVL(sum(round(rur_eq(f.amount,f.ccy,vRun_Date) *
                             f.factor_category, 2)), 0)
        into vSum_Fair
        from cl_fair_value f
        where f.agreement_key = agr.agreement_key
          and f.change_date   = vLast_Fair_Date;
        --
        -- Определяем, изменилась ли справедливая стоимость...
        -- Если изменилась, то вставляем новые записи.
        if vSum_New != vSum_Fair then
          if vSum_New = 0 then
            -- Вставим одну нулевую запись
            Insert_Rec( agr.agreement_key,   -- agreement_key
                        0,                   -- amount
                        'RUR',               -- ccy
                        0,                   -- factor_category
                        vRun_Date            -- change_date
                      );
          else
            -- Вставляем записи по валютам и коэффициентам
            for gfr in c_guar_fair(agr.agreement_key) loop
              Insert_Rec( agr.agreement_key,
                          gfr.amount,
                          gfr.ccy,
                          gfr.factor_category,
                          vRun_Date
                        );
            end loop;
          end if;
        end if;
        --
      exception
        when others then
          vErr := 'Дог. '||agr.agreement_key||' Дата = '||to_char(vRun_Date, 'DD.MM.YYYY') || sqlerrm;
          rollback to sv;
          --
          systor.insert_error_msg_silent( sqlcode,
                                          'CL_INTEREST',
                                          'CALC_FAIR_VALUE',
                                          'I',
                                          SubStr(vErr,1,254)
                                        );
      end;
    end loop;
    --
    -- Снова очищаем временную таблицу
    vErr := 'Очистка врем. таблицы расчета (2).';
    delete from CL_GUARANTEE_FAIR_VAL t
    where t.calc_user = user;
    --
  exception
    when others then
      systor.insert_error_msg_silent( sqlcode,
                                      'CL_INTEREST',
                                      'CALC_FAIR_VALUE',
                                      'I',
                                      SubStr(vErr||' '||SQLERRM,1,254)
                                    );
  end Calc_Fair_Value;
  --
  --=========================================================================
  --# Процедура CL_INTEREST.Calculate_IRR - расчет эффективной ставки
  --#                                       для кред. договоров.
  --# Входные параметры:
  --#   pn_Agreement_Key    - внутр. номер договора
  --# Выходные параметры:
  --#   pn_Eff_Rate         - эффект. ставка
  --=========================================================================
  --
  procedure Calculate_IRR( pn_Agreement_Key   in  Number
                          ,pn_Eff_Rate        out Number
                         )
  is
    c_Max_Iter  constant number := 100;        -- максимальное число итераций расчкта IRR
    c_Max_IRR   constant number := 5;          -- предполагаемое (начальное) максимальное значение IRR
    c_Precision constant number := 0.00000001; -- точность расчета
    --
    type tr_data  is record ( dischargе_date date    -- дата уплаты
                             ,insh_amount    number  -- сумма страховки на дату уплаты
                             ,other_amount   number);-- сумма прочих уплат на дату уплаты
    type ta_data is table of tr_data index by binary_integer;
    va_data ta_data;  -- массив данных
    --
    type tr_IRR_data  is record ( dischargе_date date    -- дата уплаты
                                 ,amount         number);-- сумма
    type ta_IRR_data is table of tr_IRR_data index by binary_integer;
    --
    va_IRR_Data_1 ta_IRR_data; -- массив данных о платежах с учетом страхования
    --va_IRR_Data_2 ta_IRR_data; -- массив данных о платежах без учета страхования
    --
    -- Процедура подготовки данных для расчета эффетивной ставки
    -- заполняет массивы  va_IRR_Data_1 - данные о платежах с учетом страхования
    --                    va_IRR_Data_2 - данные о платежах без учета страхования
    procedure Prepare_Data
    is
      cursor cur_Chart( pDate varchar2 ) is
        select ch.effect_date          EFFECT_DATE,
               ( nvl(ch.amount_debt,0) +
                 nvl(ch.percent_debt,0) +
                 nvl(ch.amount_commis,0)
               ) AMOUNT
        from cl_chart ch
        where ch.agreement_key  = pn_Agreement_Key
          and ch.effect_date   >= pDate
          and ch.payment_status = 'П'
        --
        union all
        select decode(substr(c.payment_status,1,1),
                      'Ф', c.effect_date,
                      'Р', s.run_date,
                      'О', c.delinquency_return_date
                     ),
               ( nvl(c.amount_debt,0) +
                 nvl(c.percent_debt,0) +
                 nvl(c.amount_commis,0)
               ) AMOUNT
        from cl_chart c, fm_system s
        where c.agreement_key  = pn_Agreement_Key
          and c.effect_date    < pDate
          and substr(c.payment_status,1,1) in ('Ф','Р','О')
        --
        union all -- добавим даннее из Cl_Er_Inform для которых нет соотвестующих в cl_chart
        select distinct er.value_date  EFFECT_DATE
              ,0                       AMOUNT
        from Cl_Er_Inform er
        where er.agreement_key = pn_Agreement_Key
          and er.value_date not in ( select c.effect_date
                                     from cl_chart c
                                     where c.agreement_key = pn_Agreement_Key
                                     and c.payment_status = 'Н')
          order by 1;
      --
      i             binary_integer;
      vEffect_Date  date;
    begin
      i:=1;
      --
      select min(effect_date)
      into   vEffect_Date
      from   cl_chart X
      where  agreement_key  =  pn_Agreement_Key
        and  effect_date    > ( select nvl( max(effect_date), X.effect_date-1 )
                                from   cl_chart
                                where  agreement_key = pn_Agreement_Key
                                  and  substr(payment_status,1,1) in ('Ф','Р','О')
                              )
        and  payment_status = 'П';
      --
      for Ch in cur_Chart(vEffect_Date) loop
        va_data(i).dischargе_date := Ch.Effect_Date;
        va_data(i).other_amount   := Ch.Amount;
        va_data(i).insh_amount    := 0;
        --
        for Er in ( select er.amount
                          ,er.amount_type
                      from cl_er_inform er
                     where er.agreement_key = pn_Agreement_Key
                       and er.value_date    = ch.effect_date)
        loop
          if Er.Amount_Type = 'КР' then
            va_data(i).other_amount := va_data(i).other_amount - er.amount;
          elsif Er.Amount_Type = 'ПК' then
            va_data(i).other_amount := va_data(i).other_amount + er.amount;
          elsif Er.Amount_Type = 'СП' then
            va_data(i).insh_amount := va_data(i).insh_amount + er.amount;
          end if;
        end loop;
        --
        va_IRR_Data_1(i).dischargе_date := va_data(i).dischargе_date;
        va_IRR_Data_1(i).amount := va_data(i).insh_amount + va_data(i).other_amount;
        --
        --va_IRR_Data_2(i).dischargе_date := va_data(i).dischargе_date;
        --va_IRR_Data_2(i).amount := va_data(i).other_amount;
        --
        i := i + 1;
      end loop;
      --
      va_data.delete;
    end Prepare_Data;
    -- процедура удаления данных
    procedure Term_Data
    is
    begin
      va_IRR_Data_1.delete;
      -- va_IRR_Data_2.delete;
    end;
    -- функция расчета эффективной ставки
    -- входной параметр pa_Data ta_IRR_data - массив данных с датами и платежами
    -- возвращает искомое значение
    function Calc_IRR(pa_Data in ta_IRR_data)
    return number
    is
      vn_NPV        number; -- значение NPV
      vn_IRR        number; -- значение IRR
      vn_N_IRR      number; -- проследнее значение IRR при отрицательном NPV
      vn_P_IRR      number; -- проследнее значение IRR при положительном NPV
      vn_Iteration  number; -- счетчик итераций при расчете IRR
      vd_Start_Date date;   -- дата первого платежа
    begin
      vn_IRR   := c_Max_IRR;
      vn_N_IRR := 0;
      vn_P_IRR := 0;
      vn_Iteration := 0;
      vd_Start_Date := pa_Data(1).dischargе_date;
      -- подбор IRR методом дихотомии (сокращение возможного диапазона IRR в два раза)
      loop
        vn_NPV := 0;
        vn_Iteration := vn_Iteration + 1;
        --
        for i in pa_data.first..pa_data.last loop
          vn_NPV := vn_NPV + pa_Data(i).amount/POWER(1 + vn_IRR,(pa_Data(i).dischargе_date - vd_Start_Date)/365);
        end loop;
        --
        if vn_NPV = 0 then
          exit;
        elsif vn_NPV < 0 then
          vn_N_IRR := vn_IRR;
          vn_IRR:= vn_N_IRR - (vn_N_IRR - vn_P_IRR)/ 2;
          if vn_N_IRR - vn_IRR < c_Precision then
            vn_IRR := vn_N_IRR;
            exit;
          end if;
        elsif vn_NPV > 0 then
          vn_P_IRR := vn_IRR;
          vn_IRR := vn_N_IRR - (vn_N_IRR - vn_IRR) /2 ;
          if vn_IRR - vn_P_IRR < c_Precision then
            vn_IRR := vn_P_IRR;
            exit;
          end if;
        elsif vn_Iteration = c_Max_Iter then
          exit;
        end if;
      end loop;
      --
      return vn_IRR;
    end Calc_IRR;
    --
    -- функция проверки кредитной линии
    -- возвращает FALSE если договор не является кредитной линией
    function Agr_Is_Credit_Line
    return boolean
    is
      vs_Dummy varchar2(1);
      vb_Ret   boolean;
      cursor cur_Agr
          is
      select 'X'
        from cl_agreement t
       where t.agreement_key = pn_Agreement_Key
         and t.credit_line = 'Н';
    begin
      open cur_Agr;
      fetch cur_Agr into vs_Dummy;
      if cur_Agr%found then
        close cur_Agr;
        vb_Ret := FALSE;
      else
        close cur_Agr;
        vb_Ret := TRUE;
      end if;
      --
      return vb_Ret;
    end Agr_Is_Credit_Line;
  --
  begin
    --
    if Agr_Is_Credit_Line then
      pn_Eff_Rate := NULL;
    else
      Prepare_Data;
      /*
       dbms_output.put_line(' ');
       for i in va_IRR_Data_1.first..va_IRR_Data_1.last loop
         dbms_output.put_line(to_char(i)||' '||
                              to_char(va_IRR_Data_1(i).dischargе_date,'DD.MM.YYYY')||' '||
                              to_char(va_IRR_Data_1(i).amount));
       end loop;
       --
       dbms_output.put_line(' ');
       for i in va_IRR_Data_2.first..va_IRR_Data_2.last loop
         dbms_output.put_line(to_char(i)||' '||
                              to_char(va_IRR_Data_2(i).dischargе_date,'DD.MM.YYYY')||' '||
                              to_char(va_IRR_Data_2(i).amount));
       end loop;
      */
      --
      pn_Eff_Rate        := round(Calc_IRR(va_IRR_Data_1)*100, 2);
      -- pn_Eff_Rate_NoInsh := round(Calc_IRR(va_IRR_Data_2)*100, 2);
      --
      if pn_Eff_Rate > 9999 then
        pn_Eff_Rate := 9999;
      end if;
      --
      /*
      if pn_Eff_Rate_NoInsh > 9999 then
        pn_Eff_Rate_NoInsh := 9999;
      end if;
      */
      Term_Data;
      --
    end if;
  end Calculate_IRR;

end CL_INTEREST;
/

show errors package body CL_INTEREST

spool off

--
-- ===== End of file =====
--
