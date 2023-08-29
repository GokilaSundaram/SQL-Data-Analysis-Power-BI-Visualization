//***HR DataAnalysis ****//
         
        SELECT * FROM HR;
        
        DESCRIBE HR;
        
        //CONVERT TERMDATE TO DATE FORMAT
        
//Try with dual//        
with t1(tm) as(
  select '2013-11-08 10:11:31 UTC' from dual
)
select cast(to_timestamp_tz(tm, 'yyyy-mm-dd hh24:mi:ss "UTC"') 
          as date)   as this_way  
     , cast(to_timestamp_tz(tm, 'yyyy-mm-dd hh24:mi:ss "UTC"') 
         as date) as or_this_way
  from t1
  
  SELECT cast(to_timestamp_tz(TERMDATE, 'yyyy-mm-dd hh24:mi:ss "UTC"') 
          as date)   as this_way FROM HRBACKUP;
          
       //   Update the termdate in HR table//
        UPDATE HR
        SET TERMDATE = cast(to_timestamp_tz(TERMDATE, 'yyyy-mm-dd hh24:mi:ss "UTC"') 
        as date) 
        WHERE TERMDATE IS NOT NULL;
         
         //To aLTER TERMDATE DATA TYPE create  a backup table
          CREATE TABLE HRBACKUP AS SELECT * FROM HR;
          
          //REMOVE VALUES BEFORE from HR.termdate before UPDATING DATATYPE
         UPDATE HR
         SET TERMDATE = NULL;
         
         ALTER TABLE HR
         MODIFY TERMDATE DATE;
         
         //RESTORE VALUES FROM BACKUP TABLE
         UPDATE HR
         SET TERMDATE = (SELECT TERMDATE FROM HRBACKUP WHERE HR.ID=HRBACKUP.ID AND TERMDATE IS NOT NULL)
         
         //check the highest and least values after update and cross check with csv file//
         select max(termdate) as maxdate, min(termdate) as mindate from HR;
         
         //INSERT AGE COLUMN
         ALTER TABLE HR 
         ADD age int;
         
         //insert values into age column
         UPDATE HR
         SET AGE = MONTHS_BETWEEN(SYSDATE,BIRTHDATE)/12
         COMMIT;
       
       
       SELECT MIN(AGE) AS YOUNGEST, MAX(AGE) AS OLDEST FROM HR;
       
       SELECT * FROM HR
      /////////////////////////////////////////////////////////////////////////////////////////////////// 
       //QUESTIONS:
      
       //WHAT IS THE GENDER BREAKDOWN OF EMPLOYEES IN THE COMPANY?
       SELECT DISTINCT GENDER FROM HR;
       SELECT  GENDER, COUNT(*) FROM HR where termdate is null GROUP BY GENDER;
       
       //WHAT IS THE RACE/ETHINICITY BREAKDOWN OF EMPLOYEES?
       SELECT DISTINCT RACE FROM HR;
       SELECT RACE, COUNT(*) FROM HR WHERE TERMDATE IS NULL GROUP BY RACE;
       
       //WHAT IS THE AGE DISTRIBUTION OF EMPLOYEES?
       
      SELECT  GENDER,AGEGROUP, COUNT(*) FROM
      (SELECT GENDER,  CASE  WHEN AGE BETWEEN 18 AND 24 THEN '18-24'
                    WHEN AGE BETWEEN 25 AND 34 THEN '25-34'
                    WHEN AGE BETWEEN 35 AND 44 THEN '35-44'
                    WHEN AGE BETWEEN 44 AND 54 THEN '44-54'
                    WHEN AGE BETWEEN 55 AND 64 THEN '55-64'
                    END AS AGEGROUP
        FROM HR WHERE TERMDATE IS NULL  )               
       GROUP BY AGEGROUP,GENDER;
       
       
      SELECT COUNT(*), AGEGROUP FROM
      (SELECT   CASE  WHEN AGE BETWEEN 18 AND 24 THEN '18-24'
                    WHEN AGE BETWEEN 25 AND 34 THEN '25-34'
                    WHEN AGE BETWEEN 35 AND 44 THEN '35-44'
                    WHEN AGE BETWEEN 44 AND 54 THEN '44-54'
                    WHEN AGE BETWEEN 55 AND 64 THEN '55-64'
                    END AS AGEGROUP
        FROM HR WHERE TERMDATE IS NULL  )  
        GROUP BY AGEGROUP;
      
       
       //HOW MANY EMPLOYEES WORK AT HEADQUARTERS VS REMOTE LOCATIONS?
        SELECT LOCATION, COUNT(*) FROM HR GROUP BY LOCATION;
       
       
       //WHAT IS THE AVERAGE LENGTH OF EMPLOYMENT  FOR EMPLOYEES WHO HAVE BEEN TERMINATED?
       SELECT * FROM HR;
       
         (SELECT round(avg(MONTHS_BETWEEN(TERMDATE,HIRE_DATE)/12),0) AS EMPLENGTH FROM HR WHERE TERMDATE IS NOT NULL and termdate<=sysdate)
 
       SELECT * FROM HR WHERE TERMDATE IS NOT NULL;

       //HOW DOES GENDER DISTRIBUTION VARY ACROSS DEPARTMENTS AND JOB TITLES?
       
        SELECT DEPARTMENT, GENDER, COUNT(*) FROM HR GROUP BY DEPARTMENT,GENDER  ORDER BY DEPARTMENT;
        
        //which department has highest turnover rate//
        select * from hr;
        
        select DEPARTMENT, TOTAL_COUNT, TERMINATED_COUNT, ROUND((TERMINATED_COUNT/TOTAL_COUNT),3)AS TERMINATIONRATE
        FROM
        (SELECT DEPARTMENT, COUNT(*) AS TOTAL_COUNT,
        SUM(CASE WHEN TERMDATE IS NOT NULL and termdate<=sysdate THEN 1 ELSE 0 END) AS TERMINATED_COUNT
        FROM HR 
        GROUP BY DEPARTMENT) 
        ORDER BY TERMINATIONRATE DESC
        
        //WHAT IS THE DISTRIBUTION OF EMPLOYEES ACROSS LOCATIONS  BY CITY AND STATE
      SELECT * FROM HR;
   
   SELECT  LOCATION_STATE, COUNT(*) AS TOTALCOUNT
   FROM HR
   WHERE TERMDATE IS NULL
   GROUP BY LOCATION_STATE
   ORDER BY TOTALCOUNT DESC
   
   //HOW HAS THE COMAPANYS EMPLOYEE COUNT CHANGED OVERTIME BASED ON HIRE AND TERM DATE
   
   SELECT YEAR, HIREDCNT, TERMINATEDCNT, HIREDCNT-TERMINATEDCNT AS CNTCHANGE,
   ROUND(((HIREDCNT-TERMINATEDCNT) /HIREDCNT)*100,2) AS PERCENTAGECHG
   FROM
   (SELECT EXTRACT(YEAR FROM HIRE_DATE) AS YEAR,
   COUNT(*) AS HIREDCNT,
   SUM(CASE WHEN TERMDATE IS NOT NULL AND TERMDATE <= SYSDATE THEN 1 ELSE 0 END) AS TERMINATEDCNT
   FROM HR
   GROUP BY EXTRACT(YEAR FROM HIRE_DATE)) 
   ORDER BY YEAR
   
   
  //WHAT IS THE TENURE DISTRIBUTION FOR EACH DEPARTMENT
  
        SELECT DEPARTMENT, round(avg(MONTHS_BETWEEN(TERMDATE,HIRE_DATE)/12),0) AS EMPLENGTH FROM HR WHERE TERMDATE IS NOT NULL and termdate<=sysdate
        GROUP BY DEPARTMENT;
         
