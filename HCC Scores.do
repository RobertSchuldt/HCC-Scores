/*******************************************************************************
This is a project to look at the impact of HCC scores on patient experience 
measurses in home health care. This project is built off of the prior work
we conducted on Rural-Urban home health care disparities. 

@author: Robert F. Schuldt
@email:rfschuldt@uams.edu

This project uses a prior data set in a new and novel form of analysis. Minor 
changes to the data set may be made and documented here. 
*******************************************************************************/

set more off

clear

/*set directory*/
cd "\\FileSrv1\CMS_Caregiver\DATA\HCC Scores"

use "2015 Full Data Set"

/*Using fixed effects model so must encode the state*/

encode state, gen(stateid)

/* identify rural V urban */

gen log_distinct = log(distinct_beneficiaries__non_lupa)

gen rural_urban = 0 
replace rural_urban = 1 if urban == 1

foreach var of varlist bed1 bath1 breathing1 timely_manner1 drugs_mouth1 lesspain_move1 walk1 {

xtreg `var' ib1.rural_urban nfp gov poverty average_hcc_score percent_non_white /*
*/ percent_dual percent_female percap_pcp_15 percap_hosp_bed15 log_distinct tenure , fe i(stateid) vce(robust)

outreg2 using `var'reg.doc, replace 
}

/* Need to also create a summary of all variables for descriptive stats
table*/

/*measurements*/
sum bed1 bath1 breathing1 drugs_mouth1 lesspain_move1 walk1 timely_manner1

/*HHA characteristics*/

sum rural_urban nfp gov average_hcc_score percent_non_white  tenure/*
*/ percent_dual percent_female distinct_beneficiaries__non_lupa

sum poverty percap_pcp_15 percap_hosp_bed15  rural_urban
