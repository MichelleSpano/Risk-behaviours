*****************************************
*******Multiple Risk Behaviours***********
******************************************

**1.Physical Inactivity: Young Person (YP) has typically over the past year exercised <5 times a week 

gen ccs5510_n=ccs5510 //frequency during the past year YP did exercise 

gen inactivity=0 if  ccs5510_n== 1
replace inactivity=1 if ccs5510_n== 5| ccs5510_n== 4 |ccs5510_n== 3  | ccs5510_n== 2 

**2.Tv viewing: YP has spent 3 or more hours watching TV on average per day across the week 

gen ccs1003_n=ccs1003 // Tv on weekdays

gen tvtime=0 if ccs1003_n==3 | ccs1003_n==2 | ccs1003_n==1
replace tvtime=1 if ccs1003_n==4 

**3.Car passenger risk: YP had been a car passenger where the driver 1- had consumed alcohol or 2- did not have a valid licence or 3- YP chose not to wear a seat belt last time travelled in a car, van or taxi 

gen ccs7140_n=ccs7140
gen ccs7130_n=ccs7130
gen ccs7090_n=ccs7090 
gen passngr=0 if ccs7140_n==2 & ccs7130_n==2 & ccs7090_n==1 
replace passngr=1 if ccs7140_n==1 | ccs7130_n==1 | ccs7090_n==2 | ccs7090_n==3 


**4.Cycle helmet use: YP reported that they had last ridden bycicle within the previous 4 weeks and they had not worn a helmet on the most recent occassion 

gen ccs7190_n=ccs7190 
recode ccs7190_n -10/0=. 1=1 2=0 

gen ccs7230_n=ccs7230
recode ccs7230_n -10/0=. 1=0 2/3=1

gen helmetuse=0 if ccs7230_n==1 
replace helmetuse=1 if ccs7190_n==1 & ccs7230_n==0

egen helmetuse_miss= rowtotal(helmetuse) 
egen helmetuse_miss1= rowmiss(ccs7190_n ccs7230_n) 
replace helmetuse_miss = . if helmetuse_miss1 >0 


**5.Scooter risk: YP has driven a motorbike/scooter off road, or without a licence on a public road at least once 

gen ccs7170_n=ccs7170 //YP has ever driven a motorbike/scooter off the road 
gen ccs7172_n=ccs7172 //YP has ever driven a car on a public road without a licence 
gen scooter=0 if ccs7170_n==2 & ccs7172_n==2 
replace scooter=1 if ccs7170_n==1 | ccs7172_n==1

egen scooter_miss= rowtotal(helmetuse) 
egen scooter_miss1= rowmiss(ccs7170_n ccs7172_n) 
replace scooter_miss = . if scooter_miss1 >0 


**6.Criminal/Antisocial behaviour: YP reported that at least once in the past year they had undertaken one of the following: 1- carried a weapon or 2-physically hurt someone on purpose or 3-stolen something or 4-sold illicit subtances to another person or 5-damaged property belonging to someone else either by using grafitti, fire or destorying it or 6-subject someone to verbal or physical abuse or 7-been rude or rowdy in public place 

gen fh8320_n=fh8320 //1-frequency YP carried a weapon 

gen weapon=0 if fh8320_n==1 
replace weapon=1 if fh8320_n==2|fh8320_n==3|fh8320_n==4

gen fh8313_n=fh8313 //2-frequency YP has hit/kicked/punched someone else on purpose

gen hurt_others=0 if fh8313_n==1
replace hurt_others=1 if fh8313_n==2|fh8313_n==3|fh8313_n==4

gen fh8302_n=fh8302 //3-frequency YP has stolen something from a shop or store 
gen fh8316_n=fh8316 //3-requency YP has stolen money or property from someone 
gen fh8311_n=fh8311 //3- frequency YP has broken into a house or building to try to steal something 
gen fh8305_n=fh8305 //3-frequency YP has broken into a car/van to try and steal something out of

