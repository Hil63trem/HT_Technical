-- 25.02.2023   Januar 2023 hinzuefuegt

CREATE TABLE "HTMILES" (
  "LDATUM" DATE, 
  "LANFANG" TIMESTAMP (6), 
  "LENDE" TIMESTAMP (6), 
  "LDAUER" TIMESTAMP (6), 
  "LBEZEICHNUNG" VARCHAR2(60 BYTE), 
  "LKURZTEXT" VARCHAR2(255 BYTE)
);

select * from htmiles order by ldatum desc;

select * from HTTIMESHEET 
order by ldatum;

-- Geht nicht
select extract(month from ldatum),sum(LIST) LL
from httimesheet
where ldatum >to_date('31.12.2023','dd.mm.yyyy')
group by extract(month from ldatum)
order by 1;

create table "HTTIMESHEET"(
  "LDATUM" DATE, 
  "LANFANG" TIMESTAMP (6), 
  "LENDE" TIMESTAMP (6), 
  "LPAUSE" TIMESTAMP (6), 
  "LIST" TIMESTAMP (6), 
  "LSOLL" TIMESTAMP (6), 
  "LDIFF" TIMESTAMP (6), 
  "LDIFFTEN" NUMBER(5,2), 
  "LLOCATION" VARCHAR2(60 BYTE), 
  "LBEMERKUNG" VARCHAR2(255 BYTE)
);

update HTTIMESHEET set LLOCATION='Wi' where LLOCATION='WI';
update HTTIMESHEET set LLOCATION='Homo' where LLOCATION='Home';
update HTTIMESHEET set LLOCATION='Homo' where LLOCATION='Homo ';


 select extract(year from LDATUM) Jahr, llocation,count(*) anzahl
  from HTTIMESHEET
  group by cube((extract(year from LDATUM)), llocation) 
  order by 1,2;
  
  
 select extract(month from LDATUM) Jahr, llocation,count(*) anzahl
  from HTTIMESHEET
  group by cube((extract(month from LDATUM)), llocation) 
  order by 1,2;  

select ldatum,llocation from httimesheet
where ldatum >to_date('31.12.2022','dd.mm.yyyy')
 order by 1;


-- Korrektur falscher werte  
select ldatum, httimesheet,llocation
from httimesheet
where llocation = 'Homo ' 
-- and length(httimesheet.llocation) >4
order by ldatum;