
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
  transmute(`!Family` = Family,
         Genus,
         Species,
         Code = str_remove(Code, "[.]"),
         CommonName = commonname,
         Size = `Size(mm)`,
         MinDepth,
         MaxDepth,
         TaxonomicNotes )



# Check that all codes are unique (should return 0)
anyDuplicated(tab$Code)

# Write all the info to an excel file
write_csv(tab, file = "MasseySpeciesListInfo.csv",
                quote = "none")

# Write just family, genus, species, and code to species list file
tab |>
  select(1:4) |>

  # add inverts
  rbind(c(
    '!Family' = 'Palinuridae',
    'Genus' = 'Jasus',
    'Species' = 'edwardsii',
    'Code' = 'Jasedw'
    )) |>

  write.table(sep="\t",
              file = "MasseySpeciesList.txt",
              quote = F,
              row.names = F)

# # Check names
# vnfb <- validate_names(tab$genusspecies, server = "fishbase")
#
# cbind(tab$genusspecies,
#       vnfb,
#       tab$genusspecies==vnfb), file = "outfish.csv")
