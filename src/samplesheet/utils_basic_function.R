
library(dplyr)

# Replace colname in df_base with dfref$target based on match between colname df1 with df_ref$Key.Sample, 

replace_colnames <- function(df_base, df_ref, match = 'Key.Sample', target = 'Sample_Name') {
  # Get original column names
  original_names <- colnames(df_base)
  
  # Find which column names in df_base match values in df_ref[[match]]
  matched_indices <- match(original_names, df_ref[[match]])
  
  # Replace matched column names with corresponding target values
  new_names <- original_names  # Start with the original names
  new_names[!is.na(matched_indices)] <- df_ref[[target]][matched_indices[!is.na(matched_indices)]]
  
  # Apply new names to df_base
  colnames(df_base) <- new_names
  
  print("Identical?")
  print(identical(colnames(df_base), df_ref[[match]]))
  
  return(df_base)
}

# Sort dataframe columns alphabetically
sort_column <- function(df) {
  sorted_cols <- sort(colnames(df))
  df_col_sorted <- df[, sorted_cols]
  return(df_col_sorted)
}

# sort row by rownames
sort_row_by_rownames <- function(df) {
  df_sorted <- df[order(rownames(df)), , drop = FALSE]
  return(df_sorted)
}


# Sort dataframe rows based on values in a specified column
sort_row <- function(df, col) {
  sorted_indices <- order(df[[col]])
  df_row_sorted <- df[sorted_indices, ]
  return(df_row_sorted)
}


# Check dimension is same for all df in a list
check_same_dim <- function(df_list, verbose = TRUE) {
  if (is.null(names(df_list))) {
    names(df_list) <- paste0("df_", seq_along(df_list))
  }
  
  dims <- lapply(df_list, dim)
  dim_strings <- sapply(dims, function(x) paste(x, collapse = "x"))
  dim_table <- split(names(df_list), dim_strings)
  
  all_same <- length(dim_table) == 1
  
  if (verbose) {
    cat("All dataframes have same dimensions? ", all_same, "\n")
    cat("Dimension counts and dataframe names:\n")
    for (dim_key in names(dim_table)) {
      cat(dim_key, " (", length(dim_table[[dim_key]]), "): ", 
          paste(dim_table[[dim_key]], collapse = ", "), "\n")
    }
  }
  
  invisible(all_same)
}


# check identical colnames rownames
check_dimnames_identical <- function(list_of_matrices) {
  # Extract rownames and colnames from all matrices
  rownames_list <- lapply(list_of_matrices, rownames)
  colnames_list <- lapply(list_of_matrices, colnames)
  
  # Check if all rownames are identical
  rows_identical <- all(sapply(rownames_list, function(x) identical(x, rownames_list[[1]])))
  
  # Check if all colnames are identical
  cols_identical <- all(sapply(colnames_list, function(x) identical(x, colnames_list[[1]])))
  
  # Print result
  if (rows_identical && cols_identical) {
    message("✅ All rownames and colnames are identical across matrices.")
  } else {
    message("❌ Not all rownames and/or colnames are identical.")
    if (!rows_identical) message("- Rownames differ.")
    if (!cols_identical) message("- Colnames differ.")
  }
  
  # Return logical summary
  return(list(rownames_identical = rows_identical,
              colnames_identical = cols_identical))
}
