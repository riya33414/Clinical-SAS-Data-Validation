# Clinical-SAS-Data-Validation
portfolio/ project for clinical trial data validation project using SAS 9.4, Base SAS and PROC SQL.

# Clinical Trial Data Validation Using SAS

## About the Project

I created this project to practice SAS and Clinical Data Management concepts using simulated clinical-trial-style data.

The main purpose was to understand how clinical datasets can be checked for missing data, incorrect values, duplicate records, and mismatches between datasets.

I worked on the data using SAS 9.4 / SAS Studio and created separate programs for different validation checks.

## Tools Used

* SAS 9.4
* SAS Studio
* Base SAS
* DATA Step
* PROC SQL
* PROC SORT
* PROC IMPORT
* PROC CONTENTS
* PROC PRINT
* Microsoft Excel

## Datasets

I used five simulated datasets:

| Dataset | What it contains                |
| ------- | ------------------------------- |
| DEMOG   | Subject demographic information |
| VITALS  | Vital sign measurements         |
| LABS    | Laboratory results              |
| AE      | Adverse event information       |
| VISIT   | Study visit information         |

## What I Checked

I performed checks for:

* Missing values
* Invalid values
* Duplicate records
* Invalid dates
* Invalid visit/status values
* Unmatched subjects
* Subject and visit mismatches

I also compared the datasets using PROC SQL to check whether the same subjects and visits were present where expected.

## SAS Programs

The SAS programs are organized in the `SAS_Programs` folder.

```text
SAS_Programs/
├── demog_validation_01.sas
├── vitals_validation_02.sas
├── labs_validation_03.sas
├── ae_validation_04.sas
├── visit_validation_05.sas
├── cross_dataset_validation_06.sas
└── validation_summary_07.sas
```

Each program focuses on a particular dataset or validation activity.

## What I Learned

While doing this project, I learned how to:

* Import CSV data into SAS
* Check dataset structure using PROC CONTENTS
* Review records using PROC PRINT
* Find duplicates using PROC SORT
* Use DATA step conditions for validation checks
* Use PROC SQL for matching subjects across datasets
* Work with SAS dates
* Identify and document data discrepancies

One useful part of the project was debugging my own validation code. I found that incorrect date conversion and SQL join conditions could produce misleading results, so I had to review and correct the logic before treating the findings as actual discrepancies.

## Project Documentation

The detailed project report is available in the `Documentation` folder.

## Disclaimer

This is a self-directed educational project using simulated/fictional clinical-trial-style data.

It is not based on a real clinical trial and does not contain real patient data or confidential company information.

## Author

**Riya Jagtap**

B.Pharm Graduate | Clinical SAS / Clinical Data Management Aspirant
