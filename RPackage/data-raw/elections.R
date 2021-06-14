
library(dplyr)

elect <- data.frame(rbind(c(0.2623, 0.0754, 0.0788, 0.0659, 0.3499, 0.0585, 0.0524, 0.0293, 0.0068),
                          c(0.3006, 0.0706, 0.0656, 0.0560, 0.3066, 0.0560, 0.0734, 0.0570, 0.0040),
                          c(0.2333, 0.0542, 0.0611, 0.0457, 0.3101, 0.0572, 0.0689, 0.1286, 0.0312),
                          c(0.1984, 0.0549, 0.0861, 0.0632, 0.2826, 0.0800, 0.0441, 0.1753, 0.0046)))
elect <- elect*100
colnames(elect) <- c("M", "L", "C", "KD", "S", "V", "MP", "SD", "FI")

elec_date <- c(as.Date('2006-09-17'),as.Date('2010-09-19'),as.Date('2014-09-14'), as.Date('2018-09-09'))

elections <- tibble(PublYearMonth = c("2006-sep","2010-sep","2014-sep", "2018-sep"),
                        Company = rep(as.character(NA), 4),
                        M=elect$M,
                        L=elect$L,
                        C=elect$C,
                        KD=elect$KD,
                        S=elect$S,
                        V=elect$V,
                        MP=elect$MP,
                        SD=elect$SD,
                        FI = elect$FI,
                        Uncertain = rep(as.numeric(NA), 4),
                        n = c(5551278, 6028682, 6290016, 6532063),
                        PublDate = elec_date,
                        collectPeriodFrom = elec_date,
                        collectPeriodTo = elec_date,
                        approxPeriod = FALSE,
                        house = "Election")

#usethis::proj_activate(path= "RPackage")
usethis::use_data(elections, overwrite = TRUE)