gen stolen=0 if fh8302_n==1 & fh8316_n==1 & fh8311_n==1 & fh8305_n==1 
replace stolen=1 if fh8302_n==2|fh8302_n==3|fh8302_n==4|fh8316_n==2|fh8316_n==3|fh8316_n==4 | fh8311_n==2| fh8311_n==3 | fh8311_n==4 |fh8305_n==2| fh8305_n==3 | fh8305_n==4 

gen fh8303_n=fh8303 //4-frequency YP has sold an illegal drug 

gen sold_drug=0 if fh8303_n==1 
replace sold_drug=1 if fh8303_n==2|fh8303_n==3|fh8303_n==4 

gen fh8314_n=fh8314 //5-frequency YP has deliberately damaged or destroyed others property
gen fh8301_n=fh8301 //5-frequency YP has written/painted on others property 
gen fh8319_n=fh8319 //5-Frequency YP has tried or set something on fire 

gen damaged_prop=0 if fh8314_n==1 & fh8301_n==1 & fh8319_n==1
replace damaged_prop=1 if fh8314_n==2| fh8314_n==3| fh8314_n==4| fh8301_n==2| fh8301_n==3| fh8301_n==4| fh8319_n==2|fh8319_n==3| fh8319_n==4

gen fh8317_n=fh8317 // 6-frequency YP has hit or picked on someone because of their race or skin 

gen verb_abuse=0 if fh8317_n==1
replace verb_abuse=1 if fh8317_n==2|fh8317_n==3|fh8317_n==4

gen fh8321_n=fh8321 //7-frequency YP has been rowdy or rude in public such people complained 

gen rowdy=0 if fh8321_n==1 
replace rowdy=1 if fh8321_n==2|fh8321_n==3|fh8321_n==4

gen CrimBehaviour=0 if weapon==0 & hurt_others==0 & stolen==0 & sold_drug==0 & verb_abuse==0 & rowdy==0 & damaged_prop==0
replace CrimBehaviour=1 if weapon==1|hurt_others==1|stolen==1|sold_drug==1|verb_abuse==1|rowdy==1| damaged_prop==1

**7.Harzardous alcohol consumption: In the past year had score 8 or more on the Alcohol Use Disorders Identification Test indicating harzardous alcohol consumption 

//give each answer a score to then calculate AUDIT// 

gen ccs3541_n=ccs3541 //Number of units YP consumes a day when they are consuming alcohol 

gen unit_drink=0 if ccs3541_n==1 
replace unit_drink=1 if ccs3541_n==2
replace unit_drink=2 if ccs3541_n==3
replace unit_drink=3 if ccs3541_n==4
replace unit_drink=4 if ccs3541_n==5


gen ccs3540_n=ccs3540 //frequency YP has a drink containing alcohol

gen freq_drink=0 if ccs3540_n==1
replace freq_drink=1 if ccs3540_n==2
replace freq_drink=2 if ccs3540_n==3
replace freq_drink=3 if ccs3540_n==4
replace freq_drink=4 if ccs3540_n==5


gen ccs3542_n=ccs3542 //frequency YP has 6 or more units of alcohol in one occasion 

gen sixdrink=0 if ccs3542_n==1 
replace sixdrink=1 if ccs3542_n==2 
replace sixdrink=2 if ccs3542_n==3
replace sixdrink=3 if ccs3542_n==4 
replace sixdrink=4 if ccs3542_n==5

gen ccs3543_n=ccs3543 //frequency during last year YP has found they were unable to stop drinking

gen stopdrink=0 if ccs3543_n==1
replace stopdrink=1 if ccs3543_n==2
replace stopdrink=2 if ccs3543_n==3
replace stopdrink=3 if ccs3543_n==4
replace stopdrink=4 if ccs3543_n==5

gen ccs3544_n=ccs3544 //frequency during the last year YP has failed to do what was normally expected 

gen normalfunct=0 if ccs3544_n==1
replace normalfunct=1 if ccs3544_n==2
replace normalfunct=2 if ccs3544_n==3
replace normalfunct=3 if ccs3544_n==4
replace normalfunct=4 if ccs3544_n==5

