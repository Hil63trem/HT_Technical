show user;
show con_name;

desc v$mystat;
select * from v$mystat;
select * from dba_sys_privs where grantee='SELECT ANY DICTONARY';



create table miles001_rawdata (
   LEISTUNGSTAG date,
   STARTZEIT date,
   ENDZEIT date,
   LEISTUNG  varchar2(100),
   KOMMENTAR varchar2(500));

-- drop table miles001_rawdata;
-- truncate table miles001_rawdata;


select Leistungstag,Leistung,to_date(sum(to_number(Endzeit)-to_number(Startzeit))) Aufwand
 from miles001_rawdata
 group by Leistungstag,Leistung
 order by 1,2;
 
select leistungstag,startzeit,endzeit, endzeit-startzeit from MILES001_RAWDATA;


select trunc(leistungstag), count(*) ANZAHL, sum((endzeit-startzeit)*24) from MILES001_RAWDATA
 group by trunc(leistungstag)
 order by trunc(LEISTUNGSTAG); 

-- https://www.plumislandmedia.net/sql-time-processing/using-sql-report-time-intervals-oracle/
-- Taegliche Grupppierung
select trunc(leistungstag)
       ,count(*) ANZAHL
       ,round(sum((endzeit-startzeit)*24),2) Aufwand 
from MILES001_RAWDATA
where LEISTUNG is not null  
group by trunc(leistungstag)
order by trunc(LEISTUNGSTAG);


select trunc(leistungstag) TAG
      ,LEISTUNG
      ,count(*) ANZAHL
      ,round(sum((endzeit-startzeit)*24),2) Aufwand 
from MILES001_RAWDATA
where LEISTUNG is not null  
 group by trunc(leistungstag),LEISTUNG
 order by trunc(LEISTUNGSTAG);
 
-- Monat:
select trunc(leistungstag,'MM') MONAT
      ,LEISTUNG
      ,count(*) ANZAHL
      ,round(sum((endzeit-startzeit)*24),2) Aufwand 
 from MILES001_RAWDATA
where LEISTUNG is not null  
group by trunc(leistungstag,'MM'),LEISTUNG
order by trunc(LEISTUNGSTAG,'MM');
 
-- Woche 
select trunc(leistungstag,'DAY') Woche
      ,LEISTUNG
      ,count(*) ANZAHL
      ,round(sum((endzeit-startzeit)*24),2) Aufwand 
 from MILES001_RAWDATA
where LEISTUNG is not null  
group by trunc(leistungstag,'DAY'),LEISTUNG
order by trunc(LEISTUNGSTAG,'DAY');

grant select on MILES001_RAWDATA to testplan;
show user;
 
