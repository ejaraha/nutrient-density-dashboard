check_empty <- function(df){
  df <- data.frame("any_nas" = apply(df, 2, function(df) any(is.na(df))),
             "any_empty_character_vectors" = apply(df, 2, function(df) any(df == ""))) 
  return(df)
}

check_empty_glimpse <- function(df){
  print(deparse(substitute(df)))
  glimpse(df)
  check_empty(df)
}