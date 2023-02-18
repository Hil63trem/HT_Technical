CREATE TABLE "HTMILES" (
  "LDATUM" DATE, 
  "LANFANG" TIMESTAMP (6), 
  "LENDE" TIMESTAMP (6), 
  "LDAUER" TIMESTAMP (6), 
  "LBEZEICHNUNG" VARCHAR2(60 BYTE), 
  "LKURZTEXT" VARCHAR2(255 BYTE)
);

/* 
Importieren der Daten ueber Kontext Menue
hier:     miles20alltabeded.txt:  Tabded File, Anpassen Spalten an Datentypen

*/


-- commit;
-- truncate table htmiles;

select count(*) from htmiles;
select count(*) from htmiles where ldatum >=to_date('01.01.2022','dd.mm.yyyy');  --1582
--delete from htmiles where ldatum >=to_date('01.01.2022','dd.mm.yyyy');
select * from htmiles order by ldatum;

select extract(year from ldatum),count(*)  from htmiles 
group by ldatum
order by ldatum;


select distinct ldatum from htmiles order by ldatum;
select * from htmiles where lbezeichnung is null and ldauer is not null;
select * from htmiles where lbezeichnung is null and lanfang is not null;
-- update htmiles set lanfang=null, lende=null where lbezeichnung is null and lanfang is not null;


-- Umwandeln Minuten in hh:mi format
select to_char(trunc(sysdate)+75/(24*60),'hh:mi') from dual;

-- lende - lanfang = ldauer.  o.k.
select ldatum,lanfang,lende, lende-lanfang dauer
,ldauer
-- ,to_char(trunc(sysdate)+((extract(hour from lende-lanfang)*60) + (extract(minute from lende-lanfang)))/(24*60),'hh24:mi')  sumhhmm
,to_char(trunc(sysdate)+((extract(hour from lende-lanfang)*60) + (extract(minute from lende-lanfang)))/(24*60),'hh:mi')  sumhhmm
from htmiles
order by ldatum;


select ldatum,lbezeichnung
--,ldauer
,sum((extract(hour from lende-lanfang)*60) + (extract(minute from lende-lanfang)))  summen
,to_char(trunc(sysdate)+(sum((extract(hour from lende-lanfang)*60) + (extract(minute from lende-lanfang))))/(24*60),'hh24:mi')  sumhhmm
from htmiles
group by ldatum,lbezeichnung
order by ldatum,lbezeichnung;



select lbezeichnung
--,ldauer
,sum((extract(hour from lende-lanfang)*60) + (extract(minute from lende-lanfang)))  summen
,trunc(sum((extract(hour from lende-lanfang)*60) + (extract(minute from lende-lanfang)))/60,2)  stunden
,to_char(trunc(sysdate)+(sum((extract(hour from lende-lanfang)*60) + (extract(minute from lende-lanfang))))/(24*60),'hh24:mi')  sumhhmm
from htmiles
group by lbezeichnung
order by stunden desc;


create index idx_htmiles_lbezeichnung on htmiles(lbezeichnung);
-- So sieht es gut aus!
select lbezeichnung
  ,count(*) Tasks
  ,round(sum(((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang)))/60)/count(*),2) AVGTask
  ,sum((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang))) Minuten
  ,sum(((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang)))/60) Stunden
  ,round(sum(((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang)))/(60*8)),2) MannTage 
   from htmiles 
  where ldatum >to_date('31.12.2021','dd.mm.yyyy')
  group by cube(lbezeichnung)
  order by lbezeichnung;
  
select lbezeichnung
  ,count(*) Tasks
  ,round(sum(((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang)))/60)/count(*),2) AVGTask
  ,sum((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang))) Minuten
  ,sum(((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang)))/60) Stunden
  ,round(sum(((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang)))/(60*8)),2) MannTage 
   from htmiles 
  where lbezeichnung in ('ISA: Chance','ISA: Infrastruktur')
  group by cube(lbezeichnung)
  order by lbezeichnung;


/* Arbeitstage  

*/ 
select sum(((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang)))/(60*8)) Arbeitstage
 from htmiles
where ldatum >to_date('31.12.2021','dd.mm.yyyy');

-- Gruppieren nach 
select extract(year from ldatum) Jahr,
   sum(((extract(hour from lende)- extract(hour from lanfang))*60 + (extract(minute from lende)- extract(minute from lanfang)))/(60*8)) Arbeitstage
 from htmiles
 group by extract(year from ldatum) 
 order by 1; 
 

 
