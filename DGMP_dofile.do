/*******************************************************************************
Replication Package

Paper: "Small Firms' Financial Decisions under Social Factors and Information
Complexity: Does Financial Culture Play a Role?"

Authors: AD, LG, AM, MP

Journal: Submitted to the Journal of Economic Behavior & Organization

Last updated: November 2026

Description:
This replication package contains the data and code required to reproduce all the tables reported in the paper.

Instructions:
- Set the project directory in line 29, and ensure that "DGMP_dataset.dta" is saved in the project directory.
- Run DGMP_dofile.do.
- All results will be generated in the selected folder.

Computational requirements: 
Stata 18 or later.
*******************************************************************************/


clear all

* Project directory
global folder "PROJECT_DIRECTORY_HERE"  
 
cd $folder



use "$folder\DGMP_dataset.dta", clear



*********************************
* Table 5: Descriptive statistics
*********************************
eststo clear
estpost summarize lt_loan overdraft dk FK_score high_FK female one_person one_bank used_mortgage high_fin_fam entrepren_parents
esttab using table5.txt, cells("mean(fmt(2)) sd(fmt(2)) min(fmt(1)) max(fmt(1))") label replace



************************
* Table 6: ATE Estimates
************************
reg lt_loan treated1 treated2, r 
outreg2 using "$folder\table6.xml", replace dec(2) label
reg lt_loan treated1 treated2 one_person female, r
outreg2 using "$folder\table6.xml", append dec(2) label
reg lt_loan treated1 treated2 one_person female one_bank FK_score used_mortgage, vce(robust)
outreg2 using "$folder\table6.xml", append dec(2) label
reg lt_loan treated1 treated2 one_person female one_bank FK_score used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table6.xml", append dec(2) label



********************************
* Table 7: Heterogeneous effects 
********************************

* Financial Knowledge
reg lt_loan i.treated1##i.high_FK i.treated2, vce(robust)
outreg2 using "$folder\table7T1.xml", excel replace dec(2) ctitle(FK)
reg lt_loan i.treated1##i.high_FK i.treated2 one_person one_bank female used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table7T1.xml", excel append dec(2) ctitle (FK_ctrls)
reg lt_loan i.treated1 i.treated2##i.high_FK, vce(robust) 
outreg2 using "$folder\table7T2.xml", replace dec(2)  ctitle(FK)
reg lt_loan i.treated1 i.treated2##i.high_FK one_person one_bank female used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table7T2.xml", append dec(2)  ctitle (FK_ctrls)
* Gender
reg lt_loan i.treated1##i.female i.treated2, vce(robust)
outreg2 using "$folder\table7T1.xml", append dec(2) ctitle(gender)
reg lt_loan i.treated1##i.female i.treated2 FK_score one_person one_bank used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table7T1.xml", append dec(2) ctitle(gender_ctrls)
reg lt_loan i.treated1 i.treated2##i.female, vce(robust)
outreg2 using "$folder\table7T2.xml", append dec(2) ctitle(gender)
reg lt_loan i.treated1 i.treated2##i.female FK_score one_person one_bank used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table7T2.xml", append dec(2) ctitle(gender_ctrls) 
* Firm size
reg lt_loan i.treated1##i.one_person i.treated2, vce(robust)
outreg2 using "$folder\table7T1.xml", append dec(2) ctitle(firmsize)
reg lt_loan i.treated1##i.one_person i.treated2 FK_score one_bank female used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table7T1.xml", append dec(2) ctitle(firmsize_ctrls)
reg lt_loan i.treated1 i.treated2##i.one_person, vce(robust)
outreg2 using "$folder\table7T2.xml", append dec(2) ctitle(firmsize)
reg lt_loan i.treated1 i.treated2##i.one_person FK_score one_bank female used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table7T2.xml", append dec(2) ctitle(firmsize_ctrls)
* Relationship with banks
reg lt_loan i.treated1##i.one_bank i.treated2, vce(robust)
outreg2 using "$folder\table7T1.xml", append dec(2) ctitle(rel_banks)
reg lt_loan i.treated1##i.one_bank i.treated2 FK_score one_person female used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table7T1.xml", append dec(2) ctitle(rel_banks_ctrls)
reg lt_loan i.treated2##i.one_bank i.treated1, vce(robust)
outreg2 using "$folder\table7T2.xml", append dec(2) ctitle(rel_banks)
reg lt_loan i.treated2##i.one_bank i.treated1  FK_score one_person female used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table7T2.xml", append dec(2) ctitle(rel_banks_ctrls)



