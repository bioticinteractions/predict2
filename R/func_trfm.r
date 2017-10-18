#' Takes predictions from model object(s) and and combines it with actual values
#' This function takes a vector of strings that represent the model object names
#' trfm <- function(df_variable, missing, min, max, zero_value, transformation)
#' @param df_variable A vector that contains the original values that need to be transformed
#' @param missing The value that should replace any  missing values in the dataset
#' @param min The minimum value that a given variable should take; any value below the minimum will be set equal to the min value
#' @param max The maximum value that a given variable should take; any value above the maximum will be set equal to the max value
#' @param zero_value This is the value that any value of 0 should be.
#' @param transformation This is an integer value for corresponding to one of three transformation: 0 == no transformation, 1 == log(), 2 == sqrt()
#' @return trfm() will a vector of transformed values
#' @export
# @examples
# original SAS code:
# %macro trfm(var,md,min,max,zd,trfm);
# if &var = . then
# t&var = &md ;
# else t&var = &var;
#
# if t&var = 0 then
# t&var = &zd;
# else
#   t&var = t&var;
#
# t&var = min(max(t&var,&min),&max);
#
# if &trfm = 1 then do;
# if t&var le 0 then
# t&var = log(0.0001);
# else
#   t&var = log(t&var);
# end;
# if &trfm = 2 then do;
# t&var = sqrt(t&var);
# end;
# %mend trfm;

trfm <- function(df_variable, missing, min, max, zero_value, transformation){
  # function to transform columns based on parameters
  # missing value is applied to the vector after missing transformation is applied
  
  vec_new <- sapply(df_variable, function(x) ifelse(is.na(x) == T, missing, x))
  vec_new <- sapply(vec_new, function(x) ifelse(x == 0, zero_value, x))
  vec_new <- sapply(vec_new, function(x) min(max(min, x), max))
  
  if (transformation == 1) {
    vec_new_trans <- sapply(vec_new, function(x) ifelse(x <= 0, log(0.0001), log(x)))
  } else if (transformation == 2) {
    vec_new_trans <- sapply(vec_new, function(x) sqrt(x))
  } else {
    vec_new_trans <- vec_new
  }
  return(vec_new_trans)
}