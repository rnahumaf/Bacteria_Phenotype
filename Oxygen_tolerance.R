# Extract oxygen tolerance from website
# This was necessary because extraction using the API was returning an error (2018-sep-28)

library(rvest)

# Create the scaffold for adding data to
m.list <- matrix(ncol=1)
m.list = NULL

# For each i in URL, add resulting page to a list 
for(i in 0:80){
  print(i)
  uRl <- paste0("https://bacdive.dsmz.de/advsearch?advsearch=search&site=advsearch&searchparams[73][contenttype]=text&searchparams[73][typecontent]=contains&searchparams[73][searchterm]=*&searchparams[921][searchterm]=*&pfc=",
               i)
  html <- read_html(uRl)
  # Extract certain elements from table, delimited using 'SelectorGadget'
  # Save elements to a list
  nodes <- html_nodes(html, ".searchresultrow2 span , .searchresultrow1 span")
  list <- html_text(nodes)
  u.list <- unlist(list)
  m.list <- rbind(m.list, matrix(u.list, ncol=1, byrow = T))
}

mm.list <- matrix(1:162, ncol=2, byrow=T) # Create the scaffold for adding data to
mm.list <- NULL

# Retrieve only needed information (Species name and oxygen tolerance status)
for(i in 1:length(m.list)){
  if(m.list[i]=="\n                        "){
  # Everything is calculated based on where "\n" is identified in the list
    if(grepl("e.g. Escherichia coli", m.list[i+4])==T){
      mm.list <- rbind(mm.list, matrix(m.list[(i+4):(i+5)], ncol=2, byrow = T))
    }
    if(grepl("e.g. Escherichia coli", m.list[i+5])==T){
      mm.list <- rbind(mm.list, matrix(m.list[(i+5):(i+6)], ncol=2, byrow = T))
    }
  }
}

mm.list[1:20,]

save(m.list, file = "oxygen_ind.RData")
write.csv(mm.list, file = "oxygen_ind.csv")








