#installed Rtools (not a package) as specified here: https://cran.r-project.org/bin/windows/Rtools/rtools42/rtools.html
install.packages("cachem")
install.packages("devtools")
install.packages("calibrate")
install.packages("ggthemes")
install.packages("xlsx")
install.packages("ggrepel")
install.packages("TwoSampleMR")
install.packages("MRInstruments")
install.packages("plyr")
install.packages("ggplot2")
install.packages("png")
install.packages("gmodels")

install.packages("remotes")
remotes::install_github("MRCIEU/TwoSampleMR")
devtools::install_github("MRCIEU/MRInstruments")
library(MRInstruments) 

library(cachem)
library(calibrate)
library(ggrepel)
library(ggthemes)
library(devtools)
library(TwoSampleMR)
library(MRInstruments)
data(gwas_catalog)
library(xlsx)
library(plyr) 
library(ggplot2)
library(png)
library(gmodels)
library(foreign)

#Read in the ALSPAC bim file 
alspac_fullsample_rsids <- read.delim("/combined.bim", header=FALSE)

####################################################################################################################
#*****************************************************************************************************************************************************
#EA4
#GWAS (available here:https://thessgac.com/papers/14/3)
#SSGAC data portal needs login in to download
ea4_snps = read.table("EA4_additive_p1e-5_clumped.txt", header=TRUE)
#rename
colnames(ea4_snps)=c("SNP","chr","pos","effect_allele","other_allele","EAF_HRC", "beta.exposure","se.exposure","se.exposure.unadj", "pval.exposure", "pval.exposure.unadj")


#Restrict to those in alspac
ea4_snps_common<-ea4_snps[which(as.character(ea4_snps$SNP) %in% as.character(alspac_fullsample_rsids$V2)), ]

#clump: identify independent, GWS ones
clumped_alspac_ea4_snps <- clump_data(subset(ea4_snps_common, pval.exposure<5e-08),clump_r2 = 0.01, clump_kb = 10000)
head (clumped_alspac_ea4_snps)

#Output:
#snplist, to import into tsd
write.table(subset(clumped_alspac_ea4_snps,select=c(SNP, effect_allele,beta.exposure)), "clumped_alspac_ea4_snps.txt", col.names = FALSE, row.names = FALSE, quote=FALSE)
#all snp info
write.table(clumped_alspac_ea4_snps, "clumped_alspac_ea4_snps_allinfo.txt",  sep="\t" , quote=FALSE, row.names = FALSE)
#info formatted for display
write.csv(subset(clumped_alspac_ea4_snps,select=c(SNP, effect_allele, other_allele, beta.exposure, se.exposure,pval.exposure)), "clumped_alspac_ea4_snpss_display.csv", quote=FALSE, row.names = FALSE)

####################################################################################################################
#*****************************************************************************************************************************************************
#RISK GWAS 
#GWAS (but unclumped? available here:https://thessgac.com/papers/14/3)
#SSGAC data portal needs login in to download
mrbs_snps = read.table("RISK_GWAS_MA_UKB+23andMe+replication.txt", header=TRUE)
#rename
colnames(mrbs_snps)=c("SNP","chr","pos","effect_allele","other_allele","EAF_HRC", "beta.exposure","se.exposure","pval.exposure")

#Restrict to those in alspac
mrbs_snps_common<-mrbs_snps[which(as.character(mrbs_snps$SNP) %in% as.character(alspac_fullsample_rsids$V2)), ]
#clump: identify independent, GWS ones
clumped_alspac_mrbs_snps <- clump_data(subset(mrbs_snps_common, pval.exposure<5e-08),clump_r2 = 0.01, clump_kb = 10000)

head (clumped_alspac_mrbs_snps)

#Output:
#snplist, to import into tsd
write.table(subset(clumped_alspac_mrbs_snps,select=c(SNP, effect_allele,beta.exposure)), "clumped_alspac_mrbs_snps.txt", col.names = FALSE, row.names = FALSE, quote=FALSE)
#all snp info
write.table(clumped_alspac_ea4_snps, "clumped_alspac_mrbs_snps_allinfo.txt",  sep="\t" , quote=FALSE, row.names = FALSE)
#info formatted for display
write.csv(subset(clumped_alspac_ea4_snps,select=c(SNP, effect_allele, other_allele, beta.exposure, se.exposure,pval.exposure)), "clumped_alspac_mrbs_snpss_display.csv", quote=FALSE, row.names = FALSE)

