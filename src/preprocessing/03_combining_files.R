library(readr)
library(dplyr)

setwd("D:/Dojo_Prostate/PRAD_PROJECT/DATASET")
getwd()

library(dplyr)

dataset_dir <- "D:/Dojo_Prostate/PRAD_PROJECT/DATASET"
filespath <- list.files(path = dataset_dir, pattern = "\\.tsv$", recursive = TRUE, full.names = TRUE)

# Initialize empty data frame
combined_df <- NULL

i = 0
for (file in filespath) {
  df <- read.delim(file, comment.char = "#") %>%  # Ignore comment lines
    select(gene_id, stranded_first)
  
  # Rename the stranded_first column based on filename
  colname <- gsub(".tsv$", "", basename(file))  
  names(df)[2] <- colname  
  
  # Merge with combined_df
  if (is.null(combined_df)) {
    combined_df <- df  
  } else {
    combined_df <- full_join(combined_df, df, by = "gene_id")  
  }
  i <- i + 1
  print(paste(i," Successfully combined:", file))
}

head(combined_df)



library(dplyr)
library(purrr)

dataset_dir <- "D:/Dojo_Prostate/PRAD_PROJECT/DATASET"
filespath <- list.files(path = dataset_dir, pattern = "\\.tsv$", recursive = TRUE, full.names = TRUE)

# Read all files and merge in one step
combined_df <- filespath %>%
  set_names(nm = gsub(".tsv$", "", basename(.))) %>%  # Set filenames as column names
  map_dfc(~ read.delim(.x, comment.char = "#") %>%
            select(gene_id, stranded_first) %>%
            rename_with(~ gsub(".tsv$", "", basename(.x)), stranded_first)) %>%
  reduce(full_join, by = "gene_id")

print("All files successfully combined!")
head(combined_df)


