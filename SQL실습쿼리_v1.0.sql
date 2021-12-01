----------------------
-- 전체 사용 데이터 --
----------------------
edimm_cus : 고객 정보 
eactw_ivd_act    : (고객 - 계좌) 개별 계좌 정보
erslm_mm_act_rsl : 월 계좌 실적 
epdiw_iem_bas            : 상품 마스터 
eaerw_act_pdt_te_tot_his : (계좌 - 상품) 계좌 상품 기간 총 자산 이력 (매 분기말일 기준으로 편집)
prd_slf_cd_nm_mapper     : (상품 - 카테고리) 매핑 테이블 


edimm_emp 
eogzw_tab 
ecntw_crm_cta_his
erslm_mm_pdt_act_rsl  : 월 계좌 상품 실적 
ecbsw_com_cd : 코드 마스터 


 



----------------------
-- Scenario 1 : 고객 --
----------------------
-- 활용 데이터 
--  edimm_cus : 고객 정보 

-- 의도: 데이터 확인 - edimm_cus 
--       문법 활용 - distinct 
-- Q. 샘플 데이터의 고객 수는? 
-- A. 

select  count(1) as cnt 
      , count(distinct cus_no) as cus_count 
from    edu.edimm_cus 
;

-- 의도: 문법 활용 - group by, case when 절
-- Q. 연령대별 고객 수는? 
-- A. 

select  case when cus_age between  0 and  9 then '10세 미만' 
             when cus_age between 10 and 19 then '10대' 
             when cus_age between 20 and 29 then '20대' 
             when cus_age between 30 and 39 then '30대' 
             when cus_age between 40 and 49 then '40대' 
             when cus_age between 50 and 59 then '50대' 
             when cus_age between 60 and 69 then '60대' 
             when cus_age between 70 and 200 then '70세 이상' 
             end as age_gr 
      , count(distinct cus_no) as cnt 
from    edu.edimm_cus 
group by case when cus_age between  0 and  9 then '10세 미만' 
             when cus_age between 10 and 19 then '10대' 
             when cus_age between 20 and 29 then '20대' 
             when cus_age between 30 and 39 then '30대' 
             when cus_age between 40 and 49 then '40대' 
             when cus_age between 50 and 59 then '50대' 
             when cus_age between 60 and 69 then '60대' 
             when cus_age between 70 and 200 then '70세 이상' 
             end      
;

select  case when cus_age between  0 and  9 then '10세 미만' 
             when cus_age between 10 and 19 then '10대' 
             when cus_age between 20 and 29 then '20대' 
             when cus_age between 30 and 39 then '30대' 
             when cus_age between 40 and 49 then '40대' 
             when cus_age between 50 and 59 then '50대' 
             when cus_age between 60 and 69 then '60대' 
             when cus_age between 70 and 200 then '70세 이상' 
             end as age_gr 
      , count(distinct cus_no) as cnt 
from    edu.edimm_cus 
group by 1


-- 의도: 문법 활용 - subquery, 간단한 over 절
-- Q. 연령대별 고객 비율은? 
-- A. 

select  cus.age_gr 
      , round(cus.cnt / total_cnt, 2) as rt 
from    (
            select  case when cus_age between  0 and  9 then '10세 미만' 
                 when cus_age between 10 and 19 then '10대' 
                 when cus_age between 20 and 29 then '20대' 
                 when cus_age between 30 and 39 then '30대' 
                 when cus_age between 40 and 49 then '40대' 
                 when cus_age between 50 and 59 then '50대' 
                 when cus_age between 60 and 69 then '60대' 
                 when cus_age between 70 and 200 then '70세 이상' 
                 end as age_gr 
          , count(distinct cus_no) as cnt 
            from    edu.edimm_cus 
            where   cus_age between 0 and 200 
            group by 1
        ) cus 
        left join 
        (
            select count(distinct cus_no) as total_cnt 
            from    edu.edimm_cus 
            where   cus_age between 0 and 200 
        ) ttl 
        on 1 
;

select  age_gr 
      , cnt 
      , cnt / sum(cnt) over ()  as rt 
from    (
            select  case when cus_age between  0 and  9 then '10세 미만' 
                 when cus_age between 10 and 19 then '10대' 
                 when cus_age between 20 and 29 then '20대' 
                 when cus_age between 30 and 39 then '30대' 
                 when cus_age between 40 and 49 then '40대' 
                 when cus_age between 50 and 59 then '50대' 
                 when cus_age between 60 and 69 then '60대' 
                 when cus_age between 70 and 200 then '70세 이상' 
                 end as age_gr 
          , count(distinct cus_no) as cnt 
            from    edu.edimm_cus 
            group by 1
        ) x 
