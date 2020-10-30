check_empty <- function(df){
  #checks every column in df for NAs and ""
  df <- data.frame("any_nas" = apply(df, 2, function(df) any(is.na(df))),
             "any_empty_character_vectors" = apply(df, 2, function(df) any(df == ""))) 
  return(df)
}

check_empty_glimpse <- function(df){
  #print name of df, preview data, check NAs and ""
  print(deparse(substitute(df)))
  glimpse(df)
  check_empty(df)
}