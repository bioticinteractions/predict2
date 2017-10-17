#' Takes predictions from model object(s) and and combines it with actual values
#' This function takes a vector of strings that represent the model object names
#' @param model A vector of containing strings of the model object names
#' @param newdata A dataframe with input variables that predict2() will feed into the model
#' @param pred_type The type of predicted value predict will return: regression will return values; classification options:
#'   response prob, vote. Default is 'response' [see predict.randomForest for more information]
#' @param actual Vector of expected (or 'actual') data from the test dataset. Will be merged to
#'   the predicted data for easy export and subsequent comparison
#' @param append_cols Append additional columns to the predictions .csv.
#' @param write_model Logical. Whether to write the model fit objects to disk (as .data; one for each model). Default = FALSE
#' @param write_pred Logical. Whether to write the predictions to disk (as a .csv). Default = FALSE
#' @param csv_name String add to the fileneames of the data and prediction files (Default value
#'   = 'model'; model.data; model.csv)
#' @param dir Path location where the .csv and .data files will be written. Default is current working directory: getwd()
#' @param dir_data Specify location for data files if you want the data files to be in a separate file. Default is current working directory: getwd()
#' @param dir_csv Specify location for csv files if you want the data files to be in a separate file. Default is current working directory: getwd()
#'   working directory (i.e. getwd())
#' @return predict2() will return the results from predict() as a data.frame. each model object in 'model' will be one column in the dataframe.
#' @importFrom stats predict
#' @importFrom utils write.csv
#' @importFrom utils packageVersion
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
#'   append_cols = df_test,
#'   pred_type = 'response',
#'   write_model = FALSE,
#'   write_pred = FALSE,
#'   csv_name = 'none'
#' )
#' head(predicted)

predict2 <- function(model, newdata, actual, pred_type, append_cols, write_model, write_pred, csv_name, dir, dir_data, dir_csv) {

  # assign current working directory for default directory location
  current_wd = paste0(getwd(), '/')

  ###################################################
  # if statements to set parameters that are options
  ###################################################
  if (!is.vector(model)) {
    stop('list of models must be in the form of a vector')
  }
  if (missing(pred_type)) {
    pred_type = 'response'
  }
  if (missing(write_model)) {
    write_model = FALSE
  }
  if (missing(write_pred)) {
    write_pred = FALSE
  }
  if (missing(csv_name)) {
    timestamp_temp = format(Sys.time(), format = '%Y%m%d_%H%M%S')
    csv_name = paste0('model_', timestamp_temp)
  }
  if (missing(dir)) {
    dir = current_wd
  }
  if (missing(dir_data)) {
    dir_data = dir
  }
  if (missing(dir_csv)) {
    dir_csv = dir
  }

  ####################################
  # create predictions and dataframes
  ####################################
  # apply predict() on data
  pred_temp = lapply(model, function(x) predict(get(x), newdata = newdata, type = pred_type))
  
  # combine all predictions into dataframe
  pred_temp = as.data.frame(do.call(cbind, pred_temp))

  # change names of each model's prediction
  names(pred_temp) = paste0(model, '_predict')

  ###########################################################
  # append data: actual data and any other columns to append
  ###########################################################
  # append the 'actual' data
  if (!missing(actual)) {
    pred_temp$actual = actual
  }

  # append any other data
  if (!missing(append_cols)) {
    names_pt = names(pred_temp)
    pred_temp = cbind.data.frame(pred_temp, data.frame(append_cols))
    names(pred_temp) = c(names_pt, names(data.frame(append_cols)))
  }

  #######################
  # output files to disk
  #######################
  # write out model data file
  if (write_model == TRUE) {
    lapply(model, function(x) saveRDS(object = get(x), file = paste0(dir_data, x, '.data')))

    # for appearance sake
    if (length(model) == 1) {
      m_files = 'file is'
    } else {
      m_files = 'files are'
    }

    writeLines(paste0('The data ', m_files, ' located in: ')) # for appearance sake

    for (i in model) {
      writeLines(paste0(dir_data, i, '.data'))
    }
  }

  # write out predictions file as csv
  if (write_pred == TRUE) {
    filename = paste0(dir_csv, csv_name, '.csv') # file name from user
    write.csv(
      x = pred_temp,
      file = filename,
      row.names = FALSE
    )
    writeLines(paste0('\nThe .csv file is located in \'', filename, '\'\n')) # prints out the location of the *.csv at the end of the function
  }

  # output the predictions as a dataframe
  return(pred_temp)
}