************************************************************************************
* Table 8: Assessing effort-driven biases
************************************************************************************

* Survey duration 
reg lt_loan i.treated1##long_time treated2, vce(robust)
outreg2 using "$folder\table8T1.xml", replace dec(2) ctitle(complexity)
reg lt_loan i.treated1##long_time treated2 one_bank FK_score one_person female used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table8T1.xml", append dec(2) ctitle(complexity_ctrls)
reg lt_loan i.treated2##long_time treated1, vce(robust)
outreg2 using "$folder\table8T2.xml", replace dec(2) ctitle(herding)
reg lt_loan i.treated2##long_time treated1 one_bank FK_score one_person female used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table8T2.xml", append dec(2) ctitle(herding_ctrls)


*************************************
* Table 9: Identifying causal pathways
*************************************

* Overdraft
reg overdraft treated1 treated2, vce(robust)
outreg2 using "$folder\table9.xml", replace dec(2) label ctitle(overdraft)
reg overdraft treated1 treated2 one_person female one_bank FK_score used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table9.xml", append dec(2) label ctitle(overdraft_ctrls)
* I don't know
reg dk treated1 treated2, vce(robust)
outreg2 using "$folder\table9.xml", append dec(2) label ctitle(dontknow)
reg dk treated1 treated2 one_person one_bank female FK_score  used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\table9.xml", append dec(2) label ctitle(dontknow_ctrls)
 
************************************************************************************
* Table 10: Assessing the role of entrepreneurial experience
************************************************************************************
* Financial Familiarity 
reg lt_loan i.treated1##high_fin_fam treated2, vce(robust)
outreg2 using "$folder\table10T1.xml", replace dec(2)  ctitle(FF_complexity)
reg lt_loan i.treated1##high_fin_fam treated2 one_person one_bank female FK_score  used_mortgage entrepren_parents, vce(robust)
outreg2 using "$folder\table10T1.xml", append dec(2)  ctitle(FF_complexity_ctrls)
reg lt_loan i.treated2##high_fin_fam treated1, vce(robust)
outreg2 using "$folder\table10T2.xml", replace dec(2) ctitle(FF_herding)
reg lt_loan i.treated2##high_fin_fam treated1 one_person one_bank female FK_score  used_mortgage entrepren_parents, vce(robust)
outreg2 using "$folder\table10T2.xml", append dec(2) ctitle(FF_herding_ctrls)
* Entrepreneurial Parents
reg lt_loan i.treated1##entrepren_parents treated2, vce(robust)
outreg2 using "$folder\table10T1.xml", append dec(2) ctitle(EP_complexity)
reg lt_loan i.treated1##entrepren_parents treated2  one_person one_bank female FK_score  used_mortgage high_fin_fam, vce(robust)
outreg2 using "$folder\table10T1.xml", append dec(2) ctitle(EP_complexity_ctrls)
reg lt_loan i.treated2##entrepren_parents treated1, vce(robust)
outreg2 using "$folder\table10T2.xml", append dec(2) ctitle(EP_herding)
reg lt_loan i.treated2##entrepren_parents treated1 one_person one_bank female FK_score  used_mortgage high_fin_fam, vce(robust)
outreg2 using "$folder\table10T2.xml", append dec(2) ctitle(EP_herding_ctrls)

**************************************************
* Table A3: Balancing test across treatment groups
**************************************************
preserve

local vars one_person female one_bank FK_score high_FK used_mortgage high_fin_fam fin_familiarity entrepren_parents south_island long_time over48 high_turnover banks_trust  d_primary d_secondary d_tertiary FK_8 high_FK_8 dk8 

cap drop group
gen str8 group="n.a."
replace group="control" if treated1==0 & treated2==0
replace group="treated1" if treated1==1 & treated2==0
replace group="treated2" if treated1==0 & treated2==1

local groupvar group  

local rownames
local i = 1

