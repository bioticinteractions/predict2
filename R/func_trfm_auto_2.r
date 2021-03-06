#' Takes predictions from model object(s) and and combines it with actual values
#' This function takes a vector of strings that represent the model object names
#' @param trfm_df The dataframe or datatable that contains the information for the transformations (i.e. values 
#'   for the trfm() function)
#' @param data_df The dataframe or datatable that contains the data that needs to be transformed
#' @param variable_col The name of the column that holds the variable names for which the data need to be transformed. 
#'   Default is 'variable'
#' @param min_col The name of the column that holds the minimum values for the trfm() function. Default is 'min'
#' @param max_col The name of the column that holds the maximum values for the trfm() function. Default is 'max'
#' @param zero_value_col The name of the column that holds the zero-value for the trfm() function. Default is 'zero_value'
#' @param missing_col The name of the column that holds the missing value for the trfm() function. Default is 'missing'
#' @param transformation_col The name of the column that holds the transformation indicator. Default is 'transformation'. 
#'   Key: 0 = no transformation; 1 = log(); 2 = sqrt()
#' @param keep_col The name of the column that holds the 'y' or 'n' to keep a certain variable. Default is 'keep'
#' @return trfm_auto() return a dataframe of the original data and the appended transformed data using trfm() and 
#'   the parameters provided
#' @export
#' @examples
#' library(predict2)
#' data(trfm_data)
#' data(data_raw)
#' trfm_example = trfm_auto(trfm_df = trfm_data, data_df = data_raw)

trfm_auto = function( trfm_df, data_df, variable_col, min_col, max_col, 
                      zero_value_col, missing_col, transformation_col, keep_col) {
  # optional argumments, if missing, default values assigned
	if (missing(variable_col)) {
    variable_col = 'variable'
  }
  if (missing(min_col)) {
    min_col = 'min'
  }
  if (missing(max_col)) {
    max_col = 'max'
  }
  if (missing(zero_value_col)) {
    zero_value_col = 'zero_value'
  }
  if (missing(missing_col)) {
    missing_col = 'missing'
  }
  if (missing(transformation_col)) {
    transformation_col = 'transformation'
  }
  if (missing(keep_col)) {
    keep_col = 'keep'
  }
  
  ##########################################################
  # debugging ##############################################
  ##########################################################
  # library(data.table)
  # data_df = fread('temp_wd/pet_trfm_sas_cust_trfm.csv')
  # data_df = data_df[1, drop = F]
  # trfm_df = fread('temp_wd/ranks_plots_variables_pet.csv')
  # 
  # variable_col = 'variable'
  # min_col = 'min'
  # max_col = 'max'
  # zero_value_col = 'zero_value'
  # missing_col = 'missing'
  # transformation_col = 'transformation'
  # keep_col = 'keep'
  ##########################################################

  # create vectors for columns needed in trfm()
  # the vector is purposely a list of objects rather than strings
  list_var_cols = c(
    variable_col,
    min_col,
    max_col,
    zero_value_col,
    missing_col,
    transformation_col,
    keep_col
  )

  # subset transformation data, only keep those with keep == 'yes'
  # using 'subset' so that it can accommodate both datatable and dataframes
  trfm_df = subset(trfm_df, eval(parse(text = keep_col)) %in% c('y', 1), select = list_var_cols)

  # assign data for each item in list_var_cols
  # for (i in list_var_cols){
  #   pasted_name = paste0('data_', i)
  #   assign(paste0(pasted_name), trfm_df[[i]])
  #   # print(pasted_name) # for debugging
  # } # for i loop
  
  # get rid of global variable notes in devtools::check()
  data_variable <- trfm_df[[variable_col]]
  data_variable_trfm <- paste0(data_variable)
  data_missing <- trfm_df[[missing_col]]
  data_min <- trfm_df[[min_col]]
  data_max <- trfm_df[[max_col]]
  data_zero_value <- trfm_df[[zero_value_col]]
  data_transformation <- trfm_df[[transformation_col]]
  
  # 'data_variable' is a reference to the variable column
  # originally wanted to have fixed custom column names (.*_trfm)
  # data_variable_trfm = paste0(data_variable)

  list_vec = vector('list', length = length(data_variable))

  # use trfm() for each of the variables
  for (k in 1:length(data_variable)) {
    # k = 11    # assign for testing purposes

    v_variable = data_variable[k]                             # assign variable name k
    v_variable_trfm = data_variable_trfm[k]                   # create '_trfm' variable name
    v_missing = as.numeric(data_missing[k])                   # assign missing value
    v_min = as.numeric(data_min[k])                           # assign minimum value
    v_max = as.numeric(data_max[k])                           # assign maximum value
    v_zero = as.numeric(data_zero_value[k])                   # assign zero value
    v_transformation = as.numeric(data_transformation[k])     # assign transformation
    v_data_df = subset(data_df, select = c(v_variable))       # subset specific column

    # trfm <- function(df_variable, missing, min, max, zero_value, transformation){
    #   # function to transform columns based on parameters
    #   # missing value is applied to the vector after missing transformation is applied
    # 
    #   vec_new <- sapply(df_variable, function(x) ifelse(is.na(x) == T, missing, x))
    #   vec_new <- sapply(vec_new, function(x) ifelse(x == 0, zero_value, x))
    #   vec_new <- sapply(vec_new, function(x) min(max(min, x), max))
    # 
    #   if (transformation == 1) {
    #     vec_new_trans <- sapply(vec_new, function(x) ifelse(x <= 0, log(0.0001), log(x)))
    #   } else if (transformation == 2) {
    #     vec_new_trans <- sapply(vec_new, function(x) sqrt(x))
    #   } else {
    #     vec_new_trans <- vec_new
    #   }
    #   return(vec_new_trans)
    # }

    # call transformation function
    temp_trfm_df = predict2::trfm(
        df_variable = v_data_df,
        missing = v_missing,
        min = v_min,
        max = v_max,
        zero_value = v_zero,
        transformation = v_transformation
      )

    # assign transformed dataframe to variable name
    assign(paste0(v_variable_trfm), temp_trfm_df)

    # print out the column transformed
    writeLines(paste0('Variable transformed: ', v_variable_trfm))

  } # for k loop

  # get dataframe object from vector containing object names, then combine into dataframe
  #temp_df = as.data.frame(sapply(data_variable_trfm, function(x) get(paste0(x))))
  temp_df = sapply(data_variable_trfm, function(x) get(paste0(x)))
  temp_df = rbind.data.frame(temp_df)
  names(temp_df) = data_variable_trfm
  
  return(temp_df)
} # for function
