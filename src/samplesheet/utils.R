library(dplyr)

## REMOVE AFTER COMMA
remove_after_comma <- function(df) {
  df[] <- lapply(df, function(col) {
    if (is.character(col)) {
      sub(",.*", "", col)
    } else {
      col
    }
  })
  return(df)
}

## SPLIT
split_column <- function(df, col, order = 1) {
  # Use [[col]] to access column by name, not literally "col"
  df[[col]] <- sapply(strsplit(df[[col]], "_"), function(x) {
    if (length(x) >= order) x[order] else NA
  })
  return(df)
}

# GIVE NUMBERING FOR DUPLICATED SAMPLE_NAME

numbering_duplicate <- function(df, col) {
  vals <- df[[col]]
  counts <- ave(vals, vals, FUN = seq_along)
  df[[col]] <- ifelse(duplicated(vals) | duplicated(vals, fromLast = TRUE),
                      paste0(vals, "_", counts),
                      vals)
  return(df)
}

# Read JSON

read_json <- function(filename){
  json <- fromJSON(filename)
  json <- as.data.frame(flatten(json))
}

# Extract annotation from JSON
extract_from_annotations <- function(annotation_list, field) {
  sapply(annotation_list, function(x) {
    if (is.null(x)) {
      return(NA)
    } else if (is.data.frame(x) && field %in% colnames(x)) {
      return(x[[field]][1])  # Use first row if multiple rows
    } else {
      return(NA)
    }
  })
}

# Extract nnotation from json to df
add_annotation_fields <- function(metadata_df, annotation_list, fields) {
  for (field in fields) {
    metadata_df[[field]] <- extract_from_annotations(annotation_list, field)
  }
  return(metadata_df)
}

# CBIND FUNCTION
cbind_function <- function(base, reference, key, target){
  cbind_df <- merge(
    base,
    reference[, c(key, target)],
    by = key,
    all.x = TRUE)
  return(cbind_df)
  
}

# Value Counts
value_count <- function(df, cols) {
  result <- list()
  
  for (col in cols) {
    counts <- table(df[[col]], useNA = "ifany")
    result[[col]] <- as.data.frame(counts)
    names(result[[col]]) <- c("Value", "Count")
  }
  
  print(result)
}

set2na <- function(data){
  data[data == "[Not Available]" | 
         data == "[Not Applicable]" |
         data == "[Not Evaluated]" | 
         data == "[Unknown]" |
         data == "Unknown" |
         data == "'--" |
         data == "[Discrepancy]" |
         data == "not reported" |
         data == "other" |
         data == "MX" |
         data == "NX" |
         data == "TX" |
         data == "RX" |
         data == "GX" |
         data == "Not Reported" ]<- NA
  return(data)
}


# cbind all
cbind_by_id <- function(dfbase, dfref, id_col = "ID") {
  dfref_aligned <- dfbase %>%
    select(!!sym(id_col)) %>%
    left_join(dfref, by = id_col) %>%
    select(-!!sym(id_col))  # drop ID to avoid duplication in cbind
  
  bind_cols(dfbase, dfref_aligned)
}

# drop col with NA
drop_cols_na <- function(df, NAcutoff = 0.5) {
  # Check proportion of NA in each column
  na_proportion <- colMeans(is.na(df))
  
  # Keep only columns with NA proportion <= NAcutoff
  df[, na_proportion <= NAcutoff, drop = FALSE]
}


# rbind
rbind_to_reference <- function(df1, df2) {
  # Identify missing columns in df2
  missing_cols <- setdiff(names(df1), names(df2))
  
  # Add missing columns with NA
  for (col in missing_cols) {
    df2[[col]] <- NA
  }
  
  # Drop extra columns in df2 not in df1
  df2 <- df2[, names(df1), drop = FALSE]
  
  # Bind rows
  rbind(df1, df2)
}

