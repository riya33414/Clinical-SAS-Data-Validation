/*========================================================
  PROJECT: Clinical Trial Data Management & SAS Validation
  DATASET: VISIT
  PROGRAM: 02_VITALS_Validation.sas
========================================================*/

PROC IMPORT DATAFILE='/home/u64498565/cdm project/raw dataset/VISITS.csv'
         OUT=clinical.visit
         DBMS=csv
         REPLACE;
         GETNAMES=yes;
run;

/*  REVIEW DATASET STRUCTURE */

proc contents data=clinical.visit;
    title "VISITS Dataset Structure";
run;


/*  REVIEW VISITS DATA */

proc print data=clinical.visit;
    title "VISITS Dataset";
run;


/* EDIT CHECK 1: MISSING VISIT DATE */

data work.missing_visit_date;
    set clinical.visit;

    if missing(visit_date);
run;

proc print data=work.missing_visit_date;
    title "Edit Check 1 - Missing Visit Date";
run;


/* EDIT CHECK 2: INVALID VISIT */

data work.invalid_visit;
    set clinical.visit;

    if missing(visit)
       or visit not in
       ("Screening",
        "Baseline",
        "Week 2",
        "Week 4");
run;

proc print data=work.invalid_visit;
    title "Edit Check 2 - Invalid Visit";
run;


/* EDIT CHECK 3: INVALID VISIT STATUS */

data work.invalid_visit_status;
    set clinical.visit;

    if missing(status)
       or status not in ("Completed", "Missed");
run;

proc print data=work.invalid_visit_status;
    title "Edit Check 3 - Invalid Visit Status";
run;


/* EDIT CHECK 4: DUPLICATE SUBJECT + VISIT */

proc sort data=clinical.visit
          out=work.sorted_visits
          nodupkey
          dupout=work.duplicate_visits;

    by subjid visit;
run;

proc print data=work.duplicate_visits;
    title "Edit Check 4 - Duplicate Subject Visit";
run;


/* EDIT CHECK 5: UNMATCHED SUBJECTS */

proc sql;

    create table work.unmatched_visit_subjects as

    select distinct v.subjid

    from clinical.visit as v

    left join clinical.demog as d
        on v.subjid = d.subjid

    where d.subjid is null;

quit;

proc print data=work.unmatched_visit_subjects;
    title "Edit Check 5 - Visit Subjects Not Found in DEMOG";
run;

/* EDIT CHECK 6: INVALID VISIT DATE */

data work.invalid_visit_date;
    set clinical.visit;

    visit_date_num= input(visit_date, ?? date9.);
    
    if not missing(visit_date)
    and missing(visit_date_num);
    
    format visit_date_num date9.;
    
run;

proc print data=work.invalid_visit_date;
    title "Edit Check 6 - Invalid Visit Date";
run;





