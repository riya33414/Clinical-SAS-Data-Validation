/*=========================================================
  07_Validation_Summary.sas
  Clinical Trial Data Validation Summary
=========================================================*/

data work.validation_summary;

    length dataset $10 check_name $40 result $20;

    dataset="VITALS";
    check_name="Unmatched Subjects";
    result="2 found";
    output;

    dataset="LABS";
    check_name="Unmatched Subjects";
    result="1 found";
    output;

    dataset="AE";
    check_name="Unmatched Subjects";
    result="1 found";
    output;

    dataset="VISIT";
    check_name="Unmatched Subjects";
    result="1 found";
    output;

    dataset="VITALS";
    check_name="Visits Not Found in VISIT";
    result="20 found";
    output;

    dataset="LABS";
    check_name="Visits Not Found in VISIT";
    result="0 found";
    output;

    dataset="AE";
    check_name="Subjects Not Found in VISIT";
    result="2 found";
    output;

run;

proc print data=work.validation_summary noobs;
    title "Clinical Trial Data Validation Summary";
run;
