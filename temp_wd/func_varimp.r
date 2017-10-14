library(caret)
library(gbm)


#' Takes predictions from model object(s) and and combines it with actual values
#' This function takes a vector of strings that represent the model object names
#' @param model_object A model object from package 'caret' (test with GBM, should work for randomforest)
#' @param setDT Logical. TRUE to return a data.table object. FALSE will return a data.frame. Default is set to FALSE
#' @param sort_column Select the column by which to sort. Default column is the variable 'importance' measure
#' @param descending Logical.
#' @return varImp2() will return a data.frame (or data.table) with the variable name from the model and the computed variable importance
#' @export
#' @examples
#' library(predict2)
#' data(lm_data)
#' df_train = lm_data[1:25, ]
#' df_test = lm_data[26:50, ]
#' lm_int = lm(y ~ x, data = df_train)
#' lm_noint = lm(y ~ 0 + x, data = df_train)
#' list_lm = c('lm_int', 'lm_noint')
#'
#' predicted = predict2(
#'   model = list_lm,
#'   newdata = df_test,
#'   actual = df_test$y,
#'   pred_type = 'response',
#'   write_model = FALSE,
#'   write_pred = FALSE,
#'   csv_name = 'none'
#' )
#' head(predicted)

varImp2 <- function(model_object, setDT, sort_column, descending) {

  # default values for parameters
  if (missing(setDT)) {
    setDT = FALSE
  }

  if (missing(sort_column)) {
    param_sort = 'importance'
  }

  if (missing(descending)) {
    descending = TRUE
  }

  # don't forget to add option to set as data.table
  temp_varimp = varImp(gbm_object)$importance     # take gbm object and extract importance measure
  temp_varimp$variable = row.names(temp_varimp)   # varImp() assignes variables to row.names; create new column for variables
  temp_varimp = temp_varimp[, c(2, 1)]            # re-order columns: variable, importance; for appearance

  names(temp_varimp)[names(temp_varimp) %in% 'Overall'] = 'importance'  # rename column 'Overall' to 'importance'
  temp_varimp = temp_varimp[with(temp_varimp, order(get(param_sort), decreasing = descending)), ]              # sort importance values descending

  # reset row.names() for appearance in data.frame/data.table
  row.names(temp_varimp) = NULL # last to make sure row.name index is ascending for the final dataframe/data.table

  # if setDT is set to TRUE, convert dataframe to data.table
  if (setDT == TRUE) {
    setDT(temp_varimp)
  }

  return(temp_varimp)
}
