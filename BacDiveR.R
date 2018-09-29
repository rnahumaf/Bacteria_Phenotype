
# Install BacDiveR to access bacteria phenotype databases
# Remember to get a login and password by registering on their website (~1 day for approval)

if(!require('devtools')) install.packages('devtools')
devtools::install_github('TIBHannover/BacDiveR', ref = 'v0.7.0')

# Check if login and password are correct
file.edit(file.path(Sys.getenv('HOME'), '.Renviron'))

### START DATA ACQUISITION
library(BacDiveR)

# Gram-positive bacteria
Gram_pos <- retrieve_search_results("https://bacdive.dsmz.de/advsearch?advsearch=search&site=advsearch&searchparams[42][searchterm]=positive")

# Gram-negative bacteria
Gram_neg <- retrieve_search_results("https://bacdive.dsmz.de/advsearch?advsearch=search&site=advsearch&searchparams[42][searchterm]=negative")

# Gram-variable bacteria
Gram_var <- retrieve_search_results("https://bacdive.dsmz.de/advsearch?advsearch=search&site=advsearch&searchparams[42][searchterm]=variable")

### Formula equivalence ###
Gram_pos[[1]][[1]][[2]][[7]] # This is the information that I want
Gram_pos$`106`$`taxonomy_name`$strains$species # This is the information that I want

Species <- function(x){x[[1]][[1]][[12]]} # This gets the information that I want, using a function
Species <- function(x){x$taxonomy_name$strains$species} # This gets the information that I want, using a function
###########################

# Output adjustments

Species <- function(x){x$taxonomy_name$strains$species}
Aerobic <- function(x){x$morphology_physiology$oxygen_tolerance$oxygen_tol}

Name_g_pos <- sapply(Gram_pos,Species)
length(Name_g_pos)
Name_g_pos[1913] # Check if last item matches

Name_g_neg <- sapply(Gram_neg,Species)
length(Name_g_neg)
Name_g_neg[3196] # Check if last item matches

Name_g_var <- sapply(Gram_var,Species)
length(Name_g_var)
Name_g_var[88] # Check if last item matches

Aerobic_g_pos <- sapply(Gram_pos,Aerobic)
length(Aerobic_g_pos)
Aerobic_g_pos[1913] # Check if last item matches

Aerobic_g_neg <- sapply(Gram_neg,Aerobic)
length(Aerobic_g_neg)
Aerobic_g_neg[3196] # Check if last item matches

Aerobic_g_var <- sapply(Gram_var,Aerobic)
length(Aerobic_g_var)
Aerobic_g_var[88] # Check if last item matches

# Avoid problems by Collapsing rows with multiple items (oxygen tolerance)

A.pos <- lapply(Aerobic_g_pos, paste, collapse=", ")
A.neg <- lapply(Aerobic_g_neg, paste, collapse=", ")
A.var <- lapply(Aerobic_g_var, paste, collapse=", ")

A.pos <- unlist(A.pos)
A.neg <- unlist(A.neg)
A.var <- unlist(A.var)

# Group into a final object

Gram_Positive_Final <- data.frame(BacDive_ID = names(Name_g_pos),
                                  Name = Name_g_pos,
                                  Oxygen = A.pos)
Gram_Negative_Final <- data.frame(BacDive_ID = names(Name_g_neg),
                                  Name = Name_g_neg,
                                  Oxygen = A.neg)
Gram_Variable_Final <- data.frame(BacDive_ID = names(Name_g_var),
                                  Name = Name_g_var,
                                  Oxygen = A.var)

# Save objects in separate files

save(Gram_pos, Gram_neg, Gram_var, Species, Aerobic, file = "Gram_pos_neg.RData")
write.csv(Nomes_Gram_Positivos, file = "g_positive.csv")
write.csv(Nomes_Gram_Negativos, file = "g_negative.csv")
write.csv(Nomes_Gram_Variaveis, file = "g_variable.csv")





