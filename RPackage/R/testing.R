find_file_by_traversing <- function(start_dir = getwd(), file_to_find = "dcat-ap.rdf") {
  current_dir <- normalizePath(start_dir)
  
  while (!file.exists(file.path(current_dir, file_to_find))) {
    parent_dir <- normalizePath(file.path(current_dir, ".."))
    
    # Check if we've reached the root directory
    if (current_dir == parent_dir) {
      return(NULL)  # File not found
    }
    
    current_dir <- parent_dir
  }
  
  return(file.path(current_dir, file_to_find))  # File found
}

#' Get the dcat_ap_rdf modified date
#' 
get_dcat_ap_rdf_modified_date <- function(){
  fp <- find_file_by_traversing(file_to_find = "dcat-ap.rdf")
  if(is.null(fp)) stop("Cant find 'dcat-ap.rdf'")
  x <- readLines(fp)
  slot <- x[grepl("dcterms:modified", x = x)]
  # Regular expression to match dates in the format YYYY-MM-DD
  date_pattern <- "\\b\\d{4}-\\d{2}-\\d{2}\\b"
  as.Date(regmatches(slot, gregexpr(date_pattern, slot))[[1]])
}
