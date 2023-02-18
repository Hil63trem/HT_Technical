CREATE TABLE "HTMILES" (
  "LDATUM" DATE, 
  "LANFANG" TIMESTAMP (6), 
  "LENDE" TIMESTAMP (6), 
  "LDAUER" TIMESTAMP (6), 
  "LBEZEICHNUNG" VARCHAR2(60 BYTE), 
  "LKURZTEXT" VARCHAR2(255 BYTE)
);


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
  
select ldatum, httimesheet.llocation
from httimesheet
where llocation = 'Homo ' 
-- and length(httimesheet.llocation) >4
order by ldatum;