;


-- 의도: 데이터 확인 - edimm_cus.pva_crp_cfc_cd
-- Q. 개인/법인 고객의 분포는? 
-- A. 
select  pva_crp_cfc_cd
      , count(distinct cus_no) as cnt 
from    edu.edimm_cus 
group by pva_crp_cfc_cd 
;


-- 문법 활용 - over 절 응용
-- Q. 개인/법인 고객의 비율은? 
-- A. 
select  pva.pva_crp_cfc_cd 
      , pva.cnt 
      , pva.cnt / ttl.total as rt 
from    (      
            select  pva_crp_cfc_cd
                  , count(distinct cus_no) as cnt 
            from    edu.edimm_cus 
            group by pva_crp_cfc_cd 
        ) pva 
      , ( 
            select  count(distinct cus_no) as total 
            from    edu.edimm_cus 
        ) ttl 
;

select  pva_crp_cfc_cd
      , cnt 
      , cnt / sum(cnt) over () as rt 
from    (      
            select  pva_crp_cfc_cd
                  , count(distinct cus_no) as cnt 
            from    edu.edimm_cus 
            group by pva_crp_cfc_cd 
        ) x
;



----------------------
-- Scenario 2 : 계좌 -- 
----------------------
-- 활용 데이터 
--  eactw_ivd_act    : (고객 - 계좌) 개별 계좌 정보
--  erslm_mm_act_rsl : 월 계좌 실적 

-- 의도: 문법 활용 - having 절 
--      데이터 확인 - eactw_ivd_act 
-- Q. 계좌를 2개 이상 보유한 고객 수는? 
-- A. 
select  count(cus_no) cnt
from    (
            select  cus_no
                  , count(*) c 
            from    edu.eactw_ivd_act 
            group by cus_no 
            having c > 1 
        ) x 
;


-- 의도: 문법 활용 - min() 함수 
-- Q. 2020년 1월 이후 계좌개설한 고객 수는? 
-- A. 

select  count(cus_no) as cnt 
from    (
            select  cus_no
                  , min(act_opn_dt) as min_act_opn_dt 
            from    edu.eactw_ivd_act
            group by cus_no 
            having  min_act_opn_dt >= '20200101' 
        ) x 
;


-- 의도: 문법 활용 - case when 
--      다소 복잡한 구조 
-- Q. 2019년 12월 기준으로 개인 고객에 대해서 총자산 기준으로 고객 등급 분류하고, 각 등급 별 고객수와 등급 별 평균 자산을 구하시오 
--    고객 등급 분류 
--      고객 총자산말일잔액 기준  10억원 이상              : UHNW 
--      고객 총자산말일잔액 기준   1억원 이상, 10억원 미만    : HNW 
--      고객 총자산말일잔액 기준 3천만원 이상, 1억원 미만      : Affluent 
--      고객 총자산말일잔액 기준 3천만원 미만               : MASS
-- A. 

select  cus_grade
      , count(distinct cus_no)  as cus_cnt 
      , round(avg(tot_aet_tld_rnd), 0)    as avt_tot
from    (      
            select  act.cus_no 
                  , sum(rsl.tot_aet_tld_rnd) 
                  , case when sum(rsl.tot_aet_tld_rnd) >= 1000000000 then 'UHNW' 
                         when sum(rsl.tot_aet_tld_rnd) >=  100000000 and sum(rsl.tot_aet_tld_rnd) < 1000000000 then 'HNW' 
                         when sum(rsl.tot_aet_tld_rnd) >=  30000000 and sum(rsl.tot_aet_tld_rnd) < 100000000 then 'Affleunt'
                         when sum(rsl.tot_aet_tld_rnd) < 30000000 then 'MASS'
                         else '_' end as cus_grade 
            from    edu.eactw_ivd_act act 
                    inner join 
                    edu.erslm_mm_act_rsl rsl 
                    on  act.act_no = rsl.act_no 
                    and rsl.bse_ym = '201912'
                    inner join 
                    edu.edimm_cus cus
                    on  cus.cus_no = act.cus_no 
                    and cus.pva_crp_cfc_cd = '1'   -- 개인고객
            group by act.cus_no        
        ) x 
group by cus_grade         
;




----------------------
-- Scenario 3 : 상품 -- 
----------------------
-- 활용 데이터 
--  epdiw_iem_bas            : 상품 마스터 
--  eaerw_act_pdt_te_tot_his : (계좌 - 상품) 계좌 상품 기간 총 자산 이력 (매 분기말일 기준으로 편집)
--  prd_slf_cd_nm_mapper     : (상품 - 카테고리) 매핑 테이블 

