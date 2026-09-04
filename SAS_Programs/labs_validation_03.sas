/*========================================================
  PROJECT: Clinical Trial Data Management & SAS Validation
  DATASET: labs
  PROGRAM: 02_VITALS_Validation.sas
========================================================*/

PROC IMPORT DATAFILE='/home/u64498565/cdm project/raw dataset/LABS.csv'
                    OUT=clinical.labs
                    DBMS=csv
                    REPLACE;
                    GETNAMES=yes;
run;

/*               <review structure> */

PROC CONTENTS DATA=clinical.labs;
    TITLE " LABS DATASET STRUCTURE";
RUN;

PROC PRINT DATA=clinical.labs;
    TITLE "LABS DATA";
RUN;


/*                   <EDIT CHECK 1 - MISSING LAB RESULTS > */

DATA misssing_result;
     SET clinical.labs; 
     IF MISSING (result);
RUN;

PROC PRINT DATA=work.misssing_result;
     TITLE "EDIT CHECK 1 - MISSING LAB RESULTS";
RUN;


/*                   <EDIT CHECK 2 - MISSING LAB UNITS > */

DATA missing_labunits;
     SET clinical.labs;
     IF MISSING (unit);
RUN;

PROC PRINT DATA=work.missing_labunits;
    TITLE "EDIT CHECK 2 - MISSING LAB UNITS ";
RUN;

 
/*                   EDIT CHECK 3 - UNEXPECTED LAB TEST NAMES */

DATA INVALID_LABTEST;
     SET clinical.labs;
     IF MISSING (unit)
     OR TEST NOT IN ("Hemoglobin", "Glucose", "ALT", "AST","Creatinine");
RUN;

PROC PRINT DATA=work.invalid_labtest;
    TITLE "EDIT CHECK 3 - UNEXPECTED LAB TEST NAMES";
RUN;


/*                       EDIT CHECK 4: DUPLICATE LAB RECORDS */
/*                          Key = SUBJID + VISIT + TEST */

PROC SORT DATA=clinical.labs
    OUT=WORK.sorted_labs
    NODUPKEY
    DUPOUT=work.duplicate_lab_record;
    by subjid visit test;
RUN;

PROC PRINT DATA=work.duplicate_lab_record;
    title "EDIT CHECK 4: DUPLICATE LAB RECORDS";
run;

 
/*                       EDIT CHECK 5: UNMATCHED SUBJECTS */
/*                          Compare LABS with DEMOG    */

PROC SQL;
         CREATE TABLE work.unmatched_labsubjects as
         SELECT distinct labs.subjid
         FROM clinical.labs labs
         
         LEFT JOIN clinical.demog demog
            on  labs.subjid = demog.subjid
         where demog.subjid is null;
         
 QUIT;
 
     proc print data=work.unmatched_labsubjects;
    title "Edit Check 5 - LABS Subjects Not Found in DEMOG";
run;    


/*                       EDIT CHECK 6: INVALID VISITS */

DATA invalid_labvisit;
     SET clinical.labs;
     IF MISSING (visit)
     OR VISIT NOT IN ("Baseline","Week 4");
RUN;

PROC PRINT DATA=work.invalid_labvisit;
   title "EDIT CHECK 6: INVALID LAB VISITS";
RUN;


/*                            EDIT CHECK 7:NEGATIVE LAB RESULTS */
data work.negative_lab_results;
    set clinical.labs;

    if not missing(result) and result < 0;
run;

proc print data=work.negative_lab_results;
    title "Edit Check 7 - Negative Laboratory Results";
run;


/*=========================================================
  REVIEW ALL LABS DISCREPANCIES
=========================================================*/

proc print data=work.misssing_result;
    title "Discrepancy 1 - Missing Lab Result";
run;

proc print data=work.missing_labunits;
    title "Discrepancy 2 - Missing Lab Unit";
run;

proc print data=work.invalid_labtest;
    title "Discrepancy 3 - Unexpected Lab Test";
run;

proc print data=work.duplicate_lab_record;
    title "Discrepancy 4 - Duplicate Lab Record";
run;

proc print data=work.unmatched_labsubjects;
    title "Discrepancy 5 - Unmatched LABS Subject";
run;









