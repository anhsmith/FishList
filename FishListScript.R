
library(rfishbase)
Sys.setenv(FISHBASE_API="sealifebase")

library(tidyverse)

# Download to tempfile
github_link <- "https://github.com/anhsmith/DuffyNZReefFish/raw/master/DuffyNZReefFishMASTER.xlsx"
library(httr)
temp_file <- tempfile(fileext = ".xlsx")
req <- GET(github_link,
           # authenticate using GITHUB_PAT
           authenticate(Sys.getenv("GITHUB_PAT"), ""),
           # write result to disk
           write_disk(path = temp_file))

# Import
tab <- readxl::read_excel(temp_file, sheet = "SpeciesInfo", col_names = T) |>
  select(`!Family` = Family,
         Genus,
         Species,
         CommonName = commonname,
         Code,
         Size = `Size(mm)`,
         MinDepth,
         MaxDepth,
         commonname,
         TaxonomicNotes )


# Write



write.table(tab, sep="\t",
            file = "MasseySpeciesList.txt",
            quote = F,
            row.names = F)

# # Check names
# vnfb <- validate_names(tab$genusspecies, server = "fishbase")
#
# cbind(tab$genusspecies,
#       vnfb,
#       tab$genusspecies==vnfb), file = "outfish.csv")
#




