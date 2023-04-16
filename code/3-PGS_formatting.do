**Preping the risk PGI first 

import delimited final_snp_score_mrbs.profile, delimiter(whitespace, collapse)

**cidB2953 = aln 

*convert the ids into one which can be merged on, by stripping off the qlet from cidB2953

split iid, p("M" "A" "B" "C" "D")

gen qlet=substr(iid,-1,1)

rename iid1 aln

destring aln, replace

*Drop 

drop v1 fid iid pheno

*Rename to fix variable names:

rename score mrb_score

rename cnt mrb_cnt

encode qlet, gen(qlet2)

*Create children PGI
gen mrb_score_child = mrb_score
replace mrb_score_child = . if qlet2==5 

*Create mother PGI
gen mrb_score_mom = mrb_score
replace mrb_score_mom = . if  qlet2==1|qlet2==2|qlet2==3|qlet2==4

*Standardize the score for comparison:
egen zmrb_score=std(mrb_score)
egen zmrb_score_child = std(mrb_score_child)
egen zmrb_score_mom = std(mrb_score_mom)

save "formatted_mrb_score.dta", replace

clear

**** now do the same for Education 

import delimited final_snp_score_education.profile, delimiter(whitespace, collapse)
split iid, p("M" "A" "B" "C" "D")
gen qlet=substr(iid,-1,1)
rename iid1 aln
destring aln, replace
drop v1 fid iid pheno
rename score educ_score
rename cnt educ_cnt

encode qlet, gen(qlet2)

*Create children PGI
gen educ_score_child = educ_score
replace educ_score_child = . if qlet2==5 

*Create mom PGI
gen educ_score_mom = educ_score
replace educ_score_mom = . if  qlet2==1|qlet2==2|qlet2==3|qlet2==4


**Standardize score for comparison

egen zeduc_score=std(educ_score)
egen zeduc_score_child = std(educ_score_child)
egen zeduc_score_mom = std(educ_score_mom)


save "formatted_educ_score.dta", replace


********MERGE scores ***********

merge 1:1  aln qlet using "formatted_mrb_score.dta"
drop _merge

save "formatted_scores.dta", replace


clear
