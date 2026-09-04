/*========================================================
  PROJECT: Clinical Trial Data Management & SAS Validation
  DATASET: VITALS
  PROGRAM: 02_VITALS_Validation.sas
========================================================*/

PROC IMPORT DATAFILE='/home/u64498565/cdm project/raw dataset/VITALS.csv'
                  OUT=CLINICAL.vitals
                  DBMS=CSV
                  REPLACE;
                  GETNAMES=yes;
RUN;

PROC CONTENTS DATA=clinical.vitals;
run;

PROC PRINT DATA=CLINICAL.vitals;
run;

/*       (Edit check- vitals signs) */

DATA missing_vitals;
                set clinical.vitals;
                if missing(SYSBP)
                or missing(diabp)
                or missing (pulse)
                or missing(temp);
run;

PROC PRINT DATA= work.missing_vitals;
  title "Edit check 1 - Missing vital signs value";
  run;

/*           ( EDIT CHECK 2: INVALID SYSTOLIC BLOOD PRESSURE) */

DATA invalid_sysbp;
             set clinical.vitals;
             if not missing(sysbp)
             and (sysbp <70 or sysbp >250);
run;

proc print data=work.invalid_sysbp;
 title "Edit check 2 - invalid systemic blood pressure value";
 run;

/*             ( EDIT CHECK 2: INVALID diastolic blood pressure) */

DATA invalid_diabp;
             set clinical.vitals;
             if not missing(diabp)
             and (diabp <40 or diabp >150);
 run;
 
proc print data=work.invalid_diabp;
 title "EDIT CHECK 2: Invalid diastolic blood pressure";
 run;
 
/*           (EDIT CHECK 3: Invalid pulse value) I */

DATA invalid_pulse;
               set clinical.vitals;
               if not missing(pulse)
               and (pulse <40 or pulse >200);
 run;
 
PROC PRINT DATA=WORK.invalid_pulse;
title " EDIT CHECK 3: Invalid pulse value";
run;

/*               (EDIT CHECK 4: Invalid Temperature)  */

DATA invalid_temp;
             set clinical.vitals;
             if not missing(temp)
             and (temp <90 or temp >110);
 run;
 
PROC PRINT DATA=work.invalid_temp;
title "EDIT CHECK 4: Invalid Temperature";
run;


/*            (EDIT CHECK 6 - duplicate subjid/visit) */
PROC SORT DATA= clinical.vitals
         out= sorted_vitals
         NODUPKEY
         DUPOUT=duplicate_subjid_visit;
         by subjid visit;
run;

proc print data= work.duplicate_subjid_visit;
title"EDIT CHECK 6 - duplicate subjid/visit";
run;

            
/*             EDIT CHECK 7: UNMATCHED SUBJECT ID */

PROC SQL;
      CREATE TABLE unmatched_vitals as
      select distinct v.subjid
      FROM clinical.vitals as v
      left join clinical.demog as d
      on v.subjid= d.subjid
      where d.subjid is null;
 QUIT;
      
 PROC PRINT DATA=WORK.unmatched_vitals;
 title "EDIT CHECK 7- Vital subject not found in demog";
 run;


proc print data=clinical.demog;
    where subjid in ("SUBJ019", "SUBJ999");
    title "Check Unmatched Subjects in DEMOG";
run;

proc print data=clinical.vitals;
    where subjid in ("SUBJ019", "SUBJ999");
    title "VITALS Records for Unmatched Subjects";
run;