-- 의도: 데이터 확인 - epdiw_iem_bas
-- Q. ELS 상품 개수는? 
-- A. 

select count(*) 
from    edu.epdiw_iem_bas 
where   iem_krl_nm like '%ELS%'
;


-- 의도: 데이터 확인 - eaerw_act_pdt_te_tot_his
-- Q. 2019년 동안 ELS 상품을 한번이라도 가입했던 계좌 수는? 
-- A. 

select  count(distinct his.act_no) cnt 
from    edu.eaerw_act_pdt_te_tot_his his 
        inner join 
        (
            select  * 
            from    edu.epdiw_iem_bas 
            where   iem_krl_nm like '%ELS%'
        ) iem 
        on his.iem_cd = iem.iem_cd 
where   his.iqr_dt between '20190101' and '20191231' 
;


-- 의도: 문법 활용 - like 
-- Q. 고객 수는? 
-- A. 

select  count(distinct act.cus_no) cus_cnt 
from    edu.eaerw_act_pdt_te_tot_his as his 
        inner join 
        edu.epdiw_iem_bas as iem 
        on      his.iem_cd = iem.iem_cd 
        and     his.iqr_dt between '20190101' and '20191231' 
        and     iem.iem_krl_nm like '%ELS%'
        inner join 
        edu.eactw_ivd_act as act
        on      his.act_no = act.act_no 
;



-- 의도: 문법 활용 - in 구문 
--     데이터 활용 
-- Q. 상품 별로 5개의 카테고리로 구분하고, 각 카테고리별 상품 개수와 가입한 계좌수, 고객수, 그리고 총 자산합계을 표현하시오 (2019년 12월 31일 기준) 
-- A. 

select  case when substr(his.iem_slf_cd, 1, 2) in ('01', '02') then '원화_주식' 
             when substr(his.iem_slf_cd, 1, 2) in ('05', '07', '09', '12', '13', '14', '26') then '원화_금상' 
             when substr(his.iem_slf_cd, 1, 2) in ('08', '25', '28') then '원화_현금' 
             when substr(his.iem_slf_cd, 1, 2) in ('15') then '외화_주식'
             when substr(his.iem_slf_cd, 1, 2) in ('16') then '외화_채권'
             end as category 
      , count(distinct his.iem_cd) as iem_cnt 
      , count(distinct his.act_no) as act_cnt 
      , count(distinct act.cus_no) as cus_cnt 
      , sum(TOT_AET_TLD_RND) as tot_aet 
from    edu.eaerw_act_pdt_te_tot_his as his 
        inner join 
        edu.eactw_ivd_act as act 
        on  his.act_no = act.act_no 
        and his.iqr_dt = '20191231' 
        and substr(his.iem_slf_cd, 1, 2) <> '21' 
group by case when substr(his.iem_slf_cd, 1, 2) in ('01', '02') then '원화_주식' 
             when substr(his.iem_slf_cd, 1, 2) in ('05', '07', '09', '12', '13', '14', '26') then '원화_금상' 
             when substr(his.iem_slf_cd, 1, 2) in ('08', '25', '28') then '원화_현금' 
             when substr(his.iem_slf_cd, 1, 2) in ('15') then '외화_주식'
             when substr(his.iem_slf_cd, 1, 2) in ('16') then '외화_채권'
             end
;






-- 의도: 문법 활용 - in 구문 
--     데이터 활용 
-- Q. 상품 별로 5개의 카테고리로 구분하고, 각 카테고리별 상품 개수와 가입한 계좌수를 표현하시오 (2019년 12월 31일 기준) 
-- A. 

select  case when substr(his.iem_slf_cd, 1, 2) in ('01', '02') then '원화_주식' 
             when substr(his.iem_slf_cd, 1, 2) in ('05', '07', '09', '12', '13', '14', '26') then '원화_금상' 
             when substr(his.iem_slf_cd, 1, 2) in ('08', '25', '28') then '원화_현금' 
             when substr(his.iem_slf_cd, 1, 2) in ('15') then '외화_주식'
             when substr(his.iem_slf_cd, 1, 2) in ('16') then '외화_채권'
             end as category 
      , count(distinct his.iem_cd) as iem_cnt 
      , count(distinct his.act_no) as act_cnt 
      , count(distinct act.cus_no) as cus_cnt 
      , sum(TOT_AET_TLD_RND) as tot_aet 
from    edu.eaerw_act_pdt_te_tot_his as his 
        inner join 
        edu.eactw_ivd_act as act 
        on  his.act_no = act.act_no 
        and his.iqr_dt = '20191231' 
        and substr(his.iem_slf_cd, 1, 2) <> '21' 
