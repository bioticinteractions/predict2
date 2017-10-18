#' Takes predictions from model object(s) and and combines it with actual values
#' This function takes a vector of strings that represent the model object names
#' @param generic_df The dataframe or datatable from which to get summarized information
#' @return summary_check() This function will return the following moments for numeric columns of the data specified:
#'   mean, media, NA count, total rows, ratio of NA to total rows
#' @importFrom stats median
#' @export

summary_check = function(generic_df){
  col_numeric = lapply(generic_df, is.numeric)
  col_n_d = do.call(rbind, col_numeric)
  var_col_list = row.names(col_n_d)
  col_n_d = cbind.data.frame(var_col_list, col_n_d)
  col_n_d$var_col_list = as.character(col_n_d$var_col_list)
  row.names(col_n_d) = NULL
  col_n_d = col_n_d$var_col_list[col_n_d$col_n_d == T]

  # create summary df to run diagnostics
  summary_df = subset(generic_df, select = col_n_d)

  sum_mean = sapply(summary_df, FUN = function(x) mean(x, na.rm = T))
  sum_median = sapply(summary_df, FUN = function(x) stats::median(x, na.rm = T))
  sum_na = sapply(summary_df, FUN = function(x) sum(is.na(x)))
  sum_row = sapply(summary_df, FUN = function(x) length(x))

  sum_bind = cbind.data.frame(
    sum_mean,
    sum_median,
    sum_na,
    sum_row
  )
  sum_bind_names = row.names(sum_bind)
  sum_bind = cbind.data.frame(sum_bind_names, sum_bind)
  sum_bind$na_ratio = with(sum_bind, sum_na / sum_row)
  row.names(sum_bind) = NULL
  names(sum_bind) = c(
    'column',
    'mean',
    'median',
    'count_na',
    'total_rows',
    'na_ratio'
  )
  sum_bind$column = as.character(sum_bind$column)
  return(sum_bind)
}
