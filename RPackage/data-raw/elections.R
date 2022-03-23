
library(dplyr)

elect <- data.frame(rbind(c(0.1830, 0.1220, 0.1130, 0.0294, 0.4321, 0.0584, 0.0553, NA, 0),
                          c(0.2192, 0.0912, 0.0850, 0.0714, 0.3771, 0.0451, 0.0338, 0.0009, 0),
                          c(0.2238, 0.0719, 0.0765, 0.0407, 0.4525, 0.0616, 0.0502, 0.0025, 0),
                          c(0.2290, 0.0472, 0.0513, 0.1177, 0.3639, 0.1199, 0.0449, 0.0037, 0),
                          c(0.1525, 0.1339, 0.0619, 0.0914, 0.3985, 0.0838, 0.0464, 0.0144, 0),
                          c(0.2623, 0.0754, 0.0788, 0.0659, 0.3499, 0.0585, 0.0524, 0.0293, 0.0068),
                          c(0.3006, 0.0706, 0.0656, 0.0560, 0.3066, 0.0560, 0.0734, 0.0570, 0.0040),
                          c(0.2333, 0.0542, 0.0611, 0.0457, 0.3101, 0.0572, 0.0689, 0.1286, 0.0312),
                          c(0.1984, 0.0549, 0.0861, 0.0632, 0.2826, 0.0800, 0.0441, 0.1753, 0.0046)))
elect <- elect*100
colnames(elect) <- c("M", "L", "C", "KD", "S", "V", "MP", "SD", "FI")

elec_date <- c(as.Date('1988-09-18'), as.Date('1991-09-15'), as.Date('1994-09-18'), as.Date('1998-09-20'), as.Date('2002-09-15'), as.Date('2006-09-17'),as.Date('2010-09-19'),as.Date('2014-09-14'), as.Date('2018-09-09'))
publ_year <- c("1988-sep", "1991-sep", "1994-sep", "1998-sep", "2002-sep", "2006-sep","2010-sep","2014-sep", "2018-sep")
eligible_votes <- c(5373719, 5470761, 5555540, 5261122, 5303212, 5551278, 6028682, 6290016, 6532063)

elections <- tibble(PublYearMonth = publ_year,
                        Company = rep(as.character(NA), nrow(elect)),
                        M=elect$M,
                        L=elect$L,
                        C=elect$C,
                        KD=elect$KD,
                        S=elect$S,
                        V=elect$V,
                        MP=elect$MP,
                        SD=elect$SD,
                        FI = elect$FI,
                        Uncertain = rep(as.numeric(NA), nrow(elect)),
                        n = eligible_votes,
                        PublDate = elec_date,
                        collectPeriodFrom = elec_date,
                        collectPeriodTo = elec_date,
                        approxPeriod = FALSE,
                        house = "Election")

#usethis::proj_activate(path= "RPackage")
usethis::use_data(elections, overwrite = TRUE)