/* Tabellenblatt Timesheet */
-- Timesheet

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
select count(*) from HTTIMESHEET;
-- where ldatum <=to_date('31.12.2019','dd.mm.yyyy');
-- Welche Jahre
select distinct((extract(year from ldatum))) DD from HTTIMESHEET;
select * from HTTIMESHEET;
select LDATUM,LANFANG,LENDE
  ,lpause
  ,LIST
  ,LDIFF
  ,llocation
  ,((extract(hour from LDIFF)*60) + (extract(minute from LDIFF))) KK  -- LDIFF in Minuten
  ,(extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)
   - extract(minute from LANFANG)) DIFFI  -- Ende - Anfang in Minuten
  ,((extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)- extract(minute from LANFANG)))
   - ((extract(hour from LPAUSE)*60) + (extract(minute from LPAUSE))) Effektiv  -- Ende-Anfang-Pause in Minunten 
  ,((extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)- extract(minute from LANFANG)))
   - ((extract(hour from LPAUSE)*60) + (extract(minute from LPAUSE))) 
   - ((extract(hour from LSOLL)*60) + (extract(minute from LSOLL)))  Ueberzeit  -- Ende-Anfang-Pause in Minunten  
  ,(extract(hour from LENDE)- extract(hour from LANFANG)) DIFFH  -- Ende-Anfang nur Stunden
  ,(extract(minute from LENDE)- extract(minute from LANFANG)) DIFFMIN  -- Ende-Anfang nur Minuten
  ,((extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)- extract(minute from LANFANG))) 
   - abs((extract(hour from LSOLL)*60) + (extract(minute from LSOLL))) Diffsoll --Ende-Anfang-Soll in Minunten
  from HTTIMESHEET
  where LLOCATION not like 'Homo%'
    and ldatum <=to_date('31.12.2020','dd.mm.yyyy')
  -- where ldatum <=to_date('31.05.2021','dd.mm.yyyy')
  order by 1;

-- update httimesheet set llocation='Home' where ldatum=to_date('30.11.2021'); 
-- delete from httimesheet where ldatum <=to_date('31.12.2021','dd.mm.yyyy');
  
select round(sum(((extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)- extract(minute from LANFANG)))
             - ((extract(hour from LPAUSE)*60) + (extract(minute from LPAUSE))))/(60),2) IST   -- Geleistete Zeiten in Stunden
       ,sum((extract(hour from LSOLL)*60) + (extract(minute from LSOLL)))/(60) SOLL  -- Soll Zeiten in Stunden   
       ,count(*)
       from HTTIMESHEET;
       -- where ldatum >=to_date('01.05.2021','dd.mm.yyyy')
       --  and ldatum <=to_date('31.05.2021','dd.mm.yyyy');
         
select sum(((extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)- extract(minute from LANFANG)))
   - ((extract(hour from LPAUSE)*60) + (extract(minute from LPAUSE))) 
   - ((extract(hour from LSOLL)*60) + (extract(minute from LSOLL))))/60  Ueberzeit  -- Ende-Anfang-Pause in Minunten  
      ,sum(((extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)- extract(minute from LANFANG)))
   - ((extract(hour from LPAUSE)*60) + (extract(minute from LPAUSE))))  ISTMIN  -- Ende-Anfang-Pause in Minunten
     ,sum((extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)- extract(minute from LANFANG))) OHNEPA
   -- -((extract(hour from LPAUSE)*60) + (extract(minute from LPAUSE))))/60  ISTMHH  -- Ende-Anfang-Pause in Minunten
   ,sum((extract(hour from LSOLL)*60) + (extract(minute from LSOLL))) SOLLMIN  -- Soll Zeiten in Stunden /(60)
   ,sum((extract(hour from LSOLL)*60) + (extract(minute from LSOLL)))/60 SOLLHH  -- Soll Zeiten in Stunden /(60)
   ,count(*)
       from HTTIMESHEET
       -- where ldatum <=to_date('31.05.2021','dd.mm.yyyy');
       where ldatum >=to_date('01.05.2020','dd.mm.yyyy')
        and ldatum <=to_date('31.05.2021','dd.mm.yyyy');

-- Arbeitstage aus timesheet
select round(sum(((extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)- extract(minute from LANFANG)))
   - ((extract(hour from LPAUSE)*60) + (extract(minute from LPAUSE))))/(60*8),3)  ATage_IST  -- Ende-Anfang-Pause in Minunten
   ,sum((extract(hour from LSOLL)*60) + (extract(minute from LSOLL)))/(60*8) ATage_SOLL  -- Soll Zeiten in Stunden /(60)
   from HTTIMESHEET
   where ldatum >=to_date('01.01.2022','dd.mm.yyyy')
        and ldatum <=to_date('31.12.2022','dd.mm.yyyy');
  
-- Gruppieren nach Jahren:        
select extract(year from LDATUM) Jahr 
  ,round(sum(((extract(hour from LENDE)- extract(hour from LANFANG))*60 + (extract(minute from LENDE)- extract(minute from LANFANG)))
   - ((extract(hour from LPAUSE)*60) + (extract(minute from LPAUSE))))/(60*8),3)  ATage_IST  -- Ende-Anfang-Pause in Minunten
  ,sum((extract(hour from LSOLL)*60) + (extract(minute from LSOLL)))/(60*8) ATage_SOLL  -- Soll Zeiten in Stunden /(60)
  from HTTIMESHEET   
  group by extract(year from LDATUM)
  order by 1;
 
       