* Loop vars
foreach var of local vars {
    * Kruskal-Wallis test
    kwallis `var', by(`groupvar')

    * results
    local chi2 = r(chi2)
    local df = r(df)
    local pvalue = chi2tail(`df', `chi2')

    * avg values, groups
    bysort `groupvar': summarize `var'

		summarize `var' if group == "control", meanonly
		local mean_ctrl = r(mean)

		summarize `var' if group == "treated1", meanonly
		local mean_t1 = r(mean)
		
		summarize `var' if group == "treated2", meanonly
		local mean_t2 = r(mean)

    * store results
    if !missing(`pvalue') {
        matrix row = (`chi2', `df', `pvalue', `mean_ctrl', `mean_t1', `mean_t2')

        if `i' == 1 {
            matrix results = row
        }
        else {
            matrix results = results \ row
        }

        local rownames `rownames' `var'
        local ++i
    }
    else {
        di "`var' ha restituito un errore nel test Kruskal-Wallis! P-value mancante."
    }
}

* init matrix
matrix rownames results = `rownames'
matrix colnames results = chi2 df pval mean_ctrl mean_t1 mean_t2

* from matrix to dataset
clear
svmat double results, names(col)

* varnames
gen varname = ""
local i = 1
foreach var of local rownames {
    replace varname = "`var'" in `i'
    local ++i
}

* order
order varname  mean_ctrl mean_t1 mean_t2 chi2 df pval

cd

* export
export excel using tableA3.xlsx, firstrow(variables) replace

restore



**************************************************************
* Table A7: Alternative balancing test across treatment groups
**************************************************************

global vars one_person female one_bank FK_score high_FK used_mortgage high_fin_fam fin_familiarity entrepren_parents south_island long_time over48 high_turnover banks_trust d_primary d_secondary d_tertiary FK_8 high_FK_8 dk8 

	* descriptive statistics
  	eststo control: quietly estpost summarize $vars if control==1 
    eststo treated1: quietly estpost summarize $vars if treated1==1
	eststo treated2: quietly estpost summarize $vars if treated2==1
	* T-test
    eststo diff1: quietly estpost ttest $vars if treated2==0,  by(control) 
	eststo diff2: quietly estpost ttest $vars if treated1==0,  by(control) 
	eststo diff3: quietly estpost ttest $vars if control==0,  by(treated2)
    esttab control treated1 treated2 diff1 diff2 diff3 using tableA7, replace cells("mean(pattern(1 1 1 0 0 0) fmt(3)) sd(pattern(1 1 1 0 0 0)) b(star pattern(0 0 0 1 1 1) fmt(3)) p(pattern(0 0 0 1 1 1) par fmt(3))") label plain star


	
*****************************************************************
* Table A8: Alternative FK measure and controlling for confidence
*****************************************************************

* Alternative FK
reg lt_loan treated1 treated2 FK_8 one_person female one_bank used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\tableA8.xml", replace dec(2) ctitle("Alternative FK")
reg lt_loan i.treated1##i.high_FK_8 treated2 one_person female one_bank used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\tableA8.xml", append dec(2) ctitle("Alternative FK")
reg lt_loan i.treated2##i.high_FK_8 treated1 one_person female one_bank used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\tableA8.xml", append dec(2) ctitle("Alternative FK")

* Control for dk replies
reg lt_loan treated1 treated2 FK_8 dk8 female one_person female one_bank used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\tableA8.xml", append dec(2) ctitle("Control for dk replies")
reg lt_loan i.treated1##i.high_FK_8 treated2 dk8 one_person female one_bank used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\tableA8.xml", append dec(2) ctitle("Control for dk replies")
reg lt_loan i.treated2##i.high_FK_8 treated1 dk8 one_person female one_bank used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\tableA8.xml", append dec(2) ctitle("Control for dk replies")

*****************************************************************
* Table A9: Extended covariates and different regression model
*****************************************************************
reg lt_loan treated1 treated2 one_person female one_bank FK_score used_mortgage fin_familiarity entrepren_parents, vce(robust)
outreg2 using "$folder\tableA9.xml", replace dec(2) label ctitle("fin_familiarity")
reg lt_loan treated1 treated2 one_person female one_bank FK_score used_mortgage high_fin_fam entrepren_parents south_island over48 high_turnover banks_trust d_primary d_secondary d_tertiary, vce(robust)
outreg2 using "$folder\tableA9.xml", append dec(2) label ctitle("extended covariates")
probit lt_loan treated1 treated2 one_person female one_bank FK_score used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\tableA9.xml", append dec(2) label ctitle("probit")
bootstrap, reps(1000): reg lt_loan treated1 treated2 one_person female one_bank FK_score used_mortgage high_fin_fam entrepren_parents, vce(robust)
outreg2 using "$folder\tableA9.xml", append dec(2) label ctitle("bootstrap")