group by case when substr(his.iem_slf_cd, 1, 2) in ('01', '02') then '원화_주식' 
             when substr(his.iem_slf_cd, 1, 2) in ('05', '07', '09', '12', '13', '14', '26') then '원화_금상' 
             when substr(his.iem_slf_cd, 1, 2) in ('08', '25', '28') then '원화_현금' 
             when substr(his.iem_slf_cd, 1, 2) in ('15') then '외화_주식'
             when substr(his.iem_slf_cd, 1, 2) in ('16') then '외화_채권'
             end
;






-------------------------------------------------------------------------------------------------------------------------------------
-- prd_slf_cd_nm_mapper


-- 의도: 다소 복잡한 join 활용 
-- Q. 2019년 동안, 펀드 경험은 없는 주식 고객 수는? 
-- A. 

select  count(distinct stk.cus_no) cus_cnt 
from    (
            select  his.*
                  , act.cus_no 
            from    edu.eaerw_act_pdt_te_tot_his his 
                    inner join 
                    edu.prd_slf_cd_nm_mapper slf 
                    on      his.iem_cd = slf.iem_cd 
                    inner join 
                    edu.eactw_ivd_act act 
                    on      his.act_no = act.act_no 
                    and     his.iqr_dt between '20190101' and '20191231' 
                    and     slf.iem_tp in ('국내주식', '해외주식')
        ) as stk 
        inner join 
        (
            select  his.*
                  , act.cus_no  
            from    edu.eaerw_act_pdt_te_tot_his his 
                    inner join 
                    edu.prd_slf_cd_nm_mapper as slf 
                    on his.iem_cd = slf.iem_cd 
                    inner join 
                    edu.eactw_ivd_act as act 
                    on      his.act_no = act.act_no 
                    and     his.iqr_dt between '20190101' and '20191231' 
                    and     slf.iem_tp != '펀드' 
        ) as fnd 
        on stk.cus_no = fnd.cus_no
;        

-- 의도: insight 도출용
-- Q. 위 고객의 인구통계학적 분포는? (성별, 연령대별(10세단위))
-- A. 

select  cus.sex_dit_cd 
      , case when cus.cus_age between  0 and  9 then '10세미만' 
             when cus.cus_age between 10 and 19 then '10대' 
             when cus.cus_age between 20 and 29 then '20대' 
             when cus.cus_age between 30 and 39 then '30대' 
             when cus.cus_age between 40 and 49 then '40대' 
             when cus.cus_age between 50 and 59 then '50대' 
             when cus.cus_age between 60 and 69 then '60대' 
             when cus.cus_age between 70 and 200 then '70세 이상' 
             end as age_gr 
      , count(distinct cus.cus_no) cnt 
from    (
            select  his.*, act.cus_no 
            from    edu.eaerw_act_pdt_te_tot_his his 
                    inner join 
                    edu.prd_slf_cd_nm_mapper slf 
                    on his.iem_cd = slf.iem_cd 
                    inner join 
                    edu.eactw_ivd_act act 
                    on his.act_no = act.act_no 
            where   iqr_dt between '20190101' and '20191231' 
            and     iem_tp in ('국내주식', '해외주식')
        ) stk 
        inner join 
        (
            select  his.*, act.cus_no  
            from    edu.eaerw_act_pdt_te_tot_his his 
                    inner join 
                    edu.prd_slf_cd_nm_mapper slf 
                    on his.iem_cd = slf.iem_cd 
                    inner join 
                    edu.eactw_ivd_act act 
                    on his.act_no = act.act_no 
            where   iqr_dt between '20190101' and '20191231' 
            and     iem_tp != '펀드' 
        ) fnd 
        on stk.cus_no = fnd.cus_no
        inner join 
        edu.edimm_cus as cus 
        on stk.cus_no = cus.cus_no 
group by cus.sex_dit_cd 
      , case when cus.cus_age between  0 and  9 then '10세미만' 
             when cus.cus_age between 10 and 19 then '10대' 
             when cus.cus_age between 20 and 29 then '20대' 
             when cus.cus_age between 30 and 39 then '30대' 
             when cus.cus_age between 40 and 49 then '40대' 
             when cus.cus_age between 50 and 59 then '50대' 
             when cus.cus_age between 60 and 69 then '60대' 
             when cus.cus_age between 70 and 200 then '70세 이상' 
             end 
;             

--  26.412 seconds
-- Q. 전체 고객 인구통계학적 분포와 비교 (*Tableau에서 ) 


u











