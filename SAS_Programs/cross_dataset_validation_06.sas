/*=========================================================
  06_Cross_Dataset_Validation.sas
  Cross-Dataset Subject Validation
=========================================================*/

/* CHECK 1: VITALS subjects not found in DEMOG */

proc sql;
    create table work.vitals_unmatched as
    select distinct v.subjid
    from clinical.vitals as v
    left join clinical.demog as d
        on v.subjid = d.subjid
    where d.subjid is null;
quit;

proc print data=work.vitals_unmatched;
    title "VITALS Subjects Not Found in DEMOG";
run;


/* CHECK 2: LABS subjects not found in DEMOG */

proc sql;
    create table work.labs_unmatched as
    select distinct l.subjid
    from clinical.labs as l
    left join clinical.demog as d
        on l.subjid = d.subjid
    where d.subjid is null;
quit;

proc print data=work.labs_unmatched;
    title "LABS Subjects Not Found in DEMOG";
run;


/* CHECK 3: AE subjects not found in DEMOG */

proc sql;
    create table work.ae_unmatched as
    select distinct a.subjid
    from clinical.ae as a
    left join clinical.demog as d
        on a.subjid = d.subjid
    where d.subjid is null;
quit;

proc print data=work.ae_unmatched;
    title "AE Subjects Not Found in DEMOG";
run;


/* CHECK 4: VISIT subjects not found in DEMOG */

proc sql;
    create table work.visit_unmatched as
    select distinct v.subjid
    from clinical.visit as v
    left join clinical.demog as d
        on v.subjid = d.subjid
    where d.subjid is null;
quit;

proc print data=work.visit_unmatched;
    title "VISIT Subjects Not Found in DEMOG";
run;

/*        IDENTIFY THE UNMATCHED ID */

proc print data=work.vitals_unmatched;
    title "VITALS Unmatched Subjects";
run;

proc print data=work.labs_unmatched;
    title "LABS Unmatched Subjects";
run;

proc print data=work.ae_unmatched;
    title "AE Unmatched Subjects";
run;

proc print data=work.visit_unmatched;
    title "VISIT Unmatched Subjects";
run;


/* CHECK 5: VITALS VISITS NOT FOUND IN VISIT DATASET */

proc sql;
    create table work.vitals_visit_check as
    select distinct v.subjid, v.visit
    from clinical.vitals as v
    inner join clinical.demog as d
        on v.subjid = d.subjid
    left join clinical.visit as vi
        on v.subjid = vi.subjid
        and v.visit = vi.visit
    where vi.subjid is null;
quit;

proc print data=work.vitals_visit_check noobs;
    title "VITALS Visits Not Found in VISIT Dataset";
run;


/* CHECK 6: LABS VISITS NOT FOUND IN VISIT DATASET */

proc sql;
    create table work.labs_visit_check as
    select distinct l.subjid, l.visit
    from clinical.labs as l
    inner join clinical.demog as d
        on l.subjid = d.subjid
    left join clinical.visit as v
        on l.subjid = v.subjid
        and l.visit = v.visit
    where v.subjid is null;
quit;

proc print data=work.labs_visit_check noobs;
    title "LABS Visits Not Found in VISIT Dataset";
run;


/* CHECK 7: AE SUBJECTS NOT FOUND IN VISIT DATASET */

proc sql;
    create table work.ae_visit_check as
    select distinct a.subjid
    from clinical.ae as a
    left join clinical.visit as v
        on a.subjid = v.subjid
    where v.subjid is null;
quit;

/*         DISCREPANCY SUMMARY */

proc print data=work.ae_visit_check noobs;
    title "AE Subjects Not Found in VISIT Dataset";
run;

proc print data=work.vitals_unmatched noobs;
    title "VITALS - Unmatched Subjects";
run;

proc print data=work.labs_unmatched noobs;
    title "LABS - Unmatched Subjects";
run;

proc print data=work.ae_unmatched noobs;
    title "AE - Unmatched Subjects";
run;

proc print data=work.visit_unmatched noobs;
    title "VISIT - Unmatched Subjects";
run;

proc print data=work.vitals_visit_check noobs;
    title "VITALS - Visits Not Found in VISIT";
run;

proc print data=work.labs_visit_check noobs;
    title "LABS - Visits Not Found in VISIT";
run;

proc print data=work.ae_visit_check noobs;
    title "AE - Subjects Not Found in VISIT";
run;