gen ccs3545_n=ccs3545 //frequency during the last year YP has needed a drink in the morning 
gen morndrink=0 if ccs3545_n==1 
replace morndrink=1 if ccs3545_n==2
replace morndrink=2 if ccs3545_n==3
replace morndrink=3 if ccs3545_n==4
replace morndrink=4 if ccs3545_n==5

gen ccs3546_n=ccs3546 //frequency during the last year YP has felt guilty/remorseful after drinking

gen guiltdrink=0 if ccs3546_n==1
replace guiltdrink=1 if ccs3546_n==2
replace guiltdrink=2 if ccs3546_n==3
replace guiltdrink=3 if ccs3546_n==4
replace guiltdrink=4 if ccs3546_n==5
 
gen ccs3547_n=ccs3547 //frequency during the last year YP has been unable to remember the night before 

gen memorydrink=0 if ccs3547_n==1
replace memorydrink=1 if ccs3546_n==2
replace memorydrink=2 if ccs3546_n==3
replace memorydrink=3 if ccs3546_n==4
replace memorydrink=4 if ccs3546_n==5

gen ccs3548_n=ccs3548 //frequency during the last year someone has been injured as a result of YP drinking 

gen injurydrink=0 if ccs3548_n==1
replace injurydrink=2 if ccs3548_n==2
replace injurydrink=4 if ccs3548_n==3

gen ccs3549_n=ccs3549 //a relative/friend/doctor/health worker has been concerned about YP's drinking 

gen concerndrink=0 if ccs3549_n==1
replace concerndrink=2 if ccs3549_n==2 
replace concerndrink=4 if ccs3549_n==3 

gen audit_score =(freq_drink + sixdrink + stopdrink + normalfunct + morndrink + guiltdrink + memorydrink + injurydrink + concerndrink + unit_drink)

gen audit=0 if audit_score<8
replace audit=1 if audit_score>=8 & audit_score!=.

egen audit_new= rowtotal(freq_drink_new sixdrink_new stopdrink_new normalfunct_new morndrink_new guiltdrink_new memorydrink_new injurydrink_new concerndrink_new unit_drink_new), missing
recode audit_new (.=.) (0/7=0) (8/36=1), gen(audit_new_binary)

**8.Regular tabacco use: Has ever smoked and is regularly smoking at least one cigarrette per week

gen ccs4005_n=ccs4005 //frequency YP smokes cigarettes 
gen ccs4000_n=ccs4000 //YP has ever smoked a cigarette/roll-up 

gen smktab=0 if ccs4005_n==1 | ccs4005_n==2| ccs4000_n==2|ccs4005_n==3
replace smktab=1 if ccs4005_n==4|ccs4005_n==5|ccs4005_n==6

egen smktab_s= rowtotal(smktab)
egen smktab_miss= rowmiss(smktab)
egen smktab_miss1= rowmiss(ccs4005_n ccs4000_n)

replace smktab_s =. if smktab_miss1>0

replace smktab_s=. if smktab_miss>0 // which one should I go for? 

**9.Cannabis use: Those who reported using cannabis sometimes but less often than once a week or more regular use was classified as occassional users.

gen ccs4065_n=ccs4065 //frequency YP smokes cannabis 
gen ccs4060_n=ccs4060 //YP has ever tried cannabis
 
gen smkcan=0 if ccs4060_n==2 | ccs4065_n==3 | ccs4065_n==2 | ccs4065_n==1
replace smkcan=1 if ccs4065_n==3| ccs4065_n==4|ccs4065_n==5|ccs4065_n==6

egen smkcan_s= rowtotal (smkcan)
egen smkcan_miss= rowmiss (smkcan)
egen smkcan_miss1=rowmiss (ccs4065_n ccs4060_n)


replace smkcan_s=. if smkcan_miss>0
replace smkcan_s=. if smkcan_miss1>0


**10.Illicit drug use/solvent use: In the year since their 15th birthday, YP has either been a regular user (i.e, used >=5 times) of one or more illicit drug (excluding cannabis) including amphetamines, ectasy, lysergic acid diethylamide (LSD), cocaine, ketamine or inhalants including aerosol, gas, solvents, and poppers.

