#' Takes predictions from model object(s) and and combines it with actual values
#' This function takes a vector of strings that represent the model object names
#' @param trfm_df The dataframe or datatable that contains the information for the transformations (i.e. values for the trfm() function)
#' @param data_df The dataframe or datatable that contains the data that needs to be transformed
#' @param variable_col The name of the column that holds the variable names for which the data need to be transformed. Default is 'variable'
#' @param min_col The name of the column that holds the minimum values for the trfm() function. Default is 'min'
#' @param max_col The name of the column that holds the maximum values for the trfm() function. Default is 'max'
#' @param zero_value_col The name of the column that holds the zero-value for the trfm() function. Default is 'zero_value'
#' @param missing_col The name of the column that holds the missing value for the trfm() function. Default is 'missing'
#' @param transformation_col The name of the column that holds the transformation indicator. Default is 'transformation'. Key: 0 = no transformation; 1 = log(); 2 = sqrt()
#' @param keep_col The name of the column that holds the 'y' or 'n' to keep a certain variable. Default is 'keep'
#' @return trfm_auto() return a dataframe of the original data and the appended transformed data using trfm() and the parameters provided
#' @export

trfm_auto = function(trfm_df, data_df, variable_col, min_col, max_col, zero_value_col, missing_col, transformation_col, keep_col) {

  # optional arguments, default values set as to what dan typically uses
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
  # testing ################################################
  ##########################################################
  # library(data.table)
  # trfm_df = fread('temp_wd/ranks_plots_variables_pet.csv')
  # data_df = fread('temp_wd/pet_trfm_sas_cust_trfm.csv')
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
  trfm_df = subset(trfm_df, keep %in% c('y', 1), select = list_var_cols) # using subset so that it can accommodate both datatable and dataframes
  # trfm_df = subset(trfm_df, keep %in% c('y', 1), select = c(variable_col, min_col, max_col, zero_value_col, missing_col, transformation_col, keep_col)) # using subset so that it can accommodate both datatable and dataframes

  # assign data for each item in list_var_cols
  for (i in list_var_cols){
    pasted_name = paste0('data_', i)
    assign(paste0(pasted_name), trfm_df[[i]])
  } # for i loop

  data_variable_trfm = paste0(data_variable, '_trfm') # 'data_variable' is a reference to the variable column

  list_vec = vector('list', length = length(data_variable))

  # use trfm() for each of the variables
  for (k in 1:length(data_variable)) {
    # k = 11    # assign for testing purposes

    v_variable = data_variable[k]                             # assign variable name k
    v_variable_trfm = data_variable_trfm[k]                   # create '_trfm" variable name
    v_missing = as.numeric(data_missing[k])                   # assign missing value
    v_min = as.numeric(data_min[k])                           # assign minimum value
    v_max = as.numeric(data_max[k])                           # assign maximum value
    v_zero = as.numeric(data_zero_value[k])                   # assign zero value
    v_transformation = as.numeric(data_transformation[k])     # assign transformation
    v_data_df = subset(data_df, select = v_variable)          # subset specific column
    # v_data_df = as.data.frame(subset(data_df, select = v_variable))   # subset specific column

    # create individual vectors that contain transformed data
    # assign to name variable name appended with '_trfm'
    assign(
      paste0(v_variable_trfm),                               # object name to assign
      trfm(                                                  # apply transformation
        df_variable = v_data_df,
        missing = v_missing,
        min = v_min,
        max = v_max,
        zero_value = v_zero,
        transformation = v_transformation
      )
    )

    # list_vec[[k]] = trfm(                                     # apply transformation
    #   df_variable = v_data_df,
    #   missing = v_missing,
    #   min = v_min,
    #   max = v_max,
    #   zero_value = v_zero,
    #   transformation = v_transformation
    # )

    writeLines(paste0('Variable transformed: ', v_variable_trfm))

  } # for k loop

  temp_df = as.data.frame(sapply(data_variable_trfm, function(x) get(paste0(x))))
  # temp_df = do.call(cbind.data.frame, list_vec)

  names(temp_df) = data_variable_trfm
  return(temp_df)
} # for function

# trfm_auto = trfm_func(trfm_df = var_dt, data_df = grocery)
