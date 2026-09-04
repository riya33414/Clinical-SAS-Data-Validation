/*========================================================
  PROJECT: Clinical Trial Data Management & SAS Validation
  DATASET: AE
  PROGRAM: 02_VITALS_Validation.sas
========================================================*/

/*                IMPORT AE RAWDATASET */

PROC IMPORT DATAFILE="/home/u64498565/cdm project/raw dataset/AE.csv"
    OUT=clinical.ae
    DBMS=csv
    REPLACE;
    GETNAMES=yes;
RUN;


/*                 REVIEW DATA STRUCTURE */

PROC CONTENTS DATA=clinical.ae;
    TITLE "AE DATASET STRUCTURE";
RUN;

PROC PRINT DATA=clinical.ae;
    TITLE "AE DATASET ";
RUN;


/*                EDIT CHECK 1- MISSING AE TERM */

DATA missing_aeterm;
     SET clinical.ae;
     IF MISSING(AE_TERM);
RUN;

PROC PRINT DATA= work.missing_aeterm;
    TITLE "EDIT CHECK 1- MISSING AE TERM";
RUN;


/*                 EDIT CHECK 2- INVALID SEVERITY */

DATA invalid_severity;
     SET clinical.ae;
     if missing(severity)
     or severity not in ("Mild","Moderate","Severe");
     run;


PROC PRINT DATA=work.invalid_severity;
    TITLE "EDIT CHECK 2- INVALID SEVERITY";
    RUN;



/*                      EDIT CHECK 3- INVALID SERIOUS VALUE */
DATA invalid_serious_value;
     set clinical.ae;
     if missing(serious)
     or serious not in ("Yes","No");
     RUN;

PROC PRINT DATA=work.invalid_serious_value;
    title"EDIT CHECK 3- INVALID SERIOUS VALUE";
run;


/*                        EDIT CHECK 4: INVALID START DATE AFTER END DATE */
DATA invalid_ae_dates;
     set clinical.ae;
     if not missing(start_date)
     and not missing (end_date)
     and start_date> end_date;
run;

proc print data=work.invalid_ae_dates;
      title "EDIT CHECK 4: INVALID START DATE AFTER END DATE";
      run;


/*                EDIT CHECK 5: MISSING AE DATES */
DATA missing_ae_dates;
     set clinical.ae;
     if missing(start_date)
       or missing(end_date);
       run;

proc print data=work.missing_ae_dates;
     title "EDIT CHECK 5: MISSING AE DATES";
     run;


/*                    EDIT CHECK 6: DUPLICATE AE RECORDS */
proc sort data=clinical.ae
    out=work.sorted_ae
    NODUPKEY
    DUPOUT=WORK.DUPLICATE_AE;
    BY SUBJID AE_TERM START_DATE;
    RUN;
    
PROC PRINT DATA=WORK.DUPLICATE_AE;
     TITLE"EDIT CHECK 6: DUPLICATE AE RECORDS";
     RUN;


/*                  EDIT CHECK 7: UNMATCHED SUBJECTS */
PROC SQL;
       create table unmatched_ae_subjects as
       select distinct ae.subjid
       from clinical.ae as ae
       
        left join clinical.demog as demog
        on ae.subjid=demog.subjid
        
        where demog.subjid is null;
        
quit;

proc print data=work.unmatched_ae_subjects;
    title "Edit Check 7 - AE Subjects Not Found in DEMOG";
run;





