gen ccs4160_n=ccs4160 //since their 15th birthday YP has used/taken amphetamines
gen ccs4161_n=ccs4161 //since their 15th birthday YP has used taken ecstasy 
gen ccs4162_n=ccs4162 //since their 15th birthday YP has used taken LSD 
gen ccs4165_n=ccs4165 //since their 15th birthday YP has used taken cocaine
gen ccs4163_n=ccs4163 //since their 15th birthday YP has used taken magic mushrooms
gen ccs4166_n=ccs4166 //since their 15th birthday YP has used taken crack
gen ccs4167_n=ccs4167 //since their 15th birthday YP has used taken heroins 
gen ccs4168_n=ccs4168

gen new_drugs=0 if ccs4160_n==1 & ccs4161_n==1 & ccs4162_n==1 & ccs4165_n==1 & ccs4168_n==1 & ccs4163_n==1 & ccs4166_n==1 & ccs4167_n==1 
replace new_drugs=1 if ccs4160_n==2 | ccs4160_n==3 | ccs4161_n==2 | ccs4161_n==3  |ccs4162_n==2 | ccs4162_n==3 |ccs4165_n==2 | ccs4165_n==3 | ccs4168_n==2 | ccs4168_n==3 | ccs4163_n==2 | ccs4163_n==3 | ccs4166_n==2 | ccs4166_n==3 | ccs4167_n==2 | ccs4167_n==3
gen new_drugs_with_missing=new_drugs
replace new_drugs_with_missing=. if ccs4160_n==. | ccs4161_n==. |ccs4162_n==. | ccs4165_n==. | ccs4168_n==. | ccs4163_n==. | ccs4166_n==. | ccs4167_n==.

**11.Self-harm=YP who said they had purposely hurt themselves in some way in their lifetime 

gen ccs6530_n= ccs6530 //YP has hurt themselves on purpose 

gen selfhrm=0 if ccs6530_n==2 
replace selfhrm=1 if ccs6530_n==1


**12.Penetrative sex before the age of 16: YP reported having had penetrative sex in the preceding year and that they were under 16 at the time 

gen fh8800_n=fh8800 // Teenager started the romantic relations questionnaire
gen fh9114_n=fh9114 //This was the first time that YP had sexual intercourse with another young person 
gen fh9115_n=fh9115 // Age of YP the first time they had sexual intercourse 

gen age=fh0011a/12
gen sexundr16=1 if fh9100==1 & age<16
replace sexundr16=1 if fh9115<16
replace sexundr16=0 if fh8800==1 & sexundr16==.

egen sexundr16_s= rowtotal(sexundr16)
egen sexundr16_miss= rowmiss (sexundr16)
egen sexundr16_miss1= rowmiss (fh8800_n fh9114_n fh9115_n)

replace sexundr16_s =. if sexundr16_miss1>0 


**13.Unprotected sex: Penetrative sex without the use of contraception on the last occasion they had had sex in the past year 

gen fh9109_n=fh9109 // YP or other young person used a condom when last had sexual intercourse 
gen fh9111_n=fh9111 // Other type of contraception used when last had sexual intercourse 

gen sex_age=0 if fh8800_n==1
replace sex_age=1 if fh8800_n==2

gen unprotsex=0 if sex_age==0 | fh9109==1| fh9111_n==1/4 
replace unprotsex=1 if fh9109==2 

egen unprotsex_s= rowtotal(unprotsex)
egen unprotsex_miss= rowmiss(unprotsex)
egen unprotsex_miss1= rowmiss(fh9109_n fh9111_n)

replace unprotsex_s=. if unprotsex_miss>0 

egen unprotsex_s1= rowtotal(unprotsex)
replace unprotsex_s1=. if unprotsex_miss1>0

*Generate Multiple Risk Behaviours Index (MRBI)
gen mrbs = (inactivity + tvtime + passngr + helmetuse + scooter + new_drugs_with_missing + smkcan + smktab + audit_new_binary + selfhrm + sexundr16 + unprotsex + CrimBehaviour)
